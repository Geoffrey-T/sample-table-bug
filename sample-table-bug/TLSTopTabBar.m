//
//  TLSTopTabBar.m
//  Tiller
//
//  Created by geoffrey on 19/10/2016.
//  Copyright © 2016. All rights reserved.
//

#import "TLSTopTabBar.h"

const CGFloat INDICATOR_HEIGHT = 3.0;

@interface TLSTopTabBar ()

@property (nonatomic) NSLayoutConstraint *indicatorXPosition;
@property (nonatomic) NSInteger currentState;
@property (nonatomic) NSMutableArray *buttonsArray;
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation TLSTopTabBar


#pragma mark - Setup

- (void)setupTabBarWithButtonsTitleArray:(NSArray*)buttons {
    CGFloat width = (self.frame.size.width / buttons.count);
    CGRect btnFrame = CGRectMake(0, 0, width, self.frame.size.height);
    CGRect indicatorFrame = btnFrame;
    NSInteger i = 0;
    
    self.buttonsArray = [[NSMutableArray alloc] init];
    
    for (NSString *title in buttons) {
        UIButton *button = [[UIButton alloc] initWithFrame:[self getFrameAtIndex:i frame:btnFrame]];
        
        button.tag = i;
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [button setTranslatesAutoresizingMaskIntoConstraints:false];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [self addSubview:button];
        [self.buttonsArray addObject:button];
        
        ++i;
        btnFrame.origin.x = i * width;
    }
    
    indicatorFrame.size.height = INDICATOR_HEIGHT;
    indicatorFrame.origin.y = self.bounds.size.height - INDICATOR_HEIGHT;
    
    self.indicatorView = [[UIView alloc] initWithFrame:indicatorFrame];
    [self.indicatorView setBackgroundColor:[UIColor blueColor]];
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addSubview:self.indicatorView];
    
    [self setBackgroundColor:[UIColor whiteColor]];

    [self setupConstraints];
    [self setupGestureRecognizers];
    
    [self addBottomBorderToview];
    
    [self setNeedsLayout];
}

- (void) setupConstraints {
    // Fix first button to top
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonsArray[0] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    // and bottom
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonsArray[0] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    // left
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonsArray[0] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    UIButton *firstButton = self.buttonsArray[0];
    [firstButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    // setup equal width constraints for all buttons
    for (int i = 1; i < self.buttonsArray.count; ++i) {
        UIButton *button = self.buttonsArray[i];

         [self addConstraint:[NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        // top
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        // and bottom
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        // left button
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonsArray[i-1] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    }
    
    // right
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonsArray[self.buttonsArray.count-1] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    
    // add constraint to indicator view
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:firstButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    self.indicatorXPosition = constraint;
    [self addConstraint:constraint];
    
    // Width constraint
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    // Height constraint
    [self.indicatorView addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute: NSLayoutAttributeNotAnAttribute
                                                     multiplier:1
                                                       constant:self.indicatorView.frame.size.height]];
    // Bottom constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (CGRect)getFrameAtIndex:(NSInteger)index frame:(CGRect)frame {
    CGFloat x = frame.size.width * index;
    frame.origin.x = x;
    
    return frame;
}

#pragma mark - Gestures

- (void)respondToLeftSwipe:(UIGestureRecognizer *)sender {
    if (self.currentState > 0) {
        [self animateTo:self.currentState - 1 direction:UIPageViewControllerNavigationDirectionReverse];
    }
}

- (void)respondToRightSwipe:(UIGestureRecognizer *)sender {
    if (self.currentState < self.buttonsArray.count - 1) {
        [self animateTo:self.currentState + 1 direction:UIPageViewControllerNavigationDirectionForward];
    }
}

- (void)buttonTapped:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag > self.currentState && button.tag < self.buttonsArray.count) {
        [self animateTo:button.tag direction:UIPageViewControllerNavigationDirectionForward];
    } else if (button.tag != self.currentState) {
        [self animateTo:button.tag direction:UIPageViewControllerNavigationDirectionReverse];
    }
}


- (void)setupGestureRecognizers {
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToRightSwipe:)];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToLeftSwipe:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self addGestureRecognizer:rightSwipe];
    [self addGestureRecognizer:leftSwipe];
}


#pragma mark - Animation

- (void)animateTo:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction {
    UIButton *fromButton = self.buttonsArray[self.currentState];
    UIButton *toButton = self.buttonsArray[index];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.indicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    if ([self.delegate respondsToSelector:@selector(willSelectViewControllerAtIndex:direction:)]) {
        [self.delegate willSelectViewControllerAtIndex:index direction:direction];
    }
    
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self removeConstraint:self.indicatorXPosition];
        self.indicatorXPosition = constraint;
        [self addConstraint:self.indicatorXPosition];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [toButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [fromButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }];
    
    self.currentState = index;
}


- (void)addBottomBorderToview{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor grayColor].CGColor;
    
    border.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    [self.layer addSublayer:border];
}
@end
