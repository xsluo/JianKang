//
//  FavariteTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/4/2.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "FavariteTableViewController.h"
#import "Hospital.h"
#import "Doctor.h"
#import "News.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
//#define Method @"GetHospitalList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define kUserName @"username"

@interface FavariteTableViewController ()

@property (retain,nonatomic)NSString *method;
@property (nonatomic,retain) NSMutableData *responseData;
//@property (strong,nonatomic) NSMutableArray *hospitalList;
//@property (strong,nonatomic) NSMutableArray *doctorlList;
//@property (strong,nonatomic) NSMutableArray *newsList;
@property (retain,nonatomic) NSMutableArray *favariteList;
@property NSInteger segueSelected;

@end

@implementation FavariteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.method = @"GetHospitalList";
    self.segueSelected = 0;
    [self setRequest];
}

-(void)setRequest{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:kUserName];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:4];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:userName forKey:@"UserName"];
    [dictionary setObject:@"99" forKey:@"Type"];
//    [dictionary setObject:@"1" forKey:@"IsGetSchedule"];
    
    NSError *error=nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=%@&jsonBody=%@",self.method,jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    [request setURL:[NSURL URLWithString:URL]];
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
//    return nil;
    return cachedResponse;
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
    
    switch (self.segueSelected) {
        case 0:
            self.favariteList = [jsonDictionary objectForKey:@"HospitalList"];
            break;
        case 1:
            self.favariteList = [jsonDictionary objectForKey:@"DoctorList"];
            break;
        case 2:
            self.favariteList = [jsonDictionary objectForKey:@"NewsList"];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0) {
        return 1;
    }
    else if([self.favariteList isEqual:[NSNull null]])
        return 0;
    else
        return [self.favariteList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *reuseIdentifier=nil;
    NSDictionary *favarite = [self.favariteList objectAtIndex:[indexPath row]];
    
    if ([indexPath section]==0) {
        static NSString *reuseIdentifier = @"segmentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        return cell;
    }
    else{
        switch (self.segueSelected) {
            case 0:{
                static NSString *reuseIdentifier0 = @"favariteHospitalCell";
                UITableViewCell *cellHospital = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier0 forIndexPath:indexPath];
                if (cellHospital==nil) {
                    cellHospital = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier0];
                }
                
                NSString *url = [favarite objectForKey:@"PictureUrl"];
                UIImageView *imgView = (UIImageView *)[cellHospital.contentView viewWithTag:1];
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage *img = [UIImage imageWithData:data];
                imgView.image = img;
                
                UILabel *labelHospitalName = (UILabel *)[cellHospital.contentView viewWithTag:2];
                labelHospitalName.text = [favarite objectForKey:@"HospitalName"];
                UILabel *labelHospitalLevel = (UILabel *)[cellHospital.contentView viewWithTag:3];
                labelHospitalLevel.text = [favarite objectForKey:@"HospitalLevelName"];
                UILabel *labelAddress = (UILabel *)[cellHospital.contentView viewWithTag:4];
                labelAddress.text = [favarite objectForKey:@"Address"];
                return cellHospital;
                break;
            }
            case 1:{
                static NSString *reuseIdentifier1 = @"favariteDoctorCell";
//                static NSInteger it = 0;
//                it++;
                
                UITableViewCell *cellDoctor = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
                if (cellDoctor==nil) {
                    cellDoctor = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier1];
                }
                NSString *url = [favarite objectForKey:@"AvatarUrl"];
                UIImageView *imgView = (UIImageView *)[cellDoctor.contentView viewWithTag:1];
                imgView.contentMode = UIViewContentModeScaleToFill;
                UIImage *img;
                if(url!=(NSString *)[NSNull null]){
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                    img= [UIImage imageWithData:data];
                }
                else{
                    img = [UIImage imageNamed:@"1.png"];
                }
                imgView.image = img;
                
                UILabel *labelDoctorName = (UILabel *)[cellDoctor.contentView viewWithTag:2];
                labelDoctorName.text = [favarite objectForKey:@"DoctorName"];
                
                UILabel *labelDoctorTitle = (UILabel *)[cellDoctor.contentView viewWithTag:3];
                NSString *doctorTitle = [favarite objectForKey:@"DoctorTitle"];
                if (doctorTitle!= (NSString *)[NSNull null]) {
                    labelDoctorTitle.text = doctorTitle;
                }
                else
                    labelDoctorTitle.text = @" ";
                
                UILabel *labelHospital = (UILabel *)[cellDoctor.contentView viewWithTag:4];
                labelHospital.text = [favarite objectForKey:@"HospitalName"];
                UILabel *labelDepartment = (UILabel *)[cellDoctor.contentView viewWithTag:5];
                labelDepartment.text = [favarite objectForKey:@"DepartmentName"];
                
                return cellDoctor;
                break;
            }
            case 2:{
                static NSString *reuseIdentifier2 = @"favariteNewsCell";
                UITableViewCell *cellNews = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
                if (cellNews==nil) {
                    cellNews = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier2];
                }
                cellNews.textLabel.text = [NSString stringWithFormat:@"%@",[favarite objectForKey:@"NewsTitle"]];
                return cellNews;
                break;
            }
            default:
                break;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath section]==0) {
        return 44;
    }
    else if(self.segueSelected ==2)
        return 60;
    else
        return 96;
}

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

- (IBAction)segmentTapped:(id)sender {
    self.segueSelected =[(UISegmentedControl*)sender selectedSegmentIndex];
    switch (self.segueSelected) {
        case 0:
            self.method = @"GetHospitalList";
            break;
        case 1:
            self.method = @"GetDoctorList";
            break;
        case 2:
            self.method = @"GetNews";
            break;
        default:
            break;
    }
    [self setRequest];
}
@end
