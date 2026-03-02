import { StyleSheet, TouchableOpacity, View } from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';

interface EditorToolbarProps {
  onInsertTemplate: (type: 'list' | 'task' | 'time') => void;
  onOpenCalendar: () => void;
  tagsCount: number;
  theme: 'light' | 'dark';
  accentColor: string;
}

export function EditorToolbar({
  onInsertTemplate,
  onOpenCalendar,
  tagsCount,
  theme,
  accentColor,
}: EditorToolbarProps) {
  const c = Colors[theme];
  const mutedColor = c.icon;

  return (
    <View
      style={[
        styles.toolbar,
        {
          backgroundColor: theme === 'dark' ? '#1A1C1E' : '#F5F5F7',
          borderTopColor: mutedColor + '20',
        },
      ]}
    >
      {tagsCount > 0 && (
        <View style={{ flexDirection: 'row', marginRight: 8 }}>
          <IconSymbol name="tag" size={20} color={mutedColor} />
        </View>
      )}
      <View style={[styles.divider, { backgroundColor: mutedColor + '33' }]} />

      {/* Tag manager shown separately */}

      <ToolButton icon="list-bullets" onPress={() => onInsertTemplate('list')} color={mutedColor} />
      <ToolButton icon="check-square" onPress={() => onInsertTemplate('task')} color={mutedColor} />
      <ToolButton icon="clock" onPress={() => onInsertTemplate('time')} color={mutedColor} />
      <ToolButton icon="calendar" onPress={onOpenCalendar} color={mutedColor} />
    </View>
  );
}

interface ToolButtonProps {
  icon: string;
  onPress: () => void;
  disabled?: boolean;
  active?: boolean;
  color: string;
}

function ToolButton({ icon, onPress, disabled = false, active = false, color }: ToolButtonProps) {
  return (
    <TouchableOpacity
      style={[styles.toolBtn, disabled && styles.toolBtnDisabled]}
      onPress={onPress}
      disabled={disabled}
      activeOpacity={0.7}
    >
      <IconSymbol name={icon as any} size={20} color={color} weight={active ? 'fill' : 'regular'} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  toolbar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderTopWidth: StyleSheet.hairlineWidth,
    gap: 8,
  },
  toolBtn: {
    width: 40,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 8,
  },
  toolBtnDisabled: {
    opacity: 0.5,
  },
  divider: {
    width: StyleSheet.hairlineWidth,
    height: 20,
    marginHorizontal: 4,
  },
});
