//
//  Section.m
//  Students App
//
//  Created by eugenerdx on 05.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "Section.h"

@implementation Section

#pragma mark - Section initialization
- (Section *)initGroupWithId:(NSString *)groupId
                         group:(NSString *)group
{
    self = [super init];
    if (self)
    {
        
        _groupId = groupId;
        _group = group;
    }
    return self;
}


+ (Section *)groupWithId:(NSString *)groupId
                   group:(NSString *)group

{
    return [[Section alloc] initGroupWithId:groupId group:group];
    
}

@end
