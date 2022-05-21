import numpy as np
from matplotlib import pyplot as plt
import seaborn as sns

from sklearn.neighbors import KNeighborsClassifier
from sklearn import neighbors


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