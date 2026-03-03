import {
  ActivityIndicator,
  Platform,
  ScrollView,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import { useCallback, useEffect, useMemo } from 'react';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { format, parseISO } from 'date-fns';
import { getDateLocale } from '@/constants/i18n';

import { ThemedText } from '@/components/themed-text';
import { ThemedView } from '@/components/themed-view';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors, FontSizes, FontWeights, Spacing } from '@/constants/theme';
import { CONFIG } from '@/constants/config';
import { useAppContext } from '@/context/AppContext';

import { useJournalEntry } from '../../hooks/use-journal-entry';
import { TagManager } from '@/components/journal/TagManager';
import { EntryMetadata } from '@/components/journal/EntryMetadata';
import { EditorToolbar } from '@/components/journal/EditorToolbar';
import { ImageUploadPreview } from '@/components/journal/ImageUploadPreview';

// 全局 CSS 注入：移除输入框 focus 高亮
const globalStyles = `
  textarea, input {
    box-shadow: none !important;
    -webkit-box-shadow: none !important;
    -moz-box-shadow: none !important;
  }
  textarea:focus, input:focus {
    box-shadow: none !important;
    -webkit-box-shadow: none !important;
    -moz-box-shadow: none !important;
    border-color: transparent !important;
  }
`;

