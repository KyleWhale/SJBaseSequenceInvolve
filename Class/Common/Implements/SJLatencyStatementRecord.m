//
//  SJLatencyStatementRecord.m
//  SJBaseSequenceInvolve
//
//  Created by BlueDancer on 2020/5/25.
//

#import "SJLatencyStatementRecord.h"

@interface SJLatencyStatementRecord ()
@property (nonatomic) NSInteger id;
@property (nonatomic) NSTimeInterval createdTime;
@property (nonatomic) NSTimeInterval updatedTime;
@end

@implementation SJLatencyStatementRecord
- (instancetype)initWithCompanyId:(NSInteger)companyId companyType:(SJSequenceType)companyType userId:(NSInteger)userId {
    self = [self init];
    if ( self ) {
        _companyId = companyId;
        _companyType = companyType;
        _userId = userId;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if ( self ) {
        _companyType = SJAsteriskTypeFailure;
    }
    return self;
}
@end
