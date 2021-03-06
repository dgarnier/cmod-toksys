% cmod_startup.m:
% We assume that the variable gatools_root has already been set elsewhere
if exist('gatools_root') ~= 1
    error('gatools_root must be set before running this script');
end
%fix an error and get at bld_subelments which is HIDDEN in TORBEAM!
  addpath([gatools_root '/matlab/toksim/build_torbeam'])


%  addpath([gatools_root '/tokamaks/cmod/build/']) %
  addpath([gatools_root '/tokamaks/cmod/define/']) %
%  addpath([gatools_root '/tokamaks/cmod/efit/']) %
  addpath([gatools_root '/tokamaks/cmod/make/']); %
%  addpath([gatools_root '/tokamaks/cmod/pwrsys/']); %
%  addpath([gatools_root '/tokamaks/cmod/sim/']); %
%  addpath([gatools_root '/tokamaks/cmod/toksim/']); %
