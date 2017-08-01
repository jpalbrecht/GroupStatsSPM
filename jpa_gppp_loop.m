%% ############### Generell Settings ###############
% User-name
comp_name = getenv('USERNAME');
% Script-Libary-Path: where did you save this script?
base_dir_lib = 'D:\owncloud\documents_unshared\Charite\Charite\SPM Programmierung\GroupStatsSPM\';
% 1stLvl data-Path: where is your firstLevel Data with Subject-directorys?
base_dir_pl = 'E:\ChariteTestData\2ndLvl\';
% Set spm Mask Threshold
sd_level.spm.spmMaskThresh = 0.8;               % spm_default: 0.8 on 2nd Lvl
% Define the path to sjinfo.mat
sd_level.gen.sjinfo.path = [base_dir_pl 'basicData_Sjinfo.mat'];
% Define structure to ID-Vector
sd_level.gen.sjinfo.IDs = 'KAP.STID';                 % default: ''
% Define structure to Grps-Vector
sd_level.gen.sjinfo.Grps = 'KAP.PKSTRING';                  % default: ''
% Define IDs which are excluded from the statistical tests
sd_level.gen.excludeList = {'','' };                      % default: {''}, i.e. no ID will be excluded from the test
% Define the path to a excludeList Textfile, leave empty if not wanted
sd_level.gen.excludeListPath = '';
% define IDs which are included from the statistical tests
sd_level.gen.includeList = {''};                                   % default: {''},i.e. all IDs will be part of the test
% Define the path to a includeList Textfile, leave empty if not wanted
sd_level.gen.includeListPath = '';
% Define Covariates to be included in the statistical Tests
sd_level.gen.covarNames = {'Bildungsjahre_ges'
    'Age_baseline' 
    'EducationYears'};
%
%% ############### gPPI ###############

% ________________________________NECESSARY________________________________
P.subject='sampleData_Study';
P.directory=[workdir filesep 'sampleData' filesep 'stats'];
P.VOI=[workdir filesep 'rmedPrecCing.nii'];
%P.VOI2=[workdir filesep 'rmedPrecCing.nii'];
P.Region='rmedPrec';
P.analysis='psy';
P.method='cond';
P.Estimate=1;
P.contrast=0;
P.extract='eig';
P.Tasks={'0' 'etoh_on_onsets_run1' 'etoh_off_onsets_run1' 'etoh_urge_onsets_run1' 'attn_on_onsets_run1' 'attn_off_onsets_run1' 'attn_urge_onsets_run1' 'etoh_on_onsets_run2' 'etoh_off_onsets_run2' 'etoh_urge_onsets_run2' 'attn_on_onsets_run2' 'attn_off_onsets_run2' 'attn_urge_onsets_run2' };
P.Weights=[];
P.equalroi=1;
P.FLmask=0;
P.CompContrasts=1;

% _____________________________OPTIONAL____________________________________
%
P.Contrasts(1).name='PPI_contrast1';
P.Contrasts(1).left={ 'etoh_on_onsets_run1' 'etoh_off_onsets_run1' 'etoh_urge_onsets_run1' 'attn_on_onsets_run1' };
P.Contrasts(1).right={ 'none' };
P.Contrasts(1).MinEvents=30;
P.Contrasts(1).STAT='T';

P.Contrasts(2).name='PPI_contrast2';
P.Contrasts(2).left={'etoh_on_onsets_run1' 'etoh_off_onsets_run1' 'etoh_urge_onsets_run1'};
P.Contrasts(2).right={'attn_on_onsets_run1' 'attn_off_onsets_run1' 'attn_urge_onsets_run1'};
P.Contrasts(2).MinEvents=30;
P.Contrasts(2).STAT='T';



% _____________________________PARTS TO RUN________________________________
% Run batch
sd_level.ttest.run_batch = 0;     
% -------------------------------------------------------------------------
% Estimate Model
sd_level.ttest.est_model = 0;
% -------------------------------------------------------------------------
% Contrast Manager
sd_level.ttest.con_man   = 0;
% -------------------------------------------------------------------------
% Evaluate Results
sd_level.ttest.evalResults = 0;
% -------------------------------------------------------------------------
% save batch and Settings-Struct
sd_level.ttest.dosavebatch = 0;
% -------------------------------------------------------------------------
% view results
sd_level.ttest.viewResults = 1;
% -------------------------------------------------------------------------
% plot results
sd_level.ttest.plotResults = 0;