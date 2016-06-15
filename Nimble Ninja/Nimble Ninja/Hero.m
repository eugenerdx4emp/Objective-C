//
//  Hero.m
//  Nimble Ninja
//
//  Created by eugenerdx on 08.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "Hero.h"
#import "Constants.h"
@interface Hero ()
{
    SKSpriteNode  *body;
    SKSpriteNode *arm;
    SKSpriteNode *leftFoot;
    SKSpriteNode *rightFoot;
    BOOL isJumping;
    BOOL isUpsideDown;
}
@end

@implementation Hero

- (instancetype)init
{
    CGSize size = CGSizeMake(32, 44);

    self = [super initWithTexture:nil
                            color:[UIColor clearColor]
                             size:size];
    
    if (self)
    {
        [self hero];
        [self loadPhysicsBodyWith:size];

    }
    return self;
}

- (void)hero
{
    

    body = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor]
                                        size:CGSizeMake(self.frame.size.width, 40)];
    
    body.position = CGPointMake(0, 2);
    [self addChild:body];
    
    UIColor *skinColor = [UIColor colorWithRed:207.0/255.0
                                         green:193.0/255.0
                                          blue:168.0/255.0
                                         alpha:1.0];
    
    SKSpriteNode* face = [SKSpriteNode spriteNodeWithColor:skinColor
                                                     size:CGSizeMake(self.frame.size.width, 12)];
    
    face.position = CGPointMake(0, 6);
    [body addChild:face];
    
    UIColor *eyeColor = [UIColor whiteColor];
    
    SKSpriteNode *leftEye    = [SKSpriteNode spriteNodeWithColor:eyeColor
                                                            size:CGSizeMake(6,6)];
    SKSpriteNode *rightEye   = [SKSpriteNode spriteNodeWithColor:eyeColor
                                                            size:CGSizeMake(6,6)];
    SKSpriteNode *leftPupil  = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor]
                                                            size:CGSizeMake(3, 3)];
    SKSpriteNode *rightPupil = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor]
                                                            size:CGSizeMake(3, 3)];
    
    
    leftPupil.position = CGPointMake(2, 2);
    rightPupil.position = CGPointMake(2, 2);

    [leftEye addChild:leftPupil];
    [rightEye addChild:rightPupil];
    leftEye.position = CGPointMake(-4, 0);
    [face addChild:leftEye];
    [face addChild:rightEye];
    
    rightEye.position = CGPointMake(14, 0);
    
    SKSpriteNode *leftEyeBrow = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor]
                                                             size:CGSizeMake(11, 1)];
    leftEyeBrow.position = CGPointMake(-1, leftEye.size.height/2);
    [leftEye addChild:leftEyeBrow];
    
    SKSpriteNode *rightEyeBrow = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor]
                                                              size:CGSizeMake(11, 1)];
    
    rightEyeBrow.position = CGPointMake(-1, rightEye.size.height/2);
    [rightEye addChild:rightEyeBrow];

    UIColor *armColor = [UIColor colorWithRed:46/255
                                        green: 46/255
                                         blue: 46/255
                                        alpha: 1.0];
    
    arm = [SKSpriteNode spriteNodeWithColor:armColor
                                       size:CGSizeMake(8, 14)];
    
    arm.anchorPoint = CGPointMake(0.5f,0.9f);
    arm.position = CGPointMake(-10, -7);
    [body addChild:arm];
    
    SKSpriteNode *hand = [SKSpriteNode spriteNodeWithColor:skinColor
                                                      size:CGSizeMake(arm.size.width,5)];
    
    hand.position = CGPointMake(0, -arm.size.height*0.9 + hand.size.height / 2);
    [arm addChild:hand];
    
    leftFoot = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor]
                                            size:CGSizeMake(6, 4)];
    
    leftFoot.position = CGPointMake(-6, -self.size.height/2 + leftFoot.size.height / 2);
    [self addChild:leftFoot];
    
    rightFoot = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(6, 4)];
    rightFoot.position = CGPointMake(8, -self.size.height/2 + leftFoot.size.height / 2);
    [self addChild:rightFoot];

}

-(void)loadPhysicsBodyWith:(CGSize)size
{
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    self.physicsBody.categoryBitMask = heroCategory;
    self.physicsBody.contactTestBitMask = wallCategory | groundCategory;
    self.physicsBody.affectedByGravity = NO;
    
}


- (void)flip
{
    SKAction *playRunningSound = [SKAction playSoundFileNamed:@"onJump" waitForCompletion:YES];
    
    
    [self runAction:playRunningSound];
    
    self.physicsBody.affectedByGravity = NO;
    isUpsideDown = !isUpsideDown;
    CGFloat scale;
    if(isUpsideDown)
    {
        if(!isJumping)
        {
            
        scale = -1.0f;
            self.physicsBody.affectedByGravity = NO;

        }
    }
    else
    {
        scale = 1.0f;
    }
    
    SKAction *translate = [SKAction moveByX:0 y:scale*(body.size.height + kMLGroundHeight)
                                   duration:0.1];
    
    SKAction *flip = [SKAction scaleYTo:scale
                               duration:0.1];
    [self runAction:translate];
    [self runAction:flip];
    
}

- (void)land
{
    self.physicsBody.affectedByGravity = YES;

    isJumping = NO;
}

- (void)jump
{
    if(!isJumping)
    {


    if(!isUpsideDown)
        {
        isJumping = YES;
        [self.physicsBody applyImpulse:CGVectorMake(0, 50) atPoint:self.position];
        [self runAction:([SKAction playSoundFileNamed:@"onJump.wav" waitForCompletion:NO])];
        self.physicsBody.affectedByGravity = YES;

        }
    }
}

- (void)fall
{
        self.physicsBody.affectedByGravity = YES;
        [self.physicsBody applyImpulse:CGVectorMake(-5, 30)];
    
        SKAction *rotateBack = [SKAction rotateByAngle:(M_PI / 2)
                                              duration:0.4];
        [self runAction:rotateBack];
}

- (void)startRunning
{
        SKAction *rotateBack = [SKAction rotateByAngle:-M_PI_2
                                              duration:0.1];


        [arm runAction:rotateBack];
        [self performOneRunCycle];
}



- (void)performOneRunCycle
{
        SKAction *up = [SKAction moveByX:0
                                       y:2
                                duration:0.05];
    
        SKAction *down = [SKAction moveByX:0
                                         y:-2
                                  duration:0.05];
    
   

        [leftFoot runAction:up
                 completion:^
    {
            [leftFoot runAction:down];
            [rightFoot runAction:up completion:^
        {
                [rightFoot runAction:down completion:^
            {
                    [self performOneRunCycle];
                }];
            }];
        }];
}


- (void)breathe
{
    SKAction *breatheOut = [SKAction moveByX:0
                                           y:-4
                                    duration:1];
    
    SKAction *breatheIn = [SKAction moveByX:0
                                          y:4
                                   duration:1];
    
    NSMutableArray *sequence = [NSMutableArray new];
    
    [sequence addObject:breatheIn];
    [sequence addObject:breatheOut];
    
    SKAction *breathe = [SKAction sequence:sequence];
    [body runAction:[SKAction repeatActionForever:breathe]];
    
    
}

- (void)stop
{
    [body removeAllActions];
    [leftFoot removeAllActions];
    [rightFoot removeAllActions];
}

@end
