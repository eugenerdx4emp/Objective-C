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
- (Section *)initSectionWithId:(NSString *)sectionId
                         section:(NSString *)section
{
    self = [super init];
    if (self)
    {
        
        _sectionId = sectionId;
        _section = section;
    }
    return self;
}


+ (Section *)sectionWithId:(NSString *)sectionId
                   section:(NSString *)section

{
    return [[Section alloc] initSectionWithId:sectionId section:section];
    
}

@end
