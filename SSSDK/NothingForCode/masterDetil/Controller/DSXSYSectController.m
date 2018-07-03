//
//  DSXSYSectController.m
//  善信
//
//  Created by LQ on 2017/6/6.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYSectController.h"


#import "DSXSYSectCell.h"
@interface DSXSYSectController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  <DSXSYSectModel *>*sectArray;
@end

@implementation DSXSYSectController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择宗派";
    
    [self loadData];
    [self createTableView];
 }

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];

}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 324, 234 - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)createTableView{
    [self.view addSubview:self.tableView];
    
}


- (void)loadData{
    Weak_Self;
    self.sectArray = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/api/master/attestation/sectarianList.do",@""];
    SYLog(@"%@", url);
    
    NSDictionary *params = @{
                             @"uid" : @121,
                             
                             };
   if (params){
        
        NSLog(@"--------------%@", params);
        if ([params[@"code"] integerValue] == 200) {
            weakSelf.sectArray = [NSMutableArray arrayWithObject:params];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }else{
            weakSelf.sectArray = [NSMutableArray arrayWithObject:params];
        }
        
   } ;
    

    //
}

# pragma mark --------------------------------------------------------------- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier =@"DSXSYSectCell";
    
    DSXSYSectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[DSXSYSectCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DSXSYSectModel *md = [[DSXSYSectModel alloc] init];
    md = self.sectArray[indexPath.row];
    //    cell.model = self.dataArray[indexPath.row];
    
    
    
    if (indexPath.row < self.sectArray.count - 1) {
        
    }else{
        // 最后一行
                cell.lineView.hidden = YES;
        
    }
    cell.model = md;
//    cell.delegate = self;
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DSXSYSectModel *infoModel = self.sectArray[indexPath.row];
    [self chooseTheSectInfo:infoModel];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *secFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 40)];
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 13, 30)];
    tipsLab.numberOfLines = 0;
    tipsLab.font = [UIFont systemFontOfSize:12];
    tipsLab.text = @"没有你的宗派？可以先选择“其他”后提交，然后联系客服修改。";
    tipsLab.textAlignment = 0;
    tipsLab.textColor = [UIColor grayColor];
    [secFooter addSubview:tipsLab];
    return secFooter;
}



- (void)chooseTheSectInfo:(DSXSYSectModel *)info{
    if (self.SectBlock) {
        self.SectBlock(info);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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

@end
