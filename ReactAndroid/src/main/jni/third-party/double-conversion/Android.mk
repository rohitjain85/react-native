LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := double-conversion

LOCAL_SRC_FILES := \
  double-conversion/bignum.cc \
  double-conversion/bignum-dtoa.cc \
  double-conversion/cached-powers.cc \
  double-conversion/diy-fp.cc \
  double-conversion/double-conversion.cc \
  double-conversion/fast-dtoa.cc \
  double-conversion/fixed-dtoa.cc \
  double-conversion/strtod.cc

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)

CXX14_FLAGS := -std=c++14 -Wno-unused-variable -Wno-unused-local-typedefs -Wno-unneeded-internal-declaration
LOCAL_CFLAGS += $(CXX14_FLAGS)
LOCAL_EXPORT_CPPFLAGS := $(CXX14_FLAGS)

include $(BUILD_STATIC_LIBRARY)
