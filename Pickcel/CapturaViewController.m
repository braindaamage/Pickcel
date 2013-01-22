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
    BOOL botonFacebook;
    BOOL botonTwitter;
    ACAccount *twitterAccount;
    UIAlertView *errorTwitter;
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
    //self.capturaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"micro_carbon"]];
    //[self.toolBar setBackgroundImage:[UIImage imageNamed:@"tabbar"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.progressBar setHidden:YES];
    [self.botonCancelarUploadVista setHidden:YES];
    [self.labelError setHidden:YES];
    
    botonFacebook = NO;
    botonTwitter = NO;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(iniciarCamara)];
    [tapRecognizer setNumberOfTouchesRequired:1];
    [tapRecognizer setDelegate:self];
    
    [imagenObtenidaVista setUserInteractionEnabled:YES];
    [imagenObtenidaVista addGestureRecognizer:tapRecognizer];
    
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
    
    [self uploadFile];
    
    if (botonFacebook) {
        [self publishStory];
    }
    
    if (botonTwitter) {
        [self publishTwitter];
    }
    
}

- (void)limpiarDatos {
    [self.botonEnviarVista setEnabled:NO];
    
    UIImage *botonCamara = [UIImage imageNamed:@"botoncamara.png"];
    [self.imagenObtenidaVista setImage:botonCamara];
}

- (void)publishTwitter {
    
    //NSLog(@"Publicando en Twitter");
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // creamos un objeto accountType especificando que solo queremos obtener las cuentas de Twitter
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // guardamos las cuentas de twitter en un array
             NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
             // armamos la petición aquí
             
             // guardamos la cuenta
             ACAccount *cuenta = [accountsArray objectAtIndex:0];
             
             NSURL *url = [NSURL URLWithString: @"https://upload.twitter.com/1/statuses/update_with_media.json"];
             
             SLRequest *requestTwitter = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                            requestMethod:SLRequestMethodPOST
                                                                      URL:url
                                                               parameters:nil];
             
             //  self.accounts is an array of all available accounts;
             //  we use the first one for simplicity
             [requestTwitter setAccount:cuenta];
             
             //  The "larry.png" is an image that we have locally
             UIImage *image = [self.imagenObtenidaVista image];
             
             //  Obtain NSData from the UIImage
             NSData *imageData = UIImagePNGRepresentation(image);
             
             [requestTwitter addMultipartData:imageData withName:@"media[]"
                                         type:@"multipart/form-data"
                                     filename:nil];
             
             // NB: Our status must be passed as part of the multipart form data
             NSString *status = @"Perfect! Encontré lo que quería y con @Pickcel tengo el mejor descuento #DescuentosPickcel";
             
             [requestTwitter addMultipartData:[status dataUsingEncoding:NSUTF8StringEncoding]
                                     withName:@"status"
                                         type:@"multipart/form-data"
                                     filename:nil];
             
             
             //  Perform the request.
             //    Note that -[performRequestWithHandler] may be called on any thread,
             //    so you should explicitly dispatch any UI operations to the main thread
             [requestTwitter performRequestWithHandler:
              ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                  /*NSDictionary *dict =
                  (NSDictionary *)[NSJSONSerialization
                                   JSONObjectWithData:responseData options:0 error:nil];*/
                  
                  // Log the result
                  //NSLog(@"%@", dict);
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      // perform an action that updates the UI...
                  });
              }];
             

             
         } else {
             NSLog(@"Error no se pudo acceder a las cuentas: %@", [error localizedDescription]);
             //completionHandler(NO);
             //[errorTwitter show];
         }
     }];

    
}

