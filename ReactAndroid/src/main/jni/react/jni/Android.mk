# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# Include . in the header search path for all source files in this module.
LOCAL_C_INCLUDES := $(LOCAL_PATH)

# Include ./../../ in the header search path for modules that depend on
# reactnativejni. This will allow external modules to require this module's
# headers using #include <react/jni/<header>.h>, assuming:
#   .     == jni
#   ./../ == react
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../..

LOCAL_CFLAGS += -fvisibility=hidden -fexceptions -frtti

LOCAL_LDLIBS += -landroid

# The dynamic libraries (.so files) that this module depends on.
LOCAL_SHARED_LIBRARIES := libfolly_json libfb libglog_init libyoga libprivatedata

# The static libraries (.a files) that this module depends on.
LOCAL_STATIC_LIBRARIES := libreactnative

# Name of this module.
#
# Other modules can depend on this one by adding libreactnativejni to their
# LOCAL_SHARED_LIBRARIES variable.
LOCAL_MODULE := reactnativejni

# Flag to enable V8 in react-native code
V8_ENABLED := 1

LOCAL_SRC_FILES := \
  CatalystInstanceImpl.cpp \
  CxxModuleWrapper.cpp \
  InstanceManager.cpp \
  JavaModuleWrapper.cpp \
  JReactMarker.cpp \
  JSLogging.cpp \
  JMessageQueueThread.cpp \
  JSLoader.cpp \
  JniJSModulesUnbundle.cpp \
  MethodInvoker.cpp \
  ModuleRegistryBuilder.cpp \
  NativeArray.cpp \
  NativeCommon.cpp \
  NativeDeltaClient.cpp \
  NativeMap.cpp \
  OnLoad.cpp \
  ProxyExecutor.cpp \
  ReadableNativeArray.cpp \
  ReadableNativeMap.cpp \
  WritableNativeArray.cpp \
  WritableNativeMap.cpp \

LOCAL_V8_FILES := \
  AndroidV8Factory.cpp

LOCAL_JSC_FILES := \
  AndroidJSCFactory.cpp \
  JSCPerfLogging.cpp \

ifeq ($(V8_ENABLED), 1)
  LOCAL_SRC_FILES += $(LOCAL_V8_FILES)
  LOCAL_CFLAGS += -DV8_ENABLED=1
else
  LOCAL_SRC_FILES += $(LOCAL_JSC_FILES)
  LOCAL_CFLAGS += -DV8_ENABLED=0
  LOCAL_SHARED_LIBRARIES += libjsc
endif

# Build the files in this directory as a shared library
include $(BUILD_SHARED_LIBRARY)

# Compile the c++ dependencies required for ReactAndroid
#
# How does the import-module function work?
#   For each $(call import-module,<module-dir>), you search the directories in
#   NDK_MODULE_PATH. (This variable is defined in Application.mk). If you find a
#   <module-dir>/Android.mk you in a directory <dir>, you run:
#   include <dir>/<module-dir>/Android.mk
#
# What does it mean to include an Android.mk file?
#   Whenever you encounter an include <dir>/<module-dir>/Android.mk, you
#   tell andorid-ndk to compile the module in <dir>/<module-dir> according
#   to the specification inside <dir>/<module-dir>/Android.mk.

$(call import-module,cxxreact)
$(call import-module,privatedata)
$(call import-module,fb)
$(call import-module,fbgloginit)
$(call import-module,folly)
$(call import-module,hermes)
ifeq ($(V8_ENABLED), 0)
  $(call import-module,jsc)
endif
$(call import-module,yogajni)
$(call import-module,jsi)
$(call import-module,jsiexecutor)

# TODO(ramanpreet):
#   Why doesn't this import-module call generate a jscexecutor.so file?
# $(call import-module,jscexecutor)

include $(REACT_SRC_DIR)/jscexecutor/Android.mk
include $(REACT_SRC_DIR)/v8executor/Android.mk
#include D:/Hermes/hermes/first-party/libhermes/Android.mk