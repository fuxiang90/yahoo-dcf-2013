//
//  DetailPhotoVC.m
//  WeLikePhoto
//
//  Created by SEI on 13-5-19.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import "DetailPhotoVC.h"
#import "UIImageView+WebCache.h"

NSString *kAddFavor = @"addFavor";
NSString *kGetPhoto = @"Getphoto";

@interface DetailPhotoVC ()

@end

@implementation DetailPhotoVC
{
    NSDictionary *photoDic;
}
@synthesize favorBtn;
@synthesize photoImgView;
@synthesize tagTextView;
@synthesize titleLabel;
@synthesize photoId, flickrRequest;

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
//    self.photoId = @"8747460606";
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    progress.labelText = @"正在加载...";
    [self.view addSubview:progress];
    [progress show:YES];
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.getInfo" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.photoId, @"photo_id", nil]];
    self.flickrRequest.sessionInfo = kGetPhoto;
//    NSString *selectString = [NSString stringWithFormat:@"http://query.yahooapis.com/v1/public/yql?q=%@"]
//    NSURL *url = [NSURL URLWithString:@"http://query.yahooapis.com/v1/public/yql?q="]
    
}

- (void)viewDidUnload
{
    [self setPhotoImgView:nil];
    [self setTagTextView:nil];
    [self setTitleLabel:nil];
    [self setFavorBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    if ([inRequest.sessionInfo isEqualToString:kGetPhoto]) {
        if ([[inResponseDictionary objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            photoDic = [inResponseDictionary objectForKey:@"photo"];
            NSString *imgUrlString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_q.jpg", [photoDic objectForKey:@"farm"], [photoDic objectForKey:@"server"], [photoDic objectForKey:@"id"], [photoDic objectForKey:@"secret"]];
            NSLog(@"imgurl is %@", imgUrlString);
            self.photoImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlString]]];
            self.photoImgView.frame = CGRectMake(85, 40, 150, 150);
            //        [self.photoImgView setImageWithURL:[NSURL URLWithString:imgUrlString]];
            self.titleLabel.text = [[photoDic objectForKey:@"title"] objectForKey:@"_text"];
            NSString *tagString = [[NSString alloc] init];
            for (NSDictionary *tagDic in [[photoDic objectForKey:@"tags"] objectForKey:@"tag"]) {
                tagString = [tagString stringByAppendingFormat:@" %@", [tagDic objectForKey:@"_text"]];
            }
            self.tagTextView.text = tagString;
            if ([[photoDic objectForKey:@"isfavorite"] intValue]) {
                [self.favorBtn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
            }
            else
            {
                [self.favorBtn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
            }
        }
    }
    else if([inRequest.sessionInfo isEqualToString:kAddFavor])
    {
        
    }
    [progress removeFromSuperview];
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

- (IBAction)addRemoveFavor:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.flickrRequest.sessionInfo = kAddFavor;
    if ([[photoDic objectForKey:@"isfavorite"] intValue]) {
        //remove
        [btn setImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
        [self.flickrRequest callAPIMethodWithGET:@"flickr.favorites.remove" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.photoId, @"photo_id", nil]];
    }
    else
    {
        [btn setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
        //add
        [self.flickrRequest callAPIMethodWithGET:@"flickr.favorites.add" arguments:[NSDictionary dictionaryWithObjectsAndKeys:self.photoId, @"photo_id", nil]];
    }
}
@end
