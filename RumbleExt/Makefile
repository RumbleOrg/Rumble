TARGET := iphone:clang:latest:9.0
ARCHS = arm64e arm64 armv7
INSTALL_TARGET_PROCESSES = Rumble
ADDITIONAL_OBJCFLAGS = -Wunguarded-availability

include $(THEOS)/makefiles/common.mk
define abi_fix
ifneq ($(THEOS_PLATFORM_NAME),macosx)
# New ABI (i.e. objc ptrauth modifications)
# is available on AppleClang on MacOS only.
# These flags make oldabi package fix our library.
$(1)_CFLAGS += -fno-ptrauth-abi-version
$(1)_LDFLAGS += -ld_classic
endif
endef

LIBRARY_NAME := yaml lwip hev-task-system hev-socks5-tunnel byedpi

SRCDIR := hev-socks5-tunnel/third-part/yaml/src
include hev-socks5-tunnel/third-part/yaml/build.mk
-include hev-socks5-tunnel/third-part/yaml/configs.mk
yaml_FILES := $(SRCFILES)
yaml_LINKAGE_TYPE := static
yaml_CFLAGS := -I$(SRCDIR) $(CONFIG_CFLAGS) -L$(THEOS_OBJ_DIR)
yaml_LDFLAGS := -L$(THEOS_OBJ_DIR)
yaml_USE_MODULES := 0
$(eval $(call abi_fix,yaml))
CONFIG_CFLAGS :=
SRCFILES :=

SRCDIR := hev-socks5-tunnel/third-part/lwip/src
include hev-socks5-tunnel/third-part/lwip/build.mk
-include hev-socks5-tunnel/third-part/lwip/configs.mk
lwip_FILES := $(SRCFILES)
lwip_LINKAGE_TYPE := static
lwip_CFLAGS := \
	       -I$(SRCDIR)/include \
	       -I$(SRCDIR)/ports/include \
	       $(CONFIG_CFLAGS) \
	       -Wno-ambiguous-macro \
	       -Wno-unused-function
lwip_LDFLAGS := -L$(THEOS_OBJ_DIR)
lwip_USE_MODULES := 0
$(eval $(call abi_fix,lwip))
CONFIG_CFLAGS :=
SRCFILES :=

SRCDIR := hev-socks5-tunnel/third-part/hev-task-system/src
include hev-socks5-tunnel/third-part/hev-task-system/build.mk
-include hev-socks5-tunnel/third-part/hev-task-system/configs.mk
hev-task-system_FILES := $(SRCFILES)
hev-task-system_LINKAGE_TYPE := static
hev-task-system_CFLAGS := \
	-I$(SRCDIR) \
	-I$(SRCDIR)/../include \
	$(CONFIG_CFLAGS)
hev-task-system_LDFLAGS := -L$(THEOS_OBJ_DIR)
hev-task-system_USE_MODULES := 0
$(eval $(call abi_fix,hev-task-system))
CONFIG_CFLAGS :=
SRCFILES :=

SRCDIR := hev-socks5-tunnel/src
include hev-socks5-tunnel/build.mk
-include hev-socks5-tunnel/configs.mk
hev-socks5-tunnel_FILES := $(SRCFILES)
hev-socks5-tunnel_LINKAGE_TYPE := static
hev-socks5-tunnel_CFLAGS := \
	-I$(SRCDIR) \
	-I$(SRCDIR)/misc \
	-I$(SRCDIR)/core/include \
	-I$(SRCDIR)/../third-part/yaml/include \
	-I$(SRCDIR)/../third-part/lwip/src/include \
	-I$(SRCDIR)/../third-part/lwip/src/ports/include \
	-I$(SRCDIR)/../third-part/hev-task-system/include \
	$(CONFIG_CFLAGS) $(VERSION_CFLAGS)
hev-socks5-tunnel_LDFLAGS := \
	-L$(THEOS_OBJ_DIR) \
	$(THEOS_OBJ_DIR)/yaml.a \
	$(THEOS_OBJ_DIR)/lwip.a \
	$(THEOS_OBJ_DIR)/hev-task-system.a
hev-socks5-tunnel_USE_MODULES := 0
$(eval $(call abi_fix,hev-socks5-tunnel))
CONFIG_CFLAGS :=
SRCFILES :=

byedpi_FILES := \
		byedpi/packets.c \
		byedpi/main.c \
		byedpi/conev.c \
		byedpi/proxy.c \
		byedpi/desync.c \
		byedpi/mpool.c \
		byedpi/extend.c
byedpi_LINKAGE_TYPE := static
byedpi_CFLAGS := \
		 -Dmain=ciadpi_main \
		 -Ibyedpi \
		 -Wno-unused-variable \
		 -Wno-unused-function \
		 -Wno-deprecated-declarations
byedpi_LDFLAGS := -L$(THEOS_OBJ_DIR)
byedpi_USE_MODULES := 0
$(eval $(call abi_fix,byedpi))

include $(THEOS_MAKE_PATH)/library.mk

APPEX_NAME = RumbleExt

RumbleExt_FILES = PacketTunnelProvider.m
RumbleExt_FRAMEWORKS = NetworkExtension
RumbleExt_CFLAGS = -fobjc-arc -Ihev-socks5-tunnel/include
RumbleExt_LDFLAGS = \
		    -L$(THEOS_OBJ_DIR) \
		    $(THEOS_OBJ_DIR)/hev-socks5-tunnel.a \
		    $(THEOS_OBJ_DIR)/byedpi.a\
		    $(THEOS_OBJ_DIR)/yaml.a \
		    $(THEOS_OBJ_DIR)/lwip.a \
		    $(THEOS_OBJ_DIR)/hev-task-system.a
RumbleExt_CODESIGN_FLAGS = -Sentitlements.xml
RumbleExt_USE_MODULES := 0
$(eval $(call abi_fix,RumbleExt))
RumbleExt_INSTALL_PATH = /Applications/Rumble.app/PlugIns

include $(THEOS_MAKE_PATH)/appex.mk

