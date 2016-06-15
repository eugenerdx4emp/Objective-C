//
//  Wall.m
//  Nimble Ninja
//
//  Created by eugenerdx on 10.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "Wall.h"
#import "Constants.h"

@implementation Wall

static const CGFloat WALL_WIDTH = 50.0f;
static const CGFloat WALL_HEIGHT = 80.0f;

- (SKSpriteNode *)init
{
    self = [super init];
    if (self)
    {
        CGSize size = CGSizeMake(WALL_WIDTH, WALL_HEIGHT);
        
        self = [[Wall alloc] initWithTexture:nil
                                       color:[UIColor getRandomColor]
                                        size:size];
        [self loadPhysicsBodyWithSize:size];
        [self startMoving];
    }
    return self;
}

- (void)loadPhysicsBodyWithSize:(CGSize)size
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    self.physicsBody.categoryBitMask = wallCategory;
    self.physicsBody.affectedByGravity = false;
}

- (void)startMoving
{
    SKAction *moveLeft = [SKAction moveByX:-kDefaultXToMovePerSecond
                                         y:0
                                  duration:1];
    
    [self runAction:[SKAction repeatActionForever:moveLeft]];
}

- (void)stopMoving
{
    [self removeAllActions];
}

@end
