//
//  ArticleContent.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/10.
//

#import <MyLayout/MyLayout.h>
#import "AuthorSection.h"
#import "RichTextView.h"
#import "ItemModel.h"
#import "ArticleDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleContent : MyLinearLayout

@property (nonatomic, strong) RichTextView *richTextView;

- (void)setModel:(ItemModel *)model details:(ArticleDetailsModel *)details authors:(NSArray <AuthorModel *> *)authors tags:(NSArray <TagModel *> *)tags attachments:(NSArray <ItemModel *> *)attachments relatedItems:(NSArray <ItemModel *> *)relatedItems;

@end

NS_ASSUME_NONNULL_END
