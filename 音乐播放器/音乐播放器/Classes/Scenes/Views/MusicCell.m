//
//  MusicCell.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/4.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import "MusicCell.h"
#import "UIImageView+WebCache.h"


@interface MusicCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *singerLB;

@end
@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setMusicModel:(MusicModel *)musicModel{
    _musicModel  = musicModel;// 不写，会取不到model的值 只传值，并没有给model赋值 
    [_imgView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]];
    
    _nameLB.text = musicModel.name;
    
    _singerLB.text = musicModel.singer;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
