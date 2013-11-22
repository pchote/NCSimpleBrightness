/*
* Copyright (c) 2012, Paul Chote
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this
* list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright notice,
* this list of conditions and the following disclaimer in the documentation
* and/or other materials provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "BBWeeAppController-Protocol.h"
#import "Springboard-Class.h"
@interface SimpleBrightnessSliderController : NSObject <BBWeeAppController>
{
    UIView *mainView;
    UISlider *slider;
}

+ (void)initialize;
- (UIView *)view;

@end

@implementation SimpleBrightnessSliderController

+ (void)initialize {}
- (float)viewHeight { return 34; }

- (UIView *)view 
{
    if (mainView == nil)
    {
        CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
        mainFrame.size.height = [self viewHeight];

        mainView = [[UIView alloc] initWithFrame:mainFrame];
        mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        float margin = 44;

        // Brightness slider
        {
            UIImage *trackThumb = [UIImage imageNamed:@"SwitcherSliderThumb.png"];
            UIImage *trackMin = [[UIImage imageNamed:@"SwitcherSliderTrackMin.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 5)];
            UIImage *trackMax = [[UIImage imageNamed:@"SwitcherSliderTrackMax.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 5)];
            CGRect sliderFrame = CGRectMake(margin, 0, mainFrame.size.width - 2*margin, mainFrame.size.height);

            slider = [[UISlider alloc] initWithFrame:sliderFrame];
            slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
            [slider setBackgroundColor:[UIColor clearColor]];
            [slider setThumbImage: trackThumb forState:UIControlStateNormal];
            [slider setMinimumTrackImage:trackMin forState:UIControlStateNormal];
            [slider setMaximumTrackImage:trackMax forState:UIControlStateNormal];
            slider.minimumValue = 0.0;
            slider.maximumValue = 1.0;
            slider.continuous = YES;
            [mainView addSubview:slider];
        }

        // 'Less bright' icon
        {
            float iconSize = 16;
            UIImageView *lessIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/LessBright.png"]];
            lessIcon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
            lessIcon.frame = CGRectMake((margin - iconSize)/2, ([self viewHeight] - iconSize)/2, iconSize, iconSize);
            [mainView addSubview:lessIcon];
            [lessIcon release];
        }

        // 'More bright' icon
        {
            float iconSize = 24;
            UIImageView *moreIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/MoreBright.png"]];
            moreIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            moreIcon.frame = CGRectMake(mainFrame.size.width - (margin + iconSize)/2, ([self viewHeight] - iconSize)/2, iconSize, iconSize);
            [mainView addSubview:moreIcon];
            [moreIcon release];
        }
    }
    return mainView;
}

- (void)dealloc
{
    [mainView release];
    [slider release];
    [super dealloc];
}

- (void)viewDidAppear
{
    slider.value = [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] systemBacklightLevel];
}

- (void)sliderUpdated:(id)sender
{
    [(SpringBoard *)[objc_getClass("SpringBoard") sharedApplication] setBacklightLevel:slider.value permanently:YES];
}

@end