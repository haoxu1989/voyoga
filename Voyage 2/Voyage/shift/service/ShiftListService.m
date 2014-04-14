//
//  ShiftListService.m
//  Voyage
//
//  Created by 王俊 on 14-4-8.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "ShiftListService.h"
#import "ShiftList.h"

@implementation ShiftListService


- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    
    _list = [[NSMutableArray alloc]init];
    
    [self.list addObjectsFromArray:[ShiftList arrayOfModelsFromDictionaries:jsonModel[@"result"]]];
    
    return YES;
}


- (void)getShift:(NSString *)aptid bustype:(NSInteger)bustype
{
    self.handle = EShiftService;
    NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:@"search_line" forKey:@"service"];
    [prams setObject:aptid forKey:@"aptid"];
    [prams setObject:[NSString stringWithFormat:@"%d",bustype] forKey:@"bustype"];
    [self sendPost:strUrl parameters:prams ImageArray:nil];
}

@end
