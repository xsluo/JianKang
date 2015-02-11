//
//  ScheduleViewController.h
//  eHealth
//
//  Created by Bagu on 15/2/10.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Doctor;

@interface ScheduleViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) Doctor *doctor;

@property (strong,nonatomic) NSMutableArray *scheduleList;

@end
