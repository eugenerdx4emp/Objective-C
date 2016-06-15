//
//  Hero.h
//  Nimble Ninja
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Hero : SKSpriteNode

- (void)stop;
- (void)loadPhysicsBodyWith:(CGSize)size;
- (void)startRunning;
- (void)fall;
- (void)flip;
- (void)breathe;
- (void)jump;
- (void)land;

@end
