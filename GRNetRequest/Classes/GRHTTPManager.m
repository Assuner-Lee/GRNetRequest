//
//  GRHTTPManager.m
//  GroooSource
//
//  Created by 李永光 on 2017/2/7.
//  Copyright © 2017年 Assuner. All rights reserved.
//

#import "GRHTTPManager.h"

#pragma mark C-Method

@implementation GRHTTPManager

+ (AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.removesKeysWithNullValues = YES;
        manager.responseSerializer = responseSerializer;
        manager.requestSerializer.timeoutInterval = 20;
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return manager;
}

#pragma mark HTTPMethod

+ (void)GET:(NSString *_Nonnull)path paramsDic:(NSDictionary *_Nullable)paramsDic completionHandler:(nullable GRRequestComplete)complete {
    [[self sharedManager] GET:path parameters:paramsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complete) {
            complete(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(nil, error);
        }
    }];
}

+ (void)POST:(NSString *_Nonnull)path paramsDic:(NSDictionary *_Nullable)paramsDic completionHandler:(nullable GRRequestComplete)complete {
    [[self sharedManager] POST:path parameters:paramsDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complete) {
            complete(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(nil, error);
        }
    }];
}

+ (void)PUT:(NSString *_Nonnull)path paramsDic:(NSDictionary *_Nullable)paramsDic completionHandler:(nullable GRRequestComplete)complete {
    [[self sharedManager] PUT:path parameters:paramsDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complete) {
            complete(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(nil, error);
        }
    }];
}


@end


