//
//  SearchOrderCell.h
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *lbdate;
@property (weak, nonatomic) IBOutlet UILabel *lbtime;
@property (weak, nonatomic) IBOutlet UILabel *lbsendPortname;
@property (weak, nonatomic) IBOutlet UILabel *lbendportname;

@property (weak, nonatomic) IBOutlet UILabel *lbstate;
@property (weak, nonatomic) IBOutlet UILabel *lbpiao;

@property (weak, nonatomic) IBOutlet UILabel *lbzhang;
@property (weak, nonatomic) IBOutlet UILabel *lbprice;
@property (weak, nonatomic) IBOutlet UILabel *lbshijian;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
