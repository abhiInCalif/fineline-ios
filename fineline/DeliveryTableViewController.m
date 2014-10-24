//
//  DeliveryTableViewController.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/9/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "DeliveryTableViewController.h"
#import "Braintree.h"
#import "BTPaymentMethod.h"
#import "Order.h"
#import "FineLineAPIClient.h"

@interface DeliveryTableViewController ()

@end

@implementation DeliveryTableViewController

NSString* clientToken;

NSString* nonce;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // you need to get the client token from the server!
    FineLineAPIClient* client = [FineLineAPIClient sharedClient];
    [client getClientToken:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success -- %@", responseObject);
        NSDictionary* responseDictionary = (NSDictionary*) responseObject;
        clientToken = [responseDictionary objectForKey:@"token"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure -- %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tappedMyPayButton {
    // Create a Braintree with the client token
    Braintree *braintree = [Braintree braintreeWithClientToken:clientToken];
    // Create a BTDropInViewController
    BTDropInViewController *dropInViewController = [braintree dropInViewControllerWithDelegate:self];

    dropInViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(userDidCancelPayment)];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController
                       animated:YES
                     completion:nil];
}

- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:false];
}

- (void)dropInViewController:(__unused BTDropInViewController *)viewController didSucceedWithPaymentMethod:(BTPaymentMethod *)paymentMethod {
    nonce = paymentMethod.nonce;
    FineLineAPIClient *client = [FineLineAPIClient sharedClient];
    Order* order = [Order sharedOrder];
    
    // you need to post the nonce to the server along with everything else
    // in the order, and then wait for a valid response.
    [client postOrder:order nonce:nonce success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success -- %@", responseObject);
        if (responseObject[@"stock"] != nil) {
            // we have an overorder, we do not have that much of this item in stock.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Order Error!"
                                                            message:[NSString stringWithFormat:@"You ordered more than we have. We only have %d of item %@ in stock.", [responseObject[@"stock"] intValue], responseObject[@"item"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else if (responseObject[@"return"] != nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self performSegueWithIdentifier:@"toPayment" sender:self];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Error!"
                                                            message:@"Failed to process your order! Please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure -- %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Error!"
                                                        message:@"Failed to process your order! Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)confirmOrder:(id)sender {
    Order* order = [Order sharedOrder];
    order.roomNumber = self.roomNumber.text;
    order.bldgName = self.bldgName.text;
    order.name = self.name.text;
    order.datetime = self.deliveryTime.text;
    
    if ([order.roomNumber isEqual:@""] || [order.bldgName isEqual:@""] || [order.name isEqual:@""] || [order.datetime isEqual:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Form Error!"
                                                        message:@"You must fill out all fields before proceeding!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // bring up the payment stuff....
        [self tappedMyPayButton];
    }
}
@end
