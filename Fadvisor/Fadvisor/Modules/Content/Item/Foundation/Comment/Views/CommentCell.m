//
//  CommentCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/2/25.
//

#import "CommentCell.h"
#import "CommentView.h"

@interface CommentCell ()

@property (nonatomic, strong) CommentView *commentView;

@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor backgroundColor];

        [self createLayout];
        //如果是代码实现autolayout的话必须要将translatesAutoresizingMaskIntoConstraints 设置为NO。
        _rootLayout.translatesAutoresizingMaskIntoConstraints = NO;

        //设置布局视图的autolayout约束，这里是用iOS9提供的约束设置方法，您也可以用低级版本设置，以及用masonry来进行设置。
        [_rootLayout.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [_rootLayout.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
        //目前MyLayout和AutoLayout相结合并且高度根据宽度自适应时只能通过明确设置宽度约束，暂时不支持同时设置左右约束来确定宽度的能力。
        [_rootLayout.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor].active = YES;

        //这句代码很关键，表明self.contentView的高度随着子视图_rootLayout的高度自适应。
        [self.contentView.bottomAnchor constraintEqualToAnchor:_rootLayout.bottomAnchor constant:0].active = YES;
    }

    return self;
}

- (void)setModel:(CommentModel *)model {
    [self.commentView setModel:model];
}

#pragma mark -- Layout Construction

//用线性布局来实现UI界面
- (void)createLayout
{
    self.commentView = [CommentView new];

    _rootLayout = self.commentView;
    _rootLayout.padding = UIEdgeInsetsMake(10, 16, 10, 16);

    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];
}

@end
