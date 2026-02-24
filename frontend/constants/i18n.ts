// ─── Internationalization ─────────────────────────────────────────────────────
import { zhCN } from 'date-fns/locale/zh-CN';
import { ja as jaLocale } from 'date-fns/locale/ja';
import { enUS } from 'date-fns/locale/en-US';
import type { Locale } from 'date-fns';

export type LangKey = 'zh' | 'en' | 'ja';

interface Translations {
    // TopNav
    appName: string;
    // Sidebar
    timeline: string;
    calendar: string;
    media: string;
    atlas: string;
    coach: string;
    chat: string;
    search: string;
    ai: string;
    settings: string;
    // Timeline
    entries: string;
    noEntries: string;
    newEntry: string;
    filter: string;
    filterByCategory: string;
    filterByWeather: string;
    all: string;
    clear: string;
    // Calendar
    sun: string; mon: string; tue: string; wed: string; thu: string; fri: string; sat: string;
    // Chat
    aiChat: string;
    aiWelcome: string;
    aiHint: string;
    chatPlaceholder: string;
    generateDiary: string;
    clearChat: string;
    confirm: string;
    // Write
    titlePlaceholder: string;
    contentPlaceholder: string;
    save: string;
    saving: string;
    aiPolish: string;
    selectWeather: string;
    setLocation: string;
    wordCount: string;
    setCategory: string;
    // Categories
    catWork: string;
    catLife: string;
    catStudy: string;
    catTravel: string;
    catHealth: string;
    catOther: string;
    // Weather
    weatherSunny: string;
    weatherCloudy: string;
    weatherRainy: string;
    weatherSnowy: string;
    weatherWindy: string;
    weatherFoggy: string;
    // Toolbar
    addTag: string;
    addList: string;
    addTask: string;
    insertTime: string;
    linkCalendar: string;
    // Settings
    appearance: string;
    colorScheme: string;
    dark: string;
    light: string;
    followSystem: string;
    themeColor: string;
    language: string;
    account: string;
    loginRegister: string;
    login: string;
    register: string;
    logout: string;
    registerAccount: string;
    username: string;
    password: string;
    hasAccount: string;
    noAccount: string;
    cancel: string;
    about: string;
    version: string;
    // Alerts
    success: string;
    error: string;
    hint: string;
    enterCredentials: string;
    registerSuccess: string;
    welcomeBack: string;
    authFailed: string;
    filteringSoon: string;
    backendOffline: string;
    uploadFailed: string;
}

const zh: Translations = {
    appName: 'AID',
    timeline: '时间线',
    chat: '聊天',
    calendar: '日历',
    media: '媒体',
    atlas: '地图',
    coach: '教练',
    search: '搜索',
    ai: 'AI 助手',
    settings: '设置',
    entries: '日记列表',
    noEntries: '暂无日记',
    newEntry: '新建',
    sun: '日', mon: '一', tue: '二', wed: '三', thu: '四', fri: '五', sat: '六',
    aiChat: 'AI 聊天',
    aiWelcome: '你好！我是你的日记助手',
    aiHint: '和我聊聊今天发生了什么，我可以帮你记录成日记',
    chatPlaceholder: '分享今天的故事...',
    generateDiary: '生成日记',
    clearChat: '清空对话',
    confirm: '确定',
    titlePlaceholder: '标题',
    contentPlaceholder: '记录今日...',
    save: '保存',
    saving: '保存中...',
    aiPolish: 'AI 润色',
    selectWeather: '选择天气',
    setLocation: '设置地点',
    wordCount: '字',
    setCategory: '设置分类',
    catWork: '工作',
    catLife: '生活',
    catStudy: '学习',
    catTravel: '旅行',
    catHealth: '健康',
    catOther: '其他',
    weatherSunny: '晴天',
    weatherCloudy: '多云',
    weatherRainy: '雨天',
    weatherSnowy: '雪天',
    weatherWindy: '大风',
    weatherFoggy: '雾霾',
    addTag: '添加标签',
    addList: '添加列表',
    addTask: '添加任务',
    insertTime: '插入时间',
    linkCalendar: '日历链接',
    appearance: '外观',
    colorScheme: '配色方案',
    dark: '深色',
    light: '浅色',
    followSystem: '跟随系统',
    themeColor: '主题色',
    language: '语言',
    account: '账号',
    loginRegister: '登录 / 注册',
    login: '登录',
    register: '注册',
    logout: '退出登录',
    registerAccount: '注册账号',
    username: '用户名',
    password: '密码',
    hasAccount: '已有账号？去登录',
    noAccount: '没有账号？立即注册',
    cancel: '取消',
    about: '关于',
    version: '版本',
    success: '成功',
    error: '错误',
    hint: '提示',
    enterCredentials: '请输入用户名和密码',
    registerSuccess: '注册成功！',
    welcomeBack: '欢迎回来',
    authFailed: '操作失败，请重试',
    filter: '筛选',
    filterByCategory: '按分类筛选',
    filterByWeather: '按天气筛选',
    all: '全部',
    clear: '清除',
    filteringSoon: '筛选功能即将推出！',
    backendOffline: '后端未连接，点击重试',
    uploadFailed: '图片上传失败',
};

