//
//  PersistencyManager.m
//  FlickUpload
//
//  Created by Serguei Vinnitskii on 4/17/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

#import "PersistencyManager.h"

@implementation PersistencyManager

-(NSArray *)getPhotos
{
    NSString *path = [self dataFilePath];
    NSMutableArray *latestArrayVersion = [NSMutableArray arrayWithContentsOfFile:path];
    
    return latestArrayVersion;
}

-(void)addPhoto:(NSString *)fileName
{
    //Get current version of Array and update it
    NSMutableArray *currentArray = [NSMutableArray arrayWithArray:[self getPhotos]];
    [currentArray addObject:fileName];
    
    //Save updated version
    NSString *path = [self dataFilePath];
    [currentArray writeToFile:path atomically:YES];
    
}

-(NSString *) documentsDirectiry {
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return localDir;
}

-(NSString *) dataFilePath {
    return [[self documentsDirectiry] stringByAppendingPathComponent:@"PhotoHistoryUpload.plist"];
}

@end
