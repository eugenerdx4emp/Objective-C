//
//  PointsLabel.h
//  Nimble Ninja
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PointsLabel : SKLabelNode
@property (assign, nonatomic) NSInteger number;

- (void) increment;
- (void)setPoints:(NSInteger)points;
- (SKLabelNode *)initWithNum:(NSInteger)num;
@end
