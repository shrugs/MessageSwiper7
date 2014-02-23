export THEOS_DEVICE_IP=192.168.1.4
# because the %new fns aren't recognized as existing by the compiler
export GO_EASY_ON_ME=1

ARCHS = armv7 armv7s arm64
include theos/makefiles/common.mk

TWEAK_NAME = MessageSwiper7
MessageSwiper7_FILES = Tweak.xm
MessageSwiper7_FRAMEWORKS = UIKit QuartzCore Foundation
MessageSwiper7_PRIVATE_FRAMEWORKS = CoreGraphics

THEOS_BUILD_DIR = debs

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"

SUBPROJECTS += messageswiper7settings
include $(THEOS_MAKE_PATH)/aggregate.mk
