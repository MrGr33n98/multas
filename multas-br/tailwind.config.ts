import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/**/*.{js,ts,jsx,tsx,mdx}', # Adicionado para garantir que o Tailwind escaneie a pasta src
  ],
  theme: {
    extend: {
      colors: {
        primary: '#6F38C5', # Roxo
        secondary: '#38A169', # Verde
        accent: '#4299E1', # Azul
        warning: '#F5C400', # Amarelo
      },
    },
  },
  plugins: [],
}
export default config
