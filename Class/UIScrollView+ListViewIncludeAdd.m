//
//  UIScrollView+ListViewIncludeAdd.m
//  Masonry
//
//  Created by 畅三江 on 2018/7/9.
//

#import "UIScrollView+ListViewIncludeAdd.h"
#import "UIScrollView+SJBaseSequenceInvolveExtended.h"
#import "UIView+SJBaseSequenceInvolveExtended.h"
#import "SJBaseSequenceInvolveConst.h"
#import "SJPlayModel.h"
#import <objc/message.h>

#if __has_include(<SJUIKit/NSObject+SJObserverHelper.h>)
#import <SJUIKit/NSObject+SJObserverHelper.h>
#else
#import "NSObject+SJObserverHelper.h"
#endif

#if __has_include(<SJUIKit/SJRunLoopTaskQueue.h>)
#import <SJUIKit/SJRunLoopTaskQueue.h>
#else
#import "SJRunLoopTaskQueue.h"
#endif

@interface UIScrollView (SJTruncateInternal)
@property (nonatomic, strong, nullable) SJAccidentPresenceAutoCaptureConfig *reserveTruncateConfig;
@property (nonatomic, readonly) BOOL reserveScrolledToTop;
@property (nonatomic, readonly) BOOL reserveScrolledToLeft;
@property (nonatomic, readonly) BOOL reserveScrolledToBottom;
@property (nonatomic, readonly) BOOL reserveScrolledToRight;
- (BOOL)truncateAutoTargetViewAppearedForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config atIndexPath:(NSIndexPath *)indexPath;
- (nullable UIView *)truncateTargetViewForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config atIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)truncateGuidelineForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config;
- (UIEdgeInsets)truncatePlayableAreaInsetsForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config;
- (NSArray<NSIndexPath *> *_Nullable)sortedVisibleIndexPaths;
@end


static NSString *const kQueue = @"SJBaseSequenceInvolveAutoplayTaskQueue";
static SJRunLoopTaskQueue *
sj_queue(void) {
    static SJRunLoopTaskQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = SJRunLoopTaskQueue.queue(kQueue).update(CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    });
    return queue;
}

static void sj_readNextProvideAfterEndScroll(__kindof UIScrollView *scrollView);
static void sj_scrollViewContentOffsetDidChange(UIScrollView *scrollView, void(^contentOffsetDidChangeExeBlock)(void));
static void sj_removeContentOffsetObserver(UIScrollView *scrollView);

@implementation UIScrollView (ListViewIncludeAdd)
- (void)setEnabledCommand:(BOOL)enabledCommand {
    objc_setAssociatedObject(self, @selector(enabledCommand), @(enabledCommand), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)enabledCommand {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)enabledCommandWithConfig:(SJAccidentPresenceAutoCaptureConfig *)autoplayConfig {
    self.enabledCommand = YES;
    self.reserveTruncateConfig = autoplayConfig;

    __weak typeof(self) _self = self;
    sj_scrollViewContentOffsetDidChange(self, ^{
        __strong typeof(_self) self = _self;
        if ( !self ) return;
        if ( self.sj_hasDelayedEndScrollTask == YES ) {
            self.sj_hasDelayedEndScrollTask = NO;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sj_readNextProvideAfterEndScroll) object:nil];
        }

        sj_queue().empty();

        if ( self.window == nil ) {
            return;
        }

        sj_queue().enqueue(^{
            self.sj_hasDelayedEndScrollTask = YES;
            [self performSelector:@selector(sj_readNextProvideAfterEndScroll) withObject:nil afterDelay:0.4];
        });
    });
}

- (void)includeDisableReflect {
    self.enabledCommand = NO;
    self.reserveTruncateConfig = nil;
    self.announceCurrentIndexPath = nil;
    sj_removeContentOffsetObserver(self);
}
 
- (void)removeCurrentAlreadyView {
    self.announceCurrentIndexPath = nil;
    [[self viewWithTag:SJAccidentPresenceViewTag] removeFromSuperview];
}

- (void)sj_readNextProvideAfterEndScroll {
    self.sj_hasDelayedEndScrollTask = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        sj_readNextProvideAfterEndScroll(self);
    });
}

