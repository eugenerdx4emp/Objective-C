//
//  GroupsService.m
//  Students App
//
//  Created by eugenerdx on 07.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "SectionService.h"

NSString * const NotificationGroupsServiceHasHTTPRequests     = @"NotificationGroupsServiceHasHTTPRequests";
NSString * const NotificationGroupsServiceHasNoHTTPRequests   = @"NotificationGroupsServiceHasNoHTTPRequests";
NSString * const NotificationGroupsServiceSectionListUpdated = @"NotificationGroupsServiceSectionListUpdated";


@interface SectionService()
{
    NSInteger requestsCount;
}

@end

@implementation SectionService

#pragma mark - Singleton initialization

+ (SectionService *)sharedService
{
    static dispatch_once_t pred;
    static SectionService *sharedService = nil;
    dispatch_once(&pred, ^
                  {
                      sharedService = [[super alloc] initUniqueInstance];
                  });
    return sharedService;
}

- (SectionService *)initUniqueInstance
{
    self = [super init];
    if (self)
    {
        [self updateSectionList];
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

- (void)updateSectionList
{
    [self retrieveSections];
}

- (void)retrieveSections
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
                                                  NSString *sectionId = [section objectForKey:@"id"];
                                                  NSString *group = [section objectForKey:@"section"];
                                                  Section *groupObject = [Section sectionWithId:sectionId section:group];
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
    
    NSString *params = [NSString stringWithFormat:@"section=%@", section.section];

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
    NSString *params = [NSString stringWithFormat:@"id=%@",section.sectionId];
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
    NSString *params = [NSString stringWithFormat:@"id=%@&section=%@",section.sectionId, section.section];
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
