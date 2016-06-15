//
//  GameScene.m
//  Nimble Ninja
//
//  Created by eugenerdx on 08.06.16.
//  Copyright (c) 2016 eugenerdx. All rights reserved.
//

#import "GameScene.h"
#import "Hero.h"
#import "WallGenerator.h"
#import "PointsLabel.h"
#import "MovingGround.h"
#import "CloudGenerator.h"
#import "Constants.h"
#import "Wall.h"

@interface GameScene()
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation GameScene

{
    Hero *hero;
    SKNode *world;
    MovingGround *movingGround;
    WallGenerator *wallGenerator;
    CloudGenerator *cloudGenerator;
    BOOL isStarted;
    BOOL isGameOver;
    BOOL isJumping;

}

- (void)didMoveToView:(SKView *)view
{
    self.physicsWorld.contactDelegate = self;
    [self createContent];
    [self addMovingGround];
    [self addHero];
    [self addTapToStartLabel];
    [self addWallGenerator];
    [self addCloudGenerator];
    [self loadScoreLabels];
    [self loadHighScore];
}

- (void)createContent
{
    self.backgroundColor = [SKColor colorWithRed:0.54f
                                           green:0.7853f
                                            blue:1.0f
                                           alpha:0.9f];
    
    world = [SKNode node];
    [self addChild:world];
    
}

- (void)addMovingGround
{
    movingGround = [[MovingGround alloc]initWithSize:CGSizeMake(self.frame.size.width * 2, kMLGroundHeight)];
    movingGround.position = CGPointMake(0, self.scene.frame.size.height / 2);
    movingGround.name = @"ground";
    [world addChild:movingGround];
}

- (void)addHero
{
    hero = [[Hero alloc]init];
    hero.position = CGPointMake(70, movingGround.position.y + movingGround.frame.size.height / 2 + hero.frame.size.height/2);
    hero.name = @"hero";
    [world addChild:hero];
    [hero breathe];
}

-(void)playBackGroundSound
{
    NSError *error;
    NSURL *soundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Run" ofType:@"wav"]];

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [self.player setVolume:1.0f];
    [self.player prepareToPlay];
    
    self.player.numberOfLoops = -1;
    SKAction *playAction = [SKAction runBlock:^{
        
        [self.player play];
    }];
    [self runAction:playAction];
}
- (void) start
{
    isStarted = YES;
    
    PointsLabel *tapToStartLabel = (PointsLabel *)[self childNodeWithName:@"tapToStartLabel"];
    [tapToStartLabel removeFromParent];


    [self playBackGroundSound];
    [hero stop];
    [hero startRunning];
    [movingGround start];
    
    [wallGenerator startGeneraTingWallsEvery:1];

}

- (void)addTapToStartLabel
{
    SKLabelNode *tapToStartLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tapToStartLabel.text = @"Tap to start!";
    tapToStartLabel.name = @"tapToStartLabel";
    tapToStartLabel.position = CGPointMake(500,500);
    tapToStartLabel.fontColor = [UIColor blackColor];
    tapToStartLabel.fontSize = 40.0f;
    [self addChild:tapToStartLabel];
    [self blinkAnimation:tapToStartLabel];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
 }
-(void)heroJump
{
    [hero jump];
}

-(void)handleLongPress
{
        [hero jump];

}

-(void)handleTap
{
    //Here you can use translation to detect what button touched with gesture
    if(isGameOver)
    {
        [self restart];
    }
    else if (!isStarted)
    {
        [self start];
        
    }
    else
    {
        [hero flip];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tapGestureRecognizer];

}

- (void)addCloudGenerator
{
    
    cloudGenerator = [[CloudGenerator alloc] init];
    
    cloudGenerator = [CloudGenerator spriteNodeWithColor:[UIColor clearColor]
                                                    size: self.view.frame.size];
    
    cloudGenerator.position = self.view.center;
    [world addChild:cloudGenerator];
    [cloudGenerator populate:20];
    [cloudGenerator startGeneratingWithSpawnTime:5];
}

