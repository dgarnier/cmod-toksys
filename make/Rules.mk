include $(RULES_HEADER)

DEV := cmod
TOK_SCRIPT_$(d) :=  datadir='default'; make_cmod_objects

TOK_OBJ_cmod_3333 := cmod_obj_3333
EXTRA_COMMANDS_cmod_3333 :=  config_name='default'; config_grid = '3333';

TOK_OBJ_cmod_6565 := cmod_obj_6565
EXTRA_COMMANDS_cmod_6565 := config_name='default'; config_grid = '6565';

TOK_OBJ_cmod_129 := cmod_obj_129
EXTRA_COMMANDS_cmod_129 := config_name='default'; config_grid = '129';

$(call make_tok_objects_command_no_gendep,COMM_cmod_3333,$(DEV),$(TOK_OBJ_cmod_3333),$(TOK_SCRIPT_$(d)),$(d),$(EXTRA_COMMANDS_cmod_3333))
$(call make_tok_objects_command_no_gendep,COMM_cmod_6565,$(DEV),$(TOK_OBJ_cmod_6565),$(TOK_SCRIPT_$(d)),$(d),$(EXTRA_COMMANDS_cmod_6565))
$(call make_tok_objects_command_no_gendep,COMM_cmod_129,$(DEV),$(TOK_OBJ_cmod_129),$(TOK_SCRIPT_$(d)),$(d),$(EXTRA_COMMANDS_cmod_129))

.phony : $(TOK_OBJ_cmod_3333)
.phony : $(TOK_OBJ_cmod_6565)
.phony : $(TOK_OBJ_cmod_129)

$(TOK_OBJ_cmod_3333) : MATLAB_COMMAND := $(COMM_cmod_3333)
$(TOK_OBJ_cmod_3333) :
	$(MATLAB_SCRIPT)

$(TOK_OBJ_cmod_6565) : MATLAB_COMMAND := $(COMM_cmod_6565)
$(TOK_OBJ_cmod_6565) :
	$(MATLAB_SCRIPT)

$(TOK_OBJ_cmod_129) : MATLAB_COMMAND := $(COMM_cmod_129)
$(TOK_OBJ_cmod_129) :
	$(MATLAB_SCRIPT)

TOK_OBJS_$(DEVICE) := $(TOK_OBJS_$(DEVICE)) $(TOK_OBJ_cmod_3333) $(TOK_OBJ_cmod_6565) $(TOK_OBJ_cmod_129)
CLEAN_TOK_OBJS_$(DEVICE) := $(CLEAN_TOK_OBJS_$(DEVICE)) $(TOK_OBJ_cmod_3333) $(TOK_OBJ_cmod_6565) $(TOK_OBJ_cmod_129)

include $(RULES_FOOTER)
