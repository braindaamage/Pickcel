//
//  VistaClienteViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VistaClienteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *tituloLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagenView;
@property (weak, nonatomic) IBOutlet UILabel *descripcionLabel;
@property (weak, nonatomic) NSString *capturarDato;

@end
