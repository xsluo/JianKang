//
//  GetDoctorTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/10.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "GetDoctorTableViewController.h"
#import "Hospital.h"
#import "Department.h"
#import "Doctor.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetDoctorList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface GetDoctorTableViewController ()
@property (nonatomic,retain) NSMutableData * responseData;

@end

@implementation GetDoctorTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.doctorList = [[NSMutableArray alloc]init];
    self.doctor = nil;
    [self getDoctorList];
}


-(void)getDoctorList{
    
    NSString *dptid =[self.department departmentID];
    
    
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:5];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:@"2" forKey:@"Type"];
    [dictionary setObject:dptid forKey:@"DepartmentID"];
    [dictionary setValue:[NSNumber numberWithBool:YES] forKey:@"IsGetSchedule"];
    
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
    self.doctorList =[jsonDictionary objectForKey:@"DoctorList"];
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
}


#pragma mark
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //    return 0;
    if(self.doctorList!=(id)[NSNull null])
        return [self.doctorList count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"doctorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSInteger row = [indexPath row];
    
    NSDictionary *doctorDictionary = [self.doctorList objectAtIndex:row];
    NSString *name = [doctorDictionary objectForKey:@"DoctorName"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",name];
    NSString *intruduction = [doctorDictionary objectForKey:@"Introduction"];
   
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",intruduction];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSDictionary *aDoctor = [self.doctorList objectAtIndex:[indexPath row]];
    Doctor *dct = [[Doctor alloc]init];
    
    dct.doctorID =[aDoctor objectForKey:@"DoctorID"];
    dct.doctorName = [aDoctor objectForKey:@"DoctorName"];
    dct.avatarUrl = [aDoctor objectForKey:@"AvatarUrl"];
    dct.hospitalID = [aDoctor objectForKey:@"HospitalID"];
    dct.hospitalName = [aDoctor objectForKey:@"HospitalName"];
    dct.introduction = [aDoctor objectForKey:@"Introduction"];
    self.doctor = dct;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end





