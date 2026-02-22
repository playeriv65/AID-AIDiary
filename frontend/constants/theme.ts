/**
 * Below are the colors that are used in the app. The colors are defined in the light and dark mode.
 * There are many other ways to style your app. For example, [Nativewind](https://www.nativewind.dev/), [Tamagui](https://tamagui.dev/), [unistyles](https://reactnativeunistyles.vercel.app), etc.
 */

import { Platform } from 'react-native';

const tintColorLight = '#0a7ea4';
const tintColorDark = '#fff';

export const Colors = {
  light: {
    text: '#1A1C1E',
    background: '#F5F5F7',
    sidebar: '#EBEBED',
    sidebarActive: '#D8D8DC',
    cardBackground: '#FFFFFF',
    topNav: '#E8E8EA',
    tint: '#02BFB8',
    icon: '#6B7180',
    tabIconDefault: '#6B7180',
    tabIconSelected: '#02BFB8',
  },
  dark: {
    text: '#DFE1E3',
    background: '#181A1B',
    sidebar: '#121415',
    sidebarActive: '#282A2C',
    cardBackground: '#212325',
    topNav: '#151718',
    tint: '#02BFB8',
    icon: '#8A8D91',
    tabIconDefault: '#8A8D91',
    tabIconSelected: '#02BFB8',
  },
};

export const Fonts = Platform.select({
  ios: {
    /** iOS `UIFontDescriptorSystemDesignDefault` */
    sans: 'system-ui',
    /** iOS `UIFontDescriptorSystemDesignSerif` */
    serif: 'ui-serif',
    /** iOS `UIFontDescriptorSystemDesignRounded` */
    rounded: 'ui-rounded',
    /** iOS `UIFontDescriptorSystemDesignMonospaced` */
    mono: 'ui-monospace',
  },
  default: {
    sans: 'normal',
    serif: 'serif',
    rounded: 'normal',
    mono: 'monospace',
  },
  web: {
    sans: "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif",
    serif: "Georgia, 'Times New Roman', serif",
    rounded: "'SF Pro Rounded', 'Hiragino Maru Gothic ProN', Meiryo, 'MS PGothic', sans-serif",
    mono: "SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace",
  },
});
