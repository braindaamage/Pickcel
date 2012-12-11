//
//  CapturaViewController.m
//  Pickcel
//
//  Created by Leonardo Olivares on 10-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "CapturaViewController.h"
#import "FiltrosCollectionViewCell.h"
#import "GPUImage.h"

@interface CapturaViewController () {
    UIImage *imagenOriginal;
}

@end

@implementation CapturaViewController
@synthesize imagenObtenidaVista, botonEnviarVista, coleccionFiltrosVista, botonFiltrosVista;

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
    botonFiltrosVista.enabled = NO;
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

- (IBAction)botonFiltros:(id)sender {
    NSInteger nuevoY;
    //NSLog(@"%f", coleccionFiltrosVista.frame.origin.y);
    if (coleccionFiltrosVista.frame.origin.y == 312) {
        nuevoY = coleccionFiltrosVista.frame.origin.y+61;
    } else {
        nuevoY = coleccionFiltrosVista.frame.origin.y-61;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [coleccionFiltrosVista setFrame:CGRectMake(coleccionFiltrosVista.frame.origin.x, nuevoY, coleccionFiltrosVista.frame.size.width, coleccionFiltrosVista.frame.size.height)];
    }];
}


// Aplicar Filtro a Imagen
- (IBAction)activarFiltro:(id)sender {
    UIButton *boton = (UIButton *) sender;
    BOOL sinFiltro = NO;
    
    GPUImageFilter *selectedFilter;
    switch (boton.tag) {
        case 0:
            sinFiltro = YES;
            break;
        case 1:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 3:
            selectedFilter = [[GPUImageSketchFilter alloc] init];
            break;
        case 4:
            selectedFilter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 5:
            selectedFilter = [[GPUImageToonFilter alloc] init];
            break;
        case 6:
            selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
            break;
        case 7:
            selectedFilter = [[GPUImagePixellateFilter alloc] init];
            break;
        default:
            break;
    }
    
     NSLog(@"Antes");
    
    UIImage *filteredImage;
    if (!sinFiltro) {
        filteredImage = [selectedFilter imageByFilteringImage:imagenOriginal];
    } else {
        filteredImage = imagenOriginal;
    }
    
    NSLog(@"Despues");
    [imagenObtenidaVista setImage:filteredImage];
}

// Función para iniciar camara
- (void) iniciarCamara {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [pickerController setDelegate:self];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

// Inicio Funciones UIImagePickerController

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Botón Cancelar
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    imagenOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [imagenObtenidaVista setImage:imagenOriginal];
    
    botonEnviarVista.enabled = YES;
    botonFiltrosVista.enabled = YES;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Fin Funciones UIImagePickerController

// Inicio Funciones UICollectionView

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FiltrosCollectionViewCell *celda = [collectionView dequeueReusableCellWithReuseIdentifier:@"FiltroCellID" forIndexPath:indexPath];
    
    [celda.botonVista setBackgroundImage: [UIImage imageNamed:@"icono.png"] forState:UIControlStateNormal];
    [celda.botonVista setTag:indexPath.item];
    
    return celda;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

// Fin Funciones UICollectionView


@end
