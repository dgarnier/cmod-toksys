%
%  USAGE:  >> make_cmod_objects
%
%  PURPOSE: Script to calculate mutuals, Green functions for Alcator C-Mod
%	tokamak system analogous to D3D Electromagnetic Environment.
%	Creates save file with new objects (mutuals, Greens, geometry).
%	Note that the "minimal" set of objects which must be defined in
%	order to save a save-set is VV, FC, and grid.
%
%  INPUTS (edit in file):
%    Filenames of data files: (make any of these null: '', if want to omit)
%       signals_file =  Signal names organized in cells for different purposes
%	  		signals is a structure containing label, ccnames, vvnames,
%			bpnames, flnames, etc.
%	vvdata_file	Filename for vac. vessel data (must be of form *.data)
%			(actually just has to have 4 characters after ".", and
%			 must have a name distinct from all the other *.data)
%	fcdata_file	Fcoil data file (name must be of same form as vvdata)
%	ecdata_file	Ecoil data file (name must be of same form as vvdata)
%	flzr_file	Flux loop data file (name must be "     ")
%	bpdata_file	Bprobe data file (name must be of "     ")
%	rgmin,rgmax	Min,max in major radial dimension on plasma grid [m]
%	zgmin,zgmax	Min,max in vertical dimension on plasma grid [m]
%	nr,nz  # of grid elem. in r,z dir. (must be odd; make 0 to omit grid)
%	etav  		vacuum vessel resistivity, uOhm-m (can be col vector...)
%	etaf  		Fcoil resistivity, uOhm-m (can be col vector...)
%			NOTE: for SC set etaf=eta(Cu), adjust for SC in build
%	etae  		Ecoil resistivity, uOhm-m (can be col vector...)
%
%  OUTPUTS:
%	Save file cmod_obj_mks_struct.mat with all mutuals, Greens functions,
%	and geometry data.

%  RESTRICTIONS:

%  METHOD:
%	Loads data files, defines
%	geometry with define_toksys_data, then uses Mike's mutind_distrib to
%	calculate mutuals. bgreens_distrib to calculate fields at B-probes.

