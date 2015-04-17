//
//  ImageDetailViewController.h
//  FlickUpload
//
//  Created by Serguei Vinnitskii on 4/17/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) UIImage *detailImage;

@end
