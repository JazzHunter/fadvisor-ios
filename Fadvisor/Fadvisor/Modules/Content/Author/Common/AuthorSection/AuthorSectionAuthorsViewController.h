//
//  AuthorSectionAuthorsViewController.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/8/7.
//

#import "BaseScrollViewController.h"
#import "AuthorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorSectionAuthorsViewController : UIViewController

- (instancetype)initWithModels:(NSArray <AuthorModel *> *)models;

@end

NS_ASSUME_NONNULL_END
