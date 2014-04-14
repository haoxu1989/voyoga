/*!
 @header    UITableViewCellEx.h
 @abstract  封装下划线及Cell的点击效果
 @author    王俊
 @version   2.1.0 2012/11/02 Creation
 */

#import <UIKit/UIKit.h>
#import "UrlImageView.h"


/*!
 @class
 @abstract  封装下划线及Cell的点击效果
 */
@interface UITableViewCellEx : UITableViewCell

@property (strong, nonatomic) UIView *linesView;

@property (nonatomic, retain) UrlImageView *retainImageview;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellFrame:(CGRect)frame;
/*!
 @method
 @abstract 绘制cell
 */
- (void)drawCell;

@end
