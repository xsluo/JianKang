//
//  HealthTrendTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/6/4.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "HealthTrendTableViewController.h"
#import "HealthTrendViewController.h"
#import "News.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetHealthNews"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define Type @"2"
#define NewsCategoryID @"999"

@interface HealthTrendTableViewController ()
@property (nonatomic,retain) NSMutableData * responseData;
@property(nonatomic,retain) NSMutableArray *newsList;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation HealthTrendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsList = [[NSMutableArray alloc]init];
    
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:AppKey,@"AppKey",AppSecret,@"AppSecret",Type,@"Type", NewsCategoryID,@"NewsCategoryID",nil];
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
    
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    // 设置缓存的大小为1M
    [urlCache setMemoryCapacity:1*1024*1024];
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    //判断是否有缓存
    if (response != nil){
        [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
    }
    
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
    
    if([_responseData length]==0)
        return;
    
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed");
        return;
    }
    
    [self.HUDManager hide];
    self.newsList =[jsonDictionary objectForKey:@"NewsList"];
    
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"无法连接网络"  duration:2];
}

#pragma mark
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.newsList!=(id)[NSNull null])
        return [self.newsList count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    static NSString* reuseIndentifier =@"trendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    }
    NSInteger row = [indexPath row];
    
    NSDictionary *newsDictionary = [self.newsList objectAtIndex:row];
    //    self.selectedNews = newsDictionary;
    
    NSString *url = [newsDictionary objectForKey:@"ThumbnailUrl"];
    UIImageView *imgv = (UIImageView *)[cell.contentView viewWithTag:4];
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *img = [UIImage imageWithData:data];
    if (img==nil) {
        img = [UIImage imageNamed:@"default.jpg"];
    }
    [imgv setImage:img];
    
    NSString *newsCategory = [newsDictionary objectForKey:@"NewsCategoryName"];
    UILabel *labelCategory = (UILabel *)[cell.contentView viewWithTag:1];
    labelCategory.text = newsCategory;
    
    NSString *newsTitle = [newsDictionary objectForKey:@"NewsTitle"];
    UILabel *labelTitle = (UILabel *)[cell.contentView viewWithTag:2];
    labelTitle.text = newsTitle;
    
    NSString *newsSummary = [newsDictionary objectForKey:@"Summary"];
    UILabel *labelSummary = (UILabel *)[cell.contentView viewWithTag:3];
    labelSummary.text = newsSummary;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    self.selectedNews = [self.newsList objectAtIndex:[indexPath row]];
    //    [self performSegueWithIdentifier:@"showNews" sender:self];
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell *cell = (UITableViewCell*)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *newsDictionary = [self.newsList objectAtIndex:[indexPath row]];
    NSString *str = [newsDictionary objectForKey:@"NewsContent"];
    HealthTrendViewController *viewController = [segue destinationViewController];
    viewController.txtNewsContent = str;
}

@end
