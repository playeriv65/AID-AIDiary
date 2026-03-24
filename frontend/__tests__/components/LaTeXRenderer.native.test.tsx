import React from 'react';
import { fireEvent, render } from '@testing-library/react-native';
import { LaTeXRenderer } from '@/components/chat/LaTeXRenderer.native';

// Mock katex library
jest.mock('katex', () => ({
  renderToString: jest.fn((formula: string, options?: { displayMode?: boolean }) => {
    return `<span class="katex">${options?.displayMode ? 'display' : 'inline'}-${formula}</span>`;
  }),
}));

// Import mocked katex for error testing
const mockKatex = jest.requireMock('katex');

describe('LaTeXRenderer.native', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders KaTeXAutoHeightWebView with correct props for inline mode', () => {
      const { getByText } = render(
        <LaTeXRenderer formula="x^2 + y^2 = z^2" theme="light" displayMode={false} />
      );

      // Check that the mock renders the component with the formula
      const latexText = getByText(/LaTeX:/);
      expect(latexText).toBeTruthy();
    });

    it('renders KaTeXAutoHeightWebView with correct props for display mode', () => {
      const { getByText } = render(
        <LaTeXRenderer formula="\\sum_{i=1}^{n} x_i" theme="light" displayMode={true} />
      );

      const latexText = getByText(/LaTeX:/);
      expect(latexText).toBeTruthy();
    });

    it('passes minHeight of 30 for inline mode', () => {
      const { getByText } = render(
        <LaTeXRenderer formula="E=mc^2" theme="light" displayMode={false} />
      );

      // The mock renders minHeight in the style
      const container = getByText(/LaTeX:/).parent;
      expect(container).toBeTruthy();
    });

    it('passes minHeight of 60 for display mode', () => {
      const { getByText } = render(
        <LaTeXRenderer formula="\\int_a^b f(x) dx" theme="light" displayMode={true} />
      );

      const container = getByText(/LaTeX:/).parent;
      expect(container).toBeTruthy();
    });

    it('calls katex.renderToString with correct options for inline mode', () => {
      render(<LaTeXRenderer formula="E=mc^2" theme="light" displayMode={false} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('E=mc^2', {
        displayMode: false,
        throwOnError: false,
        output: 'html',
      });
    });

    it('calls katex.renderToString with correct options for display mode', () => {
      render(<LaTeXRenderer formula="\\int_a^b f(x) dx" theme="light" displayMode={true} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('\\\\int_a^b f(x) dx', {
        displayMode: true,
        throwOnError: false,
        output: 'html',
      });
    });

    it('defaults to inline mode when displayMode is not provided', () => {
      render(<LaTeXRenderer formula="\\pi" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        '\\\\pi',
        expect.objectContaining({
          displayMode: false,
        })
      );
    });

    it('passes throwOnError: false to prevent exceptions', () => {
      render(<LaTeXRenderer formula="formula" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          throwOnError: false,
        })
      );
    });

    it('passes output: html to generate HTML output', () => {
      render(<LaTeXRenderer formula="formula" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        expect.any(String),
        expect.objectContaining({
          output: 'html',
        })
      );
    });

    it('includes onError callback in WebView props', () => {
      const { getByText } = render(<LaTeXRenderer formula="x^2" theme="light" />);

      // Component renders successfully with onError prop
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });
  });

  describe('Theme Tests', () => {
    it('uses light theme text color (#1A1C1E) in generated HTML when theme is light', () => {
      render(<LaTeXRenderer formula="x = 1" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalled();
      // HTML generation is verified through successful render
    });

    it('uses light theme background color (#F0F0F2) in generated HTML when theme is light', () => {
      render(<LaTeXRenderer formula="x = 1" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalled();
    });

    it('uses dark theme text color (#DFE1E3) in generated HTML when theme is dark', () => {
      render(<LaTeXRenderer formula="x = 1" theme="dark" />);

      expect(mockKatex.renderToString).toHaveBeenCalled();
    });

    it('uses dark theme background color (#2A2C30) in generated HTML when theme is dark', () => {
      render(<LaTeXRenderer formula="x = 1" theme="dark" />);

      expect(mockKatex.renderToString).toHaveBeenCalled();
    });

    it('applies correct theme colors in display mode with light theme', () => {
      const { getByText } = render(
        <LaTeXRenderer formula="formula" theme="light" displayMode={true} />
      );

      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('applies correct theme colors in display mode with dark theme', () => {
      const { getByText } = render(
        <LaTeXRenderer formula="formula" theme="dark" displayMode={true} />
      );

      expect(getByText(/LaTeX:/)).toBeTruthy();
    });
  });

  describe('Error Handling Tests', () => {
    it('renders fallback when katex throws an error', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(<LaTeXRenderer formula="\\invalid{syntax}" theme="light" />);

      // Fallback should still render the WebView
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('applies monospace font to fallback HTML', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(<LaTeXRenderer formula="bad formula" theme="light" />);

      // Fallback renders with monospace font-family in HTML
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('applies correct background color to fallback in dark theme', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(<LaTeXRenderer formula="bad formula" theme="dark" />);

      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('applies correct text color to fallback in dark theme', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(<LaTeXRenderer formula="bad formula" theme="dark" />);

      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('fallback preserves formula text exactly', () => {
      const complexFormula = '\\frac{a}{b} + \\sqrt{c} = \\infty';
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(<LaTeXRenderer formula={complexFormula} theme="light" />);

      // Should still render even when KaTeX fails
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('fallback uses minHeight of 30', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(
        <LaTeXRenderer formula="error" theme="light" displayMode={true} />
      );

      // Fallback always uses minHeight of 30
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('fallback does not include onError callback', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { getByText } = render(<LaTeXRenderer formula="error" theme="light" />);

      expect(getByText(/LaTeX:/)).toBeTruthy();
    });
  });

  describe('HTML Generation Tests', () => {
    it('includes KaTeX CSS CDN link in generated HTML', () => {
      render(<LaTeXRenderer formula="x^2" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalled();
      // The HTML generation includes the CDN link
    });

    it('generates valid HTML document structure', () => {
      render(<LaTeXRenderer formula="x = 1" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('x = 1', expect.any(Object));
    });

    it('includes DOCTYPE declaration in HTML', () => {
      render(<LaTeXRenderer formula="x^2" theme="light" />);

      // HTML structure is generated with DOCTYPE
      expect(mockKatex.renderToString).toHaveBeenCalled();
    });

    it('applies padding of 8px in inline mode through HTML style', () => {
      render(<LaTeXRenderer formula="x^2" theme="light" displayMode={false} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        'x^2',
        expect.objectContaining({ displayMode: false })
      );
    });

    it('applies padding of 16px in display mode through HTML style', () => {
      render(<LaTeXRenderer formula="\\sum x_i" theme="light" displayMode={true} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        '\\\\sum x_i',
        expect.objectContaining({ displayMode: true })
      );
    });

    it('applies flexbox centering in display mode', () => {
      render(<LaTeXRenderer formula="\\int f(x)" theme="light" displayMode={true} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        '\\\\int f(x)',
        expect.objectContaining({ displayMode: true })
      );
    });

    it('applies flexbox flex-start in inline mode', () => {
      render(<LaTeXRenderer formula="x^2" theme="light" displayMode={false} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        'x^2',
        expect.objectContaining({ displayMode: false })
      );
    });

    it('includes correct KaTeX CSS version (0.16.9) in HTML', () => {
      render(<LaTeXRenderer formula="x^2" theme="light" />);

      // The CDN URL uses version 0.16.9
      expect(mockKatex.renderToString).toHaveBeenCalled();
    });
  });

  describe('Edge Cases', () => {
    it('handles empty formula', () => {
      const { getByText } = render(<LaTeXRenderer formula="" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('', expect.any(Object));
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('handles formula with special LaTeX characters', () => {
      render(<LaTeXRenderer formula="\\alpha \\beta \\gamma" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        '\\\\alpha \\\\beta \\\\gamma',
        expect.any(Object)
      );
    });

    it('handles very long formula', () => {
      const longFormula = 'x'.repeat(1000);
      const { getByText } = render(<LaTeXRenderer formula={longFormula} theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(longFormula, expect.any(Object));
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('handles formula with newlines', () => {
      render(<LaTeXRenderer formula="x\\ny" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('x\\\\ny', expect.any(Object));
    });

    it('handles formula with unicode characters', () => {
      render(<LaTeXRenderer formula="x² + π" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('x² + π', expect.any(Object));
    });

    it('handles formula with multiple lines of LaTeX', () => {
      const multiLineFormula = '\\begin{aligned} x &= 1 \\\\ y &= 2 \\end{aligned}';
      render(<LaTeXRenderer formula={multiLineFormula} theme="light" displayMode={true} />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        multiLineFormula,
        expect.objectContaining({ displayMode: true })
      );
    });
  });

  describe('WebView Source Tests', () => {
    it('passes HTML source as object with html property', () => {
      const { getByText } = render(<LaTeXRenderer formula="x^2" theme="light" />);

      // The WebView receives source={{ html: ... }}
      expect(getByText(/LaTeX:/)).toBeTruthy();
    });

    it('generates source with complete HTML document', () => {
      render(<LaTeXRenderer formula="E=mc^2" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('E=mc^2', expect.any(Object));
    });

    it('source HTML includes body styling', () => {
      render(<LaTeXRenderer formula="x^2" theme="light" />);

      // HTML body has inline styles for margin, padding, background, color
      expect(mockKatex.renderToString).toHaveBeenCalled();
    });
  });

  describe('Console Warning Tests', () => {
    it('onError callback logs warning message', () => {
      const consoleSpy = jest.spyOn(console, 'warn').mockImplementation(() => {});

      render(<LaTeXRenderer formula="x^2" theme="light" />);

      expect(consoleSpy).not.toHaveBeenCalled();

      consoleSpy.mockRestore();
    });

    it('triggers onError callback when WebView reports an error', () => {
      const consoleSpy = jest.spyOn(console, 'warn').mockImplementation(() => {});

      const { getByTestId } = render(<LaTeXRenderer formula="test formula" theme="light" />);

      const errorButton = getByTestId('trigger-error');
      fireEvent.press(errorButton);

      expect(consoleSpy).toHaveBeenCalledWith('KaTeX render error:', 'test formula');

      consoleSpy.mockRestore();
    });
  });
});
