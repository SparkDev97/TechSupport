FRAMEWORK_NAME = TechSupport
FRAMEWORK_ID = jp.ashikase.TechSupport

TechSupport_OBJC_FILES = \
    lib/TSContactViewController.m \
    lib/TSEmailInstruction.m \
    lib/TSHTMLViewController.m \
    lib/TSIncludeInstruction.m \
    lib/TSInstruction.m \
    lib/TSLinkInstruction.m \
    lib/TSPackage.m \
    lib/TSPackageCache.m
TechSupport_FRAMEWORKS = MessageUI UIKit WebKit
TechSupport_LIBRARIES = packageinfo
ADDITIONAL_CFLAGS = -DFRAMEWORK_ID=\"$(FRAMEWORK_ID)\" -ILibraries/Common -Iinclude -include firmware.h -include include.pch -Wno-deprecated-declarations
ADDITIONAL_LDFLAGS = -Wl,-segalign,4000

export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222

TARGET = iphone:latest:7.0
export ARCHS = arm64 arm64e
export SDKVERSION = 13.3
export SYSROOT = $(THEOS)/sdks/iPhoneOS13.3.sdk

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/framework.mk

after-stage::
	# Copy localization files.
	- cp -a $(THEOS_PROJECT_DIR)/Localization/$(FRAMEWORK_NAME)/*.lproj $(THEOS_STAGING_DIR)/Library/Frameworks/$(FRAMEWORK_NAME).framework/Resources/
	# Remove repository-related files.
	- find $(THEOS_STAGING_DIR) -name '.gitkeep' -delete
	# Copy header files to include directory.
	- mkdir -p $(THEOS_STAGING_DIR)/Library/Frameworks/$(FRAMEWORK_NAME).framework/Headers
	- cp $(THEOS_PROJECT_DIR)/include/*.h $(THEOS_STAGING_DIR)/Library/Frameworks/$(FRAMEWORK_NAME).framework/Headers/

distclean: clean
	- rm -f $(THEOS_PROJECT_DIR)/$(call lc,$(FRAMEWORK_ID))*.deb
	- rm -f $(THEOS_PROJECT_DIR)/.theos/packages/*

doc:
	- appledoc \
		--project-name $(FRAMEWORK_NAME) \
		--project-company "Lance Fetters (aka. ashikase)" \
		--company-id "jp.ashikase" \
		--exit-threshold 2 \
		--ignore "*.m" \
		--keep-intermediate-files \
		--keep-undocumented-objects \
		--keep-undocumented-members \
		--logformat xcode \
		--no-install-docset \
		--no-repeat-first-par \
		--no-warn-invalid-crossref \
		--output Documentation \
		$(THEOS_PROJECT_DIR)/include

sdk: stage
	- rm -rf $(THEOS)/Frameworks/$(FRAMEWORK_NAME).framework
	- mkdir -p $(THEOS)/Frameworks/
	- cp -a $(THEOS_STAGING_DIR)/Library/Frameworks/$(FRAMEWORK_NAME).framework $(THEOS)/Frameworks/
