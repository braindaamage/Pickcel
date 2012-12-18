//
//  CapturaViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "DLCImagePickerController.h"

@interface CapturaViewController : UIViewController <DLCImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imagenObtenidaVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonEnviarVista;
@property (strong, nonatomic) IBOutlet UIView *capturaView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *botonCancelarUploadVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonCamara;
@property (weak, nonatomic) IBOutlet UILabel *labelError;

- (IBAction)cerrarObtenerDescuento:(id)sender;
- (IBAction)abrirCamara:(id)sender;
- (IBAction)botonEnviar:(id)sender;
- (IBAction)botonCancelarUpload:(id)sender;


@end
