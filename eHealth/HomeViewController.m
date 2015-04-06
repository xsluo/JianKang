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
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor brownColor];
    } else {
        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:28.0/255 green:140.0/255 blue:189.0/255 alpha:1.0];
    }
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    UIViewController *vct0 = [[self viewControllers] objectAtIndex:0];
    vct0.tabBarItem.image = [UIImage imageNamed:@"数字医院.png"];
    
    UIViewController *vct1 = [[self viewControllers] objectAtIndex:1];
    vct1.tabBarItem.image = [UIImage imageNamed:@"智能健康.png"];
    
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
