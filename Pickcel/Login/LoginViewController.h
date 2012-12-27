//
//  LoginViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 19-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController
- (IBAction)loginFacebook:(id)sender;
- (IBAction)loginTwitter:(id)sender;

@end
