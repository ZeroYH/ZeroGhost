//
//  PlayingViewController.m
//  音乐播放器
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 yrh.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "DataManager.h"
#import "LyricManager.h"
#import "LyricModel.h"
#import "JDStatusBarNotification.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDelegate,UITableViewDataSource>

// 记录一下当前播放的音乐的索引
@property (nonatomic, assign) NSInteger currentIndex;
// 记录当前正在播放的音乐
@property (nonatomic, strong) MusicModel * currentModel;

@property (nonatomic, strong) UITableViewCell * cell;

#pragma mark - 控件

@property (strong, nonatomic) IBOutlet UIImageView *backImgView;
@property (strong, nonatomic) IBOutlet UILabel *songNameLB;

@property (strong, nonatomic) IBOutlet UILabel *singerNameLB;
@property (strong, nonatomic) IBOutlet UIImageView *img4Pic;
@property (strong, nonatomic) IBOutlet UILabel *lab4PlayedTime;
@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;
@property (strong, nonatomic) IBOutlet UISlider *slider4Time;
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;
@property (strong, nonatomic) IBOutlet UIButton *btn4PlayOrPause;
@property (strong, nonatomic) IBOutlet UITableView *tableView4Lyric;

#pragma mark - 控件事件

- (IBAction)action4Prev:(UIButton *)sender;
- (IBAction)action4PlayOrPause:(UIButton *)sender;
- (IBAction)action4Next:(UIButton *)sender;

- (IBAction)action4ChangeTime:(id)sender;
- (IBAction)action4ChangeVolume:(UISlider *)sender;


@end

static PlayingViewController * playingVC = nil;
static NSString * identifier = @"cell";


@implementation PlayingViewController

+ (instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 创建一个Storyboard , '' storyboardWithName:@"Main" ''， 本程序里面的Storyboard
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        // 获取Storyboard 作为入口的Controller
        // [sb instantiateInitialViewController]
        
        // 在main sb（Storyboard） 拿到我们要用的视图控制器
        playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        NSLog(@"%@",[NSThread currentThread]);
    });
    return playingVC;
}
// button事件
- (IBAction)actionBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)startPlay{
    [[PlayerManager sharedManager] playWithUrlString:self.currentModel.mp3Url];
    // 显示UI信息
    [self buildUI];
}

- (void)buildUI{
    self.songNameLB.text = self.currentModel.name;
    self.singerNameLB.text = self.currentModel.singer;
    [self.img4Pic sd_setImageWithURL:[NSURL URLWithString:self.currentModel.picUrl]];
    
    // 更改button
    //[self.btn4PlayOrPause setTitle:@"暂停" forState:UIControlStateNormal];
    [self.btn4PlayOrPause setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    // 改变进度条的最大值 为歌曲的时间 （毫秒除以1000变为秒）
    self.slider4Time.maximumValue = [self.currentModel.duration integerValue] / 1000;
    self.slider4Time.value = 0;
    
    // 更改旋转的角度,图片归位
    self.img4Pic.transform = CGAffineTransformMakeRotation(0);
    
    // 解析歌词
    
        [[LyricManager sharedManager] loadLyricWith:self.currentModel.lyric];
        [self.tableView4Lyric reloadData];
    
    
    
    // 背景
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:self.currentModel.blurPicUrl]];
    
}

#pragma mark - getter
//确保当前播放的音乐是最新的
- (MusicModel *)currentModel{
     // 取到要播放的model
    MusicModel * model = [[DataManager sharedManager] musicModelWithIndex:self.currentIndex];
    return model;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentIndex = -1;
    
    // 设置自己为播放器的代理，帮播放器干一些事情
    [PlayerManager sharedManager].delegate = self;
    
    // 加圆角
    self.img4Pic.layer.masksToBounds = YES;
    _img4Pic.layer.cornerRadius = 120;
    
    // 注册
    [self.tableView4Lyric registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView4Lyric.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置音量进度条
    self.slider4Volume.value = [[PlayerManager sharedManager] volume];
}




- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 如果要播放的音乐和当前播放的音乐一样，就什么都不干了。
    if (_index == _currentIndex) {
        return;
    }
    // 否则 记录当前音乐的index 然后播放
    _currentIndex = _index;
    [self startPlay];
    
    // 友盟页面的统计
    [MobClick beginLogPageView:@"PageOne"];
}

