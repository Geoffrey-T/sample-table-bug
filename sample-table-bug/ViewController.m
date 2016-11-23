//
//  ViewController.m
//  sample-table-bug
//
//  Created by geoffrey thenot on 23/11/2016.
//  Copyright © 2016 tiller. All rights reserved.
//

#import "ViewController.h"
#import "TLSCustomerInfoContentViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TLSCustomerInfoContentViewController *vc = [[TLSCustomerInfoContentViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.78];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
