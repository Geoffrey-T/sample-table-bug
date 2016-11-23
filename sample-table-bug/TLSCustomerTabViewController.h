//
//  TLSCustomerTabViewController.h
//
//
//  Created by geoffrey on 19/10/2016.
//  Copyright © 2016. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLSTopTabBar.h"



@protocol TLSCustomerPageViewControllerDelegate <NSObject>

@optional
- (void)switchViewControllerToIndex:(NSInteger)index;

@end

@interface TLSCustomerTabViewController : UIViewController

///Array containing UIViewControllers to be displayed
@property (strong, nonatomic) NSArray   *subViewControllers;

/// Top Tab bar view
@property (strong, nonatomic) TLSTopTabBar *topTabBar;

///UIPageViewController that serves as the base
@property (strong, nonatomic) UIPageViewController *pageController;

@property (nonatomic, weak) id<TLSCustomerPageViewControllerDelegate> delegate;

@end
