import { Platform } from 'react-native'

export const IS_IOS = Platform.OS === 'ios'
export const IS_ANDROID = Platform.OS === 'android'

export const LOCALIZED_LANGUAGES = [
  {
    key: 'system',
    label: 'System 🌐',
  },
  {
    key: 'vi',
    label: 'Tiếng Việt 🇻🇳',
  },
  {
    key: 'zh-Hans',
    label: '简体中文 🇨🇳',
  },
  {
    key: 'zh-Hant',
    label: '繁體中文 🇹🇼',
  },
  {
    key: 'ja',
    label: '日本語 🇯🇵',
  },
  {
    key: 'ko',
    label: '한국어 🇰🇷',
  },
  {
    key: 'en',
    label: 'English 🇺🇸',
  },
  {
    key: 'ru',
    label: 'Русский 🇷🇺',
  },
  {
    key: 'de',
    label: 'Deutsch 🇩🇪',
  },
  {
    key: 'fr',
    label: 'Français 🇫🇷',
  },
  {
    key: 'ar',
    label: 'العربية 🇸🇦',
  },

  ...(IS_IOS
    ? [
        {
          key: 'th',
          label: 'ไทย 🇹🇭',
        },
        {
          key: 'id',
          label: 'Bahasa Indonesia 🇮🇩',
        },
      ]
    : []),
]
