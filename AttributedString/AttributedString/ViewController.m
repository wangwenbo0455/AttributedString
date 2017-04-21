//
//  ViewController.m
//  AttributedString
//
//  Created by 王文博 on 2017/4/21.
//  Copyright © 2017年 王文博. All rights reserved.
//

#import "ViewController.h"
#import "WBStatus.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *TestTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    NSString * str = @"[调皮]如有疑问加我QQ#790974542#或者新浪微博@零八哥 我的微博地址勿喷 http://www.weibo.com/u/1940768835 我的手机号18888888888";
    WBStatus * status = [[WBStatus alloc]init];
    status.text = str;
    _TestTextView.editable = NO;

    _TestTextView.attributedText = status.attributedText;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
