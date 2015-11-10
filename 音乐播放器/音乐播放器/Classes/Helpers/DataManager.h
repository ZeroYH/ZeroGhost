//
//  DataManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

typedef void(^UpdataUI)();


@interface DataManager : NSObject
@property (nonatomic, strong) NSArray * allMusic;
/**
 *  单例方法
 *
 *  @return 单例
 */
+ (DataManager *)sharedManager;

@property (nonatomic, copy) UpdataUI myUpdataUI;

/**
 *  根据cell的索引返回一个model
 *
 *  @param index 索引值
 *
 *  @return model
 */
- (MusicModel *)musicModelWithIndex:(NSInteger)index;


@end
