//
//  MainVC.m
//  AnimationView
//
//  Created by apple on 13-6-6.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "MainVC.h"

#import "DemoTransition.h"
#import "Demo2Transition.h"
#import "Demo3Transition.h"
#import"Demo4Transition.h"
#import"Demo5Transition.h"
#import"Demo6Transition.h"
#import"Demo7Transition.h"
#import"Demo8Transition.h"
#import "EPGLTransitionView.h"

#import "HMGLTransitionManager.h"
#import "Switch3DTransition.h"
#import "FlipTransition.h"
#import "RotateTransition.h"
#import "ClothTransition.h"
#import "DoorsTransition.h"

@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    if (pickerController!=nil) {
        [pickerController release];
    }
    if (player!=nil) {
        [player release];
    }
    [arrNames removeAllObjects];
    [arrNames release];
    [loadV release];
    [aiv release];
    [imageV release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgNum=0;
    
    arrNames=[[NSMutableArray alloc] init];
    
    loadV=[[UIView alloc] initWithFrame:self.view.bounds];
    loadV.backgroundColor=[UIColor blackColor];
    loadV.alpha=0.6;
    aiv=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.center=loadV.center;
    [loadV addSubview:aiv];
    
    UIButton *btnPicker=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPicker setTitle:@"相册" forState:UIControlStateNormal];
    btnPicker.frame=CGRectMake(0, 0, 160, 60);
    [self.view addSubview:btnPicker];
    [btnPicker addTarget:self action:@selector(btnPickerClick:) forControlEvents:UIControlEventTouchUpInside];
    btnPicker.center=CGPointMake(self.view.center.x, self.view.center.y-100);
    
    UIButton *btnPlay=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnPlay setTitle:@"播放" forState:UIControlStateNormal];
    btnPlay.frame=CGRectMake(btnPicker.frame.origin.x, btnPicker.frame.origin.y+btnPicker.frame.size.height+30, 160, 60);
    [self.view addSubview:btnPlay];
    [btnPlay addTarget:self action:@selector(btnPlayClick:) forControlEvents:UIControlEventTouchUpInside];

    
    imageV=[[UIView alloc] initWithFrame:self.view.bounds];
    imageV.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClose)];
    [imageV addGestureRecognizer:tap];
    [tap release];
	// Do any additional setup after loading the view.
}

-(void)imageClose{
    [_timer invalidate];
    [player stop];

    [imageV removeFromSuperview];
    imgNum=-1;
}

-(void)btnPickerClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d",25] forKey:@"MAXPIC"];
    if (pickerController!=nil) {
        [pickerController release];
    }
    pickerController = [[WSAssetPickerController alloc] initWithDelegate:self];
    
    [self presentViewController:pickerController animated:YES completion:NULL];

}

-(void)btnPlayClick:(id)sender{
    imgNum=0;
    if (arrNames.count!=0) {
        if (player!=nil) {
            [player release];
        }
        player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",arc4random()%8+1] ofType:@"mp3"]] error:nil];
        [player play];

        [[UIApplication sharedApplication].keyWindow addSubview:imageV];
        [self performSelector:@selector(animationImage) withObject:[NSString stringWithFormat:@"%d",imgNum]];

    }
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animationImage) userInfo:nil repeats:YES];

}
#define AnimaterImageTransitionDuration       5.0f
#define AnimatedImagesViewImageViewsBorderOffset  30

-(void)animationImage{

    
    UIImage *img=[UIImage imageWithContentsOfFile:[arrNames objectAtIndex:imgNum]];
    
    CGSize imgSize;
    
    if (img.size.width/img.size.height<imageV.frame.size.width/imageV.frame.size.height) {
        imgSize=CGSizeMake(img.size.width/img.size.height*imageV.frame.size.height,imageV.frame.size.height );

    }
    else{
        imgSize=CGSizeMake(imageV.frame.size.width,img.size.height/img.size.width*imageV.frame.size.width );

    }
    
    NSLog(@"imageSize-----%f,%f-------imageVSize-----%f,%f----------imgSize---------%f,%f",imgSize.width,imgSize.height,imageV.frame.size.width,imageV.frame.size.height,img.size.width,img.size.height);

    UIView *tempV=[[UIView alloc] initWithFrame:imageV.bounds];
    tempV.backgroundColor=[UIColor blackColor];
    tempV.userInteractionEnabled=NO;
    
    UIImageView *imgv=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    imgv.center=imageV.center;
    [imgv setImage:img];
    
    int duration=2;

    int randomeTranstion=arc4random()%3;
    
    
    [tempV addSubview:imgv];
    EPGLTransitionView *glview ;
    
    switch (randomeTranstion) {
        case 0:
        	[[HMGLTransitionManager sharedTransitionManager] setTransition:[self animation3DForIndex:arc4random()%4]];
            [[HMGLTransitionManager sharedTransitionManager] beginTransition:imageV];
            
            break;
        case 1:
            duration=1;
            break;
        case 2:

            glview = [[[EPGLTransitionView alloc]
                                           initWithView:imageV
                                           delegate:[self animationEPGForIndex:arc4random()%2]] autorelease];
            [glview prepareTextureTo:tempV];

            break;
        default:
            break;
    }


    [imgv release];
    for (UIView *view in imageV.subviews) {
        [view removeFromSuperview];
    }
    

    [imageV addSubview:tempV];
    

    switch (randomeTranstion) {
        case 0:
            [[HMGLTransitionManager sharedTransitionManager] commitTransition];
            
            break;
        case 1:
            [ControlEffect controlEffect:imageV Effect:[self animationsForIndex:arc4random()%10] subEffect:[self subAnimationsForIndex:arc4random()%4] duration:duration forKey:@"anima"];

            break;
        case 2:
            [glview startTransition];
            break;
        default:
            break;
    }

    [tempV release];

    imgNum++;
    if (imgNum==arrNames.count) {
        [_timer invalidate];
        [player stop];
        [imageV removeFromSuperview];

        return;
    }
}

