import { Text, TouchableOpacity, View } from 'react-native';

export const createKaTeXHTML = jest.fn(() => '<div>KaTeX</div>');
export const KaTeXAutoHeightWebView = ({ source, minHeight, onError }) => (
  <View style={{ minHeight }}>
    <Text testID="latex-content">LaTeX: {source?.html || ''}</Text>
    {onError && (
      <TouchableOpacity testID="trigger-error" onPress={onError}>
        <Text>Trigger Error</Text>
      </TouchableOpacity>
    )}
  </View>
);
