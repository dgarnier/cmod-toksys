%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  USAGE:  >> define_east_data
%
%  PURPOSE: Script to construct data files in format for make_east_objects
%
%  INPUTS: Defined in this script
%	tok_name 	= name of machine
%
%       bpdata_date     = Bp probe data data.  Options: 080527 
%       fldata_date     = Flux loop data date. Options: 080527, 130904
%       fcdata_date     = PF coil data date:   Options: 041101, 130904 (new IVC)
%       vvdata_date     = VV data date.        Options: 100304, 130904 (new IV plates)
%       limdata_date    = Limiter data date:   Options:         130904 (new limiter)
%       
%
%  OUTPUTS: 
%	Produces ALL .mat files required for EAST TokSys Modeling
%
%  RESTRICTIONS:
%
%  METHOD:  
%
%  SUBROUTINES:
%       define_east_bpdata
%       define_east_fldata
%       define_east_limdata
%       define_east_fcdata
%
%  WRITTEN BY:  Matthew Lanctot on March 4, 2014
%
%  MODIFICATION HISTORY:
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Inputs:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Explicit Inputs:
  % General
  tok_name =     'EAST';
  gatools_root = getenv('GATOOLS_ROOT');
  
  % ASCII data file dates
  % Bp, fl, lim, rl, in-vessel coil, passive plates, limiter
  bpdata_date  = '140521';
  fldata_date  = '140521';
  limdata_date = '130904';
  %rldata_date  = ''; %defined in make
  vvdata_date  = '130904';
  fcdata_date  = '160119';
  
  %
  % Include tweaks to data files here 
  %
  bp_reduced = 38;	%if nonzero, use this many Bp probes
  
  %
  % Specify sub-directory for saving all .mat files
  %
  data_dir = '160119';
                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load ASCII Data Files and Write Standard-Format Data Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   define_east_bpdata
   define_east_fldata
   %rl defined in make
   define_east_fcdata
   define_east_vvdata
   define_east_limdata
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save results to specified directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  eval(['!mkdir ' data_dir]);
  data_files = {'bpdata.mat', 'fcdata.mat', 'fldata.mat', 'limdata.mat', 'vvdata.mat'};
  for k=1:numel(data_files)
    eval(['!mv ' data_files{k} ' ' data_dir '/.'])
  end    
