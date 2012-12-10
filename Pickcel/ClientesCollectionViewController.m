//
//  ClientesCollectionViewController.m
//  Pickcel
//
//  Created by Leonardo on 09-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "ClientesCollectionViewController.h"
#import "ClientesCollectionViewCell.h"
#import "VistaClienteViewController.h"

@interface ClientesCollectionViewController ()

@end

@implementation ClientesCollectionViewController

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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Volver" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClientesCollectionViewCell *celda = [collectionView dequeueReusableCellWithReuseIdentifier:@"celdaID" forIndexPath:indexPath];
    
    [celda.botonVista setBackgroundImage: [UIImage imageNamed:@"icono.png"] forState:UIControlStateNormal];
    [celda.botonVista setTag:indexPath.item];
    
    return celda;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 37;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)celdaBotonPulsar:(id)sender {
    VistaClienteViewController *vistaCliente = [self.storyboard instantiateViewControllerWithIdentifier:@"VistaClienteVCID"];
    UIButton *boton = (UIButton *) sender;
    
    NSString *descripcion = [[NSString alloc] initWithFormat:@"Item: %i", boton.tag];
    
    vistaCliente.capturarDato = descripcion;
    
    [self.navigationController pushViewController:vistaCliente animated:YES];
}
@end
