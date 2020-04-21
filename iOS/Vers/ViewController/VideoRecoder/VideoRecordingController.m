//
//  VideoRecordingController.m
//  CustomVideoRecording
//
//  Created by 郭伟林 on 17/1/18.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "VideoRecordingController.h"
#import "VideoRecordingManager.h"
#import "VideoRecordingWriter.h"
#import "VideoRecordingProgress.h"
#import "Vers-Swift.h"
#import <AVKit/AVKit.h>

@interface VideoRecordingController () <VideoRecordingManagerDelegate>

@property (nonatomic, strong) VideoRecordingManager *recordingManager;

@property (nonatomic, weak) VideoRecordingProgress *recordingProgress;

@property (nonatomic, weak) UIView   *topToolBar;
@property (nonatomic, weak) UIView   *leftToolBar;
@property (nonatomic, weak) UIView   *timeClockView;
@property (nonatomic, weak) UIButton *flashBtn;
@property (nonatomic, weak) UIButton *switchCameraBtn;
@property (nonatomic, weak) UIButton *clockBtn;
@property (nonatomic, weak) UIButton *saveBtn;

@property (nonatomic, weak) UIView   *bottomToolBar;
@property (nonatomic, weak) UIButton *startRecordingBtn;
@property (nonatomic, weak) UIButton *playVideoBtn;
@property (nonatomic, weak) UIButton *saveVideoBtn;
@property  SFCountdownView *sfCountdownView;

@property CGFloat recordingTime;

@end

@implementation VideoRecordingController

#pragma mark - Lazy Load

- (VideoRecordingManager *)recordingManager {
    
    if (!_recordingManager) {
        _recordingManager = [[VideoRecordingManager alloc] init];
        _recordingManager.maxRecordingTime = 60.0;
        _recordingManager.delegate = self;
    }
    return _recordingManager;

}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width =  [[UIScreen mainScreen] bounds].size.width;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupTopToolBar];
    [self setupLeftToolBar];
    [self setupBottomToolBar];
    [self setupTimeClockView];
    
    _recordingTime = 60;
    self.recordingManager.previewLayer.frame = CGRectMake(0, 64, width, height);//self.view.bounds
    [self.view.layer insertSublayer:self.recordingManager.previewLayer atIndex:0];
    [self.recordingManager startCapture];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self hideNavigationBar];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    //VersManager.share.istryagain = true;
}

- (void) viewDidAppear:(BOOL)animated
{
    
}

#pragma mark - Setup UI

- (void)setupTopToolBar {
    //CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width =  [[UIScreen mainScreen] bounds].size.width;
    
    UIView *topToolBar = [[UIView alloc] init];
    topToolBar.frame = CGRectMake(0, 0, width, 64);
    topToolBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topToolBar];
    _topToolBar = topToolBar;
    
    CGFloat btnWH = 44;
    CGFloat margin = 15;
    
    UIButton *crossBtn = [[UIButton alloc] init];
    crossBtn.frame = CGRectMake(0, margin, btnWH, btnWH);
    [crossBtn setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:crossBtn];
    //_flashBtn = flashBtn;
   // NSLog(@"%d",VersManager.share.isAcceptScreen);
//    if (VersManager.share.isAcceptScreen) {
//        crossBtn.hidden = true;
//    } else {
//        crossBtn.hidden = false;
//    }
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.frame = CGRectMake((self.topToolBar.frame.size.width - 54), margin, btnWH, btnWH);
    [nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(sendToVC:) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:nextBtn];
    // _switchCameraBtn = switchCameraBtn;
}

