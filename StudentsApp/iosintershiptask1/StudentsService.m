//
//  PersonListDataController.m
//  iosintership
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import "StudentsService.h"
NSString * const NotificationStudentsServiceHasHTTPRequests     = @"NotificationStudentsServiceHasHTTPRequests";
NSString * const NotificationStudentsServiceHasNoHTTPRequests   = @"NotificationStudentsServiceHasNoHTTPRequests";
NSString * const NotificationStudentsServiceStudentsListUpdated = @"NotificationStudentsServiceStudentsListUpdated";


@interface StudentsService()
{
    NSInteger requestsCount;

}
@property (strong, nonatomic) NSMutableDictionary *groupedBySectionAndSortedById;
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSArray *studentsOfflineInfo;

@end

@implementation StudentsService

#pragma mark - Singleton initialization

+ (StudentsService *)sharedService
{
    static dispatch_once_t pred;
    static StudentsService *sharedService = nil;
    dispatch_once(&pred, ^
    {
        sharedService = [[super alloc] initUniqueInstance];
    });
    return sharedService;
}

- (StudentsService *)initUniqueInstance
{
    self = [super init];
    if (self)
    {
        [self updateStudentsList];
    }
    
    return self;
}
#pragma mark Internal methods

- (void)increaseRequestsCount
{
    if (requestsCount == 0)
    {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationStudentsServiceHasHTTPRequests
                                                            object:nil];
    }
    
    requestsCount++;
}

- (void)decreaseRequestsCount
{
    requestsCount--;
    
    if (requestsCount <= 0)
    {
        requestsCount = 0;
        NSString * const NotificationStudentsServiceHasNoHTTPRequests = @"NotificationStudentsServiceHasNoHTTPRequests";
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationStudentsServiceHasNoHTTPRequests
                                                            object:nil];
    }
}

#pragma mark - External methods

- (void)updateStudentsList
{
    [self retrieveStudents];
}


#pragma mark - Student methods
- (void)studentAdd:(Student *)student
{
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/create_student.php"];

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"first_name=%@&last_name=%@&phone_number=%@&email=%@&photo=%@&section=%@", student.firstName, student.lastName, student.phone, student.email, student.imageName, student.group];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
   
    NSLog(@"group = %@", student.group);

    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationStudentsServiceStudentsListUpdated object:nil];

    [self decreaseRequestsCount];
         
     }];
    [self increaseRequestsCount];
    [dataTask resume];
    
}


- (void)studentDelete:(Student *)student
{

    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/delete_student.php"];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"id=%@", student.studentId];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
   
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
         
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationStudentsServiceStudentsListUpdated object:nil];

    [self decreaseRequestsCount];
    NSString *query;
    query = [NSString stringWithFormat:@"delete from students where id = '%@'", student.studentId];
    [self.dbManager executeQuery:query];
         
     }];
    [self increaseRequestsCount];
    [dataTask resume];
}

- (void)studentEdit:(Student *)student
{
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/update_student.php"];
    NSString *params = [NSString stringWithFormat:@"id=%@&first_name=%@&last_name=%@&phone_number=%@&email=%@&photo=%@&section=%@", student.studentId, student.firstName, student.lastName, student.phone, student.email, student.imageName, student.group];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {

    [self decreaseRequestsCount];
    NSString *query;
    query = [NSString stringWithFormat:@"update students set first_name = '%@', last_name = '%@', phone_number = '%@', email = '%@', photo = '%@', section = '%@' where id = '%@'", student.firstName, student.lastName, student.phone, student.email, student.imageName, student.group, student.studentId];
    [self.dbManager executeQuery:query];
                                          
     }];
    [self increaseRequestsCount];
    [dataTask resume];
}






#pragma mark - Loading students Methods
- (void)loadData
{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.db"];
    NSString *query = @"select * from students";
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
        NSLog(@"%@", self.arrPeopleInfo);
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"arrPeopleInfo = %@",self.arrPeopleInfo);
    self.studentsOfflineInfo = [[NSArray alloc] initWithArray:[self.dbManager studentsList]];
    NSLog(@"studentsOfflineInfo = %@",self.studentsOfflineInfo);
    NSMutableArray *array = [NSMutableArray new];
    array = [self.dbManager.studentsList copy];
}






