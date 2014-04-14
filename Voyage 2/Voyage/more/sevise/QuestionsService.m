//
//  QuestionsService.m
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "QuestionsService.h"

@implementation QuestionsService
- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    self.Result=jsonModel[@"result"];
    return YES;
}

- (void)postContact:(NSString *)contact suggest:(NSString *)suggest
{
    NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:@"submit_feedback" forKey:@"service"];
    [prams setObject:suggest forKey:@"suggest"];
    [prams setObject:contact forKey:@"contact"];
    [self sendPost:strUrl parameters:prams ImageArray:nil];
}

@end
