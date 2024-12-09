import { themes as prismThemes } from 'prism-react-renderer'
import type { Config } from '@docusaurus/types'
import type * as Preset from '@docusaurus/preset-classic'

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: 'React Native Multiple Image Picker',
  tagline: 'High-performance React Native Multiple Image Picker library.',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://baronha.github.io',

  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/react-native-multiple-image-picker/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'baronha', // Usually your GitHub org/user name.
  projectName: 'react-native-multiple-image-picker', // Usually your repo name.
  trailingSlash: false,

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en', 'vi'],
    path: 'i18n',
    localeConfigs: {
      en: {
        label: 'English',
        direction: 'ltr',
        htmlLang: 'en-US',
        calendar: 'gregory',
        path: 'en',
      },
    },
  },

  presets: [
    [
      '@gorhom/docusaurus-preset',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          routeBasePath: '/',
          editUrl:
            'https://github.com/gorhom/react-native-bottom-sheet/tree/master/website/docs',
          lastVersion: 'current',
          versions: {
            current: {
              label: 'v2.0',
            },
          },
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/banner.png',

    colorMode: {
      defaultMode: 'dark',
      disableSwitch: false,
      respectPrefersColorScheme: true,
    },

    navbar: {
      title: 'RNMIP',
      logo: {
        alt: 'RNMIP Logo',
        src: 'img/RNMIP.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'multiple-image-picker',
          position: 'left',
          label: 'Guides',
        },
        {
          href: 'https://github.com/baronha/react-native-multiple-image-picker/tree/main/example',
          label: 'Example',
          position: 'left',
        },

        {
          href: 'https://github.com/baronha/react-native-multiple-image-picker',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },

    footer: {
      style: 'dark',
      links: [
        {
          title: 'Guides',
          items: [
            {
              label: 'Getting Started',
              to: '/getting-started',
            },
            {
              label: 'Config',
              to: '/config',
            },
            {
              label: 'Result',
              to: '/result',
            },
            {
              label: '☕️ Buy me a coffee',
              href: 'https://github.com/sponsors/baronha',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'X',
              href: 'https://x.com/_baronha',
            },
            {
              label: 'Threads',
              href: 'https://www.threads.net/@___donquijote',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Github',
              href: 'https://github.com/baronha',
            },
            {
              label: 'Binsoo - Photo Editor',
              href: 'https://apps.apple.com/vn/app/binsoo-photo-filters-editor/id6502683720',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Bảo Hà (baronha)`,
    },

    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
}

export default config
