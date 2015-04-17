//
//  DigitHospitalViewController.m
//  eHealth
//
//  Created by Bagu on 15/3/18.
//  Copyright (c) 2015年 PanGu. All rights reserved.
//

#import "DigitHospitalViewController.h"
#import "DigitaHospitalCollectionViewCell.h"
#import "BookViewController.h"
#import "Hospital.h"
#import "MBProgressHUDManager.h"

#define kDataFile @"dataCard"
#define kDataKey  @"defaultCard"

@interface DigitHospitalViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *imageName;
@property NSArray *labelText;
@property (nonatomic,retain) MBProgressHUDManager *HUDManager;

@end

@implementation DigitHospitalViewController
static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //    [self.collectionView registerClass:[DigitaHospitalCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view
    
    self.imageName = [NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png", nil];
    self.labelText =[NSArray arrayWithObjects:@"医院简介",@"医院资讯",@"当日出诊",@"预约挂号",@"候诊",@"咨询",@"停车指南",@"检验检查报告",@"满意度调查", nil];
    
    self.tabBarItem.title = @"数字医院";
    // Do any additional setup after loading the view, typically from a nib.
    self.HUDManager= [[MBProgressHUDManager alloc] initWithView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //#warning Incomplete method implementation -- Return the number of items in the section
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DigitaHospitalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImage *img = [UIImage imageNamed:[self.imageName objectAtIndex:[indexPath row]]];
    cell.imageView.image = img;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.labelName.text = [self.labelText objectAtIndex:[indexPath row]];
    // Configure the cell
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewFlowLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    CGSize size = CGSizeMake(100, 130);
    CGSize size = CGSizeMake(80, 90);
    
    return size;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row]==4){
        NSString *filePath = [self dataFilePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSMutableData *data = [[NSMutableData alloc]initWithContentsOfFile:filePath];
            NSKeyedUnarchiver *unarchiver =[[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            if ([unarchiver decodeObjectForKey:kDataKey]==nil){
                [self.HUDManager showMessage:@"请登录并设置默认健康卡" duration:3];
                return NO;
            }
        }
        else{
            [self.HUDManager showMessage:@"请登录并设置默认健康卡" duration:3];
            return NO;
        }
        return YES;
    }
    return YES;
}

-(NSString *)dataFilePath{
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:kDataFile];
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    const NSTimeInterval kAnimationDuration = 0.2;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        selectedCell.alpha =0.0f;
    } completion:^(BOOL finished) {
        selectedCell.alpha = 1.0f;
    }];
    
    NSString *segueID = [[NSString alloc]initWithFormat:@"%ld",(long)[indexPath row]+1];
    [self performSegueWithIdentifier:segueID sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqual: @"4"]) {
        BookViewController *destination = [segue destinationViewController];
        Hospital *fsdy = [[Hospital alloc]init];
        fsdy.hospitalID = @"440604001";
        fsdy.hospitalName = @"佛山市区第一人民医院";
        destination.hospital = fsdy;
    }
}


@end