- (void)retrieveStudents
{
    [self loadData];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject
                                                                 delegate:nil
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/studentlist/all_students.php"];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"database.db"];
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");
        [self loadData];
        [self studentsGroupedBySectionAndSortedByTrack:self.studentsOfflineInfo];
    }
    else
    {
        NSLog(@"Connected to URL://linneage.ru");
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
 {
        {
            if (data)
            {
                NSArray *studentsArray = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
                
                NSMutableArray *tempStudentsArray = [NSMutableArray new];
                NSMutableArray *tempStudentsOfflineArray = [NSMutableArray new];
                for (NSDictionary *student in studentsArray)
                {
                    NSString *studentId = [student objectForKey:@"id"];
                    NSString *firstName = [student objectForKey:@"first_name"];
                    NSString *lastName = [student objectForKey:@"last_name"];
                    NSString *email = [student objectForKey:@"email"];
                    NSString *phone = [student objectForKey:@"phone_number"];
                    NSString *createdDate = [student objectForKey:@"created_date"];
                    NSString *updatedDate = [student objectForKey:@"updated_date"];
                    NSString *imageName = [student objectForKey:@"photo"];
                    NSString *group = [student objectForKey:@"section"];
                    
                    Student *student = [Student studentWithId:studentId
                                                    firstName:firstName
                                                     lastName:lastName
                                                        email:email
                                                        phone:phone
                                                  createdDate:createdDate
                                                  updatedDate:updatedDate
                                                    imageName:imageName
                                                        image:nil
                                                        group:group];
                    
                    [tempStudentsArray addObject:student];
                    NSString *query;
                    query = [NSString stringWithFormat:@"insert or replace into students values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", studentId, firstName, lastName, email, phone, createdDate, updatedDate, imageName, group];
                    
                       Student *studentOffline = [Student studentWithId:studentId
                                                           firstName:firstName
                                                            lastName:lastName
                                                               email:email
                                                               phone:phone
                                                         createdDate:createdDate
                                                         updatedDate:updatedDate
                                                           imageName:imageName
                                                               image:nil
                                                               group:group];
                    
                    [tempStudentsOfflineArray addObject:studentOffline];

                    
                    [self.dbManager executeQuery:query];
                    
                }
                _studentsList = tempStudentsArray;
                [self studentsGroupedBySectionAndSortedByTrack:tempStudentsArray];

                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationStudentsServiceStudentsListUpdated object:nil];
            }}[self decreaseRequestsCount];
            
        }];
      [self increaseRequestsCount];
    [dataTask resume];
      [self loadData];
        }

}


#pragma mark - Service Methods
- (NSDictionary *)studentsGroupedBySectionAndSortedByTrack:(NSArray *)students
{
    
    NSSortDescriptor *byId = [NSSortDescriptor sortDescriptorWithKey:@"studentId" ascending:YES];
    NSArray *sectionName = [students valueForKeyPath:@"@distinctUnionOfObjects.group"];
     self.groupedBySectionAndSortedById = [[NSMutableDictionary alloc] init];
    for (NSString *section in sectionName) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %@",section];
        NSArray *currentStudentsId = [students filteredArrayUsingPredicate:predicate];
        NSArray *currentSectionsSortedById = [currentStudentsId sortedArrayUsingDescriptors:@[byId]];
        [self.groupedBySectionAndSortedById setObject:currentSectionsSortedById
                                               forKey:section];
        _groupedStudentBySectionAndSortedById = [self.groupedBySectionAndSortedById copy];
    }
    return _groupedStudentBySectionAndSortedById;
}


- (void)sendImageToServer:(Student *)student
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURL *url = [NSURL URLWithString:@"https://linneage.ru/phpuploadtutorial/uploader.php"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:nil];

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];


    [theRequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    

    NSData *imageData = UIImageJPEGRepresentation(student.image, 1.0);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *photo = [NSString stringWithFormat:@"Content-Disposition: attachment; name=\"userfile\"; filename=\"%@\"\r\n", student.imageName];


    [body appendData:[photo
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    
    [theRequest setHTTPBody:body];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                        
                                      }];
    [dataTask resume];

}




@end
