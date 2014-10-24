//
//  FineLineAPIClient.h
//  fineline
//
//  Created by Abhinav  Khanna on 8/6/14.
//  Copyright (c) 2014 Fine Lines. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Order.h"

extern NSString* const fineLineAPIBaseURLString;

@interface FineLineAPIClient : AFHTTPSessionManager

+ (FineLineAPIClient*)sharedClient;

- (void)getCatalogue:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getClientToken:(void(^)(NSURLSessionDataTask *task, id responseObject))success
               failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)postOrder:(Order*)order nonce:(NSString*)nonce success:(void(^)(NSURLSessionDataTask *task, id responseObject))success failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
