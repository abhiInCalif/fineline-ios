//
//  Order.h
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* roomNumber;
@property (nonatomic, strong) NSString* bldgName;
@property (nonatomic, strong) NSMutableArray* myOrder;
@property (nonatomic, strong) NSString* datetime;

+ (Order*)sharedOrder;
+ (void)initCatalogue:(id)sender;

@end
