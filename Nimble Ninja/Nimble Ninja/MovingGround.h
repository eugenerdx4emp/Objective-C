//
//  MovingGround.h
//  Nimble Ninja
//
//  Created by eugenerdx on 10.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MovingGround : SKSpriteNode

- (SKSpriteNode *)initWithSize:(CGSize)size;
- (void)start;
- (void)stop;

@end
