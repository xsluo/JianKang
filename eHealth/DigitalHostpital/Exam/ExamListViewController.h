//
//  ExamListViewController.h
//  eHealth
//
//  Created by Bagu on 15/3/9.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *examList;
- (IBAction)getExamList:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *cardID;

@end
