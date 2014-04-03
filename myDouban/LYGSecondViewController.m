//
//  LYGSecondViewController.m
//  myDouban
//
//  Created by qianfeng on 13-12-19.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import "LYGSecondViewController.h"
#import "FMDatabase.h"
#import "LYGOnlineCellModel.h"
#import "LYGOnLineCell.h"


@interface LYGSecondViewController ()

@end

@implementation LYGSecondViewController
{
    UITableView *myTableView;
    NSMutableArray *myMutArr;
    NSMutableData *myMutData;
    NSMutableData *myMutPhtotData;
    UIButton *myGetDataBtn;
    
    FMDatabase *myDB;
    
    //定义第三方headview footview
    MJRefreshHeaderView *myMJHeadView;
    MJRefreshFooterView *myMJFootView;
    
    //设置变量控制每次加载的数量 page＊pagenum
    int loadPage;
    int refreshPage;
    int pageNum;
    //控制是上拉刷新，还是下拉加载
    BOOL isFresh;
    //控制加载过程中小菊花的显示
    BOOL isLoading;
    
    BOOL isHaveData;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"数据库读写";
    self.tabBarItem.title = @"dataBase";

    /**********************创建database**********************/
    NSLog(@"%@",NSHomeDirectory());
    
    myDB = [FMDatabase databaseWithPath:[self getFilePath:@"myDoubanOnlinee.rdb"]];
    if ([myDB open]) {
        NSLog(@"打开成功！");
        //建表
        NSString *createSql = @"create table if not exists Ablumb(title,peopleNum,picNum,picUrl,ablumbID primary key)";
       
        if([myDB executeUpdate:createSql])
        {
            NSLog(@"创建表成功!");
        }
        else
        {
            NSLog(@"创建表失败!");
        }
    }
    else
    {
        
    }
    //获取数据并插入数据到数据库中
    //利用代理 NSURLConnectionDataDelegate 代理实现数据的获取和存储
    
    
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
    myTableView.tableHeaderView = myGetDataBtn;
    
    //上拉下拉初始化
    loadPage = 0;
    refreshPage = 0;
    pageNum = 5;
    isFresh = NO;
    isLoading = NO;
    isHaveData = NO;
    
    
    myMJHeadView = [MJRefreshHeaderView header];
    myMJHeadView.delegate = self;
    myMJHeadView.scrollView = myTableView;
    
    myMJFootView = [MJRefreshFooterView footer];
    myMJFootView.delegate = self;
    myMJFootView.scrollView = myTableView;
    NSLog(@"/n%@/n",NSHomeDirectory());
    
    //直接从数据库读取数据
//    [self getDataFromDataBaseBeginWithNum:0 limitWithNum:5];
    [self getDataWithGetMethodWithNum:0 limitWithNum:5];
}
#pragma mark --MJ代理函数,刷新／加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == myMJFootView) {
        [self getMoreData];
    }
    else
    {
        [self refreshMoreData];
    }
}
//下拉时，加载更多数据
-(void)getMoreData
{
    NSLog(@"***********isloading******************%d",isLoading);
    if (isLoading) {
    
    }
    else
    {
        [self getDataFromDataBaseBeginWithNum:0 limitWithNum:refreshPage * pageNum];
//        refreshPage++;
    }
}
//上拉时，刷新到更多数据,建立urlconnection链接
-(void)refreshMoreData
{
    if (!isLoading) {
//        page = 0;
        isFresh = YES;
        [self getDataWithGetMethodWithNum:loadPage * pageNum limitWithNum:pageNum];
//        loadPage ++;
    }
}

