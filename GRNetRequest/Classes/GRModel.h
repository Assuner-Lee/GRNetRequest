//
//  GRModel.h
//  GroooSource
//
//  Created by 李永光 on 2017/2/7.
//  Copyright © 2017年 Assuner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRModel : NSObject
+ (NSDictionary *)mj_replacedKeyFromPropertyName;
+ (NSDictionary *)mj_objectClassInArray;
+ (instancetype)jsonToModel:(NSDictionary *)json;

@end
