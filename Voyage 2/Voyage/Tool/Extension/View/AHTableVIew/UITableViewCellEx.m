/*!
 @header    UITableViewCellEx.m
 @abstract  封装下划线及Cell的点击效果
 @author    王俊
 @version   2.1.0 2012/11/02 Creation
 */

#import "UITableViewCellEx.h"
#import "UIImage+Additions.h"

@implementation UITableViewCellEx

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame=frame;
        [self drawCell];
    }
    return self;
}


- (void)awakeFromNib
{
     [self drawCell];
}

- (void)drawCell
{
    //点击效果
    UIView *cellSelectedimageView=[[UIView alloc]initWithFrame:self.frame];
    cellSelectedimageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    cellSelectedimageView.backgroundColor=GRAYCOLOR;
    self.selectedBackgroundView=cellSelectedimageView;
    
    _linesView=[[UIView alloc]initWithFrame:CGRectMake(15, self.height-0.5, self.width-15, 0.5)];
    _linesView.backgroundColor=LIGHTGRAYCOLOR;
    self.backgroundColor=[UIColor whiteColor];
    self.contentView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_linesView];
};



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
