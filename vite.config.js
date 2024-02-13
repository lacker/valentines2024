import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'

// Set for production in .env.production
const base = process.env.VITE_BASE_URL || '/';

export default defineConfig({
  plugins: [svelte()],
  base: base,
});

console.log('VITE_BASE_URL:', process.env.VITE_BASE_URL);