function jpa_FDttest(ttest)
% function that does a spm TTest with specified settings
%
% Syntax:
%    jpa_FDttest(ttest)
%
% Inputs:
%    ttest              - Struct with settings
%     .sjinfo           - Struct which defines Information about Subjects
%     .sjinfo.path      - Path to Struct which contains Information about Subjects
%     .sjinfo.IDs       - Substructure to IDs-Vector, defined as String
%     .sjinfo.Grps      - Substructure to Grps-Vector, defined as String
%     .FirstLVLModel    - Model-directory where the first level results are
%                           located
%     .con              - 1.st Level Contrast to be evaluated in ttest
%     .conNames         - 1.st Level Contrast Name
%     .numberOfGrp      - the groupnumber of Subjects to be evalueted in
%                           ttest. 1 could stand for "control group"
%     .excludeList      - contains IDs that are excluded from the
%                           statistical evaluation
%     .excludeListPath  - path to a exclude.txt file which contains IDs
%                           that are excluded from the statistical evaluation
%     .includeList      - contains IDs that are included from the
%                           statistical evaluation
%     .includeListPath  - path to a include.txt file which contains IDs
%                           that are included from the statistical evaluation
%     .covarNames       - Name of covariates which values are in sjinfo.KAP
%     .interaction      - Interaction between covariates
%     .contrastType     - Types of Contrasts
%     .contrastNames    - Names of Contrasts
%     .contrastWeights  - Weight-Vector of Contrasts
%     .contrastRep      - Replication-Mode of Contrasts
%     .evalResPValue    - PValue for evaluation
%     .evalResThreshold - Threshold for evaluation
%     .evalResROI       - Paths to ROI
%     .evalResAtlas     - Atlas for anatomical regions
%     .mricroGLPath     - Path to MicroGL-Program        
%     .loadimage        - BackgroundImage to load first in MircoGL
%     .plotPerRow       - Numer of Pictures in one Plot per Row
%     .plotPerCol       - Numer of Pictures in one Plot per Column
%     .picPerPage       - Number of Pictures per Page
%     .colScheme        - Color Scheme to add a Colorbar for
%     .run_batch        - Enables spm_jobman
%     .est_model        - Enables Model Estimation
%     .con_man          - Enables Contrast Manager
%     .evalResults      - Enables evaluation of Model Estimation
%     .dosavebatch      - Enables Save of Batch and Information-Struct
%     .base_dir_ttest   - Base dir where to save Outputs of ttest results
%     .base_dir_pl      - Base dir where to find Subject scans
%
% Outputs:
%     spm_jobman outputs. For detailed explanation look at spm
%     documentation under http://www.fil.ion.ucl.ac.uk/spm/doc/manual.pdf
%
% Example:
%     jpa_FDttest(ttest)
%       where mreg:
%     .sjinfo.path      = 'C:\example\sjinfo.mat'
%     .sjinfo.IDs       = 'SUBSTRUCT1.SUBSTRUCT2.Vector'
%     .sjinfo.Grps      = 'SUBSTRUCT1.SUBSTRUCT2.Vector'
%     .FirstLVLModel    = 'exampleFirstLevelModel'
%     .con              = {'con_0001','con_0002'}
%     .conNames         = {'1stLvlContrastName1','1stLvlContrastName2'}
%     .numberOfGrp      = {'1'}
%     .excludeList      = {'1001','2002'}
%     .excludeListPath  = 'C:\example\exampleExclude.txt'
%     .includeList      = {'1003','2004'}
%     .includeListPath  = 'C:\example\exampleInclude.txt'
%     .covarNames       = {'Age','EducationYears'}
%     .interaction      = [1 1]
%     .contrastType     = {'t','t'}
%     .contrastNames    = {'exampleContrast1','exampleContrast2'}
%     .contrastWeights  = {[1] [-1]}
%     .contrastRep      = {'none','none'}
%     .evalResPValue    = 0.01
%     .evalResThreshold = 8
%     .evalResROI       = 'C:\example\roi.nii'
%     .evalResAtlas     = 'C:\example\atlas.xml'
%     .mricroGLPath     = 'C:\example\Programme\mricrogl'         
%     .loadimage        = 'C:\example\mean_group_anatomy.nii'
%     .plotPerRow       = 2
%     .plotPerCol       = 2
%     .picPerPage       = []
%     .colScheme        = '1hot'
%     .run_batch        = 1
%     .est_model        = 1
%     .con_man          = 1
%     .evalResults      = 1
%     .dosavebatch      = 1
%     .base_dir_ttest   = 'C:\example\scans\results_2nd_level\ttest'
%     .base_dir_pl      = 'C:\example\scans\'
%
%
% Other m-files required: jpa_getInitialienOfSting, jpa_reassembleCell,
%   jpa_initialFDTtest, jpa_addCovariates, jpa_initialFmriEst,
%   jpa_initialConMan, jpa_resizeColumsOfMat, jpa_getStandardFContrast,
%   jpa_addFContrast, spm_jobman, jpa_eval_results, jpa_getAllResults,
%   jpa_addTContrast
% Subfunctions: none
% MAT-files required: sjinfo
%
% See also: jpa_initialFDTtest, jpa_addCovariates, jpa_initialFmriEst,
%       jpa_initialConMan, jpa_addFContrast, jpa_addFContrast,
%       jpa_eval_results

