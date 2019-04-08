//
//  declarative-engineTests.m
//  declarative-engineTests
//
//  Created by Bryan Goldstein on 04/07/2019.
//  Copyright (c) 2019 Bryan Goldstein. All rights reserved.
//

// https://github.com/Specta/Specta

#import "NSArray+Map.h"
#import "DeclarativeEngine.h"

SpecBegin(InitialSpecs)

    // FIXME: obv not the best way to write this
    NSDictionary *tank = [[NSDictionary alloc]
        initWithObjectsAndKeys:
            ^(id obj) {
              NSLog(@"Tank.oneFish");
              return [NSString stringWithFormat:@"that was really good %@",
                                                [obj valueForKey:@"oneFish"]];
            },
            @"oneFish",
            ^(id obj) {
              NSLog(@"Tank.twoFish");
              return [[NSDictionary alloc]
                  initWithObjectsAndKeys:
                      [NSString
                          stringWithFormat:@"%@%@",
                                           [[obj valueForKey:@"twoFish"]
                                               valueForKey:@"arguments"][0],
                                           [[obj valueForKey:@"twoFish"]
                                               valueForKey:@"redFish"]],
                      @"redFish", nil];
            },
            @"twoFish", nil];

NSDictionary *fish =
    [[NSDictionary alloc] initWithObjectsAndKeys:^(id obj) {
      NSLog(@"Fish.redFish");
      return [NSString stringWithFormat:@"that was double good %@",
                                        [obj valueForKey:@"redFish"]];
    },
                                                 @"redFish", nil];

NSDictionary *resolvers = [[NSDictionary alloc]
    initWithObjectsAndKeys:fish, @"Fish", tank, @"Tank",
                           ^(id obj) {
                             if ([obj isKindOfClass:[NSDictionary class]]) {
                               if ([obj valueForKey:@"oneFish"] != nil) {
                                 NSLog(@"typeFromObj == Tank");
                                 return @"Tank";
                               }
                               if ([obj valueForKey:@"redFish"] != nil) {
                                 NSLog(@"typeFromObj == Fish");
                                 return @"Fish";
                               }
                             }
                             NSLog(@"typeFromObj == ?");
                             return @"";
                           },
                           @"typeFromObj", nil];

describe(@"simple use cases", ^{
  it(@"works as expected", ^{
    id (^execute)(NSDictionary *);
    execute = [DeclarativeEngine create:resolvers];

    NSLog(@"starting declarative engine");
    NSDictionary *result = execute([[NSDictionary alloc]
        initWithObjectsAndKeys:@"fish food", @"oneFish",
                               [[NSDictionary alloc]
                                   initWithObjectsAndKeys:@[ @"food" ],
                                                          @"arguments", @"!",
                                                          @"redFish", nil],
                               @"twoFish", nil]);

    expect([result valueForKey:@"oneFish"])
        .to.equal(@"that was really good fish food");
    expect([[result valueForKey:@"twoFish"] valueForKey:@"redFish"])
        .to.equal(@"that was double good food!");
  });

  //   it(@"can do maths", ^{
  //     expect(1).beLessThan(23);
  //   });

  //   it(@"can read", ^{
  //     expect(@"team").toNot.contain(@"I");
  //   });

  //   it(@"will wait and succeed", ^{
  //     waitUntil(^(DoneCallback done) {
  //       done();
  //     });
  //   });
});

SpecEnd
