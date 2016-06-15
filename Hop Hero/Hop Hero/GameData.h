//
//  GameData.h
//  Hop Hero
//
//  Created by eugenerdx on 09.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject
@property int highscore;
+ (id)data;
- (void)save;
- (void)load;

@end
