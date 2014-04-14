//

//  AHTableViewController.h

//  Autohome

//

//  Created by 王俊 on 13-3-26.

//  Copyright (c) 2013年 autohome. All rights reserved.

//



#import <UIKit/UIKit.h>

#import "AHNetTableView.h"

#import "AHServiceBase.h"

#import "AHUIViewController.h"

@interface AHTableViewController : AHUIViewController

<UITableViewDataSource,AHNetTableViewDelegate,UIScrollViewDelegate,AHServiceDelegate>

{
    
    float tableHeight;
    
    
    
    
}

@property (nonatomic, strong) IBOutlet AHNetTableView *ahTableView;   //列表

@property (nonatomic, strong) NSMutableArray *collectionData;       //采集数据

@property (nonatomic, assign) NSInteger pageIndex;                  //第几页

@property (nonatomic, assign) NSInteger pageSize;                   //每页显示多少条数据

@property (nonatomic, assign) NSInteger rowCount;                   //总条数

@property (nonatomic, assign) NSInteger pageCount;                  //总页数

@property (nonatomic, assign) UITableViewStyle *tableViewStyle;     //列表样式



@property (strong, nonatomic) UIView *promptView; // 提示背景
@property (strong, nonatomic) UILabel *promptLable; //提示lable

/**
 
 *  初始化列表
 
 *
 
 *  @param frame 尺寸
 
 *  @param style 样式
 
 */

- (void)initAHNetTableView:(CGRect)frame style:(UITableViewStyle)style;

- (void)loadData:(BOOL)isLoading;

@end

