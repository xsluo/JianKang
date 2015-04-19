//
//  TrafficViewController.m
//  eHealth
//
//  Created by nh neusoft on 15/4/17.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "TrafficViewController.h"
#import "Hospital.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"GetHospitalInfo"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define HospitalID @"440604001"

@interface TrafficViewController ()
@property(nonatomic,retain)  NSMutableData *responseData;
@property(nonatomic,retain) NSDictionary *hospitalInfo;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation TrafficViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.;
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    self.webView.delegate = self;
    [self beginConnet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginConnet{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:1];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:HospitalID forKey:@"HospitalID"];
    
    NSError *error=nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=%@&jsonBody=%@",Method,jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    [request setURL:[NSURL URLWithString:URL]];
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
    
    [self.HUDManager hide];
    UILabel *labelTraffic = (UILabel *)[self.view viewWithTag:1];
    labelTraffic.text = @"经过市一医院的线路有132路，805路，桂30路，103路，105路，107路，110路，113路，116路，122路，123路，126路，127路，129路，131路，133路，135路，138路，139路，154路，157路，158路，161路上午班，161路下午班，163路，164A路，165路，182路，184路，255B路，259路，803路，806路，K1路，K3路，广12路，桂27路。";
    
    self.hospitalInfo =[jsonDictionary objectForKey:@"Hospital"];
    [self updateView];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:@"网络连接错误"  duration:2];
}


-(void)updateView{
    if (self.hospitalInfo) {
        NSString *trafficUrl = [self.hospitalInfo objectForKey:@"TrafficUrl"];
        NSURL *url =[NSURL URLWithString:trafficUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

#pragma mark Webview delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.HUDManager showIndeterminateWithMessage:@""] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.HUDManager hide];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.HUDManager showErrorWithMessage:@"网络连接错误"  duration:2];
}
@end