% Author: Jan Albrecht
% Work address:
% email: jan-philipp.albrecht@charite.de, j.p.albrecht@fu-berlin.de
% Website:
% Sep 2015; Last revision: 29-Sep-2015

%------------- BEGIN CODE --------------

%% check input parameters
if nargin ~= 1
    error('Invlaid Number of Parameters');
end
% check Input Arguments & get Defaults
ttest = jpa_getSecndLvlDefaults(ttest);

%% Preprocessing
% initialization
covNotEmpty = true(length(ttest.covarNames),1);
if ttest.run_batch || ttest.est_model || ttest.con_man
    % load Sjinfo
    try
        load(ttest.sjinfo.path);
    catch ME
        disp(ME.identifier);
        error('Could not load sjinfo!');
    end
    % get covariates out of Sjinfo
    [ids, grp, covarsc, covNotEmpty] = jpa_getCovarsSjinfo(Sjinfo ,ttest.covarNames, ttest.sjinfo.IDs,ttest.sjinfo.Grps);
end
% get Initialien of Covariaten to name the Folder
covIn = jpa_getInitialienOfSting(ttest.covarNames(covNotEmpty));
if isempty(covIn) || strcmp(covIn{1,1},'')
    covIn{1,1} = 'noCov';
else
    covIn{1,1} = strcat('cov',covIn{1,1});
end
if ttest.run_batch || ttest.est_model || ttest.con_man
    % Load Exclude List
    if ~strcmp(ttest.excludeListPath, '')
        [excludeListFilepath,excludeListFilename] = fileparts(ttest.excludeListPath);
        ttest.excludeListFile = jpa_loadTxtToArray(ttest.excludeListPath);
        % combine IDs loaded from File and specified in script
        ttest.excludeList = [ttest.excludeList ttest.excludeListFile];
    else
        excludeListFilename = 'excludeList';
    end
    % Load Include List
    if ~strcmp(ttest.includeListPath, '')
        [includeListFilepath,includeListFilename] = fileparts(ttest.includeListPath);
        ttest.includeListFile = jpa_loadTxtToArray(ttest.includeListPath);
        % combine IDs loaded from File and specified in script
        ttest.includeList = [ttest.includeList ttest.includeListFile];
    else
        includeListFilename = 'includeList';
    end
    % empty Include-Lists are not allowed
    first = ttest.includeList{1};
    if strcmp(first, '') || isempty(ttest.includeList)
        ttest.includeList = ids;
    end
end

%% Path calculation
% what do we search
ttest.searchFor = strcat(ttest.FirstLVLModel,filesep ,ttest.con, '.nii');
% where do we save
ttest.analysis  = strcat(ttest.base_dir_ttest, 'groupstats', '_', ...
    ttest.FirstLVLModel, '_','grp', ttest.numberOfGrp{1},...
    '_',covIn{1,1},'_', ttest.conNames );
% make save-directory
if ~exist(ttest.analysis,'dir'); mkdir(ttest.analysis); end
ttest.dirName = strcat('groupstats', '_', ttest.FirstLVLModel,...
    '_','grp', ttest.numberOfGrp{1},'_',covIn{1,1},'_', ttest.conNames );

