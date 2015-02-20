//
//  MedicalCard.m
//  eHealth
//
//  Created by nh neusoft on 15-1-12.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "MedicalCard.h"

@implementation MedicalCard
#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[self medicalCardID] forKey:@"medicalCardID"];
    [aCoder encodeObject:[self medicalCardTypeID] forKey:@"medicalCardTypeID"];
    [aCoder encodeObject:[self medicalCardTypeName] forKey:@"medicalCardTypeName"];
    [aCoder encodeObject:[self medicalCardCode] forKey:@"medicalCardCode"];
    [aCoder encodeObject:[self owner] forKey:@"owner"];
    [aCoder encodeObject:[self ownerSex] forKey:@"ownerSex"];
    [aCoder encodeObject:[self ownerAge] forKey:@"ownerAge"];
    [aCoder encodeObject:[self ownerPhone] forKey:@"ownerPhone"];
    [aCoder encodeObject:[self ownerTel] forKey:@"ownerTel"];
    [aCoder encodeObject:[self ownerIDCard] forKey:@"ownerIDCard"];
    [aCoder encodeObject:[self ownerEmail] forKey:@"ownerEmail"];
    [aCoder encodeObject:[self ownerAdress] forKey:@"ownerAdress"];
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        self.medicalCardID = [aDecoder decodeObjectForKey:@"medicalCardID"];
        self.medicalCardTypeID = [aDecoder decodeObjectForKey:@"medicalCardTypeID"];
        self.medicalCardTypeName = [aDecoder decodeObjectForKey:@"medicalCardTypeName"];
        self.medicalCardCode = [aDecoder decodeObjectForKey:@"medicalCardCode"];
        self.owner = [aDecoder decodeObjectForKey:@"owner"];
        self.ownerSex = [aDecoder decodeObjectForKey:@"ownerSex"];
        self.ownerAge = [aDecoder decodeObjectForKey:@"ownerAge"];
        self.ownerPhone = [aDecoder decodeObjectForKey:@"ownerPhone"];
        self.ownerTel = [aDecoder decodeObjectForKey:@"ownerTel"];
        self.ownerIDCard = [aDecoder decodeObjectForKey:@"ownerIDCard"];
        self.ownerEmail = [aDecoder decodeObjectForKey:@"ownerEmail"];
        self.ownerAdress = [aDecoder decodeObjectForKey:@"ownerAdress"];
    }
    return self;
}

@end

