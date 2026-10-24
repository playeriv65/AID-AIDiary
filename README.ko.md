# AID Diary

[English](README.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | **한국어**

Flutter로 만든 Windows·Android용 개인 일기 앱입니다.

AID Diary는 Demizo 외 기여자들의 [Daily You](https://github.com/Demizo/Daily_You)(GPL-3.0)를 수정한 버전이며, Daily You 공식 앱이 **아닙니다**. 상위 버전과 라이선스는 [SOURCE.md](SOURCE.md)를 참고하세요.

최신 `main` 빌드는 [nightly 사전 릴리스](https://github.com/playeriv65/AID-AIDiary/releases/tag/nightly)에 있습니다(Android APK와 Windows ZIP). 디버그 키로 서명되어 새로 설치할 수는 있지만, 릴리스 키로 서명된 설치본을 업데이트할 수는 없습니다.

이 문서는 요약본입니다. 기능에 대한 자세한 설명은 [영어 README](README.md)가 기준이며, 개발 문서도 영어로 되어 있습니다.

## 스크린샷

| 태블릿 / PC | 휴대폰 |
|---|---|
| ![일기](artifacts/ui-tablet-journal.png) | ![일기](artifacts/ui-phone-journal.png) ![일기 보기](artifacts/ui-phone-entry.png) |
| ![캘린더](artifacts/ui-tablet-calendar.png) | ![캘린더](artifacts/ui-phone-calendar.png) ![미디어](artifacts/ui-phone-media.png) |
| ![편집기](artifacts/ui-tablet-editor.png) | ![편집기](artifacts/ui-phone-editor.png) ![검색](artifacts/ui-phone-search.png) |

## 주요 기능

- **일기**: 날짜별로 묶은 일기 카드(시간, 제목, 미리보기, 기분, 장소, 날씨, 태그). 위쪽에는 오늘, 지난 오늘, 랜덤 산책, 주간·연간 돌아보기 같은 스토리 카드가 있습니다.
- **일기 날짜**: 쓴 시각과 그 일기가 어느 날의 일기인지를 따로 기록합니다. 새벽에 쓴 일기는 기본적으로 전날로 셈하며, 쓴 시각은 그대로 두고 날짜만 언제든 바꿀 수 있습니다.
- **편집기**: 제목은 선택 사항입니다. Markdown, 사진, 동영상, 음성 메모, 손글씨를 지원하고 새 일기에는 장소와 날씨를 자동으로 채웁니다.
- **댓글과 인용**: 지난 일기에서 글을 선택하면 그 구절을 보관하거나 댓글을 달 수 있고, 일기 전체에 댓글을 달 수도 있습니다. 댓글은 오늘의 일기로 저장되며 답하는 원문을 인용합니다. 몇 줄짜리 짧은 댓글에서 전체 편집기로 펼칠 수 있습니다. 어떤 일기든 다른 일기를 인용할 수 있고, 일기 아래에는 그 일기에 답한 일기들이 표시됩니다.
- **캘린더**: 일기 화면에서 바로 펼쳐지며, 날짜를 누르면 목록이 그날로 이동합니다.
- **지도**: 장소가 있는 일기를 OpenStreetMap에 표시합니다. 일기가 여러 개인 지점을 열면 그 일기들의 목록이 나옵니다.
- **태그**: 새 일기장에는 태그가 없습니다. 순서는 길게 눌러 끌어서 정하고, 일기 카드에 태그 이름이 표시됩니다.
- **사진**: 기본적으로 원본을 저장합니다. 새 사진을 약 1 MB의 WebP로 저장하거나, 기존 사진을 한 번에 압축할 수도 있습니다(되돌릴 수 없음).
- **숨긴 일기**: 「설정 › 보안」에서 기기 인증 후 볼 수 있습니다. 일반 목록, 검색, 위젯, 내보내기에 나오지 않으며, 동기화된 다른 기기에서도 숨겨진 채로 유지됩니다.
- **동기화(선택)**: 항상 종단 간 암호화되며 일기용 계정이나 비밀번호가 없습니다. 내 Google Drive, WebDAV, 또는 `server/`의 AID 동기화 서버를 쓸 수 있고, 같은 네트워크의 기기끼리는 직접 전송합니다. 새 기기는 페어링 코드나 QR로 추가하며, 모든 기기를 잃어버렸을 때는 복구 코드로 되찾습니다.
- **가져오기 / 내보내기**: One Diary v3 백업, Journey, Day One, Daylio 등을 가져오고 JSON, Markdown, Journey와 Day One 형식, 전체 백업으로 내보낼 수 있습니다.
- **명령줄**: 앱의 모든 기능은 하나의 액션으로, 버튼, 명령 팔레트, `aid` 명령줄이 함께 씁니다. 스크립트나 AI 에이전트가 한 일이 바로 앱에 나타납니다.
- **Android 홈 화면 위젯**: 오늘 상태, 매일의 사진, 연속 기록, 글쓰기 제안, 빠른 기분 기록.

## 개인정보와 네트워크

일기, 사진, 좌표는 기기에 저장됩니다. 동기화를 켰을 때만 선택한 저장소와 신뢰한 기기로 암호화되어 전송됩니다. 다음 네트워크 사용은 모두 선택 사항이며, 주소는 [assets/config/app_config.json](assets/config/app_config.json)에서 설정합니다.

- OpenStreetMap 지도 타일과 Nominatim 장소 검색.
- 주변 장소를 찾는 Overpass(장소 선택기를 열 때).
- Open-Meteo 날씨(좌표와 날짜만 전송).
- Google Drive로 동기화할 때의 Google 로그인과 Drive API.

## 개발

주로 Windows에서 개발합니다. [문서 색인](docs/INDEX.md)과 [인수인계 문서](docs/HANDOFF.md)에서 시작하고, 새 컴퓨터의 도구 설정, 서명, 테스트 기기는 [설정 문서](docs/SETUP.md)를 참고하세요. 자주 쓰는 명령은 [영어 README](README.md#development)에 있습니다.

## 라이선스

GPL-3.0-only([LICENSE.txt](LICENSE.txt))이며, 추가 조건은 [ADDITIONAL_TERMS.md](ADDITIONAL_TERMS.md)를 참고하세요.
