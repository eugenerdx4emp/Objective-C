//
//  WallGenerator.m
//  Nimble Ninja
//
//  Created by eugenerdx on 10.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "WallGenerator.h"
#import "Wall.h"
#import "Constants.h"

@interface WallGenerator()
{
    NSTimer *generationTimer;
    Wall *wall;
}
@end
@implementation WallGenerator

NSMutableArray* walls;
NSMutableArray* wallTrackers;


+ (NSMutableArray *)walls
{
    if(!walls)
        walls = [[NSMutableArray alloc]init];
    
    return walls;
}

+ (NSMutableArray *)wallTrackers
{
    if(!wallTrackers)
        wallTrackers = [[NSMutableArray alloc]init];
    return wallTrackers;
}

- (void)startGeneraTingWallsEvery:(NSTimeInterval)second
{
    generationTimer = [NSTimer scheduledTimerWithTimeInterval:second
                                                       target:self
                                                     selector:@selector(generateWall)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopGenerating
{
    [generationTimer invalidate];
}

- (void)generateWall
{
    wall = [[Wall alloc]init];
    CGFloat scale;
    int rand;
    rand = arc4random_uniform(2);
    if(rand == 0)
    {
        scale = -1.0f;
    }
    else
    {
        scale = 1.0f;
    }
    CGPoint pos = wall.position;
    pos.x = self.size.width / 6 + wall.size.width / 2;
    pos.y = scale * (kMLGroundHeight/2 + wall.size.height / 2);
    wall.position = pos;
    wall.name = @"Wall";
    [[WallGenerator wallTrackers] addObject:wall];
    [[WallGenerator walls] addObject:wall];
    [self addChild:wall];
    
}

- (void)stopWalls
{
    [self stopGenerating];
    for (wall in walls)
    {
        [wall stopMoving];
    }
}
@end
