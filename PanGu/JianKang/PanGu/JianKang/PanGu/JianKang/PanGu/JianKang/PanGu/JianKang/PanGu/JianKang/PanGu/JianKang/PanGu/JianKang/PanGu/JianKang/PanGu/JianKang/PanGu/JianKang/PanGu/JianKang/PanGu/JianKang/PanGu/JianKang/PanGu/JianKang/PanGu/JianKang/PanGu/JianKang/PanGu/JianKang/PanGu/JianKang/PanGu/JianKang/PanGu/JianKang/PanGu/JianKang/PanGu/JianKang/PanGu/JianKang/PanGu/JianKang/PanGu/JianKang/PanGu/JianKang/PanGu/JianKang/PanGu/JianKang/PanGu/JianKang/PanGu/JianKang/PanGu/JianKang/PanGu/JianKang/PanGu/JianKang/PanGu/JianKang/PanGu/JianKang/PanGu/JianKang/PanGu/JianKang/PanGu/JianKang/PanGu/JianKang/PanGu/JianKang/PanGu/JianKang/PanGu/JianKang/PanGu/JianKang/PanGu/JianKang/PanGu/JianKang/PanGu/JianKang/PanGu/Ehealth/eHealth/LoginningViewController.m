//
//  LoginningViewController.m
//  eHealth
//
//  Created by Bagu on 15/1/3.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "LoginningViewController.h"

@interface LoginningViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textPwd;

- (IBAction)logiTapped:(id)sender;
- (IBAction)signupTapped:(id)sender;
@end

@implementation LoginningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logiTapped:(id)sender {
    if([self.textName.text isEqual:@"1"])
        [self.navigationController popToRootViewControllerAnimated:self];
}

- (IBAction)signupTapped:(id)sender {
}
@end
