//
//  AlbumGridTableViewController.m
//  PhotosClone
//
//  Created by Sam on 20.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "PhotosManager.h"
#import "UIViewController+DisplayActivityIndicator.h"

#import "AlbumGridTableViewController.h"
#import "AlbumTableViewCell.h"

#import "PhotoGridCollectionViewController.h"

@implementation AlbumGridTableViewController

static NSString * const reuseIdentifier = @"AlbumCell";
static NSString * const emptyMessageText = @"Please, create album in Photos.";
static NSString * const deniedMessage = @"Access forbidden!";
static NSString * const authorizationText = @"Application has no any permission. To give permissions tap \"Change settings\"";
static NSString * const authorizationButtonText = @"Change Settings";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicator = [self createIndicator];
    [self.indicator startAnimating];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self checkAuthorizationStatus];
    [self displayAlbums];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PHAssetCollection *assetCollection = [self.albums objectAtIndex:indexPath.row];
    
    cell.albumTitleLabel.text = assetCollection.localizedTitle;
    
    [[PhotosManager shared]
     getPhotosFromCollection:assetCollection
     withOffset:0
     successBlock:^(PHFetchResult<PHAsset *> *photos) {
         PHAsset *lastAsset = [photos lastObject];
         cell.albumPhotosCountLabel.text = [NSString stringWithFormat:@"%lu", [photos count]];
         
         [[PhotosManager shared] getImageForPhotoAsset:lastAsset
            targetSize:cell.albumImageView.frame.size
            options:nil
            resultBlock:^(UIImage *image) {
                cell.albumImageView.image = image;
            }];
     }];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showAlbum"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        PHAssetCollection *assetCollection = [self.albums objectAtIndex:indexPath.row];
        PhotoGridCollectionViewController *photoGrid = segue.destinationViewController;
        photoGrid.assetCollection = assetCollection;
    }
    
}


#pragma mark - Helpful methods

- (void)displayAlbums {
    [[PhotosManager shared] getAlbums:^(PHFetchResult<PHAssetCollection *> *albums) {
        self.albums = albums;
        if (albums.count < 1) {
            UILabel *emptyMessage = [[UILabel alloc] initWithFrame:self.tableView.frame];
            if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
                emptyMessage.text = deniedMessage;
            } else {
                emptyMessage.text = emptyMessageText;
            }
            
            emptyMessage.textAlignment = NSTextAlignmentCenter;
            emptyMessage.textColor = [UIColor blackColor];
            self.tableView.backgroundView = emptyMessage;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            self.tableView.backgroundView = nil;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        [self.indicator stopAnimating];
        [self.tableView reloadData];
    }];
}


- (void)checkAuthorizationStatus {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusRestricted:
                [self showDeniedMessage];
                break;
            case PHAuthorizationStatusDenied:
                [self showDeniedMessage];
                break;
            default:
                break;
        }
    }];
}


- (void)showDeniedMessage {
    
    NSString *message = authorizationText;
    
    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
    UIAlertController * alertController = [UIAlertController
                                           alertControllerWithTitle:accessDescription
                                           message:message
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:authorizationButtonText style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    
    [alertController addAction:settingsAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController
     presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self displayAlbums];
}

@end
