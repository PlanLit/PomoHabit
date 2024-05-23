# PomoHabit

![image](https://github.com/PlanLit/PomoHabit/assets/97212841/f521e861-1bf6-4a07-8ceb-f05558a50e80)

<br/>

### 

- **프로젝트 명** : 뽀빗(PomoHabit)
- **소개**
    - 한 줄 정리 : 하루 최소 5분으로 시작하는 습관 형성앱
    - 내용 :  5분에서 시작해  하루 1분씩 25분이 될때까지 늘어나는 점진적 과부하를 통해 한달에 습관 하나를 형성하는데 도움을 줍니다.
<br/>

- 📱 **서비스 링크**: [https://apps.apple.com/kr/app/뽀빗](https://apps.apple.com/kr/app/%EB%BD%80%EB%B9%97/id6479586437)
- 📱 **포빗 노션 링크**: [https://www.notion.so/teamsparta](https://www.notion.so/2-2a171d679ae5469bb360083f1e5d2995?pvs=21)

<br/>

## 🧑‍💻 팀원 소개 (Team)

| https://github.com/joonBaek12 | https://github.com/dongjin97 |  https://github.com/Lilyhly | https://github.com/Deferare |
| --- | --- | --- | --- |
| <img width="250" alt="image" src="https://github.com/Team-Smeme/Smeem-iOS/assets/86944161/0e0cfcb6-d4d7-41f7-9eb0-7f516480939c" /> | ![image](https://github.com/PlanLit/PomoHabit/assets/97212841/3d9686be-8066-4799-841c-42e6c4ec8776) | ![image](https://github.com/PlanLit/PomoHabit/assets/97212841/a9cb76da-c935-4ac8-9675-ed16fb31f035) | ![image](https://github.com/PlanLit/PomoHabit/assets/97212841/c72ec640-0f93-4cf8-9d89-c51032c808a0) | 
| iOS Lead Developer | iOS Developer | iOS Developer | iOS Developer |
| - 프로젝트 구조, coreData 설계 / 리팩토링<br/>- 타이머 뷰 구현<br/> | - 프로젝트 구조 coreData 설계 / 리팩토링<br/>- 주간 캘린더 구현 | - 프로젝트 구조 설계 / 리팩토링<br/>- 마이페이지 뷰 구현| - 프로젝트 구조 설계 / 리팩토링<br/>- 온보딩, 레포트 뷰 구현 | 
<br/>

## ⚒️ 기술 스택 (Tech)

- UIKit
- Combine (iOS 15.0 +)
- SPM
- MVC, MVVM
- DI, FactoryMethod, Singleton, Delegate, Observer

## 🛠 개발 환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.0-orange)]() [![xcode](https://img.shields.io/badge/Xcode-15.0-blue)]() [![Snapkit](https://img.shields.io/badge/SnapKit-5.0.0-yellow)]() 

<br/>

## 🗂️ 프로젝트 구조 (Project Architecture)
<br/>

## 📌 코드 컨벤션 (Code Convention)
👉 https://www.notion.so/teamsparta/Git-Conventions-64258bea816044679a8d6c5966e94366

<br/>

## 📌 커밋 컨벤션 (Commit Convention)

> [태그] 제목의 형태
> 

| 태그 이름 | 설명 |
| --- | --- |
| FEAT | 새로운 기능을 추가할 경우 |
| FIX | 버그를 고친 경우 |
| CHORE | 짜잘한 수정 |
| DOCS | 문서 수정 |
| REFACTOR | 코드 리팩토링 |

<br/>

## 🎋 브랜치 전략 (Branch Strategy)

<img width="500" alt="image" src="https://github.com/Team-Smeme/Smeme-server-renewal/assets/55437339/1699ec13-babc-48f7-a914-d5f1fc1d51dd" />

- **main** : 실제 앱 스토어에 출시하는 브랜치
- **develop** : 개발이 완료된 최신 브랜치
- **feature** : 각 기능을 개발하는 브랜치, 기능 개발 단위로 브랜치 생성, ${[태그 이름]#이슈번호 - 작업 내용}
- **hotfix** : 배포된 버전에서 발생한 버그를 수정하는 브랜치
