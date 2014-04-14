//
//  LineportList.h
//  Voyage
//
//  Created by 王俊 on 14-4-10.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "JSONModel.h"

@interface LineportList : JSONModel
@property (strong, nonatomic) NSString *linID;
@property (strong, nonatomic) NSString *bliID;
@property (strong, nonatomic) NSString *prtID;
@property (strong, nonatomic) NSString *prtName;
@property (assign, nonatomic) float lptKM;
@property (strong, nonatomic) NSString *endPort;
@property (strong, nonatomic) NSString *endPortName;
@property (assign, nonatomic) float prcPrice;
@property (assign, nonatomic) float netPrice;
@property (strong, nonatomic) NSString *lastDateTime;
@property (strong, nonatomic) NSString *prtLat;
@property (strong, nonatomic) NSString *prtLon;
@end
