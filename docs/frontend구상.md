Local Bridge 프론트엔드 설계안
컴포넌트 아키텍처 · 화면 사양 · React Native 구현 예시
EQ LAB · 2026.7 · 모바일 화면 목업(7종)은 별도 시각자료로 제공
본 문서는 하단 탭 4개(백과사전 · AI가이드 · 근무기록/네비게이터 · 설정) 구조의 프론트엔드를 실제 개발 착수 가능한 수준으로 구체화한 것이다. 컬러 시스템은 Primary #1E40AF(Trust Blue), Secondary #0D9488(Safety Teal), Accent #D97706(Amber Orange), Background #F8FAFC(Clean Slate)를 기준으로 한다. 모듈 1은 MVP 범위인 카테고리 1(ARC 발급)·3(통신 개통)만 완성도 있게 구현하고 나머지 18개는 스켈레톤으로 노출한다.

1. 전체 앱 컴포넌트 트리 및 네비게이션 구조도
react-navigation 기준 Native Stack + Bottom Tab 조합을 사용한다. 각 탭은 독립된 Stack Navigator를 가져 탭 전환 시에도 화면 히스토리가 유지된다.

App
 └─ AuthGate (스플래시 · 로그인 상태 확인)
     └─ RootStack (Native Stack Navigator)
         ├─ Onboarding (최초 1회: 언어선택 → 비자정보 입력)
         └─ MainTabs (Bottom Tab Navigator · 4 tabs)
             │
             ├─ EncyclopediaStack  [Tab 1· 백과사전]
             │   ├─ EncyclopediaHome
             │   │   ├─ SearchBar
             │   │   ├─ VisaDdayCarousel
             │   │   └─ CategoryGroupList (그룹 A~D)
             │   │       └─ CategoryIconChip × 20
             │   └─ CategoryDetail (:categoryId)
             │       ├─ StepCard ①~⑤        (MVP: ARC 발급형)
             │       └─ ComparisonTable+FilterPill (MVP: 통신 개통형)
             │
             ├─ AIGuideStack  [Tab 2· AI가이드]
             │   └─ ChatScreen
             │       ├─ MessageList
             │       │   ├─ UserBubble
             │       │   └─ AIResponseCard (FactAnswer / RiskNotice / RoutingCTA)
             │       ├─ RecommendedOrgCard  (모든 응답 하단 고정)
             │       └─ ChatInputBar
             │
             ├─ WorkLogStack  [Tab 3· 근무기록·네비게이터]
             │   ├─ DailyHookHome
             │   │   ├─ TimePickerRow (출근/퇴근)
             │   │   ├─ WorkTypeChipSelector
             │   │   ├─ PhotoAttachButton
             │   │   ├─ IncidentCheckbox (정상/연장/사고·부상)
             │   │   └─ NavigatorSwitcher (임금체불 ⇄ 산재)
             │   ├─ WageNavigatorFlow (5단계)
             │   │   ├─ Step1_TypeSelect
             │   │   ├─ Step2_ProcedureGuide
             │   │   ├─ Step3_FactInput (정형입력+5W1H+증빙첨부)
             │   │   ├─ Step4_DocumentMapping
             │   │   │   └─ DocumentMappingRow × n
             │   │   └─ Step5_OrgRouting (지도/목록)
             │   └─ AccidentNavigatorFlow (5단계 · 동일 패턴)
             │
             └─ SettingsStack  [Tab 4· 설정]
                 ├─ LanguageSetting
                 ├─ VisaInfoSetting
                 ├─ ProfileSetting
                 └─ NotificationSetting
 
공용 컴포넌트  components/common/
 ├─ BottomTabBar     커스텀 탭바 (4아이콘 · active 색상 Primary)
 ├─ StepIndicator    5-dot 진행바 (done=Teal, now=Amber, upcoming=Gray)
 ├─ Card / Pill / Chip
 └─ DisclaimerBanner 고지문 전용 배너 (Amber 배경 고정)


 
