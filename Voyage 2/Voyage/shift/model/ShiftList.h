//
//  ShiftList.h
//  Voyage
//
//  Created by 王俊 on 14-4-8.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "JSONModel.h"

@interface ShiftList : JSONModel

@property (strong, nonatomic) NSString *linID;
@property (strong, nonatomic) NSString *linStartCity;
@property (strong, nonatomic) NSString *linEndCity;
@property (strong, nonatomic) NSString *linStartPortID;
@property (strong, nonatomic) NSString *linStartPortName;
@property (strong, nonatomic) NSString *linEndPortID;
@property (strong, nonatomic) NSString *linEndPortName;
@property (strong, nonatomic) NSString *linName;
@property (assign, nonatomic) NSInteger linKilometer;
@property (strong, nonatomic) NSString *aptID;
@property (assign, nonatomic) NSInteger isFlow;
@property (strong, nonatomic) NSString *linMemo;
@property (strong, nonatomic) NSString *linPortImgUrl;
@property (strong, nonatomic) NSString *lastDateTime;


@property (assign, nonatomic) NSNumber<Ignore> *isOpen;

@end
