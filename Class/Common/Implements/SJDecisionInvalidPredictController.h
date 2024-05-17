//
//  SJDecisionInvalidPredictController.h
//  Pods
//
//  Created by 畅三江 on 2020/2/19.
//

#import <Foundation/Foundation.h>
#import "SJLatencyStatementControllerDefines.h"
#import "SJLatencyStatementRecord.h"
#import <objc/message.h>
NS_ASSUME_NONNULL_BEGIN

@interface SJLatencyStatementRecord(SJSQLite3Extended)<SJSQLiteTableModelProtocol>

@end

extern SJSequenceType const SJAsteriskTypeFailure;
extern SJSequenceType const SJCompanyTypeRedefine;

@interface SJDecisionInvalidPredictController : NSObject<SJDecisionInvalidPredictController>
+ (instancetype)shared;
- (instancetype)initWithPath:(NSString *)path;

- (void)save:(SJLatencyStatementRecord *)record;

#pragma mark -

- (nullable SJLatencyStatementRecord *)recordForCompany:(NSInteger)companyId user:(NSInteger)userId companyType:(SJSequenceType)sequenceType;

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForUser:(NSInteger)userId companyType:(SJSequenceType)sequenceType range:(NSRange)range;

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForUser:(NSInteger)userId companyType:(SJSequenceType)sequenceType;

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions orderBy:(nullable NSArray<SJSQLite3ColumnOrder *> *)orders range:(NSRange)range;

- (nullable NSArray<SJLatencyStatementRecord *> *)recordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions orderBy:(nullable NSArray<SJSQLite3ColumnOrder *> *)orders;

#pragma mark -

- (NSUInteger)countOfRecordsForUser:(NSInteger)userId companyType:(SJSequenceType)sequenceType;

- (NSUInteger)countOfRecordsForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions;

#pragma mark -

- (void)remove:(NSInteger)company user:(NSInteger)userId companyType:(SJSequenceType)sequenceType;

- (void)removeAllRecordsForUser:(NSInteger)userId companyType:(SJSequenceType)sequenceType;

- (void)removeForConditions:(nullable NSArray<SJSQLite3Condition *> *)conditions;
@end
NS_ASSUME_NONNULL_END
