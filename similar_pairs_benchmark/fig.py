import numpy as np
import pandas as pd
from scipy import stats
import seaborn as sns
import matplotlib.pyplot as plt

plt.style.use('seaborn-v0_8-white')

class BenchResult:
    def __init__(self, us_q_tm, us_t_tm, uf_q_tm, uf_t_tm, fs_q_tm, fs_t_tm, ft_q_tm, ft_t_tm, chnum1, chnum2, timeByChNum, sdByChNum, maxTimeByChNum, minTimeByChNum, numByChNum):
        self.us_q_tm = us_q_tm
        self.us_t_tm = us_t_tm
        self.uf_q_tm = uf_q_tm
        self.uf_t_tm = uf_t_tm
        self.fs_q_tm = fs_q_tm
        self.fs_t_tm = fs_t_tm
        self.ft_q_tm = ft_q_tm
        self.ft_t_tm = ft_t_tm
        self.chnum1 = chnum1 
        self.chnum2 = chnum2
        self.timeByChNum = timeByChNum
        self.sdByChNum = sdByChNum
        self.maxTimeByChNum = maxTimeByChNum
        self.minTimeByChNum = minTimeByChNum
        self.numByChNum = numByChNum

class FigGen:
    pallet = ["#d7191c", "#fdae61", "#abd9e9", "#2c7bb6", "#d7191c", "#1a9641", "#ffffbf", "#7b3294",  "#c2a5cf"]
    title_style = {'family': 'Arial', 'size': 30, 'weight':'bold'}
    text_style = {'family': 'Arial', 'size': 20, 'weight':'bold'}
    cor_style = {'family': 'serif', 'size': 30}
    reg_style = {'family': 'serif', 'size': 25}
    number_style = {'family': 'serif','size': 15}
    legend_font = "15"

    def __init__(self, benchResult):
        self.bench = benchResult

    def b1_qtm(self, ax, title):
        # common
        ax.set_title(title, fontdict=self.title_style, loc='left')
        ax.set_xlabel('US-align', fontdict=self.text_style)
        ax.set_ylabel('Foldseek-Multimer', fontdict=self.text_style)
        ax.set_xlim(0.35,1.05)
        ax.set_ylim(0.35,1.05)
        ax.set_xticks([round(i*0.2, 1) for i in range(2,6)], [round(i*0.2, 1) for i in range(2,6)], fontdict=self.number_style)
        ax.set_yticks([round(i*0.2, 1) for i in range(2,6)], [round(i*0.2, 1) for i in range(2,6)], fontdict=self.number_style)
        ax.plot([0.4,0.8,1], [0.4, 0.8, 1], '--', color='gray', linewidth=2)
        # AA + 3Di
        ax.scatter(self.bench.us_q_tm, self.bench.fs_q_tm, color=self.pallet[0], s=50, label='Complexsearch (AA+3Di)', alpha=alpha)
        ax.text(0.9, 0.5, f'$r={stats.pearsonr(self.bench.us_q_tm, self.bench.fs_q_tm)[0]:.2f}$', fontdict=self.cor_style, va='center', ha='center', color=FigGen.pallet[0], label='Foldseek')
        # tmalign
        ax.scatter(self.bench.us_q_tm, self.bench.ft_q_tm, color=self.pallet[1], s=50, label='Complexsearch (tmalign)', alpha=alpha)
        ax.text(0.5,0.9, f'$r={stats.pearsonr(self.bench.us_q_tm, self.bench.ft_q_tm)[0]:.2f}$', fontdict=self.cor_style, va='center', ha='center', color=FigGen.pallet[1], label='Foldseek-TM')
        # ax.legend(loc='upper left', fontsize=self.legend_font)
    
    def b1_ttm(self, ax, title):
        # Common
        ax.set_title(title, fontdict=self.title_style, loc='left')
        ax.set_xlabel('US-align', fontdict=self.text_style)
        ax.set_ylabel('Foldseek-Multimer', fontdict=self.text_style)
        ax.set_xlim(0.35,1.05)
        ax.set_ylim(0.35,1.05)
        ax.set_xticks([round(i*0.2, 1) for i in range(2,6)], [round(i*0.2, 1) for i in range(2,6)], fontdict=self.number_style)
        ax.set_yticks([round(i*0.2, 1) for i in range(2,6)], [round(i*0.2, 1) for i in range(2,6)], fontdict=self.number_style)
        ax.plot([0.4,0.8,1], [0.4, 0.8, 1], '--', color='gray', linewidth=2)
        # 3Di + AA
        ax.scatter(self.bench.us_t_tm, self.bench.fs_t_tm, color=self.pallet[0], s=50, alpha=alpha, label='Complexsearch (AA+3Di)')
        ax.text(0.9, 0.5, f'$r={stats.pearsonr(self.bench.us_t_tm, self.bench.fs_t_tm)[0]:.2f}$', fontdict=self.cor_style, va='center', ha='center', color=FigGen.pallet[0])
        # tmalign
        ax.scatter(self.bench.us_t_tm, self.bench.ft_t_tm, color=self.pallet[1], s=50, alpha=alpha, label='Complexsearch (tmalign)')
        ax.text(0.5, 0.9, f'$r={stats.pearsonr(self.bench.us_t_tm, self.bench.ft_t_tm)[0]:.2f}$', fontdict=self.cor_style, va='center', ha='center', color=FigGen.pallet[1])

    def createErrorBar(self, data, err):
        nz = 0.0001
        m = [max(d-e, nz) for d, e in zip(data, err)]
        M = [max(d+e, nz) for d, e in zip(data, err)]
        d = np.log10(data)
        lm = np.log10(m)
        lM = np.log10(M)
        return [d-v for d, v in zip(d, lm)], [v-d for d, v in zip(d, lM)]

    def runtime(self, ax, title, pallet, chainNums, fs_times, ft_times, us_times, uf_times, fs_std, ft_std, us_std, uf_std, y_min, y_max, size, legend=True):
        ALL_CHAINS = [2,3,4,5,6,7,8,9,10,12,14,16,18,24]
        REAL_VAL = [0.1, 1, 10, 100, 1_000, 10_000, 100_000, 1_000_000, 10_000_000]
        CLOG_VAL = [  1, 2,  3,   4,     5,      6,       7,         8,          9]
        indexer = [ALL_CHAINS.index(i) for i in chainNums]
        ax.set_title(title, loc='left', fontdict=self.title_style)
        ax.bar([i-0.3 for i in range(len(chainNums))], np.log10(fs_times.iloc[indexer])+2, color=self.pallet[0], label='Foldseek', width=0.2)
        ax.bar([i-0.1 for i in range(len(chainNums))], np.log10(ft_times.iloc[indexer])+2, color=self.pallet[1], label='Foldseek-TM', width=0.2)
        ax.bar([i+0.1 for i in range(len(chainNums))], np.log10(us_times.iloc[indexer])+2, color=self.pallet[3], label='USalign', width=0.2)
        ax.bar([i+0.3 for i in range(len(chainNums))], np.log10(uf_times.iloc[indexer])+2, color=self.pallet[2], label='USalign -fast', width=0.2)
        
        ax.errorbar([i-0.3 for i in range(len(chainNums))], np.log10(fs_times.iloc[indexer])+2, yerr=self.createErrorBar(fs_times.iloc[indexer], fs_std.iloc[indexer]), color=pallet[0], fmt='none')
        ax.errorbar([i-0.1 for i in range(len(chainNums))], np.log10(ft_times.iloc[indexer])+2, yerr=self.createErrorBar(ft_times.iloc[indexer], ft_std.iloc[indexer]), color=pallet[1], fmt='none')
        ax.errorbar([i+0.1 for i in range(len(chainNums))], np.log10(us_times.iloc[indexer])+2, yerr=self.createErrorBar(us_times.iloc[indexer], us_std.iloc[indexer]), color=pallet[3], fmt='none')
        ax.errorbar([i+0.3 for i in range(len(chainNums))], np.log10(uf_times.iloc[indexer])+2, yerr=self.createErrorBar(uf_times.iloc[indexer], uf_std.iloc[indexer]), color=pallet[2], fmt='none')
        
        ax.set_yticks(CLOG_VAL, ['{:,}'.format(x) for x in REAL_VAL], fontdict=self.number_style)
        ax.text(-1 + -0.3 * size, y_min+2-0.27 * (y_max-y_min) / 4, '# chains', fontdict=self.number_style)
        ax.set_xticks([i for i in range(len(chainNums))],[f'\n{i}' for i in chainNums], fontdict=self.number_style)
        ax.set_ylabel('Avg. runtime in seconds', fontdict=self.text_style)
        ax.set_xlim(-0.5, len(chainNums)-0.5)
        ax.set_ylim(y_min+2, y_max+2)
        if legend:
            ax.legend(fontsize=self.legend_font, loc='upper center', ncol=2*size)
        ax.grid(True, axis='y')
    
    def b1_rt(self, ax, title):
        self.runtime(
            ax, title, self.pallet, [2,3,4,5,6,7,8,9,10,12,14,16,18,24], 
            self.bench.timeByChNum.fs_times, self.bench.timeByChNum.ft_times, self.bench.timeByChNum.us_times, self.bench.timeByChNum.uf_times, 
            self.bench.sdByChNum.fs_times, self.bench.sdByChNum.ft_times, self.bench.sdByChNum.us_times, self.bench.sdByChNum.uf_times, 
            -1, 3, 2
        )
        
    # def b1_rt_sub(self, ax, title):
    #     self.runtime(
    #         ax, title, self.pallet, [2,4,8,16,24], 
    #         self.bench.timeByChNum.fs_times, self.bench.timeByChNum.ft_times, self.bench.timeByChNum.us_times, self.bench.timeByChNum.uf_times, 
    #         self.bench.sdByChNum.fs_times, self.bench.sdByChNum.ft_times, self.bench.sdByChNum.us_times, self.bench.sdByChNum.uf_times, 
    #         -1, 3, 1
    #     )

