//
//  IntroductionViewController.m
//  eHealth
//
//  Created by Bagu on 14/12/14.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filename = [documentDirectory stringByAppendingString:@"/introduction.html"];

    NSURL *url = [NSURL fileURLWithPath:filename];
    
    NSURLRequest *request = [NSURLRequest  requestWithURL:url];
    [self.webcontent loadRequest:request];
    
   
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    [self.webcontent loadRequest:request];
    
   // NSLog(@"沙盒路径：%@",NSHomeDirectory());
    ///Users/Bagu/Library/Developer/CoreSimulator/Devices/094F3451-FA19-4E68-973F-12CD19F1E118/data/Containers/Data/Application/1C1AEA39-5C2D-4A3D-AAD9-F32F1D9BFF81
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

@end
