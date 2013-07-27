//
//  HKURLImageViewCtrl.h
//  hkutil2
//
//  Created by akwei on 13-7-25.
//  Copyright (c) 2013年 huoku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKURLImageViewCtrl : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView_my;
@property(nonatomic,strong)NSMutableArray* datalist;

@end
