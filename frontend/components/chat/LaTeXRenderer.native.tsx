import React from 'react';
import katex from 'katex';
import { KaTeXAutoHeightWebView } from '@adheil_gupta/react-native-latex-renderer';

interface LaTeXRendererProps {
    formula: string;
    displayMode?: boolean;
    theme: 'light' | 'dark';
}

export function LaTeXRenderer({ formula, displayMode = false, theme }: LaTeXRendererProps) {
    const textColor = theme === 'dark' ? '#DFE1E3' : '#1A1C1E';
    const bgColor = theme === 'dark' ? '#2A2C30' : '#F0F0F2';

    try {
        const html = katex.renderToString(formula, {
            displayMode,
            throwOnError: false,
            output: 'html',
        });
        const katexHtml = `
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
</head>
<body style="margin:0;padding:${displayMode ? '16px' : '8px'};background:${bgColor};color:${textColor};display:flex;justify-content:${displayMode ? 'center' : 'flex-start'};align-items:center;">
${html}
</body>
</html>`;
        return (
            <KaTeXAutoHeightWebView
                source={{ html: katexHtml }}
                minHeight={displayMode ? 60 : 30}
                onError={() => console.warn('KaTeX render error:', formula)}
            />
        );
    } catch {
        return (
            <KaTeXAutoHeightWebView
                source={{
                    html: `<!DOCTYPE html><html><body style="margin:0;padding:8px;background:${bgColor};color:${textColor};font-family:monospace;">${formula}</body></html>`,
                }}
                minHeight={30}
            />
        );
    }
}
