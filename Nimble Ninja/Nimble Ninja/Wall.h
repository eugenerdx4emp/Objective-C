//
//  Wall.h
//  Nimble Ninja
//
//  Created by eugenerdx on 10.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "UIColor+Wall.h"
@interface Wall : SKSpriteNode
- (void)stopMoving;
@property (strong,nonatomic) NSMutableArray* walls;
@property (strong,nonatomic) NSMutableArray* wallTrackers;
@end
