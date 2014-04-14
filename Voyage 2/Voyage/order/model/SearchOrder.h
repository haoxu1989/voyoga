//
//  SearchOrder.h
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "JSONModel.h"

@interface SearchOrder : JSONModel

@property (strong, nonatomic) NSString *fID;
@property (strong, nonatomic) NSString *oState;
@property (strong, nonatomic) NSString *sendDate;
@property (strong, nonatomic) NSString *sendTime;
@property (strong, nonatomic) NSString *sendPortName;
@property (strong, nonatomic) NSString *endPortName;
@property (assign, nonatomic) NSInteger tckNum;
@property (assign, nonatomic) float totPrice;
@property (strong, nonatomic) NSString *fromDate;
@property (strong, nonatomic) NSString *ticketno;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *paperNo;
@property (strong, nonatomic) NSString *qrcode;
@property (assign, nonatomic) NSNumber<Ignore> *isOpen;

@end
