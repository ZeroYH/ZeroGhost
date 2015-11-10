//
//  LyricManager.h
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject

// 对外的歌词数组 (这样外界只能读，不能修改，保证了数据的安全性)
@property (nonatomic, strong) NSArray * allLyric;

+ (instancetype)sharedManager;

- (void)loadLyricWith:(NSString *)lyricStr;

/**
 *  根据播放时间获取到该播放的歌词的索引
 *
 *  @param tiem <#tiem description#>
 *
 *  @return <#return value description#>
 */

- (NSInteger)indexWith:(NSTimeInterval)time;

@end
