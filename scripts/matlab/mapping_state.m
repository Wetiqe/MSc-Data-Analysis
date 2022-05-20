osl_startup
K=12 ; N=111; r = 2

; DirOut = ['~/HMM/out/' num2str(K) '_' num2str(N) '/'];
load([DirOut 'HMMrun_rep' num2str(r) '.mat'],'hmm')

parcellationfile='~/HMM/all_20/filtered_GICs.nii.gz' % modified meoldic_IC.nii.gz
maskfile='~/FSL/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz'
wbdir='~/Documents/workbench/bin_rh_linux64'

onconnectivity=1
centermaps=0
scalemaps=0

k=[1:12]
outnii=[DirOut 'result_nii' num2str(r) ]
maps = makeMap(hmm,k,parcellationfile,maskfile,onconnectivity,centermaps,scalemaps,outnii)

outsurf=[DirOut 'result_surf']
%maps_surf = makeMap(hmm,k,parcellationfile,maskfile,onconnectivity, centermaps,scalemaps,outsurf,wbdir)

partialcorr=0
threshold=0.95
centergraphs=1
scalegraphs=1
outputfile=[DirOut 'result_graph']
% graphs = makeBrainGraph(hmm,k,parcellationfile,maskfile,centergraphs,scalegraphs,partialcorr,threshold,outputfile)

