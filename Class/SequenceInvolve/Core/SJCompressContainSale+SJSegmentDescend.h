//
//  SJCompressContainSale+SJSegmentDescend.h
//  Project
//
//  Created by 畅三江 on 2018/8/12.
//  Copyright © 2018 changsanjiang. All rights reserved.
//

#import "SJCompressContainSale.h"
#import <AVFoundation/AVFoundation.h>
#import "SJPlayModel.h"
#import "SJContactIntegrateLatencyControllerDefines.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJCompressContainSale (SJSegmentDescend)
- (nullable instancetype)initWithAVAsset:(__kindof AVAsset *)asset;
- (nullable instancetype)initWithAVAsset:(__kindof AVAsset *)asset
                               playModel:(__kindof SJPlayModel *)model;
- (nullable instancetype)initWithAVAsset:(__kindof AVAsset *)asset
                           startPosition:(NSTimeInterval)startPosition
                               playModel:(__kindof SJPlayModel *)model;

- (nullable instancetype)initWithAVPlayerItem:(AVPlayerItem *)item;
- (nullable instancetype)initWithAVPlayerItem:(AVPlayerItem *)item
                                    playModel:(__kindof SJPlayModel *)model;
- (nullable instancetype)initWithAVPlayerItem:(AVPlayerItem *)item
                                startPosition:(NSTimeInterval)startPosition
                                    playModel:(__kindof SJPlayModel *)model;

- (nullable instancetype)initWithAVPlayer:(AVPlayer *)player;
- (nullable instancetype)initWithAVPlayer:(AVPlayer *)player
                                playModel:(__kindof SJPlayModel *)model;
- (nullable instancetype)initWithAVPlayer:(AVPlayer *)player
                            startPosition:(NSTimeInterval)startPosition
                                playModel:(__kindof SJPlayModel *)model;

@property (nonatomic, strong, nullable) __kindof AVAsset *reflectAsset;
@property (nonatomic, strong, nullable) AVPlayerItem *reflectMeanItem;
@property (nonatomic, strong, nullable) AVPlayer *reflectMean;

- (nullable instancetype)initWithOtherAsset:(SJCompressContainSale *)otherAsset
                                  playModel:(nullable __kindof SJPlayModel *)model;

@property (nonatomic, strong, readonly, nullable) SJCompressContainSale *original;
- (nullable SJCompressContainSale *)originAsset __deprecated_msg("ues `original`");
@end
NS_ASSUME_NONNULL_END
