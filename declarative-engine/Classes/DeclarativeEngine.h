//
//  DeclarativeEngine.h
//
//  Created by Bryan Goldstein
//

@interface DeclarativeEngine : NSObject

+ (id (^)(id))create:(NSDictionary *)resolvers;

@end
