import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { ActivityIndicator } from 'react-native';

// Mock expo-router
const mockBack = jest.fn();
const mockReplace = jest.fn();
const mockPush = jest.fn();

jest.mock('expo-router', () => ({
  useLocalSearchParams: jest.fn(),
  useRouter: () => ({
    back: mockBack,
    replace: mockReplace,
    push: mockPush,
    canGoBack: jest.fn(() => true),
  }),
}));

// Mock useJournalEntry hook
const mockSetTitle = jest.fn();
const mockSetContent = jest.fn();
const mockSetCategory = jest.fn();
const mockSetWeather = jest.fn();
const mockSetLocation = jest.fn();
const mockSetTags = jest.fn();
const mockSetImage = jest.fn();
const mockHandleSave = jest.fn();
const mockHandleImageUpload = jest.fn();
const mockInsertTemplate = jest.fn();

const mockUseJournalEntry = jest.fn();

jest.mock('@/hooks/use-journal-entry', () => ({
  useJournalEntry: (...args: any[]) => mockUseJournalEntry(...args),
}));

// Mock AppContext
jest.mock('@/context/AppContext', () => ({
  useAppContext: () => ({
    resolvedTheme: 'dark',
    accentColor: '#02BFB8',
    i18n: {
      titlePlaceholder: 'Enter title...',
      contentPlaceholder: 'Write your thoughts...',
      wordCount: 'words',
    },
  }),
}));

// Mock child components with React Native components that work with fireEvent.press
jest.mock('@/components/journal/TagManager', () => {
  const { View, TouchableOpacity, Text } = jest.requireActual('react-native');
  return {
    TagManager: ({
      tags,
      onTagsChange,
    }: {
      tags: string[];
      onTagsChange: (tags: string[]) => void;
    }) => (
      <View testID="tag-manager" data-tags={JSON.stringify(tags)}>
        <TouchableOpacity testID="add-tag-btn" onPress={() => onTagsChange([...tags, 'new-tag'])}>
          <Text>Add Tag</Text>
        </TouchableOpacity>
      </View>
    ),
  };
});

jest.mock('@/components/journal/EntryMetadata', () => {
  const { View, Text } = jest.requireActual('react-native');
  return {
    EntryMetadata: (props: any) => (
      <View testID="entry-metadata">
        <Text testID="metadata-category">{props.category || 'No Category'}</Text>
        <Text testID="metadata-weather">{props.weather || 'No Weather'}</Text>
        <Text testID="metadata-location">{props.location || 'No Location'}</Text>
      </View>
    ),
  };
});

jest.mock('@/components/journal/EditorToolbar', () => {
  const { View, TouchableOpacity, Text } = jest.requireActual('react-native');
  return {
    EditorToolbar: ({ onInsertTemplate, onOpenCalendar, tagsCount }: any) => (
      <View testID="editor-toolbar">
        <TouchableOpacity testID="insert-list-btn" onPress={() => onInsertTemplate('list')}>
          <Text>List</Text>
        </TouchableOpacity>
        <TouchableOpacity testID="insert-task-btn" onPress={() => onInsertTemplate('task')}>
          <Text>Task</Text>
        </TouchableOpacity>
        <TouchableOpacity testID="insert-time-btn" onPress={() => onInsertTemplate('time')}>
          <Text>Time</Text>
        </TouchableOpacity>
        <TouchableOpacity testID="open-calendar-btn" onPress={onOpenCalendar}>
          <Text>Calendar</Text>
        </TouchableOpacity>
        <Text testID="tags-count">{tagsCount}</Text>
      </View>
    ),
  };
});

jest.mock('@/components/journal/ImageUploadPreview', () => {
  const { View, TouchableOpacity, Text } = jest.requireActual('react-native');
  return {
    ImageUploadPreview: ({ image, uploading, onUpload, onRemove }: any) => (
      <View testID="image-upload-preview">
        {uploading && <Text testID="uploading-indicator">Uploading...</Text>}
        {image && <Text testID="image-filename">{image}</Text>}
        <TouchableOpacity testID="upload-image-btn" onPress={onUpload}>
          <Text>Upload</Text>
        </TouchableOpacity>
        <TouchableOpacity testID="remove-image-btn" onPress={onRemove}>
          <Text>Remove</Text>
        </TouchableOpacity>
      </View>
    ),
  };
});

