//
//  SJAccidentPresenceView.h
//  Pods
//
//  Created by 畅三江 on 2019/3/28.
//

#import <UIKit/UIKit.h>

@protocol SJAccidentPresenceViewDelegate;

NS_ASSUME_NONNULL_BEGIN
@interface SJAccidentPresenceView : UIView
@property (nonatomic, strong, readonly, nullable) UIView *presentView;
@property (nonatomic, weak, nullable) id<SJAccidentPresenceViewDelegate> delegate;
@end

@protocol SJAccidentPresenceViewDelegate <NSObject>
- (void)involveViewWillMoveToWindow:(SJAccidentPresenceView *)playerView;
- (nullable UIView *)presenceView:(SJAccidentPresenceView *)playerView hitTestForView:(nullable __kindof UIView *)view;
@end
NS_ASSUME_NONNULL_END
