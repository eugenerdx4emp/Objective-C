//
//  UIColor+Wall.m
//  Nimble Ninja
//
//  Created by eugenerdx on 15.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "UIColor+Wall.h"

@implementation UIColor (Wall)

+ (UIColor *)getRandomColor
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
