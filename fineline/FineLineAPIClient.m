//
//  FineLineAPIClient.m
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import "FineLineAPIClient.h"
#import "ShoppingItem.h"

NSString* const fineLineAPIBaseURLString = @"http://fineline.herokuapp.com";
//NSString* const fineLineAPIBaseURLString = @"http://localhost:8000";


@implementation FineLineAPIClient

+ (FineLineAPIClient *)sharedClient {
    static FineLineAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:fineLineAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    return self;
}

- (void)performRequest:(NSString*)path success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)performPOST:(NSString*)path parameters:(NSDictionary*)parameters success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    [self POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

- (void)getCatalogue:(void(^)(NSURLSessionDataTask *task, id responseObject))success
             failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSString* path = [NSString stringWithFormat:@"api-orders/catalogue"];
    [self performRequest:path success:success failure:failure];
}

- (void)getClientToken:(void(^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    // retrieves the client token from the server
    NSString* path = [NSString stringWithFormat:@"api-payments/clienttoken"];
    [self performRequest:path success:success failure:failure];
}

- (void)postOrder:(Order*)order nonce:(NSString*)nonce success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSDictionary* someParams = @{ @"payment_nonce": nonce,
                                  @"address": [NSString stringWithFormat:@"%@, %@", order.roomNumber, order.bldgName],
                                  @"name": order.name,
                                  @"datetime":order.datetime,
                                  };
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    [parameters addEntriesFromDictionary:someParams];
  
    NSMutableArray* skus = [NSMutableArray new];
    for (int i = 0; i < [order.myOrder count]; i++) {
        [skus addObject:((ShoppingItem*)(order.myOrder[i])).sku];
        [skus addObject:[NSString stringWithFormat:@"%d",((ShoppingItem*)(order.myOrder[i])).count]];
    }
    
    NSDictionary* skuDict = @{@"sku":skus};
    [parameters addEntriesFromDictionary:skuDict];
    
    NSString* path = @"api-orders/placeorder/";
    [self performPOST:path parameters:parameters success:success failure:failure];
}


@end
