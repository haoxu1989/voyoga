//
//  OrderListService.m
//  Voyage
//
//  Created by 王俊 on 14-4-6.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "OrderListService.h"
#import "OrderList.h"

@implementation OrderListService


- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    _list = [[NSMutableArray alloc]init];
    [self.list addObjectsFromArray:[OrderList arrayOfModelsFromDictionaries:jsonModel[@"result"]]];
    return YES;
}


- (void)getOrderList
{
    NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:@"search_airport" forKey:@"service"];
    [self sendPost:strUrl parameters:prams ImageArray:nil];
}


@end
