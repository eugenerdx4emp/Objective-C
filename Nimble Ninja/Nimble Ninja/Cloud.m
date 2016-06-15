//
//  Cloud.m
//  Nimble Ninja
//
//  Created by eugenerdx on 11.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "Cloud.h"
@interface Cloud()
{
    Cloud *cloud;
}
@end
@implementation Cloud

- (SKShapeNode *)initWithSize:(CGSize)size
{
    if (self)
    {
        self = [super init];
        self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)].CGPath;
        self.fillColor = [UIColor whiteColor];
        [self startMoving];
    }
        return self;
}

- (void)startMoving
{
    SKAction *moveLeft = [SKAction moveByX:-10
                                         y:0
                                  duration:1];
    
    [self runAction:[SKAction repeatActionForever:moveLeft]];
}

@end