const en: Translations = {
    appName: 'AID',
    timeline: 'Timeline',
    chat: 'Chat',
    calendar: 'Calendar',
    media: 'Media',
    atlas: 'Atlas',
    coach: 'Coach',
    search: 'Search',
    ai: 'AI Assistant',
    settings: 'Settings',
    entries: 'Entries',
    noEntries: 'No entries yet',
    newEntry: 'NEW',
    sun: 'Sun', mon: 'Mon', tue: 'Tue', wed: 'Wed', thu: 'Thu', fri: 'Fri', sat: 'Sat',
    aiChat: 'AI Chat',
    aiWelcome: 'Hello! I am your diary assistant',
    aiHint: 'Tell me about your day, and I can help you write it as a diary',
    chatPlaceholder: 'Share your story today...',
    generateDiary: 'Generate Diary',
    clearChat: 'Clear Chat',
    confirm: 'Confirm',
    titlePlaceholder: 'Title',
    contentPlaceholder: 'Record today...',
    save: 'Save',
    saving: 'Saving...',
    aiPolish: 'AI Polish',
    selectWeather: 'Weather',
    setLocation: 'Location',
    wordCount: 'words',
    setCategory: 'Category',
    catWork: 'Work',
    catLife: 'Life',
    catStudy: 'Study',
    catTravel: 'Travel',
    catHealth: 'Health',
    catOther: 'Other',
    weatherSunny: 'Sunny',
    weatherCloudy: 'Cloudy',
    weatherRainy: 'Rainy',
    weatherSnowy: 'Snowy',
    weatherWindy: 'Windy',
    weatherFoggy: 'Foggy',
    addTag: 'Add Tag',
    addList: 'Add List',
    addTask: 'Add Task',
    insertTime: 'Insert Time',
    linkCalendar: 'Calendar Link',
    appearance: 'Appearance',
    colorScheme: 'Color Scheme',
    dark: 'Dark',
    light: 'Light',
    followSystem: 'System',
    themeColor: 'Theme Color',
    language: 'Language',
    account: 'Account',
    loginRegister: 'Login / Register',
    login: 'Login',
    register: 'Register',
    logout: 'Log Out',
    registerAccount: 'Create Account',
    username: 'Username',
    password: 'Password',
    hasAccount: 'Already have an account? Login',
    noAccount: "Don't have an account? Register",
    cancel: 'Cancel',
    about: 'About',
    version: 'Version',
    success: 'Success',
    error: 'Error',
    hint: 'Hint',
    enterCredentials: 'Please enter username and password',
    registerSuccess: 'Account created!',
    welcomeBack: 'Welcome back',
    authFailed: 'Operation failed, please try again',
    filter: 'Filter',
    filterByCategory: 'Filter by category',
    filterByWeather: 'Filter by weather',
    all: 'All',
    clear: 'Clear',
    filteringSoon: 'Filtering feature coming soon!',
    backendOffline: 'Backend offline, tap to retry',
    uploadFailed: 'Image upload failed',
};

