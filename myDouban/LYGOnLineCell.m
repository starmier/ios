//
//  LYGOnLineCell.m
//  myDouban
//
//  Created by qianfeng on 13-12-17.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import "LYGOnLineCell.h"
#import "UIImageView+WebCache.h"
#import "LYGDetailViewController.h"



@implementation LYGOnLineCell
{
    UIButton *myTitleBtn;
    UILabel *myPeopleNumLabel;
    UILabel *myPeopleLabel;
    UILabel *mydotLabel;
    UILabel *myPicNumLabel;
    UILabel *myPicLabel;
    UIImageView *myPicImageView;
//    UIView *myPicView;
    NSMutableData *myMutPhtotData;
}
@synthesize btn = myTitleBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        myMutPhtotData = [NSMutableData data];
        //初始化自定义cell元素
        myTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        myTitleBtn.frame = CGRectMake(20, 20, 100, 25);
        [myTitleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [myTitleBtn setBackgroundColor:[UIColor clearColor]];
        [myTitleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [myTitleBtn addTarget:self action:@selector(onTitleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [myTitleBtn setBackgroundColor:[UIColor blueColor]];
//        myTitleBtn font = [UIFont systemFontOfSize:18];
        myTitleBtn.alpha = 0.8;
        [self.contentView addSubview:myTitleBtn];
        
        myPeopleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 55, 30, 20)];
        myPeopleNumLabel.font = [UIFont systemFontOfSize:10];
        myPeopleNumLabel.textColor = [UIColor brownColor];
        myPeopleNumLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:myPeopleNumLabel];
        
        myPeopleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 35, 80, 20)];
        myPeopleLabel.text = @"人参加";
        myPeopleLabel.font = [UIFont systemFontOfSize:10];
        myPeopleLabel.textColor = [UIColor brownColor];
        myPeopleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:myPeopleLabel];
        
        mydotLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 40, 2, 2)];
//        char a = '.';
//        mydotLabel.text = [NSString stringWithCString:a encoding:NSUTF8StringEncoding];
        mydotLabel.font = [UIFont systemFontOfSize:10];
        mydotLabel.textColor = [UIColor brownColor];
        mydotLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:mydotLabel];
        
        myPicNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 35, 30, 20)];
        myPicNumLabel.font = [UIFont systemFontOfSize:10];
        myPicNumLabel.textColor = [UIColor brownColor];
        myPicNumLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:myPicNumLabel];
        
        myPicLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 35, 80, 20)];
        myPicLabel.text = @"张照片";
        myPicLabel.font = [UIFont systemFontOfSize:10];
        myPicLabel.textColor = [UIColor brownColor];
        myPicLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:myPicLabel];
        
        myPicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 55, 220, 120)];
        [self.contentView addSubview:myPicImageView];
        
//        myPicView = [[UIView alloc]initWithFrame:CGRectMake(40, 75, 280, 150)];
//        [self.contentView addSubview:myPicView];
    }
    return self;
}
-(void)onTitleBtnClicked:(id)sender
{
    NSLog(@"--------------");
    LYGDetailViewController *vco = [[LYGDetailViewController alloc]init];
    [self.vc presentViewController:vco animated:YES completion:^{
        
    }];
}

#pragma --
#pragma 标题／ 人数／图片数 label随人数字符串而变
-(void)creatLabelFrameWithModel:(LYGOnlineCellModel *)model
{
    
}

-(void)refreshCellWithModel:(LYGOnlineCellModel *)model
{
    NSString *myTitle = model.cellTitleString;
    CGSize titleSize = [myTitle sizeWithFont:[UIFont systemFontOfSize:8] constrainedToSize:CGSizeMake(300, 2000)];
    myTitleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    myTitleBtn.frame = CGRectMake(20, 20, titleSize.width + 150, titleSize.height);
    [myTitleBtn setTitle:model.cellTitleString forState:UIControlStateNormal];
    NSString *peoNum = model.cellPeopleNumString;
    CGSize peoSize = [peoNum sizeWithFont:[UIFont systemFontOfSize:8] constrainedToSize:CGSizeMake(100, 2000)];
    myPeopleNumLabel.frame = CGRectMake(20, 35, peoSize.width + 20, 15);
    myPeopleNumLabel.text = model.cellPeopleNumString;
    
    NSString *picNum = model.cellPicNumString;
    CGSize picSize = [picNum sizeWithFont:[UIFont systemFontOfSize:8] constrainedToSize:CGSizeMake(100, 2000)];
    myPicNumLabel.frame = CGRectMake(20 + peoSize.width + 100, 35, picSize.width + 20, 15);
    myPicNumLabel.text = model.cellPicNumString;
//    myPicImageView.image = [UIImage imageNamed:model.cellPicImageviewString];
    //获取图片
    //        NSURL *phtotUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/online/:%@/photos",idString]];
    //        NSURL *phtotUrl = [NSURL URLWithString:@"https://api.douban.com/v2/album/:11624944/photos"];
//    NSURL *phtotUrl = [NSURL URLWithString:@" https://api.douban.com/v2/photo/:11624944"];
//    NSURL *phtotUrl = [NSURL URLWithString:model.cellPicImageviewString];
//    NSURLRequest *phtotUrlRequest = [NSURLRequest requestWithURL:phtotUrl];
//    NSURLConnection *phtotConn = [NSURLConnection connectionWithRequest:phtotUrlRequest delegate:self];
//    
//    NSDictionary *phtotDict = [NSJSONSerialization JSONObjectWithData:myMutPhtotData options:NSJSONReadingMutableContainers error:nil];
    [myPicImageView setImageWithURL:[NSURL URLWithString:model.cellPicImageviewString]];
    NSLog(@"==========phtotDict = %@=======",[NSURL URLWithString:model.cellPicImageviewString]);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
