//
//  SJBackObservation.m
//  Pods
//
//  Created by 畅三江 on 2019/8/27.
//

#import "SJBackObservation.h"
#import "SJBaseSequenceInvolveConst.h"
#import "SJContactIntegrateLatencyStatusDefines.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJBackObservation {
    NSMutableArray *_tokens;
}
- (instancetype)initWithComment:(__kindof SJBaseSequenceInvolve *)player {
    self = [super init];
    if ( self ) {
        _tokens = NSMutableArray.new;
        _player = player;
        
        __weak typeof(self) _self = self;
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegratereserveStatusDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.reserveStatusDidChangeExeBlock ) self.reserveStatusDidChangeExeBlock(self.player);
            if ( self.backStatusDidChangeBlock ) self.backStatusDidChangeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateContentDataTimeControlStatusDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.timeControlStatusDidChangeExeBlock ) self.timeControlStatusDidChangeExeBlock(self.player);
            if ( self.backStatusDidChangeBlock ) self.backStatusDidChangeBlock(self.player);
        }]];

        if (@available(iOS 14.0, *)) {
            [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegratePictureInPictureStatusDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
                __strong typeof(_self) self = _self;
                if ( !self ) return;
                if ( self.pictureInPictureStatusDidChangeExeBlock ) self.pictureInPictureStatusDidChangeExeBlock(self.player);
            }]];
        }
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateContentDataDidFinishNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.contentDataDidFinishExeBlock ) self.contentDataDidFinishExeBlock(self.player);
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            else if ( self.didPlayToEndTimeExeBlock && [(id)self.player valueForKey:@"finishedReason"] == SJFinishedReasonToEndTimePosition ) self.didPlayToEndTimeExeBlock(self.player);
            #pragma clang diagnostic pop
            if ( self.backStatusDidChangeBlock ) self.backStatusDidChangeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateDefinitionSwitchStatusDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.definitionSwitchStatusDidChangeExeBlock ) self.definitionSwitchStatusDidChangeExeBlock(self.player);
        }]];

        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateContentTimeDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.contentTimeDidChangeExeBlock ) self.contentTimeDidChangeExeBlock(self.player);
        }]];

        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateDurationDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.durationDidChangeExeBlock ) self.durationDidChangeExeBlock(self.player);
        }]];

        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegratePlayableDurationDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.playableDurationDidChangeExeBlock ) self.playableDurationDidChangeExeBlock(self.player);
        }]];

        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegratePresentationSizeDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.presentationSizeDidChangeExeBlock ) self.presentationSizeDidChangeExeBlock(self.player);
        }]];

        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegratedevelopBackTypeDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.developBackTypeDidChangeExeBlock ) self.developBackTypeDidChangeExeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateScreenLockStateDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.screenLockStateDidChangeExeBlock ) self.screenLockStateDidChangeExeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateMutedDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.mutedDidChangeExeBlock ) self.mutedDidChangeExeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateVolumeDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.playerVolumeDidChangeExeBlock ) self.playerVolumeDidChangeExeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateRateDidChangeNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.rateDidChangeExeBlock ) self.rateDidChangeExeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateContentDataDidReplayNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.didReplayExeBlock ) self.didReplayExeBlock(self.player);
        }]];
        
        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateContentDataWillSeekNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.willSeekToTimeExeBlock ) self.willSeekToTimeExeBlock(note.object, [(NSValue *)note.userInfo[SJContactIntegrateNotificationUserInfoKeySeekTime] CMTimeValue]);
        }]];

        [_tokens addObject:[NSNotificationCenter.defaultCenter addObserverForName:SJContactIntegrateContentDataDidSeekNotification object:player queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.didSeekToTimeExeBlock ) self.didSeekToTimeExeBlock(note.object, [(NSValue *)note.userInfo[SJContactIntegrateNotificationUserInfoKeySeekTime] CMTimeValue]);
        }]];
    }
    return self;
}

- (void)dealloc {
    for ( id token in _tokens ) {
        [NSNotificationCenter.defaultCenter removeObserver:token];
    }
}
@end
NS_ASSUME_NONNULL_END
