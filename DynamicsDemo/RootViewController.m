//
//  RootViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "RootViewController.h"
#import "GravityViewController.h"
#import "CollosionViewController.h"
#import "AttachmentViewController.h"
#import "SnapViewController.h"
#import "PushViewController.h"
#import "Project1ViewController.h"
#import "Project2ViewController.h"
#import "Project3ViewController.h"

@interface RootViewController ()<UITableViewDelegate,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RootViewController{
    NSArray *titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UIKit Dynamics";
    
    _myTableView.tableFooterView = [UIView new];
    
    titleArray = @[@[@"重力 - UIGravityBehavior",@"碰撞 - UICollisionBehavior",
                     @"连接 - UIAttachmentBehavior",@"弹簧 - UIAttachmentBehavior",
                     @"吸附 - UISnapBehavior",@"推力 - UIPushBehavior"],
                   @[@"项目一：串珠",@"简易游戏：消除",@"简易游戏：flappy（待完善）"]];
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    label.text = section==0?@"基础篇":@"实战篇-简易";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc;
    if (indexPath.section) {
        switch (indexPath.row) {
            case 0:
                vc = [[Project1ViewController alloc]init];
                break;
            case 1:
                vc = [[Project2ViewController alloc]init];
                break;
            case 2:
                vc = [[Project3ViewController alloc]init];
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                vc = [[GravityViewController alloc]init];
                break;
            case 1:
                vc = [[CollosionViewController alloc]init];
                break;
            case 2:
            case 3:
                vc = [[AttachmentViewController alloc]init];
                [(AttachmentViewController *)vc setTangHuang:indexPath.row==3];
                break;
            case 4:
                vc = [[SnapViewController alloc]init];
                break;
            case 5:
                vc = [[PushViewController alloc]init];
                break;
                
            default:
                break;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
