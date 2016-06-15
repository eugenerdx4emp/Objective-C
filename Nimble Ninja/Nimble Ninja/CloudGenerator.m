//
//  CloudGenerator.m
//  Nimble Ninja
//
//  Created by eugenerdx on 11.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//



#import "CloudGenerator.h"
#import "Cloud.h"

static const CGFloat CLOUD_WIDTH = 125.0f;
static const CGFloat CLOUD_HEIGHT = 55.0f;

@interface CloudGenerator()
{
    NSTimer* generationTimer;
    Cloud* cloud;
}
@end

@implementation CloudGenerator
- (void)populate:(NSInteger)num
{
    for(int i =0; i < num; i++)
    {
        cloud = [[Cloud alloc]initWithSize:CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT)];
        CGFloat x = arc4random_uniform(self.scene.size.width) - self.scene.size.width/2;
        CGFloat y = arc4random_uniform(self.scene.size.height) - self.scene.size.height/2;
        cloud.position = CGPointMake(x, y);
        cloud.zPosition = -1;
        [self addChild:cloud];
    }
}

- (void)startGeneratingWithSpawnTime:(NSTimeInterval)seconds
{
    generationTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                       target:self
                                                     selector:@selector(generateCloud)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void)stopGenerating
{
    [generationTimer invalidate];
}

- (void)generateCloud
{
    CGFloat x = self.size.width / 2 + CLOUD_WIDTH / 2;
    CGFloat y = arc4random_uniform(self.scene.size.height) - self.scene.size.height/2;
    CGSize size = CGSizeMake(CLOUD_WIDTH, CLOUD_HEIGHT);
    cloud = [cloud initWithSize:size];
    cloud.position = CGPointMake(x, y);
    cloud.zPosition = -1;
    [self addChild:cloud];
}
@end
