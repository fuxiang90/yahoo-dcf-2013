//
//  DetailPhotoVC.h
//  WeLikePhoto
//
//  Created by SEI on 13-5-19.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ObjectiveFlickr.h"
#import "MBProgressHUD.h"

@interface DetailPhotoVC : UIViewController<OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
    MBProgressHUD *progress;
}

@property (nonatomic, strong) NSString *photoId;
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (weak, nonatomic) IBOutlet UIButton *favorBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UITextView *tagTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (IBAction)addRemoveFavor:(id)sender;

@end
