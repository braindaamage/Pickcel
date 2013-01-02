//
//  DescuentoViewController.h
//  Pickcel
//
//  Created by Leonardo Olivares on 02-01-13.
//  Copyright (c) 2013 Reframe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DescuentoViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *descuentoView;
@property (weak, nonatomic) IBOutlet UIImageView *imagenDescuento;

- (void)cargarImagen:(UIImage *) imagenData;

@end
