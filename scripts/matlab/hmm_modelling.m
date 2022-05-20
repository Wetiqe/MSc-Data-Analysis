%% SETUP THE MATLAB PATHS AND FILE NAMES
mydir = '/home/jzni/Documents/MATLAB/';
addpath(genpath([ mydir 'HMM-MAR-Master']))
DirData = ['~/HMM/'];

N=111 % no. scans
repetitions = 5; % to run it multiple times (keeping all the results)
TR = 2;  
f = cell(N,1); T = cell(N,1);
% each .mat file contains the data (ICA components) for a given subject, 
% in a matrix X of dimension (4800time points by 50 ICA components). 
% T{j} contains the lengths of each session (in time points)
file_names = dir('*.mat'); 
for j = 1:N
    load([DirData file_names(j).name])
    f{j}=data(:,[1:10,12:15,18,20]);
    T{j} = [450];
end

use_stochastic = 0; % set to 1 if you have loads of data
options = struct();
options.order = 0; % no autoregressive components
options.zeromean = 0; % model the mean
options.covtype = 'full'; % full covariance matrix
options.Fs = 1/TR; 
options.verbose = 1;
options.standardise = 1;
options.inittype = 'HMM-MAR';
options.useParallel = 0 ;
options.cyc = 1000;
options.initrep = 50;
options.initcyc = 100;

%% Run HMM
for K=12 % no. states

DirOut = ['~/HMM_test/out/' num2str(K) '_' num2str(N) '/'];
mkdir(DirOut);

options.K = K; % number of states 

% We run the HMM multiple times
for r = 1:repetitions
    [hmm, Gamma, ~, vpath] = hmmmar(f,T,options);
    save([DirOut 'HMMrun_rep' num2str(r) '.mat'],'Gamma','vpath','hmm')
    disp(['RUN ' num2str(r)])
end
end

