<div align="center">
    <div>
        <img width="100%" src="https://github.com/user-attachments/assets/92ab6374-7ee1-44eb-801d-89fe72440edd">
    </div>
    <div>
        <h1 style="margin: 20px 0;">TODO의 자율 주행, $\huge{\color{#29FF74}Memento}$</h1>
        <p><strong>Memento</strong>는 사용자가 할 일을 입력하면 AI가 이를 자동으로 정렬하고 최적의 타임라인을 생성하는 <strong>자율주행 개념의 생산성 서비스</strong>입니다.</p>
    </div>
</div>

#

<br>

#  Developers
| [<img width="25" height="25" src="https://github.com/user-attachments/assets/101a205e-11db-4e17-af4e-b461bc11fe8f"><br>@mcrkgus](https://github.com/mcrkgus) | [<img width="25" height="25" src="https://github.com/user-attachments/assets/d36daa41-fe3b-4d44-90a8-11814efc296f"><br>@jeonguk29](https://github.com/jeonguk29) | [<img width="25" height="25" src="https://github.com/user-attachments/assets/25e92f00-9d4a-4808-b4f2-697d1423a62f"><br>@sem-git](https://github.com/sem-git) |
|:---:|:---:|:---:|
|<img width="250" alt="mcrkgus" src="https://github.com/user-attachments/assets/8d31c11f-3478-4482-b6a9-73a4fc1bc420">|<img width="250" alt="jeonguk29" src="https://github.com/user-attachments/assets/2fbc1d56-33a3-4e40-b10a-9466eb44666e">|<img width="250" alt="sem-git" src="https://github.com/user-attachments/assets/df094df5-da54-47b9-b77c-d6f5c298eb00">|
| `Splash`<br>`투데이`<br>`탭 바` | `온보딩`<br>`회원가입/로그인`<br>`브레인 덤프`<br>`아이젠하워`<br> | `투두 리스트`<br> |

| [<img width="25" height="25" src="https://github.com/user-attachments/assets/70e84f9b-66c1-4fc3-b2b2-54ce668a41d2"><br>@rafa-e1](https://github.com/rafa-e1) | [<img width="25" height="25" src="https://github.com/user-attachments/assets/d2b4e52c-8cc7-464e-b00a-273c0d0816b9"><br>@parkikbum](https://github.com/parkikbum) | [<img width="25" height="25" src="https://github.com/user-attachments/assets/077607bd-5ee2-4411-adf3-efb53e892b5b"><br>@Memento](https://github.com/orgs/dev-memento/repositories)
|:---:|:---:|:---:|
|<img width="250" alt="rafa-e1" src="https://github.com/user-attachments/assets/2dbe05cc-d3a6-406d-9a45-991e3bf7044c">|<img width="250" alt="parkikbum" src="https://github.com/user-attachments/assets/944978c5-eaaf-4ac7-9936-09492a194dca">|<img width="250" alt="Memento" src="https://github.com/user-attachments/assets/8997057e-711a-418f-99dc-05be6d34e2c2">|
| `투두/일정 생성 및 삭제` | [`Memento Design System`](https://github.com/dev-memento/memento-design-system-iOS])<br>[`Memento Calendar`](https://github.com/dev-memento/memento-calendar)<br>[`Mac App`](https://github.com/dev-memento/memento-app-mac) | - |

<br>

# 🔗 Flow Chart
![Flow Chart](https://github.com/user-attachments/assets/a6637fb1-0622-4e40-a243-54ca2a98950a)

<br>

# <img width="25" height="25" src="https://github.com/user-attachments/assets/6b10d8a9-7905-4400-94ee-7c609a65271f"> Conventions
[💻 Code Convention](https://testmanzi.notion.site/code-convention?pvs=4)<br>
[📝 Git Convention](https://testmanzi.notion.site/git-convention?pvs=4)<br>
[👀 PR Convention](https://testmanzi.notion.site/pr-convention?pvs=4)

<br>

# <img width="25" height="25" src="https://github.com/user-attachments/assets/01d71526-e294-435f-aed8-b9a0eb74d8e9"> Git Flow
❗️main 브랜치에서는 작업 $\huge{\color{#FF4D4D}\ 절대\ 금지}$

![git-flow](https://github.com/user-attachments/assets/ad3ef1f1-17c0-44d1-ae38-b4f5a07655c7)

### 1️⃣ 이슈 생성
> 작업할 내용을 정의하고 이슈 생성

### 2️⃣ 로컬 환경 최신화
> 내 로컬에서 develop 브랜치가 최신 상태인지 확인
develop 브랜치 pull로 항상 최신 상태 유지

### 3️⃣ 새로운 이슈 브랜치 생성
> develop 브랜치에서 새로운 브랜치 생성
> 
> 브랜치 이름은 다음 형식으로 작성:
> 커밋 타입/#(이슈번호)

ex) `feature/#123`

### 4️⃣ 브랜치에서 작업 진행
> 생성한 브랜치에서 작업을 시작

### 5️⃣ 커밋 작성
> 작업한 기능 단위로 작은 커밋을 작성 (작업 흐름이 잘 드러나도록 커밋을 세분화)

### 6️⃣ 작업 완료 후 에러 확인
> ⭐️ 작업이 완료되었으면 에러가 없는지 확인 ⭐️
>
> 기능이 정상적으로 동작하고, 문제가 없음을 확인 후 push

### 7️⃣ 브랜치 Push 및 PR 생성
> 브랜치를 원격 저장소에 push
>
> 작업한 내용을 병합하기 위해 Pull Request 생성

### 8️⃣ 코드 리뷰 및 수정 반영
> 리뷰 받은 사항을 반영 후 수정
>
> 모든 수정이 완료되면 develop 브랜치에 병합

<br>

# 📂 Foldering
```
📁 Project
├── 📁 Resource
│   └── 🎨 Assets.xcassets
├── 📁 Source
│   ├── 📁 App
│   │   ├── 📄 Config.swift
│   │   └── 📄 Memento_iOSApp.swift
│   ├── 📁 Component
│   │   ├── 📁 Alert
│   │   ├── 📁 MementoCell
│   │   ├── 📁 TabBar
│   │   ├── 📁 TimePickerView
│   │  ...
│   ├── 📁 Const
│   │   └── 📄 StringLiteral.swift
│   ├── 📁 Data
│   ├── 📁 Extension
│   ├── 📁 Network
│   │   ├── 📁 AI
│   │   │   ├── 📁 DTO
│   │   │   │   ├── 📁 Request
│   │   │   │   └── 📁 Response
│   │   │   ├── 📁 TargetType
│   │   │   └── 📄 PrioritizationAPIService.swift
│   │   ├── 📁 Base
│   │   │   ├── 📄 BaseAPIService.swift
│   │   │   ├── 📄 BaseDTO.swift
│   │   │   ├── 📄 BaseTargetType.swift
│   │   │   ├── 📄 MoyaPlugin.swift
│   │   │   ├── 📄 NetworkResult.swift
│   │   │   ├── 📄 NetworkService.swift
│   │   │   ├── 📄 TokenKeychainManager.swift
│   │   │   └── 📄 TokenRefreshPlugin.swift
│   │  ...
│   ├── 📁 Presentation
│   │   ├── 📁 Add
│   │   │   ├── 📁 AddSchedule
│   │   │   │   ├── 📁 Model
│   │   │   │   ├── 📁 View
│   │   │   │   └── 📁 ViewModel
│   │   │  ...
│   │   ├── 📁 Main
│   │   └── 📁 Onboarding
│   └── 📁 Utils
└── 📄 Info.plist
```

<br>

# <img width="20" height="20" src="https://github.com/user-attachments/assets/02758c31-aa65-44f5-b9a6-71938c729750"> Library
| Name         | Version  |          |
| ------------ |  :-----: |  ------------ |
| [Alamofire](https://github.com/Alamofire/Alamofire) | `5.10.2` | HTTP 네트워크 통신을 간단하고 효율적으로 처리할 수 있도록 지원한다. |
| [Firebase](https://github.com/firebase/firebase-ios-sdk) | `11.7.0` | 데이터베이스, 인증, 클라우드 기능 등을 쉽게 구현할 수 있도록 지원한다. |
| [Moya](https://github.com/Moya/Moya) |  `15.0.3`  | 네트워크 요청을 효율적이고 구조적으로 관리하기 위해 설계된 네트워크 추상화 라이브러리로, 코드의 가독성과 유지 보수성을 높인다.|
| [Lottie](https://github.com/airbnb/lottie-ios) | `4.5.1` | JSON 기반의 벡터 애니메이션을 iOS 앱에서 쉽게 추가하고 관리한다. |

# <img width="20" height="20" src="https://github.com/user-attachments/assets/02758c31-aa65-44f5-b9a6-71938c729750"> Memento Library
| Name         | Version  |          |
| ------------ |  :-----: |  ------------ |
| [MCalendar](https://github.com/dev-memento/memento-calendar.git) | `1.0.4`  | 달력 기반의 UI 및 일정 관리 기능을 제공하는 Memento 팀이 자체 제작한 라이브러리 |
| [MDSKit](https://github.com/dev-memento/memento-design-system-iOS) | `1.0.1` | 디자인 시스템에 기반한 공통 UI 컴포넌트 및 유틸리티를 제공하는 Memento 팀의 커스텀 라이브러리|

<br>

# <img width="25" height="25" src="https://github.com/user-attachments/assets/f3d15d7c-b256-489d-b850-cfc364d48f84"> Trouble Shooting
[🔥 Trouble Shooting](https://testmanzi.notion.site/trouble-shooting?pvs=4)
