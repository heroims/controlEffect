//
//  WSAssetView.m
//  WSAssetPickerController
//
//  Created by Wesley Smith on 5/12/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "WSAssetViewColumn.h"
#import "WSAssetPicker.h"

@interface WSAssetViewColumn ()
@property (nonatomic, weak) UIImageView *selectedView;
@end


@implementation WSAssetViewColumn

@synthesize column = _column;
@synthesize selected = _selected;
@synthesize selectedView = _selectedView;
@synthesize assetPickerState=_assetPickerState;

#pragma mark - Initialization

#define ASSET_VIEW_FRAME CGRectMake(0, 0, 75, 75)
int maxNum;
+ (WSAssetViewColumn *)assetViewWithImage:(UIImage *)thumbnail duration:(NSString*)duration
{
    WSAssetViewColumn *assetView = [[WSAssetViewColumn alloc] initWithImage:thumbnail duration:duration];
    
    return assetView;
}

- (id)initWithImage:(UIImage *)thumbnail duration:(NSString*)duration
{
    if ((self = [super initWithFrame:ASSET_VIEW_FRAME])) {
        
        // Setup a tap gesture.
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTapAction:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        // Add the photo thumbnail.
        UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:ASSET_VIEW_FRAME];
        assetImageView.contentMode = UIViewContentModeScaleToFill;
        assetImageView.image = thumbnail;
        [self addSubview:assetImageView];
        
        if (duration!=nil) {
            UILabel *assetLable=[[UILabel alloc] initWithFrame:CGRectMake(0, assetImageView.frame.size.height-15, assetImageView.frame.size.width, 15)];
            assetLable.backgroundColor=[UIColor blackColor];
            double temp=[duration floatValue];
            assetLable.text=[NSString stringWithFormat:@"%d:%02d",((int)round(temp))/60,((int)round(temp))%60];
            assetLable.textAlignment=NSTextAlignmentRight;
            assetLable.textColor=[UIColor whiteColor];
            assetLable.font=[UIFont boldSystemFontOfSize:12];
            [self addSubview:assetLable];
        }
    }
    return self;
}


#pragma mark - Setters/Getters

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected) {
        
        // KVO compliant notifications.
        [self willChangeValueForKey:@"isSelected"];
        _selected = selected;
        [self didChangeValueForKey:@"isSelected"];
        
        // Update the selectedView.
        self.selectedView.hidden = !_selected;
    }
    [self setNeedsDisplay];
}

- (UIImageView *)selectedView
{
    if (!_selectedView) {
        
        // Lazily create the selectedView.
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SELECTED_IMAGE]]];
        imageView.hidden = YES;
        [self addSubview:imageView];
        
        _selectedView = imageView;
    }
    return _selectedView;
}


#pragma mark - Actions

- (void)userDidTapAction:(UITapGestureRecognizer *)sender
{
    // Tell the delegate.
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MAXPIC"]!=nil)
        {
            maxNum = [[[NSUserDefaults standardUserDefaults]objectForKey:@"MAXPIC"] integerValue];
        }
        // Set the selection state.
        self.selected = !self.isSelected;
        if (_assetPickerState.selectedCount>maxNum) {
            self.selected = !self.isSelected;
        }

    }
}
@end
