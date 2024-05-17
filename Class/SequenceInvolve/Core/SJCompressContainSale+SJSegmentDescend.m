//
//  SJCompressContainSale+SJSegmentDescend.m
//  Project
//
//  Created by 畅三江 on 2018/8/12.
//  Copyright © 2018 changsanjiang. All rights reserved.
//

#import "SJCompressContainSale+SJSegmentDescend.h"
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
@implementation SJCompressContainSale (SJSegmentDescend)
- (nullable instancetype)initWithAVAsset:(__kindof AVAsset *)asset {
    return [self initWithAVAsset:asset playModel:[SJPlayModel new]];
}
- (nullable instancetype)initWithAVAsset:(__kindof AVAsset *)asset playModel:(__kindof SJPlayModel *)playModel {
    return [self initWithAVAsset:asset startPosition:0 playModel:playModel];
}
- (nullable instancetype)initWithAVAsset:(__kindof AVAsset *)asset startPosition:(NSTimeInterval)startPosition playModel:(__kindof SJPlayModel *)playModel {
    if ( asset == nil ) return nil;
    self = [super init];
    if ( self ) {
        self.reflectAsset = asset;
        self.playModel = playModel;
        self.startPosition = startPosition;
    }
    return self;
}

- (nullable instancetype)initWithStandardWaitItem:(AVPlayerItem *)item {
    return [self initWithAVPlayerItem:item playModel:SJPlayModel.new];
}
- (nullable instancetype)initWithAVPlayerItem:(AVPlayerItem *)item playModel:(__kindof SJPlayModel *)model {
    return [self initWithAVPlayerItem:item startPosition:0 playModel:model];
}
- (nullable instancetype)initWithAVPlayerItem:(AVPlayerItem *)item startPosition:(NSTimeInterval)startPosition playModel:(__kindof SJPlayModel *)model {
    if ( item == nil ) return nil;
    self = [super init];
    if ( self ) {
        self.reflectMeanItem = item;
        self.playModel = model;
        self.startPosition = startPosition;
    }
    return self;
}

- (nullable instancetype)initWithAVPlayer:(AVPlayer *)player {
    return [self initWithAVPlayer:player playModel:SJPlayModel.new];
}
- (nullable instancetype)initWithAVPlayer:(AVPlayer *)player playModel:(__kindof SJPlayModel *)model {
    return [self initWithAVPlayer:player startPosition:0 playModel:SJPlayModel.new];
}
- (nullable instancetype)initWithAVPlayer:(AVPlayer *)player startPosition:(NSTimeInterval)startPosition playModel:(__kindof SJPlayModel *)model {
    if ( player == nil ) return nil;
    self = [super init];
    if ( self ) {
        self.reflectMean = player;
        self.playModel = model;
        self.startPosition = startPosition;
    }
    return self;
}
- (void)setReflectAsset:(__kindof AVAsset * _Nullable)reflectAsset {
    objc_setAssociatedObject(self, @selector(reflectAsset), reflectAsset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (nullable __kindof AVAsset *)reflectAsset {
    if ( self.original != nil ) return self.original.reflectAsset;
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setReflectMeanItem:(AVPlayerItem * _Nullable)reflectMeanItem {
    objc_setAssociatedObject(self, @selector(reflectMeanItem), reflectMeanItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (nullable AVPlayerItem *)reflectMeanItem {
    if ( self.original != nil ) return self.original.reflectMeanItem;
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setReflectMean:(AVPlayer * _Nullable)reflectMean {
    objc_setAssociatedObject(self, @selector(reflectMean), reflectMean, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (nullable AVPlayer *)reflectMean {
    if ( self.original != nil ) return self.original.reflectMean;
    return objc_getAssociatedObject(self, _cmd);
}

- (nullable instancetype)initWithOtherAsset:(SJCompressContainSale *)otherAsset playModel:(nullable __kindof SJPlayModel *)model {
    if ( !otherAsset ) return nil;
    self = [super init];
    if ( self ) {
        SJCompressContainSale *curr = otherAsset;
        while ( curr.original != nil && curr != curr.original ) {
            curr = curr.original;
        }
        self.original = curr;
        self.companyURL = curr.companyURL;
        self.playModel = model?:[SJPlayModel new];
    }
    return self;
}

- (void)setOriginal:(SJCompressContainSale * _Nullable)original {
    objc_setAssociatedObject(self, @selector(original), original, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (nullable SJCompressContainSale *)original {
    return objc_getAssociatedObject(self, _cmd);
}
- (nullable SJCompressContainSale *)originAsset __deprecated_msg("ues `original`") {
    return self.original;
}
@end
NS_ASSUME_NONNULL_END
