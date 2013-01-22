//
//  ClientesCollectionViewController.h
//  Pickcel
//
//  Created by Leonardo on 09-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientesCollectionViewController : UICollectionViewController <NSXMLParserDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *vistaColeccion;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicadorCarga;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *imgNoInternet;

- (IBAction)celdaBotonPulsar:(id)sender;

@end
