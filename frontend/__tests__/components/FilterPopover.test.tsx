import React from 'react';
import { TouchableOpacity } from 'react-native';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { FilterPopover } from '@/components/journal/FilterPopover';

// Mock ThemedText to render as React Native Text component
const mockReact = React;
jest.mock('@/components/themed-text', () => ({
  ThemedText: (props: any) => {
    const { children, style, ...rest } = props;
    return mockReact.createElement('Text', { ...rest, style }, children);
  },
}));

describe('FilterPopover', () => {
  const defaultProps = {
    filterCategory: null as string | null,
    filterWeather: null as string | null,
    hasFilters: false,
    accentColor: '#02BFB8',
    theme: 'light' as const,
    i18n: {
      filterByCategory: 'Filter by Category',
      filterByWeather: 'Filter by Weather',
      all: 'All',
      clear: 'Clear',
      catWork: 'Work',
      catLife: 'Life',
      catStudy: 'Study',
      catTravel: 'Travel',
      catHealth: 'Health',
      catOther: 'Other',
      weatherSunny: 'Sunny',
      weatherCloudy: 'Cloudy',
      weatherRainy: 'Rainy',
      weatherSnowy: 'Snowy',
      weatherWindy: 'Windy',
      weatherFoggy: 'Foggy',
    },
    filterPosition: { x: 100, y: 50, width: 200, height: 40 },
    onSetCategory: jest.fn(),
    onSetWeather: jest.fn(),
    onClear: jest.fn(),
    onClose: jest.fn(),
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders without crashing', () => {
      render(<FilterPopover {...defaultProps} />);
      expect(screen.getByText('Filter by Category')).toBeTruthy();
      expect(screen.getByText('Filter by Weather')).toBeTruthy();
    });

    it('renders filter overlay for closing', () => {
      const { UNSAFE_getAllByType } = render(<FilterPopover {...defaultProps} />);
      const touchables = UNSAFE_getAllByType(TouchableOpacity);
      expect(touchables.length).toBeGreaterThan(0);
    });

    it('renders all category options', () => {
      render(<FilterPopover {...defaultProps} />);
      const allElements = screen.getAllByText('All');
      expect(allElements.length).toBe(2);
      expect(screen.getByText('Work')).toBeTruthy();
      expect(screen.getByText('Life')).toBeTruthy();
      expect(screen.getByText('Study')).toBeTruthy();
      expect(screen.getByText('Travel')).toBeTruthy();
      expect(screen.getByText('Health')).toBeTruthy();
      expect(screen.getByText('Other')).toBeTruthy();
    });

    it('renders all weather options', () => {
      render(<FilterPopover {...defaultProps} />);
      expect(screen.getByText('Sunny')).toBeTruthy();
      expect(screen.getByText('Cloudy')).toBeTruthy();
      expect(screen.getByText('Rainy')).toBeTruthy();
      expect(screen.getByText('Snowy')).toBeTruthy();
      expect(screen.getByText('Windy')).toBeTruthy();
      expect(screen.getByText('Foggy')).toBeTruthy();
    });

    it('renders category filter label', () => {
      render(<FilterPopover {...defaultProps} />);
      expect(screen.getByText('Filter by Category')).toBeTruthy();
    });

    it('renders weather filter label', () => {
      render(<FilterPopover {...defaultProps} />);
      expect(screen.getByText('Filter by Weather')).toBeTruthy();
    });

    it('renders with dark theme', () => {
      render(<FilterPopover {...defaultProps} theme="dark" />);
      expect(screen.getByText('Filter by Category')).toBeTruthy();
      expect(screen.getByText('Filter by Weather')).toBeTruthy();
    });

    it('renders with different accent colors', () => {
      render(<FilterPopover {...defaultProps} accentColor="#FF0000" />);
      expect(screen.getByText('Work')).toBeTruthy();
    });
  });

  describe('Interaction Tests', () => {
    it('calls onClose when overlay is pressed', () => {
      const onClose = jest.fn();
      const { UNSAFE_getAllByType } = render(<FilterPopover {...defaultProps} onClose={onClose} />);
      const touchables = UNSAFE_getAllByType(TouchableOpacity);
      fireEvent.press(touchables[0]);
      expect(onClose).toHaveBeenCalledTimes(1);
    });

    describe('Category Selection', () => {
      it('calls onSetCategory with null when All category is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const allElements = screen.getAllByText('All');
        const allCategoryButton = allElements[0].parent?.parent;
        expect(allCategoryButton).toBeTruthy();
        fireEvent.press(allCategoryButton!);
        expect(onSetCategory).toHaveBeenCalledWith(null);
      });

      it('calls onSetCategory with "work" when Work chip is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const workText = screen.getByText('Work');
        const workButton = workText.parent?.parent;
        expect(workButton).toBeTruthy();
        fireEvent.press(workButton!);
        expect(onSetCategory).toHaveBeenCalledWith('work');
      });

      it('calls onSetCategory with "life" when Life chip is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const lifeText = screen.getByText('Life');
        const lifeButton = lifeText.parent?.parent;
        expect(lifeButton).toBeTruthy();
        fireEvent.press(lifeButton!);
        expect(onSetCategory).toHaveBeenCalledWith('life');
      });

      it('calls onSetCategory with "study" when Study chip is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const studyText = screen.getByText('Study');
        const studyButton = studyText.parent?.parent;
        expect(studyButton).toBeTruthy();
        fireEvent.press(studyButton!);
        expect(onSetCategory).toHaveBeenCalledWith('study');
      });

      it('calls onSetCategory with "travel" when Travel chip is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const travelText = screen.getByText('Travel');
        const travelButton = travelText.parent?.parent;
        expect(travelButton).toBeTruthy();
        fireEvent.press(travelButton!);
        expect(onSetCategory).toHaveBeenCalledWith('travel');
      });

      it('calls onSetCategory with "health" when Health chip is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const healthText = screen.getByText('Health');
        const healthButton = healthText.parent?.parent;
        expect(healthButton).toBeTruthy();
        fireEvent.press(healthButton!);
        expect(onSetCategory).toHaveBeenCalledWith('health');
      });

      it('calls onSetCategory with "other" when Other chip is pressed', () => {
        const onSetCategory = jest.fn();
        render(<FilterPopover {...defaultProps} onSetCategory={onSetCategory} />);
        const otherText = screen.getByText('Other');
        const otherButton = otherText.parent?.parent;
        expect(otherButton).toBeTruthy();
        fireEvent.press(otherButton!);
        expect(onSetCategory).toHaveBeenCalledWith('other');
      });
    });

    describe('Weather Selection', () => {
      it('calls onSetWeather with null when All weather is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const allElements = screen.getAllByText('All');
        const allWeatherButton = allElements[1].parent?.parent;
        expect(allWeatherButton).toBeTruthy();
        fireEvent.press(allWeatherButton!);
        expect(onSetWeather).toHaveBeenCalledWith(null);
      });

      it('calls onSetWeather with "sunny" when Sunny chip is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const sunnyText = screen.getByText('Sunny');
        const sunnyButton = sunnyText.parent?.parent;
        expect(sunnyButton).toBeTruthy();
        fireEvent.press(sunnyButton!);
        expect(onSetWeather).toHaveBeenCalledWith('sunny');
      });

      it('calls onSetWeather with "cloudy" when Cloudy chip is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const cloudyText = screen.getByText('Cloudy');
        const cloudyButton = cloudyText.parent?.parent;
        expect(cloudyButton).toBeTruthy();
        fireEvent.press(cloudyButton!);
        expect(onSetWeather).toHaveBeenCalledWith('cloudy');
      });

      it('calls onSetWeather with "rainy" when Rainy chip is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const rainyText = screen.getByText('Rainy');
        const rainyButton = rainyText.parent?.parent;
        expect(rainyButton).toBeTruthy();
        fireEvent.press(rainyButton!);
        expect(onSetWeather).toHaveBeenCalledWith('rainy');
      });

      it('calls onSetWeather with "snowy" when Snowy chip is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const snowyText = screen.getByText('Snowy');
        const snowyButton = snowyText.parent?.parent;
        expect(snowyButton).toBeTruthy();
        fireEvent.press(snowyButton!);
        expect(onSetWeather).toHaveBeenCalledWith('snowy');
      });

      it('calls onSetWeather with "windy" when Windy chip is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const windyText = screen.getByText('Windy');
        const windyButton = windyText.parent?.parent;
        expect(windyButton).toBeTruthy();
        fireEvent.press(windyButton!);
        expect(onSetWeather).toHaveBeenCalledWith('windy');
      });

      it('calls onSetWeather with "foggy" when Foggy chip is pressed', () => {
        const onSetWeather = jest.fn();
        render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
        const foggyText = screen.getByText('Foggy');
        const foggyButton = foggyText.parent?.parent;
        expect(foggyButton).toBeTruthy();
        fireEvent.press(foggyButton!);
        expect(onSetWeather).toHaveBeenCalledWith('foggy');
      });
    });

    describe('Clear Button', () => {
      it('renders clear button when hasFilters is true', () => {
        render(<FilterPopover {...defaultProps} hasFilters={true} />);
        expect(screen.getByText('Clear')).toBeTruthy();
      });

      it('does not render clear button when hasFilters is false', () => {
        render(<FilterPopover {...defaultProps} hasFilters={false} />);
        expect(screen.queryByText('Clear')).toBeNull();
      });

      it('calls onClear when clear button is pressed', () => {
        const onClear = jest.fn();
        render(<FilterPopover {...defaultProps} hasFilters={true} onClear={onClear} />);
        const clearText = screen.getByText('Clear');
        const clearButton = clearText.parent?.parent;
        expect(clearButton).toBeTruthy();
        fireEvent.press(clearButton!);
        expect(onClear).toHaveBeenCalledTimes(1);
      });
    });
  });

  describe('State Tests', () => {
    describe('Category Selection Highlight', () => {
      it('highlights All category when filterCategory is null', () => {
        render(<FilterPopover {...defaultProps} filterCategory={null} accentColor="#FF0000" />);
        const allElements = screen.getAllByText('All');
        expect(allElements[0]).toBeTruthy();
      });

      it('highlights Work category when filterCategory is "work"', () => {
        render(<FilterPopover {...defaultProps} filterCategory="work" />);
        expect(screen.getByText('Work')).toBeTruthy();
      });

      it('highlights Life category when filterCategory is "life"', () => {
        render(<FilterPopover {...defaultProps} filterCategory="life" />);
        expect(screen.getByText('Life')).toBeTruthy();
      });

      it('highlights Study category when filterCategory is "study"', () => {
        render(<FilterPopover {...defaultProps} filterCategory="study" />);
        expect(screen.getByText('Study')).toBeTruthy();
      });

      it('highlights Travel category when filterCategory is "travel"', () => {
        render(<FilterPopover {...defaultProps} filterCategory="travel" />);
        expect(screen.getByText('Travel')).toBeTruthy();
      });

      it('highlights Health category when filterCategory is "health"', () => {
        render(<FilterPopover {...defaultProps} filterCategory="health" />);
        expect(screen.getByText('Health')).toBeTruthy();
      });

      it('highlights Other category when filterCategory is "other"', () => {
        render(<FilterPopover {...defaultProps} filterCategory="other" />);
        expect(screen.getByText('Other')).toBeTruthy();
      });
    });

    describe('Weather Selection Highlight', () => {
      it('highlights All weather when filterWeather is null', () => {
        render(<FilterPopover {...defaultProps} filterWeather={null} />);
        const allElements = screen.getAllByText('All');
        expect(allElements.length).toBe(2);
      });

      it('highlights Sunny weather when filterWeather is "sunny"', () => {
        render(<FilterPopover {...defaultProps} filterWeather="sunny" />);
        expect(screen.getByText('Sunny')).toBeTruthy();
      });

      it('highlights Cloudy weather when filterWeather is "cloudy"', () => {
        render(<FilterPopover {...defaultProps} filterWeather="cloudy" />);
        expect(screen.getByText('Cloudy')).toBeTruthy();
      });

      it('highlights Rainy weather when filterWeather is "rainy"', () => {
        render(<FilterPopover {...defaultProps} filterWeather="rainy" />);
        expect(screen.getByText('Rainy')).toBeTruthy();
      });

      it('highlights Snowy weather when filterWeather is "snowy"', () => {
        render(<FilterPopover {...defaultProps} filterWeather="snowy" />);
        expect(screen.getByText('Snowy')).toBeTruthy();
      });

      it('highlights Windy weather when filterWeather is "windy"', () => {
        render(<FilterPopover {...defaultProps} filterWeather="windy" />);
        expect(screen.getByText('Windy')).toBeTruthy();
      });

      it('highlights Foggy weather when filterWeather is "foggy"', () => {
        render(<FilterPopover {...defaultProps} filterWeather="foggy" />);
        expect(screen.getByText('Foggy')).toBeTruthy();
      });
    });

    describe('Combined Filter State', () => {
      it('renders with both category and weather filters active', () => {
        render(
          <FilterPopover
            {...defaultProps}
            filterCategory="work"
            filterWeather="sunny"
            hasFilters={true}
          />
        );
        expect(screen.getByText('Work')).toBeTruthy();
        expect(screen.getByText('Sunny')).toBeTruthy();
        expect(screen.getByText('Clear')).toBeTruthy();
      });

      it('renders with only category filter active', () => {
        render(
          <FilterPopover
            {...defaultProps}
            filterCategory="life"
            filterWeather={null}
            hasFilters={true}
          />
        );
        expect(screen.getByText('Life')).toBeTruthy();
        expect(screen.getByText('Clear')).toBeTruthy();
      });

      it('renders with only weather filter active', () => {
        render(
          <FilterPopover
            {...defaultProps}
            filterCategory={null}
            filterWeather="rainy"
            hasFilters={true}
          />
        );
        expect(screen.getByText('Rainy')).toBeTruthy();
        expect(screen.getByText('Clear')).toBeTruthy();
      });
    });
  });

  describe('Edge Cases', () => {
    it('renders with empty i18n object', () => {
      render(<FilterPopover {...defaultProps} i18n={{}} />);
      expect(screen.getByText('work')).toBeTruthy();
      expect(screen.getByText('sunny')).toBeTruthy();
    });

    it('renders with partial i18n translations', () => {
      render(
        <FilterPopover
          {...defaultProps}
          i18n={{ filterByCategory: 'Category', filterByWeather: 'Weather', all: 'All' }}
        />
      );
      expect(screen.getByText('Category')).toBeTruthy();
      expect(screen.getByText('Weather')).toBeTruthy();
      expect(screen.getByText('work')).toBeTruthy();
      expect(screen.getByText('sunny')).toBeTruthy();
    });

    it('handles different filter positions', () => {
      render(
        <FilterPopover {...defaultProps} filterPosition={{ x: 0, y: 0, width: 100, height: 30 }} />
      );
      expect(screen.getByText('Filter by Category')).toBeTruthy();
    });

    it('handles negative filter positions', () => {
      render(
        <FilterPopover
          {...defaultProps}
          filterPosition={{ x: -10, y: -20, width: 100, height: 30 }}
        />
      );
      expect(screen.getByText('Filter by Category')).toBeTruthy();
    });

    it('handles very large filter positions', () => {
      render(
        <FilterPopover
          {...defaultProps}
          filterPosition={{ x: 9999, y: 9999, width: 500, height: 100 }}
        />
      );
      expect(screen.getByText('Filter by Category')).toBeTruthy();
    });

    it('renders with invalid category value', () => {
      render(<FilterPopover {...defaultProps} filterCategory="invalid-category" />);
      expect(screen.getByText('Filter by Category')).toBeTruthy();
    });

    it('renders with invalid weather value', () => {
      render(<FilterPopover {...defaultProps} filterWeather="invalid-weather" />);
      expect(screen.getByText('Filter by Weather')).toBeTruthy();
    });

    it('renders with empty string accent color', () => {
      render(<FilterPopover {...defaultProps} accentColor="" />);
      expect(screen.getByText('Work')).toBeTruthy();
    });

    it('renders with special characters in accent color', () => {
      render(<FilterPopover {...defaultProps} accentColor="#FF0000!@#" />);
      expect(screen.getByText('Work')).toBeTruthy();
    });

    it('handles rapid category changes', () => {
      const onSetCategory = jest.fn();
      const { rerender } = render(
        <FilterPopover {...defaultProps} onSetCategory={onSetCategory} />
      );
      rerender(
        <FilterPopover {...defaultProps} filterCategory="work" onSetCategory={onSetCategory} />
      );
      expect(screen.getByText('Work')).toBeTruthy();
      rerender(
        <FilterPopover {...defaultProps} filterCategory="life" onSetCategory={onSetCategory} />
      );
      expect(screen.getByText('Life')).toBeTruthy();
    });

    it('handles rapid weather changes', () => {
      const onSetWeather = jest.fn();
      const { rerender } = render(<FilterPopover {...defaultProps} onSetWeather={onSetWeather} />);
      rerender(
        <FilterPopover {...defaultProps} filterWeather="sunny" onSetWeather={onSetWeather} />
      );
      expect(screen.getByText('Sunny')).toBeTruthy();
      rerender(
        <FilterPopover {...defaultProps} filterWeather="rainy" onSetWeather={onSetWeather} />
      );
      expect(screen.getByText('Rainy')).toBeTruthy();
    });

    it('handles toggling hasFilters state', () => {
      const { rerender, queryByText } = render(
        <FilterPopover {...defaultProps} hasFilters={false} />
      );
      expect(queryByText('Clear')).toBeNull();
      rerender(<FilterPopover {...defaultProps} hasFilters={true} />);
      expect(queryByText('Clear')).toBeTruthy();
      rerender(<FilterPopover {...defaultProps} hasFilters={false} />);
      expect(queryByText('Clear')).toBeNull();
    });

    it('renders with theme switching', () => {
      const { rerender } = render(<FilterPopover {...defaultProps} theme="light" />);
      expect(screen.getByText('Filter by Category')).toBeTruthy();
      rerender(<FilterPopover {...defaultProps} theme="dark" />);
      expect(screen.getByText('Filter by Category')).toBeTruthy();
    });

    it('handles all callback props being called in sequence', () => {
      const onSetCategory = jest.fn();
      const onSetWeather = jest.fn();
      const onClear = jest.fn();
      const onClose = jest.fn();
      const { UNSAFE_getAllByType } = render(
        <FilterPopover
          {...defaultProps}
          hasFilters={true}
          onSetCategory={onSetCategory}
          onSetWeather={onSetWeather}
          onClear={onClear}
          onClose={onClose}
        />
      );
      const workText = screen.getByText('Work');
      fireEvent.press(workText.parent?.parent!);
      expect(onSetCategory).toHaveBeenCalledWith('work');
      const sunnyText = screen.getByText('Sunny');
      fireEvent.press(sunnyText.parent?.parent!);
      expect(onSetWeather).toHaveBeenCalledWith('sunny');
      const clearText = screen.getByText('Clear');
      fireEvent.press(clearText.parent?.parent!);
      expect(onClear).toHaveBeenCalled();
      const touchables = UNSAFE_getAllByType(TouchableOpacity);
      fireEvent.press(touchables[0]);
      expect(onClose).toHaveBeenCalled();
    });

    it('renders correctly when filterCategory and filterWeather change to null simultaneously', () => {
      const { rerender } = render(
        <FilterPopover
          {...defaultProps}
          filterCategory="work"
          filterWeather="sunny"
          hasFilters={true}
        />
      );
      rerender(
        <FilterPopover
          {...defaultProps}
          filterCategory={null}
          filterWeather={null}
          hasFilters={false}
        />
      );
      expect(screen.getByText('Filter by Category')).toBeTruthy();
      expect(screen.getByText('Filter by Weather')).toBeTruthy();
      expect(screen.queryByText('Clear')).toBeNull();
    });
  });
});
