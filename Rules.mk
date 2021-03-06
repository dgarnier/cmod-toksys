include $(RULES_HEADER)

DEVICE := cmod
HAS_PCS :=

include $(MATLAB_DIR)/Device_defs.mk

dir := $(d)/make
include $(dir)/Rules.mk

include $(RULES_FOOTER)
