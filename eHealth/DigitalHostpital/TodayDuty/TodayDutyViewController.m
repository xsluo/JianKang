//
//  TodayDutyViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/17.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "TodayDutyViewController.h"
#import "MBProgressHUDManager.h"
#import "ChineseString.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetDutyRosterList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
//#define Status
#define HospitalID @"440604001"

@interface TodayDutyViewController ()
@property(nonatomic,retain)  NSMutableData *responseData;
@property (nonatomic,retain) NSString *status;
@property (nonatomic,retain) NSString *weekDay;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;

@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;
@end

@implementation TodayDutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    self.dataArr = [[NSMutableArray alloc]init];
    self.sortedArrForArrays =[[NSMutableArray alloc]init];
    self.sectionHeadsKeys = [[NSMutableArray alloc]init];
    
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
    
    self.todayDutyList =[jsonDictionary objectForKey:@"DutyRosterList"];
    if (![[self todayDutyList]isEqual:[NSNull null]]) {
        for ( NSDictionary *d in self.todayDutyList ) {
            if (![d isEqual:nil]) {
                [self.dataArr addObject:[d objectForKey:@"DoctorName"]];
            }
        }
        [self.HUDManager hide];
    }
    else{
        self.dataArr =nil;
        [self.HUDManager showSuccessWithMessage:@"当前没有数据" duration:2];
    }
    
    self.sortedArrForArrays = [self getChineseStringArr:self.dataArr];
    [self.tableView reloadData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络无法连接"  duration:2];
}


#pragma mark
#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeadsKeys objectAtIndex:section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionHeadsKeys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    return 1;
    return [self.sortedArrForArrays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.sortedArrForArrays == (id)[NSNull null])
        return 0;
    else
        return  [[self.sortedArrForArrays objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"todayDutyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = str.string;
            for (NSDictionary *dc in self.todayDutyList) {
                if ([[dc objectForKey:@"DoctorName"] isEqualToString:str.string]) {
                    NSString *phaseName = [dc objectForKey:@"PhaseName"];  //"上午"or“下午”
                    NSString *subjectName = [dc objectForKey:@"SubjectName"];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",subjectName,phaseName];
                }
            }
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
    return cell;
}

#pragma mark
#pragma mark - GetchineseString

- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=[NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
        //        [chineseString release];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]]) //here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            //            TempArrForGrouping = [[[NSMutableArray alloc] initWithObjects:nil] autorelease];
            TempArrForGrouping = [[NSMutableArray alloc]init];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}


#pragma mark
#pragma mark - dutyChanged

- (IBAction)dutyChanged:(id)sender {
    NSInteger index =[(UISegmentedControl*)sender selectedSegmentIndex];
    self.status = [NSString stringWithFormat:@"%lo",(long)index+1];
    [self.sectionHeadsKeys removeAllObjects];
    [self.sortedArrForArrays removeAllObjects];
    [self.dataArr removeAllObjects];
    
    [self linkTheNet];
    [self.HUDManager showIndeterminateWithMessage:@""];
    [self.tableView reloadData];
}
@end

