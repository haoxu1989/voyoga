//
//  EditOrderViewController.h
//  365CarCard
//
//  Created by 郝旭 on 13-4-13.
//  Copyright (c) 2013年 郝旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import "OederFirstShowViewController.h"
#import "GettktPriceService.h"
#import "ToPosttktService.h"
#import "LineportList.h"
#import "ShiftList.h"

@interface EditOrderViewController : UIViewController<UITextFieldDelegate,CKCalendarDelegate,orderFirstDelegate,AHServiceDelegate>{
    BOOL                            isiPhone;
    UILabel                         *zhangshuLabel;
    UILabel                         *kaitongLabel;
    NSInteger                       zhangshuCount; //购票张数
    NSInteger                       chengyixianzhangshuCount; //乘意保张数
    float                           allPiaoPrice;  //所有票价
    CKCalendarView                  *calendar;
    UIControl                       *backControl;
    UILabel                         *yushouLabel;
    NSInteger                       checkType; //选择的支付类型，0钱包 1网页
    
    OederFirstShowViewController    *orderTimeControl;
}

@property (nonatomic, retain) LineportList          *linePortModel;

@property (nonatomic, retain) ShiftList          *shiftList;

@property (nonatomic, assign) SEL                             result;

@property (nonatomic, strong) NSString  *tempShenfenzheng;

@property (nonatomic, strong) NSString  *tempName;

@property (nonatomic, strong) NSString  *tempPhone;

@property (nonatomic, assign) float     baoxianTotal;

@property (nonatomic, assign) float     chargeFeeStr;

@property (nonatomic, strong) IBOutlet  UITableView *orderTab;

@property (nonatomic, strong) IBOutlet  UILabel *lineLabel;

@property (nonatomic, strong) IBOutlet  UILabel *stationLabel;

@property (nonatomic, strong) IBOutlet  UIView *headerView;

@property (nonatomic, strong) IBOutlet  UIView *addHeaderView;

@property (nonatomic, strong) IBOutlet  UIButton *headerBtn;

@property (nonatomic, strong) IBOutlet  UILabel *priceLabel;

@property (nonatomic, strong) UIButton  *carDateBtn;

@property (nonatomic, strong) UIButton  *carTimeBtn;

@property (nonatomic, strong) UIButton  *askPriceBtn;

@property (nonatomic, retain) NSString                        *dateStr;//日期string


@property (nonatomic, strong) NSMutableArray   *personArray;


@property (nonatomic, retain) GettktPriceService    *getPriceSer;

@property (nonatomic, retain) ToPosttktService      *postTktSer;


//addHeaderView label

@property (nonatomic, strong) IBOutlet UILabel               *chengchedidiandianLabel;//乘车地点

@property (nonatomic, strong) IBOutlet UILabel               *chengchezhandianLabel;//乘车站点

@property (nonatomic, strong) IBOutlet UILabel               *mudizhandianLabel;//目的站点

@property (nonatomic, strong) IBOutlet UILabel               *chexingLabel;//车型

@property (nonatomic, strong) IBOutlet UILabel               *shengyuzuoweiLabel;//剩余座位

@property (nonatomic, strong) IBOutlet UILabel               *daodashijianLabel;//到达时间

@property (nonatomic, strong) IBOutlet UILabel               *quanchengLabel;//全程

@end
