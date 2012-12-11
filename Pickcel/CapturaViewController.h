//
//  CapturaViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapturaViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagenObtenidaVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonEnviarVista;
@property (weak, nonatomic) IBOutlet UICollectionView *coleccionFiltrosVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonFiltrosVista;

- (IBAction)cerrarObtenerDescuento:(id)sender;
- (IBAction)abrirCamara:(id)sender;
- (IBAction)botonFiltros:(id)sender;
- (IBAction)activarFiltro:(id)sender;

@end
