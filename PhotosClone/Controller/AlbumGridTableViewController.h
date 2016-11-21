//
//  AlbumGridTableViewController.h
//  PhotosClone
//
//  Created by Sam on 20.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumGridTableViewController : UITableViewController <PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) PHFetchResult<PHAssetCollection *> *albums;
@end
