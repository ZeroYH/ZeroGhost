//
//  MusicModel.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

// 异常处理
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
    NSLog(@"error key : %@",key);
}

@end
