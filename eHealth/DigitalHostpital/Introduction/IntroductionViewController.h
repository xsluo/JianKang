//
//  IntroductionViewController.h
//  eHealth
//
//  Created by Bagu on 14/12/14.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroductionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet UILabel *zipCode;
@property (weak, nonatomic) IBOutlet UILabel *bookEarlyDays;
@end
