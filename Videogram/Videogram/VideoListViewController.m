//
//  VideoListViewController.m
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import "VideoListViewController.h"
#import "VideoManager.h"
#import "VideoShowViewController.h"
#import "Video.h"
#import "ChannelsCollectionHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString *cellIdentifier = @"CVCell";


@interface VideoListViewController ()
{
    NSInteger selectedRow;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *ytVideos;

@property (strong, nonatomic) NSMutableDictionary *groupedBySectionAndSortedById;
@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, strong) NSMutableArray *ytVideosFromChannels;


@end

@implementation VideoListViewController

#pragma mark - View Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Videogram";
    
    [self kickoffVideoFeedLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    _array = [[NSArray alloc]init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Video Loading


- (void)kickoffVideoFeedLoad {
    self.ytVideos = [[NSMutableArray alloc] init];
    NSArray *channelsIdArray = [[NSArray alloc] init];
    channelsIdArray = @[@"UC-EnprmCZ3OXyAoG7vjVNCA", @"UChR0_wfiEHRy9TQIN51H-OA", @"UCPZtkJkHv_3pPC0veurLQ6Q"];
    NSString *string;
    self.ytVideosFromChannels = [[NSMutableArray alloc] init];

    VideoManager* vidManager = [[VideoManager alloc] init];
    for(int i=0; i < [channelsIdArray count]; i++)
    {
        string = [NSString stringWithFormat:@"%@", [channelsIdArray objectAtIndex:i]];
        
    
    [vidManager getVideos:string completionBlock:^(NSMutableArray * videoList) {
        self.ytVideos = [[videoList sortedArrayUsingDescriptors:
                          [NSArray arrayWithObject:[[NSSortDescriptor alloc]initWithKey:@"pubDate"
                                                                              ascending:NO]]] mutableCopy];
        [self.ytVideosFromChannels addObjectsFromArray:self.ytVideos];

        if(self.ytVideos.count >= 11)
        {
            [self.ytVideosFromChannels removeLastObject];
        }
        

        
      
        _array = [NSArray arrayWithArray:self.ytVideosFromChannels];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"array = %@", self.array);

            [self.collectionView reloadData];
            [self.pickerView reloadAllComponents];
        });

    }];
    }
   
   }

#pragma mark - UICollectionViewDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    _array = [self.ytVideosFromChannels copy];
    NSArray *rowArray = [[NSArray alloc] init];
    rowArray = [self.ytVideosFromChannels copy];
    [self studentsGroupedBySectionAndSortedByTrack:rowArray];
    return [self.groupedStudentBySectionAndSortedById count];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    rowArray = [self.ytVideosFromChannels copy];
    [self studentsGroupedBySectionAndSortedByTrack:rowArray];
    NSArray *keyArray = [[NSArray alloc]init];
    keyArray = [self.groupedStudentBySectionAndSortedById allKeys];
    NSString *key = [keyArray objectAtIndex:section];
    NSDictionary *dictionary = [self.groupedStudentBySectionAndSortedById objectForKey:key];
    
    return [dictionary count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                              forIndexPath:indexPath];
    UILabel *cellTitle = (UILabel *)[cell viewWithTag:1];
    UIImageView *cellImage = [(UIImageView *)cell viewWithTag:2];
    
    for(CAGradientLayer* subview in cellImage.layer.sublayers)
    {
        [subview removeFromSuperlayer];
    }
    
    NSArray *studentArray = [[NSArray alloc]init];
    studentArray = [self.groupedStudentBySectionAndSortedById allKeys];
    NSString *key = [studentArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.groupedStudentBySectionAndSortedById objectForKey:key];
    NSMutableArray *newRowArray = [[NSMutableArray alloc] init];
    newRowArray = dictionary.copy;
    CALayer *imageViewLayer = cellImage.layer;
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor];
    maskLayer.startPoint = CGPointMake(1, 1);
    maskLayer.endPoint = CGPointMake(1, 0);
    maskLayer.frame = imageViewLayer.bounds;
    [imageViewLayer insertSublayer:maskLayer below:0];
    Video* cellStudent = [newRowArray objectAtIndex:indexPath.row];
    
   

    
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:cellStudent.thumbnailURL]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize){}
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (image && finished){
            dispatch_async(dispatch_get_main_queue(), ^{
                cellImage.image=[UIImage imageWithData:data];
                NSString *string = [NSString stringWithFormat:@"%@", cellStudent.videoTitle];
                cellTitle.text = string;
            });
        }
        
    }];

    return cell;
}





- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ChannelsCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:@"HeaderView"
                                                                                             forIndexPath:indexPath];
        NSArray *sectionsArray = [[NSArray alloc]init];
        sectionsArray = [self.groupedStudentBySectionAndSortedById allKeys];
        NSString *title = [NSString stringWithFormat:@"%@", [sectionsArray objectAtIndex:indexPath.section]];
        headerView.title.text = title;
        reusableview = headerView;
    }
    
    return reusableview;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


    NSArray *studentArray = [[NSArray alloc]init];
    studentArray = [self.groupedStudentBySectionAndSortedById allKeys];
    NSString *key = [studentArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.groupedStudentBySectionAndSortedById objectForKey:key];
    NSMutableArray *newRowArray = [[NSMutableArray alloc] init];
    newRowArray = dictionary.copy;

    
    VideoShowViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"yt-video-controller"];
    
    details.video = [newRowArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:details animated:TRUE];
    
//
//    VideoShowViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"yt-video-controller"];
//    details.video = [self.ytVideos objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:details animated:TRUE];
    
    
}
//
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([[segue identifier]isEqualToString:@"showVideo"])
//    {
//        VideoShowViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"yt-video-controller"];
//        NSArray *indexRow = [self.collectionView indexPathsForSelectedItems];
//        NSLog(@"%@", indexRow);
////        NSInteger indexSection = [self.tableView indexPathForSelectedRow].section;
////        destination.selectedStudentId = indexRow;
////        NSArray *studentArray = [[NSArray alloc]init];
////        studentArray = [[StudentsService sharedService].groupedStudentBySectionAndSortedById allKeys];
////        NSString *key = [studentArray objectAtIndex:indexSection];
////        NSDictionary *dictionary = [[StudentsService sharedService].groupedStudentBySectionAndSortedById objectForKey:key];
////        NSArray *rowArray = [[NSArray alloc] init];
////        rowArray = dictionary.copy;
////        Student* selectedStudent=[rowArray objectAtIndex:indexRow];
////        destination.student = selectedStudent;
//        
//        
////        NSArray *studentArray = [[NSArray alloc]init];
////        studentArray = [self.groupedStudentBySectionAndSortedById allKeys];
////        NSString *key = [studentArray objectAtIndex:indexPath.section];
////        NSDictionary *dictionary = [self.groupedStudentBySectionAndSortedById objectForKey:key];
////        NSMutableArray *newRowArray = [[NSMutableArray alloc] init];
////        newRowArray = dictionary.copy;
////        
//    }
//}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    
    _array = [self.ytVideosFromChannels copy];
    NSArray *rowArray = [[NSArray alloc] init];
    rowArray = [self.ytVideosFromChannels copy];
    [self studentsGroupedBySectionAndSortedByTrack:rowArray];
    return [self.groupedStudentBySectionAndSortedById count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    
  
    
        NSInteger i;
    NSArray *sectionsArray = [[NSArray alloc]init];
    sectionsArray = [self.groupedStudentBySectionAndSortedById allKeys];
            for(i = 0; i < [sectionsArray count]; i++)
            {
                NSString *title = [NSString stringWithFormat:@"%@", [sectionsArray objectAtIndex:i]];
                if(row == i)
                {
                    return title;
                }
            }
    return @"Loading. Please wait...";
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow: (NSInteger)row
       inComponent:(NSInteger)component
{
    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:0 inSection:row];
    UICollectionViewLayoutAttributes* attr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
    UIEdgeInsets insets = self.collectionView.scrollIndicatorInsets;
    CGRect rect = attr.frame;
    rect.size = self.collectionView.frame.size;
    rect.size.height -= insets.top + insets.bottom;
    CGFloat offset = (rect.origin.y + rect.size.height) - self.collectionView.contentSize.height;
    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

#pragma mark - Service Methods
- (NSDictionary *)studentsGroupedBySectionAndSortedByTrack:(NSArray *)videos {
    
    NSSortDescriptor *byId = [NSSortDescriptor sortDescriptorWithKey:@"channelTitle" ascending:YES];
    NSArray *sectionName = [videos valueForKeyPath:@"@distinctUnionOfObjects.channelTitle"];
    self.groupedBySectionAndSortedById = [[NSMutableDictionary alloc] init];
    for (NSString *section in sectionName) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelTitle == %@",section];
        NSArray *currentStudentsId = [videos filteredArrayUsingPredicate:predicate];
        NSArray *currentSectionsSortedById = [currentStudentsId sortedArrayUsingDescriptors:@[byId]];
        [self.groupedBySectionAndSortedById setObject:currentSectionsSortedById
                                               forKey:section];
        _groupedStudentBySectionAndSortedById = [self.groupedBySectionAndSortedById copy];
    }
    return _groupedStudentBySectionAndSortedById;
}


@end
