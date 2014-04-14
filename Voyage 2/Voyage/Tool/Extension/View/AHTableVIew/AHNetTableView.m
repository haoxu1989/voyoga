/*!
 @header    AHNetTableView.h
 @abstract  封装用于产生网络数据请求的TableView
 @author    张洁
 @version   2.4.0 2013/03/25 Creation
 */

#import "AHNetTableView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+screenshot.h"

#define FLIP_ANIMATION_DURATION 0.18f
#define COVERALPHA 0.6



@implementation RefreshFooterView

@synthesize activity;
@synthesize btnFooter;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        btnFooter=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        btnFooter.titleLabel.font=[UIFont boldSystemFontOfSize:14];
        [btnFooter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnFooter setTitle:@"更多..." forState:UIControlStateNormal];
        [self addSubview:btnFooter];
        //初始化控件
        activity=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.width-30, self.height/2-10, 20, 20)];
        activity.hidden=YES;
        [self addSubview:activity];
    }
    return self;
}



@end
//＝＝＝＝＝＝＝＝＝＝刷新的底部View结束


@interface AHNetTableView ()
{
    RefreshFooterView *footerView;
    
    
}

@property (nonatomic, strong) FolderCoverView *top, *bottom;
@property (nonatomic) CGPoint oldTopPoint, oldBottomPoint;
@property (nonatomic) CGPoint oldContentOffset;
@property (nonatomic) BOOL closing;
@property (nonatomic) CGFloat offsetY;
@property (nonatomic, copy) FolderOpenBlock openBlock;
@property (nonatomic, copy) FolderCloseBlock closeBlock;
@property (nonatomic, copy) FolderCompletionBlock completionBlock;

@end

//用于产生网络数据请求的TableView
@implementation AHNetTableView
@synthesize ahNetDelegate;
@synthesize identify;
@synthesize isReloading;
@synthesize top=_top, bottom=_bottom;
@synthesize oldTopPoint=_oldTopPoint, oldBottomPoint=_oldBottomPoint;
@synthesize closing=_closing;
@synthesize subClassContentView=_subClassContentView;
@synthesize openBlock=_openBlock, closeBlock=_closeBlock, completionBlock=_completionBlock;
@synthesize offsetY=_offsetY;
@synthesize oldContentOffset=_oldContentOffset;
@synthesize folderDelegate=_folderDelegate;

#pragma mark - View lifecycle

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.isDropDownRefresh=YES;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.isDropDownRefresh=YES;
        isShowLoding=NO;
    }
    return self;
}


- (void)setAhNetDelegate:(id<AHNetTableViewDelegate>)_ahNetDelegate
{
    ahNetDelegate=_ahNetDelegate;
    self.delegate=ahNetDelegate;
}

//自动刷新功能
- (void)autoRefrush:(id)sender{
    if (self.isDropDownRefresh) {
        //以动画形式展现下拉table，设置75的原因是，EGORefreshTable需要下拉65个像素才能触发更新操作，设置75这样还可以有种动态回弹的效果，你可以根据自己的需求再调整。
        [self setContentOffset:CGPointMake(0, -70) animated:NO];
        [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.5];

    }
}


- (void)setIsDropDownRefresh:(BOOL)isdropDownRefresh{
    _isDropDownRefresh=isdropDownRefresh;
    if (self)
    {
        if (isdropDownRefresh)
        {
            [self drawDropDownRefreshView];
        }
        else{
            [_refreshHeaderView removeFromSuperview];
        }
    }
}


- (void)setIsShowMore:(BOOL)isShowMore{
    _isShowMore=isShowMore;
    if (self)
    {
        if (isShowMore)
        {
            [self drawMoreView];
            footerView.hidden=NO;
            self.tableFooterView.hidden = NO;
            self.tableFooterView = footerView;
        }
        else
        {
            self.tableFooterView.hidden = YES;
            self.tableFooterView = nil;
        }
    }
}


//绘制上拉刷新控件
- (void)drawDropDownRefreshView
{
    if (_refreshHeaderView == nil)
	{
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.superview.height, self.width, self.superview.height)];
		_refreshHeaderView.delegate = self;
    }
    [_refreshHeaderView removeFromSuperview];
    [self addSubview:_refreshHeaderView];
	[_refreshHeaderView refreshLastUpdatedDate];
}


