# 编译架构设置（必须包含arm64e）
ARCHS = arm64 arm64e

# 目标系统版本和部署版本
TARGET = iphone:clang:16.0:13.0

# 调试模式开关（正式发布时设为0）
DEBUG = 0

# 项目基本信息
THEOS_PACKAGE_NAME = com.yourname.dopaminereturn
DopamineReturn_NAME = DopamineReturn
DopamineReturn_BUNDLE_NAME = DopamineReturnPrefs

# 文件包含配置
include $(THEOS)/makefiles/common.mk

# Tweak配置
TWEAK_NAME = DopamineReturn
DopamineReturn_FILES = Tweak.xm
DopamineReturn_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unsupported-availability-guard

# 依赖框架配置
DopamineReturn_FRAMEWORKS = UIKit CoreGraphics
DopamineReturn_PRIVATE_FRAMEWORKS = SpringBoardServices

# Cephei依赖配置（用于偏好设置）
DopamineReturn_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
DopamineReturn_LIBRARIES += cephei

# 偏好设置包配置
include $(THEOS_MAKE_PATH)/bundle.mk

DopamineReturnPrefs_INSTALL_PATH = /Library/PreferenceBundles
DopamineReturnPrefs_FILES = Preferences/$(DopamineReturn_BUNDLE_NAME).m
DopamineReturnPrefs_FRAMEWORKS = UIKit
DopamineReturnPrefs_PRIVATE_FRAMEWORKS = Preferences
DopamineReturnPrefs_EXTRA_FRAMEWORKS += Cephei CepheiPrefs
DopamineReturnPrefs_LIBRARIES += cephei

# 资源文件配置
DopamineReturnPrefs_CFLAGS += -fobjc-arc
SUBPROJECTS += dopaminereturnprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

# 安装配置
INSTALL_TARGET_PROCESSES = SpringBoard backboardd

# 清理编译缓存
after-install::
	install.exec "killall -9 SpringBoard backboardd"

# 自动注入Dopamine兼容层
internal-package-check::
	@if [ -f $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/$(TWEAK_NAME).dylib ]; then \
		/opt/Dopamine/bin/roothelper --install-tweak $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/$(TWEAK_NAME).dylib; \
	fi
