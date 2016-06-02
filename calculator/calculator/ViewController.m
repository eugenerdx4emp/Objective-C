//
//  ViewController.m
//  calculator
//
//  Created by eugenerdx on 31.05.16.
//  Copyright © 2016 eugenerdx. All rights reserved.
//

#import "ViewController.h"
#import "CalcService.h"
#import "UILabel+Copyable.h"

@interface ViewController ()
{
    __weak IBOutlet UILabel *zeroAfterReset;
    __weak IBOutlet UILabel *display;
    CalcService *service;
    double calcMemory;
    BOOL middleOfTypingANumber;
    BOOL decimalAlreadyEnteredInDisplay;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;
- (IBAction)decimalPressed:(UIButton *)sender;
- (IBAction)clearPressed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *devideButton;
@property (weak, nonatomic) IBOutlet UIButton *multiplicationButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *equallyButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *percentButton;

@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.clearButton setTitle:@"AC"
                      forState:UIControlStateNormal];
    display.copyingEnabled = 1;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Calc Methods
- (CalcService*)service
{
    if (!service)
    {
        service = [[CalcService alloc] init];
    }
    return service;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    zeroAfterReset.hidden = YES;
    NSString *digit = sender.titleLabel.text;
    [self.clearButton setTitle:@"C"
                      forState:UIControlStateNormal];
    if (middleOfTypingANumber)
    {
        display.text = [display.text stringByAppendingString:digit];
        
    }
    else
    {
        [display setText:digit];
        middleOfTypingANumber = YES;
    }
  
}

- (IBAction)operationPressed:(UIButton *)sender
{
    
    zeroAfterReset.hidden = YES;
    NSString *string = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
    [self removingAndInstallingBorderOfButton:sender withString:string];
    NSLog(@"selected %@",sender.titleLabel.text);
    if (middleOfTypingANumber)
    {
        [[self service] setOperand:[[display text] doubleValue]];
        middleOfTypingANumber = NO;
        decimalAlreadyEnteredInDisplay = NO;
    }
      NSString *operation = [[sender titleLabel] text];
    double result = [[self service] performOperation:operation];
    [display setText:[NSString stringWithFormat:@"%g", result]];
    if (service.error) {
        [self showError:service.calcErrorMessage];
        service.error = 0;
        service.calcErrorMessage = @"";
    }
}

- (void)showError:(NSString *)message {
    
    [display setText:message];

    
}

- (IBAction)decimalPressed:(UIButton *)sender
{
    
    if (decimalAlreadyEnteredInDisplay == NO)
    {
        if (middleOfTypingANumber == NO)
        {
            middleOfTypingANumber = YES;
            [display setText:@"0."];
        }
        else
        {
            
            [display setText:[[display text] stringByAppendingString:@"."]];
        }
        decimalAlreadyEnteredInDisplay = YES;
    }
}

- (IBAction)clearPressed:(UIButton *)sender
{
    
    [self performSelector:@selector(removeBorderOfButton:)
               withObject:self.plusButton
               afterDelay:0];
    [self performSelector:@selector(removeBorderOfButton:)
               withObject:self.devideButton
               afterDelay:0];
    [self performSelector:@selector(removeBorderOfButton:)
               withObject:self.multiplicationButton
               afterDelay:0];
    [self performSelector:@selector(removeBorderOfButton:)
               withObject:self.minusButton
               afterDelay:0];
    [self performSelector:@selector(removeBorderOfButton:)
               withObject:self.percentButton
               afterDelay:0];
    [self performSelector:@selector(removeBorderOfButton:)
               withObject:self.clearButton
               afterDelay:0];
    
    NSString* cString = @"C";
    NSString* acString = @"AC";
    NSString* string = [NSString stringWithFormat:@"%@", sender.titleLabel.text];

    if([string isEqualToString:acString])
    {
    zeroAfterReset.hidden = NO;
    service = nil;
    service = [[CalcService alloc] init];
    [display setText:@""];
    }
    if([string isEqualToString:cString])
    {
        middleOfTypingANumber = NO;
        display.text = @"";
        zeroAfterReset.hidden = NO;
        [self.clearButton setTitle:@"AC"
                          forState:UIControlStateNormal];
    }
}

#pragma mark - service methods

- (void)installBorderOfButton:(UIButton*)pressedButton
{
    [[pressedButton layer] setBorderWidth:2.0f];
    [[pressedButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [pressedButton setHighlighted:NO];
}


- (void)removeBorderOfButton:(UIButton*)unPressedButton
{
    [[unPressedButton layer] setBorderWidth:0.0f];
    [[unPressedButton layer] setBorderColor:[UIColor clearColor].CGColor];
    [unPressedButton setHighlighted:NO];
}


- (void)removingAndInstallingBorderOfButton:(UIButton *)sender withString:(NSString *)string
{
    
    NSString *equalString = @"=";
    NSString *multiplicationlString = @"×";
    NSString *minusString = @"−";
    NSString *plusString = @"+";
    NSString *inversionString = @"+/-";
    NSString *devideString = @"÷";
    NSString *percentString = @"%";


    if([string isEqualToString:devideString])
    {
        [self performSelector:@selector(installBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.plusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.equallyButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.multiplicationButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.minusButton
                   afterDelay:0];
    }
    if([string isEqualToString:inversionString])
    {
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.equallyButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.multiplicationButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.minusButton
                   afterDelay:0];
    }
    
    if([string isEqualToString:plusString])
    {
        [self performSelector:@selector(installBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.equallyButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.multiplicationButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.minusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
    }
    
    if([string isEqualToString:minusString])
    {
        [self performSelector:@selector(installBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.equallyButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.multiplicationButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.plusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
    }
    
    if([string isEqualToString:multiplicationlString])
    {
        [self performSelector:@selector(installBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.equallyButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.minusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.plusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
    }
    
    
    if([string isEqualToString:equalString])
    {
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.multiplicationButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.minusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.plusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
    }
    
    if([string isEqualToString:percentString])
    {
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:sender
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.multiplicationButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.minusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.plusButton
                   afterDelay:0];
        [self performSelector:@selector(removeBorderOfButton:)
                   withObject:self.devideButton
                   afterDelay:0];
    }

}




@end
