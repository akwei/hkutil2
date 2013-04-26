//
//  HKUtilCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKUtilCtrl.h"
#import "HKDataUtil.h"
#import "HKWorkUtil.h"

@implementation HKUtilCtrl{
    HKWorkUtil* _workUtil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _workUtil = [[HKWorkUtil alloc] init];
    NSString* text = @" 你好 ";
    NSString* rtext = [HKDataUtil trim:text];
    if ([rtext length]!=2) {
        NSLog(@"trim error");
    }
    NSString* enc_text = [HKDataUtil encodeURL:text];
    NSString* dec_text = [HKDataUtil decodeURL:enc_text];
    if (![dec_text isEqualToString:text]) {
        NSLog(@"encodeURL or decodeURL error");
    }
    NSString* r = [HKDataUtil integerToStringValue:99];
    NSLog(@"integerToStringValue : %@",r);
    
    CGSize size = self.label_tip.bounds.size;
    self.label_tip.frame = CGRectMake(0, 0, size.width, -size.height);
    [self.view addSubview:self.label_tip];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabel_tip:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1 animations:^{
        CGPoint dest = CGPointMake(self.label_tip.frame.origin.x, 0 );
        CGSize size = self.label_tip.frame.size;
        self.label_tip.frame = CGRectMake(dest.x, dest.y, size.width, size.height);
    } completion:^(BOOL finished) {
        NSLog(@"end animation");
        [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionTransitionNone animations:^{
            CGPoint dest = CGPointMake(self.label_tip.frame.origin.x, -self.label_tip.bounds.size.height );
            CGSize size = self.label_tip.frame.size;
            self.label_tip.frame = CGRectMake(dest.x, dest.y, size.width, size.height);
        } completion:nil];
    }];
}


@end