2. 4개 탭별 상세 화면 UI/UX 사양
각 화면의 실제 비주얼 목업은 별도 이미지 자료(7종)로 제공했다. 본 표는 화면별 목적·핵심 컴포넌트·상태값·인터랙션을 개발 기준으로 정리한 것이다.
가. Tab 1 — 백과사전 (모듈 1)
화면	목적	핵심 컴포넌트	상태(state) / 인터랙션
EncyclopediaHome	20개 카테고리 진입점, 비자 만료 알림	SearchBar, VisaDdayCarousel, CategoryGroupList	categories[], visaExpiryDate · 카테고리 탭→상세 이동, 검색어 입력 시 실시간 필터링
CategoryDetail (ARC발급)	MVP 카테고리1 — 5단 카드+체크리스트	StepCard×5, ChecklistCard	checklist[] · 체크박스 토글 시 진행률 갱신, 캡처 썸네일 탭 시 확대뷰
CategoryDetail (통신개통)	MVP 카테고리3 — 비교표+필터	FilterPill, ComparisonTable, MiniStepper	arcOwned:boolean · 필터 전환 시 표 데이터 재필터링
기타 18개 카테고리	2차 확장 대상	SkeletonCard / AccordionRow	카테고리명·아이콘만 노출, 탭 시 “준비 중” 안내

나. Tab 2 — AI 가이드 (모듈 2 챗봇)
화면	목적	핵심 컴포넌트	상태(state) / 인터랙션
ChatScreen	라이트 라우팅 기반 안내 챗봇	MessageList, AIResponseCard, RecommendedOrgCard, ChatInputBar	messages[], userLocation · 메시지 전송 시 응답 생성, 응답마다 RecommendedOrgCard 자동 첨부(3항 상세)

다. Tab 3 — 근무기록 & 대응 네비게이터 (모듈 3)
화면	목적	핵심 컴포넌트	상태(state) / 인터랙션
DailyHookHome	일일 근무기록(데일리 훅)	TimePickerRow, WorkTypeChipSelector, IncidentCheckbox, NavigatorSwitcher	clockIn, clockOut, workType, incident · incident=‘사고·부상’ 선택 시 AccidentNavigatorFlow로 자동 전환(사실값 프리필)
WageNavigatorFlow	임금체불 대응 5단계	StepIndicator + 단계별 화면(4항 상세)	currentStep, factData · 3단계 완료 시 근무기록장 데이터 자동 프리필
AccidentNavigatorFlow	산재 대응 5단계	WageNavigatorFlow와 동일 패턴(유형 6지·서식만 상이)	currentStep, factData

라. Tab 4 — 설정
화면	목적	핵심 컴포넌트	상태(state) / 인터랙션
SettingsHome	언어·비자·회원정보 관리	ListRow × 4	language, visaType, visaExpiry · 각 행 탭 시 서브 화면으로 이동

 
3. 모듈 2(챗봇) 인터랙션 레이아웃 사양
AI 응답은 하나의 통일된 데이터 모델을 거쳐 렌더링된다. 이 구조 덕분에 ‘사실 기반 답변 제공’과 ‘라이트 라우팅’, ‘맞춤 기관 카드’ 세 가지가 항상 함께 작동한다.

type AIResponse = {
  factAnswer: string | null      // 검수 DB에 있는 사실 정보 (없으면 null)
  riskNotice: string | null      // 법률판단 필요 시 완곡 안내 문구
  routingTarget:
    | { module: "module1"; categoryId: string }
    | { module: "module3-wage" | "module3-accident" }
    | null
  recommendedOrgs: Org[]         // 모든 응답에 공통 계산되어 항상 표시
}

가. 렌더링 규칙
•	factAnswer가 있으면 AIResponseCard(단문 카드)로 즉시 노출한다.
•	법률적 판단이 필요한 질문(체불액 산정, 산재 인정 여부 등)은 riskNotice + RoutingCTA 버튼으로 전환한다. 기존 “대답할 수 없습니다” 대신, 문제를 인지했다는 신호와 다음 행동을 함께 제시하는 완곡한 문구로 교체한다.
•	recommendedOrgs는 질문 내용과 무관하게 이용자 위치·질문 키워드를 기준으로 항상 계산되어, 모든 응답 하단에 고정 카드로 렌더링된다. 즉 ‘응답을 못 할 때만’이 아니라 ‘응답할 때마다 매번’ 노출되는 구조다.

