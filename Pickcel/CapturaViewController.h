//
//  CapturaViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCImagePickerController.h"

@interface CapturaViewController : UIViewController <DLCImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagenObtenidaVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonEnviarVista;
@property (strong, nonatomic) IBOutlet UIView *capturaView;

- (IBAction)cerrarObtenerDescuento:(id)sender;
- (IBAction)abrirCamara:(id)sender;

@end
