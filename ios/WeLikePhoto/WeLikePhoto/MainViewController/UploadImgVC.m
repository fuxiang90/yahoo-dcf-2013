//
//  UploadImgVC.m
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import "UploadImgVC.h"

extern NSString *kFetchRequestTokenStep;
extern NSString *kGetUserInfoStep;
extern NSString *kSetImagePropertiesStep;
extern NSString *kUploadImageStep;

@interface UploadImgVC ()

@end

@implementation UploadImgVC
{
    UIImage *selectImage;
}
@synthesize uploadImgView;
@synthesize tagTextField;
@synthesize descripTextView;
@synthesize titleTextField;
@synthesize backScrollView;
@synthesize imgBtn, flickrRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *selectImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImg:)];
    [self.uploadImgView addGestureRecognizer:selectImgTap];
    [self.backScrollView setContentSize:CGSizeMake(320, 500)];
}

- (void)viewDidUnload
{
    [self setImgBtn:nil];
    [self setUploadImgView:nil];
    [self setTagTextField:nil];
    [self setTitleTextField:nil];
    [self setDescripTextView:nil];
    [self setBackScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelUpload:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(){
    }];
}

- (IBAction)pickImg:(id)sender
{
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    //            [repleyCon showInView:[UIApplication sharedApplication].keyWindow];
    [actSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)finishUpload:(id)sender
{
    if (selectImage == nil) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }
    else
        [self performSelector:@selector(_startUpload:) withObject:selectImage afterDelay:0.0];
}

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is %d", buttonIndex);
    switch (buttonIndex)
    {
        case 0:
        {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
                UIImagePickerController *pickerCon = [[UIImagePickerController alloc] init];
                pickerCon.delegate = self;
                pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerCon.allowsEditing = YES;
                [self presentModalViewController:pickerCon animated:YES];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
        case 1:
        {
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                UIImagePickerController *pickerCon = [[UIImagePickerController alloc] init];
                pickerCon.allowsEditing = YES;
                pickerCon.delegate = self;
                pickerCon.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentModalViewController:pickerCon animated:YES];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark UIImagePickerController delegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)_startUpload:(UIImage *)image
{
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
	NSLog(@"Uploading");
	
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"Snap and Run Demo" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"1", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //  NSDictionary *editingInfo = info;
    self.uploadImgView.image = selectImage;
    [self dismissModalViewControllerAnimated:YES];
        
    NSLog(@"Preparing...");
        
        // we schedule this call in run loop because we want to dismiss the modal view first
//    [self performSelector:@selector(_startUpload:) withObject:image afterDelay:0.0];
}

#pragma mark OFFlickrAPIRequest delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    NSLog(@"No need for token");
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
		NSLog(@"Setting properties...");
        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
        flickrRequest.sessionInfo = kSetImagePropertiesStep;
        NSMutableDictionary *arguDic = [[NSMutableDictionary alloc] init];
        if ([self.titleTextField.text length])
            [arguDic setObject:self.titleTextField.text forKey:@"title"];
        if ([self.tagTextField.text length])
            [arguDic setObject:self.tagTextField.text forKey:@"tags"];
        if([self.descripTextView.text length])
            [arguDic setObject:self.descripTextView.text forKey:@"description"];
        [arguDic setObject:photoID forKey:@"photo_id"];
//        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"Snap and Run", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:arguDic];
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		NSLog(@"Done");
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
    NSLog(@"Failed");
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
    NSLog(@"%@", [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024]);
}

#pragma mark Accesors

- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[AppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}
@end
