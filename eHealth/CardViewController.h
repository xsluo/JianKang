//
//  CardViewController.h
//  eHealth
//
//  Created by nh neusoft on 15-1-12.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalCard;

@interface CardViewController : UITableViewController
@property(strong,nonatomic) MedicalCard *medicalCard;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCardType;
@property (weak, nonatomic) IBOutlet UILabel *labelCardNumber;

@end
