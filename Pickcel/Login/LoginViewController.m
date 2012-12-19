//
//  LoginViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 19-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginFacebook:(id)sender {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{ACFacebookAppIdKey : @"442688539131546",
    ACFacebookPermissionsKey : @[@"email"],
    ACFacebookAudienceKey:ACFacebookAudienceFriends};
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:options
                                       completion:^(BOOL granted, NSError *error)
     {
         if (granted) {
             // At this point we can assume that we have access to the Facebook account
             NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
             
             // Optionally save the account
             [accountStore saveAccount:[accounts lastObject] withCompletionHandler:nil];
             
             [self dismissViewControllerAnimated:YES completion:nil];
         } else {
             NSString *mensaje = [[NSString alloc] initWithFormat:@"%@", [error localizedDescription]];
             
             UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                              message:mensaje
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
             
             [alerta show];
         }
     }];
}
@end
