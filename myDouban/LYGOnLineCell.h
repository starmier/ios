//
//  LYGOnLineCell.h
//  myDouban
//
//  Created by qianfeng on 13-12-17.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYGOnlineCellModel.h"
#import "LYGViewController.h"

@interface LYGOnLineCell : UITableViewCell

@property (nonatomic,retain) LYGViewController *vc;
@property (nonatomic,retain)UIButton *btn;
-(void)refreshCellWithModel:(LYGOnlineCellModel *)model;

@end
