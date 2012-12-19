//
//  InfoViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 19-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutFacebook:(id)sender {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
    
    ACAccount *account = [accounts lastObject];
    
    [accountStore removeAccount:account withCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Deslogeo OK");
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
}
@end
