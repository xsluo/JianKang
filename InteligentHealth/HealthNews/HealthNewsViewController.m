//
//  HealthNewsViewController.m
//  eHealth
//
//  Created by Bagu on 15/4/22.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "HealthNewsViewController.h"

@interface HealthNewsViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation HealthNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView loadHTMLString:self.txtNewsContent baseURL:nil];
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
