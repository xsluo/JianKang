//
//  GetDepartmentTableViewController.h
//  eHealth
//
//  Created by Bagu on 15/2/9.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hospital;
@class Department;

@interface GetDepartmentTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *departmentList;
@property (strong,nonatomic) Hospital *hospital;
@property (strong,nonatomic) Department *department;

- (IBAction)cancel:(id)sender;
@end
