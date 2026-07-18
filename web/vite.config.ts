import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// Relative base so the build works both at a domain root (Vercel) and under a
// path (self-hosted). https://vite.dev/config/
export default defineConfig({
  base: "./",
  plugins: [react()],
});
