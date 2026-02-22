import { Slot } from 'expo-router';
import { View, StyleSheet, useWindowDimensions } from 'react-native';
import { Sidebar } from '@/components/Sidebar';
import { TopNav } from '@/components/TopNav';
import { Colors } from '@/constants/theme';
import { useAppContext } from '@/context/AppContext';

export default function AppLayout() {
  const { resolvedTheme } = useAppContext();
  const { width } = useWindowDimensions();

  // Only show sidebar if width > 768px (Desktop/Tablet)
  const isLargeScreen = width > 768;

  return (
    <View style={[styles.container, { backgroundColor: Colors[resolvedTheme].background }]}>
      {isLargeScreen && <Sidebar />}

      <View style={styles.mainContent}>
        <TopNav />
        <View style={styles.contentArea}>
          <Slot />
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'row',
  },
  mainContent: {
    flex: 1,
    flexDirection: 'column',
  },
  contentArea: {
    flex: 1,
    position: 'relative',
  }
});

