//
//  HKExceptionCtrl.m
//  hkutil2
//
//  Created by akwei on 13-5-3.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKExceptionCtrl.h"

@interface HKExceptionCtrl ()

@end

@implementation HKExceptionCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    @try {
        [ExceptionService testEx];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",[exception description]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ExceptionService

+(void)testEx{
    ExceptionService* svr = [[ExceptionService alloc] init];
    NSString* mockText;
    NSString* atext;
    @try {
        mockText = [NSString stringWithFormat:@"%@",@"abcd"];
        atext = [self checkEx];
        [svr doSomething];
        NSLog(@"atext:%@",atext);
    }
    @finally {
        svr = nil;
        mockText = nil;
    }
    
}

+(NSString*)checkEx{
    NSException* ex;
    NSString* text ;
    @try {
        text = [[NSString alloc] initWithFormat:@"%@",@"text_abcd"];
        ex = [NSException exceptionWithName:@"test title" reason:@"test reason" userInfo:nil];
//        @throw ex;
        return text;
    }
    @finally {
        ex = nil;
        text = nil;
    }
}

-(void)doSomething{
    NSLog(@"doSomething");
}

@end
