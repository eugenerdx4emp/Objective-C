//
//  VideoShowViewController.h
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "Video.h"

@interface VideoShowViewController : UIViewController <YTPlayerViewDelegate>

@property (nonatomic, strong) Video *video;
@property (nonatomic, strong) YTPlayerView *videoPlayerView;

@end
