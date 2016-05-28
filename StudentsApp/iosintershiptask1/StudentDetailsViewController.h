//
//  StudentDetailsViewController.h
//  iosintershiptask1
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "StudentsService.h"
#import "ImagesService.h"

@interface StudentDetailsViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageStudent;
@property (weak, nonatomic) IBOutlet UIPickerView *groupsPickerView;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (strong, nonatomic) Student* student;
@property (assign) NSInteger selectedStudentId;


- (IBAction)editButton:(id)sender;
- (IBAction)changePhotoButton:(id)sender;
@end
