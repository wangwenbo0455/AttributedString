//
//  ZLTextPart.h
//  TestTexview
//
//  Created by 王文博 on 2017/3/1.
//  Copyright © 2017年 王文博. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTextPart : NSObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;


@end
