//
//  ConfirmScheduleTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/13.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "ConfirmScheduleTableViewController.h"
#import "MedicalCard.h"
#import "MBProgressHUDManager.h"

#define kDataFile @"dataCard"
#define kDataKey  @"defaultCard"
#define kUserName @"username"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"OrderBookingRecord"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface ConfirmScheduleTableViewController ()

@property (strong,nonatomic) NSArray *fieldLabels;
@property (strong,nonatomic) NSMutableArray *fieldValues;
@property (strong,nonatomic) MedicalCard *defaultCard;
@property (nonatomic,retain) NSMutableData * responseData;
@property (nonatomic,retain) MBProgressHUDManager *HUDManager;

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
//    NSString *filePath = [self dataFilePath];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
//        NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//        self.defaultCard = [unarchiver decodeObjectForKey:kDataKey];
//    }
    self.HUDManager= [[MBProgressHUDManager alloc] initWithView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.defaultCard = [unarchiver decodeObjectForKey:kDataKey];
    }
    [self.tableView reloadData];
}

-(NSString *)dataFilePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:kDataFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section ==0) {
        return 9;
    }
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSString *identifier = nil;
    NSInteger section = [indexPath section];

    if (section==0) {
        identifier = @"scheduleCell";
           UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        if ([indexPath row]<9) {
            cell.textLabel.text =[self.fieldLabels objectAtIndex:[indexPath row]];
        }
        
        if (![self.schedule isEqual:[NSNull null]] ) {
            switch ([indexPath row]) {
                case 0:
                    cell.detailTextLabel.text = [self.defaultCard owner];
                    break;
                case 1:
                    cell.detailTextLabel.text = [self.defaultCard medicalCardCode];
                    cell.accessoryType =UITableViewCellAccessoryDetailButton;
                    break;
                case 2:
                     cell.detailTextLabel.text = [[self schedule] objectForKey:@"HospitalName"];
                    break;
                case 3:
                    cell.detailTextLabel.text = [[self schedule] objectForKey:@"DepartmentName"];
                    break;
                case 4:
                    cell.detailTextLabel.text = [[self schedule] objectForKey:@"DoctorName"];
                    break;
                case 5:
                    cell.detailTextLabel.text = [[self schedule] objectForKey:@"AuscultationDate"];
                    break;
                case 6:{
                    NSString *tmFromTo = [NSString stringWithFormat:@"%@ - %@",[[self schedule] objectForKey:@"BeginTime"],[[self schedule] objectForKey:@"EndTime"]];
                    cell.detailTextLabel.text = tmFromTo;
                }
                    break;
                case 7:
                    cell.detailTextLabel.text = @"医院挂号处";
                    break;
                case 8:
                    cell.detailTextLabel.text = @"在线支付";
                    break;
                default:
                    break;
            }
        }
        return cell;
    }
    else{
        identifier = @"confirmCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CGRect rect = cell.contentView.frame;
        rect.origin.x = rect.origin.x + rect.size.width *0.05;
        rect.origin.y = rect.origin.y + rect.size.height*0.15;
        rect.size.height = rect.size.height*0.7;
        rect.size.width =rect.size.width*0.9;
        
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:rect];
        confirmButton.layer.cornerRadius = 4;
        confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        confirmButton.backgroundColor= [UIColor colorWithRed:252.0/255 green:106.0/255 blue:8.0/255 alpha:1.0];
        [confirmButton setTitle:@"确认预约" forState:UIControlStateNormal];
        confirmButton.layer.cornerRadius = 4;
        [confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchDown];
            [cell.contentView addSubview:confirmButton];
        return cell;
    }
}

-(void)confirm:(id)sender{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:3];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:[userDefaults objectForKey:kUserName] forKey:@"UserName"];
    [dictionary setObject:self.defaultCard.medicalCardTypeID forKey:@"MedicalCardTypeID"];
    [dictionary setObject:self.defaultCard.medicalCardCode forKey:@"MedicalCardCode"];
    [dictionary setObject:[self.schedule objectForKey:@"ScheduleID"] forKey:@"ScheduleID"];
    [dictionary setObject:[self.schedule objectForKey:@"AuscultationDate"] forKey:@"AuscultationDate"];
    [dictionary setObject:[self.schedule objectForKey:@"BeginTime"] forKey:@"BeginTime"];
    [dictionary setObject:[self.schedule objectForKey:@"EndTime"] forKey:@"EndTime"];
//    [dictionary setObject:[self.schedule objectForKey:@"ContactNumber"] forKey:@"ContactNumber"];
    [dictionary setObject:@"10020" forKey:@"BookingWayID"];
    
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
    
    [self.HUDManager showIndeterminateWithMessage:@""];
    
//    [self.HUDManager showMessage:@"预约成功！如需取消，请到'个人设置'-'我的预约'中取消" duration:3];
  
//    [self.navigationController popViewControllerAnimated:YES];
  
}

#pragma mark
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    if([_responseData length]==0)
        return;
    
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed");
        return;
    }
    
    NSString *resultMsg = [jsonDictionary objectForKey:@"Message"];
//    NSString *resultCode = [jsonDictionary objectForKey:@"ResultCode"];
    NSLog(@"%@",resultMsg);
    [self.HUDManager showMessage:resultMsg duration:3];
    [self.HUDManager showErrorWithMessage:resultMsg duration:2 complection:^{
        [self.navigationController popViewControllerAnimated:YES];
   
    }];

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络连接失败"];
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"changCard" sender:self];
}

@end
