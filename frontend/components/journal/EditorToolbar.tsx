import { TouchableOpacity, View, StyleSheet } from 'react-native';
import { IconSymbol } from '@/components/ui/icon-symbol';
import { Colors } from '@/constants/theme';

interface EditorToolbarProps {
    onAIPolish: () => void;
    onInsertTemplate: (type: 'list' | 'task' | 'time') => void;
    onOpenCalendar: () => void;
    aiPolishing: boolean;
    tagsCount: number;
    theme: 'light' | 'dark';
    accentColor: string;
}

export function EditorToolbar({
    onAIPolish,
    onInsertTemplate,
    onOpenCalendar,
    aiPolishing,
    tagsCount,
    theme,
    accentColor,
}: EditorToolbarProps) {
    const c = Colors[theme];
    const mutedColor = c.icon;

    return (
        <View style={[styles.toolbar, { backgroundColor: theme === 'dark' ? '#1A1C1E' : '#F5F5F7', borderTopColor: mutedColor + '20' }]}>
            <ToolButton
                icon="sparkles"
                onPress={onAIPolish}
                disabled={aiPolishing}
                active={aiPolishing}
                color={aiPolishing ? accentColor : mutedColor}
            />
            <View style={[styles.divider, { backgroundColor: mutedColor + '33' }]} />

            {/* Tag manager shown separately */}

            <ToolButton
                icon="list-bullets"
                onPress={() => onInsertTemplate('list')}
                color={mutedColor}
            />
            <ToolButton
                icon="check-square"
                onPress={() => onInsertTemplate('task')}
                color={mutedColor}
            />
            <ToolButton
                icon="clock"
                onPress={() => onInsertTemplate('time')}
                color={mutedColor}
            />
            <ToolButton
                icon="calendar"
                onPress={onOpenCalendar}
                color={mutedColor}
            />
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
        paddingHorizontal: 16,
        paddingVertical: 12,
        borderTopWidth: StyleSheet.hairlineWidth,
        gap: 16,
    },
    toolBtn: {
        width: 36,
        height: 36,
        alignItems: 'center',
        justifyContent: 'center',
    },
    toolBtnDisabled: {
        opacity: 0.5,
    },
    divider: {
        width: StyleSheet.hairlineWidth,
        height: 24,
    },
});
