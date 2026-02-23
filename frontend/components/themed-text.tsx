import { StyleSheet, Text, type TextProps } from 'react-native';

import { useThemeColor } from '@/hooks/use-theme-color';
import { FontSizes, FontWeights, LineHeights } from '@/constants/theme';

export type ThemedTextProps = TextProps & {
  lightColor?: string;
  darkColor?: string;
  type?: 'default' | 'title' | 'defaultSemiBold' | 'subtitle' | 'link';
};

export function ThemedText({
  style,
  lightColor,
  darkColor,
  type = 'default',
  ...rest
}: ThemedTextProps) {
  const color = useThemeColor({ light: lightColor, dark: darkColor }, 'text');

  return (
    <Text
      style={[
        { color },
        type === 'default' ? styles.default : undefined,
        type === 'title' ? styles.title : undefined,
        type === 'defaultSemiBold' ? styles.defaultSemiBold : undefined,
        type === 'subtitle' ? styles.subtitle : undefined,
        type === 'link' ? styles.link : undefined,
        style,
      ]}
      {...rest}
    />
  );
}

const styles = StyleSheet.create({
  default: {
    fontSize: FontSizes.md,
    lineHeight: FontSizes.md * LineHeights.relaxed,
    fontWeight: FontWeights.normal,
  },
  defaultSemiBold: {
    fontSize: FontSizes.md,
    lineHeight: FontSizes.md * LineHeights.relaxed,
    fontWeight: FontWeights.semibold,
  },
  title: {
    fontSize: FontSizes.xxxl,
    fontWeight: FontWeights.bold,
    lineHeight: FontSizes.xxxl * LineHeights.tight,
  },
  subtitle: {
    fontSize: FontSizes.xl,
    fontWeight: FontWeights.semibold,
    lineHeight: FontSizes.xl * LineHeights.normal,
  },
  link: {
    fontSize: FontSizes.md,
    lineHeight: FontSizes.md * LineHeights.relaxed,
    color: '#0a7ea4',
  },
});
