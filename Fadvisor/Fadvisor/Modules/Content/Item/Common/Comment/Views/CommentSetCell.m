//
//  CommentSetCell.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/3/2.
//

#import "CommentSetCell.h"
#import "CommentView.h"

@interface CommentSetCell ()

@property (nonatomic, strong) CommentView *parmentCommentView;
@property (nonatomic, strong) CommentView *childCommentView1;
@property (nonatomic, strong) CommentView *childCommentView2;

@property (nonatomic, strong) MyLinearLayout *showMorCommentsLayout;
@property (nonatomic, strong) UILabel *showMorCommentsLabel;

@end

@implementation CommentSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor backgroundColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

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
    [self.childCommentView1 removeFromSuperview];
    [self.childCommentView2 removeFromSuperview];
    [self.showMorCommentsLayout removeFromSuperview];

    [self.parmentCommentView setModel:model];
    if (model.replies.count >= 2) {
        [self.rootLayout addSubview:self.childCommentView1];
        [self.childCommentView1 setModel:model.replies[0]];

        [self.rootLayout addSubview:self.childCommentView2];
        [self.childCommentView2 setModel:model.replies[1]];
//        if (model.replies.count > 2) {
        self.showMorCommentsLabel.text = [NSString stringWithFormat:@"查看全部 %lu 条评论  >", model.replyCount - 2];
        [self.showMorCommentsLabel sizeToFit];
        [self.rootLayout addSubview:self.showMorCommentsLayout];
//        }
    } else if (model.replies.count == 1) {
        [self.rootLayout addSubview:self.childCommentView1];
        [self.childCommentView1 setModel:model.replies[0]];
    }
}

#pragma mark -- Layout Construction

//用线性布局来实现UI界面
- (void)createLayout
{
    _rootLayout = [MyRelativeLayout new];
    _rootLayout.paddingTop = 10;
    _rootLayout.paddingBottom = 10;
    _rootLayout.paddingLeft = 16;
    _rootLayout.paddingRight = 16;

    //这个属性只局限于在UITableViewCell中使用，用来优化tableviewcell的高度自适应的性能，其他地方请不要使用！！！
    _rootLayout.cacheEstimatedRect = YES;
    _rootLayout.heightSize.equalTo(@(MyLayoutSize.wrap));
    _rootLayout.widthSize.equalTo(nil);
    [self.contentView addSubview:_rootLayout];

    self.parmentCommentView = [CommentView new];
    self.parmentCommentView.widthSize.equalTo(self.rootLayout.widthSize);
    self.parmentCommentView.leftPos.equalTo(self.rootLayout.leftPos);
    self.parmentCommentView.topPos.equalTo(self.rootLayout.topPos);
    [self.rootLayout addSubview:self.parmentCommentView];

    self.childCommentView1 = [[CommentView alloc]initWithSize:CommentViewSizeSmall];
    self.childCommentView1.leftPos.equalTo(self.parmentCommentView.leftPos).offset(UserAvatarWithWrapperWidthNormal + 8);
    self.childCommentView1.rightPos.equalTo(self.parmentCommentView.rightPos);
    self.childCommentView1.topPos.equalTo(self.parmentCommentView.bottomPos).offset(8);

    self.childCommentView2 = [[CommentView alloc]initWithSize:CommentViewSizeSmall];
    self.childCommentView2.leftPos.equalTo(self.childCommentView1.leftPos);
    self.childCommentView2.rightPos.equalTo(self.childCommentView1.rightPos);
    self.childCommentView2.topPos.equalTo(self.childCommentView1.bottomPos).offset(8);

    self.showMorCommentsLayout.leftPos.equalTo(self.childCommentView2.leftPos).offset(UserAvatarWithWrapperWidthSmall + 8);
    self.showMorCommentsLayout.topPos.equalTo(self.childCommentView2.bottomPos).offset(8);
}

- (MyLinearLayout *)showMorCommentsLayout {
    if (!_showMorCommentsLayout) {
        _showMorCommentsLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        _showMorCommentsLayout.layer.masksToBounds = YES;
        _showMorCommentsLayout.padding = UIEdgeInsetsMake(6, 16, 6, 16);
        _showMorCommentsLayout.layer.cornerRadius = 12;
        _showMorCommentsLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
        _showMorCommentsLayout.backgroundColor = [UIColor backgroundColorGray];
        [_showMorCommentsLayout setTarget:self action:@selector(showMoreCommentsClicked:)];

        _showMorCommentsLabel = [[UILabel alloc] init];
        _showMorCommentsLabel.font = [UIFont systemFontOfSize:12];

        _showMorCommentsLabel.textColor = [UIColor titleTextColor];
        [_showMorCommentsLayout addSubview:_showMorCommentsLabel];

    }
    return _showMorCommentsLayout;
}

#pragma mark - Actions

- (void)showMoreCommentsClicked:(MyBaseLayout *)layout {
    if(self.delegate && [self.delegate respondsToSelector:@selector(showMoreCommentsClicked:)]) {
        [self.delegate showMoreCommentsClicked:self];
    }
}

@end
