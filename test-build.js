const { build } = require('./node_modules/@tarojs/cli/dist/index.js');

console.log('Starting Taro build...');

build({
  type: 'weapp',
  sourceRoot: './src',
  outputRoot: './dist',
  framework: 'react',
  verbose: true
}).then(() => {
  console.log('Build completed successfully');
}).catch((error) => {
  console.error('Build failed with error:', error);
});