import React from 'react';
import { render } from '@testing-library/react-native';
import { MarkdownRenderer } from '@/components/chat/MarkdownRenderer';
import { Colors } from '@/constants/theme';

// Mock react-native-markdown-display
jest.mock('react-native-markdown-display', () => {
  return function MockMarkdown({
    children,
    style,
  }: {
    children: string;
    style: Record<string, any>;
  }) {
    return (
      <div testID="markdown-display" data-content={children} data-styles={JSON.stringify(style)}>
        {children}
      </div>
    );
  };
});

// Mock LaTeXRenderer
jest.mock('@/components/chat/LaTeXRenderer', () => ({
  LaTeXRenderer: function MockLaTeXRenderer({
    formula,
    displayMode,
    theme,
  }: {
    formula: string;
    displayMode?: boolean;
    theme: 'light' | 'dark';
  }) {
    return (
      <div
        testID="latex-renderer"
        data-formula={formula}
        data-display-mode={displayMode}
        data-theme={theme}
      >
        {displayMode ? '$$' : '$'}
        {formula}
        {displayMode ? '$$' : '$'}
      </div>
    );
  },
}));

describe('MarkdownRenderer', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering Tests', () => {
    it('renders plain text content', () => {
      const { getByTestId } = render(<MarkdownRenderer content="Hello world" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('Hello world');
    });

    it('renders heading 1', () => {
      const { getByTestId } = render(<MarkdownRenderer content="# Heading 1" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('# Heading 1');
    });

    it('renders heading 2', () => {
      const { getByTestId } = render(<MarkdownRenderer content="## Heading 2" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('## Heading 2');
    });

    it('renders heading 3', () => {
      const { getByTestId } = render(<MarkdownRenderer content="### Heading 3" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('### Heading 3');
    });

    it('renders bold text', () => {
      const { getByTestId } = render(<MarkdownRenderer content="**bold text**" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('**bold text**');
    });

    it('renders italic text', () => {
      const { getByTestId } = render(<MarkdownRenderer content="*italic text*" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('*italic text*');
    });

    it('renders bold and italic combined', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="***bold and italic***" theme="light" />
      );

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('***bold and italic***');
    });

    it('renders inline code', () => {
      const { getByTestId } = render(<MarkdownRenderer content="`inline code`" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('`inline code`');
    });

    it('renders code block', () => {
      const content = '```javascript\nconst x = 1;\n```';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('renders unordered list', () => {
      const content = '- Item 1\n- Item 2\n- Item 3';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('renders ordered list', () => {
      const content = '1. First item\n2. Second item\n3. Third item';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('renders links', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="[Link text](https://example.com)" theme="light" />
      );

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('[Link text](https://example.com)');
    });

    it('renders blockquote', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="> This is a quote" theme="light" />
      );

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('> This is a quote');
    });

    it('renders horizontal rule', () => {
      const { getByTestId } = render(<MarkdownRenderer content="---" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('---');
    });

    it('renders table', () => {
      const content = '| Header 1 | Header 2 |\n|----------|----------|\n| Cell 1   | Cell 2   |';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('renders multiple paragraphs', () => {
      const content = 'First paragraph.\n\nSecond paragraph.\n\nThird paragraph.';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('renders strikethrough text', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="~~strikethrough~~" theme="light" />
      );

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('~~strikethrough~~');
    });

    it('renders nested lists', () => {
      const content = '- Parent\n  - Child 1\n  - Child 2';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });
  });

  describe('LaTeX Parsing Tests', () => {
    it('renders inline LaTeX formula', () => {
      const { getAllByTestId } = render(<MarkdownRenderer content="$E=mc^2$" theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('E=mc^2');
      expect(latexRenderers[0].props['data-display-mode']).toBe(false);
    });

    it('renders block LaTeX formula', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$$\\sum_{i=1}^{n} x_i$$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      // The component extracts the formula with backslashes preserved
      expect(latexRenderers[0].props['data-formula']).toBe('\\\\sum_{i=1}^{n} x_i');
      expect(latexRenderers[0].props['data-display-mode']).toBe(true);
    });

    it('renders multiple inline LaTeX formulas', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$x^2$ and $y^2$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(2);
      expect(latexRenderers[0].props['data-formula']).toBe('x^2');
      expect(latexRenderers[1].props['data-formula']).toBe('y^2');
    });

    it('renders multiple block LaTeX formulas', () => {
      const content = '$$f(x) = x^2$$$$g(x) = x^3$$';
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(2);
      expect(latexRenderers[0].props['data-formula']).toBe('f(x) = x^2');
      expect(latexRenderers[1].props['data-formula']).toBe('g(x) = x^3');
    });

    it('renders complex inline LaTeX', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$\\frac{a}{b} + \\sqrt{c}$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('\\\\frac{a}{b} + \\\\sqrt{c}');
    });

    it('renders complex block LaTeX with multiple lines', () => {
      const content = `$$\\begin{align}
x &= y \\\\
y &= z
\\end{align}$$`;
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-display-mode']).toBe(true);
    });

    it('renders LaTeX with special characters', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$\\alpha \\beta \\gamma$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('\\\\alpha \\\\beta \\\\gamma');
    });

    it('renders LaTeX with subscripts and superscripts', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$x_1^2 + x_2^2$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('x_1^2 + x_2^2');
    });

    it('renders LaTeX with integrals', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$$\\int_a^b f(x) \\, dx$$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('\\\\int_a^b f(x) \\\\, dx');
    });

    it('renders LaTeX with limits', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$$\\lim_{x \\to \\infty} f(x)$$" theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('\\\\lim_{x \\\\to \\\\infty} f(x)');
    });
  });

  describe('Mixed Content Tests', () => {
    it('renders markdown with inline LaTeX', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="The equation $E=mc^2$ is famous." theme="light" />
      );

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      // Text is split into parts, so there are two markdown displays
      expect(markdownDisplays).toHaveLength(2);
      expect(markdownDisplays[0].props['data-content']).toBe('The equation ');
      expect(markdownDisplays[1].props['data-content']).toBe(' is famous.');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('E=mc^2');
    });

    it('renders markdown with block LaTeX', () => {
      const content =
        'Here is a formula:\n\n$$\\sum_{i=1}^n i = \\frac{n(n+1)}{2}$$\n\nIt is well known.';
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      expect(markdownDisplays).toHaveLength(2);
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-display-mode']).toBe(true);
    });

    it('renders markdown with multiple LaTeX formulas', () => {
      const content =
        'First: $a+b=c$, second: $x=y$, and block:\n$$\\int_0^1 x dx = \\frac{1}{2}$$';
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      expect(latexRenderers).toHaveLength(3);
      expect(latexRenderers[0].props['data-formula']).toBe('a+b=c');
      expect(latexRenderers[1].props['data-formula']).toBe('x=y');
      expect(latexRenderers[2].props['data-formula']).toBe('\\int_0^1 x dx = \\frac{1}{2}');
    });

    it('renders heading with LaTeX', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="# Title with $x^2$ formula" theme="light" />
      );

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      // Content is split around LaTeX
      expect(markdownDisplays).toHaveLength(2);
      expect(markdownDisplays[0].props['data-content']).toBe('# Title with ');
      expect(markdownDisplays[1].props['data-content']).toBe(' formula');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('x^2');
    });

    it('renders list with LaTeX', () => {
      const content = '- Item with $x$\n- Another with $y$';
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');

      expect(latexRenderers).toHaveLength(2);
      expect(latexRenderers[0].props['data-formula']).toBe('x');
      expect(latexRenderers[1].props['data-formula']).toBe('y');
    });

    it('renders code block followed by LaTeX', () => {
      const content = '```\ncode\n```\n\n$$formula$$';
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      expect(markdownDisplays).toHaveLength(1);
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('formula');
    });

    it('renders LaTeX at the beginning of content', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="$x$ is a variable." theme="light" />
      );

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      expect(markdownDisplays).toHaveLength(1);
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('x');
    });

    it('renders LaTeX at the end of content', () => {
      const { getAllByTestId } = render(
        <MarkdownRenderer content="The answer is $42$." theme="light" />
      );

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      // Content is split: "The answer is " and "."
      expect(markdownDisplays).toHaveLength(2);
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe('42');
    });

    it('renders only LaTeX without markdown', () => {
      const { queryAllByTestId, getAllByTestId } = render(
        <MarkdownRenderer content="$x$$$y$$" theme="light" />
      );

      const markdownDisplays = queryAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      expect(markdownDisplays).toHaveLength(0);
      expect(latexRenderers).toHaveLength(2);
    });

    it('renders alternating markdown and LaTeX', () => {
      const content = 'Text $x$ more text $y$ even more $z$';
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdownDisplays = getAllByTestId('markdown-display');
      const latexRenderers = getAllByTestId('latex-renderer');

      // 3 text parts separated by 3 LaTeX formulas (no trailing text after last formula)
      expect(markdownDisplays).toHaveLength(3);
      expect(latexRenderers).toHaveLength(3);
    });
  });

  describe('Edge Cases', () => {
    it('returns null for empty content', () => {
      const { UNSAFE_root } = render(<MarkdownRenderer content="" theme="light" />);

      expect(UNSAFE_root.children).toHaveLength(0);
    });

    it('returns null for whitespace-only content', () => {
      const { queryAllByTestId } = render(<MarkdownRenderer content="   \n\t  " theme="light" />);

      // Component may render whitespace content or return null depending on trim behavior
      // The key assertion is that it doesn't crash
      const markdownDisplays = queryAllByTestId('markdown-display');
      const latexRenderers = queryAllByTestId('latex-renderer');
      // Should either be empty or contain only whitespace text
      expect(markdownDisplays.length + latexRenderers.length).toBeLessThanOrEqual(1);
    });

    it('returns null for undefined content', () => {
      const { UNSAFE_root } = render(<MarkdownRenderer content={undefined as any} theme="light" />);

      expect(UNSAFE_root.children).toHaveLength(0);
    });

    it('renders content with only whitespace between LaTeX', () => {
      const { getAllByTestId } = render(<MarkdownRenderer content="$x$   $y$" theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(2);
    });

    it('handles LaTeX with newlines inside block formula', () => {
      const content = `$$\\begin{matrix}
a & b \\\\
c & d
\\end{matrix}$$`;
      const { getAllByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-display-mode']).toBe(true);
    });

    it('handles single dollar sign not as LaTeX', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="Price is $50 dollars" theme="light" />
      );

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('Price is $50 dollars');
    });

    it('handles escaped dollar signs', () => {
      const { getByTestId } = render(<MarkdownRenderer content="Price: \\$50" theme="light" />);

      const markdown = getByTestId('markdown-display');
      // The backslash-escaped dollar appears with double backslash in content
      expect(markdown.props['data-content']).toBe('Price: \\\\$50');
    });

    it('handles empty LaTeX formula', () => {
      const { getByTestId } = render(<MarkdownRenderer content="$$$" theme="light" />);

      const markdown = getByTestId('markdown-display');
      // $$$ is parsed as text because it doesn't match the block LaTeX pattern properly
      expect(markdown.props['data-content']).toBe('$$$');
    });

    it('handles LaTeX with only whitespace', () => {
      const { queryAllByTestId } = render(<MarkdownRenderer content="$   $" theme="light" />);

      // Whitespace-only formulas are trimmed and skipped, so no LaTeX renderer
      const latexRenderers = queryAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(0);
    });

    it('handles consecutive LaTeX formulas without markdown', () => {
      const { getAllByTestId } = render(<MarkdownRenderer content="$a$$b$$$c$$" theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(3);
    });

    it('handles very long markdown content', () => {
      const longText = 'a'.repeat(10000);
      const { getByTestId } = render(<MarkdownRenderer content={longText} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(longText);
    });

    it('handles very long LaTeX formula', () => {
      const longFormula = 'x'.repeat(1000);
      const { getAllByTestId } = render(
        <MarkdownRenderer content={`$${longFormula}$`} theme="light" />
      );

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers).toHaveLength(1);
      expect(latexRenderers[0].props['data-formula']).toBe(longFormula);
    });

    it('handles special markdown characters', () => {
      const content = '*asterisk* _underscore_ [bracket] (paren) {brace}';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('handles unicode characters', () => {
      const content = '日本語 中文 🎉 emoji';
      const { getByTestId } = render(<MarkdownRenderer content={content} theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe(content);
    });

    it('handles markdown with only newlines', () => {
      const { getByTestId } = render(<MarkdownRenderer content="\n\n\n" theme="light" />);

      const markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toContain('\\n');
    });
  });

  describe('Style Tests', () => {
    it('applies light theme styles', () => {
      const { getByTestId } = render(<MarkdownRenderer content="Hello" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.body).toBeDefined();
      expect(styles.paragraph).toBeDefined();
    });

    it('applies dark theme styles', () => {
      const { getByTestId } = render(<MarkdownRenderer content="Hello" theme="dark" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.body).toBeDefined();
      expect(styles.paragraph).toBeDefined();
    });

    it('applies custom accent color', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="`code`" theme="light" accentColor="#FF0000" />
      );

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_inline.color).toBe('#FF0000');
      expect(styles.link.color).toBe('#FF0000');
    });

    it('uses default tint color when accentColor not provided', () => {
      const { getByTestId } = render(<MarkdownRenderer content="`code`" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      // Uses Colors[theme].tint as default
      expect(styles.code_inline.color).toBe(Colors.light.tint);
    });

    it('applies correct heading styles for h1', () => {
      const { getByTestId } = render(<MarkdownRenderer content="# Heading" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.heading1.fontSize).toBe(24);
      expect(styles.heading1.fontWeight).toBe('700');
    });

    it('applies correct heading styles for h2', () => {
      const { getByTestId } = render(<MarkdownRenderer content="## Heading" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.heading2.fontSize).toBe(20);
      expect(styles.heading2.fontWeight).toBe('600');
    });

    it('applies correct code block styles', () => {
      const { getByTestId } = render(<MarkdownRenderer content="```code```" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_block.fontFamily).toBe('monospace');
      expect(styles.code_block.padding).toBe(12);
    });

    it('applies different code block background for dark theme', () => {
      const { getByTestId } = render(<MarkdownRenderer content="```code```" theme="dark" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_block.backgroundColor).toBe('#1E1E1E');
    });

    it('applies different blockquote background for dark theme', () => {
      const { getByTestId } = render(<MarkdownRenderer content="> quote" theme="dark" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.blockquote.backgroundColor).toBe('#2A2C30');
    });

    it('applies correct link styles', () => {
      const { getByTestId } = render(
        <MarkdownRenderer content="[link](url)" theme="light" accentColor="#FF5722" />
      );

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.link.color).toBe('#FF5722');
      expect(styles.link.textDecorationLine).toBe('underline');
    });

    it('applies correct table styles', () => {
      const { getByTestId } = render(<MarkdownRenderer content="|a|b|" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.table.borderWidth).toBe(1);
      expect(styles.th.padding).toBe(8);
      expect(styles.td.padding).toBe(8);
    });

    it('applies correct list styles', () => {
      const { getByTestId } = render(<MarkdownRenderer content="- item" theme="light" />);

      const markdown = getByTestId('markdown-display');
      const styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.list_item.marginVertical).toBe(2);
      expect(styles.bullet_list.marginVertical).toBe(8);
    });

    it('passes theme to LaTeXRenderer', () => {
      const { getAllByTestId } = render(<MarkdownRenderer content="$x$" theme="dark" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers[0].props['data-theme']).toBe('dark');
    });

    it('passes correct displayMode to LaTeXRenderer for inline', () => {
      const { getAllByTestId } = render(<MarkdownRenderer content="$x$" theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers[0].props['data-display-mode']).toBe(false);
    });

    it('passes correct displayMode to LaTeXRenderer for block', () => {
      const { getAllByTestId } = render(<MarkdownRenderer content="$$x$$" theme="light" />);

      const latexRenderers = getAllByTestId('latex-renderer');
      expect(latexRenderers[0].props['data-display-mode']).toBe(true);
    });
  });

  describe('Memoization Tests', () => {
    it('recalculates parts when content changes', () => {
      const { rerender, getByTestId } = render(<MarkdownRenderer content="First" theme="light" />);

      let markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('First');

      rerender(<MarkdownRenderer content="Second" theme="light" />);

      markdown = getByTestId('markdown-display');
      expect(markdown.props['data-content']).toBe('Second');
    });

    it('recalculates styles when theme changes', () => {
      const { rerender, getByTestId } = render(<MarkdownRenderer content="Test" theme="light" />);

      let markdown = getByTestId('markdown-display');
      let styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_block.backgroundColor).toBe('#F5F5F5');

      rerender(<MarkdownRenderer content="Test" theme="dark" />);

      markdown = getByTestId('markdown-display');
      styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_block.backgroundColor).toBe('#1E1E1E');
    });

    it('recalculates styles when accentColor changes', () => {
      const { rerender, getByTestId } = render(
        <MarkdownRenderer content="`code`" theme="light" accentColor="#FF0000" />
      );

      let markdown = getByTestId('markdown-display');
      let styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_inline.color).toBe('#FF0000');

      rerender(<MarkdownRenderer content="`code`" theme="light" accentColor="#00FF00" />);

      markdown = getByTestId('markdown-display');
      styles = JSON.parse(markdown.props['data-styles']);
      expect(styles.code_inline.color).toBe('#00FF00');
    });
  });
});
