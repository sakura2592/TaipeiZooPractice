//
//  AnimalEntity.h
//  TaipeiZoo
//
//  Created by Ruby on 2018/10/7.
//  Copyright © 2018年 Ruby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimalEntity : NSObject
@property (nonatomic, strong) NSString *cName;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSURL *pictureUrl;
@property (nonatomic, strong) UIImage *picture;
@end

NS_ASSUME_NONNULL_END
