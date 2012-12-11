//
//  ReUnManager.h
//  Aico
//
//  Created by Wang Dean on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReUnManager : NSObject
{
    NSMutableArray *unImagePathArray_;   //undo队列存储撤销图片的绝对地址
    NSMutableArray *reImagePathArray_;   //redo队列存储反撤销图片的绝对地址
    NSUInteger index;                    //图片命名和寻找的标志
    NSString *currentImageName_;         //当前操作图片的名字 这个暂时无用
    UIImage *snapImage_;                 //快照图片。用来保存没有确认但做了操作的图片
    NSMutableArray *stickerArray_;       //装饰美化数据字典，用于保存每次装饰操作的数据
    BOOL isMagicWand_;                   //是否是魔法棒界面
    BOOL isSaved_;                       //用来记录图片是否已经存过手机相册
    BOOL isLaunch_;                      //是否是初次launch
}
@property(nonatomic,retain) NSMutableArray *unImagePathArray;
@property(nonatomic,retain) NSMutableArray *reImagePathArray;
@property(nonatomic,assign) NSUInteger index;
@property(nonatomic,copy) NSString *currentImageName;
@property(nonatomic,copy) UIImage *snapImage;  //这边用copy没有问题，因为需要保留一份图片的独立副本，单例中存在 不会泄露
@property(nonatomic,retain) NSMutableArray *stickerArray;
@property(nonatomic,assign) BOOL isMagicWand;
@property(nonatomic,assign) BOOL isSaved;
@property(nonatomic,assign) BOOL isLaunch;

/**
 * @brief  创建单例和获取单例的方法
 *
 * @param [in] 
 * @param [out] 返回单例本身
 * @return
 * @note 
 */
+ (ReUnManager *)sharedReUnManager;

/**
 * @brief  存储当前图片并且加入到撤销数据
 *
 * @param [in] image 图片数据
 * @param [out] 存储成功YES，失败返回NO
 * @return
 * @note 
 */
- (BOOL)storeImage:(UIImage *)image;

/**
 * @brief  判断当前是否支持撤销操作
 *
 * @param [in] 
 * @param [out] 支持返回YES，不支持返回NO
 * @return
 * @note 
 */
- (BOOL)canUndo;

/**
 * @brief  撤销操作
 *
 * @param [in] 
 * @param [out] 返回撤销的上一张图片的绝对路径
 * @return
 * @note 
 */
- (NSString *)undoAction;

/**
 * @brief  判断当前是否支持反撤销操作
 *
 * @param [in] 
 * @param [out] 支持返回YES，不支持返回NO
 * @return
 * @note 
 */
- (BOOL)canRedo;

/**
 * @brief  反撤销操作
 *
 * @param [in] 
 * @param [out] 返回反撤销的上一张图片的绝对路径
 * @return
 * @note 
 */
- (NSString *)redoAction;

/**
 * @brief  清楚所以的撤销反撤销记录的图片地址和图片
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)clearStorage;

/**
 * @brief  获取当前编辑区域的图片数据
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (UIImage *)getGlobalSrcImage;

/**
 * @brief  用来记录没有点击确认的图片，按home键需要保存图片
 *
 * @param [in] image 需要保存的图片数据
 * @param [out] 存储成功返回YES，失败返回NO
 * @return
 * @note 
 */
- (BOOL)storeSnap:(UIImage *)image;

/**
 * @brief  魔法棒界面切后台单独保存
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)saveMagicWandView;

//**************************Sticker****************************************//
/**
 * @brief  数组中新增一个装饰记录
 * @param [in]  图片名
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)addOneStickerToArray:(NSString *)imageName;
/**
 * @brief  从数组中删除指定的装饰记录
 * @param [in]  装饰图的tag
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)delOneStickerToArray:(NSInteger)stickerTag;
/**
 * @brief  将数组中所有记录清空
 * @param [in]  
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)clearAllStickers;
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  dict:记录字典 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */

- (BOOL)replaceStickerWithDict:(NSDictionary *)dict andIndex:(NSUInteger)i;
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  center:记录字典中的center字段 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithCenter:(CGPoint)center andIndex:(NSUInteger)i;
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  imageName:记录字典中图片名字段 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithImage:(NSString *)imageName andIndex:(NSUInteger)i;
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  transform:记录字典中transform字段 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithTransform:(CGAffineTransform)transform andIndex:(NSUInteger)i;

/**
 * @brief  更新数组最后一个装饰记录
 * @param [in]  center:记录字典中的center字段 
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceLastStickerWithCenter:(CGPoint)center;
/**
 * @brief  更新数组最后一个装饰记录
 * @param [in]  transform:记录字典中transform字段 
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceLastStickerWithTransform:(CGAffineTransform)transform;
/**
 * @brief  更新数组最后一个装饰记录
 * @param [in]  imageName:记录字典中图片名字段 
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceLastStickerWithImageName:(NSString *)imageName;
//**************************Sticker****************************************//

/**
 * @brief  获取当前编辑图片的绝对地址
 *
 * @param [in] 
 * @param [out] 当前图片的绝对地址
 * @return
 * @note 
 */
- (NSString *)getGlobalSrcImagePath;
@end
