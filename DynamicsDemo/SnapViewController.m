//
//  SnapViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "SnapViewController.h"

@interface SnapViewController ()
{
    UIImageView * uTang;
    
    UIDynamicAnimator * _animator;
}
@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    uTang = [[UIImageView alloc] initWithFrame:CGRectMake(100,200, 80, 80)];
    uTang.image = [UIImage imageNamed:@"80"];
    [self.view addSubview:uTang];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];

    if (pan.state == UIGestureRecognizerStateBegan|| pan.state == UIGestureRecognizerStateCancelled) {
        [_animator removeAllBehaviors];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self dealTheEdge:point];
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        uTang.center = point;
    }
}

- (void)dealTheEdge:(CGPoint)point
{
    CGSize size = self.view.frame.size;
    
    CGFloat lead = point.x;
    CGFloat tail = size.width - point.x;
    CGFloat bottom = size.height-point.y;
    
    CGFloat edge = uTang.frame.size.width/2.0;
    
    CGPoint newPoint;
    
    if (lead<tail) {
        if (lead<bottom) {
            newPoint = CGPointMake(edge, point.y);
        }else{
            newPoint = CGPointMake(point.x, size.height-edge);
        }
    }else{
        if (tail<bottom) {
            newPoint = CGPointMake(size.width-edge, point.y);
        }else{
            newPoint = CGPointMake(point.x, size.height-edge);
        }
    }
    
    UISnapBehavior *snap = [[UISnapBehavior alloc]initWithItem:uTang snapToPoint:newPoint];
    snap.damping = 0.55f;
    [_animator addBehavior:snap];
}

@end
