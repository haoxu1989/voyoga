//
//  System.m
//  Usedcar
//
//  Created by 南晓斌 on 11-7-10.
//  Copyright 2011 autohome. All rights reserved.
//

#import "System.h"
#include "sys/stat.h"
#include <dirent.h>
#import <AVFoundation/AVFoundation.h>

@implementation System
static int isChecked;

+ (void) alertView:(UIAlertView *)alertview
clickedButtonAtIndex:(NSInteger)buttonIndex{
    isChecked=1;
}

+ (BOOL) checkNetwork{
	if (![System connectedToNetwork]) {
        if(isChecked!=1){
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"系统信息"
															 message:@"程序需要链接外部网络。请检查网络设置。" 
															delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		
		[alertView show];
        }
		return NO;
	}
	
	return YES;
}

+ (BOOL) checkNetworConnectedByWifi{ 
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        //printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    
    //'yes' means the network is connected by wifi. 

    
    bool isConnectedbyWifi = ( (flags & kSCNetworkReachabilityFlagsIsWWAN) ==0);
    return (isReachable && !needsConnection && isConnectedbyWifi) ? YES : NO;
} 


+ (BOOL) checkNetworConnectedByGprs{ 
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        //printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);    
    bool isConnectedbyWifi = ( (flags & kSCNetworkReachabilityFlagsIsWWAN) ==0);
    return (isReachable && !needsConnection && !isConnectedbyWifi) ? YES : NO;
} 


+ (BOOL) connectedToNetwork{ 
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        //printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
} 

+ (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                }
            }];
        }
    }
    return bCanRecord;
}

+ (NSString *) getDocumentDirectory{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)EncodeGB2312StrToGB18030:(NSString *)encodeStr{
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *afterEnc=[encodeStr stringByAddingPercentEscapesUsingEncoding:enc];
    return afterEnc;
}

+ (NSString *)EncodeGB2312Str:(NSString *)encodeStr{
    
	CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
	NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeStr, CFSTR(""), kCFStringEncodingGB_18030_2000));
    
    //对nonAlphaNumValidChars特殊字符进行编码
    //kCFStringEncodingGB_18030_2000编码方式，采用多字节编码，每个字可以由1个、2个或4个字节组成
    //号称与GB 2312-1980完全兼容，与GBK基本兼容
	NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000));
    
    //￥对应的GB_18030_2000编码为%81%30%84%36
    //￥对应的GB2312编码为%A3%A4
    //服务器采用GB２３１２编码，提交上去后成问号，暂时先临时替换处理，以后再想办法解决
    newStr=[newStr stringByReplacingOccurrencesOfString:@"%81%30%84%36" withString:@"%A3%A4"];//￥
    newStr=[newStr stringByReplacingOccurrencesOfString:@"%81%30%84%35" withString:@"%A1%EA"];//￡
    newStr=[newStr stringByReplacingOccurrencesOfString:@"%A2%E3" withString:@"&#8364"];//€
    newStr=[newStr stringByReplacingOccurrencesOfString:@"%81%36%A6%31" withString:@"%26%238226%3B"];//•
    return newStr;
}

+(NSURL *)appendUrl:(NSURL *)postUrl
{
	NSString * strUrl=[NSString stringWithFormat:@"%@",postUrl];
//	NSString * statisticInfo=[self EncodeGB2312Str:[self getStatisticsInfo]];
//	if ([strUrl rangeOfString:@"?"].length>0) {
//		strUrl=[NSString stringWithFormat:@"%@&sj=%@",strUrl,statisticInfo];
//	}else {
//		strUrl=[NSString stringWithFormat:@"%@?sj=%@",strUrl,statisticInfo];
//	}
	postUrl=[NSURL URLWithString:strUrl];
	return postUrl;
}