if __name__ == "__main__":
    alpha = 0.5
    size = 200
    s = 0
    w = 6/26
    p = 2/26
    fmt='png'
    df1 = pd.read_csv("../datasets/similar_pairs_benchmark/pairs.tsv", sep="\t", header=None)
    df1.columns = [0, 1, "ch"]
    for i in [1,2,3,4,5]:
        for j in ["fs", "ft", "us", "uf"]:
            foo = pd.read_csv(f"./tmp/{j}_{i}.tsv", sep="\t", header=None)
            foo.columns = [0, 1, f"{j}_q_tm_{i}" if i>1 else f"{j}_q_tm", f"{j}_t_tm_{i}" if i>1 else f"{j}_t_tm", f"{j}_time{i}"]
            foo[0] = foo[0].apply(lambda x: x.split(".")[0])
            foo[1] = foo[1].apply(lambda x: x.split(".")[0])
            df1 = pd.merge(df1, foo, on=(0, 1))
    
    df1["fs_times"] = df1.apply(lambda x: sum([x[i]for i in ["fs_time1", "fs_time2", "fs_time3", "fs_time4", "fs_time5"]])/5, axis=1)
    df1["ft_times"] = df1.apply(lambda x: sum([x[i]for i in ["ft_time1", "ft_time2", "ft_time3", "ft_time4", "ft_time5"]])/5, axis=1)
    df1["us_times"] = df1.apply(lambda x: sum([x[i]for i in ["us_time1", "us_time2", "us_time3", "us_time4", "us_time5"]])/5, axis=1)
    df1["uf_times"] = df1.apply(lambda x: sum([x[i]for i in ["uf_time1", "uf_time2", "uf_time3", "uf_time4", "uf_time5"]])/5, axis=1)
    df1 = df1[[0, 1, "ch", "fs_q_tm", "fs_t_tm", "fs_times", "ft_q_tm", "ft_t_tm", "ft_times",  "us_q_tm", "us_t_tm", "us_times",  "uf_q_tm", "uf_t_tm", "uf_times"]]
    df1.to_csv("./tot_result.tsv", sep="\t", index=None)
    df2 = df1[(df1.us_q_tm>0.5) & (df1.us_t_tm>0.5)]
    df3 = df1.groupby('ch')[['fs_times', 'ft_times', 'us_times', 'uf_times']]
    bench1 = BenchResult(df2.us_q_tm, df2.us_t_tm, df2.uf_q_tm, df2.uf_t_tm, df2.fs_q_tm, df2.fs_t_tm, df2.ft_q_tm, df2.ft_t_tm, df1.ch, df1.ch, df3.mean(), df3.std(), df3.max(), df3.min(), df3.count())
    fig = plt.figure(figsize=(26, 6))
    gsA = fig.add_gridspec(nrows=1, ncols=1, left=s,         right=s+w,           top=1, bottom=0)
    gsB = fig.add_gridspec(nrows=1, ncols=1, left=s+w+p,     right=s+w+p+w,       top=1, bottom=0)
    gsC = fig.add_gridspec(nrows=1, ncols=1, left=s+w+p+w+p, right=s+w+p+w+p+2*w, top=1, bottom=0)
    FigA = fig.add_subplot(gsA[0])
    FigB = fig.add_subplot(gsB[0])
    FigC = fig.add_subplot(gsC[0])
    figGen = FigGen(bench1)
    figGen.b1_qtm(FigA, 'a')
    figGen.b1_ttm(FigB, 'b')
    figGen.b1_rt(FigC, 'c')
    plt.savefig(f"similar_pairs.png", format=fmt, bbox_inches="tight")
    plt.show()
