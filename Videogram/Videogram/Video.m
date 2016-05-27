//
//  Video.m
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import "Video.h"
#import "NSString+StringUtilities.h"

@implementation Video

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        _videoTitle = dictionary[@"snippet"][@"title"];
        _videoID = dictionary[@"id"][@"videoId"];
        _channelID = dictionary[@"snippet"][@"channelId"];
        _channelTitle = dictionary[@"snippet"][@"channelTitle"];
        _videoDescription = dictionary[@"snippet"][@"description"];
        _pubDate = [dictionary[@"snippet"][@"publishedAt"] dateWithJSONString];
        _thumbnailURL = dictionary[@"snippet"][@"thumbnails"][@"high"][@"url"];
    }
    
    return self;
}


- (void)getVideoList:(NSDictionary*)videoData completionBlock:(void (^)(NSMutableArray *))completionBlock {
    
    NSLog(@"video Data = %@", videoData);
    
    NSArray *videos = (NSArray*)[videoData objectForKey:@"items"];
    NSMutableArray* videoList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *videoDetail in videos) {
        if(videoDetail[@"id"][@"videoId"]){
           [videoList addObject:[[Video alloc] initWithDictionary:videoDetail]];
        }
    }
    
    completionBlock(videoList);
}




@end
