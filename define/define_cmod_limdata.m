%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  USAGE:  >> define_east_limdata
%
%  PURPOSE: Script to create limdata.mat.
%
%  INPUTS: load file with limdata ascii file
%
%  OUTPUTS: limdata.mat
%
%  RESTRICTIONS:
%
%  METHOD:  
%
%  WRITTEN BY:  Anders Welander  ON	3/22/10
%
%  MODIFICATION HISTORY:
%
%	20140304	MJL	Generalize to allow different dates for data
%	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  east_lim = load(['east_lim_' limdata_date '.data']);
  
  if (str2num(limdata_date) < 130904) 
    limdata(1,:) = east_lim(:,2)'; %z first
    limdata(2,:) = east_lim(:,1)'; %then r
  else
    limdata(1,:) = east_lim(:,1)'; %z is already  first
    limdata(2,:) = east_lim(:,2)'; %then r
  end
  
  save limdata limdata


