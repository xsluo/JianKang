//
//  DepartmentTableViewController.m
//  eHealth
//
//  Created by Bagu on 14/12/16.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import "DepartmentTableViewController.h"
#import "DepartmentIntroduction.h"
#import "Department.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetDepartmentList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define Type @"1"
#define HospitalID @"440604001"

@interface DepartmentTableViewController ()
{

}
@end

@implementation DepartmentTableViewController
-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.departmentList = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:4];
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:Type forKey:@"Type"];
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
    
    //------------------------------
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
    self.departmentList =[jsonDictionary objectForKey:@"DepartmentList"];

    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.departmentList!=(id)[NSNull null])
        return [self.departmentList count];
    else
        return 0;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString* reuseIndentifier =@"departmentCell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
     
     if (cell==nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
     }
     NSInteger row = [indexPath row];
     
     NSDictionary *department = [self.departmentList objectAtIndex:row];

     NSString *departmentName = [department objectForKey:@"DepartmentName"];
     cell.textLabel.text = [NSString stringWithFormat:@"%@",departmentName];
 
 return cell;
 }


 #pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *departmentInfo = [self.departmentList objectAtIndex:indexPath.row];
    
    Department *dpt = [[Department alloc] init];
    DepartmentIntroduction *DepartmentDetail = segue.destinationViewController;
    if (![[departmentInfo objectForKey:@"DepartmentName"] isEqual:[NSNull null]]) {
        dpt.departmentName = [departmentInfo objectForKey:@"DepartmentName"];
    }
    if (![[departmentInfo objectForKey:@"Introduction"] isEqual:[NSNull null]]) {
        dpt.introduction = [departmentInfo objectForKey:@"Introduction"];
    }
    DepartmentDetail.department = dpt;
}

@end
