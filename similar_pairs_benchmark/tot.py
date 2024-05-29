import numpy as np
import pandas as pd
import sys 
if __name__ == "__main__":
    input = sys.argv[1]
    output = sys.argv[2]
    df1 = pd.read_csv(input, sep="\t", header=None)
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
    df1.to_csv(output, sep="\t", index=None)
