#import <UIKit/UIKit.h>

@interface SliderSettings : UITableViewController

@end

//https://github.com/MTACS/iOS-17-Runtime-Headers/blob/d1d960dfaa4107765dd7fcf891e4967c0930d5fd/PrivateFrameworks/UIKitCore.framework/_UISliderFluidConfiguration.h

@interface _UISliderFluidConfiguration : NSObject
@property (nonatomic) double expansionFactor;
@property (nonatomic) double stretchLimit;
@property (retain, nonatomic) UIVisualEffect *minimumTrackEffect;
@property (retain, nonatomic) UIVisualEffect *maximumTrackEffect;
@property (retain, nonatomic, setter=_setMinimumTrackBlurEffect:) UIBlurEffect *minimumTrackBlurEffect;
@property (retain, nonatomic, setter=_setMaximumTrackBlurEffect:) UIBlurEffect *maximumTrackBlurEffect;
@end

//https://github.com/MTACS/iOS-17-Runtime-Headers/blob/d1d960dfaa4107765dd7fcf891e4967c0930d5fd/PrivateFrameworks/UIKitCore.framework/UISlider.h

@interface UISlider (Private)
@property (getter=_sliderConfiguration, setter=_setSliderConfiguration:, nonatomic, copy) _UISliderFluidConfiguration *sliderConfiguration;
@property (setter=_setSliderStyle:, nonatomic) unsigned long long _sliderStyle;
@end
