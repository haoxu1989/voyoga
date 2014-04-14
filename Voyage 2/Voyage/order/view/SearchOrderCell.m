//
//  SearchOrderCell.m
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "SearchOrderCell.h"
#import "UIImage+Additions.h"

@implementation SearchOrderCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.backView.clipsToBounds = YES;

    [self.btn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    
    // Configure the view for the selected state
}

@end
