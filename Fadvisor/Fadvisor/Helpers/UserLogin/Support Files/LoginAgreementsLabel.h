//
//  LoginAgreementsLabel.h
//  Fadvisor
//
//  Created by 韩建伟 on 2024/10/12.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginAgreementsLabel : MyLinearLayout

@property (atomic, assign) BOOL isAgreeSelect;

- (void)agree;

@end

NS_ASSUME_NONNULL_END
