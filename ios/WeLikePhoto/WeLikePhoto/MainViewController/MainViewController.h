//
//  MainViewController.h
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

@interface MainViewController : UIViewController<OFFlickrAPIRequestDelegate>
{
	OFFlickrAPIRequest *flickrRequest;
}

@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

- (IBAction)recommendPhoto:(id)sender;
- (IBAction)similarPeople:(id)sender;
- (IBAction)lookAround:(id)sender;
- (IBAction)UploadingImg:(id)sender;

- (IBAction)logOut:(id)sender;

@end
