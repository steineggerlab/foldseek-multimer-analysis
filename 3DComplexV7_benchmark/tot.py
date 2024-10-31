import sys
import numpy as np
import pandas as pd

def main(qs_pairs, fs_pairs, out_file):
    qs = set([tuple(sorted(p.strip().split(","))) for p in open(qs_pairs).readlines()[1:]])
    fs = set([tuple(sorted(p.strip().split(","))) for p in open(fs_pairs).readlines()[1:]])

    qs_only = len(qs - fs)
    fs_only = len(fs - qs)
    commons = len(fs & qs)
    qs_tots = len(qs)

    table = pd.DataFrame(
        {
            'Missed':   [qs_only, qs_only/qs_tots],
            'Confrimed':[commons, commons/qs_tots],
            'Novel':    [fs_only, fs_only/qs_tots]
        }
    ).T
    table[0] = table[0].apply(lambda x: int(x))
    table[1] = table[1].apply(lambda x: round(x, 4))
    table.columns = ['counts', 'ratio']
    table.to_csv(out_file, sep='\t')

if __name__ == "__main__":
    qs_pairs = sys.argv[1]
    fs_pairs = sys.argv[2]
    out_file = sys.argv[3]
    main(qs_pairs, fs_pairs, out_file)
