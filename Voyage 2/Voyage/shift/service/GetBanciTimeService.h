//
//  GetBanciTimeService.h
//  Voyage
//
//  Created by xu.hao on 11/4/14.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "AHServiceBase.h"

@interface GetBanciTimeService : AHServiceBase

@property (strong, nonatomic) NSMutableArray *banciList;

- (void)getTimeListByDate:(NSString *)senddate Bybliid:(NSString *)bliid Bylinid:(NSString *)linid;

@end
