import { View, Text } from 'react-native';

export const createKaTeXHTML = jest.fn(() => '<div>KaTeX</div>');
export const KaTeXAutoHeightWebView = ({ source, minHeight, onError }) => (
  <View style={{ minHeight }}>
    <Text>LaTeX: {source?.html || ''}</Text>
  </View>
);
