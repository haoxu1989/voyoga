//
//  PlistDataManager.m
//  CarPrice
//
//  Created by 王俊 on 13-10-31.
//  Copyright (c) 2013年 ATHM. All rights reserved.
//

#import "PlistDataManager.h"

@implementation PlistDataManager


+ (id)sharedPlistDataManager
{
    
    static dispatch_once_t pred;
    static PlistDataManager *manager = nil;
    dispatch_once(&pred, ^{ manager = [[PlistDataManager alloc] init]; });
    manager.isInnerApp=NO;
    return manager;
}


//获取缓存数据文件的路径
- (NSString *)getCacheDataPath:(NSString *)plistName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    plistPath=[plistPath stringByAppendingPathComponent:plistName];
    if (self.isInnerApp) {
        plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *data;
    
    if (![fileManager fileExistsAtPath: plistPath])
    {
        data = [[NSMutableDictionary alloc] init];
        [data writeToFile:plistPath atomically:YES];
    }
    return plistPath;
}


//取缓存
- (id)getCacheData:(NSString *)plistName cacheKey:(NSString *)cacheKey
{
    id cacheData=nil;
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[self getCacheDataPath:plistName]];
        if (dictionary) {
            cacheData=[dictionary objectForKey:cacheKey];
        }
        [theLock unlock];
    }
    return cacheData;
}

//取缓存
- (void)getCacheData:(NSString *)plistName cacheKey:(NSString *)cacheKey success:(void (^)(id cacheData))success
{
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:[self getCacheDataPath:plistName]];
        if (dictionary) {
            id cacheData=[dictionary objectForKey:cacheKey];
            if (success) {
                success(cacheData);
            }
        }
        [theLock unlock];
    }
}


//存缓存
- (void)setCacheData:(NSString *)plistName data:(id)data cacheKey:(NSString *)cacheKey
{
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        NSString *path=[self getCacheDataPath:plistName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            if (dictionary) {
                [dictionary setValue:data forKey:cacheKey];
                [dictionary writeToFile:path atomically:YES];
            }
        }
        [theLock unlock];
    }
}


//删除所有数据
- (void)removeAllData:(NSString *)plistName
{
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        NSString *path=[self getCacheDataPath:plistName];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if (dictionary) {
            [dictionary removeAllObjects];
            [dictionary writeToFile:path atomically:YES];
        }
        [theLock unlock];
    }
}


//清除plist中对应 key 数据
- (void)removeObjectForKey:(NSString *)plistName caheKey:(NSString *)cacheKey
{
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        NSString *path=[self getCacheDataPath:plistName];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if (dictionary) {
            [dictionary  removeObjectForKey:cacheKey];
            [dictionary writeToFile:path atomically:YES];
        }
        [theLock unlock];
    }
}

- (void)removeObjectForFuzzyKey:(NSString *)plistName caheKey:(NSString *)cacheKey
{
    NSLock *theLock = [[NSLock alloc] init];
    if ([theLock tryLock])
    {
        NSString *path=[self getCacheDataPath:plistName];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        if (dictionary)
        {
            NSMutableArray *removekey = [[NSMutableArray alloc] init];
            for (NSString *key in dictionary.allKeys) {
                if ([key hasPrefix:cacheKey]) {
                    [removekey addObject:key];
                }
            }
            
            [dictionary removeObjectsForKeys:removekey];
            [dictionary writeToFile:path atomically:YES];
            removekey = nil;
        }
        [theLock unlock];
    }
}


@end