#pragma --
#pragma 从数据库读取数据
-(void)getDataFromDataBaseBeginWithNum:(int)num limitWithNum:(int)limitNum
{
    if([myDB open])
    {
        NSLog(@"下拉加载数据");
        [myMutArr removeAllObjects];
//        NSString *selectStr = @"select title,peopleNum,picNum,picUrl from Ablumb limit 0,5";
        NSString *selectStr = [NSString stringWithFormat:@"select title,peopleNum,picNum,picUrl from Ablumb limit %d,%d",num,limitNum];
        FMResultSet *results = [myDB executeQuery:selectStr];
        while ([results next]) {
            //打包为数据模型，以便显示在界面tabelview中
            LYGOnlineCellModel *model = [[LYGOnlineCellModel alloc]init];
            model.cellTitleString = [results stringForColumn:@"title"];
            model.cellPeopleNumString = [results stringForColumn:@"peopleNum"];
            model.cellPicNumString = [results stringForColumn:@"picNum"];
            model.cellPicImageviewString = [results stringForColumn:@"picUrl"];
            [myMutArr addObject:model];
            [myTableView reloadData];
//            [myMJHeadView endRefreshing];
            
        }
        [myMJFootView endRefreshing];
        refreshPage ++;
        isLoading = NO;
    }
    else
    {
        NSLog(@"打开失败");
    }
}
#pragma --
#pragma 通过get方法向服务器请求数据
-(void)getDataWithGetMethodWithNum:(int)num limitWithNum:(int)limitNum
{
    NSLog(@"上拉刷新数据");
    NSString *baseUrl = @"https://api.douban.com/v2/onlines";
    NSString *urlStr = [NSString stringWithFormat:@"%@?start=%d&count=%d",baseUrl,num,limitNum];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//这里防止url中有汉字，古没有直接使用url，而是编码后的url
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    //控制小菊花显示，表示数据正在加载中
    isLoading = YES;
//    loadPage ++;
    [myMJHeadView endRefreshing];

    [myMJFootView endRefreshing];
}
#pragma --
#pragma 获取文件路径
-(NSString *)getFilePath:(NSString *)fileName
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [documentPath stringByAppendingPathComponent:fileName];
}
#pragma --
#pragma 自定义 解析Json数据
-(void)getJsonDataBtnClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://api.douban.com/v2/onlines"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    //先加载后滚动就可以将新加载的数据显示
//    [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:myMutArr.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma --
#pragma json 解析  NSUrlConnection代理方法
//受到响应
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
    //解析数据
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:myMutData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"**********dict = %@",dict);
    NSMutableArray *mutArr = dict[@"onlines"];
    //插入数据到数据库
    NSDictionary *modelDict;
    for (int i = 0; i < mutArr.count; i++)
    {
        modelDict = [NSDictionary dictionary];
        modelDict = mutArr[i];

        NSString *titleStr = modelDict[@"title"];
        NSString *peopleNumStr = modelDict[@"participant_count"];
        NSString *picNumStr = modelDict[@"photo_count"];
        NSLog(@"picNumStr = %@",picNumStr);
        NSString *picUrlStr = modelDict[@"image"];
        NSString *alumbIDStr = modelDict[@"id"];
        NSLog(@"alumbIDStr = %@",alumbIDStr);
        
        //插入数据库表中
        NSString *insertStr = [NSString stringWithFormat:@"insert into Ablumb (title,peopleNum,picNum,picUrl,ablumbID) values ('%@','%@','%@','%@','%@')",titleStr,peopleNumStr,picNumStr,picUrlStr,alumbIDStr];
        NSLog(@"insertStr = %@",insertStr);
        [myDB executeUpdate:insertStr];
        
        //打包为数据模型，以便显示在界面tabelview中
        LYGOnlineCellModel *model = [[LYGOnlineCellModel alloc]init];
        model.cellTitleString = [modelDict objectForKey:@"title"];
        model.cellPeopleNumString = [NSString stringWithFormat:@"%@",[modelDict objectForKey:@"participant_count"]];
        model.cellPicNumString = [NSString stringWithFormat:@"%@",[modelDict objectForKey:@"photo_count"]];
        model.cellPicImageviewString = [modelDict objectForKey:@"image"];
        [myMutArr addObject:model];
        
        [myTableView reloadData];
        //但是这里需要注意，滚动的时候，需要有单独的变量来存储当前新加载的数量
//        [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:myMutArr.count - mutArr.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        isLoading = NO;
        isFresh = NO;
        loadPage++;
    }
    [myMJHeadView endRefreshing];
    [myMJFootView endRefreshing];
}
#pragma --
#pragma tableview代理
//返回组section数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
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
    
    //利用数据模型刷新tableview
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    //利用数据模型刷新tableview
    LYGOnlineCellModel *model = myMutArr[indexPath.row];
//    [cell.btn addTarget:self action:@selector(pushDetailViewControllerWithID:) forControlEvents:UIControlEventTouchUpInside];
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
