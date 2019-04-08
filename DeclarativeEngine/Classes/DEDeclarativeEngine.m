//
//  DEDeclarativeEngine.m
//
//  Created by Bryan Goldstein
//

#import "DEDeclarativeEngine.h"
#import "NSArray+Map.h"

@implementation DEDeclarativeEngine : NSObject

+ (id (^)(id))create:(NSDictionary *)resolvers {
  __block id (^execute)(id);

  execute = ^(id obj) {
    NSLog(@"running execute with %@", obj);
    NSString * (^typeFromObj)(id);
    typeFromObj = [resolvers valueForKey:@"typeFromObj"];
    if (typeFromObj == nil || ![self isBlock:typeFromObj]) {
      [NSException
           raise:@"typeFromObj resolver is not a block"
          format:@"typeFromObj is a required resolver and must be a block"];
    }
    NSLog(@"started getting type");
    NSString *type = typeFromObj(obj);
    NSLog(@"finished getting type %@", type);

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
    for (NSString *key in obj) {
      NSLog(@"resolving fields %@", key);
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
      if (resolverResult != nil) {
        resolverResult = execute(resolverResult);
      }
      [result setObject:resolverResult forKey:key];
    }

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
