//
//  BookViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "BookViewController.h"
#import "MBProgressHUDManager.h"

#import "Area.h"
#import "Hospital.h"
#import "Department.h"
#import "Doctor.h"
#import "GetHospitalTableViewController.h"
#import "GetDepartmentTableViewController.h"
#import "GetDoctorTableViewController.h"
#import "ScheduleTableViewController.h"

#define kAreaName @"AreaName"
#define kAreaID @"AreaID"
#define kUserName @"username"

@interface BookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIView *panelView;

-(IBAction)unwindSelectHospital:(UIStoryboardSegue *)segue;
-(IBAction)unwindSelectDepartment:(UIStoryboardSegue *)segue;
-(IBAction)unwindSelectDoctor:(UIStoryboardSegue *)segue;
@property (retain,nonatomic) MBProgressHUDManager *HUDManager;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    self.hospital = nil;
    self.department = nil;
    self.doctor = nil;
    self.panelView = [self.view viewWithTag:999];
    [self.panelView setHidden:YES];
    self.HUDManager = [[MBProgressHUDManager alloc] initWithView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:kAreaName]==nil)
        self.areaItem.title = @"选择地区";
    else{
        self.areaItem.title = [userDefaults objectForKey:kAreaName];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindSelectHospital:(UIStoryboardSegue *)segue{
    Hospital *hspt= [segue.sourceViewController hospital];
    self.hospital = hspt;
    self.department = nil;
    self.doctor = nil;
    [self.panelView setHidden:YES];

    [self.tableView reloadData];
}

-(IBAction)unwindSelectDepartment:(UIStoryboardSegue *)segue{
    Department *dpt= [segue.sourceViewController department];
    if ([dpt departmentID]!=nil) {
        self.department = dpt;
    }
    else{
        self.department = nil;
    }
    self.doctor = nil;
    [self.panelView setHidden:YES];
    [self.tableView reloadData];
}

-(IBAction)unwindSelectDoctor:(UIStoryboardSegue *)segue{
    Doctor *dct= [segue.sourceViewController doctor];
    self.doctor = dct;
    
    if(self.doctor){
//        UIView *panelView = [self.view viewWithTag:999];
        
        UIImageView *imageAvatar = (UIImageView *)[_panelView viewWithTag:11];
        UILabel *labelDoctorName = (UILabel *) [_panelView viewWithTag:12];
        UILabel *labelHospitalName = (UILabel *)[_panelView viewWithTag:13];
        UILabel *labelIntroduction = (UILabel *)[_panelView viewWithTag:14];
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dct avatarUrl]]];
        UIImage *img= [UIImage imageWithData:data];
        if(!img)
            img = [UIImage imageNamed:@"man.png"];
        imageAvatar.image = img;
        
        labelDoctorName.text = dct.doctorName;
        labelHospitalName.text = dct.hospitalName;
        if([dct.introduction isEqual:[NSNull null]])
            labelIntroduction.text = nil;
        else
            labelIntroduction.text = dct.introduction;
        [self.panelView setHidden:NO];
    }
    
    [self.tableView reloadData];
}


#pragma mark
#pragma mark - Table view data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView]) {
        return 3;
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* reuseIndentifier =@"bookCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIndentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIndentifier];
    }
    NSInteger row = [indexPath row];
    switch (row) {
        case 0:{
            if(!self.hospital){
                cell.textLabel.text = @"请选择医院";
//                UIImage *img0 = [UIImage imageNamed:@"house.png"];

                cell.textLabel.textColor = [UIColor blueColor];
            }
            else{
                cell.textLabel.text = [self.hospital hospitalName];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            UIImage *img0 = [UIImage imageNamed:@"house.png"];
            cell.imageView.image = img0;
            break;
        }
        case 1:{
            if(!self.department){
                cell.textLabel.text = @"请选择科室";
                UIImage *img1 = [UIImage imageNamed:@"layer.png"];
                cell.imageView.image = img1;
                cell.textLabel.textColor = [UIColor blueColor];
            }
            else{
                cell.textLabel.text = [self.department  departmentName];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            break;
        }
        case 2:{
            if(!self.doctor){
                cell.textLabel.text = @"请选择医生";
                UIImage *img2 = [UIImage imageNamed:@"man.png"];
                cell.imageView.image = img2;
                cell.textLabel.textColor = [UIColor blueColor];
            }
            else{
                cell.textLabel.text = [self.doctor  doctorName];
                cell.textLabel.textColor = [UIColor blackColor];
            }
            break;
        }
        default:
            break;
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch ([indexPath row]) {
        case 0:{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if([userDefaults objectForKey:kAreaName]!=nil)
                [self performSegueWithIdentifier:@"selectHospital" sender:self];
            else
                [self.HUDManager showMessage:@"请先选择医院所在地区" duration:3];
            break;
        }
        case 1:{
            if(self.hospital)
                [self performSegueWithIdentifier:@"selectDepartment" sender:self];
            else
                [self.HUDManager showMessage:@"请先选择科室所在医院" duration:3];
            break;
        }
        case 2:{
            if(self.department)
                [self performSegueWithIdentifier:@"selectDoctor" sender:self];
            else
                [self.HUDManager showMessage:@"请先选择医生所在科室" duration:3];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"selectArea"]) {
        self.hospital=nil;     //重选地区后，清空医院、科室和医生值
        self.department = nil;
        self.doctor=nil;
        
        UIView *panelView = [self.view viewWithTag:999];
        [panelView setHidden:YES];
        
        [self.tableView reloadData];
    }
    else if([[segue identifier] isEqualToString:@"selectHospital"]){
        GetHospitalTableViewController *hpvController = (GetHospitalTableViewController *)segue.destinationViewController;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *areaID = [userDefaults objectForKey:kAreaID];
        if(areaID)
            hpvController.AreaID = areaID;
    }
    else if([[segue identifier] isEqualToString:@"selectDepartment"]){
        GetDepartmentTableViewController *dpvController = (GetDepartmentTableViewController *)segue.destinationViewController;
        Hospital *hpt = [[Hospital alloc]init];
        if (self.hospital)
            hpt= [self hospital];
        dpvController.hospital = hpt;
    }
    else if([[segue identifier] isEqualToString:@"selectDoctor"]){
        GetDoctorTableViewController *dctvController = (GetDoctorTableViewController *)segue.destinationViewController;
        Department *dpt;
        if (self.department)
            dpt= [self department];
        dctvController.department = dpt;
    }
    else if([[segue identifier] isEqualToString:@"getSchedule"]){
        ScheduleTableViewController *schdvController = (ScheduleTableViewController *)segue.destinationViewController;
        Doctor *dct;
        if (self.doctor)
            dct= [self doctor];
        schdvController.doctor = dct;
    }
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:kUserName]==nil && [identifier isEqual: @"getSchedule"] ){
        [self.HUDManager showMessage:@"请先登录帐号" duration:3];
        return NO;
    }
    else
        return YES;
}

@end
