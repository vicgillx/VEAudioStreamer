//
//  ViewController.m
//  PlayerDemo
//
//  Created by 姜思宇 on 16/8/1.
//  Copyright © 2016年 JsyVicgil. All rights reserved.
//

#import "ViewController.h"
#import "VEAudioStreamer.h"


@interface ViewController ()
@property(nonatomic)VEAudioStreamer* audioStreamer;
@property(nonatomic)NSArray* tracks;
@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.audioStreamer  = [VEAudioStreamer setupAudioStreamerWithTracks:self.tracks progressSlider:self.sliderOfProgress];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Streamer

#pragma mark -IBAction
- (IBAction)onSliderControlPrograss:(UISlider *)sender {
    [self.audioStreamer setCurrentTime:[self.audioStreamer duration] * [sender value]];
}

- (IBAction)onSliderControlVoice:(UISlider *)sender {
    [self.audioStreamer setVolume:[sender value]];
}
- (IBAction)onButtonPrecede:(UIButton *)sender {
    [self.audioStreamer precdeAudio];
}
- (IBAction)onButtonPlayAndStop:(id)sender {
    if(      [self.audioStreamer audioStatus] == VEAudioStreamerPaused  || [self.audioStreamer audioStatus] == VEAudioStreamerIdle   )
    {
        [self.audioStreamer play];
    }
    else
    {
        [self.audioStreamer pause];
    }
}
- (IBAction)onButtonPause:(UIButton *)sender {
    [self.audioStreamer stop];
}
- (IBAction)onButtonNext:(id)sender {
    [self.audioStreamer nextAudio];
}



-(NSArray*)tracks
{
    if(       !_tracks   )
    {
        
    
        Track* track1 = [Track trackWithTitle:@"小幸运" artist:@"1号选手" FileURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"testListen" ofType:@"mp3"]]];
        
        Track* track2 = [Track trackWithTitle:@"豆瓣FM1" artist:@"未知" FileURL:[NSURL URLWithString:@"http://mr1.doubanio.com/e06433b41b79c3dec3e31d8036cdfba5/0/fm/song/p1591096_64k.mp3"]];
        
        
        Track* track3 = [Track trackWithTitle:@"豆瓣FM2 " artist:@"未知num2" FileURL:[NSURL URLWithString:@"http://mr1.doubanio.com/2081bb1e22f79ab5d8afee437091aa5c/0/fm/song/p1948600_128k.mp3"]];
        
        _tracks = @[track1,track2,track3];
    }
    
    return _tracks;
    
}
@end
