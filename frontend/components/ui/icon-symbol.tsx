// Unified icon component using Phosphor Icons
// https://phosphoricons.com/

import {
  List,
  CaretLeft,
  CaretRight,
  X,
  XCircle,
  BookOpen,
  Calendar,
  CalendarPlus,
  MagnifyingGlass,
  Gear,
  Plus,
  Check,
  PaperPlaneTilt,
  Sparkle,
  BookmarkSimple,
  Sun,
  MapPin,
  TextAa,
  Hash,
  ListBullets,
  CheckSquare,
  Clock,
  House,
  ArrowClockwise,
  SlidersHorizontal,
  Funnel,
  User,
  Info,
  Cloud,
  CloudRain,
  CloudSnow,
  Wind,
  CloudFog,
  Briefcase,
  Heart,
  Airplane,
  Heartbeat,
  Folder,
  WifiSlash,
  ChatCircle,
  Note,
  Trash,
} from 'phosphor-react-native';
import { OpaqueColorValue, type StyleProp, type TextStyle } from 'react-native';

// Map our internal icon names to Phosphor components
const ICON_MAP: Record<string, any> = {
  // Navigation / Layout
  'list': List,
  'caret-left': CaretLeft,
  'caret-right': CaretRight,
  'x': X,
  'x-circle': XCircle,
  'house': House,
  // Sidebar
  'book-open': BookOpen,
  'calendar': Calendar,
  'calendar-plus': CalendarPlus,
  'magnifying-glass': MagnifyingGlass,
  'gear': Gear,
  // Actions
  'plus': Plus,
  'check': Check,
  'paper-plane': PaperPlaneTilt,
  'sparkle': Sparkle,
  'bookmark': BookmarkSimple,
  // Weather
  'sun': Sun,
  'cloud': Cloud,
  'cloud-rain': CloudRain,
  'snowflake': CloudSnow,
  'wind': Wind,
  'fog': CloudFog,
  // Write page
  'map-pin': MapPin,
  'text-aa': TextAa,
  'hash': Hash,
  'list-bullets': ListBullets,
  'check-square': CheckSquare,
  'clock': Clock,
  // Utilities
  'arrow-clockwise': ArrowClockwise,
  'sliders': SlidersHorizontal,
  'funnel': Funnel,
  'wifi-slash': WifiSlash,
  'user': User,
  'info': Info,
  // Categories
  'briefcase': Briefcase,
  'heart': Heart,
  'airplane': Airplane,
  'heartbeat': Heartbeat,
  'folder': Folder,
  // Chat
  'chat-circle': ChatCircle,
  'note': Note,
  'trash': Trash,
};

export type PhosphorIconName = keyof typeof ICON_MAP;

export function IconSymbol({
  name,
  size = 24,
  color,
  style,
  weight = 'regular',
}: {
  name: string;
  size?: number;
  color: string | OpaqueColorValue;
  style?: StyleProp<TextStyle>;
  weight?: 'thin' | 'light' | 'regular' | 'bold' | 'fill' | 'duotone';
}) {
  const IconComponent = ICON_MAP[name];
  if (!IconComponent) {
    console.warn(`[IconSymbol] Unknown icon: "${name}"`);
    return null;
  }
  return <IconComponent size={size} color={color as string} weight={weight} style={style} />;
}
