//
//  PhotoViewController.h
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.

#import <UIKit/UIKit.h>//
#import "PhotosManager.h"

@interface PhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (assign, nonatomic) NSUInteger photoIndex;
@property (strong, nonatomic) PHAsset *photo;
@end
