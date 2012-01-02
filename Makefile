export THEOS_DEVICE_IP=172.18.0.161
SDKVERSION = 5.0
include /usr/local/theos/makefiles/common.mk

LIBRARY_NAME = SimpleBrightnessSlider
SimpleBrightnessSlider_FILES = SimpleBrightnessSlider.mm
SimpleBrightnessSlider_INSTALL_PATH = /System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle
SimpleBrightnessSlider_FRAMEWORKS = UIKit CoreGraphics
SimpleBrightnessSlider_PRIVATE_FRAMEWORKS = BulletinBoard GraphicsServices

include $(THEOS_MAKE_PATH)/library.mk

after-stage::
	mv _/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/SimpleBrightnessSlider.dylib _/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/SimpleBrightnessSlider
	cp -a *.png _/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/
	cp Info.plist _/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/
	cp *.strings _/System/Library/WeeAppPlugins/SimpleBrightnessSlider.bundle/