- (void)setupLeftToolBar {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    //CGFloat width =  [[UIScreen mainScreen] bounds].size.width;
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    
    CGFloat yPosition = bottomPadding+80;
    
    UIView *leftToolBar = [[UIView alloc] init];
    leftToolBar.frame = CGRectMake(0, (height-220)-yPosition, 60, 220);
    leftToolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:leftToolBar];
    [self.view bringSubviewToFront:leftToolBar];
    leftToolBar = leftToolBar;
    
    CGFloat btnWH = 44;
    CGFloat margin = 10;
    
    UIButton *flashBtn = [[UIButton alloc] init];
    flashBtn.frame = CGRectMake(0, margin, btnWH, btnWH);
    [flashBtn setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
    [flashBtn setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateSelected];
    [flashBtn addTarget:self action:@selector(flashBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolBar addSubview:flashBtn];
    _flashBtn = flashBtn;
    
    UIButton *switchCameraBtn = [[UIButton alloc] init];
    switchCameraBtn.frame = CGRectMake(0 , (flashBtn.frame.origin.y+flashBtn.frame.size.height)+10, btnWH, btnWH);
    [switchCameraBtn setImage:[UIImage imageNamed:@"switch_camera"] forState:UIControlStateNormal];
    [switchCameraBtn addTarget:self action:@selector(switchCameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolBar addSubview:switchCameraBtn];
    _switchCameraBtn = switchCameraBtn;
    
    UIButton *clockBtn = [[UIButton alloc] init];
    clockBtn.frame = CGRectMake(0 , (switchCameraBtn.frame.origin.y+switchCameraBtn.frame.size.height)+10, btnWH, btnWH);
    [clockBtn setImage:[UIImage imageNamed:@"AlarmClock"] forState:UIControlStateNormal];
    [clockBtn addTarget:self action:@selector(clockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftToolBar addSubview:clockBtn];
    _clockBtn = clockBtn;
    
    UIButton *saveBtn = [[UIButton alloc] init];
    saveBtn.frame = CGRectMake(0 , (clockBtn.frame.origin.y+clockBtn.frame.size.height)+5, btnWH, btnWH);
    [saveBtn setImage:[UIImage imageNamed:@"Arrows2"] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveVideoBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [leftToolBar addSubview:saveBtn];
    _saveBtn = saveBtn;
}

- (void)setupTimeClockView {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width =  [[UIScreen mainScreen] bounds].size.width;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideClockview)];
    UIView *blurView = [[UIView alloc] init];
    blurView.frame = CGRectMake(0, 0, width, height);
    blurView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [blurView addGestureRecognizer:tap];
    [self.view addSubview:blurView];
    [self.view bringSubviewToFront:blurView];
    _timeClockView = blurView;
    _timeClockView.hidden = true;
    
    UIView *timeClockView = [[UIView alloc] init];
    timeClockView.frame = CGRectMake(((width-247)/2), ((height-207)/2)-40, 247, 207);
    timeClockView.backgroundColor = [UIColor whiteColor];
    timeClockView.layer.cornerRadius = 10;
    timeClockView.layer.masksToBounds = true;
    //timeClockView.layer.borderWidth = 1;
    [blurView addSubview:timeClockView];
    [blurView bringSubviewToFront:timeClockView];
    
    
    
    CGFloat btnWH = timeClockView.frame.size.width;
    CGFloat margin = 44;
    
    UIImage *img1 = [UIImage imageNamed:@"redclock"];
    UIImageView *imgVW1 = [[UIImageView alloc] initWithImage:img1];
    imgVW1.frame = CGRectMake(21, 16, 20, 20);
    [timeClockView addSubview:imgVW1];
    
    UILabel *lblTimer = [[UILabel alloc] init];
    lblTimer.frame = CGRectMake((imgVW1.frame.origin.x+imgVW1.frame.size.width)+5, 16, 50, 20);
    lblTimer.text = @"Timer";
    lblTimer.font = [UIFont fontWithName:@"Rubik-Regular" size:15];
    lblTimer.textColor = [UIColor colorWithRed:207/255.0 green:40/255.0 blue:40/255.0 alpha:1.0];
    [timeClockView addSubview:lblTimer];
    
    UIImage *img2 = [UIImage imageNamed:@"clockgray"];
    UIImageView *imgVW2 = [[UIImageView alloc] initWithImage:img2];
    imgVW2.frame = CGRectMake(timeClockView.frame.size.width-36, 16, 20, 20);
    [timeClockView addSubview:imgVW2];
    
    UIButton *T3sCountdown = [[UIButton alloc] init];
    T3sCountdown.frame = CGRectMake(0, margin, btnWH, 44);
    T3sCountdown.tag = 1;
    [T3sCountdown setTitle:@"3s Countdown" forState:UIControlStateNormal];
    T3sCountdown.titleLabel.font = [UIFont fontWithName:@"Rubik-Medium" size:15];
    [T3sCountdown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, T3sCountdown.frame.size.height - 1.0f, T3sCountdown.frame.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [T3sCountdown addSubview:bottomBorder];
    [T3sCountdown addTarget:self action:@selector(selectRecodingTime:) forControlEvents:UIControlEventTouchUpInside];
    [timeClockView addSubview:T3sCountdown];
    
    
    UIButton *T30sRecordLength = [[UIButton alloc] init];
    T30sRecordLength.frame = CGRectMake(0 , (T3sCountdown.frame.origin.y+T3sCountdown.frame.size.height)+10, btnWH, 44);
    T30sRecordLength.tag = 2;
    [T30sRecordLength setTitle:@"30s Record Length" forState:UIControlStateNormal];
    T30sRecordLength.titleLabel.font = [UIFont fontWithName:@"Rubik-Medium" size:15];
    [T30sRecordLength setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIView *bottomBorder1 = [[UIView alloc] initWithFrame:CGRectMake(0, T30sRecordLength.frame.size.height - 1.0f, T30sRecordLength.frame.size.width, 1)];
    bottomBorder1.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    [T30sRecordLength addSubview:bottomBorder1];
    [T30sRecordLength addTarget:self action:@selector(selectRecodingTime:) forControlEvents:UIControlEventTouchUpInside];
    [timeClockView addSubview:T30sRecordLength];
    
    
    UIButton *T1minRecordLength = [[UIButton alloc] init];
    T1minRecordLength.frame = CGRectMake(0 , (T30sRecordLength.frame.origin.y+T30sRecordLength.frame.size.height)+10, btnWH, 44);
    T1minRecordLength.tag = 3;
    [T1minRecordLength setTitle:@"1 min Record Length" forState:UIControlStateNormal];
    T1minRecordLength.titleLabel.font = [UIFont fontWithName:@"Rubik-Medium" size:15];
    [T1minRecordLength setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [T1minRecordLength addTarget:self action:@selector(selectRecodingTime:) forControlEvents:UIControlEventTouchUpInside];
    [timeClockView addSubview:T1minRecordLength];
    
    
}

- (void)setupBottomToolBar {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width =  [[UIScreen mainScreen] bounds].size.width;
    
    UIView *bottomToolBar = [[UIView alloc] init];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGFloat bottomPadding = window.safeAreaInsets.bottom;
    CGFloat yPosition = bottomPadding+100;
    
    bottomToolBar.frame = CGRectMake(0, height - yPosition, self.view.frame.size.width, yPosition);
    //bottomToolBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:bottomToolBar];
    _bottomToolBar = bottomToolBar;
    
    UIButton *startRecordingBtn = [[UIButton alloc] init];
    startRecordingBtn.frame = CGRectMake((width - 75)/2, (bottomToolBar.frame.size.height - 75)/2, 75, 75);
    [startRecordingBtn setImage:[UIImage imageNamed:@"start_recording"] forState:UIControlStateNormal];
    [startRecordingBtn addTarget:self action:@selector(startRecordingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomToolBar addSubview:startRecordingBtn];
    _startRecordingBtn = startRecordingBtn;
    
    VideoRecordingProgress *recordingProgress = [[VideoRecordingProgress alloc] initWithFrame:_startRecordingBtn.frame];
    recordingProgress.progressTintColor = [UIColor colorWithRed:1.00 green:0.28 blue:0.26 alpha:1.00];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopRecording)];
    [recordingProgress addGestureRecognizer:tap];
    [_bottomToolBar addSubview:recordingProgress];
    _recordingProgress = recordingProgress;
    _recordingProgress.hidden = YES;
    
    UIButton *playVideoBtn = [[UIButton alloc] init];
    playVideoBtn.frame = CGRectMake((_bottomToolBar.frame.size.width - 70), (_bottomToolBar.frame.size.height - 50) * 0.5, 50, 50);
    playVideoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    playVideoBtn.layer.cornerRadius = 8;
    playVideoBtn.layer.borderWidth = 3.0;
    playVideoBtn.layer.borderColor = UIColor.whiteColor.CGColor;
    playVideoBtn.layer.masksToBounds = YES;
    [playVideoBtn addTarget:self action:@selector(playVideoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bottomToolBar addSubview:playVideoBtn];
    _playVideoBtn = playVideoBtn;
    _playVideoBtn.hidden = YES;
    
}

- (void)setUpCountDownView {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width =  [[UIScreen mainScreen] bounds].size.width;
    self.sfCountdownView = [[SFCountdownView alloc] init];
    self.sfCountdownView.frame = CGRectMake(0, 0, width, height);
    self.sfCountdownView.delegate = self;
    self.sfCountdownView.backgroundAlpha = 0.2;
    self.sfCountdownView.countdownColor = [UIColor whiteColor];
    self.sfCountdownView.countdownFrom = 3;
    self.sfCountdownView.finishText = @"Do it";
    [self.sfCountdownView updateAppearance];
    [self.view addSubview:self.sfCountdownView];
    [self performSelector:@selector(countdownStart) withObject:nil afterDelay:0.5];
}

#pragma mark - Actions

- (void)crossBtnAction:(UIButton *)sender {
    
    [self navigateToBackScreen];
}

- (void)sendToVC:(UIButton *)sender {
    
    NSLog(@"---%@",self.recordingManager.videoPath);
    __block NSData *video;
    NSString *videoPath = self.recordingManager.videoPath;
    //    NSURL *realAssetUrl = [NSURL fileURLWithPath:self.recordingManager.videoPath];
    //    AVURLAsset* asset;
    //    asset = [[AVURLAsset alloc]initWithURL:realAssetUrl options:nil];
    //    NSArray *tracks = [asset tracks];
    //    float estimatedSize = 0.0 ;
    //    for (AVAssetTrack * track in tracks) {
    //        float rate = ([track estimatedDataRate] / 8); // convert bits per second to bytes per second
    //        float seconds = CMTimeGetSeconds([track timeRange].duration);
    //        estimatedSize += seconds * rate;
    //    }
    //    float sizeInMB = estimatedSize / 1024 / 1024;
    //    float sizeinGB = sizeInMB / 1024;
    if (videoPath != nil) {
        [self.view showHUD];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            video = [NSData dataWithContentsOfFile:self.recordingManager.videoPath];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.view hideHUD];
                VersManager.share.videoData = video;
            
                if (VersManager.share.isAcceptScreen) {
                    [self acceptChallengApiCall];
                }else if (VersManager.share.istryagain) {
                    [self tryagainChallengApiCall];
                }else {
                    SendToViewController *vc = [[SendToViewController alloc] initWithNibName:@"SendToViewController" bundle:nil];
                    vc.challengeVideo = video;
                    vc.status = @"send_challenge";
                    [self.navigationController pushViewController:vc animated:true];
                }
            });
        });
        
    } else {
        [self showAlertWithTitle:@"" message:@"Please create the challenge first." buttonTitle:@"OK"];
    }
    
}




