//
//  AVAsset+KIAdditions.m
//  Test
//
//  Created by 杨 烽 on 14/11/25.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import "AVAsset+KIAdditions.h"

@implementation AVAsset (KIAdditions)

- (AVMetadataItem *)metadataItemWithKey:(NSString *)key {
    NSArray *items = [AVMetadataItem metadataItemsFromArray:self.commonMetadata withKey:key keySpace:AVMetadataKeySpaceCommon];
    return items.firstObject;
}

- (AVMetadataItem *)artistMetadataItem {
    AVMetadataItem *metadataItem = [self metadataItemWithKey:AVMetadataCommonKeyArtist];
    return metadataItem;
}

- (NSString *)artist {
    return self.artistMetadataItem.stringValue;
}

- (AVMetadataItem *)albumMetadataItem {
    AVMetadataItem *metadataItem = [self metadataItemWithKey:AVMetadataCommonKeyAlbumName];
    return metadataItem;
}

- (NSString *)albumName {
    return self.albumMetadataItem.stringValue;
}

- (AVMetadataItem *)titleMetadataItem {
    AVMetadataItem *metadataItem = [self metadataItemWithKey:AVMetadataCommonKeyTitle];
    return metadataItem;
}

- (NSString *)title {
    return self.titleMetadataItem.stringValue;
}

- (NSTimeInterval)totalSeconds {
    return CMTimeGetSeconds(self.duration);
}

- (AVAssetReader *)assetReader {
    AVURLAsset *urlAsset = (AVURLAsset *)self;
    NSURL *url = [urlAsset URL];
    
    //如果是本地文件，则不用缓存
    if ([url isFileURL]) {
        return nil;
    }
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionAudioSoundTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                     preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [compositionAudioSoundTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, urlAsset.duration)
                                        ofTrack:[[urlAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero
                                          error:nil];
    
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:compositionAudioSoundTrack.asset error:nil];
    [reader setTimeRange:CMTimeRangeMake(kCMTimeZero, kCMTimePositiveInfinity)];
    
    NSMutableArray *outputs = [[NSMutableArray alloc] init];
    for (id track in [compositionAudioSoundTrack.asset tracks]) {
        AVAssetReaderTrackOutput *trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:nil];
        [outputs addObject:trackOutput];
        [reader addOutput:trackOutput];
    }
    
    [reader startReading];
    
    return reader;
}

//- (BOOL)cacheToFile:(NSString *)filePath {
//    if (filePath == nil) {
//#ifdef DEBUG
//        NSLog(@"缓存音乐文件：文件路径为nil，不能缓存");
//#endif
//        return NO;
//    }
//    
//    AVAssetReader *assetReader = [self assetReader];
//    
//    if (assetReader == nil) {
//#ifdef DEBUG
//        NSLog(@"缓存音乐文件：已经为本地文件，不能缓存");
//#endif
//        return YES;
//    }
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    if (![fileManager fileExistsAtPath:filePath]) {
//        [fileManager createFileAtPath:filePath
//                             contents:[[NSData alloc] init]
//                           attributes:nil];
//        
//    } else {
//#ifdef DEBUG
//        NSLog(@"缓存音乐文件：文件已经存在，将替换原文件");
//#endif
//    }
//    
//#ifdef DEBUG
//    NSLog(@"缓存音乐文件: %@", filePath);
//#endif
//    
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
//    
//    AVAssetReaderOutput *output = assetReader.outputs[0];
//    
//    int totalBuff = 0;
//    
//    while (YES) {
//        CMSampleBufferRef ref = [output copyNextSampleBuffer];
//        
//        if (ref == NULL) {
//            break;
//        }
//        
//        AudioBufferList audioBufferList;
//        NSMutableData *data = [[NSMutableData alloc] init];
//        
//        CMBlockBufferRef blockBuffer;
//        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(ref,
//                                                                NULL,
//                                                                &audioBufferList,
//                                                                sizeof(audioBufferList),
//                                                                NULL,
//                                                                NULL,
//                                                                0, &blockBuffer);
//        if (blockBuffer == NULL) {
//            data = nil;
//            continue;
//        }
//        
//        if (&audioBufferList == NULL) {
//            data = nil;
//            continue;
//        }
//        
//        for (int i=0; i<audioBufferList.mNumberBuffers; i++) {
//            AudioBuffer audioBuffer = audioBufferList.mBuffers[i];
//            Float32 *frame = (Float32 *)audioBuffer.mData;
//            [data appendBytes:frame length:audioBuffer.mDataByteSize];
//        }
//        
//        totalBuff++;
//        
//        CFRelease(blockBuffer);
//        CFRelease(ref);
//        ref = NULL;
//        blockBuffer = NULL;
//        
//        [fileHandle writeData:data];
//        data = nil;
//    }
//    [fileHandle closeFile];
//    
//    //id3
//    ID3v2_tag *tag = load_tag([filePath UTF8String]);
//    if (tag == NULL) {
//        tag = new_tag();
//    }
//    if (self.title != nil) {
//        tag_set_title((char *)[[self title] UTF8String], 3, tag);
//    }
//    
//    if (self.albumName != nil) {
//        tag_set_album((char *)[[self albumName] UTF8String], 3, tag);
//    }
//    
//    if (self.artist != nil) {
//        tag_set_artist((char *)[[self artist] UTF8String], 3, tag);
//    }
//    
//    set_tag([filePath UTF8String], tag);
//    
//    return YES;
//}

@end
