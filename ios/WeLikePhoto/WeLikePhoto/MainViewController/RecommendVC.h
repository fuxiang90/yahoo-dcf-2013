//
//  RecommendVC.h
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "PullPsCollectionView.h"

@interface RecommendVC : UIViewController<PSCollectionViewDelegate,PSCollectionViewDataSource,UIScrollViewDelegate,PullPsCollectionViewDelegate>

@property(nonatomic,retain) PullPsCollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *items;
-(void)loadDataSource;

@end
