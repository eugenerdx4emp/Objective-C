//
//  MovingGround.m
//  Nimble Ninja
//
//  Created by eugenerdx on 10.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "MovingGround.h"
#import "Constants.h"
static const CGFloat NUMBER_OF_SEGMENTS = 20.0f;

@implementation MovingGround


- (SKSpriteNode *)initWithSize:(CGSize)size
{
    self = [super init];
    if (self)
    {
        self = [[MovingGround alloc] initWithTexture:nil
                                               color:[UIColor blackColor]
                                                size:size];
        
        UIColor *COLOR_ONE = [UIColor colorWithRed: 88.0f/255.0f
                                             green: 148.0f/255.0f
                                              blue: 87.0f/255.0f
                                             alpha: 1.0f];
        
        UIColor *COLOR_TWO = [UIColor colorWithRed: 120.0f/255.0f
                                             green: 195.0f/255.0f
                                              blue: 118.0f/255.0f
                                             alpha: 1.0f];
        
        self.anchorPoint = CGPointMake(0, 0.5);
        int i;
        UIColor *segmentedColor;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        self.physicsBody.categoryBitMask = groundCategory;
        self.physicsBody.affectedByGravity = true;
        self.physicsBody.dynamic = NO;
        
        for(i=0; i < NUMBER_OF_SEGMENTS; i++)
        {
            if (i%2 == 0)
            {
                segmentedColor = COLOR_ONE;
            }
            else
            {
                segmentedColor = COLOR_TWO;
            }
            SKSpriteNode *segment = [SKSpriteNode spriteNodeWithColor:segmentedColor
                                                                 size:CGSizeMake(self.size.width / NUMBER_OF_SEGMENTS, self.size.height)];
            segment.anchorPoint = CGPointMake(0, 0.5);
            segment.position = CGPointMake(i*segment.size.width, 0);
            
            [self addChild:segment];
        }
        [self loadPhysicsBodyWithSize];
    }
    return self;
    
}
- (void)loadPhysicsBodyWithSize
{


}

- (void)start
{
    NSTimeInterval adjustedDuration = self.frame.size.width / kDefaultXToMovePerSecond;
    SKAction *moveLeft = [SKAction moveByX:-self.frame.size.width / 2
                                         y:0
                                  duration:adjustedDuration / 2];
    
    SKAction *resetPosition = [SKAction moveToX:0
                                       duration:0];
    
    NSMutableArray *sequence = [NSMutableArray new];
    [sequence addObject:moveLeft];
    [sequence addObject:resetPosition];
    SKAction *moveSequence = [SKAction sequence:sequence];
    [self runAction:[SKAction repeatActionForever:moveSequence]];
}

- (void)stop
{
    [self removeAllActions];
}
@end
