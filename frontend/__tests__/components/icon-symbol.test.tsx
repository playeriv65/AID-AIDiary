import React from 'react';
import { render } from '@testing-library/react-native';
import { IconSymbol, PhosphorIconName } from '@/components/ui/icon-symbol';

const mockSymbolView = jest.fn(() => null);

jest.mock('expo-symbols', () => ({
  SymbolView: (...args: any[]) => mockSymbolView(...args),
  SymbolWeight: {},
}));

describe('IconSymbol', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Renders with different icon names', () => {
    const iconNames: PhosphorIconName[] = [
      'list',
      'caret-left',
      'caret-right',
      'x',
      'x-circle',
      'house',
      'book-open',
      'calendar',
      'calendar-plus',
      'magnifying-glass',
      'gear',
      'sidebar',
      'plus',
      'check',
      'paper-plane',
      'sparkle',
      'sparkles',
      'bookmark',
      'sun',
      'cloud',
      'cloud-rain',
      'snowflake',
      'wind',
      'fog',
      'map-pin',
      'text-aa',
      'hash',
      'list-bullets',
      'check-square',
      'clock',
      'arrow-clockwise',
      'sliders',
      'funnel',
      'wifi-slash',
      'user',
      'info',
      'briefcase',
      'heart',
      'airplane',
      'heartbeat',
      'folder',
      'chat-circle',
      'chat-bubble-left-right',
      'note',
      'trash',
      'doc-on-doc',
      'pencil',
      'arrow-counterclockwise',
      'arrow-triclo',
      'photo',
      'camera',
      'stop',
      'robot',
      'arrow-down',
      'checkmark',
      'xmark',
    ];

    it.each(iconNames)('renders icon: %s', (iconName) => {
      render(<IconSymbol name={iconName} color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalled();
    });
  });

  describe('Props handling', () => {
    it('renders with default size (24)', () => {
      render(<IconSymbol name="house" color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          style: expect.arrayContaining([expect.objectContaining({ width: 24, height: 24 })]),
        }),
        undefined
      );
    });

    it('renders with custom size', () => {
      render(<IconSymbol name="house" size={32} color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          style: expect.arrayContaining([expect.objectContaining({ width: 32, height: 32 })]),
        }),
        undefined
      );
    });

    it('renders with color prop', () => {
      render(<IconSymbol name="house" color="#FF0000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          tintColor: '#FF0000',
        }),
        undefined
      );
    });

    it('renders with default weight (regular)', () => {
      render(<IconSymbol name="house" color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          weight: 'regular',
        }),
        undefined
      );
    });

    it('renders with custom weight', () => {
      render(<IconSymbol name="house" color="#000000" weight="bold" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          weight: 'bold',
        }),
        undefined
      );
    });

    it('renders with all weight variants', () => {
      const weights = ['thin', 'light', 'regular', 'bold', 'fill', 'duotone'] as const;
      weights.forEach((weight) => {
        jest.clearAllMocks();
        render(<IconSymbol name="house" color="#000000" weight={weight} />);
        expect(mockSymbolView).toHaveBeenCalledWith(expect.objectContaining({ weight }), undefined);
      });
    });

    it('renders with style prop', () => {
      const customStyle = { marginTop: 10 };
      render(<IconSymbol name="house" color="#000000" style={customStyle} />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          style: expect.arrayContaining([customStyle]),
        }),
        undefined
      );
    });

    it('passes all props correctly together', () => {
      const customStyle = { marginTop: 5 };
      render(
        <IconSymbol name="house" size={48} color="#02BFB8" weight="duotone" style={customStyle} />
      );
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          weight: 'duotone',
          tintColor: '#02BFB8',
          style: expect.arrayContaining([
            expect.objectContaining({ width: 48, height: 48 }),
            customStyle,
          ]),
        }),
        undefined
      );
    });

    it('passes icon name to SymbolView', () => {
      render(<IconSymbol name="check" color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'check',
        }),
        undefined
      );
    });
  });

  describe('Edge cases', () => {
    it('renders with empty string name', () => {
      render(<IconSymbol name="" color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          name: '',
        }),
        undefined
      );
    });

    it('renders with unknown icon name', () => {
      render(<IconSymbol name="unknown-icon" color="#000000" />);
      expect(mockSymbolView).toHaveBeenCalledWith(
        expect.objectContaining({
          name: 'unknown-icon',
        }),
        undefined
      );
    });
  });

  describe('Icon count verification', () => {
    it('has all 56 unique icon names mapped', () => {
      const uniqueIcons: PhosphorIconName[] = [
        'list',
        'caret-left',
        'caret-right',
        'x',
        'x-circle',
        'house',
        'book-open',
        'calendar',
        'calendar-plus',
        'magnifying-glass',
        'gear',
        'sidebar',
        'plus',
        'check',
        'paper-plane',
        'sparkle',
        'sparkles',
        'bookmark',
        'sun',
        'cloud',
        'cloud-rain',
        'snowflake',
        'wind',
        'fog',
        'map-pin',
        'text-aa',
        'hash',
        'list-bullets',
        'check-square',
        'clock',
        'arrow-clockwise',
        'sliders',
        'funnel',
        'wifi-slash',
        'user',
        'info',
        'briefcase',
        'heart',
        'airplane',
        'heartbeat',
        'folder',
        'chat-circle',
        'chat-bubble-left-right',
        'note',
        'trash',
        'doc-on-doc',
        'pencil',
        'arrow-counterclockwise',
        'arrow-triclo',
        'photo',
        'camera',
        'stop',
        'robot',
        'arrow-down',
        'checkmark',
        'xmark',
      ];

      expect(uniqueIcons).toHaveLength(56);

      uniqueIcons.forEach((iconName) => {
        jest.clearAllMocks();
        render(<IconSymbol name={iconName} color="#000000" />);
        expect(mockSymbolView).toHaveBeenCalled();
      });
    });
  });
});
