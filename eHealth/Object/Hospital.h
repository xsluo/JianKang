//
//  Hospital.h
//  eHealth
//
//  Created by Bagu on 15/2/9.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hospital : NSObject
@property (strong) NSString *hospitalID;
@property (strong) NSString *areaID;
@property (strong) NSString *hospitalName;
@property (strong) NSString *hospitalLevelName;
@property (strong) NSString *bookingEarlyDays;
@property (strong) NSString *zipCode;
@property (strong) NSString *telephone;
@property (strong) NSString *fax;
@property (strong) NSString *officialSite;
@property (strong) NSString *address;
@property (strong) NSString *pictureUrl;
@property (strong) NSString *latitde;
@property (strong) NSString *longitude;
@property (strong) NSString *Introduction;
@property (strong) NSString *rtaccicUrl;
@property (strong) NSString *buildingDistributionUrl;
@property (strong) NSString *departmentDistributionUrl;
@end
