//
//  UrlImageButton.m
//  test image
//
//  Created by Xuyan Yang on 8/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UrlImageButton.h"
#import "SDWebImageManager.h"
#import "NSURLAdditions.h"
#import <QuartzCore/QuartzCore.h>
@implementation UrlImageButton

@synthesize iconIndex;
@synthesize animated = _animated;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		iconIndex = -1;

		isScale = NO;
	}
    return self;
}

- (void)setImage:(BOOL)animated withUrl:(NSString *)iconUrl withIsBkg:(BOOL)isBkg
{       
	_animated = animated;
	_isBackgroundImage = isBkg;
	
	if(isBkg)
	{
		[self setBackgroundImage:[self getDefaultImage] forState:UIControlStateNormal];
	}
	else {
		[self setImage:[self getDefaultImage] forState:UIControlStateNormal];
	}

	NSURL* tempUrl = [NSURL URLWithString:iconUrl];
	
	NSURL* finallyUrl = nil;
	if([NSURL isWebURL:tempUrl])
	{
		finallyUrl = tempUrl;
	}
	else {
		//SingletonState* mySingle = [SingletonState sharedStateInstance];
		//finallyUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", mySingle.letaoConstants.imageHostName, iconUrl]];
		finallyUrl = tempUrl;
	}
	
	[self setImageWithURL:finallyUrl placeholderImage:[self getDefaultImage]];
}	

- (void) setBackgroundImageFromUrl:(BOOL)animated withUrl:(NSString *)iconUrl
{       
	[self setImage:animated withUrl:iconUrl withIsBkg:YES];
}	

- (void) setImageFromUrl:(BOOL) animated withUrl:(NSString *)iconUrl
{
	[self setImage:animated withUrl:iconUrl withIsBkg:NO];
}	

	
- (void)setImageWithURL:(NSURL *)url
{
	[self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
	SDWebImageManager *manager = [SDWebImageManager sharedManager];
	
    // Remove in progress downloader from queue
//    [manager cancelForDelegate:self];
	
    [self setImage:placeholder forState:UIControlStateNormal];
    if (url)
    {
        [manager downloadWithURL:url options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
        {
            if (finished && image) {
                [self webImageManager:manager didFinishWithImage:image];
            }
        }];
    }
}

- (void)cancelCurrentImageLoad
{
//	[[SDWebImageManager sharedManager] cancelForDelegate:self];
}

//todo:zj这段代码统统改掉
-(UIImage*) getDefaultImage
{
//	CGSize frameSize = self.frame.size;
    return  [UIImage  imageNamed:@"loding.png"];
}

#pragma mark -
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
	if(_animated)
	{
		/*
	    [UIView beginAnimations:nil context:nil];
	    [UIView setAnimationDuration:0.5];
	    //[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:YES];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
	*/
	}
	
	if(_isBackgroundImage)
	{
	    [self setBackgroundImage:image forState:UIControlStateNormal];
	}
	else {
		[self setImage:image forState:UIControlStateNormal];
	}

	if(_animated)
	{
		//[UIView commitAnimations];
		CATransition *animation = [CATransition animation];
		[animation setDuration:0.9f];   
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
		[animation setType:kCATransitionFade];
		[animation setSubtype: kCATransitionFromBottom];
		[self.layer addAnimation:animation forKey:@"Reveal"];
	}
}

@end
