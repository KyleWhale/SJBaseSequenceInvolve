//
//  NSString+SJBaseSequenceInvolveExtended.m
//  Pods
//
//  Created by 畅三江 on 2019/12/12.
//

#import "NSString+SJBaseSequenceInvolveExtended.h"

NS_ASSUME_NONNULL_BEGIN
@implementation NSString (SJBaseSequenceInvolveExtended)

+ (instancetype)stringWithContentTime:(NSTimeInterval)time duration:(NSTimeInterval)duration {
    long min = 60;
    long hour = 60 * min;
    
    long hours, seconds, minutes;
    hours = time / hour;
    minutes = (time - hours * hour) / 60;
    seconds = (NSInteger)time % 60;
    if ( duration < hour ) {
        return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }
    else if ( hours < 100 ) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    }
    else {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", hours, minutes, seconds];
    }
}
@end
NS_ASSUME_NONNULL_END
