//
//  PhotoPageViewController.m
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoPageViewController.h"


@implementation PhotoPageViewController
static NSString * const contextControllerIdentifier = @"PhotoViewController";

- (void)viewDidLoad {
    [super viewDidLoad];
    PhotoViewController *photoVC = [self photoViewControllerAtIndex:self.startPhotoIndex];
    
    if (photoVC != nil) {
        self.dataSource = self;
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self setViewControllers:@[photoVC]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:NULL];
    }
}


#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pvc
      viewControllerBeforeViewController:(PhotoViewController *)vc {
    
    NSUInteger previousIndex = ((NSInteger)vc.photoIndex - 1);
    return [self photoViewControllerAtIndex:previousIndex];
    
}


- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc {
    
    NSUInteger nextIndex = vc.photoIndex + 1;
    return [self photoViewControllerAtIndex:nextIndex];
    
}


#pragma mark - Photo view content

- (PhotoViewController *)photoViewControllerAtIndex:(NSUInteger)index {
    PhotoViewController *photoVC = nil;
    
    if (index < [self.photos count] ) {
        photoVC = [self.parentViewController.storyboard
                   instantiateViewControllerWithIdentifier:contextControllerIdentifier];
        
        if (photoVC) {
            photoVC.photoIndex = index;
            photoVC.photo = [self.photos objectAtIndex:index];
        }
    }
    
    return photoVC;
}

@end
