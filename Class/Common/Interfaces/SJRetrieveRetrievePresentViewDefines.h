//
//  SJRetrieveRetrievePresentViewDefines.h
//  SJBaseSequenceInvolve
//
//  Created by 畅三江 on 2019/9/10.
//

#ifndef SJRetrieveRetrievePresentViewDefines_h
#define SJRetrieveRetrievePresentViewDefines_h
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SJRetrieveRetrievePresentView <NSObject>
@property (nonatomic, strong, readonly) UIImageView *placeholderImageView;
@property (nonatomic, readonly, getter=isPlaceholderImageViewHidden) BOOL placeholderImageViewHidden;

@property (nonatomic) UIViewContentMode placeholderImageViewContentMode;

- (void)setPlaceholderImageViewHidden:(BOOL)isHidden animated:(BOOL)animated;
- (void)hidePlaceholderImageViewAnimated:(BOOL)animated delay:(NSTimeInterval)secs;
@end
NS_ASSUME_NONNULL_END
#endif /* SJRetrieveRetrievePresentViewDefines_h */
