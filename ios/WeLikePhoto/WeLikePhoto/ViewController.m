//
//  ViewController.m
//  WeLikePhoto
//
//  Created by SEI on 13-5-18.
//  Copyright (c) 2013年 DCF. All rights reserved.
//

#import "ViewController.h"
#import "RecommendVC.h"
#import "SettingsVC.h"
#import "MainViewController.h"

NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";

@interface ViewController ()

@end

@implementation ViewController
{
    UITabBarController *tabVC;
}
@synthesize authorizeDescriptionLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Snap and Run";
	
//	if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
//		authorizeButton.enabled = NO;
//	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInterface:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}

- (void)updateUserInterface:(NSNotification *)notification
{
    
	if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
		
		if ([[AppDelegate sharedDelegate].flickrUserName length]) {
			authorizeDescriptionLabel.text = [NSString stringWithFormat:@"You are %@", [AppDelegate sharedDelegate].flickrUserName];
		}
		else {
			authorizeDescriptionLabel.text = @"You've logged in";
		}
//        RecommendVC *recommendCon = [[RecommendVC alloc] initWithNibName:@"RecommendVC" bundle:nil];
//        SettingsVC *settingCon = [[SettingsVC alloc] initWithNibName:@"SettingsVC" bundle:nil];
//        tabVC = [[UITabBarController alloc] init];
//        tabVC.viewControllers = [NSArray arrayWithObjects:recommendCon, settingCon, nil];
//        tabVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:tabVC animated:YES completion:^(void){
//        }];
        MainViewController *mainCon = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
//        UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:mainCon];
        mainCon.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:mainCon animated:YES completion:^(void){
        }];
	}
}



- (void)viewDidUnload
{
    [self setAuthorizeDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)LogIn:(id)sender {
    if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
        [[AppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    }
	authorizeDescriptionLabel.text = @"Authenticating...";
    
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    NSLog(@"flickrRequest is %@", self.flickrRequest);
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
}

#pragma mark OFFlickrAPIRequest delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    [AppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [AppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [[AppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
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
