//
//  GRShopListRequest.m
//  GroooSource
//
//  Created by 李永光 on 2017/2/8.
//  Copyright © 2017年 Assuner. All rights reserved.
//

#import "GRShopListRequest.h"

@implementation GRShopListRequest

- (instancetype)init {
    if (self = [super init]) {
        self.requestPath = @"http://api.grooo.cn/api/v3/shops/shop?school_id=1";
        self.httpMethod = GRHTTPMethodGet;
        self.modelClassName = @"GRShopList";
    }
    return self;
}

@end
