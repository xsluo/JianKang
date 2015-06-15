//
//  StarTabTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/6/3.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "StarTabTableViewController.h"
#import "RatingBar.h"
#import "MBProgressHUDManager.h"
#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"AddSatisfaction"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define kUserName @"username"

@interface StarTabTableViewController ()
@property NSArray *arrayTitle;
@property NSMutableArray *arrayScore;
@property(nonatomic,retain)  NSMutableData *responseData;

@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation StarTabTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayTitle = [NSArray arrayWithObjects:@"1.您对医院的清洁卫生满意吗？",
                       @"2.您对分诊、导诊的服务满意吗？",
                       @"3.您对挂号、收费工作人员的服务满意吗？",
                       @"4.您对接诊医生的服务态度满意吗？",
                       @"5.您对接诊医生对病情、检验检查结果的解释满意吗？",
                       @"6.您对分诊、导诊的服务满意吗？",
                       @"7.您对治疗结果满意吗？",
                       @"8.您对本次门诊就诊的总体结果满意吗？",
                       @"9.您对分诊、导诊的服务满意吗？",
                       @"10.您对分诊、导诊的服务满意吗？",
                       @"11.您对分诊、导诊的服务满意吗？",
                       @"12.您对分诊、导诊的服务满意吗？",
                       @"13.您对分诊、导诊的服务满意吗？",
                       @"14.您对分诊、导诊的服务满意吗？",
                       @"15.您对分诊、导诊的服务满意吗？",
                       @"16.您对分诊、导诊的服务满意吗？",
                       @"17.您对分诊、导诊的服务满意吗？",
                       @"18.您对分诊、导诊的服务满意吗？",
                       @"19.您对分诊、导诊的服务满意吗？",
                       @"20.您对分诊、导诊的服务满意吗？",nil];
    
    self.arrayScore = [[NSMutableArray alloc]initWithObjects:@"0",nil];
    for (int i=0; i<19; i++) {
        [self.arrayScore addObject:@"0"];
    }
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 8;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = nil;
    UITableViewCell *cell=nil;
    
    if ([indexPath section]==0) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"scheduleCell"];
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
        labelTitle.text =[self.arrayTitle objectAtIndex:[indexPath row]];
        [cell.contentView addSubview:labelTitle];
        
        RatingBar *bar = [[RatingBar alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
        bar.starNumber =[ [self.arrayScore objectAtIndex:[indexPath row]] integerValue];
        bar.tag = 1;
        CGPoint point = cell.contentView.center;
        point.y = point.y +15;
        point.x = point.x -50;
        bar.center = point;
        [cell.contentView addSubview:bar];
        
        UILabel *labelScore = [[UILabel alloc] initWithFrame:CGRectMake(248, 0, 60, 30)];
        labelScore.text = [NSString stringWithFormat:@"%@分",[self.arrayScore objectAtIndex:[indexPath row]] ];
        point.x = point.x +150;
        labelScore.center = point;
        labelScore.tag = 2;
        [cell.contentView addSubview:labelScore];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(execute:) name:@"TAPPED" object:bar];
    }
    else{
        identifier = @"confirmCell";
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        CGRect rect = cell.contentView.frame;
        
        rect.origin.x = rect.origin.x + rect.size.width *0.05;
        rect.size.width =rect.size.width*0.9;
        
        rect.origin.y = rect.origin.y + rect.size.height *0.4;
        rect.size.height = rect.size.height*0.6;
        
        UIButton *confirmButton = [[UIButton alloc] initWithFrame:rect];
        confirmButton.layer.cornerRadius = 4;
        confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
        confirmButton.backgroundColor= [UIColor colorWithRed:252.0/255 green:106.0/255 blue:8.0/255 alpha:1.0];
        [confirmButton setTitle:@"提交调查问卷" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(present:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:confirmButton];
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void) present:(id)sender{
    [self.tableView setHidden:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName =[userDefaults objectForKey:kUserName];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:8];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:@"1" forKey:@"Type"];
    [dictionary setObject:@"10" forKey:@"SatisfactionCategoryID"];
    [dictionary setObject:[self.record objectForKey:@"BookingRecordID"] forKey:@"BookingRecordID"];
    [dictionary setObject:[self.record objectForKey:@"DoctorID"] forKey:@"DoctorID"];
    [dictionary setObject:userName forKey:@"UserName"];
    [dictionary setObject:[self.arrayScore objectAtIndex:0]  forKey:@"Item1"];
    [dictionary setObject:[self.arrayScore objectAtIndex:1]  forKey:@"Item2"];
    [dictionary setObject:[self.arrayScore objectAtIndex:2]  forKey:@"Item3"];
    [dictionary setObject:[self.arrayScore objectAtIndex:3]  forKey:@"Item4"];
    [dictionary setObject:[self.arrayScore objectAtIndex:4]  forKey:@"Item5"];
    [dictionary setObject:[self.arrayScore objectAtIndex:5]  forKey:@"Item6"];
    [dictionary setObject:[self.arrayScore objectAtIndex:6]  forKey:@"Item7"];
    [dictionary setObject:[self.arrayScore objectAtIndex:7]  forKey:@"Item8"];
    
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
    
    //    [self.HUDManager showMessage:@"提交问卷成功！" duration:2 complection:^{
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }];
}

-(void)execute:(NSNotification * )sender{
    RatingBar *ratingBar = sender.object;
    UIView *ratingView = [sender.object superview];
    
    UILabel *labelRating = (UILabel *)[ratingView viewWithTag:2];
    labelRating.text = [NSString stringWithFormat:@"%ld分",(long)ratingBar.starNumber];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    NSString *stringScore = [NSString stringWithFormat:@"%ld",(long)ratingBar.starNumber];
    [self.arrayScore replaceObjectAtIndex:[indexPath row] withObject:stringScore];
    //    [self.tableView reloadData];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    NSString *msg =[jsonDictionary objectForKey:@"Message"];
    [self.HUDManager showMessage:msg duration:2 complection:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络无法连接" duration:2];
}


@end
