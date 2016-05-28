//
//  StudentDetailsViewController.m
//  iosintershiptask1
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "StudentDetailsViewController.h"


@interface StudentDetailsViewController ()
{
    NSMutableArray *pickerRowId;
    NSMutableArray *pickerRowName;
    NSString *pickRowName;
    NSString *selectedPickerRow;
}
@property (weak, nonatomic) NSData * imageData;
@property (assign, nonatomic) BOOL editing;
@end
 @implementation StudentDetailsViewController

#pragma mark - Load View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"200"]];
    [self.firstNameTextField setText:[self.student firstName]];
    [self.lastNameTextField setText:[self.student lastName]];
    [self.phoneNumberTextField setText:[self.student phone]];
    [self.emailTextField setText:[self.student email]];
    NSLog(@"%d", self.editing);
    
    
    NSString *imageUrlFromServer = [NSString stringWithFormat:@"https://linneage.ru/phpuploadtutorial/upload-files/decode/%@", [self.student imageName]];
    NSURL *url = [NSURL URLWithString:imageUrlFromServer];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageStudent.image = [UIImage imageWithData:data];

    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");
    
                
                NSLog(@"This is cached");
                NSData *pngData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:[self.student imageName]]];
               // UIImage *image = [UIImage imageWithData:jpgData];
                UIImage *image = [UIImage imageWithData:pngData];
                self.imageStudent.image = image;
                
                
    }
    
    if([[[Network alloc]init] connectedToInternet] == YES)
    {
        NSLog(@"Connected to URL://linneage.ru");
            NSString *imageUrlFromServer = [NSString stringWithFormat:@"https://linneage.ru/phpuploadtutorial/upload-files/decode/%@", [self.student imageName]];
            NSURL *url = [NSURL URLWithString:imageUrlFromServer];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.imageStudent.image = [UIImage imageWithData:data];
            //UIImage *image = [[ImagesService sharedInstance] getCachedImageForKey:imageUrlFromServer];
            NSURL *imageURL = [NSURL URLWithString:imageUrlFromServer];
            UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imageURL]];
            NSData *jpgData = UIImageJPEGRepresentation(image, 1.0);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
            NSString *fileName = [NSString stringWithFormat:@"%@", [self.student imageName]];
            NSLog(@"%@", fileName);
            NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
            NSLog(@"%@", filePath);
            [jpgData writeToFile:filePath atomically:NO]; //Write the file
            NSLog(@"Caching ....");
    }
    [self.firstNameTextField setEnabled:NO];
    [self.lastNameTextField setEnabled:NO];
    [self.phoneNumberTextField setEnabled:NO];
    [self.emailTextField setEnabled:NO];
    [self.changeButton setEnabled:NO];
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                            target:self
                                            action:@selector(editButton:)];
    self.navigationItem.rightBarButtonItem = editButton;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPicker)
                                                 name:NotificationStudentsServiceStudentsListUpdated
                                               object:nil];
    
    
    [NSTimer scheduledTimerWithTimeInterval:300.0f target:self selector:@selector(checkInternetConnection) userInfo:nil repeats:YES];

}





-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}




#pragma mark - IBAction

