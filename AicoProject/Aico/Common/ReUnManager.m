//
//  ReUnManager.m
//  Aico
//
//  Created by Wang Dean on 12-4-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReUnManager.h"

static ReUnManager *reUnManager_ = nil;
static NSInteger  stickerTag = 10000;
@implementation ReUnManager
@synthesize unImagePathArray = unImagePathArray_;
@synthesize reImagePathArray = reImagePathArray_;
@synthesize index;
@synthesize currentImageName = currentImageName_;
@synthesize snapImage = snapImage_;
@synthesize stickerArray = stickerArray_;
@synthesize isMagicWand = isMagicWand_;
@synthesize isSaved = isSaved_;
@synthesize isLaunch =isLaunch_;

/**
 * @brief  创建单例和获取单例的方法
 *
 * @param [in] 
 * @param [out] 返回单例本身
 * @return
 * @note 
 */
+ (ReUnManager *)sharedReUnManager
{
    if (reUnManager_ == nil)
    {
        reUnManager_ = [[ReUnManager alloc] init];
    }
    return reUnManager_;
}

- (id)init
{
    if (self = [super init])
    {
        unImagePathArray_  = [[NSMutableArray alloc] initWithCapacity:0];
        reImagePathArray_  = [[NSMutableArray alloc] initWithCapacity:0];
        stickerArray_      = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        path = [path stringByAppendingPathComponent:@"Work"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) 
        {
            if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil])
            {
                NSLog(@"ciritcal error! cannot create folder");
            }
        }
        
        NSString *pathIcon = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        pathIcon = [pathIcon stringByAppendingPathComponent:@"Icon"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:pathIcon]) 
        {
            if(![[NSFileManager defaultManager] createDirectoryAtPath:pathIcon withIntermediateDirectories:NO attributes:nil error:nil])
            {
                NSLog(@"ciritcal error! cannot create folder icon");
            }
            else
            {
//                NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
//                path = [path stringByAppendingPathComponent:@"Favorite"];
//                NSString *defaultImage = [path stringByAppendingPathComponent:@"First.png"];
//                [Common writeIconAico:defaultImage];
            }
        }
    }
    index = 0;
    return self;
}

/**
 * @brief  存储当前图片并且加入到撤销数据
 *
 * @param [in] image 图片数据
 * @param [out] 存储成功YES，失败返回NO
 * @return
 * @note 
 */
- (BOOL)storeImage:(UIImage *)image
{
    NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    path = [path stringByAppendingPathComponent:@"Work"];
    NSString *name = [NSString stringWithFormat:@"%d.png", index];
    NSString *imagePath = [path stringByAppendingPathComponent:name];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    if (self.unImagePathArray != nil)
    {
        [self.unImagePathArray addObject:imagePath];
    }
    if ([self.reImagePathArray count] != 0)
    {
        [self.reImagePathArray removeAllObjects]; 
    }
    index++;
    self.snapImage = nil;//存储后，临时的照片就可以释放了
    
    self.isSaved = NO;
    return YES;
}

/**
 * @brief  判断当前是否支持撤销操作
 *
 * @param [in] 
 * @param [out] 支持返回YES，不支持返回NO
 * @return
 * @note 
 */
- (BOOL)canUndo
{
    if ((self.unImagePathArray == nil) ||([self.unImagePathArray count] <= 1))
    {
        return NO;
    }
    return YES;
}

/**
 * @brief  撤销操作
 *
 * @param [in] 
 * @param [out] 返回撤销的上一张图片的绝对路径
 * @return
 * @note 
 */
- (NSString *)undoAction
{
    if ((self.unImagePathArray == nil) ||([self.unImagePathArray count] <= 1))
    {
        return nil;
    }
    
    NSString *undoPath = [self.unImagePathArray lastObject];
    [self.reImagePathArray addObject:undoPath];
    [self.unImagePathArray removeLastObject];
    
    self.isSaved = NO;
    return [self.unImagePathArray lastObject];
}

/**
 * @brief  判断当前是否支持反撤销操作
 *
 * @param [in] 
 * @param [out] 支持返回YES，不支持返回NO
 * @return
 * @note 
 */
- (BOOL)canRedo
{
    if ((self.reImagePathArray == nil) ||([self.reImagePathArray count] == 0))
    {
        return NO;
    }
    
    return YES;
}

/**
 * @brief  反撤销操作
 *
 * @param [in] 
 * @param [out] 返回反撤销的上一张图片的绝对路径
 * @return
 * @note 
 */
