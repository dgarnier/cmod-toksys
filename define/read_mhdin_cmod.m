 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  USAGE:  >>read_mhdin_cmod
%
%  PURPOSE: reads efit file dprobe.dat (cmod changed mhdin.dat) file for cmod
%
%  INPUTS: [default]
%     filename = 'tokamaks/cmod/define/dprobe.dat'
%     nfcoil = [14]; % # of F-coils; must be specified for non-D3D (Opt.)
%
%  OUTPUTS:
%    all namelist items in UPPER CASE, ...
%    east_fc_names= list of names of all PF conductors [f1 f3 f5 f7 f9 .. f2 f4
%    east_fcg_names= list of coils (grouped conductors) [f1 f3 f5 f79 f11 ...
%
%  CAUTION: SEE read_gfile since this just sets filename and nfcoil and runs
%

% Generated by Jim Leuer 2014jun30
% taken from fortran of read_mhdin_east
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prelims:

% should we use dprobe.dat

% or mhdin.dat

% if exist('nfcoil')~=1, nfcoil=15,  end
if exist('nfcoil')~=1, nfcoil=12,  end
if exist('necoil')~=1, necoil=183, end
% if exist('nsilop')~=1, nsilop=43,  end
% if exist('nbprob')~=1, nbprob=34,  end
if exist('nvesel')~=1, nvesel=44,  end

if exist('filename')~=1
    % filename='./dprobe.dat'
    filename='./mhdin_cmod.dat'

    dum= dir(filename)
    if isempty(dum)
      return
    end
 end
% return

 read_mhdin
  return


% =======================================
% some special stuff not in EFIT
% order of 16 conductors in HL2M EFIT
  east_fc_names= ['PF1 ';'PF2 ';'PF3 ';'PF4 '; 'PF5 ';'PF6 ';'PF7 ';'PF8 ';...
                  'PF9 ';'PF10';'PF11';'PF12'; 'PF13';'PF14';'PF15';'PF16'];

% final grouped order of 12 states in EAST EFIT
  east_fcg_names= ['F1 ';'F3 ';'F5 ';'F79';'F11';'F13';...
                   'F2 ';'F4 ';'F6 ';'F81';'F12';'F14';];

  nsilop= length(RSI);
  nbprob= length(XMP2);
