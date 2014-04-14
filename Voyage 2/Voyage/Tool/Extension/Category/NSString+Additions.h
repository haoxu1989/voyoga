//
//  NSString+jun.h
//  MyLibrary
//
//  Created by jun on 13-1-22.
//  Copyright (c) 2013年 jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

// change string Vale to NSURL
- (NSURL *)urlValue;

// return the 16-bit MD5 Value
- (NSString *)md5Value;

- (CGSize)sizeWithFont:(UIFont *)font;

// 计算文字尺寸 （使用系统默认字体）
- (CGSize)sizeWithFontSize:(float)fSize constrainedToSize:(CGSize)cSize;

// 计算文字尺寸
- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)cSize;

/*!
 *  @method
 *  @abstract 获取拼音的方法
 *  @return 返回拼音数组  0：shortPY   1：fullPY
 */
- (NSArray *)pinYin;

@end
