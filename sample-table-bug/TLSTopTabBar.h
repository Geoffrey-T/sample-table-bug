//
//  TLSTopTabBar.h
//
//
//  Created by geoffrey on 19/10/2016.
//  Copyright © 2016. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TLSTopTabBarViewDelegate <NSObject>
@optional
-(void)willSelectViewControllerAtIndex:(NSInteger)index direction:(UIPageViewControllerNavigationDirection)direction;
@end


@interface TLSTopTabBar : UIView

@property (nonatomic, weak) id<TLSTopTabBarViewDelegate> delegate;
- (void)setupTabBarWithButtonsTitleArray:(NSArray*)buttons;

@end
