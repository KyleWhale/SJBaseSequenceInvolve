//
//  SJAccidentPresenceView.m
//  Pods
//
//  Created by 畅三江 on 2019/3/28.
//

#import "SJAccidentPresenceView.h"
#import "SJAccidentPresenceViewInternal.h"

NS_ASSUME_NONNULL_BEGIN
@interface SJAccidentPresenceView ()
@property (nonatomic, strong, nullable) UIView *presentView;
@end

@implementation SJAccidentPresenceView

- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event {
    UIView *_Nullable view = [super hitTest:point withEvent:event];
    
    if ( [self.delegate respondsToSelector:@selector(presenceView:hitTestForView:)] ) {
        return [self.delegate presenceView:self hitTestForView:view];
    }
    
    return view;
}

- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( self.window != nil ) {
            if ( [self.delegate respondsToSelector:@selector(involveViewWillMoveToWindow:)] ) {
                [self.delegate involveViewWillMoveToWindow:self];
            }
        }
    });
}
@end
NS_ASSUME_NONNULL_END
