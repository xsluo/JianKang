//
//  ScheduleViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/10.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Doctor.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetScheduleList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface ScheduleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableData * responseData;
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scheduleList = [[NSMutableArray alloc]init];
    [self getScheduleList];
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
    self.scheduleList =[jsonDictionary objectForKey:@"ScheduleList"];
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
    UILabel *labelBegin = (UILabel*)[cell.contentView viewWithTag:2];
    labelBegin.text = beginTm;

    NSString *endTm = [scheduleDictionary objectForKey:@"EndTime"];
    UILabel *labelEnd = (UILabel*)[cell.contentView viewWithTag:3];
    labelEnd.text = endTm;

    NSString *available = [scheduleDictionary objectForKey:@"AvailableBookingNumber"];
    UILabel *labelAvailable = (UILabel*)[cell.contentView viewWithTag:4];
    labelAvailable.text = available;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
//    NSDictionary *aDoctor = [self.doctorList objectAtIndex:[indexPath row]];
//    Doctor *dct = [[Doctor alloc]init];
//    
//    dct.doctorID =[aDoctor objectForKey:@"DoctorID"];
//    dct.doctorName = [aDoctor objectForKey:@"DoctorName"];
//    dct.avatarUrl = [aDoctor objectForKey:@"AvatarUrl"];
//    dct.hospitalID = [aDoctor objectForKey:@"HospitalID"];
//    dct.hospitalName = [aDoctor objectForKey:@"HospitalName"];
//    dct.introduction = [aDoctor objectForKey:@"Introduction"];
//    self.doctor = dct;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
