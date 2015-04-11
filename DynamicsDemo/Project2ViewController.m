//
//  Project2ViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "Project2ViewController.h"

#define MAINWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height

@interface Project2ViewController ()<UICollisionBehaviorDelegate>
{
    NSMutableArray *_itemsArray;
    
    UIImageView *_fixedView;
    UIImageView *_imageView;
    
    UIDynamicAnimator * _animator;
    UICollisionBehavior *_collision;
    UIPushBehavior *_push;
    
    CAShapeLayer *shapeLayer;
    UILabel *_num;
}
@end

@implementation Project2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 辅助视图
    _fixedView = [[UIImageView alloc]initWithFrame:CGRectMake(MAINWIDTH/2.0-15, MAINHEIGHT-150, 30, 30)];
    _fixedView.layer.masksToBounds = YES;
    _fixedView.layer.cornerRadius = 15;
    _fixedView.backgroundColor = [UIColor redColor];
    _fixedView.layer.borderWidth = 5;
    _fixedView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.view addSubview:_fixedView];
    
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"80"]];
    _imageView.frame = CGRectMake(0, 0, 40, 40);
    _imageView.layer.cornerRadius = 20;
    _imageView.layer.masksToBounds = YES;
    _imageView.center = _fixedView.center;
    [self.view addSubview:_imageView];

    _push = [[UIPushBehavior alloc]initWithItems:@[_imageView] mode:UIPushBehaviorModeInstantaneous];
    _push.angle = 0.0;
    _push.magnitude = 0.0;
    [_animator addBehavior:_push];

    _itemsArray = [NSMutableArray array];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    for (int i = 0; i<40; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"80"]];
        imageView.frame = CGRectMake((i%5)*70, 80+(i/5)*60, 40, 40);
        [self.view addSubview:imageView];
        [_itemsArray addObject:imageView];
    }
    [_itemsArray addObject:_imageView];

    
    // 碰撞
    _collision = [[UICollisionBehavior alloc]initWithItems:_itemsArray];
    _collision.collisionMode = UICollisionBehaviorModeEverything;
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
    _num = [[UILabel alloc]initWithFrame:CGRectMake(280, 35, 30, 20)];
    _num.text = @"0";
    _num.textColor = [UIColor yellowColor];
    _num.font = [UIFont boldSystemFontOfSize:27];
    [self.view addSubview:_num];
}


#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *view = (UIView *)item;
        if (view!=_imageView) {
            view.hidden = YES;
            [_collision removeItem:item];
            _num.text = [NSString stringWithFormat:@"%zd",30-_collision.items.count];
        }
    });
}

- (void)pan:(UIGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan|| pan.state == UIGestureRecognizerStateCancelled) {
        [_collision removeItem:_imageView];
        [_animator removeBehavior:_push];
        [shapeLayer removeFromSuperlayer];
        shapeLayer = nil;
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self fire:point];
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        [_collision removeItem:_imageView];
        [self updateLine:point];
    }
}

- (void)fire:(CGPoint)point{
    
    [shapeLayer removeFromSuperlayer];
    shapeLayer = nil;
    
    CGPoint origin = _fixedView.center;
    
    CGFloat distance = sqrtf(powf(origin.x-point.x, 2.0)+powf(origin.y-point.y, 2.0));
    
    CGFloat angle = atan2(origin.y-point.y, origin.x-point.x);
    
    distance = MAX(distance, 10.0);
    
    // icon位置离中心越远拉力越大
    _push = [[UIPushBehavior alloc]initWithItems:@[_imageView] mode:UIPushBehaviorModeInstantaneous];
    [_push setMagnitude:distance/10.0];
    [_push setAngle:angle];
    [_push setActive:YES];
    [_animator addBehavior:_push];
    
    [_collision addItem:_imageView];
}


- (void)updateLine:(CGPoint)point
{
    _imageView.center = point;
    
    if (shapeLayer == nil) {
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.lineDashPattern = @[@5, @5];
        shapeLayer.strokeColor = [UIColor yellowColor].CGColor;
        shapeLayer.strokeEnd = 1.0f;
        [self.view.layer addSublayer:shapeLayer];
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:point];
    [bezierPath addLineToPoint:_fixedView.center];
    shapeLayer.path = bezierPath.CGPath;
}
@end
