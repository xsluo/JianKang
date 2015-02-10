//
//  GetHospitalTableViewController.h
//  eHealth
//
//  Created by Bagu on 15/2/2.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Hospital;
@interface GetHospitalTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *hospitalList;
@property (strong,nonatomic) NSString *AreaID;
@property (strong,nonatomic) Hospital *hospital;

- (IBAction)cancel:(id)sender;

@end
