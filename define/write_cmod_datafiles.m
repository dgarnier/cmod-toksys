function cmod_data = write_cmod_data(use_dprobe)

  % Explicit Inputs:
  gatools_root = getenv('GATOOLS_ROOT');

  fcnames = str2mat(...
     'EF1U',...
     'EF1L',...
     'EF2U',...
     'EF2L',...
     'EF3U',...
     'EF3L',...
     'EF4U',...
     'EF4L',...
     'EFCU',...
     'EFCL',...
     'TFTU',...
     'TFTL');

  ecnames = str2mat(...
    'OH1',...
    'OH2U',...
    'OH2L');

  nvesel = 44;

  if ~exist('use_dprobe')
    use_dprobe=0;
  end

  if ~use_dprobe
      filename = [ gatools_root '/tokamaks/cmod/define/mhdin_cmod.dat'];
      nfcoil = 12;
      necoil = 183;
  else
      filename = [ gatools_root '/tokamaks/cmod/define/dprobe.dat'];
      nfcoil = 15;
      necoil = 183;
      fcnames = [ecnames ; fcnames];
      ecnames = [];
  end

  read_mhdin

  oldfolder = cd([gatools_root '/tokamaks/cmod/make']);

  %rzgrid.dat
  rgmin= RLEFT;
  rgmax= RRIGHT;
  zgmin= ZBOTTO;
  zgmax= ZTOP;
  % nr=    65;
  % nz=    65;
  % save rg rgmin rgmax zgmin zgmax nr nz
  save rzgrid rgmin rgmax zgmin zgmax

  % ------------------------
  % PF coil
  % ------------------------
  % calculation of parameters (would add extra coils here)
  % fcturn=   mulitplyer used to generate efit green function   (num=19)
  % turnfc=   mulitplyer of diagnostic current in efit 	 (num=11)
  % fcnturn = actual turns in each element used in object build (num=19)

  fcdata=[ ZF, RF, HF, WF, AF, AF2]';
  save fcdata fcdata

  %fcnturn
  % DON'T TRANSPOSE THIS!
  fcnturn=TURNFC;
  save fcnturn fcnturn

  %fcturn
  fcturn=TURNFC';
  save fcturn fcturn

  %fcid
  %fcid=FCID';
  fcid=[1:length(TURNFC)]';
  save fcid fcid

  %turnfc.dat
  turnfc=  ones(max(fcid),1)';
  save turnfc turnfc

  save fcnames fcnames

  % --------------------------------------
  % Ecoil:
  % (ECTURN is fractional turn/box)
  % --------------------------------------

  %ecdata
  ecdata=[ZE, RE, HE, WE, ECID]';
  save ecdata ecdata

  %ecid
  ecid=ECID';
  save ecid ecid

  %ecturn
  %ecturn=ECTURN';
  %save ecturn ecturn

  save ecnames ecnames

  % ------------------------
  % vacuum vessel
  % ------------------------

  %vvdata
  vvdata=[ ZVS, RVS, HVS, WVS, AVS, AVS2]';
  save vvdata vvdata

  vvfrac=zeros(1,length(ZVS))+1;
  save vvfrac vvfrac

  vvid=1:length(ZVS);
  save vvid vvid

  % read_mhdin botches the names
  vvnames = [...
    repmat(VSNAME(1,:),[6,1]);...
    repmat(VSNAME(2,:),[4,1]);...
    repmat(VSNAME(3,:),[6,1]);...
    repmat(VSNAME(4,:),[26,1]);...
    repmat(VSNAME(5,:),[1,1]);...
    repmat(VSNAME(6,:),[1,1]) ];

  save vvnames vvnames

  % i think this is vvres
  vvres = RSISVS';
  save vvres vvres

  % ------------------------
  % flux loops
  % ------------------------

  fldata = [ZSI, RSI, HSI, WSI, AS, AS2]';
  save fldata fldata

  flnames = LPNAME;
  save flnames flnames

  % ------------------------
  % bp coils
  % ------------------------
  % XMP2, YMP2, PATMP2, SMP2, AMP2
  % R      Z     area ?  length angle

  bpdata = [YMP2, XMP2, AMP2, SMP2 ]';
  save bpdata bpdata

  bpnames = MPNAM2;
  save bpnames bpnames

  cd(oldfolder);
