//
//  VideoManager.h
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface VideoManager : NSObject


- (void)getVideos:(NSString*)channelID completionBlock:(void (^)(NSMutableArray *))completionBlock;

@end
