//
//  BookViewController.h
//  eHealth
//
//  Created by Bagu on 15/2/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hospital;
@class Department;
@class Doctor;

@interface BookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *areaItem;

@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelDoctorName;
@property (weak, nonatomic) IBOutlet UILabel *labelHospitalName;
@property (weak, nonatomic) IBOutlet UILabel *labelIntroduction;

@property (strong,nonatomic) Hospital *hospital;
@property (strong,nonatomic) Department *department;
@property (strong,nonatomic) Doctor *doctor;

@end
