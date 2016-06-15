//
//  WorldGenerator.m
//  Hop Hero
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "WorldGenerator.h"
@interface WorldGenerator()
@property double currentGroundX;
@property double currentObstacleX;
@property SKNode *world;

@end
static const uint32_t heroCategory = 0x1 << 0;

static const uint32_t obstacleCategory = 0x1 << 1;

static const uint32_t groundCategory = 0x1 << 2;

@implementation WorldGenerator
+ (id)generatorWithWorld: (SKNode *) world
{
    WorldGenerator *generator = [WorldGenerator node];
    generator.currentGroundX = 0;
    generator.currentObstacleX = 800;
    generator.world = world;
    return generator;
}

- (void) populate
{
    for (int i=0; i <3; i++)
        [self generate];
}

- (void) generate
{
    SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    ground.name = @"ground";
    ground.position = CGPointMake(self.currentGroundX, -self.scene.frame.size.height/2 + ground.frame.size.height/2);
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ground.size];
    ground.physicsBody.categoryBitMask = groundCategory;

    ground.physicsBody.dynamic = NO;
    [self.world addChild:ground];
    
    self.currentGroundX += ground.frame.size.width;
    SKSpriteNode *obstacle = [SKSpriteNode spriteNodeWithColor:[self getRandomColor] size:CGSizeMake(40, 70)];
    obstacle.name = @"obstacle";
    obstacle.position = CGPointMake(self.currentObstacleX, ground.position.y + ground.frame.size.height / 2 + obstacle.frame.size.height /2 );
    obstacle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:obstacle.size];
    obstacle.physicsBody.categoryBitMask = obstacleCategory;
    obstacle.physicsBody.dynamic = NO;
    [self.world addChild:obstacle];
    
    self.currentObstacleX += 500;
}


- (UIColor *)getRandomColor
{
    UIColor * color;
    int rand = arc4random() % 6;
    switch(rand)
    {
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor orangeColor];
            break;
        case 2:
            color = [UIColor yellowColor];
            break;
        case 3:
            color = [UIColor greenColor];
            break;
        case 4:
            color = [UIColor purpleColor];
            break;
        case 5:
            color = [UIColor blueColor];
            break;
    }
    return color;
}
@end
