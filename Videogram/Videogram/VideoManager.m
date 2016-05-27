//
//  VideoManager.m
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//


#import "VideoManager.h"
#import "Video.h"

@implementation VideoManager


- (void)getVideos:(NSString*)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock {
    NSString* apiKey = @"AIzaSyBgONev8muz6gnAyl4LriEwMjT76XXTNVc";
    NSString* optionalParams = @"";
    if(channelID){
        optionalParams = [NSString stringWithFormat:@"&channelId=%@", channelID];
    }
    NSString* URL = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&regionCode=US&relevanceLanguage=en&$type=video&order=relevance&maxResults=11&q=%@&key=%@&alt=json%@", @"ios", apiKey, optionalParams];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[URL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if(!error){
                    Video* vid = [[Video alloc] init];
                    
                    [vid getVideoList:[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] completionBlock:^(NSMutableArray * videoList) {
                        completionBlock(videoList);
                    }];
                }
                else {
                    NSLog(@"error = %@", error);
                }
                
            }] resume];
}

@end
