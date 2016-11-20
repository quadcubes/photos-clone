//
//  PhotoViewController.m
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//
#import "PhotosManager.h"
#import "PhotoViewController.h"

@interface PhotoViewController ()
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *titleDateFormater = [[NSDateFormatter alloc] init];
    [titleDateFormater setDateFormat:@"d MMMM"];
    self.parentViewController.navigationItem.title = [titleDateFormater
                                                      stringFromDate:self.photo.creationDate];
    
    [self displayPhoto];
    
}

#pragma mark - Methods
- (void)displayPhoto {
    
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    imageOptions.networkAccessAllowed = YES;
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    CGSize size = self.view.frame.size;
    
    [[PhotosManager shared] getImageForPhotoAsset:self.photo targetSize:size options:imageOptions resultBlock:^(UIImage *image) {
        self.photoImageView.image = image;
    }];
    
}


@end