// 友盟页面的统计
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 上一首
- (IBAction)action4Prev:(UIButton *)sender {
    _currentIndex--;
    // 判断是否是第一首
    if (_currentIndex == -1) {
        // 如果是第一首就播放最后一首
        _currentIndex = [DataManager sharedManager].allMusic.count - 1;
    }
    [self startPlay];
}

// 暂停或只播放事件
- (IBAction)action4PlayOrPause:(UIButton *)sender {
    // 判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying) {
        // 如果正在播放，就让播放器暂停，同时改变button的text
        [[PlayerManager sharedManager] pause];
        //[sender setTitle:@"播放" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    } else {
        //暂停状态：开始播放，并改变btn为暂停
        [[PlayerManager sharedManager] play];
        //[sender setTitle:@"暂停" forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
    //TODO：bug ，暂停之后，点击下一首就不能播放了
   
}

// 下一首
- (IBAction)action4Next:(UIButton *)sender {
//    // 在播放下一首时，先暂停，销毁timer
//    [[PlayerManager sharedManager] pause];
    
    
    _currentIndex++;
    // 判断是不是最后一首
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        // 如果是最后一首就播放第一首
        _currentIndex = 0;
    }
    [self startPlay];
    
}
// 改变播放的进度
- (IBAction)action4ChangeTime:(id)sender {
    UISlider * slider = sender;
    // 调用接口
    [[PlayerManager sharedManager] seekToTime:slider.value];
    
}
// 改变音量
- (IBAction)action4ChangeVolume:(UISlider *)sender {
    [[PlayerManager sharedManager] changeToVolume:sender.value];
}


#pragma mark - PlayerManagerDelegate
// 播放器播放结束了，开始播放下一首
- (void)playerDidPlayEnd{
    [self action4Next:nil];
    
    // JDS
    NSString * str = [JDStatusBarNotification addStyleNamed:self.currentModel.name prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        style.barColor = [UIColor blackColor];
        style.textColor = [UIColor cyanColor];
        return style;
    }];
    [JDStatusBarNotification showWithStatus:self.currentModel.name dismissAfter:3 styleName:str];
}
// 播放器每0.1秒会让代理（也就是这个页面）执行一下这个事件
- (void)playerPlayingWithTime:(NSTimeInterval)time{
    self.slider4Time.value = time;
    self.lab4PlayedTime.text = [self stringWithTime:time];
    // 剩余时间
    NSTimeInterval time2 = [self.currentModel.duration integerValue] / 1000 - time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    // 每0.1秒旋转 1 度
    self.img4Pic.transform = CGAffineTransformRotate(self.img4Pic.transform, M_PI / 180);
    
    // 根据 当前播放时间获取到应该播放哪句歌词
    NSInteger index = [[LyricManager sharedManager] indexWith:time];
    NSIndexPath * path = [NSIndexPath indexPathForRow:index inSection:0];
    // 让tableView选中我们找到的歌词
    [self.tableView4Lyric selectRowAtIndexPath:path animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    // 改变选中行的颜色
    UITableViewCell * cell = [self.tableView4Lyric cellForRowAtIndexPath:self.tableView4Lyric.indexPathForSelectedRow];
    cell.textLabel.highlightedTextColor = [UIColor greenColor];
    // 取消掉选中时候的条条
    UIView  *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView=view;
   
}


// 根据时间获取到字符串
- (NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time / 60;
    NSInteger seconde = (int)time % 60;
    return [NSString stringWithFormat:@"%ld:%ld", (long)minutes, (long)seconde];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [LyricManager sharedManager].allLyric.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    LyricModel * lyric = [LyricManager sharedManager].allLyric[indexPath.row];
    cell.textLabel.text = lyric.lyricContext;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

@end
