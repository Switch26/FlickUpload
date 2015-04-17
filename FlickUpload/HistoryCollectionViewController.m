//
//  HistoryCollectionViewController.m
//  FlickUpload
//
//  Created by Serguei Vinnitskii on 4/16/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import "HistoryCollectionViewController.h"
#import "MyCollectionViewCell.h"
#import "ImageDetailViewController.h"
#import "PhotoHistoryData.h"

@interface HistoryCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation HistoryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.collectionView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    MyCollectionViewCell *cell = (MyCollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    ImageDetailViewController *imageDetailViewController = (ImageDetailViewController *)segue.destinationViewController;
    
    NSArray *uploadedPhotosArray = [[PhotoHistoryData sharedData]getPhotos];
    UIImage *image = [self getImageWithFileName:uploadedPhotosArray[indexPath.row]];
    
    imageDetailViewController.detailImage = image;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[PhotoHistoryData sharedData]getPhotos].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSArray *uploadedPhotosArray = [[PhotoHistoryData sharedData]getPhotos];
    UIImage *image = [self getImageWithFileName:uploadedPhotosArray[indexPath.row]];
    cell.imageView.image = image;
    
    return cell;
}

// Get images from documents directory with given file name
- (UIImage *) getImageWithFileName:(NSString *)fileName
{
    // Get a relative file path from the local documents directory
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:fileName];
    
    //Retreive image
    NSData *imageData = [NSData dataWithContentsOfFile:localPath];
    
    return [[UIImage alloc] initWithData:imageData];
}

@end
