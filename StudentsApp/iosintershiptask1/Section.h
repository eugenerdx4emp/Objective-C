//
//  Section.h
//  Students App
//
//  Created by eugenerdx on 05.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Section : NSObject
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *group;


+ (Section *)groupWithId:(NSString *)groupId
                      group:(NSString *)group;
@end
