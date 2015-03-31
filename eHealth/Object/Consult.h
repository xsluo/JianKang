//
//  Consult.h
//  eHealth
//
//  Created by nh neusoft on 15-3-31.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Consult : NSObject
@property(retain,nonatomic) NSString *consultID;
@property(retain,nonatomic) NSString *questionerID;
@property(retain,nonatomic) NSString *hostpitalID;
@property(retain,nonatomic) NSString *DepartmentID;
@property(retain,nonatomic) NSString *doctorID;
@property(retain,nonatomic) NSString *consultStatusID;
@property(retain,nonatomic) NSString *conSultID;
@property(retain,nonatomic) NSString *consultName;
@property(retain,nonatomic) NSString *consultDescription;
@property(retain,nonatomic) NSString *replies;
@property(retain,nonatomic) NSString *creatTime;

@end
