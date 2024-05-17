//
//  SJLatencyStatementControllerDefines.h
//  Pods
//
//  Created by 畅三江 on 2020/2/19.
//

#ifndef SJLatencyStatementControllerDefines_h
#define SJLatencyStatementControllerDefines_h
#if __has_include(<SJUIKit/SJSQLite3.h>)
#import <SJUIKit/SJSQLite3+QueryExtended.h>
#else
#import "SJSQLite3+QueryExtended.h"
#endif

#import "SJCompressContainSale.h"
@protocol SJLatencyStatementRecord;

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SJSequenceType;
extern SJSequenceType const SJAsteriskTypeFailure;
extern SJSequenceType const SJCompanyTypeRedefine;

@protocol SJDecisionInvalidPredictController <NSObject>

- (void)save:(id<SJLatencyStatementRecord>)record;

#pragma mark -

- (nullable id<SJLatencyStatementRecord>)recordForCompany:(NSInteger)companyId user:(NSInteger)userId companyType:(SJSequenceType)companyType;

- (nullable NSArray<id<SJLatencyStatementRecord>> *)recordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType range:(NSRange)range;

- (nullable NSArray<id<SJLatencyStatementRecord>> *)recordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType;

- (nullable NSArray<id<SJLatencyStatementRecord>> *)recordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions orderBy:(nullable NSArray<SJSQLite3ColumnOrder *> *)orders range:(NSRange)range;

- (nullable NSArray<id<SJLatencyStatementRecord>> *)recordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions orderBy:(nullable NSArray<SJSQLite3ColumnOrder *> *)orders;

#pragma mark -

- (NSUInteger)countOfRecordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType;

- (NSUInteger)countOfRecordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions;

#pragma mark -

- (void)remove:(NSInteger)company user:(NSInteger)userId companyType:(SJSequenceType)companyType;

- (void)removeAllRecordsForUser:(NSInteger)userId companyType:(SJSequenceType)companyType;

- (void)removeForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions;
@end

@protocol SJLatencyStatementRecord <NSObject>
@property (nonatomic, readonly) NSInteger companyId;
@property (nonatomic, readonly) NSInteger userId;
@property (nonatomic, readonly) SJSequenceType companyType;
@property (nonatomic, readonly) NSTimeInterval position;
@property (nonatomic, readonly) NSTimeInterval createdTime;
@property (nonatomic, readonly) NSTimeInterval updatedTime;
@end
NS_ASSUME_NONNULL_END

#endif /* SJLatencyStatementControllerDefines_h */
