# 외주 CFO 서비스 랜딩 페이지

정부지원금 신청 대행 서비스를 소개하는 랜딩 페이지입니다.

## 프로젝트 구조

```
.
├── index.html      # 메인 HTML 파일
├── styles.css      # 스타일시트
└── README.md       # 프로젝트 설명
```

## 기능

- 반응형 디자인
- 모던한 UI/UX
- 모바일 최적화
- 접근성 고려

## 시작하기

1. 저장소를 클론합니다:
```bash
git clone https://github.com/sewoong333/CFO190.git
```

2. `npm start` 로 로컬 서버 실행 후 브라우저에서 확인.

## 푸시 및 배포

이 폴더는 GitHub에서 받은 **CFO190** 저장소입니다. 푸시·배포는 아래 중 하나로 실행하세요.

### 방법 1: 스크립트 한 번에 실행 (권장)

**CFO190-main** 폴더에서 PowerShell을 연 뒤:

```powershell
.\push-and-deploy.ps1
```

- 원격 저장소: `https://github.com/sewoong333/CFO190.git`
- Vercel 첫 배포 시: 터미널에서 `npx vercel login` 한 번 실행 후 다시 `.\push-and-deploy.ps1` 실행.

### 방법 2: 수동 실행

```bash
git init
git add .
git commit -m "푸터 사업자정보 반영 및 배포"
git remote add origin https://github.com/sewoong333/CFO190.git
git branch -M main
git push -u origin main

npx vercel login   # 최초 1회
npx vercel --yes   # 배포
```

- **Git**이 설치되어 있어야 합니다: https://git-scm.com/download/win  
- **원격 저장소**: https://github.com/sewoong333/CFO190

## 기술 스택

- HTML5
- CSS3
- 반응형 디자인
- 모던 웹 표준 