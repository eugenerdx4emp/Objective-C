//
//  AddNewStudentViewController.m
//  iosintershiptask1
//
//  Created by eugenerdx on 31.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "StudentAddViewController.h"


typedef enum
{
    fieldsName,
    fieldsLastName,
    fieldsEmail,
    fieldsPhone
} Fields;

@interface StudentAddViewController ()
{
    NSString *selectedPickerRow;
    NSString *selectedPickerName;

}
@end

@implementation StudentAddViewController

#pragma mark - Load View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"200"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPicker)
                                                 name:NotificationGroupsServiceSectionListUpdated
                                               object:nil];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleGroupsServiceHasNoRequest)
                                                 name:NotificationGroupsServiceHasNoHTTPRequests
                                               object:nil];

    
    
    [NSTimer scheduledTimerWithTimeInterval:300.0f target:self selector:@selector(checkInternetConnection) userInfo:nil repeats:YES];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle notifications
- (void)handleGroupsServiceHasNoRequest
{

    [self.groupsPickerView reloadAllComponents];
}
- (void)refreshPicker
{
    [[SectionService sharedService] updateSectionList];
    [self.groupsPickerView reloadAllComponents];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [[SectionService sharedService].groupsList copy];
    Section *firstSection = [array objectAtIndex:0];
    if(selectedPickerRow == nil){
        
        selectedPickerRow = firstSection.sectionId;
    }
    
}

#pragma mark - Service Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"saveSegue"])
    {
     
        UIImage* image = self.imageContent;
        NSInteger random = arc4random()%1000;
        self.imageName = [NSString stringWithFormat:@"photo%@%ld.jpg", [self.firstNameTextField text], (long)random];
    
        [[StudentsService sharedService] studentAdd:[Student studentWithId:nil
                                                                 firstName:[self.firstNameTextField text]
                                                                  lastName:[self.lastNameTextField text]
                                                                     email:[self.emailTextField text]
                                                                     phone:[self.phoneTextField text]
                                                               createdDate:nil updatedDate:nil
                                                                 imageName:self.imageName
                                                                     image:image
                                                                     group:selectedPickerRow]];
        
        [[StudentsService sharedService] sendImageToServer:[Student studentWithId:nil
                                                                        firstName:nil
                                                                         lastName:nil
                                                                            email:nil
                                                                            phone:nil
                                                                      createdDate:nil
                                                                      updatedDate:nil
                                                                        imageName:self.imageName
                                                                            image:image
                                                                            group:selectedPickerRow]];
        
        
         NSLog(@"%@ %@ %@ %@", selectedPickerRow, selectedPickerRow, selectedPickerRow, selectedPickerRow);
       
    }
    
}




#pragma mark UIImagePickerControllerDelegate
- (IBAction) pickImage:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES
                     completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    self.imageContent =  image;
    NSLog(@"%@", self.imageContent);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.firstNameTextField isFirstResponder])
    {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if ([self.lastNameTextField isFirstResponder])
    {
        [self.emailTextField becomeFirstResponder];
    }
    else if ([self.emailTextField isFirstResponder])
    {
        [self.phoneTextField becomeFirstResponder];
    }
    else if ([self.phoneTextField isFirstResponder])
    {
        [self.phoneTextField resignFirstResponder];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    switch (textField.tag)
    {
        case fieldsName:
            [self scriptFirstNameField:textField
         shouldChangeCharactersInRange:range
                     replacementString:string];
            return NO;
            break;
        case fieldsLastName:
            [self scriptLastNameField:textField
        shouldChangeCharactersInRange:range
                    replacementString:string];
            return NO;
            break;
        case fieldsPhone:
            [self scriptPhoneField:textField
     shouldChangeCharactersInRange:range
                 replacementString:string];
            return NO;
            break;
        case fieldsEmail:
            [self scriptEmailField:textField
     shouldChangeCharactersInRange:range
                 replacementString:string];
            return NO;
            break;
    }
    
    return YES;
    
    
}

#pragma mark - Methods formating textFields



- (BOOL)scriptEmailField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *validation = [NSCharacterSet characterSetWithCharactersInString:@"!~!#$%^,/|&*()<>=+{}][:;'\" \\"];
    NSArray * components = [string componentsSeparatedByCharactersInSet:validation];
    
    if ([components count] > 1)
    {
        return NO;
    }
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:string];
    
    if (([resultString rangeOfString:@"@"].length) < 1)
    {
        self.atPresent = NO;
    }
    if ([resultString length] < 2 && [string isEqualToString:@"@"])
    
    {
        
        return NO;
    }
    
    if (self.atPresent && [string isEqualToString:@"@"])
    {
        return NO;
    }
    
    if ([string isEqualToString:@"@"])
    {
        self.atPresent = YES;
    }
    textField.text = resultString;
    return NO;
    
}


- (BOOL)scriptFirstNameField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
           replacementString:(NSString *)string
{
    
    NSCharacterSet *validation = [NSCharacterSet characterSetWithCharactersInString:@"!~!#$%^,/|&*()<>=+{}][:;1234567890'\" \\"];
    NSArray * components = [string componentsSeparatedByCharactersInSet:validation];
    
    if ([components count] > 1)
    {
        return NO;
        
    }
    else
    {
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        textField.text = resultString;
        return YES;
        
    }
}

- (BOOL)scriptLastNameField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
          replacementString:(NSString *)string
{
    NSCharacterSet *validation = [NSCharacterSet characterSetWithCharactersInString:@"!~!#$%^,/|&*()<>=+{}][:;1234567890'\" \\"];
    NSArray * components = [string componentsSeparatedByCharactersInSet:validation];
    
    if ([components count] > 1)
    {
        return NO;
        
    }
    else
    {
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        textField.text = resultString;
        
        return YES;
        
    }
}



