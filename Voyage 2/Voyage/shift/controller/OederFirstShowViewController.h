//
//  OederFirstShowViewController.h
//  365CarCard
//
//  Created by 郝旭 on 13-4-1.
//  Copyright (c) 2013年 郝旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetBanciTimeService.h"
#import "BanciModel.h"

@protocol orderFirstDelegate <NSObject>

- (void)cellDidSelected:(BanciModel *)indexStr;

@end

@interface OederFirstShowViewController : UIViewController<AHServiceDelegate>{
    NSMutableArray              *typeArray;
}

@property (nonatomic, assign) id<orderFirstDelegate>      orderFirseDele;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@property (nonatomic, retain) NSMutableArray        *listArray;

@property (nonatomic, retain) IBOutlet UITableView *listTab;

@property (nonatomic, retain) IBOutlet UIButton *deleteBtn;

@property (nonatomic, retain) IBOutlet UIView *mainView;

@property (nonatomic, retain) GetBanciTimeService   *banciTimeSer; //获取班次时间

@property (nonatomic, retain) NSString              *senddate; //发车日期

@property (nonatomic, retain) NSString              *bliid; //班次id

@property (nonatomic, retain) NSString              *linid; //路线id


@end
