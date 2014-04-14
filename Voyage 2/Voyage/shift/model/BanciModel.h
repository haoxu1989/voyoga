//
//  BanciModel.h
//  Voyage
//
//  Created by xu.hao on 13/4/14.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BanciModel : NSObject

@property (nonatomic, strong) NSString *arriveTime;//到达时间

@property (nonatomic, strong) NSString *seatCount;//剩余座位

@property (nonatomic, strong) NSString *busType;//巴士类型

@property (nonatomic, assign) NSInteger linecourse;//里程

@property (nonatomic, strong) NSString *prtTime;//发车时间


@end
