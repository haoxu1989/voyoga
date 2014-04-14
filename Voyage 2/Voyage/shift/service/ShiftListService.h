//
//  ShiftListService.h
//  Voyage
//
//  Created by 王俊 on 14-4-8.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHServiceBase.h"

@interface ShiftListService : AHServiceBase

@property (strong, nonatomic) NSMutableArray *list;

- (void)getShift:(NSString *)aptid bustype:(NSInteger)bustype;

@end
