import { defineConfig } from "vitepress";
import * as sidebar from "./sidebar.json";

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "Apex SOQL Builder",
  description: "A type safe dynamic query executor",
  ignoreDeadLinks: true,
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: "Home", link: "/" },
      { text: "Documentation", link: "/getting-started.html" }
    ],

    sidebar: sidebar.default,

    socialLinks: [{ icon: "github", link: "https://github.com/Russman12/apex-soql-builder" }],
    logo: "/brand-s-round.png"
  },
  sitemap: {
    hostname: "https://example.com"
  }
});
