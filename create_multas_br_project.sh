#!/bin/bash

# Nome do diretório raiz do projeto
PROJECT_NAME="multas-br"

echo "Criando a estrutura de pastas para o projeto $PROJECT_NAME..."

# 1. Criar o diretório raiz do projeto
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

echo "Diretório raiz '$PROJECT_NAME' criado."

# 2. Criar diretórios principais
mkdir -p public
mkdir -p src

echo "Diretórios 'public' e 'src' criados."

# 3. Criar subdiretórios dentro de src
mkdir -p src/app
mkdir -p src/components
mkdir -p src/lib
mkdir -p src/hooks
mkdir -p src/styles
mkdir -p src/types

echo "Subdiretórios de 'src' criados."

# 4. Criar grupos de rotas dentro de src/app
mkdir -p src/app/\(auth\)
mkdir -p src/app/\(main\)
mkdir -p src/app/\(dashboard\)

echo "Grupos de rotas em 'src/app' criados."

# 5. Criar subdiretórios dentro de src/components
mkdir -p src/components/ui
mkdir -p src/components/specific

echo "Subdiretórios de 'src/components' criados."

# 6. Criar arquivos placeholder essenciais
touch .env.local
touch tailwind.config.ts
touch tsconfig.json
touch package.json
touch Dockerfile
touch .dockerignore

echo "Arquivos placeholder essenciais criados."

# 7. Adicionar conteúdo básico aos arquivos
echo "Adicionando conteúdo básico aos arquivos..."

# src/app/layout.tsx
cat <<EOL > src/app/layout.tsx
import './globals.css'; // Ou o arquivo CSS global do Tailwind

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="pt-BR">
      <body>{children}</body>
    </html>
  );
}
EOL

# src/lib/firebase.ts
cat <<EOL > src/lib/firebase.ts
// src/lib/firebase.ts
import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore } from 'firebase/firestore';

// Suas credenciais de configuração do Firebase
const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
  measurementId: process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID,
};

// Inicializar o Firebase
const app = initializeApp(firebaseConfig);

// Obter instâncias de serviços
const auth = getAuth(app);
const db = getFirestore(app);

export { app, auth, db };
EOL

# .env.local
cat <<EOL > .env.local
# Credenciais do Firebase (substitua pelos seus valores reais)
NEXT_PUBLIC_FIREBASE_API_KEY="SUA_API_KEY_DO_FIREBASE"
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN="SEU_AUTH_DOMAIN_DO_FIREBASE"
NEXT_PUBLIC_FIREBASE_PROJECT_ID="SEU_PROJECT_ID_DO_FIREBASE"
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET="SEU_STORAGE_BUCKET_DO_FIREBASE"
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID="SEU_MESSAGING_SENDER_ID_DO_FIREBASE"
NEXT_PUBLIC_FIREBASE_APP_ID="SEU_APP_ID_DO_FIREBASE"
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID="SEU_MEASUREMENT_ID_DO_FIREBASE"

# URL da sua aplicação (para callbacks do Mercado Pago)
NEXT_PUBLIC_APP_URL="http://localhost:3000"

# Credenciais do Mercado Pago (NÃO use NEXT_PUBLIC_ aqui para o Access Token)
MERCADO_PAGO_ACCESS_TOKEN="SEU_ACCESS_TOKEN_DO_MERCADO_PAGO"
EOL

# tailwind.config.ts
cat <<EOL > tailwind.config.ts
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
EOL

# tsconfig.json (Conteúdo básico para Next.js com TypeScript)
cat <<EOL > tsconfig.json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOL

# package.json (Conteúdo mínimo, npm install preencherá o resto)
cat <<EOL > package.json
{
  "name": "multas-br",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "latest",
    "react": "latest",
    "react-dom": "latest"
  },
  "devDependencies": {
    "@types/node": "latest",
    "@types/react": "latest",
    "@types/react-dom": "latest",
    "autoprefixer": "latest",
    "eslint": "latest",
    "eslint-config-next": "latest",
    "postcss": "latest",
    "tailwindcss": "latest",
    "typescript": "latest"
  }
}
EOL

# Dockerfile
cat <<EOL > Dockerfile
# Dockerfile

# Stage 1: Build the Next.js application
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json yarn.lock* package-lock.json* ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Run the Next.js application
FROM node:20-alpine AS runner

WORKDIR /app

