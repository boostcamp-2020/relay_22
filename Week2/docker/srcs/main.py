from flask import Flask, request, jsonify
from konlpy.tag import Mecab
app = Flask(__name__)


@app.route('/data', methods=['POST'])  # 클라 기준 데이터 전송하는 곳
def user_input():
    print("python flask server")
    content = request.get_json()
    text = content['text']
    print(text)
    obj = get_tokens(text)
    print(obj)
    return jsonify(obj)


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


if __name__ == '__main__':
    app.run(host='0.0.0.0')

