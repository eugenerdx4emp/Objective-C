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
@property (strong, nonatomic) NSMutableDictionary *groupedByChannelAndSortedByTitle;
@property (nonatomic, strong) NSArray *rowArray;
@property (nonatomic, strong) NSMutableArray *ytVideosFromChannels;


@end

@implementation VideoListViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Videogram";
    [self kickoffVideoFeedLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _array = [[NSArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification)
                                                 name:@"firstPickerElementNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle notification
- (void) handleNotification
{
    [self.pickerView selectRow:1 inComponent:0 animated:NO];
    [self pickerView:self.pickerView didSelectRow:1 inComponent:0];
    
}

#pragma mark - Video Loading
- (void)kickoffVideoFeedLoad
{
    self.ytVideos = [[NSMutableArray alloc] init];
    NSArray *channelsIdArray = [[NSArray alloc] init];
    channelsIdArray = @[@"UC-EnprmCZ3OXyAoG7vjVNCA",
                        @"UChR0_wfiEHRy9TQIN51H-OA",
                        @"UCPZtkJkHv_3pPC0veurLQ6Q"];
    NSString *string;
    self.ytVideosFromChannels = [[NSMutableArray alloc] init];

    VideoManager* videoManager = [[VideoManager alloc] init];
    for(int i=0; i < [channelsIdArray count]; i++)
    {
        string = [NSString stringWithFormat:@"%@", [channelsIdArray objectAtIndex:i]];
    [videoManager getVideos:string completionBlock:^(NSMutableArray * videoList)
     {
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
    [self videosGroupedByChannelAndSortedByName:rowArray];
    return [self.groupedVideoByChannelAndSortedByTitle count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
    rowArray = [self.ytVideosFromChannels copy];
    [self videosGroupedByChannelAndSortedByName:rowArray];
    NSArray *keyArray = [[NSArray alloc]init];
    keyArray = [self.groupedVideoByChannelAndSortedByTitle allKeys];
    NSString *key = [keyArray objectAtIndex:section];
    NSDictionary *dictionary = [self.groupedVideoByChannelAndSortedByTitle objectForKey:key];
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
    NSArray *channelArray = [[NSArray alloc]init];
    channelArray = [self.groupedVideoByChannelAndSortedByTitle allKeys];
    NSString *key = [channelArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.groupedVideoByChannelAndSortedByTitle objectForKey:key];
    NSMutableArray *newRowArray = [[NSMutableArray alloc] init];
    newRowArray = dictionary.copy;
    CALayer *imageViewLayer = cellImage.layer;
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.colors = @[(id)[UIColor blackColor].CGColor,
                         (id)[UIColor clearColor].CGColor];
    maskLayer.startPoint = CGPointMake(1, 1);
    maskLayer.endPoint = CGPointMake(1, 0);
    maskLayer.frame = imageViewLayer.bounds;
    [imageViewLayer insertSublayer:maskLayer below:0];
    Video* cellVideo = [newRowArray objectAtIndex:indexPath.row];
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:cellVideo.thumbnailURL]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize){}
                                                      completed:^(UIImage *image,
                                                                  NSData *data,
                                                                  NSError *error,
                                                                  BOOL finished)
     {
        if (image && finished)
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                cellImage.image=[UIImage imageWithData:data];
                NSString *string = [NSString stringWithFormat:@"%@", cellVideo.videoTitle];
                cellTitle.text = string;
                               if(channelArray.count >=2)
                               {
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"firstPickerElementNotification"
                                                                                       object:nil];
                               }
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
        sectionsArray = [self.groupedVideoByChannelAndSortedByTitle allKeys];
        NSString *title = [NSString stringWithFormat:@"%@", [sectionsArray objectAtIndex:indexPath.section]];
        headerView.title.text = title;
        reusableview = headerView;
        [self.pickerView selectRow:indexPath.section inComponent:0 animated:YES];

    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *channelArray = [[NSArray alloc]init];
    channelArray = [self.groupedVideoByChannelAndSortedByTitle allKeys];
    NSString *key = [channelArray objectAtIndex:indexPath.section];
    NSDictionary *dictionary = [self.groupedVideoByChannelAndSortedByTitle objectForKey:key];
    NSMutableArray *newRowArray = [[NSMutableArray alloc] init];
    newRowArray = dictionary.copy;
    VideoShowViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"yt-video-controller"];
    details.video = [newRowArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:details animated:TRUE];
}

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
    [self videosGroupedByChannelAndSortedByName:rowArray];
    return [self.groupedVideoByChannelAndSortedByTitle count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSInteger i;
    NSArray *sectionsArray = [[NSArray alloc]init];
    sectionsArray = [self.groupedVideoByChannelAndSortedByTitle allKeys];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"firstPickerElementNotification" object:nil];
    [self.collectionView scrollRectToVisible:rect animated:YES];
}

#pragma mark - Service Methods
- (NSDictionary *)videosGroupedByChannelAndSortedByName:(NSArray *)videos
{
    
    NSSortDescriptor *byId = [NSSortDescriptor sortDescriptorWithKey:@"channelTitle" ascending:YES];
    NSArray *channelName = [videos valueForKeyPath:@"@distinctUnionOfObjects.channelTitle"];
    self.groupedByChannelAndSortedByTitle = [[NSMutableDictionary alloc] init];
    for (NSString *channel in channelName) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"channelTitle == %@",channel];
        NSArray *currentVideoTitleId = [videos filteredArrayUsingPredicate:predicate];
        NSArray *currentSectionsSortedById = [currentVideoTitleId sortedArrayUsingDescriptors:@[byId]];
        [self.groupedByChannelAndSortedByTitle setObject:currentSectionsSortedById
                                               forKey:channel];
        _groupedVideoByChannelAndSortedByTitle = [self.groupedByChannelAndSortedByTitle copy];
    }
    return _groupedVideoByChannelAndSortedByTitle;
}

@end
