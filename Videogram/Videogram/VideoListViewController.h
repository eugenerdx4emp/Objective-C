//
//  VideoListViewController.h
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface VideoListViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (copy, nonatomic) NSDictionary *groupedVideoByChannelAndSortedByTitle;
@property (nonatomic, copy, readonly) NSArray *array;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

