//
//  UILabel+Copyable.h
//  calculator
//
//  Created by eugenerdx on 31.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UILabel (Copyable)


@property (nonatomic) IBInspectable BOOL copyingEnabled;
@property (nonatomic) IBInspectable BOOL shouldUseLongPressGestureRecognizer;

@end
