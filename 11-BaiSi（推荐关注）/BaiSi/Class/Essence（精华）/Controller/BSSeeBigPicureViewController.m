//
//  BSSeeBigPicureViewController.m
//  06-BaiSi
//
//  Created by ming on 15/12/28.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSSeeBigPicureViewController.h"
#import "BSTopicItem.h"
#import <UIImageView+WebCache.h>
#import <Photos/Photos.h>
#import <SVProgressHUD.h>

@interface BSSeeBigPicureViewController ()<UIScrollViewDelegate>
/** UIImagView */
@property (nonatomic,weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

static NSString *const BSAssetCollectionName = @"明哥的百思不得姐";

@implementation BSSeeBigPicureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加scrolllView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.delegate = self;
    [self.view insertSubview:scrollView atIndex:0];
    [scrollView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    
    // 添加图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.x = BSCommandMargin;
    imageView.width = BSScreenW - 2 * BSCommandMargin;
    imageView.height = imageView.width * self.topic.height/self.topic.width;
    
    // 下载图片
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.saveButton.enabled = YES;
    }];
    // 下载完图片再计算高度，这样才比较很合理
    if (imageView.height > BSScreenW) {
        imageView.y = 2 * BSCommandMargin;
        // 设置最大缩放比例
        scrollView.maximumZoomScale = self.topic.width/imageView.width ;
    }else{
        imageView.centerY = self.view.centerY;
    }
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 设置滚动区域
    scrollView.contentSize = CGSizeMake(0, imageView.height);
}

#pragma mark - UIScrollViewDelegate
/**
 *  缩放的控件必须是UIScrollView里面的子控件。
 *  默认只能缩放一个控件，当需要缩放多个子控件时，
 *  可以用一个父控件UIView包裹住要缩放的子控件，
 *  即可实现一次性缩放多个子空间的功能。
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

#pragma mark - 操作
/** 退出查看大图模式 */
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self back];
}


/*
 一.保存图片到【Camera Roll】(相机胶卷)
 1.使用函数UIImageWriteToSavedPhotosAlbum
 2.使用AssetsLibrary.framework(iOS9开始, 已经过期)
 3.使用Photos.framework(iOS8开始可以使用, 从iOS9开始完全取代AssetsLibrary.framework)
 
 二.创建新的【自定义Album】(相簿\相册)
 1.使用AssetsLibrary.framework(iOS9开始, 已经过期)
 2.使用Photos.framework(iOS8开始可以使用, 从iOS9开始完全取代AssetsLibrary.framework)
 
 三.将【Camera Roll】(相机胶卷)的图片 添加到 【自定义Album】(相簿\相册)中
 1.使用AssetsLibrary.framework(iOS9开始, 已经过期)
 2.使用Photos.framework(iOS8开始可以使用, 从iOS9开始完全取代AssetsLibrary.framework)
 
 四.Photos.framework须知
 1.PHAsset : 一个PHAsset对象就代表一张图片或者一段视频
 2.PHAssetCollection : 一个PHAssetCollection对象就代表一本相册
 
 五.PHAssetChangeRequest的基本认识
 1.可以对相册图片进行【增\删\改】的操作
 
 六.PHPhotoLibrary的基本认识
 1.对相册的任何修改都必须放在以下其中一个方法的block中
 [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:error:];
 [[PHPhotoLibrary sharedPhotoLibrary] performChanges:completionHandler:];
 */
/** 判断授权状态 */
- (IBAction)saveClick {
    // 取得授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    // 判断当前状态
    if (status == PHAuthorizationStatusAuthorized) {
        // 当前App访问【Photo】运用
        [self saveImage];
    }else if (status == PHAuthorizationStatusDenied){
        // 拒绝当前App访问【Photo】运用
        [SVProgressHUD showInfoWithStatus:@"提醒用固话打开访问开关【设置】-【隐私】—【照片】-【百思不得姐】"];
    }else if (status == PHAuthorizationStatusNotDetermined){
        // 从未弹框让用户做出选择（用户还没有做出选择）用户未决定
        
        // 弹框让用户做出选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self saveImage];
            }else if (status == PHAuthorizationStatusDenied){
                // 用户拒绝当前App访问【Photo】运用
                // 用户刚做出拒绝当前App的举动
            }
        }];
    }else if (status == PHAuthorizationStatusRestricted){
        // 级别的限制（用户都无法给你授权）
        [SVProgressHUD showErrorWithStatus:@"由于系统原因，我IFA保存图片"];
    }
}

/**
 * 保存图片到自定义Album
 */
- (void)saveImage{
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    NSError *error = nil;
    // 用来抓取PHAsset的字符串标识
    __block NSString *assetId = nil;
    // 用来抓取PHAssetCollectin的字符串标识符
    __block NSString *assetCollectionId = nil;
    
    // 保存照片到【Camera Roll】(相机胶卷)
    [library performChangesAndWait:^{
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    // 获取曾经创建过的自定义相册
    PHAssetCollection *createdAssetCollection = nil;
    PHFetchResult <PHAssetCollection *>*assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:BSAssetCollectionName]) {
            createdAssetCollection = assetCollection;
            break;
        }
    }
    
    // 如果这个自定义相册没有被创建过
    if (createdAssetCollection == nil) {
       // 创建 新的【自定义的Album】(相簿\相册)
        [library performChangesAndWait:^{
            assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:BSAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        
        // 抓取刚刚创建完的相册对象
        createdAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
    }
    
    // 将【Camera Roll】(相机胶卷)的图片 添加到 【自定义Album】(相簿\相册)中
    [library performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
        
        // 图片
        [request addAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil]];
    } error:&error];
    
    // 提示信息
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存图片失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存图片成功!"];
    }
}



- (void)getCameraRollAlbum
{
    // 获得Camera Roll【相机胶卷】
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        BSLog(@"%@", assetCollection.localizedTitle);
    }
}

- (void)getAllDIYAlbums
{
    // 获得所有的自定义相册
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        BSLog(@"%@", assetCollection.localizedTitle);
    }
}

- (void)asyncOperation
{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 异步执行修改操作
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) { // 修改完毕后，会自动调用completionHandler这个block
        BSLog(@"1");
    }];
    
    BSLog(@"2");
}



@end
