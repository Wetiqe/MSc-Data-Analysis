
for K = 2:16
    base_name = ['chronotype_k' num2str(K) '_rep_' ]
    reps = 5
    gamma=[]
    for r = 1:5
        load([base_name num2str(r) '.mat'])
        gamma{r}=Gamma
    end
    
    simi_matrix=zeros(reps,reps)
    for i = 1:5
        for j =i:5
        value = getGammaSimilarity(gamma{i}, gamma{j})
        simi_matrix(i,j)=value; simi_matrix(j,i)=value
        end
    end
    save(['simi_matrix_k' num2str(K) '.mat'], 'simi_matrix')
end

    