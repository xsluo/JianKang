//
//  HomeViewController.m
//  eHealth
//
//  Created by Bagu on 15/1/3.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "HomeViewController.h"
#define kUserName  @"username"

@interface HomeViewController ()
- (IBAction)settingTapped:(id)sender;

@end

@implementation HomeViewController

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

- (IBAction)settingTapped:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *user =[userDefaults stringForKey:kUserName];
    if(!user)
        [self performSegueWithIdentifier:@"setting" sender:self];
    else
        [self performSegueWithIdentifier:@"personal" sender:self];
    
}
@end