나. 문구 뱅크 — 기존 표현 개선
상황	기존 표현(지양)	개선 표현(적용)
법률판단 필요	“대답할 수 없습니다.”	“정확한 판단이 필요한 사안이에요. 오안내 위험이 있어 AI가 직접 답하지 않고, 실제 검토가 가능한 곳으로 안내해 드릴게요.”
긴급 대응 필요	(안내 없음)	“즉시 대응이 필요해 보여요. [임금체불 대응 네비게이터]로 바로 이동하시겠어요?”
모듈1 정보로 충분	(라우팅 없이 텍스트만 답변)	“관련 정보를 정리해 뒀어요 — [모듈 1: 근로계약서 체크리스트]에서 자세히 확인할 수 있어요.”

 
4. 모듈 3 핵심 화면 사양
가. 데일리 훅 입력 UI
필드	컴포넌트	인터랙션
출근·퇴근 시각	TimePickerRow (스크롤 휠 picker)	선택 즉시 실근무시간 자동 계산·표시
실근무시간	텍스트 표시(읽기전용)	휴게시간 입력 시 자동 차감 반영
업무 내용	WorkTypeChipSelector	칩 단일 선택, 직접 입력 없음
현장 사진	PhotoAttachButton	촬영/첨부 시 타임스탬프 자동 삽입
특이사항	IncidentCheckbox (3지 선택)	‘사고·부상’ 선택 시 AccidentNavigatorFlow로 즉시 전환, 근무일자·사업장정보 사전 전달

나. 고용노동부 진정서 1:1 데이터 매핑 시각화 화면
4단계 화면의 핵심은 ‘내가 입력한 값이 실제 서식 어디에 들어가는지’를 이용자가 눈으로 확인할 수 있게 하는 것이다. DocumentMappingRow 컴포넌트가 좌측에 서식 필드명을, 우측에 매핑된 값을 화살표 아이콘과 함께 보여준다.
status	시각 표현	적용 필드 예시
auto (사실형)	값이 Primary Blue 텍스트 + 화살표 아이콘으로 강조 표시	성명, 사업장명, 근무기간, 미지급액(단순 차액)
verbatim (원문출력)	회색 박스 안에 이용자가 입력한 문장을 그대로 표시 + 상단 고지 라벨	진정 취지 및 체불 경위(5W1H)
blocked (공란+안내)	필드를 비워두고 Amber 안내 문구를 그 자리에 노출	통상임금·시간외수당 등 복잡 산정 항목

 
5. React Native / NativeWind(Tailwind) 핵심 컴포넌트 코드 예시
NativeWind(className 기반 Tailwind)를 기준으로 작성했다. 색상은 tailwind.config에 brand 팔레트로 등록해 사용한다.

// tailwind.config.js (발췌)
theme: {
  extend: {
    colors: {
      brand: {
        primary: "#1E40AF",   // Trust Blue
        secondary: "#0D9488", // Safety Teal
        accent: "#D97706",    // Amber Orange
        bg: "#F8FAFC",        // Clean Slate
      },
    },
  },
}

가. BottomTabBar.tsx

import { View, Pressable, Text } from "react-native"
import { Icon } from "@/components/common/Icon"
 
const TABS = [
  { key: "encyclopedia", label: "백과사전", icon: "book-2" },
  { key: "aiguide",      label: "AI가이드", icon: "message-chatbot" },
  { key: "worklog",      label: "근무기록", icon: "clock" },
  { key: "settings",     label: "설정",     icon: "settings" },
] as const
 
export function BottomTabBar({ active, onChange }: {
  active: string
  onChange: (key: string) => void
}) {
  return (
    <View className="flex-row border-t border-slate-200 bg-white">
      {TABS.map((tab) => {
        const isActive = active === tab.key
        return (
          <Pressable
            key={tab.key}
            onPress={() => onChange(tab.key)}
            className="flex-1 items-center gap-0.5 py-2 pb-3"
          >
            <Icon name={tab.icon} size={20} color={isActive ? "#1E40AF" : "#94A3B8"} />
            <Text className={`text-[10px] ${isActive ? "text-brand-primary" : "text-slate-400"}`}>
              {tab.label}
            </Text>
          </Pressable>
        )
      })}
    </View>
  )
}

나. CategoryStepCard.tsx (모듈 1 · 5단 카드)

export function CategoryStepCard({ index, title, body }: {
  index: number
  title: string
  body: string
}) {
  return (
    <View className="bg-white border border-slate-200 rounded-xl p-3 mb-2">
      <View className="self-start bg-blue-50 rounded-full px-2.5 py-1 mb-1.5">
        <Text className="text-[11px] font-medium text-blue-800">
          {["①", "②", "③", "④", "⑤"][index]} {title}
        </Text>
      </View>
      <Text className="text-[13px] text-slate-700">{body}</Text>
    </View>
  )
}

