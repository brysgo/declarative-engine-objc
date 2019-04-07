//
//  DeclarativeEngine.h
//
//  Created by Bryan Goldstein
//

@interface DeclarativeEngine : NSObject

- (id (^)(NSDictionary *))create:(NSDictionary *)resolvers;

@end
