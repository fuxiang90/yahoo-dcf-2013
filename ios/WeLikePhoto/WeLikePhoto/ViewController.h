//
//  ViewController.h
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController<OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
}
- (IBAction)LogIn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *authorizeDescriptionLabel;
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;

@end
