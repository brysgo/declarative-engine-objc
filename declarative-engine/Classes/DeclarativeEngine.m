//
//  DeclarativeEngine.m
//
//  Created by Bryan Goldstein
//

#import "DeclarativeEngine.h"
#import "NSArray+Map.h"

@implementation DeclarativeEngine : NSObject

- (id (^)(NSDictionary *))create:(NSDictionary *)resolvers {
  id (^execute)(NSDictionary *);

  execute = ^(id obj) {
    NSString * (^typeFromObj)(NSDictionary *);
    typeFromObj = [resolvers valueForKey:@"typeFromObj"];
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

    id (^resolver)(NSDictionary *);
    resolver = [resolvers valueForKey:type];
    if ([self isBlock:resolver]) {
      // short circuit field level resolution if a function if provided for the
      // type
      return resolver(obj);
    }

    // const promises = [];
    // const result = Object.keys(obj).reduce((acc, cur) => {
    //   const resolver = (resolvers[type] || {})[cur] || defaultResolver(cur);
    //   const resolverResult = resolver(obj);
    //   if (isPromise(resolverResult)) {
    //     promises.push(resolverResult);
    //     resolverResult.then(res => (acc[cur] = execute(res)));
    //   } else {
    //     acc[cur] = execute(resolverResult);
    //   }
    //   return acc;
    // }, {});
    // if (promises.length === 0) {
    //   return result;
    // } else {
    //   return Promise.all(promises).then(() => result);
    // }

    return obj;
  };

  return execute;
}

- (BOOL)isBlock:(id)item {
  id block = ^{
  };
  Class blockClass = [block class];
  while ([blockClass superclass] != [NSObject class]) {
    blockClass = [blockClass superclass];
  }
  return [item isKindOfClass:blockClass];
}

@end