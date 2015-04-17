//
//  PhotoHistoryData.h
//  FlickUpload
//
//  Created by Serguei Vinnitskii on 4/17/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import <Foundation/Foundation.h>

//Singleton object
@interface PhotoHistoryData : NSObject

+(PhotoHistoryData *)sharedData;

-(NSArray *)getPhotos;
-(void)addPhoto:(NSString *)path;

@end
