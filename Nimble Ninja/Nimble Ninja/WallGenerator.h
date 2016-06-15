//
//  WallGenerator.h
//  Nimble Ninja
//
//  Created by eugenerdx on 10.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface WallGenerator : SKSpriteNode


- (void)generateWall;
- (void)startGeneraTingWallsEvery:(NSTimeInterval)second;
- (void)stopWalls;

+ (NSMutableArray *)walls;
+ (NSMutableArray *)wallTrackers;

@end
