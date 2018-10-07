//
//  AnimalsMod.h
//  TaipeiZoo
//
//  Created by Ruby on 2018/10/7.
//  Copyright © 2018年 Ruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimalEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnimalsMod : NSObject

- (void)getAnimalsData:(NSString*)url success:(void (^)(NSDictionary *results))success failure:(void(^)(NSError* error))failure;

@end

NS_ASSUME_NONNULL_END
