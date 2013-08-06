//
//  WSAssetTableViewController.m
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

#import "WSAssetTableViewController.h"
#import "WSAssetPickerState.h"
#import "WSAssetsTableViewCell.h"
#import "WSAssetWrapper.h"
#import "WSAssetPicker.h"

#define ASSET_WIDTH_WITH_PADDING 79.0f

@interface WSAssetTableViewController () <WSAssetsTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *fetchedAssets;
@property (nonatomic, readonly) NSInteger assetsPerRow;
@end


@implementation WSAssetTableViewController

@synthesize assetPickerState = _assetPickerState;
@synthesize assetsGroup = _assetsGroup;
@synthesize fetchedAssets = _fetchedAssets;
@synthesize assetsPerRow =_assetsPerRow;


#pragma mark - View Lifecycle

#define TABLEVIEW_INSETS UIEdgeInsetsMake(2, 0, 2, 0);
int MaxCount;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.wantsFullScreenLayout = YES;
    
    // Setup the toolbar if there are items in the navigationController's toolbarItems.
    if (self.navigationController.toolbarItems.count > 0) {
        self.toolbarItems = self.navigationController.toolbarItems;
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    self.assetPickerState.state = WSAssetPickerStatePickingAssets;

}

- (void)viewWillDisappear:(BOOL)animated
{
    // Hide the toolbar in the event it's being displayed.
    if (self.navigationController.toolbarItems.count > 0) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
    
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad
{
    self.navigationItem.title = LoadingStr;
    
    
    UIButton *btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame=CGRectMake(0, 0, 64, 32);
    [btnBack setBackgroundImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:WSTableNavBack]] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = left;

    
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 64, 32);
    [rightBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:WSTabelNavRight]] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;

    UIImageView *bgView = [[UIImageView alloc]initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:WSTableBgView]]];
    [bgView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:bgView];
    
    
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
//                                                                                           target:self
//                                                                                           action:@selector(doneButtonAction:)];
    topLableOne = [[UILabel alloc]initWithFrame:CGRectMake(60, 15 + 64, 200, 15)];
    topLableOne.textAlignment = NSTextAlignmentCenter;
    topLableOne.backgroundColor = [UIColor clearColor];
    topLableOne.textColor = [UIColor whiteColor];
    topLableOne.font = [UIFont systemFontOfSize:14];
    topLableOne.text = @"选择了0张照片";
    [self.view addSubview:topLableOne];
    
    twoLableTwo = [[UILabel alloc]initWithFrame:CGRectMake(60, 38 + 64, 200, 13)];
    twoLableTwo.textAlignment = NSTextAlignmentCenter;
    twoLableTwo.textColor = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1.0f];
    twoLableTwo.font = [UIFont systemFontOfSize:14];
    twoLableTwo.backgroundColor = [UIColor clearColor];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"MAXPIC"]!=nil)
    {
        MaxCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"MAXPIC"] integerValue];
        twoLableTwo.text =[NSString stringWithFormat:@"还可以选择%d张",MaxCount];

    }
    [self.view addSubview:twoLableTwo];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 128, 320, self.view.frame.size.height - 128) style:UITableViewStylePlain];
    // TableView configuration.
   self.tableView.contentInset = TABLEVIEW_INSETS;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    self.tableView.allowsSelection = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    // Fetch the assets.
    [self fetchAssets];

    _assetsPerRow = MAX(1, (NSInteger)floorf(self.tableView.frame.size.width / ASSET_WIDTH_WITH_PADDING));
}

- (void)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    self.assetPickerState.state = WSAssetPickerStatePickingCancelled;
}

#pragma mark - Getters

- (NSMutableArray *)fetchedAssets
{
    if (!_fetchedAssets) {
        _fetchedAssets = [NSMutableArray array];
    }
    return _fetchedAssets;
}

//- (NSInteger)assetsPerRow
//{
//    NSLog(@"%d",(NSInteger)floorf(self.tableView.contentSize.width ));
//    return MAX(1, (NSInteger)floorf(self.tableView.contentSize.width / ASSET_WIDTH_WITH_PADDING));
//}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];
}


#pragma mark - Fetching Code
#define theROW_HEIGHT 79.0f