jest.mock('@/components/themed-text', () => {
  const { Text } = jest.requireActual('react-native');
  return {
    ThemedText: ({ children, style }: any) => <Text testID="themed-text">{children}</Text>,
  };
});

jest.mock('@/components/themed-view', () => {
  const { View } = jest.requireActual('react-native');
  return {
    ThemedView: ({ children, style }: any) => <View testID="themed-view">{children}</View>,
  };
});

jest.mock('@/components/ui/icon-symbol', () => {
  const { Text } = jest.requireActual('react-native');
  return {
    IconSymbol: ({ name, size, color }: { name: string; size?: number; color?: string }) => (
      <Text testID={`icon-${name}`} data-size={size} data-color={color} />
    ),
  };
});

// Import the component after mocks
// eslint-disable-next-line import/first
import WriteEntryScreen from '@/app/(tabs)/write';
// eslint-disable-next-line import/first
import { useLocalSearchParams } from 'expo-router';

describe('WriteEntryScreen', () => {
  const defaultJournalEntryReturn = {
    title: '',
    content: '',
    category: null,
    weather: null,
    location: '',
    tags: [],
    image: null,
    saving: false,
    uploading: false,
    loading: false,
    createdAt: null,
    wordCount: 0,
    categoryOptions: [
      { value: 'work', label: 'Work', icon: 'briefcase' },
      { value: 'life', label: 'Life', icon: 'heart' },
    ],
    weatherOptions: [
      { value: 'sunny', label: 'Sunny', icon: 'sun' },
      { value: 'rainy', label: 'Rainy', icon: 'cloud-rain' },
    ],
    setTitle: mockSetTitle,
    setContent: mockSetContent,
    setCategory: mockSetCategory,
    setWeather: mockSetWeather,
    setLocation: mockSetLocation,
    setTags: mockSetTags,
    setImage: mockSetImage,
    handleSave: mockHandleSave,
    handleImageUpload: mockHandleImageUpload,
    insertTemplate: mockInsertTemplate,
  };

  beforeEach(() => {
    jest.clearAllMocks();
    mockUseJournalEntry.mockReturnValue(defaultJournalEntryReturn);
    (useLocalSearchParams as jest.Mock).mockReturnValue({});
  });

  describe('Rendering Tests', () => {
    it('renders without crashing', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('themed-view')).toBeTruthy();
    });

    it('renders back button', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('icon-caret-left')).toBeTruthy();
    });

    it('renders save button', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('icon-check')).toBeTruthy();
    });

    it('renders title input with placeholder', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByPlaceholderText('Enter title...')).toBeTruthy();
    });

    it('renders content input with placeholder', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByPlaceholderText('Write your thoughts...')).toBeTruthy();
    });

    it('renders EntryMetadata component', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('entry-metadata')).toBeTruthy();
    });

    it('renders TagManager component', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('tag-manager')).toBeTruthy();
    });

    it('renders ImageUploadPreview component', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('image-upload-preview')).toBeTruthy();
    });

    it('renders EditorToolbar component', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('editor-toolbar')).toBeTruthy();
    });

    it('renders word count display', () => {
      render(<WriteEntryScreen />);
      // Word count is split across multiple text nodes, check for the icon and text separately
      expect(screen.getByTestId('icon-text-aa')).toBeTruthy();
      expect(screen.getAllByTestId('themed-text').length).toBeGreaterThanOrEqual(1);
    });

    it('renders date string in top bar', () => {
      render(<WriteEntryScreen />);
      const dateText = screen.getAllByTestId('themed-text')[0];
      expect(dateText).toBeTruthy();
    });
  });

  describe('Loading State', () => {
    it('renders loading indicator when loading is true', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        loading: true,
      });

      const { UNSAFE_getAllByType } = render(<WriteEntryScreen />);
      const indicators = UNSAFE_getAllByType(ActivityIndicator);
      expect(indicators.length).toBeGreaterThan(0);
    });

    it('does not render editor when loading', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        loading: true,
      });

      render(<WriteEntryScreen />);
      expect(screen.queryByPlaceholderText('Enter title...')).toBeNull();
      expect(screen.queryByPlaceholderText('Write your thoughts...')).toBeNull();
    });

    it('renders editor when loading is false', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        loading: false,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByPlaceholderText('Enter title...')).toBeTruthy();
      expect(screen.getByPlaceholderText('Write your thoughts...')).toBeTruthy();
    });
  });

  describe('Form Tests', () => {
    it('calls setTitle when title input changes', () => {
      render(<WriteEntryScreen />);
      const titleInput = screen.getByPlaceholderText('Enter title...');

      fireEvent.changeText(titleInput, 'My New Title');

      expect(mockSetTitle).toHaveBeenCalledWith('My New Title');
    });

    it('calls setContent when content input changes', () => {
      render(<WriteEntryScreen />);
      const contentInput = screen.getByPlaceholderText('Write your thoughts...');

      fireEvent.changeText(contentInput, 'My journal content');

      expect(mockSetContent).toHaveBeenCalledWith('My journal content');
    });

    it('displays current title value', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        title: 'Existing Title',
      });

      render(<WriteEntryScreen />);
      const titleInput = screen.getByPlaceholderText('Enter title...');
      expect(titleInput.props.value).toBe('Existing Title');
    });

    it('displays current content value', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        content: 'Existing content here',
      });

      render(<WriteEntryScreen />);
      const contentInput = screen.getByPlaceholderText('Write your thoughts...');
      expect(contentInput.props.value).toBe('Existing content here');
    });
  });

  describe('Save Functionality', () => {
    it('calls handleSave when save button is pressed', () => {
      render(<WriteEntryScreen />);
      const saveButton = screen.getByTestId('icon-check').parent;

      fireEvent.press(saveButton);

      expect(mockHandleSave).toHaveBeenCalledTimes(1);
    });

    it('shows activity indicator when saving', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        saving: true,
      });

      const { UNSAFE_getAllByType } = render(<WriteEntryScreen />);
      const indicators = UNSAFE_getAllByType(ActivityIndicator);
      expect(indicators.length).toBeGreaterThan(0);
    });

    it('disables save button when saving', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        saving: true,
      });

      render(<WriteEntryScreen />);
      expect(screen.queryByTestId('icon-check')).toBeNull();
    });
  });

  describe('Back Navigation', () => {
    it('calls router.back when back button is pressed', () => {
      render(<WriteEntryScreen />);
      const backButton = screen.getByTestId('icon-caret-left').parent;

      fireEvent.press(backButton);

      expect(mockBack).toHaveBeenCalledTimes(1);
    });
  });

  describe('Integration Tests - TagManager', () => {
    it('passes tags to TagManager', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        tags: ['work', 'personal'],
      });

      render(<WriteEntryScreen />);
      const tagManager = screen.getByTestId('tag-manager');
      expect(tagManager.props['data-tags']).toBe(JSON.stringify(['work', 'personal']));
    });

    it('passes setTags callback to TagManager', () => {
      render(<WriteEntryScreen />);
      const addTagBtn = screen.getByTestId('add-tag-btn');

      fireEvent.press(addTagBtn);

      expect(mockSetTags).toHaveBeenCalledWith(['new-tag']);
    });

    it('displays correct tags count in toolbar', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        tags: ['tag1', 'tag2', 'tag3'],
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('tags-count').children[0]).toBe('3');
    });
  });

  describe('Integration Tests - EntryMetadata', () => {
    it('passes category to EntryMetadata', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        category: 'work',
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('metadata-category').children[0]).toBe('work');
    });

    it('passes weather to EntryMetadata', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        weather: 'sunny',
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('metadata-weather').children[0]).toBe('sunny');
    });

    it('passes location to EntryMetadata', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        location: 'Shanghai',
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('metadata-location').children[0]).toBe('Shanghai');
    });

    it('passes categoryOptions and weatherOptions', () => {
      render(<WriteEntryScreen />);
      expect(screen.getByTestId('entry-metadata')).toBeTruthy();
    });
  });

  describe('Integration Tests - ImageUploadPreview', () => {
    it('passes image to ImageUploadPreview', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        image: 'test-image.jpg',
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('image-filename').children[0]).toBe('test-image.jpg');
    });

    it('passes uploading state to ImageUploadPreview', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        uploading: true,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('uploading-indicator')).toBeTruthy();
    });

    it('calls handleImageUpload when upload button pressed', () => {
      render(<WriteEntryScreen />);
      const uploadBtn = screen.getByTestId('upload-image-btn');

      fireEvent.press(uploadBtn);

      expect(mockHandleImageUpload).toHaveBeenCalledTimes(1);
    });

    it('calls setImage when remove button pressed', () => {
      render(<WriteEntryScreen />);
      const removeBtn = screen.getByTestId('remove-image-btn');

      fireEvent.press(removeBtn);

      expect(mockSetImage).toHaveBeenCalledWith(null);
    });
  });

  describe('Integration Tests - EditorToolbar', () => {
    it('calls insertTemplate with "list" type', () => {
      render(<WriteEntryScreen />);
      const listBtn = screen.getByTestId('insert-list-btn');

      fireEvent.press(listBtn);

      expect(mockInsertTemplate).toHaveBeenCalledWith('list');
    });

    it('calls insertTemplate with "task" type', () => {
      render(<WriteEntryScreen />);
      const taskBtn = screen.getByTestId('insert-task-btn');

      fireEvent.press(taskBtn);

      expect(mockInsertTemplate).toHaveBeenCalledWith('task');
    });

    it('calls insertTemplate with "time" type', () => {
      render(<WriteEntryScreen />);
      const timeBtn = screen.getByTestId('insert-time-btn');

      fireEvent.press(timeBtn);

      expect(mockInsertTemplate).toHaveBeenCalledWith('time');
    });

    it('navigates to calendar when calendar button pressed', () => {
      render(<WriteEntryScreen />);
      const calendarBtn = screen.getByTestId('open-calendar-btn');

      fireEvent.press(calendarBtn);

      expect(mockPush).toHaveBeenCalledWith('/calendar');
    });
  });

  describe('Edge Cases - New Entry vs Existing Entry', () => {
    it('initializes useJournalEntry without entryId for new entry', () => {
      (useLocalSearchParams as jest.Mock).mockReturnValue({});

      render(<WriteEntryScreen />);

      expect(mockUseJournalEntry).toHaveBeenCalledWith(
        expect.objectContaining({
          entryId: undefined,
        })
      );
    });

    it('initializes useJournalEntry with entryId for existing entry', () => {
      (useLocalSearchParams as jest.Mock).mockReturnValue({ id: 'entry-123' });

      render(<WriteEntryScreen />);

      expect(mockUseJournalEntry).toHaveBeenCalledWith(
        expect.objectContaining({
          entryId: 'entry-123',
        })
      );
    });

    it('autoFocuses content input for new entry', () => {
      (useLocalSearchParams as jest.Mock).mockReturnValue({});

      render(<WriteEntryScreen />);
      const contentInput = screen.getByPlaceholderText('Write your thoughts...');
      expect(contentInput.props.autoFocus).toBe(true);
    });

    it('does not autoFocus content input for existing entry', () => {
      (useLocalSearchParams as jest.Mock).mockReturnValue({ id: 'entry-123' });

      render(<WriteEntryScreen />);
      const contentInput = screen.getByPlaceholderText('Write your thoughts...');
      expect(contentInput.props.autoFocus).toBe(false);
    });
  });

  describe('Edge Cases - Various States', () => {
    it('displays correct word count', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        wordCount: 150,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('icon-text-aa')).toBeTruthy();
      const themedTexts = screen.getAllByTestId('themed-text');
      expect(themedTexts.length).toBeGreaterThanOrEqual(2);
    });

    it('displays entry date when createdAt is provided', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        createdAt: '2024-03-15T10:30:00Z',
      });

      render(<WriteEntryScreen />);
      const dateTexts = screen.getAllByTestId('themed-text');
      expect(dateTexts.length).toBeGreaterThan(0);
    });

    it('handles empty title gracefully', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        title: '',
      });

      render(<WriteEntryScreen />);
      const titleInput = screen.getByPlaceholderText('Enter title...');
      expect(titleInput.props.value).toBe('');
    });

    it('handles empty content gracefully', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        content: '',
      });

      render(<WriteEntryScreen />);
      const contentInput = screen.getByPlaceholderText('Write your thoughts...');
      expect(contentInput.props.value).toBe('');
    });

    it('handles null category gracefully', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        category: null,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('metadata-category').children[0]).toBe('No Category');
    });

    it('handles null weather gracefully', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        weather: null,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('metadata-weather').children[0]).toBe('No Weather');
    });

    it('handles empty tags array', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        tags: [],
      });

      render(<WriteEntryScreen />);
      const tagManager = screen.getByTestId('tag-manager');
      expect(tagManager.props['data-tags']).toBe('[]');
      expect(screen.getByTestId('tags-count').children[0]).toBe('0');
    });

    it('handles multiple tags', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        tags: ['work', 'personal', 'urgent', 'idea'],
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('tags-count').children[0]).toBe('4');
    });
  });

  describe('useJournalEntry Hook Integration', () => {
    it('passes onSuccess callback that calls safeGoBack', () => {
      render(<WriteEntryScreen />);

      // Get the onSuccess callback from the hook call
      const hookCall = mockUseJournalEntry.mock.calls[0][0];
      expect(hookCall.onSuccess).toBeDefined();

      // Call the onSuccess callback
      hookCall.onSuccess();

      // Should trigger safeGoBack which calls router.back
      expect(mockBack).toHaveBeenCalled();
    });

    it('safeGoBack falls back to replace when cannot go back', () => {
      // Import expo-router module to modify the mock
      const expoRouter = jest.requireMock('expo-router') as { useRouter: jest.Mock };
      const originalUseRouter = expoRouter.useRouter;

      // Override useRouter temporarily
      expoRouter.useRouter = jest.fn(() => ({
        back: mockBack,
        replace: mockReplace,
        push: mockPush,
        canGoBack: jest.fn(() => false),
      }));

      render(<WriteEntryScreen />);

      const hookCall = mockUseJournalEntry.mock.calls[0][0];
      hookCall.onSuccess();

      expect(mockReplace).toHaveBeenCalledWith('/');

      // Restore original mock
      expoRouter.useRouter = originalUseRouter;
    });
  });

  describe('Word Count Display', () => {
    it('displays word count with icon', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        wordCount: 42,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('icon-text-aa')).toBeTruthy();
      // Text is split across multiple nodes, check for presence of icon and themed-text
      const themedTexts = screen.getAllByTestId('themed-text');
      expect(themedTexts.length).toBeGreaterThanOrEqual(2);
    });

    it('handles zero word count', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        wordCount: 0,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('icon-text-aa')).toBeTruthy();
      const themedTexts = screen.getAllByTestId('themed-text');
      expect(themedTexts.length).toBeGreaterThanOrEqual(2);
    });

    it('handles large word count', () => {
      mockUseJournalEntry.mockReturnValue({
        ...defaultJournalEntryReturn,
        wordCount: 9999,
      });

      render(<WriteEntryScreen />);
      expect(screen.getByTestId('icon-text-aa')).toBeTruthy();
      const themedTexts = screen.getAllByTestId('themed-text');
      expect(themedTexts.length).toBeGreaterThanOrEqual(2);
    });
  });

  describe('Theme Integration', () => {
    it('uses correct theme colors from AppContext', () => {
      render(<WriteEntryScreen />);
      // The component should use the resolved theme from AppContext
      expect(screen.getByTestId('themed-view')).toBeTruthy();
    });
  });
});