- (void)publishStory
{
    NSLog(@"Publicando en Facebook");
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     [UIImage imageWithData:imagenCapturada], @"source",
     @"Perfect! Encontré lo que quería y con la aplicación Pickcel tengo el mejor descuento.", @"message",
     nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/photos"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSLog(@"Revisando Resultado");
         NSString *alertText;
         if (error) {
             NSLog(@"Error: %@", error);
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
             NSLog(@"Post Facebook: %@", result);
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

- (IBAction)btnFacebook:(id)sender {
    if (botonFacebook) {
        botonFacebook = NO;
    } else {
        [self verificarPermisosFacebook];
    }
    
    UIButton *boton = (UIButton *) sender;
    
    if (botonFacebook) {
        UIImage *imagen = [UIImage imageNamed:@"redesfbon.png"];
        [boton setImage:imagen forState:UIControlStateNormal];
    } else {
        UIImage *imagen = [UIImage imageNamed:@"redesfboff.png"];
        [boton setImage:imagen forState:UIControlStateNormal];
    }
}

- (void)facebookON {
    UIImage *imagen = [UIImage imageNamed:@"redesfbon.png"];
    [self.vistaBtnFacebook setImage:imagen forState:UIControlStateNormal];
}

- (void) verificarPermisosFacebook {
    botonFacebook = NO;
    NSLog(@"Verificando Facebook");
    if (FBSession.activeSession.isOpen) {
        NSLog(@"Sessión activa");
        // Ask for publish_actions permissions in context
        if ([FBSession.activeSession.permissions
             indexOfObject:@"publish_actions"] == NSNotFound) {
            NSLog(@"Obteniendo Permisos");
            // No permissions found in session, ask for it
            [FBSession.activeSession
             reauthorizeWithPublishPermissions:
             [NSArray arrayWithObject:@"publish_actions"]
             defaultAudience:FBSessionDefaultAudienceFriends
             completionHandler:^(FBSession *session, NSError *error) {
                 if (!error) {
                     // If permissions granted, publish the story
                     //[self publishStory];
                     botonFacebook = YES;
                     [self performSelectorOnMainThread:@selector(facebookON) withObject:nil waitUntilDone:YES];
                     NSLog(@"Permisos OK");
                 } else {
                     NSLog(@"No se pudo rescatar permsiso, error: %@", [error localizedDescription]);
                 }
             }];
        } else {
            NSLog(@"Permisos ya activos");
            botonFacebook = YES;
        }
    } else {
        NSLog(@"No se encontró Session");
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:YES withView:self tipoVista:@"captura"];
    }
}

- (IBAction)btnTwitter:(id)sender {
    if (botonTwitter) {
        botonTwitter = NO;
        UIImage *imagen = [UIImage imageNamed:@"redestwoff.png"];
        [self.vistaBotonTwitter setImage:imagen forState:UIControlStateNormal];
    } else {
        [self accesoTwitterWithCompletionHandler:^(BOOL access) {
            if (access) {
                botonTwitter = YES;
                [self performSelectorOnMainThread:@selector(cambiarImagenTwitter) withObject:nil waitUntilDone:YES];
            }
        }];
    }
}

- (void)cambiarImagenTwitter {
    UIImage *imagen = [UIImage imageNamed:@"redestwon.png"];
    [self.vistaBotonTwitter setImage:imagen forState:UIControlStateNormal];
}

- (void)accesoTwitterWithCompletionHandler:(void (^)(BOOL access))completionHandler {
    botonTwitter = NO;
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // creamos un objeto accountType especificando que solo queremos obtener las cuentas de Twitter
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // guardamos las cuentas de twitter en un array
             NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
             // armamos la petición aquí
             
             if ([accountsArray count] > 0) {
                 twitterAccount = [accountsArray objectAtIndex:0];
             } else {
                 twitterAccount = [accountsArray objectAtIndex:0];
             }

             completionHandler(YES);
             
         } else {
             NSLog(@"Error no se pudo acceder a las cuentas: %@", [error localizedDescription]);
             //completionHandler(NO);
             //[errorTwitter show];
             NSString *mensaje = @"No tienes cuentas de Twitter configuradas en el Sistema";
             [self performSelectorOnMainThread:@selector(errorEnHiloPrincipal:) withObject:mensaje waitUntilDone:YES];
         }
     }];
}

- (void)errorEnHiloPrincipal:(NSString *) mensaje {
    [self performSelectorOnMainThread:@selector(muestraError:) withObject:mensaje waitUntilDone:YES];
}

- (void)muestraError:(NSString *) mensaje{
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                    message:mensaje
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    
    [error show];
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
        
        [self performSelector:@selector(limpiarDatos) withObject:nil afterDelay:1.0];
        
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
