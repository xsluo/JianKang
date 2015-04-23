//
//  PatWaitTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/31.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "PatWaitTableViewController.h"
#import "MedicalCard.h"
#import "MBProgressHUDManager.h"

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
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;

@end

@implementation PatWaitTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.waitNum = [NSArray arrayWithObjects:@"",@"姓名", @"性别", @"年龄", @"就诊医生", @"就诊科室", @"就诊日期", @"就诊时间", @"就诊序号",nil];
    
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
    self.waitInfo =[jsonDictionary objectForKey:@"PatWaitNum"];
    if ([self.waitInfo isEqual:[NSNull null]]) {
        [self.HUDManager showErrorWithMessage:@"目前没有候诊信息" duration:3];
    }
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络无法连接" duration:2];
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
    if (![self.waitInfo isEqual:[NSNull null]]) {
        switch ([indexPath row]) {
            case 0:{
                NSString *num = [self.waitInfo objectForKey:@"WaitNum"];
                if (num!=nil ) {
                    labelInfo.text = [NSString stringWithFormat:@"排在前面的还有%@位",num];
                }
            }
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

@end
