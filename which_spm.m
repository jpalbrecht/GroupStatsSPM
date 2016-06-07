% which SPM version to choose
% spm 12 is the latest
% need spm 8 for gPPI
% need spm 5 for BPM
function which_spm(version_spm,user,cmdl)

tmp = version_spm;

if tmp == 12
    try
        tmp = strfind(spm('Version'),'SPM12');
        if isempty(tmp)
            do_it = 1;
        else
            do_it = 0;
        end
    catch
        do_it =1;
    end
    
    if do_it == 1
        try
            spm('Quit')
        catch
        end
        rmpath(genpath('C:\Program Files\spm8'))
        rmpath(genpath('C:\Program Files\spm5'))
        rmpath(['C:\Users\' user '\Google Drive\Library\emuoldMATLAB'])
        rmpath(['C:\Users\' user '\Google Drive\Library\bpm_crack'])
        save('backup.mat');
        clear classes
        addpath 'C:\Program Files\spm12'
        load('backup.mat')
        
        if cmdl
            spm defaults fmri
            spm_jobman initcfg
            spm_get_defaults('cmdline',true)
            disp ('Changed to SPM12')
        else
            spm fmri
            spm('defaults','FMRI')
        end
        
        delete('backup.mat')
    end
elseif tmp == 8
    try
        tmp = strfind(spm('Ver'),'SPM8');
        if isempty(tmp)
            do_it = 1;
        else
            do_it = 0;
        end
    catch
        do_it =1;
    end
    
    if do_it == 1
        
        
        try
            spm('Quit')
        catch
        end
        rmpath(genpath('C:\Program Files\spm12'))
        rmpath(genpath('C:\Program Files\spm5'))
        rmpath(['C:\Users\' user '\Google Drive\Library\emuoldMATLAB'])
        rmpath(['C:\Users\' user '\Google Drive\Library\bpm_crack'])
        save('backup.mat');
        clear classes
        addpath 'C:\Program Files\spm8'
        addpath 'C:\Program Files\spm8\toolbox'
        addpath 'C:\Program Files\spm8\toolbox\PPPI'
        load('backup.mat')
        
        if cmdl
            spm defaults fmri
            spm_jobman initcfg
            spm_get_defaults('cmdline',true)
            disp ('Changed to SPM8')
        else
            spm fmri
            spm('defaults','FMRI')
        end
        
        delete('backup.mat')
    end
elseif tmp == 5
    try
        tmp = strfind(spm('Ver'),'SPM5');
        if isempty(tmp)
            do_it = 1;
        else
            do_it = 0;
        end
    catch
        do_it =1;
    end
    
    if do_it == 1
        
        try
            spm('Quit')
        catch
        end
        rmpath(genpath('C:\Program Files\spm12'))
        rmpath(genpath('C:\Program Files\spm8'))
        save('backup.mat');
        clear classes
        addpath 'C:\Program Files\spm5'
        load('backup.mat')
        
        if cmdl
            % cannot get spm_defaults modified by command line yet in SPM5
            %             spm defaults fmri
            %             spm_jobman initcfg
            %             spm_get_defaults('cmdline',true)
            %             disp ('Changed to SPM5')
            spm fmri
            spm('defaults','FMRI')
        else
            spm fmri
            spm('defaults','FMRI')
        end
        
        % add BPM
        addpath('C:\Program Files\spm5\toolbox\wfu_toolboxes')
        wfu_startup;
        addpath(['C:\Users\' user '\Google Drive\Library\emuoldMATLAB'])
        addpath(['C:\Users\' user '\Google Drive\Library\bpm_crack'])
        delete('backup.mat')
    end
end


end