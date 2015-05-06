//
//  RegisterController.m
//  eHealth
//
//  Created by Bagu on 15/1/5.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "RegisterController.h"
#import "MBProgressHUDManager.h"

#define URL @"http://202.103.160.153:2001/WebAPI.ashx"
#define Method @"RegisterMember"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textCAPTCHA;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textPwdConfirm;
@property (weak, nonatomic) IBOutlet UITextField *textMember;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellMale;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellFamale;
@property (nonatomic,retain) NSString *gender;
@property (nonatomic,retain) MBProgressHUDManager *HUDManager;
@property NSInteger connectionType;
@property(nonatomic,retain)   NSMutableData *responseData;

- (IBAction)getCAPTCHA:(id)sender;
- (IBAction)Register:(id)sender;
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.HUDManager= [[MBProgressHUDManager alloc] initWithView:self.view];
    
    //    [self.HUDManager showIndeterminateWithMessage:@""];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.gender = @"0";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

//-(double) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 48;
//}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if(section==3&&row==0){
        self.cellMale.accessoryType = UITableViewCellAccessoryCheckmark;
        self.cellFamale.accessoryType = UITableViewCellAccessoryNone;
        self.gender = @"1";
    }
    if(section==3&&row==1){
        self.cellMale.accessoryType = UITableViewCellAccessoryNone;
        self.cellFamale.accessoryType = UITableViewCellAccessoryCheckmark;
        self.gender = @"0";
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
            //            NSLog(@"Regist successfully");
            [self.HUDManager showMessage:@"注册成功" duration:3 complection:^{
                [self.navigationController popoverPresentationController];
            }];
        }
        else if(self.connectionType ==1)
            //            NSLog(@"Get CAPTCHA successfully!");
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


- (IBAction)getCAPTCHA:(id)sender {
    self.connectionType = 1;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:3];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:[self.textPhone text] forKey:@"PhoneNumber"];
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    if(error){
        NSLog(@"error:%@",error);
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"method=GetCAPTCHA&jsonBody=%@",jsonString];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [self.HUDManager showIndeterminateWithMessage:@""];
    [connection start];
}

- (IBAction)Register:(id)sender {
    self.connectionType = 0;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:8];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:self.textPhone.text forKey:@"PhoneNumber"];
    [dictionary setObject:self.textPassword.text forKey:@"Password"];
    [dictionary setObject:self.textPwdConfirm.text forKey:@"ConfirmPassword"];
    [dictionary setObject:self.textCAPTCHA.text forKey:@"CAPTCHA"];
    [dictionary setObject:self.textMember.text forKey:@"MemberName"];
    [dictionary setObject:self.gender forKey:@"Sex"];
    
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
@end
