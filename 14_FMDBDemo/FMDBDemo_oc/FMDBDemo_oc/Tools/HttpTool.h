//
//  HttpTool.h
//  FMDBDemo_oc
//
//  Created by sunke on 2020/9/19.
//  Copyright © 2020 KentSun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpTool : NSObject
+ (void)loadRequestWithUrlString:(NSString *)urlString resultData:(void(^)(id))resultData;

@end

NS_ASSUME_NONNULL_END