- (BOOL) scriptPhoneField: (UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string
{
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    if ([components count] > 1)
    {
        return NO;
    }
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"new string = %@", newString);
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    newString = [validComponents componentsJoinedByString:@""];
    NSLog(@"new string fixed = %@", newString);
    
    NSMutableString* resultString = [NSMutableString string];
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    if ([newString length]> localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength)
    {
        return NO;
    }
    
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0)
    {
        NSString* number= [newString substringFromIndex:(int)[newString length]-localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length]>3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    if ([newString length] > localNumberMaxLength )
    {
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        NSString* area= [newString substringWithRange:areaRange];
        area = [NSString stringWithFormat:@"(%@)", area];
        [resultString insertString:area atIndex:0];
    }
    if ([newString length] > localNumberMaxLength +areaCodeMaxLength )
    {
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        countryCode = [NSString stringWithFormat:@"+%@", countryCode];
        [resultString insertString:countryCode atIndex:0];
    }
    textField.text = resultString;
    return  NO;
    
}


#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSLog(@"count = %lu", (unsigned long)[[SectionService sharedService].groupsList count]);
    return [[SectionService sharedService].groupsList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [[SectionService sharedService].groupsList copy];
    NSInteger i;
   
    for(i = 0; i < [array count]; i++)
    {
        Section *section = [array objectAtIndex:i];

        NSString *string = [NSString stringWithFormat:@"%@",  section.section];
    if(row == i)
        {
            return string;

        }
        
    }
    return @"";
}



- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow: (NSInteger)row
       inComponent:(NSInteger)component
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [[SectionService sharedService].groupsList copy];
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    Section *section = [array objectAtIndex:selectedRow];
    selectedPickerRow=[NSString stringWithFormat:@"%@", section.sectionId];
    selectedPickerName=[NSString stringWithFormat:@"%@", section.section];

    NSLog(@"%@", selectedPickerRow);
}


#pragma mark - IBActions

- (IBAction)deleteSectionButton:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    array = [[SectionService sharedService].groupsList copy];
    Section *firstSection = [array objectAtIndex:0];
    if(selectedPickerRow == nil)
    {
        selectedPickerRow = firstSection.sectionId;
    }
    
    [[SectionService sharedService] sectionDelete:[Section sectionWithId:selectedPickerRow
                                                                section:nil]];

}


- (IBAction)editSectionButton:(id)sender
{
    NSString *alertTitle = @"Please edit a group";
    NSString *alertMessage = @"Please enter name";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         
         NSMutableArray *array = [[NSMutableArray alloc] init];
         array = [[SectionService sharedService].groupsList copy];
         
         Section *firstSection = [array objectAtIndex:0];
         if(selectedPickerName == nil){
             
             selectedPickerName = firstSection.section;
             textField.text = selectedPickerName;
             textField.secureTextEntry = NO;
         }
         
         textField.text = selectedPickerName;
         textField.secureTextEntry = NO;
         
         
     }];
    
    
    NSString *cancel = @"Cancel";
    NSString *ok = @"Ok";
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   UITextField *newSectionName = alertController.textFields.firstObject;
                                   NSLog(@"OK action");
                                   NSLog(@"textfield value: %@",newSectionName.text);
                                   NSString *text = newSectionName.text;
                                   NSLog(@"%@", text);
                                   [[SectionService sharedService] sectionEdit:[Section sectionWithId:selectedPickerRow
                                                                                             section:text]];
                                   
                               }];
    
    okAction.enabled = YES;
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    

}

- (IBAction)addSectionButton:(id)sender
{
    
    NSString *alertTitle = @"Create a new group";
    NSString *alertMessage = @"Please enter name";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"Enter a name here";
         textField.secureTextEntry = NO;
         
         
     }];
    
    NSString *cancel = @"Cancel";
    NSString *ok = @"Ok";
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   UITextField *newSectionName = alertController.textFields.firstObject;
                                   NSLog(@"OK action");
                                   NSLog(@"textfield value: %@",newSectionName.text);
                                   NSString *text = newSectionName.text;
                                   [[SectionService sharedService] sectiontAdd:[Section sectionWithId:nil
                                                                                             section:text]];
                                   
                               }];
    
    okAction.enabled = YES;
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    

}
- (void)AddSecton
{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)closeAlertview
{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (void)checkInternetConnection
{
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        [self checkInternetConnectionAlertView];
    }
    if([[[Network alloc]init] connectedToInternet] == YES)
    {
        NSLog(@"Connected to server");
        [[StudentsService sharedService] updateStudentsList];
        
    }
}


- (void) checkInternetConnectionAlertView
{
    
    NSString *alertTitle = @"The main database is disconnected";
    NSString *alertMessage = @"The application running in offline mode. You can't editing the tableview. You can only read information.";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                             message:alertMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    NSString *cancel = @"Try to connect";
    NSString *ok = @"OK";
    UIAlertAction *tryingToConnect = [UIAlertAction actionWithTitle:cancel
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction *action)
                                      {
                                          NSLog(@"trying to connect action");
                                          
                                          if([[[Network alloc]init] connectedToInternet] == NO)
                                          {
                                              [self checkInternetConnectionAlertView];
                                          }
                                          else
                                          {
                                              [[StudentsService sharedService] updateStudentsList];
                                              [self refreshPicker];
                                              [self dismissViewControllerAnimated:YES
                                                                       completion:nil];
                                          }
                                          
                                          
                                      }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                                   
                                   
                               }];
    
    okAction.enabled = YES;
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    
    [alertController addAction:tryingToConnect];
    [alertController addAction:okAction];
    
}


@end
