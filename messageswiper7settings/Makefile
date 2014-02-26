
ARCHS = armv7 arm64
TARGET := iphone:7.0:2.0
include theos/makefiles/common.mk

BUNDLE_NAME = MessageSwiper7Settings
MessageSwiper7Settings_FILES = MessageSwiper7Settings.mm
MessageSwiper7Settings_INSTALL_PATH = /Library/PreferenceBundles
MessageSwiper7Settings_FRAMEWORKS = UIKit
MessageSwiper7Settings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MessageSwiper7Settings.plist$(ECHO_END)
