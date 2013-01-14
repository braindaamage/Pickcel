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
#import "AppDelegate.h"

@interface CapturaViewController : UIViewController <DLCImagePickerDelegate>
@property (weak, nonatomic) NSMutableDictionary *cliente;

@property (weak, nonatomic) IBOutlet UIImageView *imagenObtenidaVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonEnviarVista;
@property (strong, nonatomic) IBOutlet UIView *capturaView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *botonCancelarUploadVista;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonCamara;
@property (weak, nonatomic) IBOutlet UILabel *labelError;
@property (weak, nonatomic) IBOutlet UIView *redesView;
@property (weak, nonatomic) IBOutlet UISwitch *botonFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *botonTwitter;
@property (strong, nonatomic) NSMutableDictionary *postParams;

- (IBAction)cerrarObtenerDescuento:(id)sender;
- (IBAction)abrirCamara:(id)sender;
- (IBAction)botonEnviar:(id)sender;
- (IBAction)botonCancelarUpload:(id)sender;
- (IBAction)botonRedes:(id)sender;
- (IBAction)btnFacebook:(id)sender;
- (IBAction)btnTwitter:(id)sender;




@end
