//
//  LYGViewController.m
//  myDouban
//
//  Created by qianfeng on 13-12-17.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import "LYGViewController.h"
#import "LYGOnLineCell.h"
#import "LYGOnlineCellModel.h"
#import "UIImageView+WebCache.h"
#import "LYGDetailViewController.h"

@interface LYGViewController ()

@end

@implementation LYGViewController
{
    UITableView *myTableView;
    NSMutableArray *myMutArr;
    NSMutableData *myMutData;
    NSMutableData *myMutPhtotData;
    UIButton *myGetDataBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"直接Json解析显示";
    self.tabBarItem.title = @"json";
    /**********************创建tableview**********************/
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 300, 420) style:UITableViewStylePlain];
    myTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    /**********************获取数据****************************/
    myMutArr = [NSMutableArray array];
    myMutData = [NSMutableData data];
    myMutPhtotData = [NSMutableData data];
    
    myGetDataBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myGetDataBtn.frame = CGRectMake(0, 130, 60, 30);
    [myGetDataBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [myGetDataBtn addTarget:self action:@selector(getJsonDataBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:myGetDataBtn];
    myTableView.tableHeaderView = myGetDataBtn;

}
#pragma --
#pragma 自定义 解析Json数据
-(void)getJsonDataBtnClicked:(id)sender
{
    NSString *baseUrl = @"https://api.douban.com/v2/onlines";
    NSString *searchUrl = @"fields = title,participant_count,photo_count,desc";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",baseUrl]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    if(myMutArr.count != 0)
    {
        [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:myMutArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
#pragma --
#pragma json 解析  NSUrlConnection代理方法
//受到响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //清空缓存
    myMutData.length = 0;
}
//收到数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [myMutData appendData:data];
}
//接受数据结束
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //json 解析
//    NSMutableDictionary *jsonMtuDic = [NSMutableDictionary dictionary];
    //json解析(iOS自带解析器）
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:myMutData options:NSJSONReadingMutableContainers error:nil];
    /*
     NSJSONReadingMutableContainers 返回可写的容器
     NSJSONReadingMutableLeaves 返回只读的
     NSJSONReadingAllowFragments 允许其他类型
     */
    NSLog(@"dict = %@",dict);
    NSMutableArray *mutArr = [dict objectForKey:@"onlines"];
    LYGOnlineCellModel *model;
    NSDictionary *modelDict;
    for (int i = 0; i < mutArr.count; i++) {
        model = [[LYGOnlineCellModel alloc]init];
        modelDict = [NSDictionary dictionary];
        modelDict = mutArr[i];
//        NSLog(@"=============%d=================",i);
        model.cellTitleString = [modelDict objectForKey:@"title"];
        model.cellPeopleNumString = [NSString stringWithFormat:@"%@",[modelDict objectForKey:@"participant_count"]];
        model.cellPicNumString = [NSString stringWithFormat:@"%@",[modelDict objectForKey:@"photo_count"]];
        model.cellPicImageviewString = [modelDict objectForKey:@"image"];
//        NSString *idString = [modelDict objectForKey:@"id"];      
//        NSLog(@"============idString = %@============",idString);
//        model.cellPicImageviewString = [NSString stringWithFormat:@"https://api.douban.com/v2/online/:%@/photos",idString];
//        //获取图片
////        NSURL *phtotUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/online/:%@/photos",idString]];
////        NSURL *phtotUrl = [NSURL URLWithString:@"https://api.douban.com/v2/album/:11624944/photos"];
//        NSURL *phtotUrl = [NSURL URLWithString:@" https://api.douban.com/v2/photo/:11624944"];
//        NSURLRequest *phtotUrlRequest = [NSURLRequest requestWithURL:phtotUrl];
//        NSURLConnection *phtotConn = [NSURLConnection connectionWithRequest:phtotUrlRequest delegate:self];
//        
//        NSDictionary *phtotDict = [NSJSONSerialization JSONObjectWithData:myMutPhtotData options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"==========phtotDict = %@=======",phtotDict);

        
        [myMutArr addObject:model];
        [myTableView reloadData];
    }
    NSLog(@"--------------myMutArr.count = %d----------",myMutArr.count);
}


#pragma --
#pragma tableview代理
////返回组section数量
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//返回行row数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"*********myMutArr.count = %d*************",myMutArr.count);
    return myMutArr.count;
}
//返回自定义tableviewcell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusedID = @"reusedCell";
    
    LYGOnLineCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reusedID];
    
    if (cell == nil) {
        cell = [[LYGOnLineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID
                ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.vc = self;
    //利用数据模型刷新tableview
    LYGOnlineCellModel *model = myMutArr[indexPath.row];
    [cell.btn addTarget:self action:@selector(pushDetailViewControllerWithID:) forControlEvents:UIControlEventTouchUpInside];
    /*****/
    cell.btn.tag = indexPath.row;
    /*****/
    
    [cell refreshCellWithModel:model];
    
    return cell;
}
//返回每行row的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}
-(void)pushDetailViewControllerWithID:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    LYGDetailViewController *dvc = [[LYGDetailViewController alloc]init];
    
//    dvc.url = myMutArr[btn.tag]
    
//    [self presentViewController:dvc animated:YES completion:^{
    
//    }];
    [self.navigationController pushViewController:dvc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
