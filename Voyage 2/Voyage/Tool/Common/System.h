//
//  System.h
//  Usedcar
//
//  Created by 南晓斌 on 11-7-10.
//  Copyright 2011 autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>

@interface System : NSObject <UIAlertViewDelegate>{

}

//判断是否联网
+ (BOOL) checkNetwork;


//在联网已经成功的情况下，判断是不是通过wifi链接的。
+ (BOOL) checkNetworConnectedByWifi;

//在联网已经成功的情况下，判断是不是通过wifi链接的。
+ (BOOL) checkNetworConnectedByGprs;

+ (BOOL) connectedToNetwork; 

// iOS7 以后，需要获取mac权限，用以检测mac风
+ (BOOL)canRecord;

+ (NSString *) getDocumentDirectory;

//gb2312编码
+(NSString *)EncodeGB2312Str:(NSString *)encodeStr;


+(NSString *)getStatisticsInfo;

+(NSURL *)appendUrl:(NSURL *)postUrl;
//获取文件大小，单位B
+(long long)fileSize:(NSString *)filePath;
//获取文件夹大小，单位B
+(long long)folderSize:(NSString *)folderPath;

+ (NSString *)EncodeGB2312StrToGB18030:(NSString *)encodeStr;

+ (BOOL)isPushNotifiOn;

// 主窗口
+ (UIWindow*) MainWindow;

// 屏幕大小
+ (CGRect)getApplicationRect;
+ (CGFloat)getApplicationWidth;
+ (CGFloat)getApplicationHeight;
+ (CGFloat)getScreenHeight;
+ (CGFloat)getScreenWidth;

// 适配
+ (BOOL)isLongIOS6L;
+ (BOOL)isLongIOS7U;
+ (BOOL)isShortIOS6L;
+ (BOOL)isShortIOS7U;
@end
