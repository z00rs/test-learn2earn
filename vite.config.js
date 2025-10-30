import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import nodePolyfills from 'rollup-plugin-node-polyfills';

export default defineConfig({
  plugins: [
    react(),
    {
      name: 'global-polyfill',
      config(config) {
        if (!config.define) config.define = {};
        config.define.global = 'globalThis';
        config.define['process.env'] = 'process.env';
      },
      transformIndexHtml: {
        order: 'pre',
        handler(html) {
          return html.replace(
            '<head>',
            `<head>
    <script>
      // Define process globally before any modules load
      window.process = window.process || {
        env: { NODE_ENV: 'development' },
        browser: true,
        version: '',
        versions: {},
        nextTick: function(fn) { setTimeout(fn, 0); },
        cwd: function() { return '/'; },
        argv: [],
        binding: function() { throw new Error('process.binding is not supported'); },
        exit: function() {},
        platform: 'browser',
        title: 'browser'
      };
      
      // Define global immediately
      window.global = window.global || window;
      globalThis.global = globalThis.global || globalThis;
      globalThis.process = window.process;
      
      // Define Buffer if not available
      if (typeof Buffer === 'undefined') {
        window.Buffer = { isBuffer: function() { return false; } };
        globalThis.Buffer = window.Buffer;
      }
    </script>
    <script type="module">
      import { Buffer } from 'buffer';
      import process from 'process';
      
      // Update with real implementations
      window.Buffer = Buffer;
      window.process = process;
      globalThis.Buffer = Buffer;
      globalThis.process = process;
      
      // Ensure process.env exists
      if (!process.env) {
        process.env = {};
      }
      
      // Set NODE_ENV if not present
      if (!process.env.NODE_ENV) {
        process.env.NODE_ENV = 'development';
      }
    </script>`
          );
        },
      },
    },
  ],
  server: {
    port: 3000,
    host: true
  },
  define: {
    global: 'globalThis',
    'process.env': '{}',
    'process.env.NODE_ENV': '"development"',
    process: 'process'
  },
  resolve: {
    alias: {
      buffer: 'buffer',
      process: 'process/browser',
      crypto: 'crypto-browserify',
      stream: 'stream-browserify',
      http: 'http-browserify',
      https: 'https-browserify',
      url: 'url',
      util: 'util',
      os: 'os-browserify/browser',
      path: 'path-browserify',
      fs: 'browserify-fs',
      assert: 'assert',
      constants: 'constants-browserify',
      vm: 'vm-browserify',
      zlib: 'browserify-zlib',
    },
  },
  optimizeDeps: {
    include: [
      'buffer', 
      'process/browser', 
      'crypto-browserify',
      'stream-browserify', 
      'http-browserify',
      'https-browserify',
      'url',
      'util',
      'os-browserify',
      'path-browserify',
      'assert',
      'constants-browserify',
      'vm-browserify',
      'browserify-zlib',
      '@vechain/vechain-kit'
    ],
    exclude: [],
    esbuildOptions: {
      define: {
        global: 'globalThis',
      },
    },
  },
  build: {
    commonjsOptions: {
      transformMixedEsModules: true,
    },
    rollupOptions: {
      plugins: [
        nodePolyfills({
          include: ['crypto', 'stream', 'util', 'url', 'buffer', 'process'],
        })
      ],
      external: [],
      output: {
        globals: {
          buffer: 'Buffer',
          process: 'process'
        }
      }
    }
  }
});