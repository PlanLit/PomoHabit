# PomoHabit

https://github.com/PlanLit/PomoHabit/assets/97212841/f521e861-1bf6-4a07-8ceb-f05558a50e80

<br/><br/>

- 📱 **서비스 링크**: [https://apps.apple.com/kr/app/뽀빗/id6479586437](https://apps.apple.com/kr/app/%EB%BD%80%EB%B9%97/id6479586437)
- 📱 **포빗 노션 링크**: [https://www.notion.so/teamsparta/2-2a171d679ae5469bb360083f1e5d2995](https://www.notion.so/2-2a171d679ae5469bb360083f1e5d2995?pvs=21)

<br/>

## 🧑‍💻 팀원 소개 (Team)

[제목 없는 데이터베이스](https://www.notion.so/5d6d0e2682b742b78b932c9cf5a9e5e4?pvs=21)

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
