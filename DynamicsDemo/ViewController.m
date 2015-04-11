//
//  ViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 4/2/15.
//  Copyright (c) 2015 XcodeYang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
{
    UIImageView * apple;
    UIDynamicAnimator * _animator;
    UIAttachmentBehavior *_attach;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    apple = [[UIImageView alloc] initWithFrame:CGRectMake(100,40, 80, 80)];
    apple.backgroundColor = [UIColor redColor];
    [self.view addSubview:apple];
    
    UIView * pear = [[UIView alloc] initWithFrame:CGRectMake(270,40, 40, 40)];
    pear.backgroundColor = [UIColor greenColor];
    [self.view addSubview:pear];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[pear]];
                                  [_animator addBehavior:gravity];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]initWithItems:@[apple,pear]];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    collision.translatesReferenceBoundsIntoBoundary = YES;
    collision.collisionDelegate = self;
    [_animator addBehavior:collision];
    
    
    CGPoint appleCenter = apple.center;
    _attach = [[UIAttachmentBehavior alloc]initWithItem:pear attachedToAnchor:appleCenter];
    _attach.damping = 0.2;
    _attach.frequency = 0.8;
    [_animator addBehavior:_attach];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.view];
    [_attach setAnchorPoint:point];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      beganContactForItem:(id <UIDynamicItem>)item1
                 withItem:(id <UIDynamicItem>)item2
                  atPoint:(CGPoint)p
{
    
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item1
                 withItem:(id <UIDynamicItem>)item2
{
    
}



@end
