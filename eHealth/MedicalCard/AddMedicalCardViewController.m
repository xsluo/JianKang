//
//  AddMedicalCardViewController.m
//  eHealth
//
//  Created by Bagu on 15/4/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "AddMedicalCardViewController.h"
#define kUserName @"username"

@interface AddMedicalCardViewController ()

@end

@implementation AddMedicalCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName =[userDefaults objectForKey:kUserName];
    
    NSString *urlString = [NSString stringWithFormat:@"http://219.130.221.120/smjkfw/wsyygh/pages/jkw_login_dx.jsp?redirect=http://202.103.160.153:1001/MedicalCardPage/receive.aspx&wxid=%@",userName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    

    [self.webView loadRequest:request];
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

@end
