//
//  CapturaViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "CapturaViewController.h"
#import "ASIFormDataRequest.h"

@interface CapturaViewController () {
    NSData *imagenCapturada;
    ASIFormDataRequest *request;
}
@end

@implementation CapturaViewController
@synthesize imagenObtenidaVista, botonEnviarVista, capturaView, toolBar, progressBar, botonCancelarUploadVista;

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
    botonEnviarVista.enabled = NO;
    self.capturaView.backgroundColor = [UIColor colorWithPatternImage:
                                 [UIImage imageNamed:@"micro_carbon"]];
    [self.toolBar setBackgroundImage:[UIImage imageNamed:@"tabbar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.progressBar setHidden:YES];
    [self.botonCancelarUploadVista setHidden:YES];
    [self.labelError setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cerrarObtenerDescuento:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)abrirCamara:(id)sender {
    [self iniciarCamara];
}

- (IBAction)botonEnviar:(id)sender {
    //ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.reframe.cl/pickcel/sube.php"]];
    //[request setPostValue:@"Copsey" forKey:@"last_name"];
    //[request setFile:@"/Users/ben/Desktop/ben.jpg" forKey:@"photo"];
    
    [self uploadFile];
}

-(void)uploadFile{
    NSURL *url = [NSURL URLWithString: @"http://www.reframe.cl/pickcel/sube.php"];
    
    request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    
    //[request setUsername:@"login"];
    //[request setPassword:@"password"];
    
    [request setPostValue:@"imagen" forKey:@"nombre_imagen"];
    
    // Upload an image
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageName:fileName])
    //NSData *imageData = UIImageJPEGRepresentation(imagenCapturada, 9);
    [request setData:imagenCapturada withFileName:@"file" andContentType:@"image/jpeg" forKey:@"file"];
    
    [request setDelegate:self];
    [request setUploadProgressDelegate:progressBar];
    [request setTimeOutSeconds:60];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    [request setDidStartSelector:@selector(uploadRequestStart:)];
    
    [request startAsynchronous];
}

- (IBAction)botonCancelarUpload:(id)sender {
    [request cancel];
    [self.progressBar setProgress:0.0];
    [self.botonCancelarUploadVista setHidden:YES];
    [self.progressBar setHidden:YES];
}

// Funciones ASIHTTPRequest

- (void) uploadRequestStart:(ASIHTTPRequest *) requestInstance {
    [self.progressBar setHidden:NO];
    [self.botonCancelarUploadVista setHidden:NO];
    [self.botonEnviarVista setEnabled:NO];
    [self.botonCamara setEnabled:NO];
    [self.labelError setHidden:YES];
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)requestInstance{
    NSString *responseString = [requestInstance responseString];
    NSLog(@"Upload response %@", responseString);
    [self.progressBar setHidden:YES];
    [self.botonCancelarUploadVista setHidden:YES];
    [self.botonEnviarVista setEnabled:YES];
    [self.botonCamara setEnabled:YES];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)requestInstance{
    NSString *error;
    switch ([[requestInstance error] code]) {
        case 1:
            error = [[NSString alloc] initWithFormat:@"Error de conexión."];
            break;
        case 2:
            self.labelError.text = @"Tiempo de espera agotado.";
            break;
        case 4:
            // Cancelado
            self.labelError.text = @"";
            break;
        default:
            error = [[NSString alloc] initWithFormat:@"Error desconocido (%i)", [[requestInstance error] code]];
            break;
    }
    
    self.labelError.text = error;
    [self.labelError setHidden:NO];
    [self.progressBar setHidden:YES];
    [self.botonCancelarUploadVista setHidden:YES];
    NSLog(@" Error - Statistics file upload failed: \"%@\"",[requestInstance error]);
    [self.botonEnviarVista setEnabled:YES];
    [self.botonCamara setEnabled:YES];
}

// Fin Functiones ASIHTTPRequest

// Función para iniciar camara
- (void) iniciarCamara {
    DLCImagePickerController *pickerController = [[DLCImagePickerController alloc] init];
    
    pickerController.delegate = self;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

// Inicio Funciones UIImagePickerController


- (void) imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    imagenCapturada = [info objectForKey:@"data"];
    
    [imagenObtenidaVista setImage:[UIImage imageWithData:imagenCapturada]];
    
    botonEnviarVista.enabled = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker{
    // Botón Cancelar
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Fin Funciones UIImagePickerController


@end
