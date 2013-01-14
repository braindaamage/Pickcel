//
//  CapturaViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "CapturaViewController.h"
#import "ASIFormDataRequest.h"
#import "ObtenerDescuentoNavigationViewController.h"
#import "DescuentoViewController.h"
#import <FacebookSDK/FacebookSDK.h>

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
    
    [self.redesView setHidden:YES];
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
    
    if (self.redesView.hidden == NO) {
        [self mostrarOcultarRedes];
    }
    
    [self uploadFile];
    
    if (self.botonFacebook.on) {
        [self publishStory];
    }
    
}

- (void)publishStory
{
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     [UIImage imageWithData:imagenCapturada], @"source",
     @"Estoy utilizando Pickcel para obtener un descuento!", @"message",
     nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/photos"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             
             // Show the result in an alert
             [[[UIAlertView alloc] initWithTitle:@"FACEBOOK ERROR"
                                         message:alertText
                                        delegate:self
                               cancelButtonTitle:@"OK!"
                               otherButtonTitles:nil]
              show];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
     }];
}

-(void)uploadFile{
    //NSURL *url = [NSURL URLWithString: @"http://www.reframe.cl/pickcel/sube.php"];
    
    NSURL *url = [NSURL URLWithString: @"http://www.pickcel.cl/admin/procesar.php"];
    
    request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    //if you have your site secured by .htaccess
    
    //[request setUsername:@"login"];
    //[request setPassword:@"password"];
    
    NSString *dispositivo = [[NSString alloc] initWithFormat:@"%@ - iOS %@", [[UIDevice currentDevice] localizedModel], [[UIDevice currentDevice] systemVersion]];
    ObtenerDescuentoNavigationViewController *navigation = (ObtenerDescuentoNavigationViewController *) self.navigationController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *idUsuario;
    idUsuario = [defaults objectForKey:@"idUsuario"];
    
    [request setPostValue:[navigation.cliente valueForKey:@"id"] forKey:@"marca"];
    [request setPostValue:idUsuario forKey:@"cliente"];
    [request setPostValue:dispositivo forKey:@"dispositivo"];
    
    // Upload an image
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageName:fileName])
    //NSData *imageData = UIImageJPEGRepresentation(imagenCapturada, 9);
    [request setData:imagenCapturada withFileName:@"imagen" andContentType:@"image/jpeg" forKey:@"imagen"];
    
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

- (IBAction)botonRedes:(id)sender {
    [self mostrarOcultarRedes];
}

- (IBAction)btnFacebook:(id)sender {
    [self verificarPermisosFacebook];
}

- (void) verificarPermisosFacebook {
    if (FBSession.activeSession.isOpen) {
        // Ask for publish_actions permissions in context
        if ([FBSession.activeSession.permissions
             indexOfObject:@"publish_actions"] == NSNotFound) {
            // No permissions found in session, ask for it
            [FBSession.activeSession
             reauthorizeWithPublishPermissions:
             [NSArray arrayWithObject:@"publish_actions"]
             defaultAudience:FBSessionDefaultAudienceFriends
             completionHandler:^(FBSession *session, NSError *error) {
                 if (!error) {
                     // If permissions granted, publish the story
                     //[self publishStory];
                 }
             }];
        }
    } else {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        if ([appDelegate openSessionWithAllowLoginUI:NO]) {
            [self verificarPermisosFacebook];
        }
    }
}

- (IBAction)btnTwitter:(id)sender {
}

- (void)mostrarOcultarRedes {
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.redesView.layer addAnimation:transition forKey:nil];
    if (self.redesView.hidden == YES) {
        [self.redesView setHidden:NO];
    } else {
        [self.redesView setHidden:YES];
    }
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
    NSString *respuesta = [[requestInstance responseHeaders] objectForKey:@"Content-Type"];
    
    [self.progressBar setHidden:YES];
    [self.botonCancelarUploadVista setHidden:YES];
    [self.botonEnviarVista setEnabled:YES];
    [self.botonCamara setEnabled:YES];
    
    if ([respuesta isEqualToString:@"image/jpg"]) {
        NSData *responseData = [requestInstance responseData];
        UIImage *imagenRespuesta = [[UIImage alloc] initWithData:responseData];
        
        DescuentoViewController *descuento = [self.storyboard instantiateViewControllerWithIdentifier:@"DescuentoCID"];
        [descuento cargarImagen:imagenRespuesta];
        [descuento setTitle:@"Descuento!"];
        
        
        [self.navigationController pushViewController:descuento animated:YES];
    } else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:@"Ocurrio un error al obtener el descuento, intentalo más tarde"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [error show];
    }
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
