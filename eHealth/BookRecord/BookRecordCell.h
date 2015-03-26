//
//  BookRecordCell.h
//  eHealth
//
//  Created by Bagu on 15/3/26.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *departmentName;
@property (weak, nonatomic) IBOutlet UILabel *medicalCardCode;
@property (weak, nonatomic) IBOutlet UILabel *medicalCardTypeName;
@property (weak, nonatomic) IBOutlet UILabel *medicalCardOwner;
@property (weak, nonatomic) IBOutlet UILabel *auscultationDate;
@property (weak, nonatomic) IBOutlet UILabel *signInStatusName;
@end
