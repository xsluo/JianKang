//
//  DepartmentTableViewController.h
//  eHealth
//
//  Created by Bagu on 14/12/16.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DepartmentTableViewController : UITableViewController//<NSURLConnectionDelegate>
@property(nonatomic,retain) NSMutableArray *departmentList;
@property(nonatomic,retain)   NSMutableData *responseData;
@end
