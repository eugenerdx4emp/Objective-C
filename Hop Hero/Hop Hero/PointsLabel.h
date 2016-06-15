//
//  PointsLabel.h
//  Hop Hero
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PointsLabel : SKLabelNode
+ (id)pointLabelWithFontNamed:(NSString *)fontName;
- (void) increment;
- (void)setPoints:(int)points;
@property int number; 
@end
