//
//  HKShadowCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-23.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKShadowCtrl.h"

#define kBlockKey @"block"
#define kAnimationKey @"animation"
#define kCloseAni @"closeAni"
#define HKShaodCtrlDebug 0

@interface HKShadowCtrl ()
@property(nonatomic,strong)NSMutableArray* viewControllers;
@property(nonatomic,strong)UIView* shadow;//作用是渐变式弹出阴影层，不收view切换影响
@property(nonatomic,strong)UIView* hkViewContainer;
@property(nonatomic,assign)CGRect viewFrame;
@property(nonatomic,strong)UIView* parent;
@property(nonatomic,assign)NSTimeInterval animationTime;//动画持续时间
@property(nonatomic,copy)NSString* forwardType;
@property(nonatomic,copy)NSString* backwardType;
@property(nonatomic,copy)NSString* forwardSubType;
@property(nonatomic,copy)NSString* backwardSubType;
@property(nonatomic,strong)UIColor* shadowColor;
@end

@implementation HKShadowCtrl{
    BOOL animating;
}

-(id)initWithParentView:(UIView *)parent{
    self = [super init];
    if (self) {
        animating = NO;
        self.viewControllers=[[NSMutableArray alloc] init];
        self.parent=parent;
        CGRect parentFrame = parent.frame;
        self.viewFrame = CGRectMake(0, 0, parentFrame.size.width, parentFrame.size.height);
        self.animationTime=.5;
        self.forwardType = kCATransitionPush;
        self.forwardSubType = kCATransitionFromRight;
        self.backwardType = kCATransitionPush;
        self.backwardSubType = kCATransitionFromLeft;
        self.closeType = kCATransitionFade;
    }
    return self;
}

-(id)init{
    return nil;
}

-(void)loadView{
    [super loadView];
    animating=NO;
    UIColor* clearColor = [UIColor clearColor];
    if (!self.shadowColor) {
        self.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    }
    CGRect rect = self.viewFrame;
    self.view.frame = rect;
    self.view.backgroundColor=clearColor;
    self.view.clipsToBounds=YES;
    [self.parent addSubview:self.view];
    UIViewAutoresizing defViewAutoresizing = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    CGRect cFrame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.shadow=[[UIView alloc] initWithFrame:cFrame];
    self.shadow.backgroundColor=self.shadowColor;
    self.shadow.alpha=0.5;
    self.shadow.autoresizesSubviews=YES;
    self.shadow.autoresizingMask=defViewAutoresizing;
    [self.view addSubview:self.shadow];
    self.hkViewContainer=[[UIView alloc] initWithFrame:cFrame];
    self.hkViewContainer.backgroundColor = self.shadowColor;
    self.hkViewContainer.autoresizingMask=defViewAutoresizing;
    self.hkViewContainer.clipsToBounds=YES;
    self.hkViewContainer.backgroundColor=clearColor;
    self.hkViewContainer.clearsContextBeforeDrawing=YES;
    [self.view addSubview:self.hkViewContainer];
    self.view.hidden=YES;
}

-(void)buildPosition{
    self.view.frame = self.parent.bounds;
}

-(void)changeShadowColor:(UIColor *)shadowColor{
    self.shadowColor = shadowColor;
    self.shadow.backgroundColor = self.shadowColor;
}

#pragma mark - push
-(void)hkPushViewController:(UIViewController<HKShadowCtrlDelegate> *)viewController animated:(BOOL)animated{
    if (![self canProcess]) {
        return;
    }
    [self hkPushViewController:viewController animated:animated onComplete:nil];
}

-(void)hkPushViewController:(UIViewController<HKShadowCtrlDelegate> *)viewController animated:(BOOL)animated onComplete:(void (^)(void))completeBlock{
    CAAnimation* tr;
    if (![self canProcess]) {
        return;
    }
    if (animated) {
        tr = [self createAnimationWithtype:self.forwardType subType:self.forwardSubType];
    }
    [self hkPushViewController:viewController animation:tr onComplete:completeBlock];
}

-(void)hkPushViewController:(UIViewController<HKShadowCtrlDelegate> *)viewController animation:(CAAnimation *)animation onComplete:(void (^)(void))completeBlock{
    if (![self doProcessing]) {
        return;
    }
    viewController.shadowCtrl=self;
    [self.viewControllers insertObject:viewController atIndex:0];
    [self showViewController:viewController animation:animation onComplete:completeBlock];
#if HKShaodCtrlDebug
    NSLog(@"current viewControllers count:%i",[self.viewControllers count]);
#endif
}

#pragma mark - popToRoot

-(NSArray *)hkPopToRootViewControllerAnimated:(BOOL)animated{
    if (![self canProcess]) {
        return nil;
    }
    return [self hkPopToRootViewControllerAnimated:animated onComplete:nil];
}

