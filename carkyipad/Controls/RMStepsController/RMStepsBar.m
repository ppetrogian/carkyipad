//
//  RMStepsBar.m
//  RMStepsController
//
//  Created by Roland Moers on 14.11.13.
//  Copyright (c) 2013 Roland Moers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMStepsBar.h"
#import <QuartzCore/QuartzCore.h>

#import "RMStep.h"
#import "CircleLineButton.h"
#define RM_CANCEL_BUTTON_WIDTH 50
#define RM_MINIMAL_STEP_WIDTH 40
#define RM_SEPERATOR_WIDTH 10

#define RM_LEFT_SEPERATOR_KEY @"RM_LEFT_SEPERATOR_KEY"
#define RM_RIGHT_SEPERATOR_KEY @"RM_RIGHT_SEPERATOR_KEY"
#define RM_STEP_KEY @"RM_STEP_KEY"
#define RM_STEP_WIDTH_CONSTRAINT_KEY @"RM_STEP_WIDTH_CONSTRAINT_KEY"


#pragma mark - Main Implementation

@interface RMStepsBar ()


@property (nonatomic, strong) NSMutableArray *stepDictionaries;

@end

@implementation RMStepsBar

@dynamic delegate;

#pragma mark - Init and Dealloc
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.clipsToBounds = YES;
    }

    return self;
}


- (NSMutableArray *)stepDictionaries {
    if(!_stepDictionaries) {
        self.stepDictionaries = [@[] mutableCopy];
    }
    
    return _stepDictionaries;
}

- (void)setIndexOfSelectedStep:(NSUInteger)newIndexOfSelectedStep {
    [self setIndexOfSelectedStep:newIndexOfSelectedStep animated:NO];
}

- (void)setIndexOfSelectedStep:(NSUInteger)newIndexOfSelectedStep animated:(BOOL)animated {
    if(_indexOfSelectedStep != newIndexOfSelectedStep) {
        _indexOfSelectedStep = newIndexOfSelectedStep;
        
        if(animated) { // animated
            __block RMStepsBar *blockself = self;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [blockself layoutIfNeeded];
            } completion:nil];
        } else
            [self layoutIfNeeded];
        
        [self updateStepsAnimated:animated];
    } else {
        [self updateStepsAnimated:NO];
    }
}

#pragma mark - Helper
- (void)updateStepsAnimated:(BOOL)animated {
    __weak RMStepsBar *blockself = self;
    [self.stepDictionaries enumerateObjectsUsingBlock:^(NSDictionary *aStepDict, NSUInteger idx, BOOL *stop) {
        RMStep *step = [self.dataSource stepsBar:self stepAtIndex:idx]; // (RMStep *)aStepDict[RM_STEP_KEY];
        
        if(blockself.indexOfSelectedStep > idx) {
            void (^stepAnimations)(void) = ^(void) {
                //step.stepView.strokeColor = step.enabledBarColor;
                //step.titleLabel.textColor = step.enabledTextColor;
                step.numberLabel.textColor = step.enabledTextColor;
                step.stepView.enabled = NO;
                step.hideNumberLabel = NO;
            };
            
            if(animated)
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:stepAnimations completion:nil];
            else
                stepAnimations();
            
        } else if(blockself.indexOfSelectedStep == idx) {
            void (^stepAnimations)(void) = ^(void) {
                //step.stepView.strokeColor = step.selectedBarColor;
                step.stepView.enabled = YES;
                //step.titleLabel.textColor = step.selectedTextColor;
                step.numberLabel.textColor = step.selectedTextColor;
                step.hideNumberLabel = self.hideNumberLabelWhenActiveStep;
            };
            
            if(animated)
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:stepAnimations completion:nil];
            else
                stepAnimations();

        } else if(blockself.indexOfSelectedStep < idx) {
            void (^stepAnimations)(void) = ^(void) {
                //step.stepView.strokeColor = step.disabledBarColor;
                step.stepView.enabled = NO;
                //step.titleLabel.textColor = step.disabledTextColor;
                step.numberLabel.textColor = step.disabledTextColor;
                step.hideNumberLabel = NO;
            };
            
            if(animated)
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:stepAnimations completion:nil];
            else
                stepAnimations();
            
        }

    }];
}


#pragma mark - Actions
- (void)reloadData {
    [self.stepDictionaries enumerateObjectsUsingBlock:^(NSDictionary *aStepDict, NSUInteger idx, BOOL *stop) {
        [[(RMStep *)aStepDict[RM_STEP_KEY] stepView] removeFromSuperview];
    }];
    [self.stepDictionaries removeAllObjects];

    __block NSUInteger numberOfSteps = [self.dataSource numberOfStepsInStepsBar:self];
    for(NSUInteger i=0 ; i<numberOfSteps ; i++) {

        
        if(i == numberOfSteps-1) {
            // todo
        } else {

        }
        
        RMStep *step = [self.dataSource stepsBar:self stepAtIndex:i];
        [self.stepDictionaries addObject:@{RM_STEP_KEY: step}];
        step.numberLabel.text = [NSString stringWithFormat:@"%lu", (long unsigned)i+1];
        
        [self updateStepsAnimated:NO];
    }
}

- (void)cancelButtonTapped:(id)sender {
    [self.delegate stepsBarDidSelectCancelButton:self];
}

- (void)recognizedTap:(UIGestureRecognizer *)recognizer {
    CGPoint touchLocation = [recognizer locationInView:self];
    for(NSDictionary *aStepDict in self.stepDictionaries) {
        RMStep *step = aStepDict[RM_STEP_KEY];
        
        if(CGRectContainsPoint(step.stepView.frame, touchLocation)) {
            NSInteger index = [self.stepDictionaries indexOfObject:aStepDict];
            if(index < self.indexOfSelectedStep && self.allowBackward) {
                [self.delegate stepsBar:self shouldSelectStepAtIndex:index];
            }
        }
    }
}

@end
