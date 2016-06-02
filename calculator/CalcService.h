//
//  CalcService.h
//  calculator
//
//  Created by eugenerdx on 31.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    divideByZero   = 1,
    sqrtNegative    = 2,
    inverseOfZero   = 3
};
typedef NSInteger calcError;


@interface CalcService : NSObject {
    double operand;
    double waitingOperand;
    NSString * waitingOperation;
}

@property (assign, nonatomic) calcError error;
@property (strong, nonatomic) NSString *calcErrorMessage;

- (void)setOperand:(double)aDouble;
- (double)performOperation:(NSString *)operation;
- (void)performWaitingOperation;

@end
