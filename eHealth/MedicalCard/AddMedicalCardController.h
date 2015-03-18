//
//  AddMedicalCardController.h
//  eHealth
//
//  Created by Bagu on 15/1/12.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedicalCard;

@interface AddMedicalCardController : UITableViewController
@property (copy, nonatomic) NSString *userName;
@property(nonatomic,retain) MedicalCard *medicalCard;

@end
