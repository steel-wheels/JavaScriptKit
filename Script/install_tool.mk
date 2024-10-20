# install_tool.mk

PROJECT_NAME	?= JavaScriptKit
BUNDLE_PATH	= binary/bin
PRODUCT_DIR	= ../Product

all: unittest

clean:
	(cd $(PRODUCT_DIR) && rm -rf $(BUNDLE_PATH))
	
unittest: install_bundle
	xcodebuild install \
 	  -scheme UnitTest \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
 	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
 	  INSTALL_PATH=$(BUNDLE_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=$(PRODUCT_DIR) \
	  ONLY_ACTIVE_ARCH=NO

install_bundle: dummy
	xcodebuild install \
	  -scheme Bundle \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
 	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
 	  INSTALL_PATH=$(BUNDLE_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=$(PRODUCT_DIR) \
	  ONLY_ACTIVE_ARCH=NO

dummy:

