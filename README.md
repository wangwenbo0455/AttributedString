# AttributedString
可以转换成表情，@，#话题#，URL 链接等

NSString * str = @"[调皮]如有疑问加我QQ#790974542#或者新浪微博@零八哥 我的微博地址勿喷 http://www.weibo.com/u/1940768835 我的手机号18888888888";
    WBStatus * status = [[WBStatus alloc]init];
    status.text = str;
    _TestTextView.editable = NO;

    _TestTextView.attributedText = status.attributedText;

![image](https://github.com/wangwenbo0455/AttributedString/blob/master/AttributedString/AttributedString/111.gif) 
