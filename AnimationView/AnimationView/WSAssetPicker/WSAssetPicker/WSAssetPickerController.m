//
//  WSAssetPickerController.m
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

#import "WSAssetPickerController.h"
#import "WSAssetPickerState.h"
#import "WSAlbumTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WSAssetPickerController ()
@property (nonatomic, strong) WSAssetPickerState *assetPickerState;
@property (nonatomic, readwrite) NSUInteger selectedCount;
@property (nonatomic) UIStatusBarStyle originalStatusBarStyle;
@end


@implementation WSAssetPickerController

@dynamic selectedAssets;

@synthesize assetPickerState = _assetPickerState;
@synthesize selectedCount = _selectedCount;
@synthesize originalStatusBarStyle = _originalStatusBarStyle;


#pragma mark - Initialization

- (id)initWithDelegate:(id <WSAssetPickerControllerDelegate>)delegate;
{
    // Create the Album TableView Controller.
    WSAlbumTableViewController *albumTableViewController = [[WSAlbumTableViewController alloc] initWithStyle:UITableViewStylePlain];
    albumTableViewController.assetPickerState = self.assetPickerState;
    
    if ((self = [super initWithRootViewController:albumTableViewController])) {
      self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.toolbar.barStyle = UIBarStyleBlackTranslucent;
        self.delegate = delegate;
    }
    
    return self;
}

#define STATE_KEY @"state"
#define SELECTED_COUNT_KEY @"selectedCount"
- (WSAssetPickerState *)assetPickerState
{
    if (!_assetPickerState) {
        _assetPickerState = [[WSAssetPickerState alloc] init];
    }
    return _assetPickerState;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    
    // Start observing state changes and selectedCount changes.
    [_assetPickerState addObserver:self forKeyPath:STATE_KEY options:NSKeyValueObservingOptionNew context:NULL];
    [_assetPickerState addObserver:self forKeyPath:SELECTED_COUNT_KEY options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.originalStatusBarStyle animated:YES];
    
    // Stop observing state changes and selectedCount changes.
    [_assetPickerState removeObserver:self forKeyPath:STATE_KEY];
    [_assetPickerState removeObserver:self forKeyPath:SELECTED_COUNT_KEY];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if (![object isEqual:self.assetPickerState]) return;
    
    if ([STATE_KEY isEqualToString:keyPath]) {     
        
        // Cast the delegate to the assetPickerDelegate.
        id <WSAssetPickerControllerDelegate> delegate = (id <WSAssetPickerControllerDelegate>)self.delegate;
        
        if (WSAssetPickerStatePickingCancelled == self.assetPickerState.state) {
            if ([delegate conformsToProtocol:@protocol(WSAssetPickerControllerDelegate)]) {
                [delegate assetPickerControllerDidCancel:self];
            }
        } else if (WSAssetPickerStatePickingDone == self.assetPickerState.state) {
            if ([delegate conformsToProtocol:@protocol(WSAssetPickerControllerDelegate)]) {
                if (self.assetPickerState.selectedAssets.count>0) {
                    float alldate=0;
                    for (int i=0; i<self.assetPickerState.selectedAssets.count-1; i++) {
                        NSDate *date1=[[self.assetPickerState.selectedAssets objectAtIndex:i] valueForProperty:ALAssetPropertyDate];
                        NSDate *date2=[[self.assetPickerState.selectedAssets objectAtIndex:i+1] valueForProperty:ALAssetPropertyDate];
                        alldate+=fabs([date1 timeIntervalSinceDate:date2]);
                    }
                    [[NSUserDefaults standardUserDefaults] setFloat:alldate/(self.assetPickerState.selectedAssets.count-1)*0.618 forKey:@"TimeDensity"];
                    
                }

                [delegate assetPickerController:self didFinishPickingMediaWithAssets:self.assetPickerState.selectedAssets];
            }
        }
    } else if ([SELECTED_COUNT_KEY isEqualToString:keyPath]) {
        
        self.selectedCount = self.assetPickerState.selectedCount;
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
