//
//  ContentTags.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/11.
//

#import "ContentTags.h"

@interface ContentTags ()

@property (nonatomic, strong) NSArray <TagModel *> *tagModels;

@end

@implementation ContentTags

- (instancetype)init {
    self = [super init];
    if (self) {
        self.myHeight = MyLayoutSize.wrap;
        self.autoArrange = YES;
        self.subviewHSpace = 12;
        self.subviewVSpace = 6;
        self.orientation = MyOrientation_Vert;
        self.arrangedCount = 0;
    }
    return self;
}

- (void)setModels:(NSArray <TagModel *> *)models {
    self.tagModels = [NSArray arrayWithArray:models];
    
    [self removeAllSubviews];
    
    for (int i = 0; i < models.count; i++) {
        [self addSubview:[self createTagButton:models[i].name withIndex:i]];
    }
}

- (UIButton *)createTagButton:(NSString *)text withIndex:(NSInteger)index {
    UIButton *tagButton = [UIButton new];
    [tagButton setTitle:text forState:UIControlStateNormal];
    [tagButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [tagButton setBackgroundColor:[UIColor lightMainColor] forState:UIControlStateHighlighted];
    tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
    tagButton.layer.cornerRadius = 14;
    tagButton.layer.masksToBounds = YES;
    tagButton.layer.borderWidth = 1;
    tagButton.layer.borderColor = [UIColor mainColor].CGColor;
    tagButton.tag = index;
    //这里可以看到尺寸宽度等于自己的尺寸宽度并且再增加10，且最小是40，意思是按钮的宽度是等于自身内容的宽度再加10，但最小的宽度是40
    //如果没有这个设置，而是直接调用了sizeToFit则按钮的宽度就是内容的宽度。
    tagButton.widthSize.equalTo(@(MyLayoutSize.wrap)).add(20).min(40);
    tagButton.heightSize.equalTo(@(MyLayoutSize.wrap));
    [tagButton sizeToFit];
    [tagButton addTarget:self action:@selector(handleTapped:) forControlEvents:UIControlEventTouchUpInside];
    return tagButton;
}

- (void)handleTapped:(UIButton *)sender {
    NSLog(@"%@", self.tagModels[sender.tag].tagId);
}

@end
