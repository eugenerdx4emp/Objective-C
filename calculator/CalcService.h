//
//  CalcService.h
//  calculator
//
//  Created by eugenerdx on 31.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CalcService : NSObject

- (void)setOperand:(double)aDouble;
- (double)performOperation:(NSString *)operation;
- (void)performWaitingOperation;

@end
