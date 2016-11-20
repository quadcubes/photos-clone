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


@interface AlbumGridTableViewController () <PHPhotoLibraryChangeObserver>
@property (strong, nonatomic) PHFetchResult<PHAssetCollection *> *albums;
@end


@implementation AlbumGridTableViewController

static NSString * const reuseIdentifier = @"AlbumCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicator = [self createIndicator];
    [self.indicator startAnimating];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [self displayAlbums];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                [self displayAlbums];
                break;
            case PHAuthorizationStatusRestricted:
                [self checkAccess];
                break;
            case PHAuthorizationStatusDenied:
                NSLog(@"denied");
                [self checkAccess];
                break;
            default:
                break;
        }
    }];
    
    
    [self checkAccess];
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    }
    
    
    PHAssetCollection *assetCollection = [self.albums objectAtIndex:indexPath.row];
    
    
    cell.albumTitleLabel.text = assetCollection.localizedTitle;
    
    [[PhotosManager shared]
     getPhotosFromCollection:assetCollection
     withOffset:0
     successBlock:^(PHFetchResult<PHAsset *> *photos) {
         PHAsset *lastAsset = [photos lastObject];
         cell.albumPhotosCountLabel.text = [NSString stringWithFormat:@"%d",
                                            (int)[photos count]];
         
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
    __weak AlbumGridTableViewController *weakSelf = self;
    [[PhotosManager shared] getAlbums:^(PHFetchResult<PHAssetCollection *> *albums) {
        weakSelf.albums = albums;
        if (albums.count < 1) {
            UILabel *emptyMessage = [[UILabel alloc] initWithFrame:weakSelf.tableView.frame];
            emptyMessage.text = @"Please, create album in Photos.";
            emptyMessage.textAlignment = NSTextAlignmentCenter;
            emptyMessage.textColor = [UIColor blackColor];
            weakSelf.tableView.backgroundView = emptyMessage;
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        } else {
            weakSelf.tableView.backgroundView = nil;
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        [weakSelf.indicator stopAnimating];
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self displayAlbums];
}

- (void)checkAccess {
    
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        
        NSString *message = @"Application has no any permission. To give permissions tap \"Change settings\"";
        
        NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
        UIAlertController * alertController = [UIAlertController
                                               alertControllerWithTitle:accessDescription
                                               message:message
                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Change Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alertController addAction:settingsAction];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController
         presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

@end
