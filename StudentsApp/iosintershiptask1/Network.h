//
//  Network.h
//  Students App
//
//  Created by Evgeny Ulyankin on 4/30/16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    RequestTypePut,
    RequestTypePost,
    RequestTypePatch,
    RequestTypeGet,
    RequestTypePostImage
} RequestType;

@interface Network : NSObject

- (void) performRequestWithType:(RequestType)type params:(NSString *)params withUrl:(NSURL *) url completionHandler:(void (^)(NSData * data, NSURLResponse *  response, NSError *  error))completionHandler;
- (BOOL)connectedToInternet;

@end
