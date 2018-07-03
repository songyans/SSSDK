//
//  DSXSYAddressController.m
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYAddressController.h"

#import "DSXSYCityController.h"
#import <CoreLocation/CoreLocation.h>
#import "ShareArea.h"
@interface DSXSYAddressController ()<CLLocationManagerDelegate>
@property(nonatomic,strong)NSArray *provinces ;
@property(nonatomic,strong)NSDictionary *cities ;
@property(nonatomic,strong)CLLocation *currentLocation;
@property(nonatomic,strong)CLLocationManager *locationManager ;
@property(nonatomic,copy)NSString *currentProvince;
@property(nonatomic,copy)NSString *currentCity;
@property(nonatomic,copy)NSString *currentString;
@property (nonatomic, copy) NSString *addressStr;
@end

@implementation DSXSYAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_setup];
    
    [self p_checkForLocation];
}
#pragma mark - lazy
- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self ;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer ;
    }
    return _locationManager ;
}

- (NSDictionary *)cities
{
    if (!_cities)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
        _cities = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _cities ;
}
- (NSArray *)provinces
{
    if (!_provinces)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
        
        _provinces = [NSArray arrayWithContentsOfFile:path];
    }
    return _provinces ;
}
- (void)p_setup
{
    self.title = @"地区"  ;
    self.tableView.backgroundColor = [UIColor whiteColor] ;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    //    UIButton *leftB = [[UIButton alloc] initNavigationButtonWithName:@"返回" addTarget:self action:@selector(leftBarButtonItemClick)];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftB];
    //    [leftB sizeToFit];
    
   }

- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  定位服务是否开启
 */
- (void)p_checkForLocation
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined)
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if(status == kCLAuthorizationStatusDenied || status ==kCLAuthorizationStatusRestricted )
    {
        self.currentString = @"定位服务已关闭";
    }
    else
    {
        [self.locationManager startUpdatingLocation];
        self.currentString = @"正在定位...";
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLoc = [locations lastObject];
    
    if (!self.currentLocation && currentLoc) {
        self.currentLocation = currentLoc ;
        NSLog(@"当前的地理坐标位置：%@",self.currentLocation);
        //定位当前地址
        [self p_locateCurrentAddress];
        [manager stopUpdatingLocation];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //        GYLog(@"%@",placemarks.lastObject);
            CLPlacemark *pm = placemarks.lastObject;
            //        GYLog(@"%@ %@",pm.administrativeArea ,pm.locality);
            self.currentProvince = pm.administrativeArea ;
            if([self.currentProvince containsString:@"省"]){
                self.currentProvince =[self.currentProvince substringToIndex:self.currentProvince.length - 1];
            }
            self.currentCity = pm.locality ;
            if([self.currentCity containsString:@"市"]){
                self.currentCity =[self.currentCity substringToIndex:self.currentCity.length - 1];
            }
            self.currentString = [NSString stringWithFormat:@"%@ %@",self.currentProvince ,self.currentCity];
            
            NSLog(@"当前---%@-----%@",self.currentProvince,self.currentCity);
            self.currentString = [NSString stringWithFormat:@"%@ %@",self.currentProvince,self.currentCity];
            self.addressStr = [NSString stringWithFormat:@"%@_%@",self.currentProvince,self.currentCity];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
}

/**
 *  上传坐标。
 */
- (void)p_locateCurrentAddress
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@",@"",@""];
    NSDictionary *params = @{
                             @"uid" : URLString,
                             @"lat" : @(self.currentLocation.coordinate.latitude),
                             @"lon" : @(self.currentLocation.coordinate.longitude)
                             };
    
    NSLog(@"上传坐标%f--%e",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
    ;
   
    
    if (params){
        NSLog(@"上传坐标%@",params);
        if ([params[@"code"] intValue] == 200) {
            
            
        }
        else {
            
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section ? self.provinces.count : 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0)
    {
        cell.textLabel.text = self.currentString ;
        
        
    }
    else
    {
        cell.textLabel.text = self.provinces[indexPath.row];
        
        
    }
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] init];
    label.origin = CGPointMake(34  , 132) ;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    if (section == 0) {
        label.text = @"定位到的位置";
    }else{
        label.text = @"全部";
    }
    [label sizeToFit];
    [view addSubview:label];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 324, 0.5)];
    topView.backgroundColor = [UIColor grayColor];
    [view addSubview:topView];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 234 ;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.currentString.length < 1) {
            self.currentString = @"正在定位..." ;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.locationManager startUpdatingLocation];
            return;
        }
        else if ([self.currentString isEqualToString:@"定位服务已关闭"]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"定位服务已关闭" message:@"请在系统设置选项中允许善信访问你的定位服务" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:settingURL];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else if ([self.currentString isEqualToString:@"正在定位..." ] || [self.currentString isEqualToString:@"" ]) {
            return ;
        }
        else if ([self.currentString isEqualToString:@"定位失败，请点击重试"]) {
            self.currentString = @"正在定位..." ;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.locationManager startUpdatingLocation];
            return ;
        }
        else {
            
          //            self.currentString
            [self getAddress];
//           
            
            }
        
    }else{
        //跳转到市级页面
        DSXSYCityController *citiesVc = [[DSXSYCityController alloc] init] ;
        citiesVc.selectedProvince = self.provinces[indexPath.row];
        citiesVc.cities = self.cities[self.provinces[indexPath.row]];
        [self.navigationController pushViewController:citiesVc animated:YES];
    }
}

- (void)getAddress{
    
    NSLog(@" === %@",self.addressStr);
    
    ShareArea *manager = [ShareArea shareAre];
    manager.allPlace = self.addressStr;
    
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
