//
//  DutyRosterViewController.h
//  eHealth
//
//  Created by Bagu on 14/12/30.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DutyRosterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)   NSMutableArray *dutyRosterList;
@property(nonatomic,retain)   NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)weedayChanged:(id)sender;

@end