- (void)fetchAssets
{
    // TODO: Listen to ALAssetsLibrary changes in order to update the library if it changes. 
    // (e.g. if user closes, opens Photos and deletes/takes a photo, we'll get out of range/other error when they come back.
    // IDEA: Perhaps the best solution, since this is a modal controller, is to close the modal controller.
    
    dispatch_queue_t enumQ = dispatch_queue_create("AssetEnumeration", NULL);
    
    dispatch_async(enumQ, ^{
        
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (!result || index == NSNotFound) {
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self.tableView reloadData];
                    self.tableView.contentOffset=CGPointMake(0, (ceil(self.fetchedAssets.count/4)<6?0:(ceil(self.fetchedAssets.count/4)+1))*theROW_HEIGHT-(ceil(self.fetchedAssets.count/4)<6?0:self.tableView.frame.size.height));


                    self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
                    NSEnumerator *enumerator = [self.fetchedAssets reverseObjectEnumerator];
                                        
                    self.fetchedAssets =[NSMutableArray  arrayWithArray:[enumerator allObjects]];
//                    if (self.fetchedAssets.count>0) {
//                        float alldate=0;
//                        for (int i=0; i<self.fetchedAssets.count-1; i++) {
//                            NSDate *date1=[((WSAssetWrapper*)[self.fetchedAssets objectAtIndex:i]).asset valueForProperty:ALAssetPropertyDate];
//                            NSDate *date2=[((WSAssetWrapper*)[self.fetchedAssets objectAtIndex:i+1]).asset valueForProperty:ALAssetPropertyDate];
//                            alldate+=fabs([date1 timeIntervalSinceDate:date2]);
//                        }
//                        [[NSUserDefaults standardUserDefaults] setFloat:alldate/(self.fetchedAssets.count-1)*0.618 forKey:@"TimeDensity"];
//
//                    }

                });

                return;
            }
            
            WSAssetWrapper *assetWrapper = [[WSAssetWrapper alloc] initWithAsset:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.fetchedAssets addObject:assetWrapper];
                
            });
            
        }];

    });
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    dispatch_release(enumQ);
#endif

    
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - Actions

- (void)doneButtonAction:(id)sender
{     
    self.assetPickerState.state = WSAssetPickerStatePickingDone;
}


#pragma mark - WSAssetsTableViewCellDelegate Methods

- (void)assetsTableViewCell:(WSAssetsTableViewCell *)cell didSelectAsset:(BOOL)selected atColumn:(NSUInteger)column
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // Calculate the index of the corresponding asset.
    NSUInteger assetIndex = indexPath.row * self.assetsPerRow + column;
    
    WSAssetWrapper *assetWrapper = [self.fetchedAssets objectAtIndex:assetIndex];
    assetWrapper.selected = selected;
    
    // Update the state object's selectedAssets.
    [self.assetPickerState changeSelectionState:selected forAsset:assetWrapper.asset];
    
  // WSTableTitleShow
    topLableOne.text = [NSString stringWithFormat:@"选择了%d张照片",_assetPickerState.selectedCount];
    twoLableTwo.text = [NSString stringWithFormat:@"还可以选择%d张照片",MaxCount-_assetPickerState.selectedCount];
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.fetchedAssets.count + self.assetsPerRow - 1) / self.assetsPerRow;
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)indexPath
{    
    NSRange assetRange;
 
    
    assetRange.location = indexPath.row * self.assetsPerRow;
    assetRange.length = self.assetsPerRow;
  
    if (assetRange.length > self.fetchedAssets.count - assetRange.location) {
        assetRange.length = self.fetchedAssets.count - assetRange.location;
    }

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:assetRange];
    // Return the range of assets from fetchedAssets.
    return [self.fetchedAssets objectsAtIndexes:indexSet];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AssetCellIdentifier = @"WSAssetCell";
    WSAssetsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AssetCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[WSAssetsTableViewCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:AssetCellIdentifier];        
    } else {
        
        cell.cellAssetViews = [self assetsForIndexPath:indexPath];
    }
    cell.delegate = self;
    
    return cell;
}


#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
	return theROW_HEIGHT;
}

@end
