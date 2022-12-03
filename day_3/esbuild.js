const ElmPlugin = require('esbuild-plugin-elm')
const { build } = require('esbuild')

build({
  entryPoints: ['js/index.js'],
  bundle: true,
  outdir: 'dist',
  platform: 'node',
  external: ['./index.node'],
  watch: false,
  plugins: [
    ElmPlugin({ debug: false, verbose: true }),
  ],
}).catch(_e => process.exit(1))

