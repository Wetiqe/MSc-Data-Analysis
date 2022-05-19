clear
for K = 6:16
TR=2
N=111
repetitions=5
Dirin = ['~/dissertation/analysis/hmm_inputs/'];
DirOut = ['~/dissertation/analysis/output/'];
Dirinfo = ['~/dissertation/analysis/output/hmminfo/'];

% Create input cell
f = cell(N,1); T = cell(N,1);file_names = dir([Dirin 'sub*']);

for j = 1:N
    f{j}=load([Dirin file_names(j).name]);
    T{j} = [450];
end
for r = 1:5
    load([DirOut 'chronotype_k' num2str(K) '_rep_' num2str(r) '.mat'],'Gamma','hmm')
    %% metastate stuff
    figure(r)
    subplot(1,2,1) % Figure 2B
    GammaSubMean = squeeze(mean(reshape(Gamma,[450 1 N K]),1));    
    %GammaSubMean = squeeze(mean(GammaSubMean,1));
    [~,pca1] = pca(GammaSubMean','NumComponents',1);
    [~,ord] = sort(pca1); 
    fo_matrix = corr(GammaSubMean(:,ord))
    imagesc(fo_matrix); colorbar
    subplot(1,2,2) % Figure 2A
    P = hmm.P;
    for j=1:K, P(j,j) = 0; P(j,:) = P(j,:) / sum(P(j,:));  end
    ordered_p = P(ord, ord)
    imagesc(ordered_p,[0 0.25]); colorbar
    axis square
    hold on
    for j=0:K
        plot([0 K+1] - 0.5,[j j] + 0.5,'k','LineWidth',2)
        plot([j j] + 0.5,[0 K+1] - 0.5,'k','LineWidth',2)
    end
    hold off    
    %% subject specific stuff
    for j = 1:N
        data=struct()
        data.X = f{j}.data
        % dual-estimation
        [hmm_subj,Gammaj,vpath_subj] = hmmdual(data,T{j},hmm);
    for k = 1:K
        hmm_subj.state(k).prior = [];
    end
        hmms={};
        hmms{j}.hmm = hmm_subj;
        hmms{j}.gamma = Gammaj;
        hmms{j}.vpath = vpath_subj;
        % use vpath
        
        fo_vpath(j,:)=getFractionalOccupancy(vpath_subj,T{j},hmm_subj.train,2);
        switch_vpath(j,:) = getSwitchingRate(vpath_subj,T{j},hmm_subj.train);
        lifetimes_vpath(j,:) = getStateLifeTimes(vpath_subj,T{j},hmm_subj.train);
        stateinterval_vpath(j,:) = getStateIntervalTimes(vpath_subj,T{j},hmm_subj.train);
        maxfo_vpath(j,:) = getMaxFractionalOccupancy(vpath_subj,T{j},hmm_subj.train);

        % use gamma
        % fo_gamma1(j,:) = mean(Gammaj); this is the same as the following
        % command
        fo_gamma(j,:)=getFractionalOccupancy(Gammaj,T{j},hmm_subj.train,2);
        switch_gamma(j,:) = getSwitchingRate(Gammaj,T{j},hmm_subj.train);
        lifetimes_gamma(j,:) = getStateLifeTimes(Gammaj,T{j},hmm_subj.train);
        stateinterval_gamma(j,:) = getStateIntervalTimes(Gammaj,T{j},hmm_subj.train);
        maxfo_gamma(j,:) = getMaxFractionalOccupancy(Gammaj,T{j},hmm_subj.train);

    end
    vpath_info={};
    vpath_info.fo=fo_vpath; vpath_info.switch=switch_vpath;
    vpath_info.lifetimes=lifetimes_vpath; vpath_info.interval=stateinterval_vpath;
    vpath_info.maxfo=maxfo_vpath;
    gamma_info={};
    gamma_info.fo=fo_gamma; gamma_info.switch=switch_gamma;
    gamma_info.lifetimes=lifetimes_gamma; gamma_info.interval=stateinterval_gamma;
    gamma_info.maxfo=maxfo_gamma;

 
    save([Dirinfo 'hmminfo_k' num2str(k) '_rep_'  num2str(r) '.mat'],'ord','ordered_p', 'fo_matrix', ...
        'hmms','vpath_info','gamma_info')
    
end
clear
end