-(NSObject<EPGLTransitionViewDelegate>*)animationEPGForIndex:(NSInteger)index{
    NSObject<EPGLTransitionViewDelegate> *transition;

    switch (index) {
        case 0:
            transition = [[[DemoTransition alloc] init] autorelease];

            break;
        case 1:
            transition = [[[Demo5Transition alloc] init] autorelease];

            break;
        default:
            transition=nil;
            break;
    }
    return transition;
}

-(HMGLTransition*)animation3DForIndex:(NSInteger)index{
    
    HMGLTransition *transition = nil;

    switch (index) {
        case 0:
            transition = [[[Switch3DTransition alloc] init] autorelease];
            ((Switch3DTransition*)transition).transitionType = arc4random()%2;
            break;
        case 1:
            transition = [[[FlipTransition alloc] init] autorelease];
            ((FlipTransition*)transition).transitionType = arc4random()%2;
            break;
        case 2:
            transition = [[[ClothTransition alloc] init] autorelease];
            break;
        case 3:
            transition = [[[DoorsTransition alloc] init] autorelease];
            break;
        default:
            transition = [[[Switch3DTransition alloc] init] autorelease];
            break;
    }
    
    return transition;
}

-(NSString*)subAnimationsForIndex:(NSInteger)index{
    switch (index) {
        case 0:
            
            return kCATransitionFromRight;
        case 1:
            
            return kCATransitionFromLeft;
        case 2:
            
            return kCATransitionFromTop;
        case 3:
            
            return kCATransitionFromBottom;
        default:
            
            return @"";
    }
}

-(NSString*)animationsForIndex:(NSInteger)index{
    switch (index) {
        case 0:
            
            return kCATransitionFade;
        case 1:
            
            return kCATransitionMoveIn;
        case 2:
            
            return kCATransitionPush;
        case 3:
            
            return kCATransitionReveal;
        case 4:
            
            return @"cube";
        case 5:
            
            return @"suckEffect";
        case 6:
            
            return @"rippleEffect";

        case 7:
            
            return @"pageCurl";

        case 8:
            
            return @"pageUnCurl";
        case 9:
            
            return @"oglFlip";
        case 10:
            
            return @"rotate";
        case 11:
            
            return @"spewEffect";
        case 12:
            
            return @"genieEffect";
        case 13:
            
            return @"unGenieEffect";
        case 14:
            
            return @"twist";
        case 15:
            
            return @"tubey";
        case 16:
            
            return @"swirl";
            
        case 17:
            
            return @"charminUltra";
        case 18:
            
            return @"zoomyIn";
        case 19:
            
            return @"zoomyOut";
        case 20:
            
            return @"oglApplicationSuspend";
        default:
            return @"";
    }
}

#pragma mark - 图片选择库 delegate
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSFileManager *filemanager=[[NSFileManager alloc] init];
        NSError *error=nil;
        if ([filemanager isExecutableFileAtPath:[NSString stringWithFormat:@"%@/Documents/player",NSHomeDirectory()]]) {
            [filemanager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/player",NSHomeDirectory()] error:&error];
            [filemanager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/player",NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:&error];
            
        }
        else{
            [filemanager createDirectoryAtPath:[NSString stringWithFormat:@"%@/Documents/player",NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:&error];
            
        }
        if (error!=nil) {
        }
        [filemanager release];
        
        if (assets.count < 1) return;
        [arrNames removeAllObjects];
        [self.view addSubview:loadV];
        [aiv startAnimating];

        dispatch_queue_t queueSave=dispatch_queue_create("saveImage", NULL);
        dispatch_async(queueSave, ^{
            for (ALAsset *asset in assets) {
                NSData *data=UIImageJPEGRepresentation([UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage], 1);
                [data writeToFile:[NSString stringWithFormat:@"%@/Documents/player/%@.png",NSHomeDirectory(),[asset valueForProperty:ALAssetPropertyDate]] atomically:NO];
                
                [arrNames addObject:[NSString stringWithFormat:@"%@/Documents/player/%@.png",NSHomeDirectory(),[asset valueForProperty:ALAssetPropertyDate]]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [aiv stopAnimating];
                [loadV removeFromSuperview];                
                
            });
        });
        dispatch_release(queueSave);
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
