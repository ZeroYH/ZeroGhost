//
//  LyricManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/10.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"


@interface LyricManager ()
// 用来存放歌词
@property (nonatomic, strong) NSMutableArray * lyrics;

@end


static LyricManager * manage = nil;
@implementation LyricManager

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [LyricManager new];
    });
    return manage;
}

- (void)loadLyricWith:(NSString *)lyricStr{
    if (lyricStr.length == 0) {
        LyricModel * model = [[LyricModel alloc] initWithTime:0 lyric:@"无歌词"];
        [self.lyrics addObject:model];
        return;
    }
    // 1.分行 (根据分隔符截取,返回一个数组类型)
    NSMutableArray * lyricStringArray = [[lyricStr componentsSeparatedByString:@"\n"] mutableCopy];
    // 最后一行是 @"" ，所以需要将最后一行移除
    [lyricStringArray removeLastObject];
    // 要将之前歌曲的歌词移除
    [self.lyrics removeAllObjects];
    
    for (NSString * str in lyricStringArray) {
        
        /*
        if ([str isEqualToString:@""]) {
            continue;
        }
        */
        if (![str hasPrefix:@"["]) {
            LyricModel * model = [[LyricModel alloc] initWithTime:0 lyric:str];
            // 添加到数组中
            [self.lyrics addObject:model];

        }else{
            
        
        // 2.分开时间和歌词
        NSArray * timeAndLyric = [str componentsSeparatedByString:@"]"];
        // 3.去掉时间左边的 “ [ ”
        NSString * time = [timeAndLyric[0] substringFromIndex:1];
        // 4.截取时间获取分和秒
        NSArray * minuteAndSecond = [time componentsSeparatedByString:@":"];
        // 分
        NSInteger minute = [minuteAndSecond[0] integerValue];
        // 秒
        double second = [minuteAndSecond[1] doubleValue];
        // 5.装成一个Model
        LyricModel * model = [[LyricModel alloc] initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
        // 6.添加到数组中
        [self.lyrics addObject:model];
        }
    }
    
}

- (NSInteger)indexWith:(NSTimeInterval)time{
   
    NSInteger index = 0;
    // 遍历数组，找到还没有播放的哪一句歌词。
    for (int i = 0; i < self.lyrics.count; i++) {
        LyricModel * model = self.lyrics[i];
        if (model.time > time) {
            // 注意如果是第0个元素，而且元素时间必要播放的时间大， i- 1就会小于0，这样tableview就会crash
            index = (i - 1 > 0) ? i - 1 : 0;
            // 一定要break，要不就会一直循环下去；
            break;
        }
    }
    return index;
}


- (NSArray *)allLyric{
    return self.lyrics;
}

- (NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray new];
    }
    return _lyrics;
}
@end
