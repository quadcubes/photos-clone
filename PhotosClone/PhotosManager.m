//
//  PhotosManager.m
//  PhotosClone
//
//  Created by Sam on 16.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "PhotosManager.h"

@class UIImage;

@interface PhotosManager ()
@property dispatch_queue_t backgroundQueue;
@end

@implementation PhotosManager

+ (id)shared {
    static id _shared = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[PhotosManager alloc] init];
        
    });

    return _shared;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageManager =  [[PHCachingImageManager alloc] init];
        self.backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}


- (void)getAlbums:(void (^)(PHFetchResult<PHAssetCollection *> *))successBlock {
   
    dispatch_async(self.backgroundQueue, ^{
        
        PHFetchOptions *userAlbumsOptions = [[PHFetchOptions alloc] init];
        userAlbumsOptions.includeHiddenAssets = NO;
        userAlbumsOptions.includeAllBurstAssets = NO;
        userAlbumsOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
        
        PHFetchResult<PHAssetCollection *> *albums =
                            [PHAssetCollection
                             fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                             subtype:PHAssetCollectionSubtypeAny
                             options:userAlbumsOptions];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            successBlock(albums);
        });
        
    });
    
}


- (void)getPhotosFromCollection:(PHAssetCollection *)collection
                     withOffset:(NSUInteger)offset
                   successBlock:(void(^)(PHFetchResult<PHAsset *> *photos))block {
    
    dispatch_async(self.backgroundQueue, ^{
        PHFetchOptions *photosOptions = [[PHFetchOptions alloc] init];
        photosOptions.sortDescriptors = @[[[NSSortDescriptor alloc]
                                           initWithKey:@"creationDate" ascending:YES]];
        
        photosOptions.predicate =  [NSPredicate predicateWithFormat:@"mediaType = %d",
                                    PHAssetMediaTypeImage];
        
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection
                                                                   options:photosOptions];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            block(fetchResult);
        });
        
        
    });
    
}


- (void)getImageForPhotoAsset:(PHAsset *)asset
                   targetSize:(CGSize)size
                      options:(PHImageRequestOptions *)options
                  resultBlock:(void(^)(UIImage *image))block {
    
    size.height *= [[UIScreen mainScreen] scale];
    size.width *= [[UIScreen mainScreen] scale];
    
    [[[PhotosManager shared] imageManager]
        requestImageForAsset:asset
        targetSize:size
     contentMode:PHImageContentModeAspectFit
     options:options
     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         
         if (result) {
             block(result);
         }
         
     }];

}

@end