- (void)setSj_hasDelayedEndScrollTask:(BOOL)sj_hasDelayedEndScrollTask {
    objc_setAssociatedObject(self, @selector(sj_hasDelayedEndScrollTask), @(sj_hasDelayedEndScrollTask), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sj_hasDelayedEndScrollTask {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end

@interface _SJScrollViewContentOffsetObserver : NSObject
- (instancetype)initWithScrollView:(UIScrollView *)scrollView contentOffsetDidChangeExeBlock:(void(^)(void))block;
@property (nonatomic, copy, readonly) void(^contentOffsetDidChangeExeBlock)(void);
@end

@implementation _SJScrollViewContentOffsetObserver
- (instancetype)initWithScrollView:(UIScrollView *)scrollView contentOffsetDidChangeExeBlock:(void (^)(void))block {
    self = [super init];
    if ( !self ) return nil;
    _contentOffsetDidChangeExeBlock = block;
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrollView sj_addObserver:self forKeyPath:@"contentOffset"];
    });
    return self;
}
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey,id> *)change context:(nullable void *)context {
    _contentOffsetDidChangeExeBlock();
}
@end

static char kObserver;
static void sj_scrollViewContentOffsetDidChange(UIScrollView *scrollView, void(^contentOffsetDidChangeExeBlock)(void)) {
    dispatch_async(dispatch_get_main_queue(), ^{
        _SJScrollViewContentOffsetObserver *_Nullable observer = objc_getAssociatedObject(scrollView, &kObserver);
        if ( observer )
            return;
        observer = [[_SJScrollViewContentOffsetObserver alloc] initWithScrollView:scrollView contentOffsetDidChangeExeBlock:contentOffsetDidChangeExeBlock];
        objc_setAssociatedObject(scrollView, &kObserver, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

static void sj_removeContentOffsetObserver(UIScrollView *scrollView) {
    dispatch_async(dispatch_get_main_queue(), ^{
        objc_setAssociatedObject(scrollView, &kObserver, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

#pragma mark -

static void sj_readNextProvideAfterEndScroll(__kindof __kindof UIScrollView *self) {
    if ( self.window == nil ) {
        return;
    }
    
    NSArray<NSIndexPath *> *_Nullable sortedVisibleIndexPaths = [self sortedVisibleIndexPaths];
    if ( sortedVisibleIndexPaths.count < 1 )
        return;
    
    SJAccidentPresenceAutoCaptureConfig *config = [self reserveTruncateConfig];
    NSIndexPath *_Nullable current = [self announceCurrentIndexPath];

    UICollectionViewScrollDirection scrollDirection = config.scrollDirection;
    switch ( scrollDirection ) {
        case UICollectionViewScrollDirectionVertical:
            if ( !self.reserveScrolledToTop && !self.reserveScrolledToBottom &&
                 [self truncateAutoTargetViewAppearedForConfiguration:config atIndexPath:current] )
                return;
            break;
        case UICollectionViewScrollDirectionHorizontal:
            if ( !self.reserveScrolledToLeft && !self.reserveScrolledToRight &&
                 [self truncateAutoTargetViewAppearedForConfiguration:config atIndexPath:current] )
                return;
            break;
    }
    
    NSIndexPath *_Nullable next = nil;

    CGFloat guideline = [self truncateGuidelineForConfiguration:config];
    
    if ( guideline < 0 )
        return;
    
    NSInteger count = sortedVisibleIndexPaths.count;
    CGFloat subs = CGFLOAT_MAX;
    for ( NSInteger i = 0 ; i < count ; ++ i ) {
        NSIndexPath *indexPath = sortedVisibleIndexPaths[i];
        UIView *_Nullable target = [self truncateTargetViewForConfiguration:config atIndexPath:indexPath];
        if ( !target ) continue;
        UIEdgeInsets playableAreaInsets = [self truncatePlayableAreaInsetsForConfiguration:config];
        CGRect intersection = [self intersectionWithView:target insets:playableAreaInsets];
        CGFloat result = CGFLOAT_MAX;
        switch ( scrollDirection ) {
            case UICollectionViewScrollDirectionVertical:
                if ( intersection.size.height != 0 ) result = floor(ABS(guideline - CGRectGetMidY(intersection)));
                break;
            case UICollectionViewScrollDirectionHorizontal:
                if ( intersection.size.width != 0 ) result = floor(ABS(guideline - CGRectGetMidX(intersection)));
                break;
        }
        
        if ( result < subs ) {
            subs = result;
            next = indexPath;
        }
    }
    
    if ( next != nil && ![next isEqual:current] ) [config.autoCaptureDelegate involveNeedNewReflectAtIndexPath:next];
}


@implementation UIScrollView (SJTruncateInternal)

- (BOOL)reserveScrolledToTop {
    return floor(self.contentOffset.y) == 0;
}

- (BOOL)reserveScrolledToLeft {
    return floor(self.contentOffset.x) == 0;
}

- (BOOL)reserveScrolledToRight {
    return floor(self.contentOffset.x + self.bounds.size.width) == floor(self.contentSize.width);
}

- (BOOL)reserveScrolledToBottom {
    return floor(self.contentOffset.y + self.bounds.size.height) == floor(self.contentSize.height);
}

- (BOOL)truncateAutoTargetViewAppearedForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config atIndexPath:(NSIndexPath *)indexPath {
    SEL superviewSelector = config.captureSuperviewSelector;
    if ( superviewSelector != NULL )
        return [self isViewAppearedForSelector:superviewSelector insets:config.playableAreaInsets atIndexPath:indexPath];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSInteger superviewTag = config.selectorSuperviewTag;
#pragma clang diagnostic pop
    if ( superviewTag != 0 )
        return [self tchViewAppearedWithTag:superviewTag insets:config.playableAreaInsets atIndexPath:indexPath];
    
    return [self tchViewAppearedWithProtocol:@protocol(SJEnvironSuperHoldModelView) tag:0 insets:config.playableAreaInsets atIndexPath:indexPath];
}

- (nullable UIView *)truncateTargetViewForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config atIndexPath:(NSIndexPath *)indexPath {
    SEL superviewSelector = config.captureSuperviewSelector;
    if ( superviewSelector != NULL ) {
        return [self viewForSelector:superviewSelector atIndexPath:indexPath];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSInteger superviewTag = config.selectorSuperviewTag;
#pragma clang diagnostic pop
        return superviewTag != 0 ?
                 [self viewWithTag:superviewTag atIndexPath:indexPath] :
                 [self viewWithProtocol:@protocol(SJEnvironSuperHoldModelView) tag:0 atIndexPath:indexPath];
    }
}

- (CGFloat)truncateGuidelineForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config {
    CGFloat guideline = 0;
    switch ( config.scrollDirection ) {
        case UICollectionViewScrollDirectionVertical: {
            if      ( self.reserveScrolledToTop ) {
                // nothing
            }
            else if ( self.reserveScrolledToBottom ) {
                guideline = self.contentSize.height;
            }
            else {
                if (@available(iOS 11.0, *))
                    guideline = floor((CGRectGetHeight(self.bounds) - self.adjustedContentInset.top) * 0.5);
                else
                    guideline = floor((CGRectGetHeight(self.bounds) - self.contentInset.top) * 0.5);
            }
        }
            break;
        case UICollectionViewScrollDirectionHorizontal: {
            if      ( self.reserveScrolledToLeft ) {
                // nothing
            }
            else if ( self.reserveScrolledToBottom ) {
                guideline = self.contentSize.width;
            }
            else {
                if (@available(iOS 11.0, *))
                    guideline = floor((CGRectGetWidth(self.bounds) - self.adjustedContentInset.left) * 0.5);
                else
                    guideline = floor((CGRectGetWidth(self.bounds) - self.contentInset.left) * 0.5);
            }
        }
            break;
    }
    return guideline;
}

- (UIEdgeInsets)truncatePlayableAreaInsetsForConfiguration:(SJAccidentPresenceAutoCaptureConfig *)config {
    UIEdgeInsets insets = config.playableAreaInsets;
    switch ( config.scrollDirection ) {
        case UICollectionViewScrollDirectionVertical:
            if ( self.reserveScrolledToTop ) insets.top = 0;
            else if ( self.reserveScrolledToBottom ) insets.bottom = 0;
            break;
        case UICollectionViewScrollDirectionHorizontal:
            if ( self.reserveScrolledToLeft ) insets.left = 0;
            else if ( self.reserveScrolledToRight ) insets.right = 0;
            break;
    }
    return insets;
}

- (void)setReserveTruncateConfig:(nullable SJAccidentPresenceAutoCaptureConfig *)reserveTruncateConfig {
    objc_setAssociatedObject(self, @selector(reserveTruncateConfig), reserveTruncateConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (nullable SJAccidentPresenceAutoCaptureConfig *)reserveTruncateConfig {
    return objc_getAssociatedObject(self, _cmd);
}

- (NSArray<NSIndexPath *> *_Nullable)sortedVisibleIndexPaths {
    NSArray<NSIndexPath *> *_Nullable visibleIndexPaths = nil;
    if ( [self isKindOfClass:[UITableView class]] )
        visibleIndexPaths = [(UITableView *)self indexPathsForVisibleRows];
    else if ( [self isKindOfClass:[UICollectionView class]] )
        visibleIndexPaths = [[(UICollectionView *)self indexPathsForVisibleItems] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
    return visibleIndexPaths;
}
@end

@implementation UIScrollView (SJOverlayAssigns)
- (void)setAnnounceCurrentIndexPath:(nullable NSIndexPath *)announceCurrentIndexPath {
    objc_setAssociatedObject(self, @selector(announceCurrentIndexPath), announceCurrentIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSIndexPath *)announceCurrentIndexPath {
    return objc_getAssociatedObject(self, _cmd);
}

@end
