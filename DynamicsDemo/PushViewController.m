//
//  PushViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()
{
    UIImageView * uTang;
    
    UIDynamicAnimator * _animator;
    
    UIPushBehavior *_push;
    
    CAShapeLayer *shapeLayer;
}
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    uTang = [[UIImageView alloc] initWithFrame:CGRectMake(100,200, 40, 40)];
    uTang.transform = CGAffineTransformRotate(uTang.transform, M_PI_4/2.0);
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
        [shapeLayer removeFromSuperlayer];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self fire:point];
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self updateLine:point];
    }
}

- (void)fire:(CGPoint)point{
    
    [shapeLayer removeFromSuperlayer];
    shapeLayer = nil;
    
    CGPoint origin = self.view.center;
    
    CGFloat distance = sqrtf(powf(origin.x-point.x, 2.0)+powf(origin.y-point.y, 2.0));
    
    CGFloat angle = atan2(origin.y-point.y, origin.x-point.x);
    
    distance = MAX(distance, 10.0);
    
    // icon位置离中心越远拉力越大
    _push = [[UIPushBehavior alloc]initWithItems:@[uTang] mode:UIPushBehaviorModeInstantaneous];
    [_push setMagnitude:distance/40.0];
    [_push setAngle:angle];
    [_push setActive:YES];
    [_animator addBehavior:_push];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[uTang]];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collision];
}


- (void)updateLine:(CGPoint)point
{
    uTang.center = point;

    if (shapeLayer == nil) {
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineWidth = 3.0f;
        shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
        shapeLayer.strokeEnd = 1.0f;
        [self.view.layer addSublayer:shapeLayer];
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point];
    [bezierPath addLineToPoint:self.view.center];
    shapeLayer.path = bezierPath.CGPath;
}


@end