- (void)addWallGenerator
{
    wallGenerator = [[WallGenerator alloc]init];
    
    wallGenerator = [WallGenerator spriteNodeWithColor:[UIColor clearColor]
                                                  size:self.view.frame.size];
    
    wallGenerator.position = CGPointMake(self.frame.size.width, self.frame.size.height / 2);
    wallGenerator.name = @"wall";
    [world addChild:wallGenerator];
}



- (void) gameOver
{
    
    isGameOver = YES;

    
  
    [self.player stop];
    SKAction *playRunningSound = [SKAction playSoundFileNamed:@"onGameOver" waitForCompletion:YES];
    [self runAction:playRunningSound];
    [hero fall];
    [hero stop];
    [wallGenerator stopWalls];
    [movingGround stop];

 

    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    gameOverLabel.text = @"Game Over!";
    gameOverLabel.fontSize = 40.0f;
    gameOverLabel.fontColor = [UIColor blackColor];
    gameOverLabel.position = CGPointMake(500,500);
    [self addChild:gameOverLabel];



    [self blinkAnimation:gameOverLabel];

    PointsLabel *pointsLabel = (PointsLabel *)[self childNodeWithName:@"pointsLabel"];
    PointsLabel *highScoreLabel = (PointsLabel *)[self childNodeWithName:@"highScoreLabel"];

    
    if(highScoreLabel.number < pointsLabel.number)
    {
        [highScoreLabel setPoints:pointsLabel.number];
        NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
        [defauls setInteger:highScoreLabel.number forKey:@"highscore"];
    }
}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if([contact.bodyA.node.name isEqualToString:@"ground"] || [contact.bodyB.node.name isEqualToString:@"ground"])
    {
        [hero land];
    }else{
        [self gameOver];
    }
  
}

- (void)didSimulatePhysics
{
    
}

- (void)restart
{
    [cloudGenerator stopGenerating];
    GameScene *scene = [[GameScene alloc] initWithSize:self.frame.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self.view presentScene:scene];
    
}

- (void)update:(CFTimeInterval)currentTime
{
    if([WallGenerator wallTrackers].count > 0)
    {
        
        Wall *wall = [[WallGenerator wallTrackers] objectAtIndex:0];
        CGPoint wallLocation = [wallGenerator convertPoint:wall.position
                                                    toNode:self];
        
        if(wallLocation.x < hero.position.x)
        {
            [[WallGenerator wallTrackers] removeObjectAtIndex:0];
            PointsLabel *pointsLabel = (PointsLabel *)[self childNodeWithName:@"pointsLabel"];
            [pointsLabel increment];
        }
    }
}


- (void)loadScoreLabels
{
    PointsLabel *pointsLabel = [[PointsLabel alloc]initWithNum:0];
    pointsLabel.name = @"pointsLabel";
    pointsLabel.fontSize = 30.0f;
    pointsLabel.position = CGPointMake(60, 600);
    [self addChild:pointsLabel];
    
    
    PointsLabel *highscoreLabel = [[PointsLabel alloc]initWithNum:0];
    highscoreLabel.name = @"highScoreLabel";
    highscoreLabel.fontSize = 30.0f;
    highscoreLabel.position = CGPointMake(950, 600);
    [self addChild:highscoreLabel];
    
    
    SKLabelNode *bestLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    bestLabel.text = @"best";
    bestLabel.fontSize = 24;
    bestLabel.position = CGPointMake(0, -30);
    [highscoreLabel addChild:bestLabel];
    
}

- (void)loadHighScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    PointsLabel *highscoreLabel = (PointsLabel *)[self childNodeWithName:@"highScoreLabel"];
    [highscoreLabel setPoints:[defaults integerForKey:@"highscore"]];
}


- (void)blinkAnimation:(SKNode *)node
{
    SKAction *disappear = [SKAction fadeAlphaTo:0.0f
                                       duration:0.4f];
    
    SKAction *appear = [SKAction fadeAlphaTo:1.0f
                                    duration:0.4f];
    
    SKAction *pulse = [SKAction sequence:@[disappear, appear]];
    
    [node runAction:[SKAction repeatActionForever:pulse]];

}
@end
