//
//  ClientesCollectionViewCell.m
//  Pickcel
//
//  Created by Leonardo on 09-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "ClientesCollectionViewCell.h"

@implementation ClientesCollectionViewCell
@synthesize botonVista, indicadorCarga, imagenBoton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) cargarDatos:(NSMutableDictionary *) cliente {
    NSOperationQueue *manejaHilos = [NSOperationQueue new];
    NSInvocationOperation *operacion = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(cargarImagen:) object:[cliente valueForKey:@"imagen"]];
    
    [manejaHilos addOperation:operacion];
}

- (void) cargarImagen:(NSString *) url {
    UIImage *imagen = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    [self.imagenBoton performSelectorOnMainThread:@selector(setImage:) withObject:imagen waitUntilDone:YES];

    [self.indicadorCarga performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
}

@end
