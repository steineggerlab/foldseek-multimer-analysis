import sys
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib_venn import venn2, venn2_circles
import matplotlib.lines as mlines
plt.style.use('seaborn-v0_8-white')
plt.rcParams['svg.fonttype'] = 'none'
final_pallet = ["#d7191c", "#fdae61", "#abd9e9", "#2c7bb6", "#d7191c", "#1a9641", "#ffffbf", "#7b3294", "#c2a5cf"]
title_style = {'family': 'Arial', 'size': 30, 'weight':'bold'}
legend_font = "15"

alpha = 0.5
venn_font_size = 20
def BU_homo_res(ax, title, pallet, s, qs_only, fs_only, commons, qs_tots):
    ax.set_title(title, loc='left', fontdict=title_style)
    out = venn2(subsets=(qs_only, fs_only, commons), set_labels = ('', ''), ax=ax, alpha=1)
    out.get_label_by_id('10').set_text(f'{qs_only:,}\n({qs_only/qs_tots*100:.2f}%)')
    out.get_label_by_id('11').set_text(f'{commons:,}\n({commons/qs_tots*100:.2f}%)')
    out.get_label_by_id('01').set_text(f'{fs_only:,}\n({fs_only/qs_tots*100:.2f}%)')
    out.get_patch_by_id('10').set_color(pallet[5])
    out.get_patch_by_id('11').set_color(pallet[6])
    out.get_patch_by_id('01').set_color(pallet[4])
    for text in out.subset_labels:
        text.set_fontsize(venn_font_size)

    Miss = mlines.Line2D([], [], color=pallet[5], marker='s', linestyle='None', markersize=s, markeredgecolor='k', markeredgewidth=2, label='QSalign BUs missed')
    Found = mlines.Line2D([], [], color=pallet[6], marker='s', linestyle='None', markersize=s, markeredgecolor='k', markeredgewidth=2,  label='QSalign BUs confirmed')
    Novel = mlines.Line2D([], [], color=pallet[4], marker='s', linestyle='None', markersize=s, markeredgecolor='k', markeredgewidth=2,  label='FS-Multimer novel')
    ax.legend(handles=[Miss, Found, Novel], fontsize=legend_font, loc=(0,-0.15))

if __name__ == "__main__":
    qs_pairs = sys.argv[1]
    fs_pairs = sys.argv[2]
    out_file = sys.argv[3]
    qs = set([tuple(sorted(p.strip().split(","))) for p in open(qs_pairs).readlines()[1:]])
    fs = set([tuple(sorted(p.strip().split(","))) for p in open(fs_pairs).readlines()[1:]])
    
    qs_only = len(qs - fs)
    fs_only = len(fs - qs) 
    commons = len(fs & qs)
    qs_tots = len(qs)
    
    fig = plt.figure(figsize=(6, 6))
    gsc = fig.add_gridspec(nrows=1, ncols=1, left=0, right=1, top=1, bottom=0)
    Fig = fig.add_subplot(gsc[0])
    
    BU_homo_res(Fig, '', final_pallet, 20, qs_only, fs_only, commons, qs_tots)
    plt.savefig(out_file, format="png", bbox_inches="tight")
