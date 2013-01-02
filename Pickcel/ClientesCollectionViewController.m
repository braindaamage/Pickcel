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
    NSOperationQueue *manejaHilo;
}
@end

@implementation ClientesCollectionViewController
@synthesize vistaColeccion, indicadorCarga;

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
    self.vistaColeccion.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"micro_carbon"]];
    
    [self obtenerClientes];
}

- (void) obtenerClientes {
    
    if (self.navigationItem.rightBarButtonItem != nil) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self.indicadorCarga startAnimating];
    [self.progressBar setProgress:0.0];
    [self.progressBar setHidden:NO];
    
    // Configuración para parseo de XML
    clientes = [[NSMutableArray alloc] init];
    
    
    // Cargar Datos en nuevo Hilo para no congelar aplicación
    manejaHilo = [NSOperationQueue new];
    NSInvocationOperation *operacion = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parsearCLientes) object:nil];
    
    [manejaHilo addOperation:operacion];
    
}


// Funciones NSXMLParseDelegate

- (void) parsearCLientes {
    // Parseo archivo local
    //NSXMLParser *parseador = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"feeds.xml"]]];
    // Parseo URL
    
    //NSURL *url = [NSURL URLWithString:@"http://www.reframe.cl/pickcel/feeds.xml"];
    
    NSURL *url = [NSURL URLWithString:@"http://pickcel.cl/admin/marcasiphone.php"];
    
    NSXMLParser *parseador = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    parseador.delegate = self;
    
    [parseador parse];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    UIBarButtonItem *nuevoBoton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(obtenerClientes)];
    [self.navigationItem performSelectorOnMainThread:@selector(setRightBarButtonItem:) withObject:nuevoBoton waitUntilDone:YES];
    [self.indicadorCarga performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(ocultarBarra) withObject:nil waitUntilDone:YES];
    NSLog(@"%@", parseError);
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString:@"marca"]) {
        clienteActual = [[NSMutableDictionary alloc] init];
        currentNode = [[NSMutableString alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSString *currentNew = [currentNode stringByReplacingOccurrencesOfString:@"\n\t\t"
                                                         withString:@""];
    if ([elementName isEqualToString:@"nombre"]) {
        [clienteActual setValue:currentNew forKey:@"nombre"];
    } else if ([elementName isEqualToString:@"id"]) {
        [clienteActual setValue:currentNew forKey:@"id"];
    } else if ([elementName isEqualToString:@"icono"]) {
        //[clienteActual setValue:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:currentNode]]] forKey:@"imagen"];
        [clienteActual setValue:currentNew forKey:@"imagen"];
    } else if ([elementName isEqualToString:@"marca"]) {
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //[self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    //[self.indicadorCarga performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    
    [self cargarImagenes];
}

- (void)cargarImagenes {
    NSInvocationOperation *operacion;
    NSMutableArray *operaciones = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [clientes count]; i++) {
        NSNumber *indice = [NSNumber numberWithInteger:i];
        operacion = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(cargaImagenInternet: ) object:indice];
        [operaciones addObject:operacion];
        //[manejaHilo addOperation:operacion];
    }
    
    [manejaHilo addOperations:operaciones waitUntilFinished:YES];
    
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self.indicadorCarga performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(ocultarBarra) withObject:nil waitUntilDone:YES];
}

- (void) ocultarBarra {
    [self.progressBar setHidden:YES];
}

- (void)cargaImagenInternet:(NSNumber *) indice {
    NSMutableDictionary *itemActual = (NSMutableDictionary *) [clientes objectAtIndex:[indice integerValue]];
    [itemActual setValue:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemActual valueForKey:@"imagen"]]]] forKey:@"imagen"];
    [clientes setObject:itemActual atIndexedSubscript:[indice integerValue]];
    [self performSelectorOnMainThread:@selector(manejaBarraProgreso) withObject:nil waitUntilDone:YES];
}

- (void)manejaBarraProgreso {
    float porcentaje = (float)1/[clientes count];
    float actual = [self.progressBar progress];
    float nuevo = actual + porcentaje;
    
    [self.progressBar setProgress:nuevo];
}

// Fin Funciones NSXMLParseDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClientesCollectionViewCell *celda = [collectionView dequeueReusableCellWithReuseIdentifier:@"celdaID" forIndexPath:indexPath];
    
    [celda.botonVista setTag:indexPath.item];
    [celda.botonVista setBackgroundImage:[[clientes objectAtIndex:indexPath.item] valueForKey:@"imagen"] forState:UIControlStateNormal];
    
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
