//
//  NSString+jun.m
//  MyLibrary
//
//  Created by jun on 13-1-22.
//  Copyright (c) 2013年 jun. All rights reserved.
//

#import "NSString+Additions.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

-(NSURL *)urlValue
{
    return [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

-(NSString *)md5Value
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font constrainedToSize:(CGSize){MAXFLOAT,MAXFLOAT}];
}

- (CGSize)sizeWithFontSize:(float)fSize constrainedToSize:(CGSize)cSize
{
    UIFont *font = [UIFont systemFontOfSize:fSize];
    return [self sizeWithFont:font constrainedToSize:cSize];
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)cSize
{
    if (kSystemVersion < 7)
    {
        CGSize size = [self sizeWithFont:font constrainedToSize:cSize
                           lineBreakMode:NSLineBreakByWordWrapping];
        return size;
    }else{
        NSDictionary *stringAttributes = @{NSFontAttributeName:font};
        CGRect rect = [self boundingRectWithSize:cSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:stringAttributes context:nil];
        
        return rect.size;
    }
}

- (NSArray *)pinYin
{
    CFMutableStringRef cfString = CFStringCreateMutableCopy(NULL, 0, (CFStringRef)self);
    CFStringTransform(cfString, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(cfString, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *fullPY =  [(__bridge NSString *)cfString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *strArray = [(__bridge NSString *)cfString componentsSeparatedByString:@" "];
    NSString *shortPY = @"";
    for (NSString *str in strArray) {
        if (str.length>0) {
            shortPY = [shortPY stringByAppendingString:[str substringToIndex:1]];
        }
    }
    
    CFRelease(cfString);
    
    return @[shortPY,
             fullPY != nil ? fullPY:@""
            ];
}

@end
