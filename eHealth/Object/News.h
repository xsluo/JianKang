//
//  News.h
//  eHealth
//
//  Created by Bagu on 15/3/16.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
@property (strong,nonatomic)NSString *newsID;
@property (strong,nonatomic)NSString *hospitalID;
@property (strong,nonatomic)NSString *newsCategoryName;
@property (strong,nonatomic)NSString *newsCategoryID;
@property (strong,nonatomic)NSString *newsTitle;
@property (strong,nonatomic)NSString *summary;
@property (strong,nonatomic)NSString *newsContent;
@property (strong,nonatomic)NSString *thumbnailUrl;
@property (strong,nonatomic)NSString *creatTime;
@end
