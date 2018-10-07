//
//  ImageDownloader.m
//  TaipeiZoo
//
//  Created by Ruby on 2018/10/7.
//  Copyright © 2018年 Ruby. All rights reserved.
//

#import "ImageDownloader.h"
#import "AnimalEntity.h"

@interface ImageDownloader()
@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;
@end
@implementation ImageDownloader
//- (void)startDownload:(CGFloat)width andPicHeight:(CGFloat)height success: (void(^)(NSData *data))success
- (void)startDownload:(CGFloat)width andPicHeight:(CGFloat)height
{
    self.sessionTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.currentAnimal.pictureUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil)
        {
            if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
            {
                // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                // then your Info.plist has not been properly configured to match the target server.
                //
                abort();
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            
            // Set appIcon and clear temporary data/image
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            if (image.size.width != width || image.size.height != height)
            {
                CGSize itemSize = CGSizeMake(width, height);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                self.currentAnimal.picture = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            else
            {
                self.currentAnimal.picture= image;
            }
            
            // call our completion handler to tell our client that our icon is ready for display
//            if (success)
//            {
//                success(data);
//            }
            if (self.completionHandler) {
                self.completionHandler();
            }
        }];
    }];
    
    
    [self.sessionTask resume];
}
@end
