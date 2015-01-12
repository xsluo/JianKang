//
//  MedicalCard.h
//  eHealth
//
//  Created by nh neusoft on 15-1-12.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalCard : NSObject
@property (nonatomic,retain) NSString *medicalCardID;
@property (nonatomic,retain) NSString *medicalCardTypeID;
@property (nonatomic,retain) NSString *medicalCardTypeName;
@property (nonatomic,retain) NSString *medicalCardCode;
@property (nonatomic,retain) NSString *owner;
@property (nonatomic,retain) NSString *ownerSex;
@property (nonatomic,retain) NSString *ownerAge;
@property (nonatomic,retain) NSString *ownerPhone;
@property (nonatomic,retain) NSString *ownerTel;
@property (nonatomic,retain) NSString *ownerIDCard;
@property (nonatomic,retain) NSString *ownerEmail;
@property (nonatomic,retain) NSString *ownerAdress;

@end
