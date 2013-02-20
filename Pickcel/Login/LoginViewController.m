//
//  LoginViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 04-01-13.
//  Copyright (c) 2013 Reframe. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIFormDataRequest.h"

@interface LoginViewController () {
    int indice;
    ASIFormDataRequest *request;
}

@end

@implementation LoginViewController

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
    // Do any additional set…up after loading the view from its nib.
    
    camposArray = [[NSArray alloc] initWithObjects:self.nombre, self.email, self.fechaNacimiento, nil];
    
    
    [self.toolBar setTranslucent:YES];
    
    [self.fechaNacimiento setDelegate:self];
    [self.nombre setDelegate:self];
    [self.email setDelegate:self];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(datePickerValueChangedd:) forControlEvents:UIControlEventValueChanged];
    
    [self.fechaNacimiento setInputAccessoryView:self.toolBar];
    [self.fechaNacimiento setInputView:datePicker];
}

- (NSString *)datePickerValueChangedd:(UIDatePicker*) datePicker {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    
    [self.fechaNacimiento setText:[NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]]];
    
    return self.fechaNacimiento.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setInputAccessoryView:self.toolBar];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.vistaLogin setFrame: CGRectMake(self.vistaLogin.frame.origin.x, -200, self.vistaLogin.frame.size.width, self.vistaLogin.frame.size.height)];
    }];
    
    indice = textField.tag;
    
    if (textField.tag == 0) {
        [self.btnAnterior setEnabled:NO];
    } else {
        [self.btnAnterior setEnabled:YES];
    }
    
    if (textField.tag == 2) {
        [self.btnSiguiente setEnabled:NO];
    } else {
        [self.btnSiguiente setEnabled:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginFacebook:(id)sender {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate openSessionWithAllowLoginUI:YES withView:self tipoVista:@"login"];
    
}

- (IBAction)cerrarTeclado:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.vistaLogin setFrame: CGRectMake(self.vistaLogin.frame.origin.x, 0, self.vistaLogin.frame.size.width, self.vistaLogin.frame.size.height)];
    }];
    
    [self.nombre resignFirstResponder];
    [self.email resignFirstResponder];
    [self.fechaNacimiento resignFirstResponder];
}

- (IBAction)anterior:(id)sender {
    [[camposArray objectAtIndex:indice-1] becomeFirstResponder];
}

- (IBAction)siguiente:(id)sender {
    [[camposArray objectAtIndex:indice+1] becomeFirstResponder];
}

- (IBAction)actRegistrar:(id)sender {
    if ([self verificarTexto]) {
        [self registrar];
    } else {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                         message:@"Debes ingresar todos los datos"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        
        [alerta show];
    }
}

- (BOOL)verificarTexto {
    if ([self.nombre.text isEqualToString:@""] && [self.email.text isEqualToString:@""] && [self.fechaNacimiento.text isEqualToString:@""]) {
        return NO;
    } else {
        return YES;
    }
}


// Funciones ASIHTTPRequest

-(void)registrar{
    //NSURL *url = [NSURL URLWithString: @"http://www.reframe.cl/pickcel/sube.php"];
    
    NSURL *url = [NSURL URLWithString: @"http://www.pickcel.cl/admin/serviciocliente.php"];
    
    request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUseKeychainPersistence:YES];
    
    
    [request setPostValue:self.nombre.text forKey:@"nombre"];
    [request setPostValue:self.email.text forKey:@"email"];
    [request setPostValue:self.fechaNacimiento.text forKey:@"edad"];
    
    [request setDelegate:self];
    //[request setUploadProgressDelegate:progressBar];
    [request setTimeOutSeconds:60];
    [request setDidFinishSelector:@selector(uploadRequestFinished:)];
    [request setDidFailSelector:@selector(uploadRequestFailed:)];
    [request setDidStartSelector:@selector(uploadRequestStart:)];
    
    [request startAsynchronous];
}

- (void) uploadRequestStart:(ASIHTTPRequest *) requestInstance {
    
}

- (void)uploadRequestFinished:(ASIHTTPRequest *)requestInstance{
    //NSLog(@"Respuesta: %@", [requestInstance responseString]);
    // Store the data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[requestInstance responseString] forKey:@"idUsuario"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadRequestFailed:(ASIHTTPRequest *)requestInstance{
    NSString *error;
    switch ([[requestInstance error] code]) {
        case 1:
            error = [[NSString alloc] initWithFormat:@"Error de conexión."];
            break;
        case 2:
            //self.labelError.text = @"Tiempo de espera agotado.";
            error = [[NSString alloc] initWithFormat:@"Tiempo de espera agotado."];
            break;
        default:
            error = [[NSString alloc] initWithFormat:@"Error desconocido (%i)", [[requestInstance error] code]];
            break;
    }
    
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                     message:error
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    
    [alerta show];
    
}

// Fin Functiones ASIHTTPRequest

@end
