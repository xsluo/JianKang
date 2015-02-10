//
//  BookViewController.m
//  eHealth
//
//  Created by Bagu on 15/2/1.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "BookViewController.h"
#import "Area.h"
#import "Hospital.h"
#import "Department.h"
#import "Doctor.h"
#import "GetHospitalTableViewController.h"
#import "GetDepartmentTableViewController.h"
#import "GetDoctorTableViewController.h"

#define kAreaName @"AreaName"
#define kAreaID @"AreaID"

@interface BookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) Hospital *hospital;
@property (strong,nonatomic) Department *department;
@property (strong,nonatomic) Doctor *doctor;

-(IBAction)unwindSelectHospital:(UIStoryboardSegue *)segue;
@end

@implementation BookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.hospital = nil;
    self.department = nil;
    self.doctor = nil;
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
    
    [self.tableView reloadData];
}

-(IBAction)unwindSelectDepartment:(UIStoryboardSegue *)segue{
    
    Department *dpt= [segue.sourceViewController department];
    self.department = dpt;
    self.doctor = nil;
    [self.tableView reloadData];
}

-(IBAction)unwindSelectDoctor:(UIStoryboardSegue *)segue{
    
    Doctor *dct= [segue.sourceViewController doctor];
    self.doctor = dct;
    [self.tableView reloadData];
}


#pragma mark
#pragma mark - Table view data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
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
            if(self.hospital == nil)
                 cell.textLabel.text = @"请选择医院";
            else
                cell.textLabel.text = [self.hospital hospitalName];
            break;
        }
        case 1:{
            if(self.department ==nil)
                cell.textLabel.text = @"请选择科室";
            else
                cell.textLabel.text = [self.department  departmentName];
            break;
        }
        case 2:{
            if(self.doctor ==nil)
                cell.textLabel.text = @"请选择医生";
            else
                cell.textLabel.text = [self.doctor  doctorName];
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch ([indexPath row]) {
        case 0:
            [self performSegueWithIdentifier:@"selectHospital" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"selectDepartment" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"selectDoctor" sender:self];
            break;
        default:
            break;
    }
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"selectArea"]) {
        self.hospital=nil;
        self.department = nil;
        [self.tableView reloadData];
    }
    else if([[segue identifier] isEqualToString:@"selectHospital"]){
        GetHospitalTableViewController *hpvController = (GetHospitalTableViewController *)segue.destinationViewController;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *areaID = [userDefaults objectForKey:kAreaID];
        if(areaID)
            hpvController.AreaID = areaID;
        else
            hpvController.AreaID = @"440604";
    }
    else if([[segue identifier] isEqualToString:@"selectDepartment"]){
        GetDepartmentTableViewController *dpvController = (GetDepartmentTableViewController *)segue.destinationViewController;
        Hospital *hpt = [[Hospital alloc]init];
        if (self.hospital==nil) {
            hpt.hospitalID = @"440604001";
        }
        else
            hpt= [self hospital];
        dpvController.hospital = hpt;
    }
    else if([[segue identifier] isEqualToString:@"selectDoctor"]){
        GetDoctorTableViewController *dctvController = (GetDoctorTableViewController *)segue.destinationViewController;
        Department *dpt = [[Department alloc]init];
        if (self.department==nil) {
            dpt.departmentID = @"200000568";
        }
        else
            dpt= [self department];
        dctvController.department = dpt;
    }
}

@end
