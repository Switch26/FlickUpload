//
//  PhotoHistoryData.m
//  FlickUpload
//
//  Created by Serguei Vinnitskii on 4/17/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import "PhotoHistoryData.h"
#import "PersistencyManager.h"

@interface PhotoHistoryData () {
    PersistencyManager *persistencyManager;
}

@end

@implementation PhotoHistoryData

+(PhotoHistoryData *)sharedData {
    static PhotoHistoryData *sharedData = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once (&oncePredicate, ^{
        sharedData = [[PhotoHistoryData alloc] init];
    });
    return sharedData;
}

-(id) init {
    self = [super init];
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
    }
    return self;
}

-(NSArray *)getPhotos{
    return [persistencyManager getPhotos];
}

-(void)addPhoto:(NSString *)path{
    [persistencyManager addPhoto:path];
}

@end
