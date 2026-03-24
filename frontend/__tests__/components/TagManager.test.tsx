import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
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
    expect(screen.getByRole('button', { name: 'Add tag' })).toBeTruthy();
  });

  it('displays existing tags', () => {
    const tags = ['work', 'personal'];
    render(<TagManager {...defaultProps} tags={tags} />);

    expect(screen.getByText('#work')).toBeTruthy();
    expect(screen.getByText('#personal')).toBeTruthy();
  });

  it('shows add button and opens input when pressed', () => {
    render(<TagManager {...defaultProps} />);

    const addButton = screen.getByRole('button', { name: 'Add tag' });
    fireEvent.press(addButton);

    expect(screen.getByRole('textbox', { name: 'New tag input' })).toBeTruthy();
  });

  it('calls onTagsChange when adding a new tag', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} onTagsChange={onTagsChange} />);

    fireEvent.press(screen.getByRole('button', { name: 'Add tag' }));

    const input = screen.getByRole('textbox', { name: 'New tag input' });
    fireEvent.changeText(input, 'newtag');
    fireEvent.press(screen.getByRole('button', { name: 'Save tag' }));

    expect(onTagsChange).toHaveBeenCalledWith(['newtag']);
  });

  it('does not add duplicate tags', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} tags={['existing']} onTagsChange={onTagsChange} />);

    fireEvent.press(screen.getByRole('button', { name: 'Add tag' }));
    const input = screen.getByRole('textbox', { name: 'New tag input' });
    fireEvent.changeText(input, 'existing');
    fireEvent.press(screen.getByRole('button', { name: 'Save tag' }));

    expect(onTagsChange).not.toHaveBeenCalled();
  });

  it('removes tag when delete button pressed', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} tags={['tag1']} onTagsChange={onTagsChange} />);

    const deleteButton = screen.getByRole('button', { name: 'Remove tag tag1' });
    fireEvent.press(deleteButton);

    expect(onTagsChange).toHaveBeenCalledWith([]);
  });

  it('does not add empty tags', () => {
    const onTagsChange = jest.fn();
    render(<TagManager {...defaultProps} onTagsChange={onTagsChange} />);

    fireEvent.press(screen.getByRole('button', { name: 'Add tag' }));
    fireEvent.press(screen.getByRole('button', { name: 'Save tag' }));

    expect(onTagsChange).not.toHaveBeenCalled();
  });
});
