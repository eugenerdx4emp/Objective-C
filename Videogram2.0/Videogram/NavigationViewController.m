//
//  NavigationViewController.m
//  SlideOutMenu
//
//  Created by Jared Davidson on 7/14/14.
//  Copyright (c) 2014 Archetapp. All rights reserved.
//

#import "NavigationViewController.h"
#import "SWRevealViewController.h"
#import "YTVideoListController.h"

@interface NavigationViewController ()
{
}

@property (nonatomic, strong) YTVideoListController *videoList;
@property (nonatomic, strong) NSArray *studentsOfflineInfo;

@end

@implementation NavigationViewController
{
    NSArray *menu;
}

#pragma mark - initialization
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Load View
- (void)viewDidLoad
{
    [super viewDidLoad];
    menu = @[@"space", @"channel",@"first", @"second", @"third"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.studentsOfflineInfo = [[NSArray alloc] initWithArray:[self.videoList ytVideosFromChannels]];
    NSLog(@"studentsOfflineInfo = %@",self.studentsOfflineInfo);
    NSMutableArray *array = [NSMutableArray new];
    array = [self.videoList.ytVideosFromChannels copy];
    NSLog(@"%@",self.ytVideosFromChannels);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return  [menu count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [menu objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *dictionary = [[NSDictionary alloc]init];
    YTVideoListController *videoList = [[YTVideoListController alloc]init];
    dictionary =[videoList getArray];
    
    return cell;
}

@end
