//
//  DSXSYMasterDetailController.m
//  善信
//
//  Created by LQ on 2017/6/2.
//  Copyright © 2017年 LM. All rights reserved.
//

#import "DSXSYMasterDetailController.h"
#import "DSXSYLabelAndTextField.h"
#import "DSXSYTitleModel.h"
#import "DSXSYInputMIModel.h"
#import "DSXSYInputInMastertroductionCell.h"
#import "DSXSYTextTypeCell.h"
#import "DSXSYSectController.h"
#import "DSXSYAddressController.h"
#import "ShareArea.h"

#import "DSXSYSectModel.h"

@interface DSXSYMasterDetailController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,TextTypeCellTextFieldDelegate,InputInMastertroductionCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *inputArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) NSString *addressStr;
@property (nonatomic, strong) DSXSYSectModel *infoModel;
@property (nonatomic, strong) DSXSYAddressController *addressVC;

@property (nonatomic, copy) NSString *str1;
/*
@property (nonatomic, copy) NSString *<#string#>;
@property (nonatomic, copy) NSString *<#string#>;
@property (nonatomic, copy) NSString *<#string#>;
@property (nonatomic, copy) NSString *<#string#>;
@property (nonatomic, copy) NSString *<#string#>;
@property (nonatomic, copy) NSString *<#string#>;
@property (nonatomic, copy) NSString *<#string#>;
 */
@end

@implementation DSXSYMasterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"编辑师父资料";
       [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
  
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


- (NSMutableArray *)inputArray{
    if (!_inputArray) {
        _inputArray = [[NSMutableArray alloc] init];
    }
    return _inputArray;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
    }
    return _textField;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 21312, 21312 - 64 - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    
}

- (void)createTableView{
    [self.view addSubview:self.tableView];
    
    UIView *tableHead = [[UIView alloc] init];
    tableHead.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = tableHead;
    
    UIImageView *headerImageView = [[UIImageView alloc] init];
    headerImageView.image = [UIImage imageNamed:@"1111"];
    [tableHead addSubview:headerImageView];
    headerImageView.frame = CGRectMake(0, 0, 21312, 21312 / 2);
    
    UILabel *noticeLab = [DSXSYLabelAndTextField createLabelWithFrame:CGRectZero TextColorState:Normoal WantChangeColor:nil ChangeTitle:nil Titile:@"表单所示带*号为必填项，所填信息仅为“师父资料”展示所用，审核成功后一个月内不可重复修改，且法号、毕业佛学院及宗派不可修改，请慎重填写。（如需完善或咨询，请在帮助与反馈中联系“一善师兄”）" FontSize:14 TextColor:[UIColor blackColor] TextAlignment:0];
    CGSize notLabSize = [noticeLab.text boundingRectWithSize:CGSizeMake(21312 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : noticeLab.font} context:nil].size;
    noticeLab.frame = CGRectMake(12, headerImageView.height, 21312 - 24, notLabSize.height);
    [tableHead addSubview:noticeLab];
    
    tableHead.frame = CGRectMake(0, 0, 21312, (noticeLab.y + noticeLab.height + 20));
    
}


- (void)loadData{
//    , @"* 个人经历", @"个人介绍"
    
   
    NSArray *array = @[@"* 法号", @"* 寺院名称", @"寺院职务", @"* 毕业佛学院", @"最高学历", @"* 寺院/精舍地址", @"* 所属宗派", @"客堂电话"];
    NSArray *placeholderArray = @[@"请输入法号", @"请输入现常住寺院/精舍名称", @"主持、首座、堂主、监院、知客等", @"请输入毕业佛学院", @"请输入最高学历", @"请输入详细地址", @"请输入客堂电话"];
    for (int i = 0; i < array.count; i ++) {
        DSXSYTitleModel *model = [[DSXSYTitleModel alloc] init];
        model.title = array[i];
        if (i < placeholderArray.count) {
           model.placeholder = placeholderArray[i];
        }
        
        [self.dataArray addObject:model];
    }
    SYLog(@"-----dataArray:%@", self.dataArray);
    
    NSArray *titleArr = @[@"* 个人经历", @"个人介绍"];
    NSArray *placeholderArr = @[@"如：2005.07XXX寺发心出家，2009.06~2011.09浙江普陀山佛学院学习", @"个人作品、参加过的大型弘法、比赛取得的荣誉、其他等"];
    for (int i  = 0; i < titleArr.count; i ++) {
        DSXSYInputMIModel *model = [[DSXSYInputMIModel alloc] init];
        model.title = titleArr[i];
        model.placeHolderStr = placeholderArr[i];
        [self.inputArray addObject:model];
    }
    SYLog(@"-----inputArray:%@", self.inputArray);
    [self createTableView];
    [self.tableView reloadData];
}


