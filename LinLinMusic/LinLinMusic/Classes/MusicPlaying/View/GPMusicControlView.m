//
//  GPMusicControlView.m
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicControlView.h"

@interface GPMusicControlView ()

@property (nonatomic,weak) IBOutlet UIButton *playButton;

@property (nonatomic,weak) IBOutlet UIButton *preButton;

@property (nonatomic,weak) IBOutlet UIButton *nextButton;

@property (nonatomic,weak) IBOutlet UISlider *slider;

@property (nonatomic,weak) IBOutlet UILabel *timeLabel;


@end

@implementation GPMusicControlView

- (void)awakeFromNib{
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderThumb_small"] forState:UIControlStateNormal];
    // 设置按钮的tag以便区分
    self.playButton.tag = GPMusicControlViewPlayButton;
    self.preButton.tag = GPMusicControlViewPreviousButton;
    self.nextButton.tag = GPMusicControlViewNextButton;
    // 添加监听
    [self.playButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.preButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    // slider
    [self.slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
}



- (void)setSliderMaxVaulue:(float)sliderMaxVaulue{
    _sliderMaxVaulue = sliderMaxVaulue;
    self.slider.maximumValue = sliderMaxVaulue;
    
    [self setUpTimeLabelWithSeconds:sliderMaxVaulue];
}

- (void)setSliderProgress:(float)sliderProgress{
    _sliderProgress = sliderProgress;
    [self setUpTimeLabelWithSeconds:(self.sliderMaxVaulue - sliderProgress)];
    
    if ( self.slider.state ) return;
    self.slider.value = sliderProgress;
}

- (void)sliderValueChange:(UISlider *)slider{
    if ( [self.delegate respondsToSelector:@selector(musicControlView:didDragSlider:)] ) {
        [self.delegate musicControlView:self didDragSlider:slider.value];
    }
}

- (void)setUpTimeLabelWithSeconds:(NSInteger)seconds{
    // 初始化总时长
    NSInteger minute = seconds / 60;
    NSInteger second = seconds - minute * 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];
}

- (void)buttonClick:(UIButton *)sender{
    
    if ( [self.delegate respondsToSelector:@selector(musicControlView:didClickButton:type:)] ) {
        NSInteger tag = sender.tag;
        [self.delegate musicControlView:self didClickButton:sender type:tag];
    }
}

@end