- (NSString *)redoAction
{
    if ((self.reImagePathArray == nil) ||([self.reImagePathArray count] == 0))
    {
        return nil;
    }
    NSString *redoPath = [self.reImagePathArray lastObject];
    [self.unImagePathArray addObject:redoPath];
    [self.reImagePathArray removeLastObject];
    self.isSaved = NO;
    
    return [self.unImagePathArray lastObject];
}

/**
 * @brief  清楚所以的撤销反撤销记录的图片地址和图片
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)clearStorage
{
    [self.reImagePathArray removeAllObjects];
    [self.unImagePathArray removeAllObjects];
    NSString *path = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
    path = [path stringByAppendingPathComponent:@"Work"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *pathArray = nil;
    pathArray = [fm contentsOfDirectoryAtPath:path error:nil];
    if (pathArray != nil && [pathArray count] > 0)
    {
        for (NSString *name in pathArray)
        {
            NSString *newPath = [NSString stringWithFormat:@"%@/%@", path, name];
            if ([fm fileExistsAtPath:newPath])
            {
                [fm removeItemAtPath:newPath error:nil];
            }
        }
    }
    self.currentImageName = nil;
    index = 0;
}

/**
 * @brief  获取当前编辑区域的图片数据
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (UIImage *)getGlobalSrcImage
{
    UIImage *retunImage = nil;
    if (self.unImagePathArray != nil && [self.unImagePathArray count] > 0)
    {
        NSString *path = [self.unImagePathArray lastObject];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:path]) 
        {
            retunImage = [UIImage imageWithContentsOfFile:path];
        }
        
    }
    return retunImage;
}

/**
 * @brief  获取当前编辑图片的绝对地址
 *
 * @param [in] 
 * @param [out] 当前图片的绝对地址
 * @return
 * @note 
 */
- (NSString *)getGlobalSrcImagePath
{
    if (self.unImagePathArray != nil && [self.unImagePathArray count] > 0)
    {
        NSString *path = [self.unImagePathArray lastObject];
        return [NSString stringWithString:path];
    }
    return nil;
}

/**
 * @brief  用来记录没有点击确认的图片，按home键需要保存图片
 *
 * @param [in] image 需要保存的图片数据
 * @param [out] 存储成功返回YES，失败返回NO
 * @return
 * @note 
 */
- (BOOL)storeSnap:(UIImage *)image
{
    if (image == nil)
    {
        return NO;
    }
    self.snapImage = nil;//先释放原来的对象
    self.snapImage = image;//属性是copy确保产生一个新对象，而不是只是retain原来对象
    return YES;
}

/**
 * @brief  魔法棒界面切后台单独保存
 *
 * @param [in] 
 * @param [out] 
 * @return
 * @note 
 */
- (void)saveMagicWandView
{
    UIImage *lastImage = nil;
    if (self.snapImage != nil)
    {
        lastImage = self.snapImage;
        [Common writeImageAico:lastImage withName:nil];
    }
    else
    {
        lastImage = [self getGlobalSrcImage];
        if ([self canUndo] )
        {
            [Common writeImageAico:lastImage withName:nil];//文件名为空的时候走新建保存
        }
    }
    
    //更新最后编辑的图片
    if (lastImage != nil) 
    {
        NSString *OrPath = [NSString stringWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ];
        NSString *lastFloder = [OrPath stringByAppendingPathComponent:@"LastImage"];
        NSString *lastImagePath = [lastFloder stringByAppendingPathComponent:@"lastImage.png"];
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:lastImagePath error:nil];
        [UIImagePNGRepresentation(lastImage) writeToFile:lastImagePath atomically:YES];
    }

}
- (void)dealloc
{
    self.unImagePathArray = nil;
    self.reImagePathArray = nil;
    self.snapImage = nil;
    self.stickerArray = nil;
    [super dealloc];
}

