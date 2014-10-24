//
//  Order.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "Order.h"
#import "FineLineAPIClient.h"
#import "ShoppingItem.h"

@implementation Order

@synthesize bldgName = _bldgName;
@synthesize name = _name;
@synthesize items = _items;
@synthesize roomNumber = _roomNumber;
@synthesize datetime = _datetime;

static Order *sharedOrder = nil;
static dispatch_once_t onceToken;

+ (Order*)sharedOrder {
    dispatch_once(&onceToken, ^{
        sharedOrder = [[self alloc] init];
    });
    return sharedOrder;
}

+ (void)initCatalogue:(id)sender {
    Order* yourOrder = [Order sharedOrder];
    yourOrder.items = [NSMutableArray new];
    
    FineLineAPIClient *client = [FineLineAPIClient sharedClient];
    
    [client getCatalogue:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Success -- %@", responseObject);
        NSArray* responseDictionary = (NSArray*) responseObject;
        for (int i = 0; i < [responseDictionary count]; i = i + 1) {
            ShoppingItem* item = [ShoppingItem new];
            item.price = [NSString stringWithFormat:@"%@",[responseDictionary objectAtIndex:i][@"fields"][@"price"]];
            item.photoUrl = [responseDictionary objectAtIndex:i][@"fields"][@"photo"];
            item.name = [responseDictionary objectAtIndex:i][@"fields"][@"name"];
            item.sku = [responseDictionary objectAtIndex:i][@"fields"][@"sku"];
            item.stock = [[responseDictionary objectAtIndex:i][@"fields"][@"stock"] intValue];
            [yourOrder.items addObject:item];
        }
        
        // transition to next view programatically!
        if (sender != nil) {
            [sender performSegueWithIdentifier:@"toBrowse" sender:self];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Failure -- %@", error);
    }];
}

- (id)init {
    if (self = [super init]) {
        self.bldgName = @"";
        self.name = @"";
        self.items = [NSMutableArray new];
        self.roomNumber = @"";
        self.datetime = @"";
        self.myOrder = [NSMutableArray new];
    }
    return self;
}

@end
