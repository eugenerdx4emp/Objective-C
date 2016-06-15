//
//  CloudGenerator.h
//  Nimble Ninja
//
//  Created by eugenerdx on 11.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CloudGenerator : SKSpriteNode
- (void)populate:(NSInteger)num;
- (void)startGeneratingWithSpawnTime:(CGFloat)seconds;
- (void)stopGenerating;

@end
