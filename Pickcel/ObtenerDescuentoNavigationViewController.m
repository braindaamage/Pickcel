//
//  ObtenerDescuentoNavigationViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "ObtenerDescuentoNavigationViewController.h"

@interface ObtenerDescuentoNavigationViewController ()

@end

@implementation ObtenerDescuentoNavigationViewController
@synthesize cliente;

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
    self.navigationBar.topItem.title = [cliente valueForKey:@"titulo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
