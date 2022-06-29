# CodingTestRecord
## 📍프로젝트 소개
시간을 정해두고 코딩테스트 연습을 할 수 있습니다!

결과를 기록 할 수 있습니다!

## 🛠 개발환경
<img src="https://img.shields.io/badge/Swift-F05138?style=flat&logo=Swift&logoColor=white"/> <img src="https://img.shields.io/badge/XCode-147EFB?style=flat&logo=XCode&logoColor=white"/> <img src="https://img.shields.io/badge/Combine-gray?style=flat"/> <img src="https://img.shields.io/badge/CoreData-green?style=flat"/>

## ⭐️ 프로젝트 화면

> 연습하고 싶은 테스트를 선택할 수 있습니다!

<img width="33%" src="https://user-images.githubusercontent.com/96657571/176194806-0c96814c-502c-4582-a1bd-70f36f7a438b.png"/>

> 설정을 바꿀 수 있습니다!

<img width="30%" src="https://user-images.githubusercontent.com/96657571/176192672-61e23070-4d8f-4456-9b83-8336f7d1508d.png"/> <img width="30%" src="https://user-images.githubusercontent.com/96657571/176192640-47aab7e4-b74f-4402-a2f6-063289f072e7.png"/> <img width="30%" src="https://user-images.githubusercontent.com/96657571/176192691-d86dee5b-94d7-42ec-b62c-89ce35319f11.png"/>

> 결과를 확인하고 지금까지의 기록을 확인해 보세요!

<img width="30%" src="https://user-images.githubusercontent.com/96657571/176192699-2c382c6c-d538-439a-825f-0117ca17c3a0.png"/> <img width="30%" src="https://user-images.githubusercontent.com/96657571/176192712-3a0b8b1b-12bf-498b-904f-34b465423d30.png"/> <img width="30%" src="https://user-images.githubusercontent.com/96657571/176192728-42bc5508-e218-4695-b392-78824d014a88.png"/>

## 🔗 아키텍처
### MVVM CleanArchitecture Coordinator

> ### MVVM

- UI를 그리는 일과 비즈니스 로직을 분리함.
- ViewController에서 UI를 그리는 역할을 맡고, 로직은 ViewModel에서 관리.

> ### Clean Architecture

- ViewModel에서의 역할도 분리.
- 화면에 필요한 로직을 제외한 비즈니스 로직은 Domain레이어의 UseCase로,
- 데이터를 가져오는 작업은 Data레이어의 Repository로 분리.

> ### Coordinator

- ViewController에서 화면 전환 로직과 의존성 주입의 역할도 분리.