//绘制显示更多控件
- (void)drawMoreView
{
    if (footerView==nil)
    {
        footerView=[[RefreshFooterView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        footerView.backgroundColor=[UIColor whiteColor];
        [footerView.btnFooter addTarget:self action:@selector(onFooterClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tableFooterView.hidden=NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender==self) {
        if (ahNetDelegate && [ahNetDelegate respondsToSelector:@selector(tableViewDidScrol:)])
        {
             [ahNetDelegate tableViewDidScrol:sender];
        }
       
        if (_isDropDownRefresh) {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:sender];
        }
        
        if (self.isShowMore && !isReloading)
        {
            
            if (isShowLoding)
            {
                return;
            }
            if (sender.contentOffset.y+sender.frame.size.height>sender.contentSize.height+40)
            {
                [footerView.btnFooter setTitle:@"松开加载更多" forState:UIControlStateNormal];
                if (ahNetDelegate && [ahNetDelegate respondsToSelector:@selector(tableView:whileUpDrag:)])
                {
                    [ahNetDelegate tableView:self didEndDownDrag:footerView];
                }
            }
            else
            {
                if (_isDropDownRefresh) {
                    [self doneShowLoadingData];
                }
                
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_isDropDownRefresh) {
         [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
   
    
    if (self.isShowMore && !isReloading)
    {
        if (scrollView.contentOffset.y+scrollView.frame.size.height>scrollView.contentSize.height+40)
        {
            isShowLoding=YES;
            [self statShowLoadingData];
        }
        else
        {
            if (_isDropDownRefresh) {
                [self doneShowLoadingData];
            }
        }
    }
}


- (void)onFooterClick:(id)sender
{
    if (!isReloading && !isShowLoding) {
        isShowLoding=YES;
        [self statShowLoadingData];
    }
}


- (void)statShowLoadingData
{
    [footerView.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [footerView.activity setHidesWhenStopped:YES];
    [footerView.activity setHidden: NO];
    [footerView.activity startAnimating];
    [footerView.btnFooter setTitle:@"加载中..." forState:UIControlStateNormal];
    //调用代理加载数据
    if (ahNetDelegate&&[ahNetDelegate respondsToSelector:@selector(tableView:startLoadingData:)])
    {
        [ahNetDelegate tableView:self startLoadingData:AHNetTableViewLoadEventUpDrag];
    }
    if (ahNetDelegate && [ahNetDelegate respondsToSelector:@selector(tableView:didEndUpDrag:)]) {
        [ahNetDelegate tableView:self didEndUpDrag:footerView];
    }
//    [self performSelector:@selector(doneShowLoadingData) withObject:nil afterDelay:30.0];
}


- (void)doneShowLoadingData
{
    if (ahNetDelegate && [ahNetDelegate respondsToSelector:@selector(tableView:startUpDrag:)])
    {
        [ahNetDelegate tableView:self startUpDrag:footerView];
    }
    isShowLoding=NO;
    [footerView.btnFooter setTitle:@"更多..." forState:UIControlStateNormal];
    footerView.activity.hidden=YES;
    [footerView.activity stopAnimating];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods


//自动刷新
- (void)doneManualRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self];

    if (ahNetDelegate&&[ahNetDelegate respondsToSelector:@selector(doneManualRefreshTableView:)]) {
        [ahNetDelegate doneManualRefreshTableView:self];
    }
}


- (void)doneLoadingTableViewData
{
	isReloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


- (void)reloadTableViewDataSource
{
	//重新获取数据
	isReloading = YES;
    [self doneShowLoadingData];
    //调用代理加载数据
    if (ahNetDelegate&&[ahNetDelegate respondsToSelector:@selector(tableView:startLoadingData:)])
    {
        [ahNetDelegate tableView:self startLoadingData:AHNetTableViewLoadEventDownDrag];
    }
    //设置下拉时间
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view state:(EGOPullRefreshState)aState
{
    switch (aState)
    {
		case EGOOPullRefreshPulling:
        {
            if (ahNetDelegate&&[ahNetDelegate respondsToSelector:@selector(tableView:whileDownDrag:)])
            {
                [ahNetDelegate tableView:self whileDownDrag:view];
            }
			view.statusLabel.text = NSLocalizedString(@"松开立即刷新...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			view.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
        }
			break;
		case EGOOPullRefreshNormal:
        {
			if (view.states == EGOOPullRefreshPulling) {
                if (ahNetDelegate&&[ahNetDelegate respondsToSelector:@selector(tableView:startDownDrag:)])
                {
                    [ahNetDelegate tableView:self startDownDrag:view];
                }
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				view.arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			view.statusLabel.text = NSLocalizedString(@"下拉即可刷新...", @"Pull down to refresh status");
			[view.activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			view.arrowImage.hidden = NO;
			view.arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			//[self refreshLastUpdatedDate];
        }
			break;
		case EGOOPullRefreshLoading:
        {
            if (ahNetDelegate&&[ahNetDelegate respondsToSelector:@selector(tableView:didEndDownDrag:)])
            {
                [ahNetDelegate tableView:self didEndDownDrag:view];
            }
			view.statusLabel.text = NSLocalizedString(@"更新中...", @"Loading Status");
			[view.activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			view.arrowImage.hidden = YES;
			[CATransaction commit];
        }
			break;
		default:
			break;
	}
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
    if (_isDropDownRefresh) {
        [self reloadTableViewDataSource];
    }
	
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:30.0];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
      if (_isDropDownRefresh) {
          [_refreshHeaderView refreshLastUpdatedDate];

      }
	return isReloading; // should return if data source model is reloading
}


- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    //获取上次下拉时间
    return [NSDate date];
}








#pragma mark -
#pragma mark AHNetTableView Methods

/*!
 @method
 @abstract   结束加载数据的显示
 @discussion 目前支持的是上拉下拉的加载调用、主动点击的加载调用
 @param      isLoadDataNow:是否现在载入数据，如果YES,则重新载入TableView的数据
 */
- (void)endLoadingData:(BOOL)isLoadDataNow
{
    //
}



- (void)openFolderAtIndexPath:(NSIndexPath *)indexPath
              WithContentView:(UIView *)subClassContentView
                    openBlock:(FolderOpenBlock)openBlock
                   closeBlock:(FolderCloseBlock)closeBlock
              completionBlock:(FolderCompletionBlock)completionBlock
{
    //
    self.subClassContentView = subClassContentView;
    self.openBlock = openBlock;
    self.completionBlock = completionBlock;
    self.closing = NO;
    
    // 位置和高度参数
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    CGFloat deltaY = self.contentOffset.y;
    CGFloat positionX;
    
    // 小三角的位置x坐标
    if ([self.folderDelegate respondsToSelector:@selector(tableView:xForRowAtIndexPath:)]) {
        positionX = [self.folderDelegate tableView:self xForRowAtIndexPath:indexPath];
    } else {
        positionX = 40;
    }
    
    CGPoint position = CGPointMake(positionX, cell.frame.origin.y+cell.frame.size.height - 1);
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (position.y - deltaY > height) {
        self.offsetY = position.y - height - deltaY;
    } else {
        self.offsetY = 0.0f;
    }
    
    // 重置contentoffset  这里要动画吗？
    self.oldContentOffset = self.contentOffset;
    self.contentOffset = CGPointMake(0, self.offsetY + deltaY);
    
    deltaY = self.contentOffset.y;
    
    UIImage *screenshot = [self screenshotWithOffset:-deltaY];
    
    // 配置上下遮罩
    CGRect upperRect = CGRectMake(0, deltaY, width, position.y - deltaY);
    CGRect lowerRect = CGRectMake(0, position.y, width, height + deltaY - position.y);
    
    self.top = [self buttonForRect:upperRect
                            screen:screenshot
                          position:position
                               top:YES
                       transparent:NO];
    self.bottom = [self buttonForRect:lowerRect
                               screen:screenshot
                             position:position
                                  top:NO
                          transparent:NO];
    // 绑定关闭动作
    [self.top addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom addTarget:self action:@selector(performClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.top.cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)] ];
    [self.bottom.cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)]];
    
    [self addSubview:subClassContentView];
    [self addSubview:self.top];
    [self addSubview:self.bottom];
    
    CGRect viewFrame = subClassContentView.frame;
    if (position.y - deltaY + viewFrame.size.height > height) {
        viewFrame.origin.y = height + deltaY - viewFrame.size.height;
    } else {
        viewFrame.origin.y = position.y;
    }
    subClassContentView.frame = viewFrame;
    
    // 配置打开动画
    CGFloat contentHeight = subClassContentView.frame.size.height;
    CFTimeInterval duration = 0.4f;
    CGPoint toTopPoint;
    CABasicAnimation *moveTop = [CABasicAnimation animationWithKeyPath:@"position"];
    moveTop.duration = duration;
    moveTop.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.oldTopPoint = self.top.layer.position;
    CGFloat newTopY;
    if (self.top.frame.origin.y + self.top.frame.size.height > subClassContentView.frame.origin.y) {
        newTopY = self.oldTopPoint.y + subClassContentView.frame.origin.y - (self.top.frame.origin.y + self.top.frame.size.height);
    } else {
        newTopY = self.oldTopPoint.y;
    }
    toTopPoint = (CGPoint){ self.oldTopPoint.x, newTopY};
    moveTop.fromValue = [NSValue valueWithCGPoint:self.oldTopPoint];
    moveTop.toValue = [NSValue valueWithCGPoint:toTopPoint];
    
    
    CGPoint toBottomPoint;
    CABasicAnimation *moveBottom = [CABasicAnimation animationWithKeyPath:@"position"];
    moveBottom.duration = duration;
    moveBottom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    self.oldBottomPoint = self.bottom.layer.position;
    CGFloat newBottomY;
    if (subClassContentView.frame.origin.y + subClassContentView.frame.size.height > height + deltaY ) {
        newBottomY = self.oldBottomPoint.y + (subClassContentView.frame.origin.y + contentHeight) - deltaY - height;
    } else {
        newBottomY = self.oldBottomPoint.y + contentHeight;
    }
    toBottomPoint = (CGPoint){ self.oldBottomPoint.x, newBottomY};
    moveBottom.fromValue = [NSValue valueWithCGPoint:self.oldBottomPoint];
    moveBottom.toValue = [NSValue valueWithCGPoint:toBottomPoint];
    
    // 打开动画
    [self.top.layer addAnimation:moveTop forKey:@"t1"];
    [self.bottom.layer addAnimation:moveBottom forKey:@"t2"];
    
    // 透明变半透明
    [UIView animateWithDuration:duration animations:^{
        self.top.cover.alpha = COVERALPHA;
        self.bottom.cover.alpha = COVERALPHA;
    }];
    
    if (openBlock) openBlock(self.subClassContentView, duration, [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]);
    
    [self.top.layer setPosition:toTopPoint];
    [self.bottom.layer setPosition:toBottomPoint];
    
}

-(void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged ||
        gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.numberOfTapsRequired > 0) {
            [self performClose:gesture];
        }
    }
}

- (void)performClose:(id)sender {
    if (self.closing) {
        return;
    }else {
        self.closing = YES;
    }
    
    // 配置关闭动画
    CFTimeInterval duration = 0.4f;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *moveTop = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveTop setValue:@"close" forKey:@"animationType"];
    [moveTop setDelegate:self];
    [moveTop setTimingFunction:timingFunction];
    moveTop.fromValue = [NSValue valueWithCGPoint:[[self.top.layer presentationLayer] position]];
    moveTop.toValue = [NSValue valueWithCGPoint:self.oldTopPoint];
    moveTop.duration = duration;
    
    
    CABasicAnimation *moveBottom = [CABasicAnimation animationWithKeyPath:@"position"];
    [moveBottom setValue:@"close" forKey:@"animationType"];
    [moveBottom setDelegate:self];
    [moveBottom setTimingFunction:timingFunction];
    moveBottom.fromValue = [NSValue valueWithCGPoint:[[self.bottom.layer presentationLayer] position]];
    moveBottom.toValue = [NSValue valueWithCGPoint:self.oldBottomPoint];
    moveBottom.duration = duration;
    
    // 关闭动画
    [self.top.layer addAnimation:moveTop forKey:@"b1"];
    [self.bottom.layer addAnimation:moveBottom forKey:@"b2"];
    
    // 半透明变透明
    [UIView animateWithDuration:duration animations:^{
        
        self.contentOffset = self.oldContentOffset;
        self.top.cover.alpha = 0;
        self.bottom.cover.alpha = 0;
        
    }];
    
    if (self.closeBlock) self.closeBlock(self.subClassContentView, duration, timingFunction);
    
    [self.top.layer setPosition:self.oldTopPoint];
    [self.bottom.layer setPosition:self.oldBottomPoint];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"animationType"] isEqualToString:@"close"]) {
        [self.top removeFromSuperview];
        [self.bottom removeFromSuperview];
        [self.subClassContentView removeFromSuperview];
        
        self.top = nil;
        self.bottom = nil;
        self.subClassContentView = nil;
        
        if (self.completionBlock) self.completionBlock();
        //        sharedInstance = nil;
    }
    
}

- (FolderCoverView *)buttonForRect:(CGRect)aRect
                            screen:(UIImage *)screen
                          position:(CGPoint)position
                               top:(BOOL)isTop
                       transparent:(BOOL)isTransparent {
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = aRect.size.width;
    CGFloat height = aRect.size.height;
    CGPoint origin = aRect.origin;
    CGFloat deltaY = self.contentOffset.y;
    
    CGRect scaledRect = CGRectMake(origin.x*scale, origin.y*scale - deltaY*scale, width*scale, height*scale);
    CGImageRef ref1 = CGImageCreateWithImageInRect([screen CGImage], scaledRect);
    
    FolderCoverView *button;
    if (isTop) {
        button = [[FolderCoverView alloc] initWithFrame:aRect offset:self.rowHeight];
        
        UIImageView *notch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip.png"]];
        notch.center = CGPointMake(position.x, height - 2);
        [button addSubview:notch];
        
    } else {
        button = [[FolderCoverView alloc] initWithFrame:aRect offset:0];
    }
    
    [button setIsTopView:isTop];
    
    button.position = position;
    button.layer.contentsScale = scale;
    button.layer.contents = isTransparent ? nil : (__bridge id)(ref1);
    button.layer.contentsGravity = kCAGravityCenter;
    CGImageRelease(ref1);
    
    return button;
}



@end
