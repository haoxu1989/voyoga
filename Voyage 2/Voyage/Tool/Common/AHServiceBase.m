//
//  ServiceBase.m
//  CarPrice
//
//  Created by 王俊 on 13-10-30.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import "AHServiceBase.h"
#import "AFJSONRequestOperation.h"
#import "PlistDataManager.h"
#import "AHNetConsts.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonDigest.h>
#import "JSONKit.h"

@implementation AHServiceBase

//分发出错信息给委托
- (void)notifyNetServiceError:(enum AHServiceHandle)currentHandle
                    errorCode:(int)errorCode
                 errorMessage:(NSString *)errorMessage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(netServiceError:errorCode:errorMessage:)])
    {
        //把错误传递出去
        if (errorMessage == nil|| [errorMessage isKindOfClass:[NSNull class]]|| errorMessage.length == 0)
        {
            [self.delegate netServiceError:currentHandle errorCode:errorCode errorMessage:UNKNOWN_ERROR];
        }
        else
        {
            [self.delegate netServiceError:currentHandle errorCode:errorCode errorMessage:errorMessage];
        }
    }
    //显示提示
    if (self.isShowNetHint)
    {
        if (errorMessage == nil || errorMessage.length == 0)
        {
            [self showHintView:UNKNOWN_ERROR];
        }
        else
        {
            [self showHintView:self.message];
        }
    }
}

-(NSString *)md5Value:(NSString*)value
{
    const char *original_str = [value UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}


- (void)updateCache
{
    
}

//显示提示信息
- (void)showHintView:(NSString *)message
{
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window showDownMessage:message withDelay:1.0];
}

+ (id)sharedServiceBase
{
    AHServiceBase *client = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:API_DOMAIN]];
    client.isAddCache=NO;
    client.isShowNetHint=YES;
    return client;
}

+ (id)sharedServiceBaseWithUrlString:(NSString *)urlString
{
    AHServiceBase *client = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    client.isAddCache=NO;
    client.isShowNetHint=YES;
    return client;
}


- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    return YES;
}


#pragma mark – 网络返回处理

- (void)success:(AFHTTPRequestOperation *)operation responseObject:(id) responseObject
{
    @try {
        self.message =NETPARSER_BAD;
        //        NSLog(@"%@",operation.responseString);
        if (responseObject == nil)
        {
            //如果不是一个有效的json数据，则认为是出错了
            [self notifyNetServiceError:_handle errorCode:-1 errorMessage:NETPARSER_BAD];
            return;
        }
        
        //NSString *message = [responseObject objectForKey:@"message"];
//        NSLog(@"  log message : %@ ",message);
        NSLog(@"%@",operation.responseString);
        if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceFinished:WithString:)] && _handle == EGetOrderService)
        {
            [self.delegate netServiceFinished:_handle WithString:operation.responseString];
        }
        responseObject = [operation.responseString objectFromJSONString];
        id result = [responseObject objectForKey:@"result"];
        if ([result isKindOfClass:[NSString class]]) {
            self.message =result;
        }
        
//        NSString *successFlag = [responseObject valueForKey:@"status"];
//        if ([successFlag isEqualToString:@"ok"])
//        {
//            [self notifyNetServiceError:_handle errorCode:0 errorMessage:[responseObject valueForKey:@"message"]];
//            return;
//        }
        if ([self parseJSON:responseObject])
        {
            if (self.isAddCache)
            {
                PlistDataManager *plistDataManager=[PlistDataManager sharedPlistDataManager];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @autoreleasepool{
                        [self updateCache];
                        if (responseObject) {
                            //添加缓存
                            [plistDataManager setCacheData:CACHEPLISTNAME data:responseObject cacheKey:self.cacheKey];
                        }
                    }
                });
            }
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceFinished:)])
            {
                [self.delegate netServiceFinished:_handle];
            }
        }
        else
        {
            [self notifyNetServiceError:_handle errorCode:1 errorMessage:NETPARSER_BAD];
        }
    }
    @catch (NSException *exception)
    {
        //解析出错，把错误传递出去
        [self notifyNetServiceError:_handle errorCode:-1 errorMessage:NETPARSER_BAD];
    }
}

- (void)failure:(AFHTTPRequestOperation *)operation error:(NSError*) error
{
    
    [self notifyNetServiceError:_handle errorCode:[error code] errorMessage:NETWORK_BAD];
}


#pragma mark – GET请求

- (void)getData:(NSString *)url parameters:(NSDictionary *)parameters
{
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceStarted:)])
    {
        [self.delegate netServiceStarted:_handle];
    }
    [self getPath:url
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self success:operation responseObject:responseObject];
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self failure:operation error:error];
     }
     ];
}


- (void)getData:(NSString *)url parameters:(NSDictionary *)parameters queryFromCache:(BOOL)isQueryFromCache
{
    PlistDataManager *plistDataManager=[PlistDataManager sharedPlistDataManager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        if (self.isAddCache)
        {
            [plistDataManager getCacheData:CACHEPLISTNAME cacheKey:self.cacheKey
                                   success:^(id cacheData)
             {
                 if ([cacheData isKindOfClass:[NSDictionary class]])
                 {
                     if ([self parseJSON:cacheData])
                     {
                         if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceCacheFinished:)])
                         {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self.delegate netServiceCacheFinished:_handle];
                             });
                         }
                     }
                 }
             }
             ];
        }
        if (isQueryFromCache)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getData:url parameters:parameters];
            });
        }
    });
}


#pragma mark – POST提交

- (void)sendPost:(NSString *)postUrl parameters:(NSDictionary *)parameters ImageArray:(NSMutableArray *)imageArray
{
    if (parameters) {
        [parameters setValue:@"2B9FED25FDA45CEA" forKey:@"hashsource"];
        [parameters setValue:@"99998" forKey:@"agentno"];
        [parameters setValue:[self md5Value:@"999982B9FED25FDA45CEA"] forKey:@"sign" ];
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
//    [self setDefaultHeader:@"Accept" value:@"application/json"];
    if(self.delegate && [self.delegate respondsToSelector:@selector(netServiceStarted:)])
    {
        [self.delegate netServiceStarted:_handle];
    }
    [self postPath:postUrl
        parameters:parameters
           success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self success:operation responseObject:responseObject];
     }
           failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self failure:operation error:error];
     }
     ];
}



@end
