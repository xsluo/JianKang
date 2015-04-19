//
//  DutyRosterViewController.m
//  eHealth
//
//  Created by Bagu on 14/12/30.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import "DutyRosterViewController.h"
#import "ScheduleTableViewController.h"
#import "Doctor.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetDutyRosterList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define Status @"0"
#define HospitalID @"440604001"

@interface DutyRosterViewController ()
@property (nonatomic,retain) NSString *weekDay;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation DutyRosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    self.weekDay = @"1";
    self.dutyRosterList = [[NSMutableArray alloc]init];
    [self linkTheNet];
}


- (void)linkTheNet{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:4];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:Status forKey:@"Status"];
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
    //    return cachedResponse;
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
    self.dutyRosterList =[jsonDictionary objectForKey:@"DutyRosterList"];
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络连接错误"  duration:2];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dutyRosterList == (id)[NSNull null])
        return 0;
    else
        return [self.dutyRosterList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIndentifier =@"dutyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    }
    NSInteger row = [indexPath row];
    
    NSDictionary *dutyRoster = [self.dutyRosterList objectAtIndex:row];
    
    NSString *doctorName = [dutyRoster objectForKey:@"DoctorName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",doctorName];
    
    //    NSString *auscultationDate = [dutyRoster objectForKey:@"AuscultationDate"];
    NSString *subjectName = [dutyRoster objectForKey:@"SubjectName"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",subjectName];
    return cell;
}


#pragma mark - Navigation

- (IBAction)weedayChanged:(id)sender {
    NSInteger day =[(UISegmentedControl*)sender selectedSegmentIndex]+1;
    self.weekDay = [NSString stringWithFormat:@"%ld",(long)day];
    [self linkTheNet];
    [self.HUDManager showIndeterminateWithMessage:@""];
    [self.tableView reloadData];
}
@end
