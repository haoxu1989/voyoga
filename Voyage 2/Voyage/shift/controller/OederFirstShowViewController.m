//
//  OederFirstShowViewController.m
//  365CarCard
//
//  Created by 郝旭 on 13-4-1.
//  Copyright (c) 2013年 郝旭. All rights reserved.
//

#import "OederFirstShowViewController.h"
#import "Constants.h"
#import "AlertHelper.h"

@interface OederFirstShowViewController ()

@end

@implementation OederFirstShowViewController
@synthesize listArray;
@synthesize listTab;
@synthesize deleteBtn;
@synthesize titleLabel;
@synthesize mainView;
@synthesize orderFirseDele;
@synthesize banciTimeSer;
@synthesize senddate;
@synthesize bliid;
@synthesize linid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    banciTimeSer = [GetBanciTimeService sharedServiceBase];
    banciTimeSer.delegate = self;
    [banciTimeSer getTimeListByDate:self.senddate Bybliid:self.bliid Bylinid:self.linid];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([banciTimeSer.banciList count] == 0) {
        [banciTimeSer getTimeListByDate:self.senddate Bybliid:self.bliid Bylinid:self.linid];
    }
}

- (IBAction)deleteBtn:(id)sender{
    [self.view removeFromSuperview];
}


#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier2 = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
    cell.textLabel.left = 0;
    cell.textLabel.width = 320;
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    BanciModel *banci = [listArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:banci.prtTime];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (orderFirseDele && [orderFirseDele respondsToSelector:@selector(cellDidSelected:)]) {
        [orderFirseDele cellDidSelected:[listArray objectAtIndex:indexPath.row]];
    }
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    banciTimeSer.delegate = nil;
}

- (void)netServiceStarted:(enum AHServiceHandle)handle{
    [self.view showLoadingHudWithMessage:LOADINGMESSGE];
}

-(void)netServiceFinished:(enum AHServiceHandle)handle{
    self.listArray = banciTimeSer.banciList;
    [listTab reloadData];
    [self.view hideLoadingHud];
}

- (void)netServiceError:(enum AHServiceHandle)handle errorCode:(int)errorCode errorMessage:(NSString *)errorMessage{
    [self.view hideLoadingHud];
}

@end
