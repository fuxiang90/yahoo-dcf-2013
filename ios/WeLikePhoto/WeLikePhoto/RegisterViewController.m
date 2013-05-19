//
//  RegisterViewController.m
//  TaxiHelper
//
//  Created by SEI on 13-3-26.
//  Copyright (c) 2013年 SEI. All rights reserved.
//

#import "RegisterViewController.h"
#import "User.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
{
    User *user;
}
@synthesize userName;
@synthesize password;
@synthesize passwordAgain;
@synthesize phoneNumber;
@synthesize trueName;
@synthesize contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//取消按钮
- (void)clickedLeftItem:(id)sender
{
    [self.delegate registerCancel:self];
    
}

//注册按钮
- (void)clickedRegister:(id)sender
{
    if ([password.text isEqualToString:[NSString stringWithFormat:@"%@",passwordAgain.text]]) {
        if (![user registerUser:userName.text password:password.text name:trueName.text tel:phoneNumber.text]) {
            NSLog(@"");
        }
        [self.delegate registerSuccess:self];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.contentView setContentSize:CGSizeMake(320, 520)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedLeftItem:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(clickedRegister:)];
    
    
    user = [User shareInstance];
}

- (void)viewDidUnload
{
    [self setContentView:nil];
    [self setUserName:nil];
    [self setPassword:nil];
    [self setPasswordAgain:nil];
    [self setPhoneNumber:nil];
    [self setTrueName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
