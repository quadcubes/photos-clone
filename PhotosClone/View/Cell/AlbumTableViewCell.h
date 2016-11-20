//
//  AlbumCollectionViewCell.h
//  PhotosClone
//
//  Created by Sam on 16.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumPhotosCountLabel;
@end
