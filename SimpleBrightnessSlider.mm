#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BBWeeAppController-Protocol.h"
#import "GraphicServices.h"
@interface SimpleBrightnessSliderController : NSObject <BBWeeAppController>
{
    UIView *_view;
    UISlider *slider;
}

+ (void)initialize;
- (UIView *)view;

@end

@implementation SimpleBrightnessSliderController

+ (void)initialize
{
    
}

- (void)dealloc
{
    [_view release];
    [slider release];
    [super dealloc];
}

- (UIView *)view 
{
    if (_view == nil)
    {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        _view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        int width = CGRectGetWidth(_view.bounds);
        UIImage *trackThumb = [UIImage imageNamed:@"SwitcherSliderThumb.png"];
        UIImage *trackMin = [[UIImage imageNamed:@"SwitcherSliderTrackMin.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 5)];
        UIImage *trackMax = [[UIImage imageNamed:@"SwitcherSliderTrackMax.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 5)];

        slider = [[UISlider alloc] initWithFrame: CGRectMake(44, 0, width - 88, 30)];
        slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        [slider setThumbImage: trackThumb forState:UIControlStateNormal];
        [slider setMinimumTrackImage:trackMin forState:UIControlStateNormal];
        [slider setMaximumTrackImage:trackMax forState:UIControlStateNormal];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        slider.continuous = YES;
        [_view addSubview:slider];

        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/LessBright.png"]];
        iconView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        iconView.frame = CGRectMake(14, 7, 16, 16);
        [_view addSubview:iconView];
        [iconView release];

        iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/MoreBright.png"]];
        iconView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        iconView.frame = CGRectMake(width - 34, 3, 24, 24);
        [_view addSubview:iconView];
        [iconView release];

        [slider release];
    }
    
    return _view;
}

- (void)viewDidAppear
{
    NSNumber *val = (NSNumber*)CFPreferencesCopyAppValue(CFSTR("SBBacklightLevel2" ), CFSTR("com.apple.springboard"));
    slider.value = [val floatValue];
}

- (void)sliderUpdated:(id)sender
{
    GSEventSetBacklightLevel(slider.value);
}

- (float)viewHeight
{
    return 30.0f;
}

@end