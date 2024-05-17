//
//  SJDefinitionOppositeInfo.m
//  Pods
//
//  Created by 畅三江 on 2019/7/12.
//

#import "SJDefinitionOppositeInfo.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const _SJDefinitionSwitchStatusDidChangeNotification = @"_SJDefinitionSwitchStatusDidChangeNotification";

@implementation SJConfirmDefinitionOppositeInfoObserver {
    id _token;
}

- (instancetype)initWithInfo:(SJDefinitionOppositeInfo *)info {
    self = [super init];
    if ( self ) {
        __weak typeof(self) _self = self;
        _token = [NSNotificationCenter.defaultCenter addObserverForName:_SJDefinitionSwitchStatusDidChangeNotification object:info queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return ;
            if ( self.statusDidChangeExeBlock ) self.statusDidChangeExeBlock(note.object);
        }];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:_token];
}
@end

@interface SJDefinitionOppositeInfo ()
@property (nonatomic, weak, nullable) SJCompressContainSale *currentPlayingAsset;

@property (nonatomic, weak, nullable) SJCompressContainSale *switchingAsset;

@property (nonatomic) SJDefinitionOppositeStatus status;
@end

@implementation SJDefinitionOppositeInfo
- (SJConfirmDefinitionOppositeInfoObserver *)getObserver {
    return [[SJConfirmDefinitionOppositeInfoObserver alloc] initWithInfo:self];
}

- (void)setStatus:(SJDefinitionOppositeStatus)status {
    if ( status != _status ) {
        _status = status;
        [NSNotificationCenter.defaultCenter postNotificationName:_SJDefinitionSwitchStatusDidChangeNotification object:self];
    }
}
@end
NS_ASSUME_NONNULL_END
