//
//  TodayDutyViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/17.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "TodayDutyViewController.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetDutyRosterList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
//#define Status
#define HospitalID @"440604001"

@interface TodayDutyViewController ()
@property(nonatomic,retain)  NSMutableData *responseData;
@property (nonatomic,retain)  NSString *status;
@property (nonatomic,retain) NSString *weekDay;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation TodayDutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *now = [[NSDate alloc] init];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
    NSArray *daysOfWeek = @[@"",@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
    [nowDateFormatter setDateFormat:@"e"];
    NSInteger weekdayNumber = (NSInteger)[[nowDateFormatter stringFromDate:now] integerValue];
    //    NSLog(@"Day of Week: %@",[daysOfWeek objectAtIndex:weekdayNumber]);
    self.weekDay =[NSString stringWithFormat:@"%@",[daysOfWeek objectAtIndex:weekdayNumber]];
    
    self.status = @"1";
    self.todayDutyList= [[NSMutableArray alloc]init];
    [self linkTheNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)linkTheNet{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:4];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:self.status forKey:@"Status"];
    [dictionary setObject:HospitalID forKey:@"HospitalID"];
    [dictionary setObject:self.weekDay forKey:@"Week"];
    
    NSError *error=nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=%@&jsonBody=%@",Method,jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    //    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}


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
    
    if([self.responseData length]==0)
        return;
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:self.responseData  options:NSJSONReadingMutableContainers  error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed \r\n");
        return;
    }
    [self.HUDManager hide];
    self.todayDutyList =[jsonDictionary objectForKey:@"DutyRosterList"];
    [self.tableView reloadData];
    
    UIApplication* app = [ UIApplication  sharedApplication ];
    app.networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络无法连接"  duration:2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.todayDutyList == (id)[NSNull null])
        return 0;
    else
        return [self.todayDutyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIndentifier =@"todayDutyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    }
    NSInteger row = [indexPath row];
    
    NSDictionary *todayDuty = [self.todayDutyList objectAtIndex:row];
    
    //    NSString *phaseName = [todayDuty objectForKey:@"PhaseName"];
    
    NSString *doctorName = [todayDuty objectForKey:@"DoctorName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",doctorName];
    
    NSString *subjectName = [todayDuty objectForKey:@"SubjectName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",subjectName];
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)dutyChanged:(id)sender {
    NSInteger index =[(UISegmentedControl*)sender selectedSegmentIndex];
    self.status = [NSString stringWithFormat:@"%lo",(long)index+1];
    [self linkTheNet];
    [self.HUDManager showIndeterminateWithMessage:@""];
    [self.tableView reloadData];
}
@end

