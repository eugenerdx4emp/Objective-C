//
//  Section.h
//  Students App
//
//  Created by eugenerdx on 05.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Section : NSObject
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *section;


+ (Section *)sectionWithId:(NSString *)sectionId
                      section:(NSString *)section;
@end
