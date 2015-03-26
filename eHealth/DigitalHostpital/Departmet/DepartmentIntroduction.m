//
//  DepartmentIntroduction.m
//  eHealth
//
//  Created by Bagu on 15/3/26.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "DepartmentIntroduction.h"
#import "Department.h"

@interface DepartmentIntroduction ()

@end

@implementation DepartmentIntroduction

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.departmentName.text = [self.department departmentName];
    self.introduction.text = [self.department  introduction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
