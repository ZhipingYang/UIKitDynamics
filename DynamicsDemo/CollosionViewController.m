//
//  CollosionViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "CollosionViewController.h"

@interface CollosionViewController ()
{
    UIImageView * uTang;
    UIImageView * uTang2;
    
    UIDynamicAnimator * _animator;
}
@end

@implementation CollosionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    
    uTang = [[UIImageView alloc] initWithFrame:CGRectMake(100,50, 80, 80)];
    uTang.image = [UIImage imageNamed:@"80"];
    uTang2.transform = CGAffineTransformRotate(uTang2.transform, -M_PI_4/2.0);
    [self.view addSubview:uTang];
    
    uTang2 = [[UIImageView alloc] initWithFrame:CGRectMake(150,20, 80, 80)];
    uTang2.image = [UIImage imageNamed:@"80"];
    uTang2.transform = CGAffineTransformRotate(uTang2.transform, M_PI_4);
    [self.view addSubview:uTang2];
    
    [self addBehavior];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)pan
{
    [_animator removeAllBehaviors];
    
    uTang.center = [pan locationInView:self.view];
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        [self addBehavior];
    }
}

- (void)addBehavior{
    // 重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[uTang,uTang2]];
    [_animator addBehavior:gravity];
    
    // 碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[uTang,uTang2]];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionDelegate = nil;//delegate自己看
    [_animator addBehavior:collision];
}


@end
