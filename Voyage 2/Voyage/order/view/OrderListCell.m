//
//  OrderListTableViewCell.m
//  Voyage
//
//  Created by 王俊 on 14-4-7.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
