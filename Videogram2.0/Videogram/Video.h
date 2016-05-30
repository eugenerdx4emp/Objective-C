//
//  Video.h
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic, strong) NSString* videoTitle;
@property (nonatomic, strong) NSString* videoID;
@property (nonatomic, strong) NSString* channelTitle;
@property (nonatomic, strong) NSString* channelID;
@property (nonatomic, strong) NSString* videoDescription;
@property (nonatomic, strong) NSString* thumbnailURL;
@property (nonatomic, strong) NSDate* pubDate;

- (void)getVideoList:(NSDictionary*)videoData completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
