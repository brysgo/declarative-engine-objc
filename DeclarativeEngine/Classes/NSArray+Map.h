//
//  NSArray+Map.h
//  declarative-engine
//
//  Created by Goldstein, Bryan (BCG Platinion) on 4/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Map)

- (NSArray *)mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;

@end

NS_ASSUME_NONNULL_END
