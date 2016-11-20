//
//  PhotoGridCollectionViewController.h
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "PhotosManager.h"

@interface PhotoGridCollectionViewController : UICollectionViewController
@property (strong, nonatomic) PHAssetCollection *assetCollection;
@property (strong, nonatomic) PHFetchResult<PHAsset *> *photos;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@end
