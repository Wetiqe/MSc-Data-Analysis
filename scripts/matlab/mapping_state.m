osl_startup
K=10 ; N=111; r = 2;

DirOut = '~/dissertation/analysis/' ;
load([DirOut 'output/chronotype_k' num2str(K) '_rep_' num2str(r) '.mat'],'hmm')

parcellationfile='~/dissertation/analysis/ICA_20IC/filtered_ICs.nii.gz' % modified meoldic_IC.nii.gz
maskfile='~/FSL/fsl/data/standard/MNI152_T1_2mm_brain.nii.gz'
wbdir='~/Documents/workbench/bin_rh_linux64'

onconnectivity=1
centermaps=0
scalemaps=0

k=[1:10]
outnii=[DirOut 'surface/' 'statemap_' 'K' num2str(K) 'rep' num2str(r) ]
maps = makeMap(hmm,k,parcellationfile,maskfile,onconnectivity,centermaps,scalemaps,outnii)

outsurf=[DirOut  'surface/' 'statemap_' 'K' num2str(K) 'rep' num2str(r) ]
maps_surf = makeMap(hmm,k,parcellationfile,maskfile,onconnectivity, centermaps,scalemaps,outsurf,wbdir)
% 
% partialcorr=0
% threshold=0.95
% centergraphs=1
% scalegraphs=1
% outputfile=[DirOut 'result_graph']
% graphs = makeBrainGraph(hmm,k,parcellationfile,maskfile,centergraphs,scalegraphs,partialcorr,threshold,outputfile)

