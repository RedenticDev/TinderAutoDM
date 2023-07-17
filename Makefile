ARCHS = arm64 arm64e
TARGET = iphone:clang:13.5:13.5

INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TinderAutoDM

$(TWEAK_NAME)_FILES = Tweak.x $(wildcard Prefs/*.m) $(wildcard Categories/*.m)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk