//
//  SimilarVC.h
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBTableView.h"
#import "MBProgressHUD.h"

@interface SimilarVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet BBTableView *mTableView;
    NSMutableArray *mDataSource;
    MBProgressHUD *progress;
}
- (IBAction)backToMain:(id)sender;

@end
