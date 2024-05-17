//
//  SJConfuseRecordSaveHandler.m
//  SJContactIntegrate_Example
//
//  Created by BlueDancer on 2020/2/20.
//  Copyright © 2020 changsanjiang. All rights reserved.
//

#if __has_include(<YYModel/YYModel.h>) || __has_include(<YYKit/YYKit.h>)

#import "SJConfuseRecordSaveHandler.h"
#import <objc/message.h>
#import "SJBaseSequenceInvolveConst.h"
#import "SJBaseSequenceInvolve.h"

NS_ASSUME_NONNULL_BEGIN
@implementation SJConfuseRecordSaveHandler {
    SJAccidentPresenceEventObserver *_observer;
    id<SJDecisionInvalidPredictController> _controller;
}

+ (instancetype)shared {
    static id obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [SJConfuseRecordSaveHandler.alloc initWithEvents:SJAccidentPresenceEventMaskAll contentDataHistoryController:SJDecisionInvalidPredictController.shared];
    });
    return obj;
}

- (instancetype)initWithEvents:(SJAccidentPresenceEventMask)events contentDataHistoryController:(id<SJDecisionInvalidPredictController>)controller;
 {
    self = [super init];
    if ( self ) {
        _controller = controller;
        __weak typeof(self) _self = self;
        _observer = [SJAccidentPresenceEventObserver.alloc initWithEvents:events handler:^(id  _Nonnull target, SJAccidentPresenceEvent event) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            [self _target:target event:event];
        }];
    }
    return self;
}

- (void)setEvents:(SJAccidentPresenceEventMask)events {
    _observer.events = events;
}

- (SJAccidentPresenceEventMask)events {
    return _observer.events;
}

- (void)_target:(id)target event:(SJAccidentPresenceEvent)event {
    switch ( event ) {
        case SJAccidentPresenceEventContentDataDidPause: {
            SJBaseSequenceInvolve *involve = target;
            if ( involve.ellipsisRule ) {
                [self _saveForInvolve:involve];
            }
        }
            break;
        case SJAccidentPresenceEventContentDataWillRefresh:
        case SJAccidentPresenceEventURLAssetWillChange:
        case SJAccidentPresenceEventContentDataWillStop:
        case SJAccidentPresenceEventApplicationDidEnterBackground:
        case SJAccidentPresenceEventApplicationWillTerminate:
            [self _saveForInvolve:target];
            break;
        case SJAccidentPresenceEventContentDataControllerWillDeallocate:
            [self _saveForLatencyController:target];
            break;
    }
}

- (void)_saveForInvolve:(SJBaseSequenceInvolve *)involve {
    SJLatencyStatementRecord *record = involve.containSale.record;
    if ( record != nil ) {
        record.position = involve.contentTime;
        [self _saveRecord:record];
    }
}

- (void)_saveForLatencyController:(id<SJContactIntegrateHomebackController>)contentDataController {
    SJLatencyStatementRecord *record = ((SJCompressContainSale *)contentDataController.company).record;
    if ( record != nil ) {
        record.position = contentDataController.contentTime;
        [self _saveRecord:record];
    }
}

- (void)_saveRecord:(SJLatencyStatementRecord *)record {
    [_controller save:record];
}
@end

@implementation SJCompressContainSale (SJConfuseRecordSaveHandlerExtended)
- (void)setRecord:(nullable SJLatencyStatementRecord *)record {
    objc_setAssociatedObject(self, @selector(record), record, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (nullable SJLatencyStatementRecord *)record {
    return objc_getAssociatedObject(self, _cmd);
}
@end


@implementation SJAccidentPresenceEventObserver {
    void(^_block)(id target, SJAccidentPresenceEvent event);
}
- (instancetype)initWithEvents:(SJAccidentPresenceEventMask)events handler:(void(^)(id target, SJAccidentPresenceEvent event))block {
    self = [super init];
    if ( self ) {
        _events = events;
        _block = block;
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_timeControlStatusDidChange:) name:SJContactIntegrateContentDataTimeControlStatusDidChangeNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_URLAssetWillChange:) name:SJContactIntegrateURLAssetWillChangeNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_contentDataWillStop:) name:SJContactIntegrateContentDataWillStopNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_contentDataWillRefresh:) name:SJContactIntegrateContentDataWillRefreshNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didEnterBackground:) name:SJContactIntegrateApplicationDidEnterBackgroundNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_willTerminate:) name:SJContactIntegrateApplicationWillTerminateNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_contentDataControllerWillDeallocate:) name:SJContactIntegrateContentDataControllerWillDeallocateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)_timeControlStatusDidChange:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskContentDataDidPause ) {
        SJBaseSequenceInvolve *involve = note.object;
        if ( involve.ellipsisRule ) {
            if ( _block ) _block(involve, SJAccidentPresenceEventContentDataDidPause);
        }
    }
}

- (void)_URLAssetWillChange:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskURLAssetWillChange ) {
        if ( _block ) _block(note.object, SJAccidentPresenceEventURLAssetWillChange);
    }
}

- (void)_contentDataWillStop:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskContentDataWillStop ) {
        if ( _block ) _block(note.object, SJAccidentPresenceEventContentDataWillStop);
    }
}

- (void)_contentDataWillRefresh:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskContentDataWillRefresh ) {
        if ( _block ) _block(note.object, SJAccidentPresenceEventContentDataWillRefresh);
    }
}

- (void)_didEnterBackground:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskApplicationDidEnterBackground ) {
        if ( _block ) _block(note.object, SJAccidentPresenceEventApplicationDidEnterBackground);
    }
}

- (void)_willTerminate:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskApplicationWillTerminate ) {
        if ( _block ) _block(note.object, SJAccidentPresenceEventApplicationWillTerminate);
    }
}

- (void)_contentDataControllerWillDeallocate:(NSNotification *)note {
    if ( _events & SJAccidentPresenceEventMaskContentDataControllerWillDeallocate ) {
        if ( _block ) _block(note.object, SJAccidentPresenceEventContentDataControllerWillDeallocate);
    }
}
@end
NS_ASSUME_NONNULL_END

#endif
