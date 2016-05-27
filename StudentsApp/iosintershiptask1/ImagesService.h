//
//  ImagesService.h
//  Students App
//
//  Created by eugenerdx on 13.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImagesService : NSObject
+(ImagesService*)sharedInstance;

// set
- (void)cacheImage:(UIImage*)image forKey:(NSString*)key;
// get
- (UIImage*)getCachedImageForKey:(NSString*)key;




@end