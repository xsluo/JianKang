//
//  GetDoctorTableViewController.h
//  eHealth
//
//  Created by Bagu on 15/2/10.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hospital;
@class Department;
@class Doctor;

@interface GetDoctorTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *doctorList;
@property (strong,nonatomic) Hospital *hospital;
@property (strong,nonatomic) Department *department;
@property (strong,nonatomic) Doctor *doctor;

- (IBAction)cancel:(id)sender;
@end
