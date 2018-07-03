//
//  DSXSYCityController.m
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYCityController.h"

#import "ShareArea.h"

@interface DSXSYCityController ()



@end

@implementation DSXSYCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupTableView];
   
}

- (void)p_setupTableView
{
    self.title = @"地区";
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIView *header = [[UIView alloc] init];
    header.height = 30 ;
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.frame = CGRectMake(10, 10, self.view.width, 20);
    label.text = @"全部";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor clearColor];
    [header addSubview:label];
    self.tableView.tableHeaderView = header ;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    //    UIButton *leftB = [[UIButton alloc] initNavigationButtonWithName:@"返回" addTarget:self action:@selector(leftBarButtonItemClick)];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftB];
    //    [leftB sizeToFit];
    
}

- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCities:(NSArray *)cities
{
    _cities = cities ;
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    
    
    //    cell.isLastCell = NO ;
    //    if (indexPath.row == self.cities.count - 1) {
    //        cell.isLastCell = YES ;
    //    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 12312 ;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *address = [NSString stringWithFormat:@"%@_%@", self.selectedProvince,self.cities[indexPath.row]];
    [self getAddress:address];

}

- (void)getAddress:(NSString *)address{
//    DSXLog(@" === %@",self.currentString);
    ShareArea *manager = [ShareArea shareAre];
    manager.allPlace = address;
    
    
    [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 3] animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