- (IBAction)editButton:(UIBarButtonItem *)sender
{
    
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");
        [self checkInternetConnectionAlertView];
    }
    else
    {
        NSLog(@"Connected to URL://linneage.ru");
        UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
        item = UIBarButtonSystemItemEdit;
        NSString *str = [NSString stringWithFormat:@"%@", [self.student group]];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        array = [[SectionService sharedService].groupsList copy];
        pickerRowName = [[NSMutableArray alloc]init];
        pickerRowId = [[NSMutableArray alloc]init];
        if(self.editing == NO)
        {
            self.editing = YES;
            item = UIBarButtonSystemItemDone;
            [self.firstNameTextField setEnabled:YES];
            [self.lastNameTextField setEnabled:YES];
            [self.phoneNumberTextField setEnabled:YES];
            [self.emailTextField setEnabled:YES];
            [self.changeButton setEnabled:YES];
            [self.groupsPickerView reloadAllComponents];
            NSInteger i;
            for(i = 0; i < [array count]; i++)
            {
                Section *section = [array objectAtIndex:i];
                NSString *stringWithName = [NSString stringWithFormat:@"%@",  section.section];
                NSString *stringWithId = [NSString stringWithFormat:@"%@", section.sectionId];
                [pickerRowName addObject:stringWithName];
                [pickerRowId addObject:stringWithId];
            }
            NSUInteger index = [pickerRowName indexOfObjectPassingTest:
                                ^(id obj, NSUInteger idx, BOOL *stop) {
                                    return [obj hasPrefix:str];
                                }];
            NSLog(@"index: %lu", (unsigned long)index);
            [self.groupsPickerView selectRow:index
                                 inComponent:0
                                    animated:YES];
            NSLog(@"%d", self.editing);
        }
        else if(self.editing == YES)
        {
            self.editing = NO;
            item = UIBarButtonSystemItemEdit;
            [self.firstNameTextField setEnabled:NO];
            [self.lastNameTextField setEnabled:NO];
            [self.phoneNumberTextField setEnabled:NO];
            [self.emailTextField setEnabled:NO];
            [self.changeButton setEnabled:NO];
            NSLog(@"%d", self.editing);
            NSString* firstName   = [self.firstNameTextField text];
            NSString* lastName    = [self.lastNameTextField text];
            NSString* email       = [self.emailTextField text];
            NSString* phone = [self.phoneNumberTextField text];
            NSString* studentID = self.student.studentId;
            NSString* imageName = self.student.imageName;
            NSString* studentGroup = self.student.group;
            UIImage* studentImage = self.imageStudent.image;
            
            if(self.imageStudent.image == nil){
                [[StudentsService sharedService] studentEdit:[Student studentWithId:studentID
                                                                          firstName:firstName
                                                                           lastName:lastName
                                                                              email:email
                                                                              phone:phone
                                                                        createdDate:nil
                                                                        updatedDate:nil
                                                                          imageName:nil
                                                                              image:nil
                                                                              group:pickRowName]];
                NSLog(@"studentgroup = %@",studentGroup);
                NSLog(@"studentgroup = %@",pickerRowName);
                NSLog(@"studentgroup = %@",pickerRowId);
                NSLog(@"studentgroup = %@",selectedPickerRow);


            }
            else
            {
                
                [[StudentsService sharedService] studentEdit:[Student studentWithId:studentID
                                                                          firstName:firstName
                                                                           lastName:lastName
                                                                              email:email
                                                                              phone:phone
                                                                        createdDate:nil
                                                                        updatedDate:nil
                                                                          imageName:imageName
                                                                              image:studentImage
                                                                              group:pickRowName]];
                
               

                
                [[StudentsService sharedService] sendImageToServer:[Student studentWithId:nil
                                                                                firstName:nil
                                                                                 lastName:nil
                                                                                    email:nil
                                                                                    phone:nil
                                                                              createdDate:nil
                                                                              updatedDate:nil
                                                                                imageName:imageName
                                                                                    image:studentImage
                                                                                    group:pickRowName]];
                
            }
            UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item
                                                                                        target:self
                                                                                        action:@selector(editButton:)];
            [self.navigationItem setRightBarButtonItem:editButton animated:NO];
            
        }

    }
   }

- (IBAction)changePhotoButton:(id)sender
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentViewController:pickerController
                       animated:YES
                     completion:nil];
    
}

#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    self.imageStudent.image = image;
    NSLog(@"%@", self.imageStudent);
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    if(self.editing == NO)
    {
        return 1;
    }
    else
    {
        NSLog(@"count = %lu", (unsigned long)[[SectionService sharedService].groupsList count]);
        return [[SectionService sharedService].groupsList count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{

    if(self.editing == NO)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        array = [[SectionService sharedService].groupsList copy];
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        Section *section = [array objectAtIndex:selectedRow];
        selectedPickerRow=[NSString stringWithFormat:@"%@", section.section];
        NSString *str = [NSString stringWithFormat:@"%@", [self.student group]];
        return str;
    }
    else
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        array = [[SectionService sharedService].groupsList copy];
        NSInteger i;
        pickerRowName = [[NSMutableArray alloc]init];
        pickerRowId = [[NSMutableArray alloc]init];
        for(i = 0; i < [array count]; i++)
        {
            Section *section = [array objectAtIndex:i];
            NSString *stringWithName = [NSString stringWithFormat:@"%@",  section.section];
            pickRowName = stringWithName;
            NSString *stringWithId = [NSString stringWithFormat:@"%@", section.sectionId];
            [pickerRowName valueForKey:@"group"];
            [pickerRowId addObject:stringWithId];
            if(row == i)
            {
                return stringWithName;
            }
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
    NSLog(@"%@", section.section);
    pickRowName=[NSString stringWithFormat:@"%@", section.section];
}

- (void)refreshPicker
{
    
    [[SectionService sharedService] updateSectionList];
    [self.groupsPickerView reloadAllComponents];
    
}

#pragma mark - Service Methods


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
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
