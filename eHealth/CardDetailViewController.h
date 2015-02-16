//
//  CardDetailViewController.h
//  eHealth
//
//  Created by Bagu on 15/2/15.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedicalCard;

@interface CardDetailViewController : UITableViewController
@property(strong,nonatomic) MedicalCard *medicalCard;
@end