+(NSString *)getStatisticsInfo
{
	NSString * jsonStatistics;
	NSInteger strPid=0;
	NSString * strPv=@"0";
	NSString * strDt=@"0";
	NSString * strDid=@"0";
	NSString * strPf=@"0";
	NSString * strSid=@"0";
	NSString * strSv=@"0";
	NSInteger  strRw=0;
	NSInteger  strRh=0;
	NSString * strNt=@"0";
	NSString * strIp=@"0";
	NSString * strSp=@"0";
	NSString * strLo=@"0";
	NSString * strLa=@"0";
	NSString * strP=@"0";
	NSString * strC=@"0";
    NSString * strUID=@"";
    NSString * strUN=@"";
	NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
	
	if ([[userDefaults objectForKey:@"STATISTICS_NT"] length]>0) {
		strNt=[userDefaults objectForKey:@"STATISTICS_NT"];
	}
    strIp=@"";
		strSp=@"0";	
	jsonStatistics=[NSString stringWithFormat:@"{\"PID\":%d,\"PV\":\"%@\",\"DT\":\"%@\",\"DID\":\"%@\",\"PF\":%@,\"SID\":%@,\"SV\":\"%@\",\"RW\":%d,\"RH\":%d,\"NT\":\"%@\",\"IP\":\"%@\",\"P\":\"%@\",\"C\":\"%@\",\"SP\":%@,\"LO\":%@,\"LA\":%@,\"UID\":\"%@\",\"UN\":\"%@\"}"
					,strPid
					,strPv
					,strDt
					,strDid
					,strPf
					,strSid
					,strSv
					,strRw
					,strRh
					,strNt
					,strIp
					,strP
					,strC
					,strSp
					,strLo
					,strLa
                    ,strUID
                    ,strUN];
	[userDefaults setObject:jsonStatistics forKey:@"STATISTICS_AllInfo"];
	return jsonStatistics;
}

+(long long)fileSize:(NSString *)filePath{
    struct stat st;
    if (lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0) {
        return st.st_size;
    }
    return 0;
}

+(long long)folderSize:(NSString *) afolderPath{
    const char* folderPath = [afolderPath cStringUsingEncoding:NSUTF8StringEncoding];
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) {
        return 0;
    }
    struct dirent* child;
    while ((child = readdir(dir)) != NULL) {
        if (child->d_type == DT_DIR
            && (child->d_name[0] == '.' && child->d_name[1] == 0)) {
            continue;
        }
        
        if (child->d_type == DT_DIR
            && (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0)) {
            continue;
        }
        
        int folderPathLength = strlen(folderPath);
        char childPath[1024];
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength - 1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        
        stpcpy(childPath + folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){
            NSString* child = [NSString stringWithCString:childPath encoding:NSUTF8StringEncoding];
            folderSize += [self folderSize:child];
            struct stat st;
            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        } else if (child->d_type == DT_REG || child->d_type == DT_LNK){
            struct stat st;
            if (lstat(childPath, &st) == 0) {
                folderSize += st.st_size;
            }
        }
    }
    
    return folderSize;
}

+ (CGRect)getApplicationRect
{
    return [[UIScreen mainScreen]applicationFrame];
}

+ (CGFloat)getApplicationWidth
{
    int width = 0;
    width = CGRectGetWidth([[UIScreen mainScreen] applicationFrame]);
    return width;
}

+ (CGFloat)getApplicationHeight
{
    int height = 0;
    height = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]);
    return height;
}

+ (CGFloat)getScreenWidth
{
    CGFloat width = 0.0;
    width = CGRectGetWidth([[UIScreen mainScreen] applicationFrame]);
    return width;
}

+ (CGFloat)getScreenHeight
{
    CGFloat height = 0.0;
    height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    return height;
}

+ (UIWindow*) MainWindow
{
    return [[UIApplication sharedApplication] delegate].window;;
}

+ (BOOL)isPushNotifiOn
{
    int pushType = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if(pushType == UIRemoteNotificationTypeNone){
        return NO;
    }
    return YES;
}

// 适配
+ (BOOL)isLongIOS6L
{
    if (kSystemVersion < 7.0 && [System getScreenHeight] >= 568.0)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLongIOS7U
{
    if (kSystemVersion >= 7.0 && [System getScreenHeight] >= 568.0)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isShortIOS6L
{
    if (kSystemVersion < 7.0 && [System getScreenHeight] <= 480.0)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isShortIOS7U
{
    if (kSystemVersion >= 7.0 && [System getScreenHeight] <= 480.0)
    {
        return YES;
    }
    
    return NO;
}
@end
