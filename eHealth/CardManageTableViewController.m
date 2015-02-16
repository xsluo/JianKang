//
//  CardManageTableViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/15.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "CardManageTableViewController.h"
#import "MedicalCard.h"
#import "CardDetailViewController.h"
#import "AddMedicalCardController.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetMedicalCardList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define kUserName @"username"

@interface CardManageTableViewController ()
@property (nonatomic,retain)NSMutableArray *medicalCardList;
//@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)   NSMutableData *responseData;
@property (nonatomic,strong) NSIndexPath *lastIndexPath;
@property (nonatomic,retain) NSMutableArray *cards;
@property (strong,nonatomic) MedicalCard *selectedCard;
@end

@implementation CardManageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.medicalCardList = nil;
    self.lastIndexPath = nil;
    self.cards = [[NSMutableArray alloc] init];
    [self setRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRequest{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName =[userDefaults objectForKey:kUserName];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dictionary setObject:AppKey forKey:@"AppKey"];
    [dictionary setObject:AppSecret forKey:@"AppSecret"];
    [dictionary setObject:userName forKey:@"UserName"];
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
    
    //    if([connection.currentRequest.URL.  isEqualToString:URL]){
    NSError *error = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:kNilOptions error:&error];
    if (jsonDictionary == nil) {
        NSLog(@"json parse failed");
        return;
    }
    self.medicalCardList =[jsonDictionary objectForKey:@"MedicalCardList"];
    [self.tableView reloadData];
    //    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"%@",[error localizedDescription]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    //    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    //    // Return the number of rows in the section.
    if(section ==0){
    if(self.medicalCardList!=(id)[NSNull null])
        return [self.medicalCardList count];
    else
        return 0;
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath section]==0){
        static NSString* reuseIndentifier =@"cardCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        NSInteger row = [indexPath row];
        NSInteger oldRow = [self.lastIndexPath row];
        
        cell.detailTextLabel.text = (row==oldRow&&self.lastIndexPath!=nil)?@"默认":@"";
        NSDictionary *cardDictionary = [self.medicalCardList objectAtIndex:row];
        
        MedicalCard *card = [[MedicalCard alloc] init];
        card.medicalCardID = [cardDictionary objectForKey:@"MedicalCardID"];
        card.medicalCardTypeID = [cardDictionary objectForKey:@"MedicalCardTypeID"];
        card.medicalCardTypeName = [cardDictionary objectForKey:@"MedicalCardTypeName"];
        card.medicalCardCode = [cardDictionary objectForKey:@"MedicalCardCode"];
        card.owner = [cardDictionary objectForKey:@"Owner"];
        card.ownerSex = [cardDictionary objectForKey:@"OwnerSex"];
        card.ownerAge = [cardDictionary objectForKey:@"OwnerAge"];
        card.ownerPhone = [cardDictionary objectForKey:@"OwnerPhone"];
        card.ownerTel = [cardDictionary objectForKey:@"OwnerTel"];
        card.ownerIDCard = [cardDictionary objectForKey:@"OwnerIDCard"];
        card.ownerEmail = [cardDictionary objectForKey:@"OwnerEmail"];
        card.ownerAdress = [cardDictionary objectForKey:@"OwnerAdress"];
        
        [self.cards addObject:card];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@<%@>",[card owner],[card medicalCardTypeName]];
        cell.detailTextLabel.textColor = [UIColor redColor];
        return cell;
    }
    else{
        static NSString* reuseIndentifier =@"button";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
        
        if (cell==nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
        }
        cell.textLabel.textColor = [UIColor yellowColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"添加健康卡";
        cell.textLabel.backgroundColor = [UIColor blueColor];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section]==0){
        NSInteger newRow = [indexPath row];
        NSInteger oldRow = (self.lastIndexPath!=nil)?[self.lastIndexPath row]:-1;
        if(newRow!=oldRow||self.lastIndexPath ==0){
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.detailTextLabel.text = @"默认";
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
            oldCell.detailTextLabel.text = @"";
            self.lastIndexPath = indexPath;
        };
        self.selectedCard = [self.cards objectAtIndex:newRow];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
        [self performSegueWithIdentifier:@"addCard" sender:self];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.selectedCard = [self.cards objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"showCardDetail" sender:[tableView cellForRowAtIndexPath: indexPath]];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0&&![self.medicalCardList  isEqual:[NSNull null]])
        return @"点击行选择默认健康卡，点击右边图标查看卡片详细信息";
    else
        return @"添加健康卡";
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showCardDetail"]){
        CardDetailViewController *detail =  segue.destinationViewController ;
        detail.medicalCard = [self selectedCard];
    }
//    if([[segue identifier] isEqualToString:@"addCard"]){
//        AddMedicalCardController *addCard = segue.destinationViewController;
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSString *userName =[userDefaults objectForKey:kUserName];
//        addCard.userName =userName;
//    }

}
@end

