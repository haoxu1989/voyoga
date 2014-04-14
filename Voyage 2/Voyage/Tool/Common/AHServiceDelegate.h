//
//  AHServiceDelegate.h
//  CarPrice
//
//  Created by 王俊 on 13-10-30.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import "AHNetConsts.h"

@protocol AHServiceDelegate <NSObject>

@optional

/*!
 @method
 @abstract   开始传输数据时的调用
 @discussion 开始传输数据
 @param      handle 网络请求服务的标识
 @param      obj 用于网络请求传递的对象
 */
- (void)netServiceStarted:(enum AHServiceHandle)handle;

/*!
 @method
 @abstract   完成传输数据时的调用
 @discussion 完成传输数据
 @param      handle 网络请求服务的标识
 @param      obj 用于网络请求传递的对象
 */
- (void)netServiceFinished:(enum AHServiceHandle)handle;

- (void)netServiceFinished:(enum AHServiceHandle)handle WithString:(NSString *)jsonStr;

- (void)netServiceCacheFinished:(enum AHServiceHandle)handle;
/*!
 @method
 @abstract   请求错误时的调用
 @discussion 请求接口错误或接口返回错误信息时调用此方法
 @param      handle 网络请求服务的标识
 @param      obj 用于网络请求传递的对象
 */
- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage;

@end