다. ChatMessage + RecommendedOrgCard.tsx (모듈 2)

export function AIResponseCard({ response }: { response: AIResponse }) {
  return (
    <View className="gap-2 mb-2">
      {response.factAnswer && (
        <View className="bg-white border border-slate-200 rounded-xl rounded-bl-sm p-3">
          <Text className="text-[13px] text-slate-700">{response.factAnswer}</Text>
        </View>
      )}
      {response.riskNotice && (
        <View className="bg-amber-50 border border-amber-200 rounded-xl p-3 flex-row gap-2">
          <Icon name="alert-triangle" size={16} color="#854F0B" />
          <Text className="text-[11px] text-amber-900 flex-1">{response.riskNotice}</Text>
        </View>
      )}
      {response.routingTarget && (
        <Pressable className="bg-brand-secondary rounded-xl p-2.5 flex-row items-center justify-center gap-1.5">
          <Text className="text-white text-[12px] font-medium">
            {routingLabel(response.routingTarget)}
          </Text>
          <Icon name="arrow-right" size={14} color="#fff" />
        </Pressable>
      )}
      <RecommendedOrgCard orgs={response.recommendedOrgs} />
    </View>
  )
}
 
export function RecommendedOrgCard({ orgs }: { orgs: Org[] }) {
  return (
    <View className="bg-blue-50 border border-blue-200 rounded-xl p-3">
      <Text className="text-[10px] text-blue-800 font-medium mb-1.5">
        내 위치 기반 추천 기관
      </Text>
      {orgs.map((org) => (
        <View key={org.id} className="flex-row justify-between py-1">
          <Text className="text-[12px] text-slate-800">{org.name}</Text>
          <Text className="text-[11px] text-slate-400">{org.distanceKm}km</Text>
        </View>
      ))}
    </View>
  )
}

라. DocumentMappingRow.tsx (모듈 3 · 4단계 매핑 시각화)

type MappingStatus = "auto" | "verbatim" | "blocked"
 
export function DocumentMappingRow({ label, value, status, notice }: {
  label: string
  value?: string
  status: MappingStatus
  notice?: string
}) {
  if (status === "blocked") {
    return (
      <View className="bg-amber-50 border border-amber-200 rounded-lg p-2.5 mb-1.5">
        <Text className="text-[10px] text-amber-900">{notice}</Text>
      </View>
    )
  }
  if (status === "verbatim") {
    return (
      <View className="bg-slate-50 border border-slate-200 rounded-lg p-2.5 mb-1.5">
        <Text className="text-[10px] text-slate-400 mb-1">{label} (원문 그대로 출력)</Text>
        <Text className="text-[12px] text-slate-700">{value}</Text>
      </View>
    )
  }
  return (
    <View className="flex-row justify-between items-center py-1.5 border-b border-slate-100">
      <Text className="text-[12px] text-slate-500">{label}</Text>
      <View className="flex-row items-center gap-1">
        <Text className="text-[12px] font-medium text-blue-800">{value}</Text>
        <Icon name="arrow-right" size={12} color="#0C447C" />
      </View>
    </View>
  )
}

마. StepIndicator.tsx (임금체불·산재 공통 5단계)

export function StepIndicator({ total = 5, current }: {
  total?: number
  current: number
}) {
  return (
    <View className="flex-row items-center mb-2.5">
      {Array.from({ length: total }).map((_, i) => {
        const step = i + 1
        const state = step < current ? "done" : step === current ? "now" : "upcoming"
        return (
          <View key={step} className="flex-row items-center flex-1">
            <View
              className={`w-5.5 h-5.5 rounded-full items-center justify-center ${
                state === "done" ? "bg-brand-secondary" :
                state === "now" ? "bg-brand-accent" : "bg-slate-200"
              }`}
            >
              <Text className={`text-[10px] font-medium ${state === "upcoming" ? "text-slate-400" : "text-white"}`}>
                {state === "done" ? "✓" : step}
              </Text>
            </View>
            {step < total && <View className="flex-1 h-0.5 bg-slate-200" />}
          </View>
        )
      })}
    </View>
  )
}


 

 

 
  
