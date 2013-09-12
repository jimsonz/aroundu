//
//  AULoginViewController.m
//  AroundU
//
//  Created by Peter Yeung on 2013-08-03.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AULoginViewController.h"
#import "AUAppDelegate.h"

@interface AULoginViewController ()

@end

@implementation AULoginViewController

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
    self.spinner.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)performLogin:(id)sender
{
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    AUAppDelegate* delegate = (AUAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate openSession];
}

-(void)loginFailed
{
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
    NSLog(@"login failed");
}

@end
