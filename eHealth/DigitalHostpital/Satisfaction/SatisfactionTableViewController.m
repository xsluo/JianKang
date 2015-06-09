
//
//  SatisfactionTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/4/6.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "SatisfactionTableViewController.h"
#import "BookRecordTableViewController.h"
#import "BookRecordCell.h"
#import "StarTabTableViewController.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetBookingRecordList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define Type @"0"
#define kUserName @"username"

@interface SatisfactionTableViewController ()

@property (nonatomic,retain) NSMutableArray *bookRecordList;
@property (nonatomic,retain) NSMutableData *responseData;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation SatisfactionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRequest{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName =[userDefaults objectForKey:kUserName];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:Type forKey:@"Type"];
    [dictionary setObject:userName forKey:@"UserName"];
    [dictionary setObject:@"2013-01-01" forKey:@"BeginDate"];
    [dictionary setObject:@"2035-05-01" forKey:@"EndDate"];
    
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=%@&jsonBody=%@",Method,jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
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
    
    if([_responseData length]==0)
        return;
    
    //    if([connection.currentRequest.URL.  isEqualToString:URL]){
    [self.HUDManager hide];
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed");
        return;
    }
    //    self.medicalCardList =[jsonDictionary objectForKey:@"MedicalCardList"];
    //    NSMutableArray *arrayM =[[NSMutableArray alloc]initWithArray:[jsonDictionary objectForKey:@"BookingRecordList"]];
    NSMutableArray *arrayM= [jsonDictionary objectForKey:@"BookingRecordList"];
    if ([arrayM isEqual:[NSNull null]])
        self.bookRecordList = nil;
    else
        self.bookRecordList = arrayM;
    [self.tableView reloadData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
//    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"无法连接网络，请检查网络"  duration:2];
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
    if(self.bookRecordList!=(id)[NSNull null])
        return [self.bookRecordList count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"bookedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[BookRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSDictionary *bookRecord = [self.bookRecordList objectAtIndex: [indexPath row]];
    
    UILabel *lableHospital = (UILabel *)[cell viewWithTag:1];
    lableHospital.text = [bookRecord objectForKey:@"HospitalName"];
    
    UILabel *lableDepartment = (UILabel *)[cell viewWithTag:2];
    lableDepartment.text = [bookRecord objectForKey:@"DepartmentName"];
    
    UILabel *lableDoctor = (UILabel *)[cell viewWithTag:3];
    lableDoctor.text = [bookRecord objectForKey:@"DoctorName"];
    
    UILabel *lableCardCode = (UILabel *)[cell viewWithTag:4];
    lableCardCode.text = [bookRecord objectForKey:@"MedicalCardCode"];
    
    UILabel *lableOwner = (UILabel *)[cell viewWithTag:5];
    lableOwner.text = [bookRecord objectForKey:@"MedicalCardOwner"];
    
    UILabel *lableTime = (UILabel *)[cell viewWithTag:6];
    lableTime.text = [bookRecord objectForKey:@"BeginTime"];
    return cell;
    
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     StarTabTableViewController *viewController = [segue destinationViewController];
     NSIndexPath *index = [self.tableView indexPathForSelectedRow];
     NSDictionary *bookRecord = [[NSDictionary alloc] init];
     bookRecord = [self.bookRecordList objectAtIndex: [index row]];
     viewController.record = bookRecord;
 }


@end
