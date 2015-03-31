//
//  ConsultReply.h
//  eHealth
//
//  Created by nh neusoft on 15-3-31.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultReply : NSObject

@property (retain,nonatomic) NSString *consultReplyID;
@property (retain,nonatomic) NSString *consultID;
@property(retain,nonatomic) NSString * doctorID;
@property (retain,nonatomic) NSString *memberID;
@property (retain,nonatomic) NSString *replyContent;
@property (retain,nonatomic) NSString *creatTime;
@end
