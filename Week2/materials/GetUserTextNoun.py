import pandas as pd
from konlpy.tag import Mecab

def get_tokens(x):
    mecab = Mecab()
    try:
        return [i for i in mecab.nouns(x) if len(i) > 1] if x else []
    except Exception as e:
        if str(x) == 'nan':
            return []
        print(e)
        print(str(x))
        raise e


def getNonunsData():
    df = pd.read_csv('../../Desktop/RelayA/dummy_users.tsv', sep='\t')
    df['user_mecab'] = df['user.description'].map(get_tokens)
    df['user_mecab_len'] = df['user_mecab'].map(len)
    return df

# print(getNonunsData().head())
