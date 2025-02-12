ARCHS = arm64
TARGET = iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeBarReturn

HomeBarReturn_FILES = Tweak.x
HomeBarReturn_CFLAGS = -fobjc-arc
HomeBarReturn_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
