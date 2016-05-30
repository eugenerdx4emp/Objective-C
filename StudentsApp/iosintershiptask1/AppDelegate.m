//
//  AppDelegate.m
//  iosintershiptask1
//
//  Created by eugenerdx on 28.03.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property UIImageView * imageView;
@property CALayer * mask;
@property CAKeyframeAnimation * keyFrameAnimation;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor redColor];
    [self.window makeKeyAndVisible];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *navigationController  = [mainStoryboard instantiateViewControllerWithIdentifier:@"navCont"];
    self.window.rootViewController = navigationController;
    navigationController.view.layer.mask = [CALayer layer];
    navigationController.view.layer.mask.contents = (id)([[UIImage imageNamed:@"logo"] CGImage]);
    navigationController.view.layer.mask.bounds = CGRectMake(0, 0, 330, 330);
    navigationController.view.layer.mask.anchorPoint = CGPointMake(0.5, 0.5);
    navigationController.view.layer.mask.position = CGPointMake(CGRectGetMidX(navigationController.view.bounds), CGRectGetMidY(navigationController.view.bounds));
    
    UIView *maskBgView = [[UIView alloc] initWithFrame:navigationController.view.frame];
    maskBgView.backgroundColor = [UIColor whiteColor];
    [navigationController.view addSubview:maskBgView];
    [navigationController.view bringSubviewToFront:maskBgView];
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    transformAnimation.delegate = self;
    transformAnimation.duration = 1;
    transformAnimation.beginTime = CACurrentMediaTime() + 1;
    CGRect initalBounds = self.mask.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 90, 90);
    CGRect finalBounds = CGRectMake(0, 0, 2000, 2000);
    transformAnimation.values = @[[NSValue valueWithCGRect:initalBounds],
                                  [NSValue valueWithCGRect:secondBounds],
                                  [NSValue valueWithCGRect:finalBounds]];
    transformAnimation.keyTimes = @[@0, @0.3, @1];
    transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    transformAnimation.removedOnCompletion = false;
    transformAnimation.fillMode = kCAFillModeForwards;
    [navigationController.view.layer.mask addAnimation:transformAnimation forKey:@"maskAnimation"];
    
    [UIView animateWithDuration:0.1
                          delay:1.35
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         maskBgView.alpha = 0.0;
                     } completion:^(BOOL finished){
                         [maskBgView removeFromSuperview];
                     }];
    
    
    
    [UIView animateWithDuration:0.25
                          delay:1.3
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.window.rootViewController.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.window.rootViewController.view.transform = CGAffineTransformIdentity;
                                          } completion:^(BOOL finished){
                                              [self.imageView removeFromSuperview];
                                          }];
                     }];
    
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
