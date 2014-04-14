//
//  ServiceBase.h
//  CarPrice
//  网络操作类
//  Created by 王俊 on 13-10-30.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AHNetConsts.h"
#import "AHServiceDelegate.h"

@interface AHServiceBase : AFHTTPClient

/**
 *  网络回调
 */
@property (weak,nonatomic) id<AHServiceDelegate> delegate;
/*!
 @property
 @abstract 网络请求服务的标识
 */
@property(nonatomic, assign) enum AHServiceHandle handle;
/*!
 @property
 @abstract 是否添加Cache
 */
@property (nonatomic, assign) BOOL isAddCache;
/*!
 @property
 @abstract 要缓存时，缓存的key
 */
@property (nonatomic, strong) NSString *cacheKey;
/*!
 @property
 @abstract 当出错时是否显示提示信息，默认是显示
 */
@property (nonatomic, assign) BOOL isShowNetHint;

@property (strong, nonatomic) NSString *message;
/*!
 @method
 @abstract   发送get请求
 @discussion 发送get请求
 @param      postUrl 数据地址
 @result     返回结果 nil
 */
- (void)getData:(NSString *)url parameters:(NSDictionary *)parameters;
/*!
 @method
 @abstract   发送get请求
 @discussion 发送get请求
 @param      postUrl 数据地址
 @param      isQueryFromCache 是否取缓存
 @result     返回结果 nil
 */
- (void)getData:(NSString *)url parameters:(NSDictionary *)parameters queryFromCache:(BOOL)isQueryFromCache;

/*!
 @method
 @abstract   发送post请求
 @discussion 发送post请求
 @param      postUrl post数据地址
 @param      dic 发送的字典数据
 @param      imageArray 图片数组
 */
- (void)sendPost:(NSString *)postUrl parameters:(NSDictionary *)parameters ImageArray:(NSMutableArray *)imageArray;

/*!
 @method
 @abstract   解析json
 @discussion 解析json
 @param      strJSON 返回的json数据
 @result     返回结果 nil
 */

-(BOOL)parseJSON:(NSDictionary*)jsonModel;

/**
 *  初始化serviceBase
 *
 *  @return serviceBase单例对象
 */
+ (id)sharedServiceBase;

/**
 *  用不同的urlString 初始化serviceBase
 *
 *  @return serviceBase对象
 */
+ (id)sharedServiceBaseWithUrlString:(NSString *)urlString;


- (void)updateCache;

-(NSString *)md5Value:(NSString*)value;

@end
