//
//  PlistDataManager.h
//  CarPrice
//  操作plist文件管理类
//  Created by 王俊 on 13-10-31.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlistDataManager : NSObject


/**
 *  是否是离线访问数据
 */
@property (assign, nonatomic) BOOL isInnerApp;
/**
 *  单例生成PlistDataManager
 *
 *  @return PlistDataManager
 */
+ (id)sharedPlistDataManager;

/**
 *  获取存储在plist中的数据
 *
 *  @param cacheKey 该数据在plist中对应key
 *  @param success  获取数据成功后回调
 */
- (void)getCacheData:(NSString *)plistName cacheKey:(NSString *)cacheKey success:(void (^)(id cacheData))success;

/**
 *  直接返回缓存内容
 *
 *  @param cacheKey key
 *
 *  @return 缓存数据
 */
- (id)getCacheData:(NSString *)plistName cacheKey:(NSString *)cacheKey;

/**
 *  储存数据到plist中
 *
 *  @param data     要储存的数据
 *  @param cacheKey 要储存的数据对应的KEY
 */
- (void)setCacheData:(NSString *)plistName data:(id)data cacheKey:(NSString *)cacheKey;

/**
 *  清除plist中所有数据
 */
- (void)removeAllData:(NSString *)plistName;

/**
 *  清除plist中对应 key 数据
 *
 *  @param cacheKey plist中对应 key
 */
- (void)removeObjectForKey:(NSString *)plistName caheKey:(NSString *)cacheKey;

/**
 *  清除plist中相似的 key 数据
 *
 *  @param cacheKey
 */
- (void)removeObjectForFuzzyKey:(NSString *)plistName caheKey:(NSString *)cacheKey;


@end
