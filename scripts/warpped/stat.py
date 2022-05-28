import numpy as np
import pingouin as pg
import pandas as pd


def partial_corr(working_df,K_state, covariates=[],skipped=[], correct_p=True, correct_method="holm"):
    """
    Partial correlation using pingouin. 
    P values corrected for multiple comparsion problem
    """
    IVs = working_df.columns[:K_state] # independent variables
    DVs = working_df.columns[K_state:] # dependent variables
    DVs = DVs[~DVs.isin(skipped)] # drop the variables that are not useful for correlation
    r_matrix = pd.DataFrame(np.zeros((len(IVs),len(DVs))), index=IVs, columns=DVs) 
    p_matrix = r_matrix.copy()

    for y_label in DVs:
        p_vals = []
        for state in IVs:
            x_label = state

            # Create a df only contains the variables using now
            # This is a good practice when using pingouin 
            df = working_df[[x_label, y_label]+covariates] 
            df = df.dropna(how='any',axis=0) # drop any row with missing value
            # Select correlation method based on multivariate normality test result
            method = "pearson" if pg.multivariate_normality(df[[x_label, y_label]])[2] else "spearman"

            results = pg.partial_corr(data=df, x=x_label, y=y_label, covar=covariates, method=method).round(3)
            r_matrix.loc[x_label, y_label] = results.loc[method,'r']
            p_vals.append(results.loc[method,'p-val'])
        if correct_p == True:
            bools, p_vals = pg.multicomp(p_vals, alpha=0.05, method=correct_method)
        p_matrix.loc[:, y_label] = p_vals  
    
    return r_matrix, p_matrix