//
//  LoginViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 04-01-13.
//  Copyright (c) 2013 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    NSArray *camposArray;
}
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UITextField *fechaNacimiento;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAnterior;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSiguiente;

- (IBAction)loginFacebook:(id)sender;
- (IBAction)cerrarTeclado:(id)sender;
- (IBAction)anterior:(id)sender;
- (IBAction)siguiente:(id)sender;
- (IBAction)actRegistrar:(id)sender;

-(void)registrar;


@end
