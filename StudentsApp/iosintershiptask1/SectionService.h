//
//  GroupsService.h
//  Students App
//
//  Created by eugenerdx on 07.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Section.h"
#import "Network.h"

extern NSString * const NotificationGroupsServiceHasHTTPRequests;
extern NSString * const NotificationGroupsServiceHasNoHTTPRequests;
extern NSString * const NotificationGroupsServiceSectionListUpdated;
extern NSString * const NotificationGroupsServiceSectionUpdated;

@interface SectionService : Network

@property (strong, nonatomic) NSArray *groupsList;

- (void)updateSectionList;
- (void)retrieveSections;
- (void)sectiontAdd:(Section *)section;
- (void)sectionDelete:(Section *)section;
- (void)sectionEdit:(Section *)section;

+ (SectionService *)sharedService;
+ (SectionService *)alloc __attribute__((unavailable("alloc not available, call sharedService instead.")));
- (SectionService *)init  __attribute__((unavailable("init not available, call sharedService instead.")));
+ (SectionService *)new   __attribute__((unavailable("new not available, call sharedService instead.")));
@end
