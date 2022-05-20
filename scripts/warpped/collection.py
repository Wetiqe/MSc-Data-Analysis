#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
@Author: Jianzhang Ni
@Date: 2022.5.18
@Email: jzni132134@gmail.com
@GitHub: https://github.com/Wetiqe
"""

from scipy.io import loadmat
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import seaborn as sns

from sklearn.neighbors import KNeighborsClassifier
from sklearn import neighbors


def load_simimat(K,base):
    return loadmat(f'{base}simi/simi_matrix_k{K}.mat')['simi_matrix']


def mean_simi(simi_matrix, reps=5):
    return (simi_matrix.sum()-5)/(reps*(reps - 1))


def mean_simi_mat(K_range, base):
    mean_simi_df = pd.DataFrame([],index=K_range, columns=['State', 'Mean_simi'])
    for K in K_range:
        if K == 1:
            mean_simi_df.loc[K, 'Mean_simi'] = 1
            mean_simi_df.loc[K, 'State'] = f'1 States'
        else:
            mean_simi_df.loc[K, 'Mean_simi'] = mean_simi(load_simimat(K, base))
            mean_simi_df.loc[K, 'State'] = f'{K} States'
    return mean_simi_df



def parse_chronnectome(info_array, model_selection=False):
    """
    Use this function to load chronnectome data in hmminfo file.
    Input:
        info_array: either vpath_info or gamma_info.
        model_selection: By default, returns the raw_fo dataframe, state life time and state intervals. 
            If True, will return maxfo and switching rate. 
    """
    info_array = info_array[0][0]
    if model_selection:
        switching_rate = np.squeeze(info_array[1]); maxfo = np.squeeze(info_array[4])
        return switching_rate, maxfo
    else: 
        raw_fo = info_array[0]
        lifetime = info_array[2]; intervals = info_array[3]
        return raw_fo, lifetime, intervals

    
def get_mean_chronnectome(df):
    """
    df should contains the state lifetime or interval for each subject
    """
    result = np.zeros_like(df)
    for subj in range(df.shape[0]):
        for state in range(df.shape[1]):
            vector = df[subj,state]
            if vector.size:
                mean_value = vector.mean()
            else:
                mean_value = 0
            result[subj,state] = mean_value
    return result


def get_number_of_visit(df):
    """
    df should contains the state lifetime for each subject
    """
    result = np.zeros_like(df)
    for subj in range(df.shape[0]):
        for state in range(df.shape[1]):
            vector = np.squeeze(df[subj,state])
            result[subj,state] = vector.size
    return pd.DataFrame(result, columns=[f'state{i+1}_visits' for i in range(df.shape[1])]) 


def warp_knn(X,y,n_neighbors, cmap_light, cmap_bold):
    h = 0.02  # step size in the mesh
    for weights in ["uniform", "distance"]:
        # we create an instance of Neighbours Classifier and fit the data.
        clf = neighbors.KNeighborsClassifier(n_neighbors, weights=weights)
        clf.fit(X, y)

        # Plot the decision boundary. For that, we will assign a color to each
        # point in the mesh [x_min, x_max]x[y_min, y_max].
        x_min, x_max = X[ 0].min() - 1, X[0].max() + 1
        y_min, y_max = X[ 1].min() - 1, X[1].max() + 1
        xx, yy = np.meshgrid(np.arange(x_min, x_max, h), np.arange(y_min, y_max, h))
        Z = clf.predict(np.c_[xx.ravel(), yy.ravel()])

        # Put the result into a color plot
        Z = Z.reshape(xx.shape)
        plt.figure(figsize=(8, 6))
        plt.contourf(xx, yy, Z, cmap=cmap_light)

        # Plot also the training points
        sns.scatterplot(
            x=X[:,0],
            y=X[:,1],
            hue=y,
            palette=cmap_bold,
            alpha=1.0,
            edgecolor="black",
        )
        plt.xlim(xx.min(), xx.max())
        plt.ylim(yy.min(), yy.max())
        plt.title(
            "2-Class classification (n = %i, weights = '%s')" % (n_neighbors, weights)
        )
    plt.show()