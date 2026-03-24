import React from 'react';
import { fireEvent, render, screen } from '@testing-library/react-native';
import { ActivityIndicator, Image, TouchableOpacity, View } from 'react-native';
import { ImageUploadPreview } from '@/components/journal/ImageUploadPreview';

// Mock IconSymbol component
jest.mock('@/components/ui/icon-symbol', () => ({
  IconSymbol: ({ name, size, color }: { name: string; size?: number; color?: string }) => {
    return <div testID={`icon-${name}`} data-size={size} data-color={color} />;
  },
}));

describe('ImageUploadPreview', () => {
  const mockOnUpload = jest.fn();
  const mockOnRemove = jest.fn();

  const defaultProps = {
    image: null as string | null,
    uploading: false,
    onUpload: mockOnUpload,
    onRemove: mockOnRemove,
    theme: 'light' as 'light' | 'dark',
    accentColor: '#02BFB8',
    apiStaticUrl: 'http://localhost:8000/static',
  };

  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering - Upload Button State (no image)', () => {
    it('renders upload button when image is null', () => {
      render(<ImageUploadPreview {...defaultProps} image={null} />);

      // Should show image icon and plus icon
      expect(screen.getByTestId('icon-image')).toBeTruthy();
      expect(screen.getByTestId('icon-plus')).toBeTruthy();
    });

    it('renders upload button when image is empty string', () => {
      render(<ImageUploadPreview {...defaultProps} image="" />);

      // Empty string is falsy, so it should show upload button
      expect(screen.getByTestId('icon-image')).toBeTruthy();
      expect(screen.getByTestId('icon-plus')).toBeTruthy();
    });

    it('renders with correct muted color from theme for light theme', () => {
      render(<ImageUploadPreview {...defaultProps} image={null} theme="light" />);

      const imageIcon = screen.getByTestId('icon-image');
      // Light theme icon color is '#6B7280' (from mocked Colors in jest.setup.js)
      expect(imageIcon.props['data-color']).toBe('#6B7280');
    });

    it('renders with correct muted color from theme for dark theme', () => {
      render(<ImageUploadPreview {...defaultProps} image={null} theme="dark" />);

      const imageIcon = screen.getByTestId('icon-image');
      // Dark theme icon color is '#9CA3AF' (from mocked Colors in jest.setup.js)
      expect(imageIcon.props['data-color']).toBe('#9CA3AF');
    });

    it('renders upload button with correct icons', () => {
      render(<ImageUploadPreview {...defaultProps} image={null} />);

      // Main image icon
      const imageIcon = screen.getByTestId('icon-image');
      expect(imageIcon.props['data-size']).toBe(20);

      // Plus icon inside container
      const plusIcon = screen.getByTestId('icon-plus');
      expect(plusIcon.props['data-size']).toBe(12);
    });
  });

  describe('Rendering - Image Preview State (with image)', () => {
    it('renders image preview when image exists', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="test-image.jpg" />
      );

      // Get Image component using UNSAFE API
      const images = UNSAFE_getAllByType(Image);
      expect(images.length).toBeGreaterThan(0);
    });

    it('renders remove button when image exists', () => {
      render(<ImageUploadPreview {...defaultProps} image="test-image.jpg" />);

      expect(screen.getByTestId('icon-x')).toBeTruthy();
    });

    it('does not render upload button when image exists', () => {
      render(<ImageUploadPreview {...defaultProps} image="test-image.jpg" />);

      expect(screen.queryByTestId('icon-image')).toBeNull();
      expect(screen.queryByTestId('icon-plus')).toBeNull();
    });

    it('renders remove button with x icon of size 14', () => {
      render(<ImageUploadPreview {...defaultProps} image="test-image.jpg" />);

      const xIcon = screen.getByTestId('icon-x');
      expect(xIcon.props['data-size']).toBe(14);
      expect(xIcon.props['data-color']).toBe('#fff');
    });
  });

  describe('Rendering - Loading State', () => {
    it('renders ActivityIndicator when uploading is true', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image={null} uploading={true} />
      );

      // Should have ActivityIndicator
      const indicators = UNSAFE_getAllByType(ActivityIndicator);
      expect(indicators.length).toBeGreaterThan(0);

      // Icons should not be present
      expect(screen.queryByTestId('icon-image')).toBeNull();
      expect(screen.queryByTestId('icon-plus')).toBeNull();
    });

    it('does not render ActivityIndicator when uploading is false', () => {
      const { UNSAFE_queryAllByType } = render(
        <ImageUploadPreview {...defaultProps} image={null} uploading={false} />
      );

      // Should show icons instead of ActivityIndicator
      expect(screen.getByTestId('icon-image')).toBeTruthy();
      expect(screen.getByTestId('icon-plus')).toBeTruthy();

      // No ActivityIndicator
      const indicators = UNSAFE_queryAllByType(ActivityIndicator);
      expect(indicators.length).toBe(0);
    });

    it('passes accent color to ActivityIndicator', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image={null} uploading={true} accentColor="#FF5733" />
      );

      const indicators = UNSAFE_getAllByType(ActivityIndicator);
      expect(indicators.length).toBeGreaterThan(0);
      // ActivityIndicator should receive the accent color
      expect(indicators[0].props.color).toBe('#FF5733');
    });
  });

  describe('Interaction - Upload Callback', () => {
    it('calls onUpload when upload button is pressed', () => {
      render(<ImageUploadPreview {...defaultProps} image={null} />);

      // Find the upload button (TouchableOpacity containing image icon)
      const uploadIcon = screen.getByTestId('icon-image');
      const uploadButton = uploadIcon.parent;

      expect(uploadButton).toBeTruthy();
      fireEvent.press(uploadButton);
      expect(mockOnUpload).toHaveBeenCalledTimes(1);
    });

    it('upload button is disabled when uploading', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image={null} uploading={true} />
      );

      // When uploading, the ActivityIndicator is shown inside TouchableOpacity
      const indicators = UNSAFE_getAllByType(ActivityIndicator);
      expect(indicators.length).toBeGreaterThan(0);

      // TouchableOpacity should have disabled prop set to true
      const touchable = indicators[0].parent;
      expect(touchable?.props.accessibilityState?.disabled).toBe(true);
    });

    it('upload button has activeOpacity 0.7', () => {
      const { UNSAFE_getAllByType } = render(<ImageUploadPreview {...defaultProps} image={null} />);

      const touchables = UNSAFE_getAllByType(TouchableOpacity);
      expect(touchables.length).toBeGreaterThan(0);

      const uploadTouchable = touchables[0];
      expect(uploadTouchable?.props.activeOpacity).toBe(0.7);
    });
  });

  describe('Interaction - Remove Callback', () => {
    it('calls onRemove when remove button is pressed', () => {
      render(<ImageUploadPreview {...defaultProps} image="test-image.jpg" />);

      const removeIcon = screen.getByTestId('icon-x');
      const removeButton = removeIcon.parent;

      expect(removeButton).toBeTruthy();
      fireEvent.press(removeButton);
      expect(mockOnRemove).toHaveBeenCalledTimes(1);
    });
  });

  describe('URL Construction', () => {
    it('constructs correct image URL with apiStaticUrl and image filename', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview
          {...defaultProps}
          image="my-photo.png"
          apiStaticUrl="http://api.example.com/uploads"
        />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images.length).toBeGreaterThan(0);
      expect(images[0].props.source.uri).toBe('http://api.example.com/uploads/my-photo.png');
    });

    it('constructs correct URL with different static URL', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview
          {...defaultProps}
          image="vacation/photo-123.jpg"
          apiStaticUrl="https://cdn.example.com/static"
        />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images[0].props.source.uri).toBe(
        'https://cdn.example.com/static/vacation/photo-123.jpg'
      );
    });

    it('handles image with leading slash', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview
          {...defaultProps}
          image="/uploads/image.png"
          apiStaticUrl="http://localhost:8000"
        />
      );

      const images = UNSAFE_getAllByType(Image);
      // The component just concatenates, so leading slash creates double slash
      expect(images[0].props.source.uri).toBe('http://localhost:8000//uploads/image.png');
    });

    it('handles simple filename', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview
          {...defaultProps}
          image="pic.jpg"
          apiStaticUrl="http://127.0.0.1:8080"
        />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images[0].props.source.uri).toBe('http://127.0.0.1:8080/pic.jpg');
    });

    it('sets resizeMode to cover', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="test.jpg" />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images[0].props.resizeMode).toBe('cover');
    });
  });

  describe('Edge Cases', () => {
    it('handles null image gracefully', () => {
      render(<ImageUploadPreview {...defaultProps} image={null} />);

      // Should render upload button state
      expect(screen.getByTestId('icon-image')).toBeTruthy();
      expect(screen.queryByTestId('icon-x')).toBeNull();
    });

    it('handles undefined-like falsy values', () => {
      // Test with empty string (falsy value)
      render(<ImageUploadPreview {...defaultProps} image="" />);

      // Empty string is falsy, should show upload button
      expect(screen.getByTestId('icon-image')).toBeTruthy();
      expect(screen.queryByTestId('icon-x')).toBeNull();
    });

    it('handles image filename with spaces', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="my photo.jpg" />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images[0].props.source.uri).toBe('http://localhost:8000/static/my photo.jpg');
    });

    it('handles image filename with special characters', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="photo%20test.jpg" />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images[0].props.source.uri).toBe('http://localhost:8000/static/photo%20test.jpg');
    });

    it('handles long image filename', () => {
      const longFilename = 'a'.repeat(200) + '.jpg';
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image={longFilename} />
      );

      const images = UNSAFE_getAllByType(Image);
      expect(images[0].props.source.uri).toBe(`http://localhost:8000/static/${longFilename}`);
    });

    it('handles various accent colors', () => {
      const colors = ['#FF0000', '#00FF00', '#0000FF', '#FFFFFF', '#000000'];

      colors.forEach((color) => {
        jest.clearAllMocks();
        const { UNSAFE_getAllByType } = render(
          <ImageUploadPreview {...defaultProps} uploading={true} accentColor={color} />
        );

        const indicators = UNSAFE_getAllByType(ActivityIndicator);
        expect(indicators.length).toBeGreaterThan(0);
        expect(indicators[0].props.color).toBe(color);
      });
    });

    it('handles remove button press with different image values', () => {
      const images = ['test.jpg', 'photo.png', 'image.gif', 'doc.webp'];

      images.forEach((img) => {
        jest.clearAllMocks();
        render(<ImageUploadPreview {...defaultProps} image={img} />);

        const removeIcon = screen.getByTestId('icon-x');
        const removeButton = removeIcon.parent;

        if (removeButton) {
          fireEvent.press(removeButton);
          expect(mockOnRemove).toHaveBeenCalled();
        }
      });
    });
  });

  describe('Props Integration', () => {
    it('renders correctly with all props provided', () => {
      const fullProps = {
        image: 'full-test.jpg',
        uploading: false,
        onUpload: mockOnUpload,
        onRemove: mockOnRemove,
        theme: 'dark',
        accentColor: '#FF5733',
        apiStaticUrl: 'https://cdn.example.com',
      };

      const { UNSAFE_getAllByType } = render(<ImageUploadPreview {...fullProps} />);

      const images = UNSAFE_getAllByType(Image);
      expect(images.length).toBeGreaterThan(0);
      expect(screen.getByTestId('icon-x')).toBeTruthy();
    });

    it('switches from preview to upload when image prop changes', () => {
      const { rerender, UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="test.jpg" />
      );

      let images = UNSAFE_getAllByType(Image);
      expect(images.length).toBeGreaterThan(0);

      rerender(<ImageUploadPreview {...defaultProps} image={null} />);

      // Should now show upload button
      expect(screen.getByTestId('icon-image')).toBeTruthy();
      expect(screen.queryByTestId('icon-x')).toBeNull();
    });

    it('switches from upload to preview when image prop changes', () => {
      const { rerender, UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image={null} />
      );

      expect(screen.getByTestId('icon-image')).toBeTruthy();

      rerender(<ImageUploadPreview {...defaultProps} image="new-image.png" />);

      // Should now show preview
      let images = UNSAFE_getAllByType(Image);
      expect(images.length).toBeGreaterThan(0);
      expect(screen.queryByTestId('icon-image')).toBeNull();
    });
  });

  describe('Styling - Dashed Border', () => {
    it('upload button has dashed border style', () => {
      const { UNSAFE_getAllByType } = render(<ImageUploadPreview {...defaultProps} image={null} />);

      const touchables = UNSAFE_getAllByType(TouchableOpacity);
      expect(touchables.length).toBeGreaterThan(0);

      const uploadTouchable = touchables[0];
      const styles = uploadTouchable?.props.style;
      let hasDashed = false;

      if (Array.isArray(styles)) {
        hasDashed = styles.some((s: any) => s?.borderStyle === 'dashed');
      } else if (styles?.borderStyle === 'dashed') {
        hasDashed = true;
      }

      expect(hasDashed).toBe(true);
    });
  });

  describe('Styling - Theme Background Colors', () => {
    it('preview container has light theme background color', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="test.jpg" theme="light" />
      );

      const images = UNSAFE_getAllByType(Image);
      const container = images[0].parent;
      const styles = container?.props.style;

      let hasLightBg = false;
      if (Array.isArray(styles)) {
        hasLightBg = styles.some((s: any) => s?.backgroundColor === '#F0F0F2');
      } else if (styles?.backgroundColor === '#F0F0F2') {
        hasLightBg = true;
      }

      expect(hasLightBg).toBe(true);
    });

    it('preview container has dark theme background color', () => {
      const { UNSAFE_getAllByType } = render(
        <ImageUploadPreview {...defaultProps} image="test.jpg" theme="dark" />
      );

      const images = UNSAFE_getAllByType(Image);
      const container = images[0].parent;
      const styles = container?.props.style;

      let hasDarkBg = false;
      if (Array.isArray(styles)) {
        hasDarkBg = styles.some((s: any) => s?.backgroundColor === '#2A2C30');
      } else if (styles?.backgroundColor === '#2A2C30') {
        hasDarkBg = true;
      }

      expect(hasDarkBg).toBe(true);
    });
  });

  describe('Styling - Container', () => {
    it('renders with correct container margins', () => {
      const { UNSAFE_getAllByType } = render(<ImageUploadPreview {...defaultProps} image={null} />);

      // Get the root View (container)
      const rootView = UNSAFE_getAllByType(View)[0];
      const styles = rootView?.props.style;

      let hasCorrectMargins = false;
      if (Array.isArray(styles)) {
        hasCorrectMargins = styles.some((s: any) => s?.marginTop === 24 && s?.marginBottom === 0);
      } else if (styles?.marginTop === 24) {
        hasCorrectMargins = true;
      }

      expect(hasCorrectMargins).toBe(true);
    });
  });
});
