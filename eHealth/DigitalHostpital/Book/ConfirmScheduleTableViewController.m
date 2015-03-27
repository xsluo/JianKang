//
//  ConfirmScheduleTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/13.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "ConfirmScheduleTableViewController.h"
#import "MedicalCard.h"

#define kDataFile @"dataCard"
#define kDataKey  @"defaultCard"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"OrderBookingRecord"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface ConfirmScheduleTableViewController ()

@property (strong,nonatomic) NSArray *fieldLabels;
@property (strong,nonatomic) NSMutableArray *fieldValues;
@property (strong,nonatomic) MedicalCard *defaultCard;

@end

@implementation ConfirmScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *array = [[NSArray alloc]initWithObjects:@"姓名",@"健康卡号", @"预约医院",@"预约科室",@"预约医生",@"预约日期",@"预约时间",@"取号地点",@"支付方式",nil];
    self.fieldLabels = array;
    self.fieldValues = [[NSMutableArray alloc]init];
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.defaultCard = [unarchiver decodeObjectForKey:kDataKey];
    }
}

-(NSString *)dataFilePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:kDataFile];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"scheduleCell"];
    UITableViewCell *cell1 =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"confirmCell"];
    if([indexPath section]== 0){
        switch ([indexPath row]) {
            case 0:
                cell.detailTextLabel.text = [[self defaultCard] owner];break;
            case 1:
                cell.detailTextLabel.text = @"健康卡号";break;
            case 2:
                cell.detailTextLabel.text = [[self schedule] objectForKey:@"HospitalName"];break;
            case 3:
                cell.detailTextLabel.text = [[self schedule] objectForKey:@"DepartmentName"];break;
            case 4:
                cell.detailTextLabel.text = [[self schedule] objectForKey:@"DoctorName"];break;
            case 5:
                cell.detailTextLabel.text = [[self schedule] objectForKey:@"AuscultationDate"];break;
            case 6:{
                NSString *tmFromTo = [NSString stringWithFormat:@"%@ - %@",[[self schedule] objectForKey:@"BeginTime"],[[self schedule] objectForKey:@"EndTime"]];
                cell.detailTextLabel.text = tmFromTo;}break;
            case 7:
                cell.detailTextLabel.text = @"取号地点";break;
            case 8:
                cell.detailTextLabel.text = @"支付方式";break;
            default:break;
        }
        cell.textLabel.text = [[self fieldLabels] objectAtIndex:[indexPath row]];
        return cell;
    }
    else{
//        cell1.contentView.backgroundColor = [UIColor colorWithRed:28.0/255 green:140.0/255 blue:189.0/255 alpha:1.0];
//        cell1.textLabel.contentMode = UIViewContentModeCenter;
//        cell1.textLabel.text = @"确认预约";
//        cell1.textLabel.textAlignment = NSTextAlignmentCenter;
//        cell1.textLabel.textColor = [UIColor whiteColor];
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:cell1.frame];
        confirmButton.backgroundColor= [UIColor redColor];
        [confirmButton setTitle:@"确认预约" forState:UIControlStateNormal];
        confirmButton.titleLabel.textColor = [UIColor brownColor];
        [cell1.contentView addSubview:confirmButton];
        [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchDown];
        return cell1;
    }
}

-(void)confirm:(id)sender{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:3];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    
    [dictionary setObject:self.defaultCard.medicalCardTypeID forKey:@"MedicalCardTypeID"];
    [dictionary setObject:self.defaultCard.medicalCardCode forKey:@"MedicalCardCode"];
    [dictionary setObject:[self.schedule objectForKey:@"ScheduleID"] forKey:@"ScheduleID"];
    [dictionary setObject:[self.schedule objectForKey:@"AuscultationDate"] forKey:@"AuscultationDate"];
    [dictionary setObject:[self.schedule objectForKey:@"BeginTime"] forKey:@"BeginTime"];
    [dictionary setObject:[self.schedule objectForKey:@"EndTime"] forKey:@"EndTime"];
    [dictionary setObject:[self.schedule objectForKey:@"ContactNumber"] forKey:@"ContactNumber"];
    [dictionary setObject:@"10020" forKey:@"BookWayID"];
    
   
    
    NSError *error=nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=%@&jsonBody=%@",Method,jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    //------------------------------
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    /* 设置缓存的大小为1M*/
    [urlCache setMemoryCapacity:1*1024*1024];
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    //判断是否有缓存
    if (response != nil){
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    //-----------------------------
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];

    
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
