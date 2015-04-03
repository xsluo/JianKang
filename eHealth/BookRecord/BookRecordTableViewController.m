//
//  BookRecordTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/26.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "BookRecordTableViewController.h"
#import "BookRecordCell.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetBookingRecordList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define Type @"0"

#define kUserName @"username"

@interface BookRecordTableViewController ()
@property (nonatomic,retain) NSMutableArray *bookRecordList;
@property (nonatomic,retain) NSMutableData *responseData;


@end

@implementation BookRecordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed");
        return;
    }
    //    self.medicalCardList =[jsonDictionary objectForKey:@"MedicalCardList"];
    NSMutableArray *arrayM =[[NSMutableArray alloc]initWithArray:[jsonDictionary objectForKey:@"BookingRecordList"]];
    self.bookRecordList = arrayM;
    
    [self.tableView reloadData];
    //    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
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
    static NSString *reuseIdentifier = @"bookRecordCell";
    BookRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[BookRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
//    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    NSInteger row = [indexPath row];
    NSDictionary *recordDictionary = [self.bookRecordList objectAtIndex:row];
    
    cell.hospitalName.text = [recordDictionary objectForKey:@"HospitalName"];
    cell.doctorName.text = [recordDictionary objectForKey:@"DoctorName"];
    cell.departmentName.text =[recordDictionary objectForKey:@"DepartmentName"];
    cell.medicalCardCode.text =[recordDictionary objectForKey:@"MedicalCardCode"];
    cell.medicalCardOwner.text =[recordDictionary objectForKey:@"MedicalCardOwner"];
    cell.medicalCardTypeName.text =[recordDictionary objectForKey:@"MedicalCardTypeName"];
    cell.auscultationDate.text =[recordDictionary objectForKey:@"AuscultationDate"];
    cell.signInStatusName.text =[recordDictionary objectForKey:@"SignInStatusName"];
    cell.medicalCardTypeID = [recordDictionary objectForKey:@"MedicalCardTypeID"];
    cell.bookingRecordID = [recordDictionary objectForKey:@"BookingRecordID"];
    
    if ([[recordDictionary objectForKey:@"SignInStatusName"] isEqualToString:@"未到诊"]) {
        cell.buttonCancel.hidden = NO;
        cell.signInStatusName.hidden = YES;
    }
    else{
        cell.buttonCancel.hidden = YES;
        cell.signInStatusName.hidden = NO;
    }
    return cell;

}

//-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 144.0;
//}


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
