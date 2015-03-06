//
//  GPMusicControlView.h
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPMusicControlView;

typedef NS_ENUM(NSInteger, GPMusicControlViewButtonType) {
    GPMusicControlViewPlayButton = 100,
    GPMusicControlViewPreviousButton,
    GPMusicControlViewNextButton
};

@protocol GPMusicControlViewDelegate <NSObject>

- (void)musicControlView:(GPMusicControlView *)controlView didClickButton:(UIButton *)button type:(GPMusicControlViewButtonType)buttonType;

- (void)musicControlView:(GPMusicControlView *)controlView didDragSlider:(float)sliderValue;

@end

@interface GPMusicControlView : UIView

@property (nonatomic,assign) float sliderMaxVaulue;

@property (nonatomic,assign) float sliderProgress;

@property (nonatomic,weak) id<GPMusicControlViewDelegate> delegate;

@end
