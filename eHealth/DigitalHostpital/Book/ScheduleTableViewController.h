//
//  ScheduleTableViewController.h
//  eHealth
//
//  Created by Bagu on 15/3/15.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Doctor;
@interface ScheduleTableViewController : UITableViewController
@property(nonatomic,retain) Doctor *doctor;
@property (strong,nonatomic) NSMutableArray *scheduleList;
@property (weak, nonatomic) IBOutlet UIView *resumeView;
@end