%  WRITTEN BY:  Dave Humphreys  ON	7/17/00
%
%  VERSION @(#)make_kstar_objects.m	1.18 02/07/12
%
%  MODIFIED BY:
%     2005/05/10  MW    use make_tok_objects
%     2007/11/06  NWE   reads fcnturn.mat instead of ASCII fcnturn.dat
%     2008/01/21  NWE   added rogowski loops to input structure list
%     2009/02/18  SAW   Adding handling multiple configurations
%     2020/05/01  DTG   Adapt to CMOD from KSTAR example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Explicit Inputs:
gatools_root = getenv('GATOOLS_ROOT');

% Establish configuration
if ~exist('config_name','var')
   % Select config name list of available configurations.
   [s,w] = unix(['find ' gatools_root '/tokamaks/cmod/make/ -maxdepth 1  -name ''*.mat'''...
                  ' \! -name ''cmod_obj*'' \! -name ''*old*'' -type f']);
   [dum,dum2,tokens] = regexp(w,'make/\S*_(\S*).mat'); % Does not assume simple year config name
   clist = '';
   for ii = 1:length(tokens)
      clist = strvcat(clist,w(tokens{ii}(1):tokens{ii}(2)));
   end
   disp('Available CMOD configurations:');
   disp(unique(clist,'rows'))
   disp 'default'
   config_name = input('Enter config_name [default]: ','s');
end

if (isempty(config_name) | strcmp(config_name,'default'))
   config_name = 'default';
   config_sfx = '';
else
   config_sfx = ['_' config_name];
end


%Select grid size
%if strcmp(config_name,'TSC') | strcmp(config_name,'FreeGS')
if exist('config_name') & ~strcmp(config_name,'default')
    disp(['Config ' config_name ': Grid set in custom file.'])
    config_grid = config_name;
elseif ~exist('config_grid')
   disp('Select grid size:')
   disp('   [0] 129x129')
   disp('   [1] 65x65  [default]')
   disp('   [2] 33x33')
   gridType = input('Choose grid by index: ')
   if gridType == 0
     config_grid = '129';
   elseif gridType == 2
     config_grid = '3333';
   else
     config_grid = '6565';
   end
end

if strcmp(config_grid,'6565')
  nr = 65;
  nz = 65;
elseif strcmp(config_grid,'3333')
  nr = 33;
  nz = 33;
elseif strcmp(config_grid,'129')
  nr = 129;
  nz = 129;
end

%if strcmp(config_name,'default')
%   config_grid = [config_name '_' config_grid]
%end

% Set appropriate geometry files.
% Use default if no configuration-specific file exists
if exist(['limdata' config_sfx '.mat'],'file')
   limdata_file = ['limdata' config_sfx];
else
   limdata_file = 'limdata';
end
if exist(['vvdata' config_sfx '.mat'],'file')
   vvdata_file = ['vvdata' config_sfx];
else
   vvdata_file = 'vvdata';
end
if exist(['ecdata' config_sfx '.mat'],'file')
   ecdata_file = ['ecdata' config_sfx];
else
   ecdata_file = 'ecdata';
end
if exist(['ecnames' config_sfx '.mat'],'file')
   ecnames_file = ['ecnames' config_sfx];
else
   ecnames_file = 'ecnames';
end
if exist(['fcdata' config_sfx '.mat'],'file')
   fcdata_file = ['fcdata' config_sfx];
else
   fcdata_file = 'fcdata';
end
if exist(['fcnames' config_sfx '.mat'],'file')
   fcnames_file = ['fcnames' config_sfx];
else
   fcnames_file = 'fcnames';
end
if exist(['fldata' config_sfx '.mat'],'file')
   fldata_file = ['fldata' config_sfx];
else
   fldata_file = 'fldata';
end
if exist(['flnames' config_sfx '.mat'],'file')
   flnames_file = ['flnames' config_sfx];
else
   flnames_file = 'flnames';
end
if exist(['sldata' config_sfx '.mat'],'file')
   sldata_file = ['sldata' config_sfx];
else
   sldata_file = 'sldata';
end
if exist(['slnames' config_sfx '.mat'],'file')
   slnames_file = ['slnames' config_sfx];
else
   slnames_file = 'slnames';
end
if exist(['bpdata' config_sfx '.mat'],'file')
   bpdata_file = ['bpdata' config_sfx];
else
   bpdata_file = 'bpdata';
end
if exist(['bpnames' config_sfx '.mat'],'file')
   bpnames_file = ['bpnames' config_sfx];
else
   bpnames_file = 'bpnames';
end
if exist(['rlnames' config_sfx '.mat'],'file')
   rlnames_file = ['rlnames' config_sfx];
else
   rlnames_file = 'rlnames';
end
if exist(['rldata' config_sfx '.mat'],'file')
   rldata_file = ['rldata' config_sfx];
else
   rldata_file = 'rldata';
end
if exist(['lvnames' config_sfx '.mat'],'file')
   lvnames_file = ['lvnames' config_sfx];
else
   lvnames_file = 'lvnames';
end
if exist(['vvnames' config_sfx '.mat'],'file')
   vvnames_file = ['vvnames' config_sfx];
else
   vvnames_file = 'vvnames';
end
if exist(['vvres' config_sfx '.mat'],'file')
   vvres_file = ['vvres' config_sfx];
else
   vvres_file = 'vvnres';
end
if exist(['lvdata' config_sfx '.mat'],'file')
   lvdata_file = ['lvdata' config_sfx];
else
   lvdata_file = 'lvdata';
end
if exist(['fcnturn' config_sfx '.mat'],'file')
   fcnturn_file = ['fcnturn' config_sfx];
else
   fcnturn_file = 'fcnturn';
end
if exist(['flsignals' config_sfx '.mat'],'file')
   flsignals_file = ['flsignals' config_sfx];
else
   flsignals_file = 'flsignals';
end
if exist(['bpsignals' config_sfx '.mat'],'file')
   bpsignals_file = ['bpsignals' config_sfx];
else
   bpsignals_file = 'bpsignals';
end
if exist(['fcsignals' config_sfx '.mat'],'file')
   fcsignals_file = ['fcsignals' config_sfx];
else
   fcsignals_file = 'fcsignals';
end
if exist(['rlsignals' config_sfx '.mat'],'file')
   rlsignals_file = ['rlsignals' config_sfx];
else
   rlsignals_file = 'rlsignals';
end
if exist(['lvsignals' config_sfx '.mat'],'file')
   lvsignals_file = ['lvsignals' config_sfx];
else
   lvsignals_file = 'lvsignals';
end
if exist(['fcid' config_sfx '.mat'],'file')
   fcid_file = ['fcid' config_sfx];
else
   fcid_file = 'fcid';
end
if exist(['vvid' config_sfx '.mat'],'file')
   vvid_file = ['vvid' config_sfx];
else
   vvid_file = 'vvid';
end
if exist(['fcturn' config_sfx '.mat'],'file')
   fcturn_file = ['fcturn' config_sfx];
else
   fcturn_file = 'fcturn';
end
if exist(['turnfc' config_sfx '.mat'],'file')
   turnfc_file = ['turnfc' config_sfx];
else
   turnfc_file = 'turnfc';
end
if exist(['tddata' config_sfx '.mat'],'file')
   tddata_file = ['tddata' config_sfx];
else
   tddata_file = 'tddata';
end
if exist(['tdwireD' config_sfx '.mat'],'file')
   tdwireD_file = ['tdwireD' config_sfx];
else
   tdwireD_file = 'tdwireD';
end
if exist(['tdnames' config_sfx '.mat'],'file')
   tdnames_file = ['tdnames' config_sfx];
else
   tdnames_file = 'tdnames';
end
if exist(['tdnturn' config_sfx '.mat'],'file')
   tdnturn_file = ['tdnturn' config_sfx];
else
   tdnturn_file = 'tdnturn';
end

% if exist(['etav' config_sfx '.mat'],'file')
%    etav_file = ['etav' config_sfx];
% else
%    etav_file = 'etav';
% end
% load(etav_file);
%
% if exist(['etaf' config_sfx '.mat'],'file')
%    etaf_file = ['etaf' config_sfx];
% else
%    etaf_file = 'etaf';
% end
% load(etaf_file);
%
% if exist(['etat' config_sfx '.mat'],'file')
%    etat_file = ['etat' config_sfx];
% else
%    etat_file = 'etat';
% end
% load(etat_file);

if ~exist('rzgrid_file')i % Use alternate grid descriptor file if user specifies
   if exist(['rzgrid' config_sfx '.mat'],'file')
      rzgrid_file = ['rzgrid' config_sfx];
   else
      rzgrid_file = 'rzgrid';
   end
end
load(rzgrid_file);

% specify datadir if the config_sfx is NOT in the clist
if (~exist('datadir'))
    datadir = input('Enter directory path. Hit enter for default: ','s');
end
if (isempty(datadir) | strcmp(datadir,'default'))
       datadir = [gatools_root,'/tokamaks/cmod/make/'];
end

procedures = [];

make_tok_inputs = struct( ...
'tokamak', 'cmod', ...
'config_name', config_grid, ...
'datadir', datadir, ...
... %'limdata_file', limdata_file, ...
'vvdata_file',  vvdata_file, ...
'vvnames_file', vvnames_file, ...
'ecdata_file',  ecdata_file, ...
'ecnames_file', ecnames_file, ...
'fcdata_file',  fcdata_file, ...
'fcnames_file', fcnames_file, ...
'fldata_file',  fldata_file, ...
'flnames_file', flnames_file, ...
... %'sldata_file',  sldata_file, ...
... %'slnames_file', slnames_file, ...
'bpdata_file',  bpdata_file, ...
'bpnames_file', bpnames_file, ...
... %'rlnames_file', rlnames_file, ...
... %'rldata_file',  rldata_file, ...
... %'lvnames_file', lvnames_file,...
... %'lvdata_file',  lvdata_file,...
... %'tddata_file',  tddata_file,...
... %'tdnames_file', tdnames_file,...
... %'tdnturn_file', tdnturn_file,...
... %'tdwireD_file', tdwireD_file,...
'fcnturn_file', fcnturn_file, ...
... %'flsignals_file', flsignals_file, ...
... %'slsignals_file', flsignals_file, ...
... %'bpsignals_file', bpsignals_file, ...
... %'fcsignals_file', fcsignals_file, ...
... %'rlsignals_file', rlsignals_file, ...
... %'lvsignals_file', lvsignals_file, ...
'fcid_file', fcid_file, ...
'vvid_file', vvid_file, ...
'fcturn_file', fcturn_file, ...
'turnfc_file', turnfc_file, ...
'rgmin', rgmin, ...     		%rgrid1 EFIT variable
'rgmax', rgmax, ... 		%rgrid1 + EFIT variable xdim
'zgmin', zgmin, ...		%zmid - zdim/2 EFIT variables
'zgmax', zgmax, ...		%zmid + zdim/2 EFIT variables
'nr', nr, ...			%EFIT var nw
'nz', nz, ...			%EFIT var nh
... %'etav', etav, ...
'vvres_file', vvres_file, ... %resistance of vv elements
... %'etaf', etaf, ... 	%Fcoil resistivity, uOhm-m   (Cu)
'etaf', 2.5e-2, ... 	%Fcoil resistivity, uOhm-m   (Cu)  (from Cmod EFIT code)
'etae', 3.5e-2, ...   %Ecoil resistivity
... %'etat', etat, ...   %Tcoil resistivity, uOhm-m
'nminvv', 2, ...     %# of conductors in *min* dimension of vac. vessel element
'nminec', 1, ...     %# of conductors in *min* dimension of E coils
'nminfc', 2, ...     %# of conductors in *min* dimension of PF coils
'nmingg', 2, ...     %# of conductors in *min* dimension of plasma grid
'drfl', 0.001, ...   %width of FL for mutuals to points (like grid ggdata)
'dzfl', 0.001)   %height of FL for mutuals to points (like grid ggdata)

make_tok_objects(make_tok_inputs,procedures);

% add a hook to make force matricies.
% add_fgreens(make_tok_inputs);
