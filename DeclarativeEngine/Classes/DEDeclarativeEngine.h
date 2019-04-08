//
//  DEDeclarativeEngine.h
//
//  Created by Bryan Goldstein
//

@interface DEDeclarativeEngine : NSObject

+ (id (^)(id))create:(NSDictionary *)resolvers;

@end
