//
//  ZLSpecial.m
//  TestTexview
//
//  Created by 王文博 on 2017/3/1.
//  Copyright © 2017年 王文博. All rights reserved.
//

#import "WBSpecial.h"

@implementation WBSpecial
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.text, NSStringFromRange(self.range)];
}
@end
