//
//  HealthViewController.m
//  eHealth
//
//  Created by Bagu on 15/4/20.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "HealthViewController.h"

@interface HealthViewController ()

- (IBAction)Call:(id)sender;
@end

@implementation HealthViewController

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

- (IBAction)Call:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打热线" message:@"即将拨打电话114" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"同意", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString *telNumber = [NSString stringWithFormat:@"tel:%@",@"114"];
        NSURL *aURL = [NSURL URLWithString: telNumber];
        if ([[UIApplication sharedApplication] canOpenURL:aURL])
            [[UIApplication sharedApplication] openURL:aURL];
    }
}
@end
