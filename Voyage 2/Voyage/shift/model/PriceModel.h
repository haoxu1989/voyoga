//
//  PriceModel.h
//  Library
//
//  Created by xu.hao on 7/4/14.
//  Copyright (c) 2014年 郝旭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceModel : NSObject

@property (nonatomic, assign)  float lineStationPrice; //原价

@property (nonatomic, assign)  float onLinePrice; //网购价

@property (nonatomic, assign)  NSInteger SeatCount; //剩余座位数

@property (nonatomic, retain)  NSString *inname;//保险名称

@property (nonatomic, assign)  float infee;//保险价格

@property (nonatomic, retain)  NSString *inpro;//保险协议

@property (nonatomic, retain)  NSString *inmemo;//特别说明

@property (nonatomic, assign)  NSInteger onesell;//单笔最多购买张数

@property (nonatomic, assign)  BOOL isopen;//是否开通

@property (nonatomic, assign)  NSInteger chargefee;//手续费

@end
