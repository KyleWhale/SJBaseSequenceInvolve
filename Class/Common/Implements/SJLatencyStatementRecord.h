//
//  SJLatencyStatementRecord.h
//  SJBaseSequenceInvolve
//
//  Created by BlueDancer on 2020/5/25.
//

#import "SJLatencyStatementControllerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface SJLatencyStatementRecord : NSObject<SJLatencyStatementRecord>
- (instancetype)initWithCompanyId:(NSInteger)companyId companyType:(SJSequenceType)companyType userId:(NSInteger)userId;
@property (nonatomic) NSInteger companyId;
@property (nonatomic) NSInteger userId;
@property (nonatomic) NSTimeInterval position;
@property (nonatomic) SJSequenceType companyType;
@end


@interface SJLatencyStatementRecord (SJPrivate)
@property (nonatomic) NSInteger id;
@property (nonatomic) NSTimeInterval createdTime;
@property (nonatomic) NSTimeInterval updatedTime;
@end
NS_ASSUME_NONNULL_END
