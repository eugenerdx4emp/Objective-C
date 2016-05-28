//
//  StudentListViewController.h
//  iosintershiptask1
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudentsService.h"
#import "DBManager.h"

@interface StudentListViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (assign) NSInteger selectedStudentId;
@property (assign) NSInteger selectedStudentSection;
@property (strong, nonatomic) Student* student;
@property (weak, nonatomic) IBOutlet UIImageView *imageStudent;

@end
