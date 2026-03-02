import React, { useMemo } from 'react';
import { Platform, StyleSheet, View } from 'react-native';
import Markdown from 'react-native-markdown-display';
import { LaTeXRenderer } from './LaTeXRenderer';
import { Colors, FontSizes, FontWeights } from '@/constants/theme';

interface MarkdownRendererProps {
  content: string;
  theme: 'light' | 'dark';
  accentColor?: string;
}

interface ContentPart {
  type: 'text' | 'latex-block' | 'latex-inline';
  content: string;
}

function parseContent(content: string): ContentPart[] {
  if (!content) return [];

  const parts: ContentPart[] = [];
  let lastIndex = 0;

  const regex = /(\$\$[\s\S]+?\$\$|\$[^$\n]+?\$)/g;
  let match;

  while ((match = regex.exec(content)) !== null) {
    if (match.index > lastIndex) {
      parts.push({
        type: 'text',
        content: content.slice(lastIndex, match.index),
      });
    }

    const latexFull = match[0];
    const isBlock = latexFull.startsWith('$$');
    const formula = isBlock ? latexFull.slice(2, -2).trim() : latexFull.slice(1, -1).trim();

    if (formula) {
      parts.push({
        type: isBlock ? 'latex-block' : 'latex-inline',
        content: formula,
      });
    }
    lastIndex = match.index + match[0].length;
  }

  if (lastIndex < content.length) {
    parts.push({
      type: 'text',
      content: content.slice(lastIndex),
    });
  }

  return parts;
}

function getMarkdownStyles(theme: 'light' | 'dark', accentColor: string) {
  const c = Colors[theme];
  const isDark = theme === 'dark';

  return {
    body: {
      color: c.text,
      fontSize: FontSizes.md,
      lineHeight: FontSizes.md * 1.6,
    },
    heading1: {
      color: c.text,
      fontSize: FontSizes.xxl,
      fontWeight: FontWeights.bold,
      marginTop: 16,
      marginBottom: 8,
    },
    heading2: {
      color: c.text,
      fontSize: FontSizes.xl,
      fontWeight: FontWeights.semibold,
      marginTop: 14,
      marginBottom: 6,
    },
    heading3: {
      color: c.text,
      fontSize: FontSizes.lg,
      fontWeight: FontWeights.semibold,
      marginTop: 12,
      marginBottom: 4,
    },
    paragraph: {
      color: c.text,
      fontSize: FontSizes.md,
      lineHeight: FontSizes.md * 1.6,
      marginVertical: 4,
    },
    strong: {
      fontWeight: FontWeights.bold,
    },
    em: {
      fontStyle: 'italic',
    },
    blockquote: {
      backgroundColor: isDark ? '#2A2C30' : '#F0F0F2',
      borderLeftWidth: 4,
      borderLeftColor: accentColor,
      paddingHorizontal: 12,
      paddingVertical: 8,
      marginVertical: 8,
    },
    code_inline: {
      backgroundColor: isDark ? '#2A2C30' : '#F0F0F2',
      color: accentColor,
      fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace',
      fontSize: FontSizes.sm,
      paddingHorizontal: 6,
      paddingVertical: 2,
      borderRadius: 4,
    },
    code_block: {
      backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5',
      color: c.text,
      fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace',
      fontSize: FontSizes.sm,
      padding: 12,
      borderRadius: 8,
      marginVertical: 8,
    },
    fence: {
      backgroundColor: isDark ? '#1E1E1E' : '#F5F5F5',
      color: c.text,
      fontFamily: Platform.OS === 'ios' ? 'Menlo' : 'monospace',
      fontSize: FontSizes.sm,
      padding: 12,
      borderRadius: 8,
      marginVertical: 8,
    },
    list_item: {
      color: c.text,
      fontSize: FontSizes.md,
      marginVertical: 2,
    },
    bullet_list: {
      marginVertical: 8,
    },
    ordered_list: {
      marginVertical: 8,
    },
    link: {
      color: accentColor,
      textDecorationLine: 'underline',
    },
    hr: {
      backgroundColor: c.border,
      height: 1,
      marginVertical: 16,
    },
    table: {
      borderWidth: 1,
      borderColor: c.border,
      marginVertical: 8,
    },
    th: {
      backgroundColor: isDark ? '#2A2C30' : '#F0F0F2',
      padding: 8,
      borderWidth: 1,
      borderColor: c.border,
    },
    td: {
      padding: 8,
      borderWidth: 1,
      borderColor: c.border,
    },
    tr: {
      borderWidth: 1,
      borderColor: c.border,
    },
  };
}

export function MarkdownRenderer({ content, theme, accentColor }: MarkdownRendererProps) {
  const parts = useMemo(() => {
    if (!content || content.trim() === '') {
      return [];
    }
    return parseContent(content);
  }, [content]);

  const markdownStyles = useMemo(
    () => getMarkdownStyles(theme, accentColor || Colors[theme].tint),
    [theme, accentColor]
  );

  if (parts.length === 0) {
    return null;
  }

  return (
    <View style={styles.container} selectable={true}>
      {parts.map((part, index) => {
        if (part.type === 'text') {
          return (
            <Markdown key={index} style={markdownStyles}>
              {part.content}
            </Markdown>
          );
        } else {
          return (
            <LaTeXRenderer
              key={index}
              formula={part.content}
              displayMode={part.type === 'latex-block'}
              theme={theme}
            />
          );
        }
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    width: '100%',
  },
});
