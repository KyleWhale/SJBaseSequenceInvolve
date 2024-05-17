//
//  UIScrollView+ListViewIncludeAdd.h
//  Masonry
//
//  Created by 畅三江 on 2018/7/9.
//

#import <UIKit/UIKit.h>
#import "SJAccidentPresenceAutoCaptureConfig.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIScrollView (ListViewIncludeAdd)

@property (nonatomic, readonly) BOOL enabledCommand;

- (void)enabledCommandWithConfig:(SJAccidentPresenceAutoCaptureConfig *)autoplayConfig;

- (void)includeDisableReflect;

- (void)removeCurrentAlreadyView;
@end

@interface UIScrollView (SJOverlayAssigns)
@property (nonatomic, strong, nullable, readonly) NSIndexPath *announceCurrentIndexPath;
- (void)setAnnounceCurrentIndexPath:(nullable NSIndexPath *)announceCurrentIndexPath;
@end
NS_ASSUME_NONNULL_END
