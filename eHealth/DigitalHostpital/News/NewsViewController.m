//
//  NewsViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/16.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "NewsViewController.h"
#import "News.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSString *newsTitle = [self.aNews newsTitle];
    UILabel *labelTitle = (UILabel *)[self.view viewWithTag:1];
    labelTitle.text = newsTitle;
    labelTitle.numberOfLines = 2;
    
    NSString *newsCategoryName = [self.aNews newsCategoryName];
    UILabel *labelCategory = (UILabel *)[self.view viewWithTag:2];
    labelCategory.text = newsCategoryName;
    labelCategory.backgroundColor = [UIColor colorWithRed:28.0/255 green:140.0/255 blue:189.0/255 alpha:1.0];
    labelCategory.textColor = [UIColor whiteColor];
    
    NSString *createTime = [self.aNews creatTime];
    UILabel *labelCreate = (UILabel *)[self.view viewWithTag:3];
    labelCreate.text = createTime;
    
    NSString *url = [self.aNews thumbnailUrl];
    UIImageView *imgv = (UIImageView *)[self.view viewWithTag:4];
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *img = [UIImage imageWithData:data];
    [imgv setImage:img];
    
    NSString *content = [self.aNews newsContent];
    UIWebView *webView = (UIWebView *) [self.view viewWithTag:5];
    [webView loadHTMLString:content baseURL:nil];

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