# Copy necessary files from the builder stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Set environment variables for production
ENV NODE_ENV production
# Expose the port Next.js runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
EOL

# .dockerignore
cat <<EOL > .dockerignore
.next/
node_modules/
npm-debug.log
.env.local
.env.development
.env.production
.git/
.gitignore
EOL

# README.md (Conteúdo do README.md que já geramos)
cat <<EOL > README.md
# Multas BR: Sua Plataforma Completa para Recursos de Trânsito

Bem-vindo ao repositório do Multas BR, a solução definitiva para auxiliar motoristas e empresas a gerenciarem e recorrerem a multas de trânsito, suspensões/cassações de CNH e infrações da ANTT. Nossa plataforma oferece recursos personalizados e suporte especializado para garantir sua tranquilidade.

## Visão Geral do Projeto

O Multas BR é uma aplicação web projetada para simplificar o processo de recurso de infrações de trânsito. Nosso objetivo é capacitar os usuários com as ferramentas e o conhecimento necessários para contestar multas e proteger suas carteiras de motorista.

## Funcionalidades Principais

* **Recursos Personalizados:** Soluções sob medida para diversos tipos de infrações, incluindo multas de trânsito, CNH suspensa/cassada e multas da ANTT.

* **Planos de Assinatura:** Oferecemos planos flexíveis (Anual, Trimestral, Mensal) para atender às suas necessidades, com monitoramento 24h e suporte via chat.

* **Consulta Rápida:** Interface intuitiva para consultar e iniciar o processo de recurso para cada tipo de infração.

* **Área do Usuário:**

  * **Minha Conta:** Gerenciamento de informações pessoais e configurações de perfil.

  * **Meus Recursos:** Acompanhamento do status de recursos em andamento e histórico de recursos.

  * **Meus Dados:** Edição e atualização de informações de contato e endereço.

  * **Assinatura:** Gerenciamento do plano de assinatura e detalhes de pagamento.

* **Seções Informativas:** Páginas dedicadas a explicar "Como Funciona", "Por que assinar", "Dúvidas Frequentes" e "Contato".

* **Suporte Especializado:** Acesso a uma equipe para desenvolver a estratégia ideal de recurso.

## Estrutura do Repositório (Exemplo)

\`\`\`
├── AI-Product-Development-Toolkit/
│   ├── MVP/
│   │   └── README.md             <- Este arquivo
│   └── PRD/
│       └── ProductRequirementsDocument.md
├── src/
│   ├── components/
│   ├── pages/
│   ├── assets/
│   └── styles/
├── public/
├── api/
├── tests/
└── .env.example
\`\`\`

## Como Rodar o Projeto Localmente (Exemplo)

Para configurar e rodar o projeto Multas BR em sua máquina local, siga os passos abaixo:

### Pré-requisitos

* Node.js (versão 14 ou superior)

* npm ou yarn

* Git

### Instalação

1. **Clone o repositório:**

   \`\`\`bash
   git clone https://github.com/seu-usuario/multas-br.git
   cd multas-br
   \`\`\`

2. **Instale as dependências:**

   \`\`\`bash
   npm install
   # ou
   yarn install
   \`\`\`

3. **Configure as variáveis de ambiente:**
   Crie um arquivo \`.env\` na raiz do projeto e adicione as seguintes variáveis (exemplo):

   \`\`\`
   REACT_APP_API_BASE_URL=http://localhost:3001/api
   REACT_APP_FIREBASE_API_KEY=your_firebase_api_key
   REACT_APP_FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain
   REACT_APP_FIREBASE_PROJECT_ID=your_firebase_project_id
   # ... outras variáveis do Firebase
   \`\`\`

### Rodando a Aplicação

\`\`\`bash
npm start
# ou
yarn start
\`\`\`

A aplicação estará disponível em \`http://localhost:3000\`.

## Contribuição

Agradecemos o seu interesse em contribuir para o Multas BR! Por favor, leia nosso \`CONTRIBUTING.md\` (se houver) para detalhes sobre nosso código de conduta e o processo para enviar pull requests.

## Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo \`LICENSE\` para mais detalhes.

**Multas BR** - Simplificando seus recursos de trânsito.
EOL

echo "Conteúdo básico adicionado aos arquivos."

echo "Estrutura do projeto '$PROJECT_NAME' criada com sucesso!"
echo "Agora você pode entrar no diretório do projeto e instalar as dependências:"
echo "cd $PROJECT_NAME"
echo "npm install"
