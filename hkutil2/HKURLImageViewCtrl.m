//
//  HKURLImageViewCtrl.m
//  hkutil2
//
//  Created by akwei on 13-7-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import "HKURLImageViewCtrl.h"
#import "HKURLImageView.h"
#import "UIView+HKEx.h"

@implementation HKURLImageViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.datalist = [[NSMutableArray alloc] init];
    self.tableView_my.delegate = self;
    self.tableView_my.dataSource = self;
    self.tableView_my.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397877/397877_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397878/397878_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397879/397879_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397880/397880_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397881/397881_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397882/397882_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397883/397883_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397884/397884_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397885/397885_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397886/397886_h.jpg"];
    [self.datalist addObject:@"http://pic2.bosee.cn/pic3/2013/7/23/000/005/664/397887/397887_h.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView_my:nil];
    [super viewDidUnload];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datalist count];
//    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cid = @"cid";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HKURLImageView* imgview = [[HKURLImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 200)];
        imgview.backgroundColor = [UIColor lightGrayColor];
        imgview.loadingStyle = UIActivityIndicatorViewStyleWhiteLarge;
        imgview.isCanShowLoading = NO;
        imgview.tag = 1;
        [cell addSubview:imgview];
    }
    HKURLImageView* imgview = (HKURLImageView*)[cell viewWithTag:1];
    NSString* url = [self.datalist objectAtIndex:indexPath.row];
    [imgview loadFromUrl:url onErrorBlock:nil];
    return cell;
}


@end




