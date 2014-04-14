//
//  QuestionsService.h
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHServiceBase.h"

@interface QuestionsService : AHServiceBase
@property (strong, nonatomic) NSString *Result;


- (void)postContact:(NSString *)contact suggest:(NSString *)suggest;
@end
