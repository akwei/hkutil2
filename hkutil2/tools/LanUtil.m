//
//  LanUtil.m
//  huoku_paidui
//
//  Created by 伟 袁 on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LanUtil.h"

static LanUtil* lanUtil=nil;
@implementation LanUtil
static NSString *sysloc = @"zh-Hans";

+(LanUtil *)instance{
    if (!lanUtil) {
        lanUtil=[[LanUtil alloc] init];
    }
    return lanUtil;
}

+(void)setSysLoc:(NSString *)loc{
    @synchronized([LanUtil class]){
        sysloc=nil;
        sysloc=loc;     
    }
}

-(NSString*)localWithKey:(NSString *)key comment:(NSString *)comment{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable"
                                                     ofType:@"strings"                                                       
                                                inDirectory:nil
                                            forLocalization:sysloc];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *str = [dict objectForKey:key];
    if (str) {
        return str;
    }
    return key;
}

@end
