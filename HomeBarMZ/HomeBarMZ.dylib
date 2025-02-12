#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 定义HomeBar的触发区域高度（根据实际设备调整）
#define HOMEBAR_HEIGHT 10.0

%hook UIWindow

// 拦截触摸事件
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    // 获取屏幕尺寸
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGFloat screenHeight = screenBounds.size.height;
    
    // 计算HomeBar触发区域（底部中央）
    CGRect homeBarArea = CGRectMake(0, screenHeight - HOMEBAR_HEIGHT, screenBounds.size.width, HOMEBAR_HEIGHT);
    
    // 判断触摸点是否在HomeBar区域
    if (CGRectContainsPoint(homeBarArea, location)) {
        // 执行返回操作
        [self triggerBackAction];
    }
    
    %orig; // 调用原始方法保持其他功能正常
}

// 触发返回逻辑
- (void)triggerBackAction {
    UIViewController *topController = [self topMostViewController];
    
    // 尝试导航控制器出栈
    if ([topController.navigationController.viewControllers count] > 1) {
        [topController.navigationController popViewControllerAnimated:YES];
    }
    // 尝试关闭模态视图
    else if (topController.presentingViewController != nil) {
        [topController dismissViewControllerAnimated:YES completion:nil];
    }
}

// 获取当前顶层视图控制器
- (UIViewController *)topMostViewController {
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}

%end
