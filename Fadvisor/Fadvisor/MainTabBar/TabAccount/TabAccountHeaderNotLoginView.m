//
//  TabAccountHeaderNotLogin.m
//  Fadvisor
//
//  Created by 韩建伟 on 2023/12/19.
//

#import "TabAccountHeaderNotLoginView.h"

@implementation TabAccountHeaderNotLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.orientation = MyOrientation_Vert;
        self.myHorzMargin = 0;
        self.backgroundColor = [UIColor blueColor];
        self.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        [self setTarget:self action:@selector(handleMainLoginClick:)];
        
        UILabel *loginTextLable = [[UILabel alloc] init];
        loginTextLable.text = @"点我登录";
        loginTextLable.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        [loginTextLable sizeToFit];
        [self addSubview:loginTextLable];
        
        UIImageView *rightArr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_right_arr"]];
        rightArr.size = CGSizeMake(32, 32);
        [self addSubview:rightArr];
        
    }
    return self;
}

-(void)handleMainLoginClick:(MyBaseLayout*)sender{
    
    [self.delegate mainLoginClick:self];
}


@end
