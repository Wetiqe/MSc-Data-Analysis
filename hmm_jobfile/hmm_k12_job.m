% fMRI_HMM Script, chronotype project.
% B.T Ingram (2022)

%% Init Parallel Computing
pc = parcluster('local')
pc.JobStorageLocation = getenv('TMPDIR')
parpool(pc, str2num(getenv('SLURM_TASKS_PER_NODE')))

%% Define File Structure
addpath(genpath('/rds/projects/b/bagshaap-eeg-fmri-hmm/Software/HMM-MAR')) % add hmm-mar toolbox
mydir = '/rds/projects/b/bagshaap-eeg-fmri-hmm/Projects/Chronotype/'; % my working directory
DirData = [mydir 'hmm_inputs/'];
DirOut = [mydir 'hmm_results/'];
addpath(genpath([ mydir 'HMM-MAR']))
addpath(genpath('/rds/projects/b/bagshaap-eeg-fmri-hmm/Projects/Chronotype/scripts/matlab/'))

%% Define Data Paramaters

subjects = 37; % number of subjects
sessions = 3; % number of sessions per subject
tr = 2;

total_files = subjects*sessions;

% Create input cell
T = cell(total_files,1);
f = natsort(glob([DirData '*']));

for i=1:total_files
    load(f{i}); T{i} = [450];
end

%% Hidden Markov Model Options
options = struct();
options.order = 0; % multivariate guassian distribution 
options.verbose = 1;
options.cyc = 1000;
options.initrep = 50;
options.initcyc = 100;
options.standardise = 1;
options.inittype = 'HMM-MAR';
options.zeromean = 0; % model the mean
options.covtype = 'full';
options.useParallel = 0;
options.repetitions = 10;
options.Fs = 1/tr;
options.K = 12;
%% Run Model

for rep = 1:5
        [hmm, Gamma, Xi, vpath] = hmmmar(f,T,options);
        save([DirOut 'chronotype_k12_rep_' num2str(rep)  '.mat'],'Gamma','vpath','hmm', 'Xi')
	disp('Run Complete')
end

