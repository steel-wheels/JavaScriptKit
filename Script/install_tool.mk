# install_tool.mk

PROJECT_NAME	?= JavaScriptKit
BUNDLE_PATH	= binary/bin
PRODUCT_DIR	= ../Product

all: unittest

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
	(cd $(PRODUCT_DIR) && rm -rf $(BUNDLE_PATH))
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


# BIN_PATH	= binary/bin
# 
# all: dummy
# 	echo "usage: make install_bundle or make install_tools"
# 
# install_jsh_bundle: dummy
# 	xcodebuild install \
# 	  -scheme jsh_bundle \
# 	  -project $(PROJECT_NAME).xcodeproj \
# 	  -destination="macOSX" \
# 	  -configuration Release \
# 	  -sdk macosx \
# 	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
# 	  INSTALL_PATH=$(BUNDLE_PATH) \
# 	  SKIP_INSTALL=NO \
# 	  DSTROOT=$(PRODUCT_DIR) \
# 	  ONLY_ACTIVE_ARCH=NO
# 
# install_edecl: dummy
# 	xcodebuild install \
# 	  -scheme edecl \
# 	  -project $(PROJECT_NAME).xcodeproj \
# 	  -destination="macOSX" \
# 	  -configuration Release \
# 	  -sdk macosx \
# 	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
# 	  INSTALL_PATH=$(BIN_PATH) \
# 	  SKIP_INSTALL=NO \
# 	  DSTROOT=$(PRODUCT_DIR) \
# 	  ONLY_ACTIVE_ARCH=NO
# 
# install_jsrun: dummy
# 	xcodebuild install \
# 	  -scheme jsrun \
# 	  -project $(PROJECT_NAME).xcodeproj \
# 	  -destination="macOSX" \
# 	  -configuration Release \
# 	  -sdk macosx \
# 	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
# 	  INSTALL_PATH=$(BIN_PATH) \
# 	  SKIP_INSTALL=NO \
# 	  DSTROOT=$(PRODUCT_DIR) \
# 	  ONLY_ACTIVE_ARCH=NO
# 
# install_jsh: dummy
# 	xcodebuild install \
# 	  -scheme jsh \
# 	  -project $(PROJECT_NAME).xcodeproj \
# 	  -destination="macOSX" \
# 	  -configuration Release \
# 	  -sdk macosx \
# 	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
# 	  INSTALL_PATH=$(BIN_PATH) \
# 	  SKIP_INSTALL=NO \
# 	  DSTROOT=$(PRODUCT_DIR) \
# 	  ONLY_ACTIVE_ARCH=NO
# 
# dummy:
# 
