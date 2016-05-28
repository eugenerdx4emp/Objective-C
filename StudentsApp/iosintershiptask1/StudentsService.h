//
//  StudentDataStorage.h
//  iosintership
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "Network.h"
#import "StudentAddViewController.h"
#import "Section.h"
#import "SectionService.h"
#import "DBManager.h"

extern NSString * const NotificationStudentsServiceHasHTTPRequests;
extern NSString * const NotificationStudentsServiceHasNoHTTPRequests;
extern NSString * const NotificationStudentsServiceStudentsListUpdated;
extern NSString * const NotificationStudentsServiceStudentUpdated;

@interface StudentsService : Network

@property (strong, nonatomic, readonly) NSArray *studentsList;
@property (strong, nonatomic, readonly) NSDictionary *groupedStudentBySectionAndSortedById;
@property (strong, nonatomic) NSMutableData *infoData;


- (void)updateStudentsList;
- (void)studentAdd:(Student *)student;
- (void)studentDelete:(Student *)student;
- (void)studentEdit:(Student *)student;
- (void)sendImageToServer:(Student *)student;
- (NSDictionary *)studentsGroupedBySectionAndSortedByTrack:(NSArray *)students;

+ (StudentsService *)sharedService;

+ (StudentsService *)alloc __attribute__((unavailable("alloc not available, call sharedService instead.")));
- (StudentsService *)init  __attribute__((unavailable("init not available, call sharedService instead.")));
+ (StudentsService *)new   __attribute__((unavailable("new not available, call sharedService instead.")));

@end
