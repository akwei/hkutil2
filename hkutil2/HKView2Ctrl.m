//
//  HKView2Ctrl.m
//  hkutil2
//
//  Created by akwei on 13-4-23.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKView2Ctrl.h"
#import "HKURLImageView.h"

@interface HKView2Ctrl ()
@property(nonatomic)NSMutableArray* list;
@end

@implementation HKView2Ctrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.list = [[NSMutableArray alloc] init];
    for (int i=0; i<6; i++) {
        NSString* url = [[NSString alloc] initWithFormat:@"http://aktest0.b0.upaiyun.com/img%d.jpg_600x400",i];
        [self.list addObject:url];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMytable:nil];
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cid = @"cid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cid];
    HKURLImageView* imgView = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.frame = CGRectMake(0, 0, 320, 320);
        imgView = [[HKURLImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
        imgView.tag = 1;
        imgView.timeout = 10;
        [cell addSubview:imgView];
    }
    else{
        imgView = (HKURLImageView*)[cell viewWithTag:1];
    }
    NSString* url = [self.list objectAtIndex:indexPath.row];
    [imgView loadFromUrl:url onErrorBlock:nil];
    return cell;
}

@end
