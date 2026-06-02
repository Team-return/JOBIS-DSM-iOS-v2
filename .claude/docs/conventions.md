# 커밋 & PR 컨벤션

## 커밋 메시지

```
<이모지> :: (#이슈번호) 한 줄 설명
```

| 이모지 | 용도 |
|--------|------|
| ✨ | 새 기능 |
| 🐛 | 버그 수정 |
| ♻️ | 리팩토링 |
| 🎨 | UI 수정 |
| 📝 | 문서 |
| 🔧 | 설정 변경 |
| 🤖 | 자동화, 에이전트, CI |
| 👥 | 팀 설정 (CODEOWNERS 등) |
| 🙈 | gitignore |

예시:
```
✨ :: (#101) 공지사항 상세 첨부파일 다운로드 기능 추가
🐛 :: (#102) NoticeFlow rootViewController nil 크래시 수정
```

## 이슈 제목

- **이모지 없음**
- 형식: `{기능 설명}` (간결하게)
- 예시: `공지사항 첨부파일 다운로드 기능`

## PR 제목 & 본문

- 제목 앞 🔗 이모지 필수
- 형식: `🔗 :: (#이슈번호) 한 줄 설명`

```markdown
## Summary
- 변경 사항 bullet

## Test plan
- [ ] 테스트 항목
```

## 브랜치 전략

| 브랜치 | 용도 |
|--------|------|
| `main` | 배포 브랜치 |
| `develop` | 통합 브랜치 |
| `feature/(#이슈번호)-설명` | 신규 기능 |
| `bugfix/(#이슈번호)-설명` | 버그 수정 |
| `refactor/(#이슈번호)-설명` | 리팩토링 |

## 네이밍 컨벤션

| 대상 | 패턴 | 예시 |
|------|------|------|
| UseCase protocol | `{Feature}UseCase` | `NoticeUseCase` |
| UseCase 구현체 | `Default{Feature}UseCase` | `DefaultNoticeUseCase` |
| Repository protocol | `{Feature}Repository` | `NoticeRepository` |
| Repository 구현체 | `{Feature}RepositoryImpl` | `NoticeRepositoryImpl` |
| Reactor | `{Feature}Reactor` | `NoticeDetailReactor` |
| ViewController | `{Feature}ViewController` | `NoticeDetailViewController` |
| Flow | `{Feature}Flow` | `NoticeDetailFlow` |
| Step | `{Feature}Step` | `NoticeDetailStep` |
