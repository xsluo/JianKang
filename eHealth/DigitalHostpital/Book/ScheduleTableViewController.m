//
//  ScheduleTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/15.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "Doctor.h"
#import "ConfirmScheduleTableViewController.h"
#import "MBProgressHUDManager.h"

#define kDataFile @"dataCard"
#define kDataKey  @"defaultCard"
#define kUserName @"username"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetScheduleList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface ScheduleTableViewController ()
@property (nonatomic,retain) NSMutableData * responseData;
@property (nonatomic,retain) MBProgressHUDManager *HUDManager;
@end

@implementation ScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.HUDManager= [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scheduleList = [[NSMutableArray alloc]init];
    [self getScheduleList];    
}

-(void)viewDidAppear:(BOOL)animated{
    UIImageView *imageAvatar = (UIImageView *)[self.resumeView viewWithTag:1];
    UILabel *labelDoctorName = (UILabel *) [self.resumeView viewWithTag:2];
    UILabel *labelDepartment = (UILabel *) [self.resumeView viewWithTag:3];
    UILabel *labelHospitalName = (UILabel *)[self.resumeView viewWithTag:4];
 
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self.doctor avatarUrl]]];
    UIImage *img= [UIImage imageWithData:data];
    if(!img)
        img = [UIImage imageNamed:@"男医生.png"];
    imageAvatar.image = img;
  
 
    labelDoctorName.text = [self.doctor doctorName ];
    labelDepartment.text = [self.doctor departmentName];
    labelHospitalName.text = [self.doctor hospitalName];
}

-(void)getScheduleList{
    
    NSString *dctid =[self.doctor doctorID];
    NSString *hptid = [self.doctor hospitalID];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:5];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:@"3" forKey:@"Type"];
    [dictionary setObject:hptid forKey:@"HospitalID"];
    [dictionary setObject:dctid forKey:@"DoctorID"];
    
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
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.HUDManager hide];
    self.scheduleList =[jsonDictionary objectForKey:@"ScheduleList"];
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"无法连接网络，请检查网络" duration:2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(self.scheduleList!=(id)[NSNull null])
        return [self.scheduleList count];
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"scheduleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSInteger row = [indexPath row];
    NSDictionary *scheduleDictionary = [self.scheduleList objectAtIndex:row];
    
    NSString *ausDate = [scheduleDictionary objectForKey:@"AuscultationDate"];
    UILabel *labelDate = (UILabel*)[cell.contentView viewWithTag:1];
    labelDate.text = ausDate;
    
    NSString *beginTm = [scheduleDictionary objectForKey:@"BeginTime"];
    NSString *endTm = [scheduleDictionary objectForKey:@"EndTime"];
    UILabel *labelTm = (UILabel*)[cell.contentView viewWithTag:2];
    labelTm.text = [NSString stringWithFormat:@"%@-%@",beginTm,endTm];
    
    
    NSString *available = [scheduleDictionary objectForKey:@"AvailableBookingNumber"];
    UILabel *labelAvailable = (UILabel*)[cell.contentView viewWithTag:4];
    labelAvailable.text = available;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"confirm"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *scheduleDictionary = [self.scheduleList objectAtIndex:indexPath.row];
        [[segue destinationViewController] setSchedule:scheduleDictionary];
    }
}
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    //此段逻辑还需要厘清
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        if ([unarchiver decodeObjectForKey:kDataKey]==nil){
            [self.HUDManager showMessage:@"请在‘个人设置’中设置默认健康卡" duration:3];
            return NO;
        }
    }
    else{
        [self.HUDManager showMessage:@"请在‘个人设置‘中设置默认健康卡" duration:3];
        return NO;
    }
    return YES;
}

-(NSString *)dataFilePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:kDataFile];
}

@end