export default function WriteEntryScreen() {
  const params = useLocalSearchParams<{
    id?: string;
  }>();

  const router = useRouter();
  const { resolvedTheme, accentColor, i18n } = useAppContext();
  const theme = resolvedTheme;
  const dateLocale = getDateLocale(i18n.language);

  const safeGoBack = useCallback(() => {
    if (router.canGoBack()) {
      router.back();
    } else {
      router.replace('/');
    }
  }, [router]);

  const {
    title,
    content,
    category,
    weather,
    location,
    tags,
    image,
    saving,
    uploading,
    loading,
    createdAt,
    wordCount,
    categoryOptions,
    weatherOptions,
    setTitle,
    setContent,
    setCategory,
    setWeather,
    setLocation,
    setTags,
    setImage,
    handleSave,
    handleImageUpload,
    insertTemplate,
  } = useJournalEntry({
    entryId: params.id,
    onSuccess: safeGoBack,
  });

  const entryDate = useMemo(() => {
    if (createdAt) {
      return parseISO(createdAt);
    }
    return new Date();
  }, [createdAt]);

  const dateStr = useMemo(
    () => format(entryDate, 'MM月dd日 HH:mm', { locale: dateLocale }),
    [entryDate, dateLocale]
  );

  const c = Colors[theme];
  const mutedColor = c.icon;

  const handleOpenCalendar = () => {
    router.push('/calendar');
  };

  // 注入全局 CSS：移除输入框 focus 高亮
  useEffect(() => {
    if (Platform.OS === 'web') {
      const style = document.createElement('style');
      style.textContent = globalStyles;
      style.id = 'write-page-styles';
      if (!document.getElementById('write-page-styles')) {
        document.head.appendChild(style);
      }
      return () => {
        const existing = document.getElementById('write-page-styles');
        if (existing) {
          document.head.removeChild(existing);
        }
      };
    }
  }, []);

  if (loading) {
    return (
      <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color={accentColor} />
        </View>
      </ThemedView>
    );
  }

  return (
    <ThemedView style={[styles.container, { backgroundColor: c.background }]}>
      {/* 顶部导航栏 - 简洁 */}
      <View
        style={[styles.topBar, { borderBottomColor: theme === 'dark' ? '#1A1C1E' : '#E8E8EA' }]}
      >
        <TouchableOpacity onPress={safeGoBack} style={styles.backBtn} activeOpacity={0.7}>
          <IconSymbol name="caret-left" size={18} color={c.text} />
        </TouchableOpacity>

        <View style={styles.topBarCenter}>
          <ThemedText style={[styles.dateLabel, { color: mutedColor }]}>{dateStr}</ThemedText>
        </View>

        <TouchableOpacity
          style={[
            styles.saveCircle,
            { backgroundColor: saving ? Colors[theme].icon : accentColor },
          ]}
          onPress={handleSave}
          disabled={saving}
          activeOpacity={0.8}
        >
          {saving ? (
            <ActivityIndicator size="small" color="#000" />
          ) : (
            <IconSymbol name="check" size={20} color="#000" weight="bold" />
          )}
        </TouchableOpacity>
      </View>

      {/* 主编辑区域 */}
      <View style={styles.editorArea}>
        <ScrollView
          style={styles.scrollContent}
          contentContainerStyle={styles.scrollInner}
          keyboardDismissMode="interactive"
          showsVerticalScrollIndicator={false}
        >
          {/* 标题输入 */}
          <TextInput
            style={[styles.titleInput, { color: c.text }]}
            placeholder={i18n.titlePlaceholder}
            placeholderTextColor={mutedColor + '60'}
            value={title}
            onChangeText={setTitle}
            textAlign="left"
          />

          {/* 元数据行 - 放在标题下方 */}
          <EntryMetadata
            category={category}
            weather={weather}
            location={location}
            categoryOptions={categoryOptions}
            weatherOptions={weatherOptions}
            onCategoryChange={setCategory}
            onWeatherChange={setWeather}
            onLocationChange={setLocation}
            theme={theme}
            accentColor={accentColor}
            i18n={i18n}
          />

          {/* 正文输入 */}
          <TextInput
            style={[styles.contentInput, { color: c.text }]}
            placeholder={i18n.contentPlaceholder}
            placeholderTextColor={mutedColor + '50'}
            multiline
            textAlignVertical="top"
            value={content}
            onChangeText={setContent}
            autoFocus={!params.id}
          />

          {/* 图片预览 */}
          <ImageUploadPreview
            image={image}
            uploading={uploading}
            onUpload={handleImageUpload}
            onRemove={() => setImage(null)}
            theme={theme}
            accentColor={accentColor}
            apiStaticUrl={CONFIG.STATIC_URL}
          />

          {/* 标签管理 */}
          <TagManager
            tags={tags}
            onTagsChange={setTags}
            theme={theme}
            accentColor={accentColor}
            i18n={i18n}
          />

          {/* 字数统计 */}
          <View style={styles.wordCountRow}>
            <IconSymbol name="text-aa" size={14} color={mutedColor} />
            <ThemedText style={[styles.wordCountText, { color: mutedColor }]}>
              {wordCount} {i18n.wordCount}
            </ThemedText>
          </View>
        </ScrollView>
      </View>

      {/* 底部工具栏 */}
      <EditorToolbar
        onInsertTemplate={insertTemplate}
        onOpenCalendar={handleOpenCalendar}
        tagsCount={tags.length}
        theme={theme}
        accentColor={accentColor}
      />
    </ThemedView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  topBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingTop: Platform.OS === 'web' ? 16 : 56,
    paddingBottom: 12,
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
  backBtn: {
    width: 40,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },
  topBarCenter: {
    flex: 1,
    alignItems: 'center',
  },
  dateLabel: {
    fontSize: FontSizes.sm,
    fontWeight: FontWeights.medium,
  },
  saveCircle: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  editorArea: {
    flex: 1,
  },
  scrollContent: {
    flex: 1,
  },
  scrollInner: {
    paddingHorizontal: Spacing.contentHorizontal,
    paddingTop: 32,
    paddingBottom: 24,
  },
  titleInput: {
    fontSize: FontSizes.xxxl,
    fontWeight: FontWeights.bold,
    marginBottom: 16,
    textAlign: 'left',
    lineHeight: FontSizes.xxxl * 1.2,
    padding: 0,
    borderWidth: 0,
    outline: 'none',
  },
  contentInput: {
    fontSize: FontSizes.lg,
    lineHeight: FontSizes.lg * 1.75,
    fontWeight: FontWeights.normal,
    minHeight: 200,
    marginTop: 8,
    padding: 0,
    borderWidth: 0,
    outline: 'none',
  },
  wordCountRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginTop: 24,
    paddingTop: 16,
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: 'rgba(150, 150, 150, 0.2)',
  },
  wordCountText: {
    fontSize: FontSizes.sm,
  },
});
