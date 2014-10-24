//
//  finelineViewController.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/1/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "finelineViewController.h"
#import "FineLineAPIClient.h"
#import "ShoppingItem.h"
#import "Order.h"

@interface finelineViewController ()

@end

@implementation finelineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [Order initCatalogue:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
