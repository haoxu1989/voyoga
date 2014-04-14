//
//  LineportService.m
//  Voyage
//
//  Created by 王俊 on 14-4-10.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "LineportService.h"
#import "LineportList.h"

@implementation LineportService


- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    
    _list = [[NSMutableArray alloc]init];
    
    [self.list addObjectsFromArray:[LineportList arrayOfModelsFromDictionaries:jsonModel[@"result"]]];
    
    return YES;
}


- (void)getLineprt:(NSString *)lin
{
    self.handle = ELineportService;
    NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:@"search_lineport" forKey:@"service"];
    [prams setObject:lin forKey:@"linid"];
    [self sendPost:strUrl parameters:prams ImageArray:nil];
}


@end
