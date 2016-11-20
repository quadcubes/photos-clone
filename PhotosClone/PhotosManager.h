//
//  PhotosManager.h
//  PhotosClone
//
//  Created by Sam on 16.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotosManager : NSObject
+ (id)shared;
- (void)getAlbums:(void(^)(PHFetchResult<PHAssetCollection *> *albums)) successBlock;
- (void)getPhotosFromCollection:(PHAssetCollection *)collection
                     withOffset:(NSUInteger)offset
                   successBlock:(void(^)(PHFetchResult<PHAsset *> *photos))block;

- (void)getImageForPhotoAsset:(PHAsset *)asset
                   targetSize:(CGSize)size
                      options:(PHImageRequestOptions *)options
                  resultBlock:(void(^)(UIImage *image))block;

@property (strong, nonatomic) PHCachingImageManager *imageManager;
@end
