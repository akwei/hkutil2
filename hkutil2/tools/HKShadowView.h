//
//  HKShadowView.h
//  hkutil2
//
//  Created by akwei on 13-4-23.
//  Copyright (c) 2013年 huoku. All rights reserved.
//
/*
 
 */
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface HKShadowView : UIView

-(id)initWithParentView:(UIView*)parentView;
-(void)changeShadowColor:(UIColor *)shadowColor;
-(void)showView:(UIView*)view completeBlock:(void (^)(void))block animation:(CAAnimation*)animation;
-(void)closeViewWithCompleteBlock:(void (^)(void))block delay:(NSTimeInterval)delay animation:(CAAnimation*)animation;
-(void)showView:(UIView*)view completeBlock:(void (^)(void))block animated:(BOOL)animated;
-(void)closeViewWithCompleteBlock:(void (^)(void))block delay:(NSTimeInterval)delay animated:(BOOL)animated;

@end
