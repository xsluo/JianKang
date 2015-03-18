//
//  TodayDutyViewController.h
//  eHealth
//
//  Created by Bagu on 15/3/17.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayDutyViewController : UIViewController
@property(nonatomic,retain) NSMutableArray *todayDutyList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dutyChanged:(id)sender;
@end
