//
//  MoreViewController.m
//  Voyage
//
//  Created by 王俊 on 14-4-13.
//  Copyright (c) 2014年 王俊. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchAction:(id)sender
{
    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [userdefaults setBool:isButtonOn forKey:@"isButtonOn"];
}


#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    NSString *icon = @"";
    NSString *strtitle=@"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                icon = @"";
                strtitle = @"软件版本";
                UILabel *lbnum = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 65, 45)];
                lbnum.text= [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleVersionKey];
                lbnum.font=[UIFont systemFontOfSize:13];
                lbnum.textColor = [UIColor redColor];
                lbnum.textAlignment = NSTextAlignmentRight;
                [cell addSubview:lbnum];
                lbnum.backgroundColor = [UIColor clearColor];
            }
                break;
            case 1:
            {
                icon = @"";
                strtitle = @"检查版本";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
               break;
            case 2:
            {
                icon = @"";
                strtitle = @"自动检查版本";
                NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
                UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(250, 10, 70.0f, 28.0f)];
                switchView.on = [userdefaults boolForKey:@"isButtonOn"];
                [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:switchView];
            }
               break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                icon = @"";
                strtitle = @"关于我们";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 1:
            {
                icon = @"";
                strtitle = @"购票须知";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            }
                break;
            case 2:
            {
                icon = @"";
                strtitle = @"用户指南";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
        }
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@", strtitle];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
        }
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
        }
    }
}





@end
