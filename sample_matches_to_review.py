import pandas as pd
import numpy as np

lfo = pd.read_csv("./lf_output.tsv", sep="\t", usecols=[0,3,4,5], names=["PMID", "Start", "End", "Match"], dtype={"PMID":str, "Start":"int32", "End":"int32", "Match":str})
lfo["PMID"] = pd.Series(["PMID:"]*lfo.shape[0], index=lfo.index).str.cat(lfo["PMID"])  

# Select the 500 most frequently matched terms
top500 = lfo.groupby(by=["Match"]).apply(lambda x: len(x.values)).sort_values(ascending=False)[:500]
top500 = top500.reset_index(drop=False).rename(columns={0:"N_hits"})

# Pick 5 PIDS for each of the top 500 matched terms
# for_review = pd.DataFrame(top500["Match"].apply(lambda x: np.random.choice(lfo.loc[lfo.Match == x, "PMID"].values, size=5, replace=False)).values, index=top500.Match.values, columns=["PMID"]).reset_index(drop=False).rename(columns={"index":"Match"}).explode("PMID").reset_index(drop=True)   ## explode only works for pandas >= 0.25 !!!

# Pick 5 PIDS for each of the top 500 matched terms; also outputs the text coordinates in the same step!
for_review = pd.DataFrame(np.vstack(top500["Match"].apply(lambda x: lfo.loc[(lfo.PMID.isin(np.random.choice(lfo.loc[lfo.Match == x, "PMID"].unique(), size=5, replace=False))) & (lfo.Match == x)].drop_duplicates(subset=["PMID", "Match"], keep="first").reset_index()).values), columns=np.append("index", lfo.columns.values)).set_index("index")

for_review.to_csv("./lf_output_for_review.tsv", sep="\t", header=False, index=False)


# pd.DataFrame(np.vstack(list(lfo.groupby(by=["Match"]).apply(lambda x: x.values[np.random.choice(x.values.shape[0], size=5, replace=False)] if(x.values.shape[0]>=5) else x.values[np.random.choice(x.values.shape[0], size=x.values.shape[0], replace=False)]).values)), columns=lfo.columns).to_csv("./lf_output_for_review.tsv", sep="\t", header=False, index=False)
