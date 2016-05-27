//
//  StudentListViewController.m
//  iosintershiptask1
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "StudentListViewController.h"
#import "StudentDetailsViewController.h"
#import "StudentAddViewController.h"
#import "StudentsService.h"

@interface StudentListViewController ()
{
    NSString *selectedStudentId,
    *selectedStudentFirstName,
    *selectedStudentLastName,
    *selectedStudentEmail,
    *selectedStudentPhone,
    *selectedStudentImageName;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (nonatomic) int recordIDToEdit;
-(void)loadData;
@end

@implementation StudentListViewController


#pragma mark - Load View methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"200"]];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor orangeColor];
    UIBarButtonItem *spinnerButton = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    NSArray *buttonArray = [NSArray arrayWithObjects:spinnerButton, nil];

    [self navigationItem].leftBarButtonItems = buttonArray;
    
    self.refreshControl.tintColor = [UIColor whiteColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
    
 
    
    UISwipeGestureRecognizer *recognizer;
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                           action:@selector(swipeRightTableView)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];

  
    
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");
    
        
    }
    else
    {
        NSLog(@"Connected to URL://linneage.ru");
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStudentsListUpdated)
                                                 name:NotificationStudentsServiceStudentsListUpdated
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStudentsServiceHasRequest)
                                                 name:NotificationStudentsServiceHasHTTPRequests
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleStudentsServiceHasNoRequest)
                                                 name:NotificationStudentsServiceHasNoHTTPRequests
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handle Notification Methods

- (void)handleStudentsListUpdated
{
    [self.tableView reloadData];
}

- (void)handleStudentsServiceHasRequest
{
    [self.spinner startAnimating];
}

- (void)handleStudentsServiceHasNoRequest
{
    [self.spinner stopAnimating];
}

- (void)refreshTable
{
    [self.refreshControl endRefreshing];
    
    [[StudentsService sharedService] updateStudentsList];

}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *keyArray = [[NSArray alloc]init];
    keyArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
    
    return [keyArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *keyArray = [[NSArray alloc]init];
    keyArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
    NSString *key = [keyArray objectAtIndex:section];
    NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
    return [dictionary count];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell"
                                                            forIndexPath:indexPath];
    NSArray* subviews = [cell.contentView subviews];
    
    for(UIView* subview in subviews)
    {
        [subview removeFromSuperview];
    }
    
    NSArray *studentArray = [[NSArray alloc]init];
    studentArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
    NSString *key = [studentArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
    NSArray *rowArray = [[NSArray alloc] init];
    rowArray = dictionary.copy;
    Student* cellStudent = [rowArray objectAtIndex:indexPath.row];
    
    
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");
        NSData *pngData = [NSData dataWithContentsOfFile:[self documentsPathForFileName:[cellStudent imageName]]];
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,47.5,47.5)];
        imv.image=[UIImage imageWithData:pngData];
        [cell.contentView clearsContextBeforeDrawing];
        [cell.contentView addSubview:imv];
        UILabel *cellName = [[UILabel alloc] init];
        cellName.frame = CGRectMake(55,12,200,20);
        cellName.text = [NSString stringWithFormat:@"%@ %@", cellStudent.firstName, cellStudent.lastName];
        [cell.contentView addSubview:cellName];
    }
    if([[[Network alloc]init] connectedToInternet] == YES)
    {
        NSLog(@"Connected to URL://linneage.ru");
        NSString *imageUrlFromServer = [NSString stringWithFormat:@"https://linneage.ru/phpuploadtutorial/upload-files/decode/%@", cellStudent.imageName];
        NSURL *url = [NSURL URLWithString:imageUrlFromServer];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.imageStudent.image = [UIImage imageWithData:data];
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,47.5,47.5)];
        imv.image=[UIImage imageWithData:data];
        [cell.contentView clearsContextBeforeDrawing];
        [cell.contentView addSubview:imv];
        UILabel *cellName = [[UILabel alloc] init];
        cellName.frame = CGRectMake(55,12,200,20);
        cellName.text = [NSString stringWithFormat:@"%@ %@", cellStudent.firstName, cellStudent.lastName];
        [cell.contentView addSubview:cellName];
        
        
    }
    return cell;
    
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    
    NSArray *studentArray = [[NSArray alloc]init];
    studentArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
    
    return [studentArray objectAtIndex:section];
}
-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return indexPath.row >= 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexSection = [self.tableView indexPathForSelectedRow].row;
    NSLog(@"selected row %ld", (long)indexSection);
}



- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    
    if (fromIndexPath.section != toIndexPath.section ) {
        NSMutableArray *section = [NSMutableArray new];
        section = [[GroupsService sharedService].groupsList copy];
        NSArray *sectionArray = [[NSArray alloc]init];
        sectionArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
        NSString *key = [sectionArray objectAtIndex:toIndexPath.section];
        NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
        
        NSMutableArray *rowArray = [[NSMutableArray alloc] init];
        rowArray = dictionary.copy;
        NSMutableArray *student = [NSMutableArray new];
        student = [[StudentsService sharedService].studentsList copy];
        Student* cellStudent = [student objectAtIndex:toIndexPath.row];
        [[StudentsService sharedService] studentEdit:[Student studentWithId:selectedStudentId
                                                                  firstName:selectedStudentFirstName
                                                                   lastName:selectedStudentLastName
                                                                      email:selectedStudentEmail
                                                                      phone:selectedStudentPhone
                                                                createdDate:nil
                                                                updatedDate:nil
                                                                  imageName:selectedStudentImageName
                                                                      image:nil
                                                                      group:key]];
        
        [[StudentsService sharedService] updateStudentsList];
        [tableView reloadData];
        [self refreshTable];
        
    }
}

- (void)tableView:(UITableView *)tableView didEndReorderingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *section = [NSMutableArray new];
    section = [[GroupsService sharedService].groupsList copy];
    NSArray *sectionArray = [[NSArray alloc]init];
    sectionArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
    NSString *key = [sectionArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    rowArray = dictionary.copy;
    Student* cellStudent = [rowArray objectAtIndex:indexPath.row];
    selectedStudentId = cellStudent.studentId;
    selectedStudentFirstName = cellStudent.firstName;
    selectedStudentLastName = cellStudent.lastName;
    selectedStudentEmail = cellStudent.email;
    selectedStudentPhone = cellStudent.phone;
    selectedStudentImageName = cellStudent.imageName;
}



- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                             forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");

            [self checkInternetConnectionAlertView];
    }

    if([[[Network alloc]init] connectedToInternet] == YES)
    {
        NSLog(@"Connected to URL://linneage.ru");
        if(editingStyle == UITableViewCellEditingStyleDelete)
        {
            NSArray *studentArray = [[NSArray alloc]init];
            studentArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
            NSString *key = [studentArray objectAtIndex:indexPath.section];
            NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
            NSArray *rowArray = [[NSArray alloc] init];
            rowArray = dictionary.copy;
            Student* cellStudent = [rowArray objectAtIndex:indexPath.row];
            
            NSLog(@"student for delete %@", cellStudent.studentId);
            [[StudentsService sharedService] studentDelete:[Student studentWithId:cellStudent.studentId
                                                                        firstName:nil
                                                                         lastName:nil
                                                                            email:nil
                                                                            phone:nil
                                                                      createdDate:nil
                                                                      updatedDate:nil
                                                                        imageName:nil
                                                                            image:nil
                                                                            group:nil]];
            [[StudentsService sharedService] updateStudentsList];
            [self.tableView reloadData];
            
        }

    }
    
   }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"detailSegue"])
    {
        StudentDetailsViewController* destination = [segue destinationViewController];
        NSInteger indexRow = [self.tableView indexPathForSelectedRow].row;
        NSInteger indexSection = [self.tableView indexPathForSelectedRow].section;
        destination.selectedStudentId = indexRow;
        NSArray *studentArray = [[NSArray alloc]init];
        studentArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
        NSString *key = [studentArray objectAtIndex:indexSection];
        NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
        NSArray *rowArray = [[NSArray alloc] init];
        rowArray = dictionary.copy;
        Student* selectedStudent=[rowArray objectAtIndex:indexRow];
        destination.student = selectedStudent;
        

        
        
    }
    if([[segue identifier]isEqualToString:@"saveSegue"])
    {
        
        if([[[Network alloc]init] connectedToInternet] == NO)
        {
            NSLog(@"Disconnected to URL://linneage.ru");
            
            [self checkInternetConnectionAlertView];
        
            
        }
        else
        {
            NSLog(@"Connected to URL://linneage.ru");
        }
        NSLog(@"Save segue");
    }
    
    }

#pragma mark - UIAlertView

- (void)closeAlertview
{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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
                                              [self refreshTable];
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


#pragma mark - UIGestureRecognizer



- (void)swipeRightTableView
{
    if([[[Network alloc]init] connectedToInternet] == NO)
    {
        NSLog(@"Disconnected to URL://linneage.ru");
        
        [self checkInternetConnectionAlertView];
        
        
    }
    else
    {
        BOOL isEditing = self.tableView.editing;
        [self.tableView setEditing:!isEditing animated:YES];
        if(self.tableView.editing)
        {
            UISwipeGestureRecognizer *recognizer;
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(cancelEditingTableView)];
            [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            [[self view] addGestureRecognizer:recognizer];
            
        }
    }
    NSLog(@"Save segue");

    
    }

- (void)cancelEditingTableView
{
    [self.tableView setEditing:NO
                      animated:YES];
}

#pragma mark - Service Methods
- (IBAction)cancel:(UIStoryboardSegue*)segue
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)save:(UIStoryboardSegue*)segue
{
    [self dismissViewControllerAnimated:true
                             completion:nil];
    
    [[StudentsService sharedService] updateStudentsList];
    
    [self.tableView reloadData];
    
}
- (void)AddSecton
{
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}


@end
