//
//  ZLStatus.m
//  TestTexview
//
//  Created by 王文博 on 2017/3/1.
//  Copyright © 2017年 王文博. All rights reserved.
//

#import "WBStatus.h"
#import "WBSpecial.h"
#import "WBTextPart.h"
#import "RegexKitLite.h"
@implementation WBStatus
- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    // 利用text生成attributedText
    self.attributedText = [self attributedTextWithText:text];
}
/**
 *  普通文字 --> 属性文字
 *
 *  @param text 普通文字
 *
 *  @return 属性文字
 */
- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // url链接的规则
    NSString *urlPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(((http[s]{0,1}|ftp)://|)((?:(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d)))\\.){3}(?:25[0-5]|2[0-4]\\d|((1\\d{2})|([1-9]?\\d))))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
//    NSString *phoneNumber =@"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[3578]+\\d{9}|\\d{8}|\\d{7}"
//    ;
    NSString *phoneNumber = @"\\d{3}-\\d{8}|\\d{4}-\\d{7}|\\d{11}";
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern,phoneNumber];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        WBTextPart *part = [[WBTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    // 遍历所有的非特殊字符
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        WBTextPart *part = [[WBTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 排序
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(WBTextPart *part1, WBTextPart *part2) {
        // NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
        // 返回NSOrderedSame:两个一样大
        // NSOrderedAscending(升序):part2>part1
        // NSOrderedDescending(降序):part1>part2
        if (part1.range.location > part2.range.location) {
            // part1>part2
            // part1放后面, part2放前面
            return NSOrderedDescending;
        }
        // part1<part2
        // part1放前面, part2放后面
        return NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"face.plist" ofType:nil];
    NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
    // 按顺序拼接每一段文字
    for (WBTextPart *part in parts) {
        // 等会需要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 表情
            NSString *str = [text substringWithRange:part.range];
            for (int i = 0; i < face.count; i ++) {
                if ([face[i][@"face_name"] isEqualToString:str]) {
                    //face[i][@"png"]就是我们要加载的图片Face
                    //新建文字附件来存放我们的图片,iOS7才新加的对象
                    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                    //给附件添加图片
                    textAttachment.image = [UIImage imageNamed:face[i][@"face_image_name"]];
                    //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                    textAttachment.bounds = CGRectMake(0, -4, 20, 20);
                    //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                   substr = [NSAttributedString attributedStringWithAttachment:textAttachment];

                    break;
                }
            }
        } else if (part.special) { // 非表情的特殊文字
            NSURL *url =[NSURL URLWithString:part.text];
            if (url.scheme) {
                substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                           NSForegroundColorAttributeName : [UIColor redColor]
                                                                                           }];

               NSString *string =@"网页链接";
                            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                                //给附件添加图片
                                textAttachment.image = [UIImage imageNamed:@"链接"];
                                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                                textAttachment.bounds = CGRectMake(0, -6, 25, 25);
                NSMutableAttributedString *tempAttribute = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
                 NSMutableAttributedString *tempAttribute2 = [[NSMutableAttributedString alloc]initWithAttributedString:[NSAttributedString attributedStringWithAttachment:textAttachment]];
                NSMutableAttributedString *text =[[NSMutableAttributedString alloc]initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
                
                NSRange selectRange = NSMakeRange(0,text.length);
                [text addAttribute:NSLinkAttributeName value:url range:selectRange];
                
                
                [tempAttribute appendAttributedString:text];
                substr = [[NSAttributedString alloc]initWithAttributedString:tempAttribute];
                // 创建特殊对象
                
                WBSpecial *s = [[WBSpecial alloc] init];
                s.text = string;
                NSUInteger loc = attributedText.length+tempAttribute2.length;
                NSUInteger len = string.length;
                s.range = NSMakeRange(loc, len);
                s.urlString = part.text;
                [specials addObject:s];
            }else{
                
                NSLog(@"%@",part.text);
                substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{
                                                                                           NSForegroundColorAttributeName : [UIColor redColor]
                                                                                           }];
                // 创建特殊对象
                WBSpecial *s = [[WBSpecial alloc] init];
                s.text = part.text;
                NSUInteger loc = attributedText.length;
                NSUInteger len = part.text.length;
                s.range = NSMakeRange(loc, len);
                s.urlString = part.text;
                [specials addObject:s];
            }
           
            
           
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        if (substr) {
            [attributedText appendAttributedString:substr];
        }
        
    }
    
    // 一定要设置字体,保证计算出来的尺寸是正确的
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
//    [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    return attributedText;
}

@end