/**
 * @brief  数组中新增一个装饰记录
 * @param [in]  图片名
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)addOneStickerToArray:(NSString *)imageName
{
    NSLog(@"addOneStickerToArray");
    //CGFloat [ a b c d tx ty ][ 1 0 0 1 0 0 ]
    NSArray *transform = [[NSArray alloc] initWithObjects:@"1",@"0",@"0",@"1",@"0",@"0", nil];
    //CGFloat [x y]
    NSArray *center = [[NSArray alloc] initWithObjects:@"0",@"0", nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 imageName,kStickerDefaultImageName,
                                 transform,kStickerDefaultTransform,
                                 center,kStickerDefaultCenter,
                                 [NSNumber numberWithInt:stickerTag],kStickerDefaultTag,
                                 nil];
    if (stickerArray_!=nil) {
        [stickerArray_ addObject:dict];
        stickerTag++;
    }
    [transform release];
    [center release];
    [dict release];
    return YES;
}
/**
 * @brief  从数组中删除指定的装饰记录
 * @param [in]  装饰图的tag
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)delOneStickerToArray:(NSInteger)stickerTag
{
    BOOL ret = NO;
    for (int i=0,j=[stickerArray_ count]-1; i<=j; i++,j--) {
        if ([[[stickerArray_ objectAtIndex:i] objectForKey:kStickerDefaultTag] intValue] == stickerTag) {
            [stickerArray_ removeObjectAtIndex:i];
            ret = YES;
            break;
        }
        if ([[[stickerArray_ objectAtIndex:j] objectForKey:kStickerDefaultTag] intValue] == stickerTag) {
            [stickerArray_ removeObjectAtIndex:j];
            ret = YES;
            break;
        }
    }
    return ret;
}
/**
 * @brief  将数组中所有记录清空
 * @param [in]  
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)clearAllStickers
{
    if ([stickerArray_ count]!=0) {
        [self.stickerArray removeAllObjects];
        stickerTag = 10000;
        return YES;
    }
    return YES;
}
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  dict:记录字典 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithDict:(NSDictionary *)dict andIndex:(NSUInteger)i
{
    
    if ([stickerArray_ count]<i) 
    {
        //error
        return NO;
    }
    else
    {
        return YES;
    }
}
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  center:记录字典中的center字段 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithCenter:(CGPoint)center andIndex:(NSUInteger)i
{
    if ([stickerArray_ count]<i) 
    {
        //error
        return NO;
    }
    else
    {
        NSArray *cArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%f",center.x],[NSString stringWithFormat:@"%f",center.y], nil];
        [[stickerArray_ objectAtIndex:i] removeObjectForKey:kStickerDefaultCenter];
        [[stickerArray_ objectAtIndex:i] setObject:cArray forKey:kStickerDefaultCenter];
        [cArray release];
        return YES;
    }
}
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  imageName:记录字典中图片名字段 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithImage:(NSString *)imageName andIndex:(NSUInteger)i
{
    if ([stickerArray_ count]<i) 
    {
        //error
        return NO;
    }
    else
    {
        [[stickerArray_ objectAtIndex:i] removeObjectForKey:kStickerDefaultImageName];
        [[stickerArray_ objectAtIndex:i] setObject:imageName forKey:kStickerDefaultImageName];
        return YES;
    }
}
/**
 * @brief  更新数组中指定装饰记录
 * @param [in]  transform:记录字典中transform字段 i:下标
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceStickerWithTransform:(CGAffineTransform)transform andIndex:(NSUInteger)i
{
    if ([stickerArray_ count]<i) 
    {
        //error
        return NO;
    }
    else
    {
        NSArray *tArray = [[NSArray alloc] initWithObjects:
                           [NSString stringWithFormat:@"%f",transform.a],
                           [NSString stringWithFormat:@"%f",transform.b],
                           [NSString stringWithFormat:@"%f",transform.c],
                           [NSString stringWithFormat:@"%f",transform.d],
                           [NSString stringWithFormat:@"%f",transform.tx],
                           [NSString stringWithFormat:@"%f",transform.ty],
                           nil];
        [[stickerArray_ objectAtIndex:i] removeObjectForKey:kStickerDefaultTransform];
        [[stickerArray_ objectAtIndex:i] setObject:tArray forKey:kStickerDefaultTransform];
        [tArray release];
        return YES;
    }
    return YES;
}
/**
 * @brief  更新数组最后一个装饰记录
 * @param [in]  center:记录字典中的center字段 
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceLastStickerWithCenter:(CGPoint)center
{
    return [self replaceStickerWithCenter:center andIndex:[stickerArray_ count]-1];
}
/**
 * @brief  更新数组最后一个装饰记录
 * @param [in]  transform:记录字典中transform字段 
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceLastStickerWithTransform:(CGAffineTransform)transform
{
    return [self replaceStickerWithTransform:transform andIndex:[stickerArray_ count]-1];
}
/**
 * @brief  更新数组最后一个装饰记录
 * @param [in]  imageName:记录字典中图片名字段 
 * @param [out] 成功:YES 失败:NO
 * @return
 * @note 
 */
- (BOOL)replaceLastStickerWithImageName:(NSString *)imageName
{
    return [self replaceStickerWithImage:imageName andIndex:[stickerArray_ count]-1];
}
@end
