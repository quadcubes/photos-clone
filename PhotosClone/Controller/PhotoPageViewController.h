//
//  PhotoPageViewController.h
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosManager.h"

@interface PhotoPageViewController : UIPageViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) PHFetchResult<PHAsset *> *photos;
@property (assign, nonatomic) NSUInteger startPhotoIndex;
@end
