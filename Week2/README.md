# 2주차 릴레이 프로젝트 [ I 💗 School ]

## iOS

* NetworkManager 클래스로 네트워크 요청 부분을 분리해주었습니다.
* HttpMethod 열거형에 GET, POST 방식을 추가해주었고, body 에 데이터를 담아 POST 요청이 가능합니다.
```swift
static func request(_ url: String, method: HttpMethod, body: Data? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> ())
```
* 사용예시
```swift
NetworkManager.request("api 주소가 들어갈 부분",method: .GET) { (data, _, _) in
    guard let data = data else { return }
    // 응답값을 사용할 부분
}
```

## 백엔드

>**참고**
>[파이썬 Flask 웹 서버 구축하기](https://m.blog.naver.com/ndb796/221080811928)
>[파이썬 Flask로 간단 웹서버 구동하기](https://velog.io/@decody/%ED%8C%8C%EC%9D%B4%EC%8D%AC-Flask%EB%A1%9C-%EA%B0%84%EB%8B%A8-%EC%9B%B9%EC%84%9C%EB%B2%84-%EA%B5%AC%EB%8F%99%ED%95%98%EA%B8%B0)

**개발 환경**
- IDE : 자유
- Python3 사용
- Flask 서버 사용

**python에서 flask를 이용하여 서버 구축 (RestFul Server 제공) --> Get / Post 사용 (Flask 환경에서 delete, put는 위험)**

- python 터미널에 flask 설치
    ``` console
    pip3 install Flask
    ```


- `main.py` 설명
    ``` python
    from flask import Flask,request, jsonify
    import GetUserTextNoun # 같은 폴더 내 자연어처리 파일 import
    import pandas as pd

    app = Flask(__name__) 
    
    
    @app.route('/') # 예시. 127.0.0.1:5000/ 접속 시 화면에 Hello World 텍스트
    def hello():
        return "Hello World!"
    
      
    @app.route('/info') # 예시. 127.0.0.1:5000/info 접속 시 화면에 info 텍스트
    def info():
        return 'Info'
      
      
    @app.route('/data', methods = ['GET']) # 클라 기준 데이터 전송하는 곳
    def userLogin():
        print("python flask server")
        str = request.args.get('str',"test") # iOS에서 보낸 문자열을 str 변수로 받음
        print(str) 
        obj = GetUserTextNoun.get_tokens(str) # 자연어 처리
        print(obj)
        return "str"
        #TODO: - C기능을 위해 데이터베이스에 저장
        
        
    @app.route('/adsf', methods = ['POST']) # iOS에서 넘어오는 자기소개서 문장을 받는곳
    def test():
        print(request.get_json())
        
    
    if __name__ == '__main__': # 현재 파일명이 main.py 인지
        app.run()
    ​```
    ```
    
    ​    

## 자연어 처리 

>**참고**
>[NLP 튜토리얼](https://beomi.github.io/2020/01/05/Clustering_Twitter_Users/)

- 개발환경 : 
    - Python3.8
    - Pycharm
    - mecab
    - konlpy
    - pandas

- 설치 과정 
    -> Pycharm Terminal Console 사용해 설치
    1. mecab 설치
    ```bash
    bash <(curl -s https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh)
    ```
    2. konlpy 설치
    ```bash
    pip install -q konlpy
    ```
    3. pandas 설치 
    ```bash
    pip install pandas
    ```
    
- 입출력 데이터 타입
= 문자열 (String) -> 배열 (Array)
  
- 입출력 예시
    ```python
    inputString = "저는 청명고등학교를 나온 53세 김가나입니다. 남자입니다. 25회 졸업생이고 충남 출신입니다."
    # 결과 : "[청명, 고등학교, 가나, 남자, 졸업, 충남, 출신]"
    ```

- 메인 화면

    ![](https://i.imgur.com/y7C0YlH.png)

- 서버로 넘어온 데이터 자연어 처리

    ![](https://i.imgur.com/Mt2XWRC.png)







## Docker

![image](https://user-images.githubusercontent.com/21030956/89675730-66cdc480-d925-11ea-9c41-c20dab0eae91.png)

- #### docker build

  `dockerfile` 로 `image` 빌드

  ```bash
  $ docker build -t relay22 .
  ```

- #### docker run

  flask 서버 실행

  ```bash
  $ docker run -p 5000:5000 relay22
  ```

  

  ![image](https://user-images.githubusercontent.com/21030956/89676318-700b6100-d926-11ea-8812-9e1a1825978f.png)



#### 2주차 팀원

> IOS - 조기현, 홍동현, 백종근

> 자연어처리 - 김석호, 조송주, 이태경, 이진호

> 백엔드 - 김병인, 박태희, 오다은, 홍경표