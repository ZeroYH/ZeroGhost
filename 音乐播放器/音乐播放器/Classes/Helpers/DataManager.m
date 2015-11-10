//
//  DataManager.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import "DataManager.h"
#import "MusicModel.h"

@interface DataManager ()
@property (nonatomic, strong) NSMutableArray * musicArray;
@end

@implementation DataManager
// command + control + ⬆️/⬇️ 切换 .h .m
static DataManager * manager = nil;
+ (DataManager *)sharedManager{
    // GCD 提供的一种单例方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [DataManager new];
        [manager requestData];
    });
    return manager;
}

- (void)requestData{
    //__weak typeof(self) temp = self;
    // 开辟子线程, 在子线程中请求数据,防止假死
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // 数据链接 请求数据 请求的是一个plist文件下面是一个数组 用下面这个方法 直接全部解析出来
        NSArray *dataArray = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:kMuicListURL]];
        
        for (int i = 0; i < dataArray.count; i++) {
            NSLog(@"%@",dataArray[i]);
            // 构建model
            MusicModel *model = [MusicModel new];
            [model setValuesForKeysWithDictionary:dataArray[i]];
            [self.musicArray addObject:model];
        }
        //返回主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.myUpdataUI) {
                NSLog(@"block 没代码");
            }else{
                self.myUpdataUI();
            }
        });
        
    });
   
}
- (MusicModel *)musicModelWithIndex:(NSInteger)index{
    return self.allMusic[index];
}

#pragma mark -- lazy load
- (NSMutableArray *)musicArray{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

- (NSArray *)allMusic{
    return self.musicArray;
}
@end