# pragma mark --------------------------------------------------------------- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Weak_Self;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier =@"DSXSYTextTypeCell";
        
        DSXSYTextTypeCell *textTypeCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (textTypeCell == nil) {
            
            textTypeCell = [[DSXSYTextTypeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        textTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DSXSYTitleModel *md = [[DSXSYTitleModel alloc] init];
        md = self.dataArray[indexPath.row];
        //    cell.model = self.dataArray[indexPath.row];
        
        textTypeCell.textFieldtype = 1;

        if (indexPath.row == 0) {
            
            textTypeCell.textLimit = 15;
            
        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            
            textTypeCell.textLimit = 10;
            
        }else if (indexPath.row == 3){
            
        }else if (indexPath.row == 4){
            
        }else if (indexPath.row == 5){
            textTypeCell.textLimit = 50;
            textTypeCell.isLineFeed = YES;
            
            textTypeCell.TextFieldBlock = ^(NSString *text) {
                weakSelf.str1 = text;
                
            };
            
            NSLog(@"%@",self.str1);
            md.selectTitle = @"选择地区";
            if (self.addressStr.length > 0) {
                md.selectDetail = self.addressStr;
                
            }
            ShareArea *manager = [ShareArea shareAre];
            if (manager.allPlace.length > 0) {
                self.addressStr = [manager.allPlace stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            }
            md.selectDetail = self.addressStr;
            textTypeCell.textFieldtype = 3;
            
        }else if (indexPath.row == 6){
            md.selectTitle = @"选择宗派";
            
            if (self.infoModel.sectarianName.length > 0) {
                md.selectDetail = self.infoModel.sectarianName;
            }
            textTypeCell.textFieldtype = 2;

        }else{
            textTypeCell.textLimit = 15;
        }
        
        
        if (indexPath.row < self.dataArray.count - 1) {
            
        }else{
            // 最后一行
            //        cell.lineView.hidden = YES;
            
        }
        textTypeCell.model = md;
        textTypeCell.delegate = self;
        
        
        return textTypeCell;

    }else{
         static NSString *CellIdentifier = @"DSXSYInputInMastertroductionCell";
        DSXSYInputInMastertroductionCell *inputCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (inputCell == nil) {
            
            inputCell = [[DSXSYInputInMastertroductionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        inputCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        DSXSYInputMIModel *md = [[DSXSYInputMIModel alloc] init];
        md = self.inputArray[indexPath.row];
        //    cell.model = self.dataArray[indexPath.row];
        
        
        
        if (indexPath.row < self.inputArray.count - 1) {
            
        }else{
            // 最后一行
            //        cell.lineView.hidden = YES;
            
        }
        inputCell.model = md;
//        inputCell.delegate = self;
        inputCell.delegate = self;
        
        return inputCell;

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 5) {
        if (self.str1.length > 0) {
            CGSize stringSize = [self.str1 boundingRectWithSize:CGSizeMake(21312 - 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil].size;
            if (stringSize.height > 44) {
                return (stringSize.height + 99);
            }
        }
        return 143;
    }
    if (indexPath.section == 1) {
        return (68 + 25 + 20);
    }
    return 89;
}

/*
 CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
 CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
 
 */

# pragma mark --------------------------------------------------------------- TextTypeCellTextFieldDelegate

- (void)isFirstResponderForTextFiled:(UITextField *)textField{
    
    self.textField = textField;
}

- (void)TextFieldIsChnagetToText:(NSString *)text{
    NSString *textStr = text;
    SYLog(@"__________________%@________________", textStr);
}

- (void)pushVCForType:(NSInteger)type{
    Weak_Self;
    if (type == 3) {
        DSXSYAddressController *addressVC = [[DSXSYAddressController alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if(type == 2) {
        DSXSYSectController *sectVC = [[DSXSYSectController alloc] init];
        sectVC.SectBlock = ^(DSXSYSectModel *info) {
            weakSelf.infoModel = info;
            SYLog(@"+++++++++%@++++++++", weakSelf.infoModel.sectarianName);
        };
        [self.navigationController pushViewController:sectVC animated:YES];
    }
}



# pragma mark --------------------------------------------------------------- InputInMastertroductionCellDelegate

- (void)isFirstResponderForTextView:(UITextView *)textView{
    self.textView = textView;
    [self.textView becomeFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        if (textView) {
            self.tableView.y = -180;
        }
        self.tableView.y = -200;
    }];
   
  
    
}


# pragma mark --------------------------------------------------------------- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];

    }
    if (self.textView.isFirstResponder) {
        [self.textView resignFirstResponder];
        
    }
    
}

//- (void)scrollViewToBottom:(BOOL)animated
//{
//    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
//    {
//        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
//        [self.tableView setContentOffset:offset animated:animated];
//    }
//}

# pragma mark --------------------------------------------------------------- 监听键盘
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    /**
      *如果键盘挡住cell里的输入框,cell会自动往上移动
      *如果没有挡住,将不会移动;
     */
   
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    
    
    if (self.textView.isFirstResponder) {
       
    }

}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
    if (self.textView.isFirstResponder) {
        self.tableView.y = 0;
    }
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
