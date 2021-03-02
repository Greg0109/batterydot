TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BatteryDot

BatteryDot_FILES = BDPRootListController.m
BatteryDot_FRAMEWORKS = UIKit
BatteryDot_PRIVATE_FRAMEWORKS = Preferences
BatteryDot_LIBRARIES = colorpicker
BatteryDot_INSTALL_PATH = /Library/PreferenceBundles
BatteryDot_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
