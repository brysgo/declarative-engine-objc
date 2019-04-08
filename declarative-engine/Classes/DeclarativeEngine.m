//
//  DeclarativeEngine.m
//
//  Created by Bryan Goldstein
//

#import "DeclarativeEngine.h"
#import "NSArray+Map.h"

@implementation DeclarativeEngine : NSObject

+ (id (^)(id))create:(NSDictionary *)resolvers {
  id (^execute)(id);

  execute = ^(id obj) {
    NSString * (^typeFromObj)(NSDictionary *);
    typeFromObj = [resolvers valueForKey:@"typeFromObj"];
    if (typeFromObj == nil || ![self isBlock:typeFromObj]) {
      [NSException
           raise:@"typeFromObj resolver is not a block"
          format:@"typeFromObj is a required resolver and must be a block"];
    }
    NSString *type = typeFromObj(obj);

    if (type == nil || [resolvers valueForKey:type] == nil) {
      if ([obj isKindOfClass:[NSString class]] ||
          [obj isKindOfClass:[NSNumber class]]) {
        return obj;
      }

      if ([obj isKindOfClass:[NSArray class]]) {
        return (id)[(NSArray *)obj mapObjectsUsingBlock:^(id o, NSUInteger i) {
          return execute(o);
        }];
      }
    }

    // TODO: add support for type level resolver
    // id (^resolver)(NSDictionary *);
    // resolver = [resolvers valueForKey:type];
    // if (resolver != nil && [self isBlock:resolver]) {
    //   // short circuit field level resolution if a function if provided for
    //   the type return resolver(obj);
    // }

    // TODO: add in promise support
    id result = [[NSMutableDictionary alloc] init];
    [obj enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      NSDictionary *resolverForKey = [resolvers valueForKey:type];
      if (resolverForKey == nil) {
        resolverForKey = [[NSDictionary alloc] init];
      }
      __block id (^resolver)(id);
      resolver = [resolverForKey valueForKey:key];
      if (resolver == nil || ![self isBlock:resolver]) {
        resolver = ^(id o) {
          return [o valueForKey:key];
        };
      }
      NSDictionary *resolverResult = resolver(obj);
      [result setObject:resolverResult forKey:key];
    }];

    return result;
  };

  return execute;
}

+ (BOOL)isBlock:(id)item {
  id block = ^{
  };
  Class blockClass = [block class];
  while ([blockClass superclass] != [NSObject class]) {
    blockClass = [blockClass superclass];
  }
  return [item isKindOfClass:blockClass];
}

@end