# Relay 22 - Week4 아이💗스쿨

---

## 구성원

S010 김승언

S032 오다은

S039 이승진

S016 문성주

S034 오태양

S054 조송주

S023 서명렬

S037 윤병휘

S059 최광현

S027 신병기

S038 이상윤

S061 최철웅

---

# 기능 C - 친구 추천 기능

특정 User 와 저장된 다른 User Data를 비교하여 높은 유사도를 갖는 User들을 ‘친구’로 추천한다.

- User list 중, **학교가 같고 취미가 유사한** 사람을 선별하여 추천한다.
- ex) 학교: membership, 취미: 프로그래밍 일 때,  학교가 membership 이고 취미가 파이썬 인 User가 추천 리스트에 포함될 수 있다.

## 최종 구현

---

![3](https://user-images.githubusercontent.com/62557093/90868994-93c4b180-e3d2-11ea-9911-3ecc4ac44172.gif)
---

## API

### **Alamofire**

- Alamofire 란
    - Apple의 Foundation networking 기반으로 인터페이스를 제공
    - iOS, macOS를 위한 스위프트 기반 HTTP 네트워킹 라이브러리
    - 일반적인 네트워킹 작업을 단순화
- 기능
    - Request / Response method
    - JSON Parameter
    - Response serialization
    - Authentication 등.. 많은 기능 내포
- 기초 사용법

[Swift, Alamofire가 무엇인지, 어떻게 사용하는지 알아봅니다](https://devmjun.github.io/archive/Alamofire)

### **ADAMS.AI OPEN API**

- DeepTopicRank Trend API(연관 주제어 분석 API)

    주어진 질의어에 대해 뉴스, 블로그에 등록되어 있는 문서의 기간별 통계를 제공합니다.

    입력된 기간에 대하여 단위 기간을 설정할 수 있습니다.

    결과는 json 형태로 제공 되며, 질의어에 해당하는 문서 통계 결과와 같은 기간의 전체 문서 통계 결과를 제공합니다. 결과 값은 월별로 군집시킬 수 있습니다.

    [https://www.adams.ai/apiPage?deeptopicrankTrend](https://www.adams.ai/apiPage?deeptopicrankTrend)