-(NSArray *)hkPopToRootViewControllerAnimated:(BOOL)animated onComplete:(void (^)(void))completeBlock{
    CAAnimation* tr;
    if (![self canProcess]) {
        return nil;
    }
    if (animated) {
        tr = [self createAnimationWithtype:self.backwardType subType:self.backwardSubType];
    }
    return [self hkPopToRootViewControllerAnimation:tr onComplete:completeBlock];
}

-(NSArray *)hkPopToRootViewControllerAnimation:(CAAnimation *)animation onComplete:(void (^)(void))completeBlock{
    if (![self canProcess]) {
        return nil;
    }
    if ([self.viewControllers count]>0) {
        UIViewController<HKShadowCtrlDelegate>* root = [self.viewControllers lastObject];
        return [self hkPopToViewController:root animation:animation onComplete:completeBlock];
        //        NSRange range=NSMakeRange(0, [self.viewControllers count]-1);
        //        return [self arrayForRemoved:range];
    }
    return nil;
}

#pragma mark - popAll

-(NSArray *)hkPopAllAndCloseAnimated:(BOOL)animated{
    CAAnimation* tr;
    if (![self canProcess]) {
        return nil;
    }
    if (animated) {
        tr = [self createAnimationWithtype:self.closeType subType:nil];
    }
    return [self hkPopAllAndCloseWithBlock:nil delay:0 animation:tr];
}

-(NSArray *)hkPopAllAndCloseWithBlock:(void (^)(void))block delay:(NSTimeInterval)delay animation:(CAAnimation *)animation{
    if (![self canProcess]) {
        return nil;
    }
    if ([self.viewControllers count]>0) {
        [self closeWithBlock:block delay:delay animation:animation];
        return [NSArray arrayWithArray:self.viewControllers];
    }
    return nil;
}

#pragma mark - popToView
-(NSArray *)hkPopToViewController:(UIViewController<HKShadowCtrlDelegate> *)viewController animated:(BOOL)animated{
    if (![self canProcess]) {
        return nil;
    }
    return [self hkPopToViewController:viewController animated:animated onComplete:nil];
}

-(NSArray *)hkPopToViewController:(UIViewController<HKShadowCtrlDelegate> *)viewController animated:(BOOL)animated onComplete:(void (^)(void))completeBlock{
    CAAnimation* tr;
    if (![self canProcess]) {
        return nil;
    }
    if (animated) {
        tr = [self createAnimationWithtype:self.backwardType subType:self.backwardSubType];
    }
    return [self hkPopToViewController:viewController animation:tr onComplete:completeBlock];
}

-(NSArray *)hkPopToViewController:(UIViewController<HKShadowCtrlDelegate> *)viewController animation:(CAAnimation *)animation onComplete:(void (^)(void))completeBlock{
    if (![self doProcessing]) {
        return nil;
    }
    [self showViewController:viewController animation:animation onComplete:completeBlock];
    NSRange range = [self rangeForRemoveViewControllers:viewController];
    return [self arrayForRemoved:range];
}

#pragma mark - popView
-(UIViewController<HKShadowCtrlDelegate> *)hkPopViewControllerAnimated:(BOOL)animated{
    if (![self canProcess]) {
        return nil;
    }
    return [self hkPopViewControllerAnimated:animated onComplete:nil];
}

-(UIViewController<HKShadowCtrlDelegate> *)hkPopViewControllerAnimated:(BOOL)animated onComplete:(void (^)(void))completeBlock{
    CAAnimation* tr;
    if (![self canProcess]) {
        return nil;
    }
    if (animated) {
        tr = [self createAnimationWithtype:self.backwardType subType:self.backwardSubType];
    }
    return [self hkPopViewControllerAnimation:tr onComplete:completeBlock];
}

-(UIViewController<HKShadowCtrlDelegate> *)hkPopViewControllerAnimation:(CAAnimation *)animation onComplete:(void (^)(void))completeBlock{
    if (![self canProcess]) {
        return nil;
    }
    if ([self.viewControllers count] <= 1) {
        [self closeWithBlock:completeBlock delay:0 animation:animation];
        return nil;
    }
    UIViewController<HKShadowCtrlDelegate>* second = [self.viewControllers objectAtIndex:1];
    UIViewController<HKShadowCtrlDelegate>* top = [self.viewControllers objectAtIndex:0];
    [self hkPopToViewController:second animation:animation onComplete:completeBlock];
    return top;
}

#pragma mark - close
-(void)closeWithAnimated:(BOOL)animated{
    if (![self canProcess]) {
        return ;
    }
    [self closeWithBlock:nil animated:animated];
}

-(void)closeWithBlock:(void (^)(void))block animated:(BOOL)animated{
    if (![self canProcess]) {
        return ;
    }
    [self closeWithBlock:block delay:0 animated:animated];
}

-(void)closeWithDelay:(NSTimeInterval)delay animated:(BOOL)animated{
    if (![self canProcess]) {
        return ;
    }
    [self closeWithBlock:nil delay:delay animated:animated];
}

