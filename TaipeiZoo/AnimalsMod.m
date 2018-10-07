//
//  AnimalsMod.m
//  TaipeiZoo
//
//  Created by Ruby on 2018/10/7.
//  Copyright © 2018年 Ruby. All rights reserved.
//

#import "AnimalsMod.h"

@implementation AnimalsMod
- (void)getAnimalsData:(NSString*)url success:(void (^)(NSDictionary *results))success failure:(void(^)(NSError* error))failure   {
    
    [self sendRequest:url success:^(NSData* data){
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSDictionary *result = [jsonData objectForKey:@"result"];
        NSArray *results =[result objectForKey:@"results"];
        NSMutableArray *ary = [NSMutableArray new];
        for (NSDictionary *dict in results) {
            AnimalEntity *animal = [AnimalEntity new];
            animal.cName = [dict objectForKey:@"A_Name_Ch"];
            animal.location = [dict objectForKey:@"A_Location"];
            NSString *content = [dict objectForKey:@"A_Behavior"];
            if (!content || content.length ==0) {
                content = [dict objectForKey:@"A_Interpretation"];
            }
            animal.content = content;
            animal.pictureUrl = [NSURL URLWithString:[dict objectForKey:@"A_Pic01_URL"]];
            [ary addObject:animal];
        }
        
        NSDictionary *resp = @{@"animals":ary, @"totalCnt":[result objectForKey:@"count"], @"offset":[result objectForKey:@"offset"]};
        success(resp);
    } failure:^(NSError *error){
        failure(error);
    }];
}


- (void)sendRequest:(NSString*)url success:(void (^)(NSData* data))success failure:(void(^)(NSError* error))failure {
    NSLog(@"URL: %@", url);
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        if (error) {
            NSLog(@"get Data error: %@", error);
            if (failure) {
                failure(error);
            }
            
        }else{
            if (success) {
                success(data);
            }
            
        }
    }];
    [dataTask resume];
}

@end
