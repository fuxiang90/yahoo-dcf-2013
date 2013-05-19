//
//  MainViewController.m
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import "MainViewController.h"
#import "RecommendVC.h"
#import "SettingsVC.h"
#import "UploadImgVC.h"
#import "SimilarVC.h"
#import "UIImageView+WebCache.h"

@interface MainViewController ()

@end

@implementation MainViewController
{
    RecommendVC *recommendCon;
}
@synthesize flickrRequest;
@synthesize iconImg;
@synthesize nameLabel;

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
    self.title = @"主页";
    [self.flickrRequest callAPIMethodWithGET:@"flickr.people.getInfo" arguments:[NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"user_id", nil]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidUnload
{
    [self setIconImg:nil];
    [self setNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)recommendPhoto:(id)sender {
    if (recommendCon == nil) {
        recommendCon = [[RecommendVC alloc] initWithNibName:@"RecommendVC" bundle:nil];
    }
//    [self.navigationController pushViewController:recommendCon animated:YES];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:recommendCon];
    [self presentModalViewController:navCon animated:YES];
}

- (IBAction)similarPeople:(id)sender {
    SimilarVC *similarCon = [[SimilarVC alloc] initWithNibName:@"SimilarVC" bundle:nil];
    [self presentModalViewController:similarCon animated:YES];
}

- (IBAction)lookAround:(id)sender {
}

- (IBAction)UploadingImg:(id)sender {
    UploadImgVC *uploadImgCon = [[UploadImgVC alloc] initWithNibName:@"UploadImgVC" bundle:nil];
    [self presentModalViewController:uploadImgCon animated:YES];
}


- (IBAction)logOut:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}



- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    if ([[inResponseDictionary objectForKey:@"stat"] isEqualToString:@"ok"]) {
        NSDictionary *personDic = [inResponseDictionary objectForKey:@"person"];
        NSString *urlString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/buddyicons/%@.jpg", [personDic objectForKey:@"iconfarm"], [personDic objectForKey:@"iconserver"], [personDic objectForKey:@"id"]];
        NSLog(@"urlString is %@", urlString);
        [self.iconImg setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"Luma@2x.png"]];
        self.nameLabel.text = [personDic valueForKeyPath:@"username._text"];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
    [[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
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
