//
//  PointsLabel.m
//  Nimble Ninja
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "PointsLabel.h"
@interface PointsLabel()
{

}
@end


@implementation PointsLabel


- (SKLabelNode *)initWithNum:(NSInteger)num
{
    self = [super init];
    if (self)
    {
        self.number = 0;
        self = [PointsLabel labelNodeWithFontNamed:@"Helvetica"];
        self.fontColor = [UIColor blackColor];
        self.fontSize = 24.0;
        self.number = num;
        self.text = [NSString stringWithFormat:@"%ld", (long)num];
    
    }
    return self;
}

- (void) increment
{
    self.number++;
    self.text = [NSString stringWithFormat:@"%li", (long)self.number];
}

- (void)setPoints:(NSInteger)points
{
    self.number = points;
    self.text = [NSString stringWithFormat:@"%li", (long)self.number];
}

- (void)reset
{
    self.number = 0;
    self.text = @"0";
}
@end
