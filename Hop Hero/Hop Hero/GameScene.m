//
//  GameScene.m
//  Hop Hero
//
//  Created by eugenerdx on 08.06.16.
//  Copyright (c) 2016 eugenerdx. All rights reserved.
//

#import "GameScene.h"
#import "Hero.h"
#import "WorldGenerator.h"
#import "PointsLabel.h"
#import "GameData.h"

@interface GameScene()
@property BOOL isStarted;
@property BOOL isGameOver;
@end

@implementation GameScene

{
    Hero *hero;
    SKNode *world;
    WorldGenerator *generator;
}
static NSString *GAME_FONT = @"AmericanTypewritter-Bold";

- (void)didMoveToView:(SKView *)view
{
    /* Setup your scene here */
    self.anchorPoint = CGPointMake(0.5f, 0.5f);
    self.physicsWorld.contactDelegate = self;
    
    [self createContent];
}

- (void)loadScoreLabels
{
    PointsLabel *pointsLabel = [PointsLabel pointLabelWithFontNamed:GAME_FONT];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.fontSize = 60;
    pointsLabel.position = CGPointMake(-400, 200);
    [self addChild:pointsLabel];
    
    
    GameData *data = [GameData data];
    [data load];
    
    PointsLabel *highscoreLabel = [PointsLabel pointLabelWithFontNamed:GAME_FONT];
    highscoreLabel.name = @"highscoreLabel";
    highscoreLabel.fontSize = 60;
    highscoreLabel.position = CGPointMake(400, 200);
    [highscoreLabel setPoints:data.highscore];
    [self addChild:highscoreLabel];
    
    
    SKLabelNode *bestLabel = [SKLabelNode labelNodeWithFontNamed:@"GAME_FONT"];
    bestLabel.text = @"best";
    bestLabel.fontSize = 24;
    bestLabel.position = CGPointMake(0, -20);
    [highscoreLabel addChild:bestLabel];
    
}

- (void)loadClouds
{
    SKShapeNode *cloudOne = [SKShapeNode node];
    cloudOne.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 65, 140, 40)].CGPath;
    cloudOne.fillColor = [UIColor whiteColor];
    cloudOne.strokeColor = [UIColor blackColor];
    [world addChild:cloudOne];
    
    SKShapeNode *cloudTwo = [SKShapeNode node];
    cloudTwo.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-250, 45, 140, 40)].CGPath;
    cloudTwo.fillColor = [UIColor whiteColor];
    cloudTwo.strokeColor = [UIColor blackColor];
    [world addChild:cloudTwo];
}

- (void)createContent
{
    self.backgroundColor = [SKColor colorWithRed:0.54f green:0.7853f blue:1.0f alpha:0.9f];
    
    world = [SKNode node];
    [self addChild:world];
    
    generator = [WorldGenerator generatorWithWorld:world];
    [self addChild:generator];
    [generator populate];
    
    hero = [Hero hero];
    [world addChild:hero];
    
    [self loadScoreLabels];
    
    SKLabelNode *tapToBeginLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToBeginLabel.name = @"tapToBeginLabel";
    tapToBeginLabel.text = @"tap to begin";
    tapToBeginLabel.fontSize = 60.0f;
    [self addChild:tapToBeginLabel];
    [self animateWithPulse:tapToBeginLabel];
    [self loadClouds];

    
}

- (void) start
{
    self.isStarted = YES;
    [[self childNodeWithName:@"tapToBeginLabel"] removeFromParent];
    [hero start];
}

- (void) clear
{
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    [self.view presentScene:scene];
}


- (void) gameOver
{
    self.isGameOver = YES;
    [hero stop];
    
    [self runAction:[SKAction playSoundFileNamed:@"onGameOver.mp3" waitForCompletion:NO]];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    gameOverLabel.text = @"Game over";
    gameOverLabel.position = CGPointMake(0,100);
    
    
    SKLabelNode *tapToResetLabel = [SKLabelNode labelNodeWithFontNamed:GAME_FONT];
    tapToResetLabel.name = @"tapToResetLabel";
    tapToResetLabel.text = @"Tap to reset";
    tapToResetLabel.fontSize = 60.0f;
    [self addChild:tapToResetLabel];
    [self animateWithPulse:tapToResetLabel];
    
    [self updateHighScore];
}

- (void)updateHighScore
{
    PointsLabel *pointsLabel = (PointsLabel *)[self childNodeWithName:@"pointsLabel"];
    PointsLabel *highscoreLabel = (PointsLabel *)[self childNodeWithName:@"highscoreLabel"];
    if(pointsLabel.number > highscoreLabel.number)
    {
        [highscoreLabel setPoints:pointsLabel.number];
        
        GameData *data = [GameData data];
        data.highscore = pointsLabel.number;
        [data save];
    }
}

- (void)didSimulatePhysics
{
    [self centerOnNode:hero];
    [self handlePoints];
    [self handleGeneration];
    [self handleCleanUp];
    
}

- (void)handlePoints
{
    [world enumerateChildNodesWithName:@"obstacle"
                            usingBlock:^(SKNode * node, BOOL * stop) {
                                if(node.position.x < hero.position.x)
                                {
                                    PointsLabel *pointsLabel = (PointsLabel *)[self childNodeWithName:@"pointsLabel"];
                                    [pointsLabel increment];
                                }
                            }];
}

- (void)handleGeneration
{
    [world enumerateChildNodesWithName:@"obstacle"
                           usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
                               if(node.position.x < hero.position.x)
                               {
                                   node.name = @"obstacle_cancelled";
                                   [generator generate];
                               }
                           }];
}

- (void)handleCleanUp
{
    [world enumerateChildNodesWithName:@"ground" usingBlock:
     ^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
         if(node.position.x < hero.position.x - self.frame.size.width / 2 - node.frame.size.width / 2)
         {
             [node removeFromParent];
         }
     }];
    
    [world enumerateChildNodesWithName:@"obstacle_cancelled"
                            usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
                                if(node.position.x < hero.position.x - self.frame.size.width / 2 - node.frame.size.width /2 ) {
                                    [node removeFromParent];
                                }
                            }];
}

- (void)centerOnNode:(SKNode *)node
{
    CGPoint positionInScene = [self convertPoint:node.position fromNode:node.parent];
    world.position = CGPointMake(world.position.x - positionInScene.x, world.position.y);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    /* Called when a touch begins */
    if(!self.isStarted)
        [self start];
    else if (self.isGameOver)
        [self clear];
    else
        [hero jump];
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if([contact.bodyA.node.name isEqualToString:@"ground"] || [contact.bodyB.node.name isEqualToString:@"ground"]){
    [hero land];
    } else {
    [self gameOver];

    }
}

- (void)animateWithPulse:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0f duration:0.3f];
    SKAction *appear = [SKAction fadeAlphaTo:1.0f duration:0.3f];
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    [node runAction:[SKAction repeatActionForever:pulse]];

}

@end
