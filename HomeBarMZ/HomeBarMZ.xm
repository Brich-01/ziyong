#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>

static HBPreferences *prefs;
static BOOL enabled = YES;
static CGFloat tapAreaHeight = 30;
static BOOL hapticEnabled = YES;
static NSArray *excludedApps = @[];

%hook SBHomeGrabberView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    static NSTimeInterval lastTouch = 0;
    if (CACurrentMediaTime() - lastTouch < 0.3) return;
    lastTouch = CACurrentMediaTime();
    
    %orig;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!enabled) return %orig;
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    
    // 动态获取排除应用
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if ([excludedApps containsObject:bundleID]) return %orig;
    
    CGRect activeArea = CGRectMake(0, (self.bounds.size.height - tapAreaHeight)/2, 
                                 self.bounds.size.width, tapAreaHeight);
    
    if (CGRectContainsPoint(activeArea, loc)) {
        [self performReturnAction];
        if (hapticEnabled) {
            [[UIImpactFeedbackGenerator new] impactOccurredWithIntensity:0.7];
        }
        return;
    }
    
    %orig;
}

%new
- (void)performReturnAction {
    UIViewController *topVC = [self _topMostController];
    
    // 安全执行返回操作
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([topVC.navigationController.viewControllers count] > 1) {
            [topVC.navigationController popViewControllerAnimated:YES];
        } else if (topVC.presentingViewController) {
            [topVC dismissViewControllerAnimated:YES completion:nil];
        } else if ([topVC respondsToSelector:@selector(close)]) {
            [topVC performSelector:@selector(close)];
        }
    });
}

%end

// 兼容游戏全屏模式
%hook UIWindow
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = %orig;
    
    if ([NSStringFromClass([view class]) isEqualToString:@"SBHomeGrabberView"]) {
        return %orig;
    }
    
    return view;
}
%end

// 配置加载
static void loadPrefs() {
    prefs = [[HBPreferences alloc] initWithIdentifier:@"com.yourname.dopaminereturn"];
    [prefs registerDefaults:@{
        @"enabled": @YES,
        @"tapAreaHeight": @30,
        @"hapticFeedback": @YES,
        @"excludedApps": @[]
    }];
    
    [prefs registerBool:&enabled forKey:@"enabled"];
    [prefs registerFloat:&tapAreaHeight forKey:@"tapAreaHeight"]; 
    [prefs registerBool:&hapticEnabled forKey:@"hapticFeedback"];
    [prefs registerObject:&excludedApps forKey:@"excludedApps"];
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)loadPrefs,
        CFSTR("com.yourname.dopaminereturn/prefsChanged"),
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );
}
