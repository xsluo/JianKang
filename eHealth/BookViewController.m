//
//  BookViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "BookViewController.h"
#import "GetHospitalTableViewController.h"
#define kArea @"Area"
#define kAreaID @"AreaID"
#define kHospitaID @"HospitalID"
#define kHospitalName @"HospitalName"

@interface BookViewController ()
-(IBAction)unwindSelectHospital:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:kArea]==nil)
        self.areaItem.title = @"选择地区";
    else{
        self.areaItem.title = [userDefaults objectForKey:kArea];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindSelectHospital:(UIStoryboardSegue *)segue{
    [self.tableView reloadData];
}

#pragma mark
#pragma mark - Table view data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bokCell"];
    // Configure the cell...
    static NSString* reuseIndentifier =@"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    }
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *hospitalName = [userDefaults objectForKey:kHospitalName];
            if(hospitalName==nil)
                 cell.textLabel.text = @"请选择医院";
            else
                cell.textLabel.text = hospitalName;
            break;
        }
        case 1:
            cell.textLabel.text = @"请选择科室";
            break;
        case 2:
            cell.textLabel.text = @"请选择医生";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([indexPath row]==0){
        [self performSegueWithIdentifier:@"selectHospital" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"selectHospital"]){
        GetHospitalTableViewController *hpvController = (GetHospitalTableViewController *)segue.destinationViewController;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *areaID = [userDefaults objectForKey:kAreaID];
        if(areaID)
            hpvController.AreaID = areaID;
        else
            hpvController.AreaID = @"440604";
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

@end
