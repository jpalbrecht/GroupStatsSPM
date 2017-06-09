function jpa_switch_spm(pathToSpmOld, pathToSpmNew, startSpm)
% Function that switches the SPM version. Valid is SPM12 and SPM8.
% If only numbers are specified then function will set default path to spm
% First given number is from what version to change. Secound number is to
% what version to change to.
%
% Syntax:  
%    jpa_switch_spm(pathToSpmOld, pathToSpmNew)
%    jpa_switch_spm(pathToSpmOld, pathToSpmNew, startSpm)
%
% Inputs:
%    pathToSpmOld    - string, Path to old SPM version
%                    OR integer, if so default path will be set
%                       i.e. matlabroot\toolbox\spmX
%    pathToSpmNew    - string, path to new SPM version
%                    OR integer, if so default path will be set
%                       i.e. matlabroot\toolbox\spmX
%    startSpm        - boolean, indicates weather to start SPM afterwards
%                       i.e. 0 will not start spm, 1 will do so
%
% Outputs:
%                    
% Example:
%     jpa_switch_spm(8, 12, 0)
%     jpa_switch_spm('C:\Path\To\Old\SPM', 'C:\Path\To\Old\SPM')
%     jpa_switch_spm('C:\Path\To\Old\SPM', 'C:\Path\To\Old\SPM', 1)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also:   

% Author: Jan Albrecht
% Work address:
% email: jan-philipp.albrecht@charite.de, j.p.albrecht@fu-berlin.de
% Website: https://github.com/jpalbrecht
% Jun 2017; Last revision: 09-Jun-2017

%------------- BEGIN CODE --------------
%% Initialize
% read matlab path
currPath = path;

%% Parsing Arguments
if nargin < 2
    disp('Not enough input arguments. use help for more information about inputs!')
else
    if (isnumeric(pathToSpmOld) && isnumeric(pathToSpmNew))
       if ( pathToSpmOld == 8 && pathToSpmNew == 12 )
           pathToSpmOld = [matlabroot filesep 'toolbox' filesep 'spm8'];
           pathToSpmNew = [matlabroot filesep 'toolbox' filesep 'spm12'];
       elseif ( pathToSpmOld == 12 && pathToSpmNew == 8 )
           pathToSpmOld = [matlabroot filesep 'toolbox' filesep 'spm12'];
           pathToSpmNew = [matlabroot filesep 'toolbox' filesep 'spm8'];
       else 
           disp('Unknown spm version number!')
           return
       end
   end
end
if nargin == 2
   startSpm = 0; 
elseif  nargin ==3
   if  (~isnumeric(startSpm) || startSpm == 0)
       startSpm = 0;
   else
       startSpm = 1;
   end
end
%% Change SPM version
% check for correctness
if ~isempty(strfind(currPath , pathToSpmNew ))
    disp([pathToSpmNew ' already exists in matlabPath!'])
    if startSpm
        eval('spm fmri');
    end
    return
end
% read spm version
try
    version = evalc('spm version');
catch
    disp('No SPMX detected. Just added SPM_path to matlab_path!')
    addpath(pathToSpmNew);
    return
end
% initialize newPath
newPath = '';
% split old path that its a cell Array
currPath =  textscan(currPath,'%s', 'delimiter' , ';');
currPath = currPath{1};
[lenPath,~] = size(currPath);
% delete every path that contains pathToSpmOld
for ind=1:1:lenPath 
    if isempty(strfind(currPath{ind,1}, pathToSpmOld))
        newPath = [newPath ';' currPath{ind,1}];
    end
end
% remove leading ; from newPath
newPath = newPath(2:end);
path(newPath);
% add new spm path to path
addpath(pathToSpmNew);
if startSpm
    eval('spm fmri');
end
end
%------------- END CODE --------------