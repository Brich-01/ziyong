ARCHS = arm64
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard MobileSMS MobileMail Safari# 根据需要添加更多应用

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeBarReturn

HomeBarReturn_FILES = Tweak.x
HomeBarReturn_CFLAGS = -fobjc-arc
HomeBarReturn_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
