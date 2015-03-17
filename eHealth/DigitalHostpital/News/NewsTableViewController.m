//
//  NewsTableViewController.m
//  eHealth
//
//  Created by nh neusoft on 14-12-25.
//  Copyright (c) 2014年 PanGu. All rights reserved.
//

#import "NewsTableViewController.h"
#import "News.h"
#import "NewsViewController.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetNews"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define Type @"0"
#define HospitalID @"440604001"
#define NewsCategoryID @“1”
@interface NewsTableViewController ()

@property (nonatomic,retain) NSMutableData * responseData;
@property(nonatomic,retain) NSDictionary *selectedNews;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary=[[NSDictionary alloc]initWithObjectsAndKeys:AppKey,@"AppKey",AppSecret,@"AppSecret",Type,@"Type", nil];
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
    self.newsList =[jsonDictionary objectForKey:@"NewsList"];

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
    if(self.newsList!=(id)[NSNull null])
        return [self.newsList count];
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    static NSString* reuseIndentifier =@"newsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    }
    NSInteger row = [indexPath row];
    
    NSDictionary *newsDictionary = [self.newsList objectAtIndex:row];
    self.selectedNews = newsDictionary;
    
    NSString *url = [newsDictionary objectForKey:@"ThumbnailUrl"];
    UIImageView *imgv = (UIImageView *)[cell.contentView viewWithTag:4];
    imgv.contentMode = UIViewContentModeScaleAspectFit;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *img = [UIImage imageWithData:data];
    [imgv setImage:img];
    
    NSString *newsTitle = [newsDictionary objectForKey:@"NewsTitle"];
    UILabel *labelTitle = (UILabel *)[cell.contentView viewWithTag:1];
    labelTitle.text = newsTitle;
    
    NSString *newsContent = [newsDictionary objectForKey:@"NewsContent"];
    UILabel *labelContent = (UILabel *)[cell.contentView viewWithTag:2];
    labelContent.text = newsContent;
    
    NSString *newsCategory = [newsDictionary objectForKey:@"NewsCategoryName"];
    UILabel *labelCategory = (UILabel *)[cell.contentView viewWithTag:3];
    labelCategory.backgroundColor = [UIColor brownColor];
    labelCategory.textColor = [UIColor whiteColor];
    labelCategory.text = newsCategory;
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewsViewController *newsController = (NewsViewController *)segue.destinationViewController;
    News *aNews = newsController.aNews;
    if(self.selectedNews){
        aNews.newsID = [self.selectedNews objectForKey:@"NewsID"];
        aNews.hospitalID = [self.selectedNews objectForKey:@"HospitalID"];
        aNews.newsCategoryID = [self.selectedNews objectForKey:@"NewsCategoryID"];
        aNews.newsCategoryName = [self.selectedNews objectForKey:@"NewsCategoryName"];
        aNews.newsTitle =[self.selectedNews objectForKey:@"NewsTitle"];
        aNews.summary = [self.selectedNews objectForKey:@"Summary"];
        aNews.newsContent = [self.selectedNews objectForKey:@"NewsContent"];
        aNews.thumbnailUrl = [self.selectedNews objectForKey:@"ThumbnailUrl"];
        aNews.creatTime = [self.selectedNews objectForKey:@"CreateTime"];
    }
}

@end
