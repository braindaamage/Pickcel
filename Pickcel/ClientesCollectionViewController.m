//
//  ClientesCollectionViewController.m
//  Pickcel
//
//  Created by Leonardo on 09-12-12.
//  Copyright (c) 2012 Reframe. All rights reserved.
//

#import "ClientesCollectionViewController.h"
#import "ClientesCollectionViewCell.h"
#import "ObtenerDescuentoNavigationViewController.h"

@interface ClientesCollectionViewController () {
    NSMutableArray *clientes;
    NSMutableDictionary *clienteActual;
    NSMutableString *currentNode;
}
@end

@implementation ClientesCollectionViewController
@synthesize vistaColeccion;

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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Volver" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    self.vistaColeccion.backgroundColor = [UIColor colorWithPatternImage:
                                           [UIImage imageNamed:@"micro_carbon"]];
    
    
    // Configuración para parseo de XML
    clientes = [[NSMutableArray alloc] init];
    
    // Parseo archivo local
    //NSXMLParser *parseador = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"feeds.xml"]]];
    // Parseo URL
     NSURL *url = [NSURL URLWithString:@"http://www.reframe.cl/pickcel/feeds.xml"];
     NSXMLParser *parseador = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    parseador.delegate = self;
    [parseador parse];
    
    [self cargarDatos];
}

- (void) cargarDatos {
    NSOperationQueue *manejaHilos = [NSOperationQueue new];
    
    NSInvocationOperation *operacion;
    
    for (int i = 0; i < [clientes count]; i++) {
        operacion = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(cargarImagen:) object:[clientes objectAtIndex:i]];
        [manejaHilos addOperation:operacion];
    }
}

- (void) cargarImagen:(NSDictionary *) itemActual {
    UIImage *imagen = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemActual valueForKey:@"url"]]]];
    
    ClientesCollectionViewCell *celda = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"celdaID" forIndexPath:[itemActual valueForKey:@"indexPah"]];
    
    [celda.imagenBoton performSelectorOnMainThread:@selector(setImage:) withObject:imagen waitUntilDone:YES];
                                         
}


// Funciones NSXMLParseDelegate

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"cliente"]) {
        clienteActual = [[NSMutableDictionary alloc] init];
        currentNode = [[NSMutableString alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"titulo"]) {
        [clienteActual setValue:currentNode forKey:@"titulo"];
    } else if ([elementName isEqualToString:@"descripcion"]) {
        [clienteActual setValue:currentNode forKey:@"descripcion"];
    } else if ([elementName isEqualToString:@"imagen"]) {
        [clienteActual setValue:currentNode forKey:@"imagen"];
    } else if ([elementName isEqualToString:@"cliente"]) {
        [clientes addObject:clienteActual];
    }
    
    currentNode = nil;
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!currentNode) {
        currentNode = [[NSMutableString alloc] initWithString:string];
    } else {
        [currentNode appendString:string];
    }
}

// Fin Funciones NSXMLParseDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClientesCollectionViewCell *celda = [collectionView dequeueReusableCellWithReuseIdentifier:@"celdaID" forIndexPath:indexPath];
    
    [celda.botonVista setBackgroundImage: [UIImage imageNamed:@"icono.png"] forState:UIControlStateNormal];
    //[celda.botonVista setAlpha:0];
    [celda.indicadorCarga startAnimating];
    [celda.botonVista setTag:indexPath.item];
    
    //[celda cargarDatos:[clientes objectAtIndex:indexPath.item]];
    
    return celda;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [clientes count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)celdaBotonPulsar:(id)sender {
    ObtenerDescuentoNavigationViewController *vistaCliente = [self.storyboard instantiateViewControllerWithIdentifier:@"ObtenerDescuentroCID"];
    UIButton *boton = (UIButton *) sender;
    
    vistaCliente.cliente = [clientes objectAtIndex:boton.tag];
    
    [self presentViewController:vistaCliente animated:YES completion:nil];

}

@end
