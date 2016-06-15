//
//  Hero.h
//  Hop Hero
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Hero : SKSpriteNode
+(id)hero;
- (void)jump;
- (void)land;
- (void)start;
- (void)stop;

@end
