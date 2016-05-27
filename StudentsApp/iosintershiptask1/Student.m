//
//  Student.m
//  iosintership
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import "Student.h"

@implementation Student

#pragma mark - Student initialization methods

- (Student *)initWithId:(NSString *)studentId
              firstName:(NSString *)firstName
               lastName:(NSString *)lastName
                  email:(NSString *)email
                  phone:(NSString *)phone
            createdDate:(NSString *)created
            updatedDate:(NSString *)updated
              imageName:(NSString *)imageName
                  image:(UIImage *)image
                  group:(NSString *) group

{
    self = [super init];
    if (self)
    {
        _studentId = studentId;
        _firstName = firstName;
        _lastName = lastName;
        _email = email;
        _phone = phone;
        _created = created;
        _updated = updated;
        _imageName = imageName;
        _image = image;
        _group = group;

    }
    
    return self;
}

+ (Student *)studentWithId:(NSString *)studentId
                 firstName:(NSString *)firstName
                  lastName:(NSString *)lastName
                     email:(NSString *)email
                     phone:(NSString *)phone
               createdDate:(NSString *)created
               updatedDate:(NSString *)updated
                 imageName:(NSString *)imageName
                     image:(UIImage *)image
                     group:(NSString *) group

{
    return [[Student alloc] initWithId:(NSString *)studentId
                             firstName:(NSString *)firstName
                              lastName:(NSString *)lastName
                                 email:(NSString *)email
                                 phone:(NSString *)phone
                           createdDate:(NSString *)created
                           updatedDate:(NSString *)updated
                             imageName:(NSString *)imageName
                                 image:(UIImage *)image
                                 group:(NSString *)group];
    
}




@end


