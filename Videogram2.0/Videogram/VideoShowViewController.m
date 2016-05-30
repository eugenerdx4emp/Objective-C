//
//  VideoShowViewController.m
//  Videogram
//
//  Created by eugenerdx on 25.05.16.
//  Copyright © 2016 Evgeny Ulyankin. All rights reserved.
//

#import "VideoShowViewController.h"

#define NAVHEIGHT                       64
#define SCREENWIDTH                     (int)[[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT                    (int)[[UIScreen mainScreen] bounds].size.height
#define VIEWNHEIGHT                     ((int)[[UIScreen mainScreen] bounds].size.height - NAVHEIGHT)


@interface VideoShowViewController ()

@end

@implementation VideoShowViewController

#pragma mark - Load View
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.videoPlayerView = [[YTPlayerView alloc] init];
    [self.videoPlayerView loadWithVideoId:_video.videoID];
    [self.videoPlayerView setDelegate:self];
    [self.view addSubview:self.videoPlayerView];
}

- (void)viewDidLayoutSubviews
{
    [self.videoPlayerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 320)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Youtube player delegate methods
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        default:
            break;
    }
}

@end
