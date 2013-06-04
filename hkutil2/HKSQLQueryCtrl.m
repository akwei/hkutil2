//
//  HKSQLQueryCtrl.m
//  hkutil2
//
//  Created by akwei on 13-4-27.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKSQLQueryCtrl.h"
#import "HKSQLQuery.h"
#import "HKTimeUtil.h"


@implementation Person
+(NSString *)currentDbName{
    return @"hkutil2.sqlite";
}
@end

@interface HKSQLQueryCtrl ()

@end

@implementation HKSQLQueryCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    /*
    HKSQLQuery* query = [HKSQLQuery sqlQueryWithDbName:@"hkutil2.sqlite"];
    Person* obj = [[Person alloc] init];
    obj.name =@"akweiweiwei";
    obj.createtime = [HKTimeUtil nowDoubleDate];
    NSString* text = @"我来测试看看有没有问题    对了    aaa bbb";
    obj.data = [text dataUsingEncoding:NSUTF8StringEncoding];
    obj.pid = [query insertWithSQL:@"insert into Person(pid,name,data,createtime) values(?,?,?,?)"
                  params:@[[NSNull null],obj.name,obj.data,[NSNumber numberWithDouble:obj.createtime]]];
    NSLog(@"insert person pid : %llu",(unsigned long long)obj.pid);
    
    [query updateWithSQL:@"update Person set name=? where pid=?" params:@[@"apple",[NSNumber numberWithUnsignedInteger:obj.pid]]];
    
    NSInteger count = [query countWithSQL:@"select count(*) from Person" params:nil];
    NSLog(@"current count : %lu",(unsigned long)count);
    
    NSArray* list = [query listWithSQL:@"select * from Person" params:nil];
    if ([list count]!=count) {
        NSLog(@"select count not equal list size");
    }
    
    [query updateWithSQL:@"delete from Person where pid=?" params:@[[NSNumber numberWithUnsignedInteger:obj.pid]]];
     */
    
    Person* obj = [[Person alloc] init];
    obj.name =@"akweiweiwei";
    obj.createtime = [HKTimeUtil nowDoubleDate];
    NSString* text = @"我来测试看看有没有问题    对了    aaa bbb";
    obj.data = [text dataUsingEncoding:NSUTF8StringEncoding];
    [obj saveObj];
    NSLog(@"insert person pid : %llu",(unsigned long long)obj.pid);
    
    obj.name=@";sdfsdf";
    [obj updateObj];
    
    [obj deleteObj];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
