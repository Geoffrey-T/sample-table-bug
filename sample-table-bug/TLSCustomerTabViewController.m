//
//  TLSCustomerTabViewController.m
//  
//
//  Created by geoffrey on 19/10/2016.
//  Copyright © 2016. All rights reserved.
//

#import "TLSCustomerTabViewController.h"

#import "TableViewController.h"

const CGFloat TOP_BAR_HEIGHT = 50.0;

@interface TLSCustomerTabViewController () <TLSTopTabBarViewDelegate>


@end

@implementation TLSCustomerTabViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIViewController *firstVC = [[UIViewController alloc] init];
    firstVC.view.backgroundColor = [UIColor redColor];
    
    TableViewController *secondVC = [[TableViewController alloc] init];

    
    self.subViewControllers = [NSArray arrayWithObjects:firstVC, secondVC, nil];
    
    [self setupTopBar];
    [self setupPageView];
    [self setupConstraints];
}


///Sets up the UI of the page view and tab bar
- (void)setupPageView {
    [self.view addSubview:self.topTabBar];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.view.translatesAutoresizingMaskIntoConstraints = false;
    
    CGRect pageFrame = self.view.bounds;
    pageFrame.origin.y = TOP_BAR_HEIGHT;
    self.pageController.view.frame = pageFrame;
    
    
    [self.pageController setViewControllers:@[self.subViewControllers[0]]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:false
                                 completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)setupTopBar {
    self.topTabBar = [[TLSTopTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TOP_BAR_HEIGHT)];
    self.topTabBar.delegate = self;
    
    [self.view addSubview:self.topTabBar];
    
    self.topTabBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topTabBar setupTabBarWithButtonsTitleArray:[NSArray arrayWithObjects:@"Informations", @"Historique", nil]];
}

- (void)setupConstraints {
    NSDictionary *views = @{@"menuBar": self.topTabBar, @"pageView": self.pageController.view};
    
    // sticky on left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[menuBar]|" options:0 metrics:nil views:views]];
    // vertical margin to menuBar
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuBar][pageView]|" options:0 metrics:nil views:views]];
    // sticky on left and right
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pageView]|" options:0 metrics:nil views:views]];
    
    [self.topTabBar addConstraint:[NSLayoutConstraint constraintWithItem:self.topTabBar
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute: NSLayoutAttributeNotAnAttribute
                                                                  multiplier:1
                                                                    constant:TOP_BAR_HEIGHT]];
    
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:self.view
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}


#pragma mark - TopTabBar Delegate

- (void)willSelectViewControllerAtIndex:(NSInteger)index
                              direction:(UIPageViewControllerNavigationDirection)direction {
    
    __weak TLSCustomerTabViewController *weakSelf = self;

    if (index > [self.subViewControllers count]) {
        [self.pageController setViewControllers:@[self.subViewControllers[self.subViewControllers.count - 1]]direction:direction animated:YES completion:^(BOOL finished){
            if ([weakSelf.delegate respondsToSelector:@selector(switchViewControllerToIndex:)]) {
                [weakSelf.delegate switchViewControllerToIndex:index];
            }
        }];

    } else {
        [self.pageController setViewControllers:@[self.subViewControllers[index]] direction:direction animated:YES completion:^(BOOL finished){
            if ([weakSelf.delegate respondsToSelector:@selector(switchViewControllerToIndex:)]) {
                [weakSelf.delegate switchViewControllerToIndex:index];
            }
        }];
    }
    
}


@end
