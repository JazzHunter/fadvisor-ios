//
//  CommonFunc.m
//  Fadvisor
//
//  Created by 韩建伟 on 2024/1/20.
//

#import "CommonFunc.h"
#import <FCUUID/FCUUID.h>
#import <Photos/Photos.h>

@implementation CommonFunc

+ (NSString *)getDeviceId {
    return [FCUUID uuidForDevice];
}
+ (void)saveImage:(UIImage *)image inView:(UIView *)view {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        [MBProgressHUD showAutoMessage:[@"因为系统原因, 保存到相册失败" localString] ToView:view];
    } else if (status == PHAuthorizationStatusDenied) {
        [MBProgressHUD showAutoMessage:[@"因为权限原因, 保存到相册失败" localString] ToView:view];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self saveImageHasAuthority:image inView:view];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImageHasAuthority:image inView:view];
            }else {
                [MBProgressHUD showMessage:[@"因为权限原因, 保存到相册失败" localString] ToView:view];
            }
        }];
    }
}

+ (void)saveImageHasAuthority:(UIImage *)image inView:(UIView *)view {
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        if (@available(iOS 9.0, *)) {
            assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            [MBProgressHUD showAutoMessage:[@"保存图片失败!" localString] ToView:view];
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection == nil) {
            [MBProgressHUD showAutoMessage:[@"创建相簿失败!" localString] ToView:view];
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                [MBProgressHUD showMessage:[@"保存图片失败!" localString] ToView:view];
            } else {
                [MBProgressHUD showMessage:[@"保存图片成功!" localString] ToView:view];
            }
        }];
    }];
}

+ (PHAssetCollection *)createdAssetCollection {
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:@"相机胶卷"]) {
            return assetCollection;
        }
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    
    // 错误信息
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"相机胶卷"].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}
@end