%% getCovariates and IDs ordered by group
if ttest.run_batch || ttest.est_model || ttest.con_man
    disp(strcat('run ttest in directory: ',ttest.dirName))
    % search for con_img and get paths
    match = jpa_getDirs(ttest.base_dir_pl,ttest.searchFor);
    % get Logical Vectors which IDs will be part of the Test and which match
    % will be part of the test
    [logicalIDs, indMatch, idsFound] = jpa_getLogicalID(match, ids, ttest.excludeList, ttest.includeList);
    % initialize
    [b,l]= size(match);
    if b==0
        disp('WARNING: No Matches Found!');
    end
    covariates4EachGoup = cell(length(ttest.covarNames),1);
    ttest.match2Group = repmat({''},b,length(ttest.numberOfGrp));
    ttest.subjectList = repmat({''},length(logicalIDs),1);
    lengthSList = 0;
    % loop though all groups
    for ind=1:1:length(ttest.numberOfGrp)
        % filter Vector where Grp is not the one we search for
        logicalGrp = strcmp(grp,ttest.numberOfGrp{ind});
        logicalIDgroup = logicalIDs & logicalGrp;
        % get the covariates of the Subject
        for k=1:length(ttest.covarNames)
            % if Covariate could be found
            if covNotEmpty(k)
                covariates4EachGoup{k,ind} = covarsc{k}(logicalIDgroup);
            end
        end
        % get the scans of each group
        indM2G = 0;
        for i=1:1:length(indMatch)
            if indMatch(i) > 0 % test if Match was found
                if logicalIDgroup(indMatch(i)); % test if match is part of test
                    indM2G = indM2G + 1;
                    ttest.match2Group{indM2G,ind} = match{i,1};
                end
            end
        end
        % fill the ttest.subjectList for the current group
        ttest.subjectList((lengthSList+1):lengthSList + length(ids(logicalIDgroup)),1) = ids(logicalIDgroup);
        lengthSList = lengthSList + length(ids(logicalIDgroup));
    end
    % order them for spm in right way
    ttest.covariates = jpa_getCovVec(covariates4EachGoup);
    % filter the covarraites which has not been found
    ttest.covariates = ttest.covariates(covNotEmpty);
    
    %% Build & run batch
    % Initialize
    if ttest.run_batch
        spm('defaults','fmri');
        spm_get_defaults('mask.thresh',ttest.spm.spmMaskThresh);
        spm_jobman('initcfg');
    end
    matlabbatch = struct.empty;
    % set analysis folder
    factorial_design.dir = { ttest.analysis };
    % set con-images
    factorial_design.des.t1.scans = ttest.match2Group;
    matlabbatch = jpa_initialFDTtest(matlabbatch, factorial_design);
    % build covariates
    ttest.covarNames = ttest.covarNames(covNotEmpty);
    ttest.interaction = ttest.interaction(covNotEmpty);
    for i=1:sum(covNotEmpty)
        matlabbatch = jpa_addCovariates(matlabbatch,ttest.covariates{i},ttest.covarNames{i},ttest.interaction(i),1);
    end
    % model estimation
    if ttest.est_model
        matlabbatch = jpa_initialFmriEst(matlabbatch);
    end
    % initalize contrast Manager Module
    if ttest.con_man
        if ttest.est_model
            matlabbatch = jpa_initialConMan(matlabbatch);
            for i=1:1:length(ttest.contrastNames)
                [ttest.contrastWeights{i}, st] = jpa_resizeColumsOfMat(ttest.contrastWeights{i},length(ttest.numberOfGrp)+sum(covNotEmpty));
                if st == -1;disp(['WARNING: ContrastWeight ' num2str(i) ' is to long! Removed last Elements: ' mat2str(ttest.contrastWeights{i}) ]);end
                if st == 1;disp(['WARNING: ContrastWeight ' num2str(i) ' is to short! Filled last Elements with zeros: ' mat2str(ttest.contrastWeights{i})]);end
                if strcmp(ttest.contrastType,'t')
                    matlabbatch = jpa_addTContrast(matlabbatch, ttest.contrastNames{i},ttest.contrastWeights{i},ttest.contrastRep{i});
                end
                if strcmp(ttest.contrastType,'f')
                    matlabbatch = jpa_addTContrast(matlabbatch, ttest.contrastNames{i},ttest.contrastWeights{i},ttest.contrastRep{i});
                end
            end
        else % can not run Contrast Manager without Model estimation
            disp('Model estimation-Module not activated. skipping Contrast Manager ...');
        end
    end
    % run spm_jobman
    if ttest.run_batch
        spm_jobman('run',matlabbatch);
    end
    % save matlabbatch & excludeList & includeList
    if ttest.dosavebatch
        ttest.excludeList = unique([ttest.excludeList ids(~idsFound)]);
        ttest.includeList = unique(ttest.includeList);
        jpa_writeArrayToTxt([ttest.analysis, filesep, excludeListFilename '.txt'], ttest.excludeList, 'v' );
        jpa_writeArrayToTxt([ttest.analysis, filesep, includeListFilename '.txt'], ttest.includeList, 'v' );
        jpa_writeArrayToTxt([ttest.analysis, filesep, 'usedSubjectList.txt'], ttest.subjectList, 'v' );
        save([ttest.analysis,filesep,'matlabbatch.mat'],'matlabbatch');
        save([ttest.analysis,filesep,'ttest.mat'],'ttest');
    end
