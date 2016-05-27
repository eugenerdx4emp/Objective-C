//
//  AddNewStudentViewController.h
//  iosintershiptask1
//
//  Created by eugenerdx on 31.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "StudentsService.h"
#import "GroupsService.h"



@interface StudentAddViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) Student* addStudent;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *arrayField;
@property (strong, nonatomic) IBOutlet UIImageView* imageView;
@property (assign, nonatomic) BOOL atPresent;
@property (strong, nonatomic) NSMutableData *infoData;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIImage *imageContent;
@property (weak, nonatomic) IBOutlet UIPickerView *groupsPickerView;
- (IBAction)editSectionButton:(id)sender;
- (IBAction)addSectionButton:(id)sender;
- (IBAction)deleteSectionButton:(id)sender;
- (IBAction)pickImage:(id)sender;

@end