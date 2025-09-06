TARGET := iphone:clang:latest:7.0
ARCHS = arm64e arm64 armv7
INSTALL_TARGET_PROCESSES = Rumble

include $(THEOS)/makefiles/common.mk

APPEX_NAME = RumbleExt

RumbleExt_FILES = PacketTunnelProvider.m
RumbleExt_FRAMEWORKS = NetworkExtension
RumbleExt_CFLAGS = -fobjc-arc
RumbleExt_CODESIGN_FLAGS = -Sentitlements.xml
ifneq ($(THEOS_PLATFORM_NAME),macosx)
# New ABI (i.e. objc ptrauth modifications)
# is available on AppleClang on MacOS only.
# These flags make oldabi package fix our library.
RumbleExt_CFLAGS += -fno-ptrauth-abi-version
RumbleExt_LDFLAGS = -ld_classic
endif
RumbleExt_INSTALL_PATH = /Applications/Rumble.app/PlugIns

include $(THEOS_MAKE_PATH)/appex.mk
