import React from 'react';
import { render } from '@testing-library/react-native';
import { LaTeXRenderer } from '@/components/chat/LaTeXRenderer.web';

// Mock katex library
jest.mock('katex', () => ({
  renderToString: jest.fn((formula: string, options?: { displayMode?: boolean }) => {
    return `<span class="katex">${options?.displayMode ? 'display' : 'inline'}-${formula}</span>`;
  }),
}));

// Import mocked katex for error testing
const mockKatex = jest.requireMock('katex');

describe('LaTeXRenderer', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders valid LaTeX formula in inline mode', () => {
      const { UNSAFE_getByType } = render(
        <LaTeXRenderer formula="x^2 + y^2 = z^2" theme="light" displayMode={false} />
      );

      const div = UNSAFE_getByType('div');
      expect(div.props.dangerouslySetInnerHTML).toBeDefined();
      expect(div.props.dangerouslySetInnerHTML.__html).toContain('inline-x^2 + y^2 = z^2');
    });

    it('renders valid LaTeX formula in display mode', () => {
      const { UNSAFE_getByType } = render(
        <LaTeXRenderer formula="\\sum_{i=1}^{n} x_i" theme="light" displayMode={true} />
      );

      const div = UNSAFE_getByType('div');
      expect(div.props.dangerouslySetInnerHTML).toBeDefined();
      expect(div.props.dangerouslySetInnerHTML.__html).toContain('display-\\\\sum_{i=1}^{n} x_i');
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
  });

  describe('Theme Tests', () => {
    it('uses light theme text color (#1A1C1E) when theme is light', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x = 1" theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.color).toBe('#1A1C1E');
    });

    it('uses light theme background color (#F0F0F2) when theme is light', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x = 1" theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.backgroundColor).toBe('#F0F0F2');
    });

    it('uses dark theme text color (#DFE1E3) when theme is dark', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x = 1" theme="dark" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.color).toBe('#DFE1E3');
    });

    it('uses dark theme background color (#2A2C30) when theme is dark', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x = 1" theme="dark" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.backgroundColor).toBe('#2A2C30');
    });

    it('applies correct theme colors in display mode', () => {
      const { UNSAFE_getByType } = render(
        <LaTeXRenderer formula="formula" theme="dark" displayMode={true} />
      );

      const div = UNSAFE_getByType('div');
      expect(div.props.style.color).toBe('#DFE1E3');
      expect(div.props.style.backgroundColor).toBe('#2A2C30');
    });
  });

  describe('Error Handling Tests', () => {
    it('renders fallback when katex throws an error', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { UNSAFE_getByType } = render(
        <LaTeXRenderer formula="\\invalid{syntax}" theme="light" />
      );

      const div = UNSAFE_getByType('div');
      // Should not have dangerouslySetInnerHTML in fallback
      expect(div.props.dangerouslySetInnerHTML).toBeUndefined();
      // Should render the original formula text
      expect(div.props.children).toBe('\\\\invalid{syntax}');
    });

    it('applies monospace font to fallback rendering', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="bad formula" theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.fontFamily).toBe('monospace');
    });

    it('applies correct background color to fallback in dark theme', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="bad formula" theme="dark" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.backgroundColor).toBe('#2A2C30');
    });

    it('applies correct text color to fallback in dark theme', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="bad formula" theme="dark" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.color).toBe('#DFE1E3');
    });

    it('fallback preserves formula text exactly', () => {
      const complexFormula = '\\frac{a}{b} + \\sqrt{c} = \\infty';
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { UNSAFE_getByType } = render(<LaTeXRenderer formula={complexFormula} theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.children).toBe(complexFormula);
    });

    it('fallback handles displayMode parameter', () => {
      mockKatex.renderToString.mockImplementationOnce(() => {
        throw new Error('KaTeX parse error');
      });

      const { UNSAFE_getByType } = render(
        <LaTeXRenderer formula="error" theme="light" displayMode={true} />
      );

      const div = UNSAFE_getByType('div');
      expect(div.props.style.textAlign).toBe('center');
      expect(div.props.style.padding).toBe(16);
    });
  });

  describe('Style Tests', () => {
    it('applies borderRadius of 8', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x" theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.borderRadius).toBe(8);
    });

    it('applies overflowX auto for horizontal scrolling', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x" theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.style.overflowX).toBe('auto');
    });

    describe('Padding Tests', () => {
      it('applies padding 8 in inline mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={false} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.padding).toBe(8);
      });

      it('applies padding 16 in display mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={true} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.padding).toBe(16);
      });
    });

    describe('Font Size Tests', () => {
      it('applies fontSize 14px in inline mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={false} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.fontSize).toBe('14px');
      });

      it('applies fontSize 18px in display mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={true} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.fontSize).toBe('18px');
      });
    });

    describe('Text Alignment Tests', () => {
      it('applies textAlign left in inline mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={false} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.textAlign).toBe('left');
      });

      it('applies textAlign center in display mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={true} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.textAlign).toBe('center');
      });
    });

    describe('Margin Tests', () => {
      it('applies marginVertical 2 in inline mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={false} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.marginVertical).toBe(2);
      });

      it('applies marginVertical 8 in display mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={true} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.marginVertical).toBe(8);
      });
    });

    describe('Flexbox Tests', () => {
      it('applies flex display in rendered mode', () => {
        const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x" theme="light" />);

        const div = UNSAFE_getByType('div');
        expect(div.props.style.display).toBe('flex');
      });

      it('applies justifyContent flex-start in inline mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={false} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.justifyContent).toBe('flex-start');
      });

      it('applies justifyContent center in display mode', () => {
        const { UNSAFE_getByType } = render(
          <LaTeXRenderer formula="x" theme="light" displayMode={true} />
        );

        const div = UNSAFE_getByType('div');
        expect(div.props.style.justifyContent).toBe('center');
      });

      it('applies alignItems center', () => {
        const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x" theme="light" />);

        const div = UNSAFE_getByType('div');
        expect(div.props.style.alignItems).toBe('center');
      });
    });

    describe('Fallback Style Tests', () => {
      it('fallback does not have flex display', () => {
        mockKatex.renderToString.mockImplementationOnce(() => {
          throw new Error('KaTeX parse error');
        });

        const { UNSAFE_getByType } = render(<LaTeXRenderer formula="error" theme="light" />);

        const div = UNSAFE_getByType('div');
        expect(div.props.style.display).toBeUndefined();
      });

      it('fallback has borderRadius 8', () => {
        mockKatex.renderToString.mockImplementationOnce(() => {
          throw new Error('KaTeX parse error');
        });

        const { UNSAFE_getByType } = render(<LaTeXRenderer formula="error" theme="light" />);

        const div = UNSAFE_getByType('div');
        expect(div.props.style.borderRadius).toBe(8);
      });
    });
  });

  describe('Edge Cases', () => {
    it('handles empty formula', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="" theme="light" />);

      const div = UNSAFE_getByType('div');
      expect(div.props.dangerouslySetInnerHTML).toBeDefined();
    });

    it('handles formula with special characters', () => {
      const { UNSAFE_getByType } = render(
        <LaTeXRenderer formula="\\alpha \\beta \\gamma" theme="light" />
      );

      expect(mockKatex.renderToString).toHaveBeenCalledWith(
        '\\\\alpha \\\\beta \\\\gamma',
        expect.any(Object)
      );
    });

    it('handles very long formula', () => {
      const longFormula = 'x'.repeat(1000);
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula={longFormula} theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith(longFormula, expect.any(Object));
    });

    it('handles formula with newlines', () => {
      const { UNSAFE_getByType } = render(<LaTeXRenderer formula="x\\ny" theme="light" />);

      expect(mockKatex.renderToString).toHaveBeenCalledWith('x\\\\ny', expect.any(Object));
    });
  });
});
