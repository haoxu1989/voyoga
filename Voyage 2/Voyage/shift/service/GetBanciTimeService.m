//
//  GetBanciTimeService.m
//  Voyage
//
//  Created by xu.hao on 11/4/14.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "GetBanciTimeService.h"
#import "BanciModel.h"

@implementation GetBanciTimeService
@synthesize banciList;


- (BOOL)parseJSON:(NSDictionary*)jsonModel
{
    banciList = [[NSMutableArray alloc]init];
    NSDictionary * dictionary=[jsonModel objectForKey:@"result"];
    for (NSDictionary *dic in dictionary) {
        BanciModel *banci = [[BanciModel alloc] init];
        banci.prtTime = [dic objectForKey:@"prtTime"];
        banci.arriveTime = [dic objectForKey:@"arriveTime"];
        banci.seatCount = [dic objectForKey:@"seatCount"];
        banci.busType = [dic objectForKey:@"busType"];
        banci.linecourse = [[dic objectForKey:@"linecourse"] floatValue];
        [banciList addObject:banci];
    }
    return YES;
}


- (void)getTimeListByDate:(NSString *)senddate Bybliid:(NSString *)bliid Bylinid:(NSString *)linid
{
    NSString *strUrl = [NSString stringWithFormat:@"%@",API_DOMAIN];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:@"search_lineplan" forKey:@"service"];
    [prams setObject:senddate forKey:@"senddate"];
    [prams setObject:bliid forKey:@"bliid"];
    [prams setObject:linid forKey:@"linid"];
    
    NSString *mdeStr = [self md5Value:[NSString stringWithFormat:@"99998%@%@%@2B9FED25FDA45CEA",senddate,bliid,linid]];
    [prams setObject:mdeStr forKey:@"sign"];
    [self sendPost:strUrl parameters:prams ImageArray:nil];
}

@end
