//
//  AttachmentViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "AttachmentViewController.h"

@interface AttachmentViewController ()
{
    UIImageView * uTang;
    
    UIDynamicAnimator * _animator;
    
    UIAttachmentBehavior *_attach;
    
    UIImageView *kongImageView;
    
    CAShapeLayer *shapeLayer;
}
@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    uTang = [[UIImageView alloc] initWithFrame:CGRectMake(100,100, 80, 80)];
    uTang.image = [UIImage imageNamed:@"80"];
    [self.view addSubview:uTang];
    
    kongImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AttachmentPoint_Mask"]];
    kongImageView.frame = CGRectMake(0, 0, 10, 10);
    kongImageView.center = CGPointMake(uTang.bounds.size.width / 2 - 30, uTang.bounds.size.height / 2 - 30);
    kongImageView.backgroundColor = [UIColor lightGrayColor];
    kongImageView.layer.borderWidth = 2;
    kongImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    kongImageView.layer.cornerRadius = 5;
    kongImageView.layer.masksToBounds = YES;
    [uTang addSubview:kongImageView];

    // 设置观察者，在手指离开以后继续画线
    [uTang addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];

    //重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[uTang]];
    [_animator addBehavior:gravity];
    
    // 连接
    _attach = [[UIAttachmentBehavior alloc]initWithItem:uTang offsetFromCenter:UIOffsetMake(-30, -30) attachedToAnchor:CGPointMake(CGRectGetMidX(self.view.bounds), 120)];
    _attach.length = _tangHuang?60:120;
    
    // 弹簧效果
    _attach.damping = 0.1;
    _attach.frequency = _tangHuang?0.6:0;
    [_animator addBehavior:_attach];

    // 碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[uTang]];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:collision];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];
    [_attach setAnchorPoint:point];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self updateLine];
}

- (void)updateLine
{
    if (shapeLayer == nil) {
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineWidth = 3.0f;
        shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
        shapeLayer.strokeEnd = 1.0f;
        [self.view.layer addSublayer:shapeLayer];
    }

    CGPoint p = [self.view convertPoint:kongImageView.center fromView:uTang];

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:_attach.anchorPoint];
    [bezierPath addLineToPoint:p];
    shapeLayer.path = bezierPath.CGPath;
}

- (void)dealloc{
    [uTang removeObserver:self forKeyPath:@"center"];
}
@end
