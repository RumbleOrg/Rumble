TARGET := iphone:clang:latest:9.0
ARCHS = arm64e arm64
INSTALL_TARGET_PROCESSES = Rumble
PACKAGE_FORMAT ?= ipa
ADDITIONAL_OBJCFLAGS = -Wunguarded-availability

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = Rumble

Rumble_FILES = \
	       main.m \
	       RMAppDelegate.m \
	       RMSettingsViewController.m \
	       RMRootViewController.m \
	       RMStartStopButton.m \
	       UIBezierPath+gear.m \
	       UIBezierPath+house.m \
	       UIBezierPath+power.m
Rumble_FRAMEWORKS = UIKit CoreGraphics
Rumble_CFLAGS = -fobjc-arc
Rumble_CODESIGN_FLAGS = -Sentitlements.xml
ifneq ($(THEOS_PLATFORM_NAME),macosx)
# New ABI (i.e. objc ptrauth modifications)
# is available on AppleClang on MacOS only.
# These flags make oldabi package fix our library.
Rumble_CFLAGS += -fno-ptrauth-abi-version
Rumble_LDFLAGS = -ld_classic
endif

include $(THEOS_MAKE_PATH)/application.mk
SUBPROJECTS += RumbleExt
include $(THEOS_MAKE_PATH)/aggregate.mk
