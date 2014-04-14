//
//  NSArray+Additions.m
//  CarPrice
//
//  Created by lichenxi on 14-1-14.
//  Copyright (c) 2014年 ATHM. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)
- (id)objectAtIndexSafe:(NSUInteger)index
{
    if (index < [self count])
    {
        return [self objectAtIndex:index];
    }
    
    return nil;
}
@end
