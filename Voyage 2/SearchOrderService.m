//
//  SearchOrderService.m
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "SearchOrderService.h"
#import "SearchOrder.h"

@implementation SearchOrderService

- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    _list = [[NSMutableArray alloc]init];
    [self.list addObjectsFromArray:[SearchOrder arrayOfModelsFromDictionaries:jsonModel[@"result"]]];
    return YES;
}


- (void)SearchOrder:(NSString *)date search:(NSString *)search
{
    NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:date forKey:@"date"];
    [prams setObject:search forKey:@"search"];
    [prams setObject:@"search_order" forKey:@"service"];
    [self sendPost:strUrl parameters:prams ImageArray:nil];

}

@end
