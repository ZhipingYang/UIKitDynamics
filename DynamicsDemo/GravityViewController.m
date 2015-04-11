//
//  GravityViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()
{
    UIImageView * uTang;
    
    UIDynamicAnimator * _animator;
}
@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    uTang = [[UIImageView alloc] initWithFrame:CGRectMake(140,100, 80, 80)];
    uTang.image = [UIImage imageNamed:@"80"];
    [self.view addSubview:uTang];

    // 引擎载体
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)pan
{
    [_animator removeAllBehaviors];
    
    uTang.center = [pan locationInView:self.view];
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        [self addGravity];
    }
}

- (void)addGravity{
    // 重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[uTang]];
    [_animator addBehavior:gravity];
}

@end
