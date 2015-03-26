//
//  DepartmentIntroduction.h
//  eHealth
//
//  Created by Bagu on 15/3/26.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Department;

@interface DepartmentIntroduction : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *departmentName;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (retain,nonatomic) Department *department;

@end
