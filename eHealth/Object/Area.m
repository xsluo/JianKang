//
//  Area.m
//  eHealth
//
//  Created by Bagu on 15/2/9.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "Area.h"
#define  kareaID @"ID"
#define  kareaName @"Name"

@implementation Area

#pragma mark -
#pragma mark NSCoding

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.areaID forKey:kareaID];
    [aCoder encodeObject:self.areaName forKey:kareaName];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self=[super init]){
        self.areaID = [aDecoder decodeObjectForKey:kareaID];
        self.areaName =[aDecoder decodeObjectForKey:kareaName];
    }
    return self;
}

@end