const ja: Translations = {
    appName: 'AID',
    timeline: 'タイムライン',
    chat: 'チャット',
    calendar: 'カレンダー',
    media: 'メディア',
    atlas: 'アトラス',
    coach: 'コーチ',
    search: '検索',
    ai: 'AI アシスタント',
    settings: '設定',
    entries: 'エントリー',
    noEntries: 'エントリーがありません',
    newEntry: '新規',
    sun: '日', mon: '月', tue: '火', wed: '水', thu: '木', fri: '金', sat: '土',
    aiChat: 'AI チャット',
    aiWelcome: 'こんにちは！あなたの日記アシスタントです',
    aiHint: '今日起きたことを教えてください。日記として帮助你記録します',
    chatPlaceholder: '今日の話をしよう...',
    generateDiary: '日記生成',
    clearChat: 'チャットクリア',
    confirm: '確認',
    titlePlaceholder: 'タイトル',
    contentPlaceholder: '今日を記録...',
    save: '保存',
    saving: '保存中...',
    aiPolish: 'AI 添削',
    selectWeather: '天気',
    setLocation: '場所',
    wordCount: '文字',
    setCategory: 'カテゴリ',
    catWork: '仕事',
    catLife: '生活',
    catStudy: '勉強',
    catTravel: '旅行',
    catHealth: '健康',
    catOther: 'その他',
    weatherSunny: '晴れ',
    weatherCloudy: '曇り',
    weatherRainy: '雨',
    weatherSnowy: '雪',
    weatherWindy: '風',
    weatherFoggy: '霧',
    addTag: 'タグ追加',
    addList: 'リスト追加',
    addTask: 'タスク追加',
    insertTime: '時間挿入',
    linkCalendar: 'カレンダー',
    appearance: '外観',
    colorScheme: '配色',
    dark: 'ダーク',
    light: 'ライト',
    followSystem: 'システム',
    themeColor: 'テーマカラー',
    language: '言語',
    account: 'アカウント',
    loginRegister: 'ログイン / 登録',
    login: 'ログイン',
    register: '登録',
    logout: 'ログアウト',
    registerAccount: 'アカウント作成',
    username: 'ユーザー名',
    password: 'パスワード',
    hasAccount: 'アカウントをお持ちですか？ログイン',
    noAccount: 'アカウントがありませんか？登録',
    cancel: 'キャンセル',
    about: 'その他',
    version: 'バージョン',
    success: '成功',
    error: 'エラー',
    hint: 'ヒント',
    enterCredentials: 'ユーザー名とパスワードを入力してください',
    registerSuccess: 'アカウント作成完了！',
    welcomeBack: 'おかえりなさい',
    authFailed: '操作に失敗しました。もう一度お試しください',
    filter: 'フィルター',
    filterByCategory: 'カテゴリー別',
    filterByWeather: '天気別',
    all: 'すべて',
    clear: 'クリア',
    filteringSoon: 'フィルタリング機能は近日公開予定です！',
    backendOffline: 'バックエンドがオフライン、タップして再試行',
    uploadFailed: '画像のアップロードに失敗しました',
};

const translations: Record<LangKey, Translations> = { zh, en, ja };

export function t(lang: string): Translations {
    return translations[lang as LangKey] || translations.zh;
}

const dateLocales: Record<LangKey, Locale> = { zh: zhCN, en: enUS, ja: jaLocale };

export function getDateLocale(lang: string): Locale {
    return dateLocales[lang as LangKey] || zhCN;
}
