//
//  PhotoGridCollectionViewController.m
//  PhotosClone
//
//  Created by Sam on 17.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "PhotosManager.h"
#import "UIViewController+DisplayActivityIndicator.h"

#import "PhotoCollectionViewCell.h"
#import "PhotoPageViewController.h"
#import "PhotoGridCollectionViewController.h"

@implementation PhotoGridCollectionViewController

#pragma mark - CollectionView Configs
static NSUInteger const cellsPerRow = 4;
static NSUInteger const spacingBetweenCell = 2;

static NSString * const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.assetCollection.localizedTitle;
    
    self.indicator = [self createIndicator];
    [self.indicator startAnimating];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self displayPhotos];
    
    
}


- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


- (void)displayPhotos {
    [[PhotosManager shared] getPhotosFromCollection:self.assetCollection withOffset:20 successBlock:^(PHFetchResult<PHAsset *> *photos) {
        self.photos = photos;
        if (photos.count < 1) {
            UILabel *emptyMessage = [[UILabel alloc] initWithFrame:self.collectionView.frame];
            emptyMessage.text = @"The album is empty.";
            emptyMessage.textAlignment = NSTextAlignmentCenter;
            emptyMessage.textColor = [UIColor blackColor];
            self.collectionView.backgroundView = emptyMessage;
        } else {
            self.collectionView.backgroundView = nil;
        }
        [self.indicator stopAnimating];
        [self.collectionView reloadData];
    }];
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    PHAsset *photo = [self.photos objectAtIndex:indexPath.row];
    
    [[PhotosManager shared] getImageForPhotoAsset:photo targetSize:cell.frame.size options:nil resultBlock:^(UIImage *image) {
        cell.photoImageView.image = image;
    }];
    

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (CGRectGetWidth(collectionView.frame) - cellsPerRow * spacingBetweenCell)  / cellsPerRow;
    CGSize size = CGSizeMake(width, width);
    return size;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        PhotoPageViewController *photoPageView = segue.destinationViewController;
        photoPageView.startPhotoIndex = indexPath.row;
        photoPageView.photos = self.photos;
    }
    
 }

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self displayPhotos];
}


@end
