//
//  CalcService.m
//  calculator
//
//  Created by eugenerdx on 31.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "CalcService.h"

NSString* const calculationInverseOperation                 = @"+/-";
NSString* const calculationPlusOperation                    = @"+";
NSString* const calculationMinusOperation                   = @"−";
NSString* const calculationMultipleOperation                = @"×";
NSString* const calculationDivideOperation                  = @"÷";
NSString* const calculationPercentOperation                 = @"%";
NSString* const calculationClearLastExpressionOperation     = @"C";
NSString* const calculationClearAllExpressionOperation      = @"AC";




@implementation CalcService

- (void)setOperand:(double)aDouble {
    
    operand = aDouble;
}

- (double)performOperation:(NSString *)operation {
    if ([operation isEqual:calculationPercentOperation]) {
        
        operand = operand / 100;
        
    }
    
    if ([operation isEqual:calculationPercentOperation]) {
        
        operand = operand / 100;
        
    }

    
   if ([operation isEqualToString:calculationInverseOperation]) {
        
        if (operand != 0) {
            operand = -1 * operand;
        } else {
            self.error = inverseOfZero;
            self.calcErrorMessage = @"Inverse of Zero";
        }
            
  
    } else {
        
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingOperand = operand;
    }
    
    return operand;
}

- (void)performWaitingOperation {
    
    if ([calculationPlusOperation isEqual:waitingOperation]) {
        
        operand = waitingOperand + operand;
        
    } else if ([calculationMultipleOperation isEqual:waitingOperation]) {
        
        operand = waitingOperand * operand;
        
    } else if ([calculationMinusOperation isEqual:waitingOperation]) {
        
        operand = waitingOperand - operand;
        
    } else if ([calculationDivideOperation isEqual:waitingOperation]) {
        
        if (operand != 0) {
            operand = waitingOperand / operand;
        } else {
            self.error = divideByZero;
            self.calcErrorMessage = @"Divide by Zero";
        }
    }
   
}

@end