end
% eval results
if ttest.evalResults
    [current_sig_resultsWB,  current_sig_resultsROI] = jpa_evalResults(ttest.analysis, ttest.evalResAtlas,ttest.evalResROI,'ttest',ttest.evalResPValue, ttest.evalResThreshold);
    % write sigResults of current ttest
    jpa_writeResults(current_sig_resultsWB, [ttest.analysis filesep 'results' filesep 'sig_resultsWB.txt']);
    jpa_writeResults(current_sig_resultsROI, [ttest.analysis filesep 'results' filesep 'sig_resultsROI.txt']);
    % get all sigResults of all ttests and fill them with sigRes of current ttest
    ttest_all_sig_resultsWB = jpa_getAllResults([ttest.base_dir_ttest 'ttest_all_sig_resultsWB.mat'],current_sig_resultsWB);
    ttest_all_sig_resultsROI = jpa_getAllResults([ttest.base_dir_ttest 'ttest_all_sig_resultsROI.mat'],current_sig_resultsROI);
    % save them as .mat
    save([ttest.base_dir_ttest 'ttest_all_sig_resultsWB.mat'],'ttest_all_sig_resultsWB')
    save([ttest.base_dir_ttest 'ttest_all_sig_resultsROI.mat'],'ttest_all_sig_resultsROI')
    % write them as .txt
    jpa_writeResults(ttest_all_sig_resultsWB, [ttest.base_dir_ttest 'ttest_all_sig_resultsWB.txt']);
    jpa_writeResults(ttest_all_sig_resultsROI, [ttest.base_dir_ttest 'ttest_all_sig_resultsROI.txt']);
end
% view results
if ttest.viewResults
    match = jpa_getDirs([ttest.analysis filesep 'thresholded'],'*.nii');
    for i=1:1:length(match)
        % make dirs for Pictures
        [pathstr,name] = fileparts(match{i});
        name = [name, 'Pictures'];
        if ~exist([ttest.analysis filesep 'thresholded' filesep name],'dir'); mkdir([ttest.analysis filesep 'thresholded' filesep name]); end
        jpa_viewResults(ttest.mricroGLPath, match{i} , ttest.loadimage, 'edge_phong', ttest.colScheme);
    end
end
% plot results
if ttest.plotResults
    % get all thresholded contrasts to plot pictures for
    match = jpa_getDirs([ttest.analysis filesep 'thresholded'],'*.nii');
    % set specified values
    plot.settings.maxRows =  ttest.plotPerRow;
    plot.settings.maxCols =  ttest.plotPerCol;
    plot.settings.picPerPage = ttest.picPerPage;
    % loop through all thresholded .nii
    for i=1:1:length(match)
        % get Folder and name
        [pathstr,name] = fileparts(match{i});
        % set folder with pictures to plot
        plot.path = [pathstr, filesep, name, 'Pictures', filesep , 'edited' filesep];
        jpa_plotResults(plot);
    end
end

end
%------------- END CODE --------------