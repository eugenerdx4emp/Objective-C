//
//  ImagesService.m
//  Students App
//
//  Created by eugenerdx on 13.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "ImagesService.h"

static ImagesService *sharedInstance;

@interface ImagesService ()
{
}
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation ImagesService

+ (ImagesService*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImagesService alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCache = [[NSCache alloc] init];
    }
    return self;
}

- (void)cacheImage:(UIImage*)image forKey:(NSString*)key {
    [self.imageCache setObject:image forKey:key];
}

- (UIImage*)getCachedImageForKey:(NSString*)key {
    return [self.imageCache objectForKey:key];
}
@end
