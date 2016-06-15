//
//  WorldGenerator.h
//  Hop Hero
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WorldGenerator : SKNode
+ (id)generatorWithWorld: (SKNode *) world;
- (void) populate;
- (void) generate;
@end
