const { getDefaultConfig } = require('expo/metro-config');

const config = getDefaultConfig(__dirname);

config.resolver = {
  ...config.resolver,
  assetExts: [...config.resolver.assetExts, 'wasm'],
  sourceExts: [...config.resolver.sourceExts, 'wasm'],
};

module.exports = config;
