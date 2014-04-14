//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:103.0/255.0 green:103.0/255.0 blue:103.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize lastUpdatedLabel=_lastUpdatedLabel;
@synthesize statusLabel=_statusLabel;
@synthesize arrowImage=_arrowImage;
@synthesize activityView=_activityView;
@synthesize delegate=_delegate;
@synthesize states=_states;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if (self = [super initWithFrame:frame]) {
		 offsetTop=0;
         offsetY=65;
//        if (kSystemVersion>=7) {
//            offsetTop=65;
//            offsetY=130;
//        }
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = LIGHTGRAYCOLOR;
		
		
		UILabel *lb_lastUpdate = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		lb_lastUpdate.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		lb_lastUpdate.font = [UIFont systemFontOfSize:12.0f];
		lb_lastUpdate.textColor = textColor;
		lb_lastUpdate.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		lb_lastUpdate.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lb_lastUpdate.backgroundColor = [UIColor clearColor];
		lb_lastUpdate.textAlignment = UITextAlignmentCenter;
		[self addSubview:lb_lastUpdate];
		self.lastUpdatedLabel=lb_lastUpdate;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 40.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:14.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		self.statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(100.0f, frame.size.height - 45, 20, 30);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		self.arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(45.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        view.center = CGRectGetCenter(layer.frame);
		[self addSubview:view];
		self.activityView = view;
		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (void)setIsAlignment:(BOOL)isAlignment
{
    _isAlignment=isAlignment;
    if (kSystemVersion >= 7.0) {
        if (isAlignment) {
            offsetTop=0;
            offsetY=65;
        }
        else
        {
            offsetTop=65;
            offsetY=130;
        }
    }
}

-(void)setDelegate:(id<EGORefreshTableHeaderDelegate>)delegate{
    _delegate=delegate;
    [self setState:EGOOPullRefreshNormal];
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"refreshArrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
//	if ([self.delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
//		
//		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
//		NSDate *now=[NSDate date];
//		
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"yyyy-MM-dd"];
//		NSString *nowStr=@"";
//		if ([[formatter stringFromDate:date] isEqual:[formatter stringFromDate:now]]) {
//            [formatter setDateFormat:@"今天 hh:mm"];
//			nowStr=[formatter stringFromDate:date];
//		}
//		[formatter setAMSymbol:@"AM"];
//		[formatter setPMSymbol:@"PM"];//
//		[formatter setDateFormat:@"MM-dd hh:mm"];
//		if ([nowStr isEqual:@""]) {
//			nowStr=[formatter stringFromDate:date];
//		}else {
//			[formatter setDateFormat:@"今天 hh:mm"];
//			nowStr=[formatter stringFromDate:date];
//		}
//		
//		_lastUpdatedLabel.text = [NSString stringWithFormat:@"最后更新: %@", nowStr];
//		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
//		[[NSUserDefaults standardUserDefaults] synchronize];
//		
//	} else {
//		
//		_lastUpdatedLabel.text = nil;
//		
//	}

}

- (void)setState:(EGOPullRefreshState)aState{
//	if (self.delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:state:)]) {
//        [self.delegate egoRefreshTableHeaderDidTriggerRefresh:self state:aState];
//    }
//    else{
    
        switch (aState)
        {
            case EGOOPullRefreshPulling:
            {
                self.statusLabel.text = NSLocalizedString(@"释放刷新", @"Release to refresh status");
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
            }
                break;
            case EGOOPullRefreshNormal:
            {
                if (self.states == EGOOPullRefreshPulling) {
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    self.arrowImage.transform = CATransform3DIdentity;
                    [CATransaction commit];
                }
                self.statusLabel.text = NSLocalizedString(@"下拉刷新", @"Pull down to refresh status");
                [self.activityView stopAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                self.arrowImage.hidden = NO;
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
                //[self refreshLastUpdatedDate];
            }
                break;
            case EGOOPullRefreshLoading:
            {
                self.statusLabel.text = NSLocalizedString(@"更新中...", @"Loading Status");
                [self.activityView startAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                self.arrowImage.hidden = YES;
                [CATransaction commit];
            }
                break;
            default:
                break;
        }

//    }
	_states = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
    
	if (_states == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, offsetY);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_states == EGOOPullRefreshPulling && scrollView.contentOffset.y > -offsetY && scrollView.contentOffset.y < offsetTop && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_states == EGOOPullRefreshNormal && scrollView.contentOffset.y < -offsetY && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
//		if (scrollView.contentInset.top != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
//		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	if (scrollView.contentOffset.y <= - offsetY && !_loading) {
		
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(offsetY, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
	
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(offsetTop, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	[self setState:EGOOPullRefreshNormal];

}


#pragma mark -
#pragma mark Dealloc



@end
