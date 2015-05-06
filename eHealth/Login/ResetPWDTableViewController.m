//
//  ResetPWDTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/5/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "ResetPWDTableViewController.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"ResetPassword"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface ResetPWDTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UITextField *textNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *textCAPTCHA;
@property NSInteger connectionType;

- (IBAction)ressetPassword:(id)sender;
- (IBAction)getCAPTCHA:(id)sender;
@property (nonatomic,retain) MBProgressHUDManager *HUDManager;
@property(nonatomic,retain)   NSMutableData *responseData;
@end

@implementation ResetPWDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HUDManager= [[MBProgressHUDManager alloc] initWithView:self.view];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSString *resultCode = [jsonDictionary objectForKeyedSubscript:@"ResultCode"];
    
    if([resultCode isEqualToString:@"0000"]){
        if(self.connectionType ==0){
            [self.HUDManager showMessage:@"重设密码成功" duration:3 complection:^{
                [self.navigationController popoverPresentationController];
            }];
        }
        else
            [self.HUDManager showMessage:@"请查收短信" duration:2];
    }
    else{
        NSString *msg = [jsonDictionary objectForKey:@"Message"];
        [self.HUDManager showMessage:msg duration:2];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
    [self.HUDManager showErrorWithMessage:[error localizedDescription] duration:2];
}

- (IBAction)ressetPassword:(id)sender {
    self.connectionType = 0;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:6];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:self.textUserName.text forKey:@"UserName"];
    [dictionary setObject:self.textNewPassword.text forKey:@"NewPassword"];
    [dictionary setObject:self.textConfirmPassword.text forKey:@"ConfirmPassword"];
    [dictionary setObject:self.textCAPTCHA.text forKey:@"CAPTCHA"];
    
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
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    [connection start];
}

- (IBAction)getCAPTCHA:(id)sender {
    self.connectionType = 1;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:3];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:self.textUserName.text forKey:@"PhoneNumber"];
    
    NSError *error=nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=GetCAPTCHA&jsonBody=%@",jsonString];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self.HUDManager showIndeterminateWithMessage:@""];
    
    [connection start];
}

@end
