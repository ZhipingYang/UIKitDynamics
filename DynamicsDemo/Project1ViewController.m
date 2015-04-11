//
//  Project1ViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "Project1ViewController.h"

@interface Project1ViewController ()
{
    NSMutableArray *_array;
    
    UIDynamicAnimator * _animator;

    UIAttachmentBehavior *_attach;
}
@end

@implementation Project1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    _array = [NSMutableArray array];
    
    for (int i=0; i<6; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"80"]];
        imageView.frame = CGRectMake(i*60, 200, 30, 30);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 15;
        [self.view addSubview:imageView];
        [_array addObject:imageView];
    }
    
    //物体属性
    UIDynamicItemBehavior *itemsBehavior = [[UIDynamicItemBehavior alloc]initWithItems:_array];
    itemsBehavior.angularResistance = 0.6;
    itemsBehavior.density = 10;
    itemsBehavior.elasticity = 0.6;
    itemsBehavior.friction = 0.3;
    itemsBehavior.resistance = 0.3;
    [_animator addBehavior:itemsBehavior];
    
    //重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:_array];
    [_animator addBehavior:gravity];
    
    //碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:_array];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collision];
    
    //约束
    _attach = [[UIAttachmentBehavior alloc]initWithItem:[_array firstObject] attachedToAnchor:[[_array firstObject] center]];
    _attach.anchorPoint = CGPointMake(150, 80);
    _attach.length = 35;
    _attach.damping = 1;
    _attach.frequency = 3;
    [_animator addBehavior:_attach];
    
    for (int i=1; i<_array.count; i++) {
        UIView *view = _array[i];
        UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc]initWithItem:view attachedToItem:_array[i-1]];
        attach.length = 35;
        attach.damping = 1;
        attach.frequency = 3;
        [_animator addBehavior:attach];
    }

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)pan
{
    if (![_animator.behaviors containsObject:_attach]) {
        [_animator addBehavior:_attach];
    }
    CGPoint point = [pan locationInView:self.view];
    [_attach setAnchorPoint:point];
    
    if (pan.state==UIGestureRecognizerStateEnded) {
        [_animator removeBehavior:_attach];
    }
}

//-(void)viewDidLayoutSubviews
//{
//    for (int i=1; i<_array.count; i++) {
//        UIView *view = _array[i];
//        UIView *view2 = _array[i-1];
//        [self addLineView:view point:view.center point:view2.center];
//    }
//}

//- (void)addLineView:(UIView *)view point:(CGPoint)point point:(CGPoint)point2
//{
//    for (CALayer *layer in view.layer.sublayers) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeFromSuperlayer];
//            break;
//        }
//    }
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
//    shapeLayer.lineJoin = kCALineJoinRound;
//    shapeLayer.lineWidth = 3.0f;
//    shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
//    shapeLayer.strokeEnd = 1.0f;
//    [view.layer addSublayer:shapeLayer];
//    
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    [bezierPath moveToPoint:point];
//    [bezierPath addLineToPoint:point2];
//    shapeLayer.path = bezierPath.CGPath;
//}

@end
