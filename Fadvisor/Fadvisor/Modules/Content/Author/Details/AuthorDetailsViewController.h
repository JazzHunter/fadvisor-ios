//
//  AuthorDetailsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/6/30.
//

#import "AuthorModel.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorDetailsViewController : BaseViewController<NavigationBarDataSource, NavigationBarDelegate>

- (instancetype)initWithAuthor:(AuthorModel *)authorModel;

- (instancetype)initWithId:(NSString *)authorId;

@end

NS_ASSUME_NONNULL_END
