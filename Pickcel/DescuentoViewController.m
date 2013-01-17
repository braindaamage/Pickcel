//
//  DescuentoViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 02-01-13.
//  Copyright (c) 2013 Reframe. All rights reserved.
//

#import "DescuentoViewController.h"

@interface DescuentoViewController () {
    UIImage *imagen;
}

@end

@implementation DescuentoViewController
@synthesize imagenDescuento;

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
    //self.descuentoView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"micro_carbon"]];
    
    [imagenDescuento setImage:imagen];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar" style:UIBarButtonItemStylePlain target:self action:@selector(cerrarNavController)];
    
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)cerrarNavController {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cargarImagen:(UIImage *) imagenData {
    imagen = imagenData;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
