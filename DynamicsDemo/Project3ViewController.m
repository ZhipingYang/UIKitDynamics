//
//  Project3ViewController.m
//  DynamicsDemo
//
//  Created by XcodeYang on 15/4/10.
//  Copyright (c) 2015年 XcodeYang. All rights reserved.
//

#import "Project3ViewController.h"

#define MAINWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height

@interface Project3ViewController ()<UICollisionBehaviorDelegate,UIAlertViewDelegate>
{
    UIImageView *_imageView;
    
    UIDynamicAnimator * _animator;
    UIPushBehavior *_push;
    UIGravityBehavior *_gravity;
    
    int num;
    NSMutableArray *_viewArray;
    NSTimer *_timer;
    UILabel *_num;
}
@end

@implementation Project3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    num=0;
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"80"]];
    _imageView.frame = CGRectMake(140, 80, 40, 40);
    _imageView.layer.cornerRadius = 20;
    _imageView.layer.masksToBounds = YES;
    [self.view addSubview:_imageView];
    
    _num = [[UILabel alloc]initWithFrame:CGRectMake(280, 35, 30, 20)];
    _num.text = @"0";
    _num.textColor = [UIColor yellowColor];
    _num.font = [UIFont boldSystemFontOfSize:27];
    [self.view addSubview:_num];

//    int randomHeight = MAINHEIGHT-100.0;
//    UIView *upView = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH, 0, 50, MAX(50, arc4random()%randomHeight))];
//    upView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:upView];
//    
//    int height = MAINHEIGHT - upView.frame.size.height - 100;
//    UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(MAINWIDTH, MAINHEIGHT-height, 50, height)];
//    downView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:downView];
    
//    _viewArray = [NSMutableArray arrayWithObjects:upView,downView, nil];
//    [self addTimer];
    [self add];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_push setActive:NO];
    [_animator removeBehavior:_push];
    [_animator removeBehavior:_gravity];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _gravity = [[UIGravityBehavior alloc]initWithItems:@[_imageView]];
    _gravity.magnitude = 3;
    [_animator addBehavior:_gravity];
    
    _push = [[UIPushBehavior alloc]initWithItems:@[_imageView] mode:UIPushBehaviorModeInstantaneous];
    [_push setMagnitude:20];
    [_push setAngle:-M_PI_2];
    [_push setActive:YES];
    [_animator addBehavior:_push];
    NSInteger num = [_num.text integerValue];
    _num.text = [NSString stringWithFormat:@"%zd",++num];
}

- (void)tap:(UIGestureRecognizer *)tap
{

    if (tap.state == UIGestureRecognizerStateEnded) {
    }
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_animator removeAllBehaviors];
        if (num==0) {
            NSString *message = [NSString stringWithFormat:@"游戏结束,总分%@",_num.text];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再来一次", nil];
            [alert show];
        }
        num ++;
    });
    self.view.userInteractionEnabled = NO;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex!=buttonIndex) {
        //paly again
        _imageView.frame = CGRectMake(140, 80, 40, 40);
        [self add];
        _num.text = @"0";
        num = 0;
        self.view.userInteractionEnabled = YES;
    }else{
        self.view.userInteractionEnabled = NO;
    }
}

- (void)add{
    //物体属性
    UIDynamicItemBehavior *itemsBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[_imageView]];
    itemsBehavior.angularResistance = 0;
    itemsBehavior.density = 10;
    itemsBehavior.elasticity = 0.6;
    itemsBehavior.friction = 1;
    itemsBehavior.resistance = 1;
    [_animator addBehavior:itemsBehavior];
    
//    NSMutableArray *array = [_viewArray mutableCopy];
//    [array addObject:_imageView];
    UICollisionBehavior *_collision = [[UICollisionBehavior alloc]initWithItems:@[_imageView]];
    _collision.collisionMode = UICollisionBehaviorModeEverything;
    _collision.translatesReferenceBoundsIntoBoundary = YES;
    _collision.collisionDelegate = self;
    [_animator addBehavior:_collision];
    
    _gravity = [[UIGravityBehavior alloc]initWithItems:@[_imageView]];
    _gravity.magnitude = 0.5;
    [_animator addBehavior:_gravity];
}

- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void) deleteTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)moveView{
    for (UIView *view in _viewArray) {
        CGRect frame = view.frame;
        frame.origin.x --;
        if (frame.origin.x<-50) {
            frame.origin.x = MAINWIDTH;
        }
        view.frame = frame;
    }
}
@end
