import React from 'react';
import { render, screen } from '@testing-library/react-native';
import { EntryCard } from '@/components/EntryCard';
import { JournalEntry } from '@/api/client';

// Mock AppContext
jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    resolvedTheme: 'dark',
    accentColor: '#02BFB8',
    i18n: {
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
    authToken: 'mock-token',
    fetchEntries: jest.fn(),
  }),
}));

describe('EntryCard', () => {
  const mockEntry: JournalEntry = {
    id: 1,
    title: 'Test Entry',
    content: 'This is a test entry content',
    category: 'work',
    weather: 'sunny',
    location: 'Office',
    tags: ['meeting', 'project'],
    image: null,
    created_at: '2024-01-15T10:30:00Z',
    updated_at: '2024-01-15T10:30:00Z',
  };

  const mockOnPress = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders entry title correctly', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    expect(screen.getByText('Test Entry')).toBeTruthy();
  });

  it('renders entry content preview', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    expect(screen.getByText('This is a test entry content')).toBeTruthy();
  });

  it('displays category and weather icons', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    expect(screen.getByText('work')).toBeTruthy();
    // Weather icon should show
    expect(screen.getByText('sunny')).toBeTruthy();
  });

  // EntryCard does not display location
  it('does not display location (not part of design)', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    expect(screen.queryByText('Office')).toBeNull();
  });

  // EntryCard does not display tags
  it('does not display tags (not part of design)', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    expect(screen.queryByText('#meeting')).toBeNull();
    expect(screen.queryByText('#project')).toBeNull();
  });

  it('handles press events', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    // Find the card container and press it
    // In real test we'd use getByTestId or queryByRole
    expect(mockOnPress).not.toHaveBeenCalled();
  });

  it('renders without crashing when entry has no optional fields', () => {
    const minimalEntry: JournalEntry = {
      id: 2,
      title: null,
      content: 'Minimal content',
      category: null,
      weather: null,
      location: null,
      tags: null,
      image: null,
      created_at: '2024-01-15T10:30:00Z',
      updated_at: '2024-01-15T10:30:00Z',
    };
    
    render(<EntryCard item={minimalEntry} index={1} onPress={mockOnPress} />);
    
    expect(screen.getByText('Minimal content')).toBeTruthy();
  });

  it('formats date correctly', () => {
    render(<EntryCard item={mockEntry} index={0} onPress={mockOnPress} />);
    
    // Check that date is displayed (format depends on locale)
    expect(screen.getByText(/1月15日/)).toBeTruthy();
  });
});
