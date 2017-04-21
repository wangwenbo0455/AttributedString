//
//  ZLStatus.h
//  TestTexview
//
//  Created by 王文博 on 2017/3/1.
//  Copyright © 2017年 王文博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WBStatus : NSObject
//源内容
@property (nonatomic, copy) NSString *text;
@property (nonatomic,copy)NSAttributedString * yuanAttributeString;

/**	string	信息内容 -- 带有属性的(特殊文字会高亮显示\显示表情)*/
@property (nonatomic, copy) NSAttributedString *attributedText;

@end
