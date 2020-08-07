# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

from flask import Flask,request, jsonify
import GetUserTextNoun
import pandas as pd

app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello Wor치ld!"

# 파이썬 3버전 설치
# sudo pip3 install flask - 파이썬 3버전 플라스크 설치

@app.route('/info')
def info():
    return 'Info'


@app.route('/data', methods = ['GET']) #클라 기준 데이터 전송하는 곳
def userLogin():
    print("python flask server")
    str = request.args.get('str',"test")
    print(str)
    obj = GetUserTextNoun.get_tokens(str)
    print(obj)
    return "str"


@app.route('/adsf', methods = ['POST']) # ios에서 넘어오는 자기소개서 문장을 받는곳
def test():
    print(request.get_json())



if __name__ == '__main__':
    app.run()

# def get_tokens(x):
#     mecab = Mecab()
#     try:
#         return [i for i in mecab.nouns(x) if len(i) > 1] if x else []
#     except Exception as e:
#         if str(x) == 'nan':
#             return []
#         print(e)
#         print(str(x))
#         raise e
#
#
# def getNonunsData():
#     df = pd.read_csv('../../../Desktop/RelayA/dummy_users.tsv', sep='\t')
#     df['user_mecab'] = df['user.description'].map(get_tokens)
#     df['user_mecab_len'] = df['user_mecab'].map(len)
#     return df
# See PyCharm help at https://www.jetbrains.com/help/pycharm/
