//
//  UploadImgVC.h
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"
#import "AppDelegate.h"

@interface UploadImgVC : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
}
@property (weak, nonatomic) IBOutlet UIButton *imgBtn;
@property (nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImgView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UITextView *descripTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

- (IBAction)cancelUpload:(id)sender;
- (IBAction)pickImg:(id)sender;
- (IBAction)finishUpload:(id)sender;
@end
