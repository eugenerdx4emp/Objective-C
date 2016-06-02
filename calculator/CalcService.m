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


@interface CalcService()
{
    double expression;
    double waitingExpression;
    NSString * waitingOperation;
}

@end

@implementation CalcService

- (void)setOperand:(double)doubleExpression
{
    expression = doubleExpression;
}

- (double)performOperation:(NSString *)operation
{
    if ([operation isEqual:calculationPercentOperation])
        {
        expression = expression / 100;
        }
    if ([operation isEqual:calculationClearAllExpressionOperation])
        {
        expression = 0;
        }
    if ([operation isEqualToString:calculationInverseOperation])
        {
        if (expression != 0)
            {
            expression = -1 * expression;
            }
        }
    else
    {
        [self performWaitingOperation];
        waitingOperation = operation;
        waitingExpression = expression;
    }
    return expression;
}

- (void)performWaitingOperation
{
    if (waitingExpression  == 0)
            {
        expression = expression * expression;
            }
    if ([calculationPlusOperation isEqual:waitingOperation])
            {
        expression = waitingExpression + expression;
            }
    else if ([calculationMultipleOperation isEqual:waitingOperation])
            {
        expression = waitingExpression * expression;
            }
    else if ([calculationMinusOperation isEqual:waitingOperation])
            {
        expression = waitingExpression - expression;
            }
    else if ([calculationClearLastExpressionOperation isEqual:waitingOperation])
            {
        expression = waitingExpression;
            }
    else if ([calculationDivideOperation isEqual:waitingOperation])
            {
        if (expression != 0)
                {
            expression = waitingExpression / expression;
                }
            }
}

@end
