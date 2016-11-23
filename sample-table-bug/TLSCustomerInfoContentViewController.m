//
//  TLSComtentViewController.m
//  Tiller
//
//  Created by Geoffrey 21/11/16.
//  Copyright © 2016. All rights reserved.
//

#import "TLSCustomerInfoContentViewController.h"
#import "TLSCustomerTabViewController.h"


@interface TLSCustomerInfoContentViewController () <TLSCustomerPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong) UIViewController *childFormVc;

@end

@implementation TLSCustomerInfoContentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self switchRightButton:YES];
    
    self.childFormVc = [[TLSCustomerTabViewController alloc] init];
    [self addChildViewController:self.childFormVc];
    [self.containerView addSubview:self.childFormVc.view];
    [self.childFormVc didMoveToParentViewController:self];
    [self addBottomBorderToview:self.headerView];
    
    UIView *childview = self.childFormVc.view;
    [childview setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    // fill horizontal
    [self.containerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: @"H:|[childview]|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
    // fill vertical
    [self.containerView addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat: @"V:|-0-[childview]-0-|" options: 0 metrics: nil views: NSDictionaryOfVariableBindings(childview)]];
    
    [self.containerView layoutIfNeeded];
    [self setupGesture];
    
    [self addBottomBorderToview:self.headerView];
}


- (void)switchRightButton:(BOOL)isForm {
    if (isForm) {
        // Right bar button
        [self.rightBarButton setImage:nil forState:UIControlStateNormal];
        [self.rightBarButton setTitle:@"Enregistrer" forState:UIControlStateNormal];
        self.rightBarButton.tag = 2;
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)setupGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismiss:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint touchPoint = [tapRecognizer locationInView:self.view];
    if (![self pointInside:touchPoint]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)pointInside:(CGPoint)point{
    if (CGRectContainsPoint(self.mainView.frame, point)) {
        return YES;
    }
    
    return NO;
}

- (void)addBottomBorderToview:(UIView*)view{
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor blueColor].CGColor;
    
    border.frame = CGRectMake(0, 60, view.frame.size.width, 1);
    [view.layer addSublayer:border];
}


#pragma mark - Buttons Action

- (IBAction)rightBarButtonTapped:(id)sender {

}

#pragma mark - Delegate


- (void)switchViewControllerToIndex:(NSInteger)index {
    if (!index) {
        [self switchRightButton:YES];
    } else {
        [self switchRightButton:NO];
    }
}

@end
