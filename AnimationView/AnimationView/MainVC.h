//
//  MainVC.h
//  AnimationView
//
//  Created by apple on 13-6-6.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "controlEffect.h"
#import "WSAssetPicker.h"
#import <AVFoundation/AVFoundation.h>
@interface MainVC : UIViewController<WSAssetPickerControllerDelegate>{
    WSAssetPickerController *pickerController;
    NSMutableArray *arrNames;
    UIActivityIndicatorView *aiv;
    UIView *loadV;
    UIView *imageV;
    AVAudioPlayer *player;

}



@end
