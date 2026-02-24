import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react-native';
import { TagManager } from '@/components/journal/TagManager';

describe('TagManager', () => {
  const defaultProps = {
    tags: [],
    onTagsChange: jest.fn(),
    theme: 'light' as const,
    accentColor: '#02BFB8',
    i18n: {
      tags: 'Tags',
      addTag: 'Add Tag',
      save: 'Save',
    },
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders without crashing', () => {
    render(<TagManager {...defaultProps} />);
    expect(screen.getByText('Tags')).toBeTruthy();
  });

  it('displays existing tags', () => {
    const tags = ['work', 'personal'];
    render(<TagManager {...defaultProps} tags={tags} />);
    
    expect(screen.getByText('#work')).toBeTruthy();
    expect(screen.getByText('#personal')).toBeTruthy();
  });

  it('shows add button and opens input when pressed', () => {
    render(<TagManager {...defaultProps} />);
    
    const addButton = screen.getByText('+');
    fireEvent.press(addButton);
    
    expect(screen.getByPlaceholderText('Add Tag')).toBeTruthy();
  });

  it('calls onTagsChange when adding a new tag', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} onTagsChange={onTagsChange} />);
    
    fireEvent.press(screen.getByText('+'));
    
    const input = screen.getByPlaceholderText('Add Tag');
    fireEvent.changeText(input, 'newtag');
    fireEvent.press(screen.getByText('Save'));
    
    expect(onTagsChange).toHaveBeenCalledWith(['newtag']);
  });

  it('does not add duplicate tags', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} tags={['existing']} onTagsChange={onTagsChange} />);
    
    fireEvent.press(screen.getByText('+'));
    const input = screen.getByPlaceholderText('Add Tag');
    fireEvent.changeText(input, 'existing');
    fireEvent.press(screen.getByText('Save'));
    
    expect(onTagsChange).not.toHaveBeenCalled();
  });

  it('removes tag when delete button pressed', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} tags={['tag1']} onTagsChange={onTagsChange} />);
    
    const deleteButton = screen.getByText('✕');
    fireEvent.press(deleteButton);
    
    expect(onTagsChange).toHaveBeenCalledWith([]);
  });

  it('does not add empty tags', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} onTagsChange={onTagsChange} />);
    
    fireEvent.press(screen.getByText('+'));
    fireEvent.press(screen.getByText('Save'));
    
    expect(onTagsChange).not.toHaveBeenCalled();
  });
});
