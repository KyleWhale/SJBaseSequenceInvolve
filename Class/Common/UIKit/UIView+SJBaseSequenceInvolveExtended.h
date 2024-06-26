//
//  UIView+SJBaseSequenceInvolveExtended.h
//  SJBaseSequenceInvolve
//
//  Created by 畅三江 on 2019/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (SJBaseSequenceInvolveExtended)

- (BOOL)regularViewAppeared:(UIView *_Nullable)childView insets:(UIEdgeInsets)insets;

- (CGRect)intersectionWithView:(UIView *)view insets:(UIEdgeInsets)insets;

- (__kindof UIResponder *_Nullable)lookupResponderForClass:(Class)cls;

- (__kindof UIView *_Nullable)viewWithProtocol:(Protocol *)protocol tag:(NSInteger)tag;

- (BOOL)regularViewAppearedWithProtocol:(Protocol *)protocol tag:(NSInteger)tag insets:(UIEdgeInsets)insets;

@property (nonatomic) CGFloat sj_x;
@property (nonatomic) CGFloat sj_y;
@property (nonatomic) CGFloat sj_w;
@property (nonatomic) CGFloat sj_h;
@property (nonatomic) CGSize sj_size;
@end

@interface NSObject (SJBaseSequenceInvolveExtended)
- (__kindof UIView *_Nullable)subviewForSelector:(SEL)selector;
@end
NS_ASSUME_NONNULL_END
