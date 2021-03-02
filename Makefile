INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BatteryDot

BatteryDot_FILES = Tweak.x
BatteryDot_FRAMEWORKS = UIKit
BatteryDot_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += batterydot
include $(THEOS_MAKE_PATH)/aggregate.mk
