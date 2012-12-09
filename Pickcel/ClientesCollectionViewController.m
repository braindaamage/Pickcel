//
//  ClientesCollectionViewController.m
//  Pickcel
//
//  Created by Leonardo on 09-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "ClientesCollectionViewController.h"
#import "ClientesCollectionViewCell.h"

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
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClientesCollectionViewCell *celda = [collectionView dequeueReusableCellWithReuseIdentifier:@"celdaID" forIndexPath:indexPath];
    
    [celda.botonVista setBackgroundImage: [UIImage imageNamed:@"icono.png"] forState:UIControlStateNormal];
    
    return celda;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
