//
//  PatWaitTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/31.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "PatWaitTableViewController.h"
#import "MedicalCard.h"
#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetPatWaitNum"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define HospitalID @"440604001"
#define kDataFile @"dataCard"
#define kDataKey  @"defaultCard"

@interface PatWaitTableViewController ()
@property(nonatomic,retain)  NSMutableData *responseData;
@property (retain,nonatomic) NSArray *waitNum;
@property (retain,nonatomic) NSDictionary *waitInfo;
@property (strong,nonatomic) MedicalCard *defaultCard;

@end

@implementation PatWaitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.waitNum = [NSArray arrayWithObjects:@"排在前面的有",@"姓名", @"性别", @"年龄", @"就诊医生", @"就诊科室", @"就诊日期", @"就诊时间", @"就诊序号",nil];
    
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.defaultCard = [unarchiver decodeObjectForKey:kDataKey];
    }
    [self setRequest];
}

-(NSString *)dataFilePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:kDataFile];
}

- (void)setRequest{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:4];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:HospitalID forKey:@"HospitalID"];
    [dictionary setObject:[self.defaultCard medicalCardCode]  forKey:@"CardNo"];
    [dictionary setObject:[self.defaultCard medicalCardTypeID] forKey:@"CadType"];
    
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
    
    //------------------------------
    //    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    //    /* 设置缓存的大小为1M*/
    //    [urlCache setMemoryCapacity:1*1024*1024];
    //    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    //    //判断是否有缓存
    //    if (response != nil){
    //        NSLog(@"如果有缓存输出，从缓存中获取数据");
    //        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    //    }
    //-----------------------------
    
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
    //    return nil;
    return cachedResponse;
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
    self.waitInfo =[jsonDictionary objectForKey:@"PatWaitNum"];
    [self.tableView reloadData];
    
    UIApplication* app = [ UIApplication  sharedApplication ];
    app.networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    
    UIApplication* app = [ UIApplication  sharedApplication ];
    app.networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络无法连接" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
    [alert show];
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
    return 9;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = nil;
    NSInteger row = [indexPath row];
    if (row==0) {
        identifier = @"attentionCell";
    }
    else{
        identifier = @"plainCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSString *clause = [self.waitNum objectAtIndex:[indexPath row]];
    UILabel *labelTitle =(UILabel *) [cell viewWithTag:1];
    labelTitle.text = clause;
    
    UILabel *labelInfo = (UILabel *)[cell viewWithTag:2];
    if (![self.waitInfo isEqual:[NSNull null]] ) {
        switch ([indexPath row]) {
            case 0:
                labelInfo.text = [self.waitInfo objectForKey:@"WaitNum"];
                break;
            case 1:
                labelInfo.text = [self.defaultCard owner];
                break;
            case 2:
                labelInfo.text = [self.defaultCard ownerSex];
                break;
            case 3:
                labelInfo.text = [self.defaultCard ownerAge];
                break;
            case 4:
                labelInfo.text = [self.waitInfo objectForKey:@"DocNm"];
                break;
            case 5:
                labelInfo.text = [self.waitInfo objectForKey:@"DeptNm"];
                break;
            case 6:
                labelInfo.text = [self.waitInfo objectForKey:@"RegDate"];
                break;
            case 7:
                labelInfo.text = [self.waitInfo objectForKey:@"RegPhaseNm"];
                break;
            case 8:
                labelInfo.text = [self.waitInfo objectForKey:@"VistTime"];
                break;
            case 9:
                labelInfo.text = [self.waitInfo objectForKey:@"SNum"];
                break;
            default:
                break;
        }
    }
    
    // Configure the cell...
    
    return cell;
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

@end
