//
//  AlbumCollectionViewCell.m
//  PhotosClone
//
//  Created by Sam on 16.11.16.
//  Copyright © 2016 Samvel Mejlumyan. All rights reserved.
//

#import "AlbumTableViewCell.h"


@implementation AlbumTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.albumImageView.layer.cornerRadius = 3.f;
    self.albumImageView.clipsToBounds = YES;
}

@end
