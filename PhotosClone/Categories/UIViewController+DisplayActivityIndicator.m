//
//  UIViewController+DisplayIndicator.m
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "UIViewController+DisplayActivityIndicator.h"

@implementation UIViewController (DisplayActivityIndicator)

- (UIActivityIndicatorView *)createIndicator {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = self.view.center;
    indicator.hidesWhenStopped = YES;
    [self.view addSubview:indicator];
    return indicator;
}

@end
