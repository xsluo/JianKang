//
//  Doctor.h
//  eHealth
//
//  Created by Bagu on 15/2/9.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Doctor : NSObject
@property (strong,nonatomic)NSString *doctorID;
@property (strong,nonatomic)NSString *hospitalID;
@property (strong,nonatomic)NSString *hospitalName;
@property (strong,nonatomic)NSString *doctorName;
@property (strong,nonatomic)NSString *sex;
@property (strong,nonatomic)NSString *avatarUrl;
@property (strong,nonatomic)NSString *introduction;
@property (strong,nonatomic)NSString *versions;

@end