- (void)hideClockview {
    self.timeClockView.hidden = true;
}

- (void)clockBtnAction:(UIButton *)sender {
    
    self.timeClockView.hidden = false;
}

- (void)selectRecodingTime:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [self setUpCountDownView];
            break;
        case 2:
            self.recordingTime = 30.0;
            break;
        case 3:
            self.recordingTime = 60.0;
            break;
        default:
            break;
    }
    self.timeClockView.hidden = true;
}

- (void) countdownStart {
    [self.sfCountdownView start];
}

- (void)flashBtnAction:(UIButton *)sender {
    
    if (_switchCameraBtn.selected) {
        return;
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.recordingManager openFlashLight];
    } else {
        [self.recordingManager closeFlashLight];
    }
}

- (void)switchCameraBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        _flashBtn.selected = NO;
        [self.recordingManager closeFlashLight];
        [self.recordingManager switchCameraInputDeviceToFront];
    } else {
        [self.recordingManager swithCameraInputDeviceToBack];
    }
}

- (void)startRecordingBtnAction:(UIButton *)sender {
    
    sender.hidden = YES;
    _playVideoBtn.hidden = YES;
    _saveVideoBtn.hidden = YES;
    _recordingProgress.hidden = NO;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self->_topToolBar.transform = CGAffineTransformMakeTranslation(0, -64);
                     } completion:nil];
    self.recordingManager.maxRecordingTime = self.recordingTime;
    [self.recordingManager startRecoring];
}

