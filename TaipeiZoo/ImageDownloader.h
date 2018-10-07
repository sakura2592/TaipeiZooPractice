//
//  ImageDownloader.h
//  TaipeiZoo
//
//  Created by Ruby on 2018/10/7.
//  Copyright © 2018年 Ruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimalEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDownloader : NSObject
@property (nonatomic, strong) AnimalEntity *currentAnimal;
@property (nonatomic, copy) void (^completionHandler)(void);
//- (void)startDownload:(CGFloat)width andPicHeight:(CGFloat)height success: (void(^)(NSData *data))success;
- (void)startDownload:(CGFloat)width andPicHeight:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
