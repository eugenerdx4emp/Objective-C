//
//  Hero.m
//  Hop Hero
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "Hero.h"
@interface Hero ()
@property BOOL isJumping;
@end
@implementation Hero

static const uint32_t heroCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;
static const uint32_t groundCategory = 0x1 << 2;
+ (id)hero
{
    Hero *hero = [Hero spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(80,80)];
    SKSpriteNode *leftEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)];
    leftEye.position = CGPointMake(-6, 16);
    [hero addChild:leftEye];
    
    SKSpriteNode *rightEye = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)];
    rightEye.position = CGPointMake(26, 16);
    [hero addChild:rightEye];
    
    hero.name = @"hero";
    hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hero.size];
    hero.physicsBody.categoryBitMask = heroCategory;
    hero.physicsBody.contactTestBitMask = obstacleCategory | groundCategory;
    return hero;
}

- (void)jump
{
    if(!self.isJumping) {
        
        [self.physicsBody applyImpulse:CGVectorMake(0, 300)];
        [self runAction:([SKAction playSoundFileNamed:@"onJump.wav" waitForCompletion:NO])];
        
        self.isJumping = YES;
    }
}

- (void)land
{
    self.physicsBody.velocity = CGVectorMake(0, 0);
    self.isJumping = NO;
}

- (void)start
{
    SKAction *incrementRight = [SKAction moveByX:1.0f y:0 duration:0.004f];
    SKAction *moveRight = [SKAction repeatActionForever:incrementRight];
    [self runAction:moveRight];
}
- (void)stop
{
    [self removeAllActions];
}

@end
