//
//  SettingTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/1/3.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "SettingTableViewController.h"
#import "MedicalCard.h"

#define kUserName @"username"
#define kPassWord @"password"

#define kDataFile @"dataCard"
#define kDataKey  @"defaultCard"

@interface SettingTableViewController ()
@property (strong,nonatomic) MedicalCard *defaultCard;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if(section==0&&row==0){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"真的注销账户吗？" delegate:self cancelButtonTitle:@"不注销" destructiveButtonTitle:@"注销" otherButtonTitles:nil];
        [actionSheet showInView:self.view];
    }
    //Not to highlight selected cell
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [actionSheet destructiveButtonIndex]){
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:nil forKey:kUserName];
        [userDefaults setObject:nil forKey:kPassWord] ;
        [userDefaults synchronize];
        
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver =[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        self.defaultCard = nil;
        [archiver encodeObject:[self defaultCard] forKey:kDataKey];
        [archiver finishEncoding];
        NSString *filePath = [self dataFilePath];
        [data writeToFile:filePath atomically:YES];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(NSString *)dataFilePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:kDataFile];
}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    NSString *userName = [userDefaults objectForKey:kUserName];
//    if ([identifier  isEqual:@"manageCard"]&& userName==nil) {
//        return NO;
//}
//    else
//        return YES;
//}

@end
