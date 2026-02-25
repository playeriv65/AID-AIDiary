import React from 'react';
import katex from 'katex';

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
        return (
            <div
                style={{
                    backgroundColor: bgColor,
                    padding: displayMode ? 16 : 8,
                    borderRadius: 8,
                    marginVertical: displayMode ? 8 : 2,
                    color: textColor,
                    fontSize: displayMode ? '18px' : '14px',
                    textAlign: displayMode ? 'center' : 'left',
                    overflowX: 'auto',
                    display: 'flex',
                    justifyContent: displayMode ? 'center' : 'flex-start',
                    alignItems: 'center',
                }}
                dangerouslySetInnerHTML={{ __html: html }}
            />
        );
    } catch {
        return (
            <div
                style={{
                    backgroundColor: bgColor,
                    padding: displayMode ? 16 : 8,
                    borderRadius: 8,
                    marginVertical: displayMode ? 8 : 2,
                    color: textColor,
                    fontSize: displayMode ? '18px' : '14px',
                    textAlign: displayMode ? 'center' : 'left',
                    overflowX: 'auto',
                    fontFamily: 'monospace',
                }}
            >
                {formula}
            </div>
        );
    }
}
