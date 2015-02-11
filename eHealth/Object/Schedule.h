//
//  Schedule.h
//  eHealth
//
//  Created by Bagu on 15/2/10.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject
@property(nonatomic,strong) NSString  *scheduleID;
@property(nonatomic,strong) NSString  *hospitalID;
@property(nonatomic,strong) NSString  *hospitalName;
@property(nonatomic,strong) NSString  *departmentID;
@property(nonatomic,strong) NSString  *departmentName;
@property(nonatomic,strong) NSString  *doctorID;
@property(nonatomic,strong) NSString  *doctorName;
@property(nonatomic) BOOL  isRealTime;
@property(nonatomic,strong) NSString  *registrationFee;
@property(nonatomic) BOOL  isStopAuscultate;
@property(nonatomic,strong) NSString  *auscultationDate;
@property(nonatomic,strong) NSString  *beginTime;
@property(nonatomic,strong) NSString  *endTime;
@property(nonatomic,strong) NSString  *availableBookingNumber;
@end
