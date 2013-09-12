//
//  AULoginViewController.h
//  AroundU
//
//  Created by Peter Yeung on 2013-08-03.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AULoginViewController : UIViewController

@property (nonatomic,weak)IBOutlet UIActivityIndicatorView* spinner;

-(IBAction)performLogin:(id)sender;
-(void)loginFailed;

@end
