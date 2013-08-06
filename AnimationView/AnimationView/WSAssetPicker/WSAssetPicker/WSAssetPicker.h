//
//  WSAssetPicker.h
//  WSAssetPicker
//
//  Created by Wesley Smith on 5/21/12.
//  Copyright (c) 2012 Wesley D. Smith. All rights reserved.
//
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WSAssetPickerController.h"
//#define WSTableTitleShow if (self.assetPickerState.selectedCount==0) {self.navigationItem.title = [NSString stringWithFormat:@"%@", [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];}else{self.navigationItem.title = [NSString stringWithFormat:@"(可选%d张)%@",MaxCount-_assetPickerState.selectedCount, [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName]];}
#define LoadingStr @"加载中…"
#define AlbumStr @"相簿"
#define SELECTED_IMAGE @"WSAssetPicker.Bundle/Images/WSAssetPicker_SelectImage@2x.png"
#define TimeDensity [[NSUserDefaults standardUserDefaults] valueForKey:@"TimeDensity"]
#define WSTableNavBgView @"WSAssetPicker.Bundle/Images/WSAssetPicker_TopBg@2x.png" 
#define WSTableNavBack @"WSAssetPicker.Bundle/Images/WSAssetPicker_TopCancel@2x.png"
#define WSTabelNavRight @"WSAssetPicker.Bundle/Images/WSAssetPicker_TopOK@2x.png"
#define WSTableBgView @"WSAssetPicker.Bundle/Images/WSAssetPicker_Bg@2x.png"
#define WStableCellSeqLine @"WSAssetPicker.Bundle/Images/WSAssetPicker_CellLine.@2xpng"
#define ROW_HEIGHT 60.0f