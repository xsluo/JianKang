//
//  InstructionViewController.m
//  eHealth
//
//  Created by Bagu on 15/5/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelInstruction;
- (IBAction)dismiss:(id)sender;

@end

@implementation InstructionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelInstruction.text = @"预约就诊当天，请凭个人有效证件在预约时间段开始前15分种到达医院确认取号，无故不应诊的将记爽约一次。\n\r佛山健康E园实行黑名单管理制度，没累计爽约3次，将暂停使用预约挂号1个月。\n\r每位市民每天最多可预约同一医院或同一医生两次。";    
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

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
