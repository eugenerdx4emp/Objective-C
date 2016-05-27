//
//  GroupsService.m
//  Students App
//
//  Created by eugenerdx on 07.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "GroupsService.h"

NSString * const NotificationGroupsServiceHasHTTPRequests     = @"NotificationGroupsServiceHasHTTPRequests";
NSString * const NotificationGroupsServiceHasNoHTTPRequests   = @"NotificationGroupsServiceHasNoHTTPRequests";
NSString * const NotificationGroupsServiceSectionListUpdated = @"NotificationGroupsServiceSectionListUpdated";


@interface GroupsService()
{
    NSInteger requestsCount;
}

@end

@implementation GroupsService

#pragma mark - Singleton initialization

+ (GroupsService *)sharedService
{
    static dispatch_once_t pred;
    static GroupsService *sharedService = nil;
    dispatch_once(&pred, ^
                  {
                      sharedService = [[super alloc] initUniqueInstance];
                  });
    return sharedService;
}

- (GroupsService *)initUniqueInstance
{
    self = [super init];
    if (self)
    {
        [self updateGroupsList];
    }
    
    return self;
}

#pragma mark Internal methods

- (void)increaseRequestsCount
{
    if (requestsCount == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGroupsServiceHasHTTPRequests
                                                            object:nil];
    }
    
    requestsCount++;
    NSLog(@"%ld", (long)requestsCount);
}

- (void)decreaseRequestsCount
{
    requestsCount--;
    
    if (requestsCount <= 0)
    {
        requestsCount = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGroupsServiceHasNoHTTPRequests
                                                            object:nil];
    }
    NSLog(@"%ld", (long)requestsCount);
}

#pragma mark External methods

- (void)updateGroupsList
{
    [self retrieveGroups];
}

- (void)retrieveGroups
{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/all_groups.php"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                    
                                      {
                                          if (data)
                                          {
                                              NSArray *groupsArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:kNilOptions
                                                                                                       error:nil];
                                              NSMutableArray *tempGroupsArray = [NSMutableArray new];
                                              
                                              for (NSDictionary *section in groupsArray)
                                              {
                                                  NSString *studentId = [section objectForKey:@"id"];
                                                  NSString *group = [section objectForKey:@"section"];
                                                  Section *groupObject = [Section groupWithId:studentId group:group];
                                                  [tempGroupsArray addObject:groupObject];
                                              }
                                              _groupsList = tempGroupsArray;
                                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGroupsServiceSectionListUpdated object:nil];
                                              NSLog(@"%@", tempGroupsArray);
                                             
                                           }
                                        
                                          
                                          [self decreaseRequestsCount];
                                      }];
    [self increaseRequestsCount];
    [dataTask resume];
}


#pragma mark - Sections change methods

- (void)sectiontAdd:(Section *)section
{
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/create_group.php"];
    
    NSString *params = [NSString stringWithFormat:@"section=%@", section.group];

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGroupsServiceSectionListUpdated object:nil];
                                          [self decreaseRequestsCount];
                                          
                                      }];
    [self increaseRequestsCount];
    [dataTask resume];
}



- (void)sectionDelete:(Section *)section
{
    
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/delete_section.php"];
    NSString *params = [NSString stringWithFormat:@"id=%@",section.groupId];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    
  
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGroupsServiceSectionListUpdated object:nil];
                                          [self decreaseRequestsCount];
                                          
                                      }];
    [self increaseRequestsCount];
    [dataTask resume];
}

- (void)sectionEdit:(Section *)section
{
    
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/edit_section.php"];
    NSString *params = [NSString stringWithFormat:@"id=%@&section=%@",section.groupId, section.group];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:NotificationGroupsServiceSectionListUpdated object:nil];

                                          [self decreaseRequestsCount];
                                          
                                      }];
    [self increaseRequestsCount];
    [dataTask resume];
}




@end
