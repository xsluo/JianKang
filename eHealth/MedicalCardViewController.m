//
//  MedicalCardViewController.m
//  eHealth
//
//  Created by Bagu on 15/1/6.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "MedicalCardViewController.h"
#import "MedicalCard.h"
#import "CardViewController.h"
#import "AddMedicalCardController.h"

#define URL @"http://202.103.160.154:1210/WebAPI.ashx"
#define Method @"GetMedicalCardList"
#define AppKey @"JianKangEYuanIOS"
#define AppSecret @"8D994823EBD9F13F34892BB192AB9D85"
#define kUserName @"username"

@interface MedicalCardViewController ()

@property (nonatomic,retain)NSMutableArray *medicalCardList;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain)   NSMutableData *responseData;
@property (nonatomic,strong) NSIndexPath *lastIndexPath;

@property (nonatomic,retain) NSMutableArray *cards;
@property (strong,nonatomic) MedicalCard *selectedCard;

@end

@implementation MedicalCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    //    self.medicalCardList = [[NSMutableArray alloc]init];
    self.medicalCardList = nil;
    self.lastIndexPath = nil;
    self.cards = [[NSMutableArray alloc] init];
    [self setRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    //    // Return the number of rows in the section.
    if(self.medicalCardList!=(id)[NSNull null])
        return [self.medicalCardList count];
    else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseIndentifier =@"cardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSInteger row = [indexPath row];
    NSInteger oldRow = [self.lastIndexPath row];
    cell.accessoryType = (row==oldRow&&self.lastIndexPath!=nil)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger newRow = [indexPath row];
    NSInteger oldRow = (self.lastIndexPath!=nil)?[self.lastIndexPath row]:-1;
    if(newRow!=oldRow||self.lastIndexPath ==0){
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastIndexPath = indexPath;
    };
    self.selectedCard = [self.cards objectAtIndex:newRow];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"prepareForSegue!");
//    if([[segue destinationViewController] isEqualToString:@"showCardDetail"]){
    if([[segue identifier] isEqualToString:@"showCardDetail"]){
        CardViewController *detail =  segue.destinationViewController ;
        detail.medicalCard = [self selectedCard];
    }
    if([[segue identifier] isEqualToString:@"addCard"]){
        AddMedicalCardController *addCard = segue.destinationViewController;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userName =[userDefaults objectForKey:kUserName];
        addCard.userName =userName;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"showCardDetail"] &&(self.lastIndexPath !=nil))
        return  YES;
    if([identifier isEqualToString:@"addCard"])
        return YES;
    return NO;
    }
@end