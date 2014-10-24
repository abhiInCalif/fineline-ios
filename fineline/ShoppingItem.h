//
//  ShoppingItem.h
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingItem : NSObject

@property (nonatomic, strong) NSString* price;
@property (nonatomic, strong) NSString* sku;
@property (nonatomic, strong) NSString* photoUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int stock;

@end
