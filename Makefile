export THEOS_DEVICE_IP=192.168.1.7


ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = MessageSwiper7
MessageSwiper7_FILES = Tweak.xm
MessageSwiper7_FRAMEWORKS = UIKit QuartzCore Foundation CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
