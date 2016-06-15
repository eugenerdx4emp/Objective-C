//
//  GameData.m
//  Hop Hero
//
//  Created by eugenerdx on 09.06.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "GameData.h"
@interface GameData()
@property NSString *filePath;
@end
@implementation GameData
+ (id)data
{
    GameData *data = [GameData new];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fileName = @"archieve.data";
    data.filePath = [path stringByAppendingString:fileName];
    return data;
}

- (void)save
{
    NSNumber *highScoreObject = [NSNumber numberWithInteger:self.highscore];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highScoreObject];
    [data writeToFile:self.filePath atomically:YES];
}

- (void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.filePath];
    NSNumber *highscoreObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    self.highscore = highscoreObject.intValue;
}
@end