-(void)closeWithBlock:(void (^)(void))block delay:(NSTimeInterval)delay animated:(BOOL)animated{
    CAAnimation* tr;
    if (![self canProcess]) {
        return ;
    }
    if (animated) {
        tr = [self createAnimationWithtype:self.closeType subType:nil];
    }
    [self closeWithBlock:block delay:delay animation:tr];
}

-(void)closeWithBlock:(void (^)(void))block delay:(NSTimeInterval)delay animation:(CAAnimation *)animation{
    if (![self canProcess]) {
        return ;
    }
    NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
    if (animation) {
        [info setValue:animation forKey:kAnimationKey];
    }
    if (block) {
        [info setValue:block forKey:kBlockKey];
    }
    if (delay <= 0) {
        [self closeWithInfo:info];
    }
    else{
        [self performSelector:@selector(closeWithInfo:) withObject:info afterDelay:delay];
    }
}

#pragma mark - private method

-(void)showViewController:(UIViewController*)viewController animation:(CAAnimation*)animation onComplete:(void (^)(void))completeBlock{
    [self showView:viewController.view];
    if (animation) {
        animation.delegate = self;
        animation.removedOnCompletion = YES;
        [animation setValue:completeBlock forKey:kBlockKey];
        [self.hkViewContainer.layer addAnimation:animation forKey:nil];
    }
    else{
        animating = NO;
    }
}

-(void)show{
    [self buildPosition];
    self.view.hidden=NO;
    [self.parent bringSubviewToFront:self.view];
}

/*
 返回删除的ViewControllers
 */
-(NSArray*)arrayForRemoved:(NSRange)range{
    if (range.length==0) {
        return nil;
    }
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    for (int i=range.location; i<range.length; i++) {
        [arr addObject:[self.viewControllers objectAtIndex:i]];
    }
    [self.viewControllers removeObjectsInRange:range];
#if HKShaodCtrlDebug
    NSLog(@"current viewControllers count:%i",[self.viewControllers count]);
#endif
    return arr;
}

//private
-(void)closeWithInfo:(NSDictionary*)info{
    if (![self doProcessing]) {
        return ;
    }
    [self clearAll];
    self.view.hidden = YES;
    CAAnimation* tr = [info valueForKey:kAnimationKey];
    void (^block)(void) = [info valueForKey:kBlockKey];
    if (tr) {
        tr.delegate = self;
        tr.removedOnCompletion = YES;
        //        [tr setValue:@true forKey:kCloseAni];
        if (block) {
            [tr setValue:block forKey:kBlockKey];
        }
        [self.view.layer addAnimation:tr forKey:nil];
    }
    else{
        if (block) {
            block();
        }
        animating=NO;
    }
}

-(BOOL)isViewShow{
    if ([[self.hkViewContainer subviews] count]>0) {
        return YES;
    }
    return NO;
}

-(BOOL)isCurrentRoot{
    if ([self.viewControllers count]==1) {
        return YES;
    }
    return NO;
}

/*
 找到需要显示的viewController的位置，返回此位置以前的范围
 */
-(NSRange)rangeForRemoveViewControllers:(UIViewController*)toViewController{
    int i=0;
    for (UIViewController* ctrl in self.viewControllers) {
        if (ctrl==toViewController) {
            NSRange range= NSMakeRange(0, i);
            return range;
        }
        i++;
    }
    return NSMakeRange(0, 0);
}

-(void)clearAll{
    NSArray* views = [self.hkViewContainer subviews];
    for (UIView* sview in views) {
        [sview removeFromSuperview];
    }
    [self clearControllers];
}

#pragma mark - animation ref
-(CAAnimation*)createAnimationWithtype:(NSString*)type subType:(NSString*)subType {
    CATransition *transition = [CATransition animation];
    transition.duration = self.animationTime;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type=type;
    transition.subtype=subType;
    transition.delegate=self;
    transition.removedOnCompletion = YES;
    return transition;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    animating = NO;
    NSNumber* n_closeAni = [anim valueForKey:kCloseAni];
    if (n_closeAni) {
        self.view.hidden = YES;
    }
    void(^block)(void) = [anim valueForKey:kBlockKey];
    if (block) {
        block();
    }
}

-(BOOL)canProcess{
    if (animating) {
        return NO;
    }
    return YES;
}

-(BOOL)doProcessing{
    if (animating) {
        return NO;
    }
    animating=YES;
    return YES;
}

-(void)showView:(UIView*)view{
    [self show];
    CGPoint centerP=self.hkViewContainer.center;
    centerP = [self.hkViewContainer convertPoint:centerP fromView:self.hkViewContainer.superview];
    view.center=centerP;
    NSArray* subViews = [self.hkViewContainer subviews];
    for (UIView* sview in subViews) {
        [sview removeFromSuperview];
    }
    [self.hkViewContainer addSubview:view];
}

-(void)clearControllers{
    [self.viewControllers removeAllObjects];
}
@end
