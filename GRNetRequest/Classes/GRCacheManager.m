//
//  GRCacheManager.m
//  GroooSource
//
//  Created by Assuner on 2017/2/24.
//  Copyright © 2017年 Assuner. All rights reserved.
//

#import "GRCacheManager.h"
#import <MJExtension/MJExtension.h>

@interface GRCacheManager ()

@property (nonatomic, strong) NSCache *ramCache;
@property (nonatomic, strong) NSMutableDictionary *romCache;
@property (nonatomic, strong) NSArray *keysArray;
@property (nonatomic, assign) NSUInteger cacheCountLimit;

@end

@implementation GRCacheManager

+ (GRCacheManager *)sharedManager {
    static GRCacheManager *maneger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        maneger = [[GRCacheManager alloc] init];
    });
    return maneger;
}

- (instancetype)init {
    if (self = [super init]) {
        self.ramCache = [[NSCache alloc] init];
        self.cacheCountLimit = 20;
        self.ramCache.countLimit = self.cacheCountLimit;
        NSMutableDictionary *romCacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self filePath]];
        if (romCacheDic) {
            self.romCache = romCacheDic;
            self.keysArray = romCacheDic.allKeys;
        } else {
            self.romCache = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

+ (void)saveCacheWithObject:(GRModel *)model json:(NSDictionary *)dic forKey:(NSString *)path {
    [[self sharedManager] saveCacheWithObject:model json:dic forKey:path];
}

+ (id)modelCacheOfKey:(NSString *)path className:(NSString *)modelClassName {
    return [[self sharedManager] modelCacheOfKey:path className:modelClassName];
}

+ (void)setCacheCountLimit:(NSUInteger)count {
    [self clearAllCache];
    GRCacheManager *cacheManager = [self sharedManager];
    cacheManager.cacheCountLimit = count;
    cacheManager.ramCache.countLimit = cacheManager.cacheCountLimit;
}

+ (void)clearAllCache {
    GRCacheManager *manager = [self sharedManager];
    [manager.ramCache removeAllObjects];
    [manager.romCache removeAllObjects];
    manager.keysArray = nil;
    [manager.romCache writeToFile:[manager filePath] atomically:YES];
}

#pragma - Private Methods

- (NSString *)filePath {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"cache.plist"];
}

- (void)saveCacheWithObject:(GRModel *)model json:(NSDictionary *)dic forKey:(NSString *)path {
 @synchronized(self) {
     if (self.cacheCountLimit) {
         [self.ramCache setObject:model forKey:[path copy]];
         if (self.keysArray.count <= self.cacheCountLimit) {
             [self.romCache setObject:dic forKey:path];
         } else {
             [self.romCache removeObjectForKey:self.keysArray[0]];
             [self.romCache setObject:dic forKey:path];
         }
         self.keysArray = self.romCache.allKeys;
         [self.romCache writeToFile:[self filePath] atomically:YES];
     }
 }
}

- (id)modelCacheOfKey:(NSString *)path className:(NSString *)modelClassName {
 @synchronized(self) {
    id object = nil;
    if ([self.ramCache objectForKey:path]) {
        object = [self.ramCache objectForKey:path];
        return object;
    } else if ([self.keysArray containsObject:path]) {
        if (modelClassName) {
            Class modelClass = NSClassFromString(modelClassName);
            if (modelClass  && [modelClass isSubclassOfClass:[GRModel class]]) {
                NSDictionary *modelDic = [self.romCache objectForKey:path];
                object = [modelClass mj_objectWithKeyValues:modelDic];
                return object;
            }
        }
    }
    return object;
 }
}

@end