- (void)playVideoBtnAction {
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:self.recordingManager.videoPath]];
    [self presentViewController:playerViewController animated:YES completion:nil];
}

- (void)saveVideoBtnBtnAction {
    
    [self.recordingManager saveCurrentRecordingVideo];
}

- (void)stopRecording {
    
    _recordingProgress.hidden = YES;
    _startRecordingBtn.hidden = NO;
    _playVideoBtn.hidden = NO;
    _saveVideoBtn.hidden = NO;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self->_topToolBar.transform = CGAffineTransformIdentity;
                     } completion:nil];
    
    [self.recordingManager stopRecordingHandler:^(UIImage *firstFrameImage) {
        [self->_playVideoBtn setImage:firstFrameImage forState:UIControlStateNormal];
    }];
}

#pragma mark - SRRecordingManagerDelegate

- (void)updateRecordingProgress:(CGFloat)progress {
    
    _recordingProgress.progress = progress;
    
    if (progress >= 1.0) {
        [self stopRecording];
    }
}

#pragma - Countdown delegate method

- (void) countdownFinished:(SFCountdownView *)view
{
    [self.sfCountdownView removeFromSuperview];
    [self.view setNeedsDisplay];
    [self startRecordingBtnAction:self.startRecordingBtn];
}

@end
