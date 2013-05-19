//
//  CellView.h
//  PSCollectionViewDemo
//
//  Created by Eric on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PSCollectionViewCell.h"

@interface CellView : PSCollectionViewCell
@property (retain, nonatomic) IBOutlet UIImageView *picView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@end
