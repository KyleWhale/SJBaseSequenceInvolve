//
//  SJConsoleDrumObservation.m
//  player
//
//  Created by 畅三江 on 2023/8/7.
//

#import "SJConsoleDrumObservation.h"

static NSString *kStatus = @"status";
static NSString *kTimeControlStatus = @"timeControlStatus";
static NSString *kReasonForWaitingCompose = @"reasonForWaitingToPlay";

@implementation SJConsoleDrumObservation {
    AVPlayer *_player;
}
- (instancetype)initWithPlayer:(AVPlayer *)player observer:(nonnull id<SJAVPlayerObserver>)observer {
    self = [super init];
    _player = player;
    _observer = observer;
    [self _registerObserver];
    return self;
}

- (void)dealloc {
    [_player removeObserver:self forKeyPath:kStatus context:&kStatus];
    if ( @available(iOS 10.0, *) ) {
        [_player removeObserver:self forKeyPath:kTimeControlStatus context:&kTimeControlStatus];
        [_player removeObserver:self forKeyPath:kReasonForWaitingCompose context:&kReasonForWaitingCompose];
    }
}

- (void)_registerObserver {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew;
    [_player addObserver:self forKeyPath:kStatus options:options context:&kStatus];
    if ( @available(iOS 10.0, *) ) {
        [_player addObserver:self forKeyPath:kTimeControlStatus options:options context:&kTimeControlStatus];
        [_player addObserver:self forKeyPath:kReasonForWaitingCompose options:options context:&kReasonForWaitingCompose];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    id newValue = change[NSKeyValueChangeNewKey];
    BOOL nonNull = newValue != nil && ![newValue isKindOfClass:NSNull.class];
    
    if      ( context == &kStatus ) {
        [_observer player:_player purposeStatusDidChange:nonNull ? [newValue integerValue] : _player.status];
    }
    else if ( @available(iOS 10.0, *) ) {
        if ( context == &kTimeControlStatus ) {
            [_observer player:_player purposeTimeControlStatusDidChange:nonNull ? [newValue integerValue] : _player.timeControlStatus];
        }
        else if ( context == &kReasonForWaitingCompose ) {
            [_observer player:_player reasonForWaitingDidChange:nonNull ? newValue : _player.reasonForWaitingToPlay];
        }
    }
}
@end
