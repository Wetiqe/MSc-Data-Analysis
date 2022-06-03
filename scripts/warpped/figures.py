from matplotlib import pyplot as plt
import numpy as np


heatmap_colors=...
boxplot_colors=...

def update_matplotlib_fontsize():
    parameters = {'axes.labelsize': 20,
                  'axes.titlesize': 20,
                  'figure.titlesize':20,
                  'xtick.labelsize':18,
                  'ytick.labelsize':18,
                  'legend.fontsize':14,
                  'legend.title_fontsize':15}
    plt.rcParams.update(parameters)
        


def get_sig(df,feature):
    sig = df.loc[scale,'p value']
    symbol = ''
    if  0.01 < sig < 0.05:
        symbol = '*'
    elif 0.001< sig <=0.01:
        symbol = '**'
    elif sig <=0.001:
        symbol = '***'
    elif 0.05 <= sig <0.10:
        symbol = '^'
    return (sig, symbol)


def plot_sig(xstart,xend,ystart,yend,sig):
    x = [xstart,xstart]
    y = [ystart,yend]
    plt.plot(x,y,color="black",linewidth=2)
    
    x = [xstart,xend]
    y = [yend,yend]
    plt.plot(x,y,color="black",linewidth=2)

    x0 = (xstart+xend)/2
    y0=yend
    plt.annotate(r'%s'%sig, xy=(x0, y0), xycoords='data', xytext=(-15, +1),
                 textcoords='offset points', fontsize=25,color="black")
    x = [xend,xend]
    y = [ystart,yend]
    plt.plot(x,y,color="black",linewidth=2)
    

def fig_set():
    ax = plt.gca()      #gca='get current axis'
    # 将右边和上边的边框（脊）的颜色去掉
    ax.spines['right'].set_color('none')
    ax.spines['top'].set_color('none')
    ax.xaxis.set_ticks_position('bottom')
    ax.yaxis.set_ticks_position('left')
    plt.tight_layout()
    
#     font2 = {'weight' : 'normal','size'   : 20, }
#     plt.ylabel('{}评分'.format(scale),font=font2)
#     plt.tick_params(labelsize=20)
#     plt.ylim(0, y_max*1.3)
    
