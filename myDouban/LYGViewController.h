//
//  LYGViewController.h
//  myDouban
//
//  Created by qianfeng on 13-12-17.
//  Copyright (c) 2013年 UIday3_layer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYGViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
-(void)pushDetailViewController;
@end
