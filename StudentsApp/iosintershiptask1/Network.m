//
//  Network.m
//  Students App
//
//  Created by Evgeny Ulyankin on 4/30/16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "Network.h"

@interface Network()
{
    NSInteger requestsCount;

}
@end

@implementation Network

#pragma mark - Request Methods
- (void) performRequestWithType:(RequestType)type params:(NSString *)params withUrl:(NSURL *) url completionHandler:(void (^)(NSData * data, NSURLResponse *  response, NSError *  error))completionHandler
{
    if(type == RequestTypePost){
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          
                                      }];
    [dataTask resume];
    }
    if(type == RequestTypeGet)
    {
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                     delegate:nil
                                                                delegateQueue:[NSOperationQueue mainQueue]];
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              
                                          }];
        [dataTask resume];
    }
}

#pragma mark - Network Methods
- (BOOL)connectedToInternet
{
    NSString *urlString = @"https://linneage.ru/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}





@end
