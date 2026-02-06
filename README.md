# Payture - Lista de Espera com Supabase

Sistema de lista de espera integrado com Supabase para armazenar emails dos usuários.

## 🚀 Configuração

### 1. Criar projeto no Supabase

1. Acesse [supabase.com](https://supabase.com)
2. Crie uma conta ou faça login
3. Crie um novo projeto
4. Anote a **URL do projeto** e a **chave anônima (anon key)**

### 2. Configurar o banco de dados

1. No painel do Supabase, vá em **SQL Editor**
2. Copie e cole o conteúdo do arquivo `schema.sql`
3. Execute o SQL para criar a tabela `waitlist`

### 3. Configurar as credenciais

1. Copie o arquivo `config.js.example` para `config.js`:
   ```bash
   cp config.js.example config.js
   ```

2. Abra o arquivo `config.js` e substitua:
   - `SUA_URL_DO_SUPABASE` pela URL do seu projeto Supabase
   - `SUA_CHAVE_ANON_DO_SUPABASE` pela chave anônima do seu projeto

Exemplo:
```javascript
const SUPABASE_URL = 'https://seuprojeto.supabase.co';
const SUPABASE_ANON_KEY = 'sua-chave-anon-aqui';
```

**Onde encontrar as credenciais:**
- No painel do Supabase, vá em **Settings** → **API**
- **URL**: Project URL
- **Anon Key**: anon/public key

### 4. Testar

1. Abra o arquivo `listadeespera.html` no navegador
2. Preencha um email e envie
3. Verifique no painel do Supabase (Table Editor) se o email foi salvo

## 📋 Estrutura da Tabela

A tabela `waitlist` possui os seguintes campos:

- `id` (UUID): Identificador único
- `email` (TEXT): Email do usuário (único)
- `created_at` (TIMESTAMP): Data de criação
- `updated_at` (TIMESTAMP): Data de última atualização

## 🔒 Segurança

O projeto utiliza Row Level Security (RLS) do Supabase:
- Usuários podem inserir novos emails
- Usuários podem ler a contagem total
- Apenas você (com credenciais de admin) pode ver todos os dados no painel

## 📊 Visualizar dados

Para ver todos os emails cadastrados:
1. Acesse o painel do Supabase
2. Vá em **Table Editor**
3. Selecione a tabela `waitlist`

## 🛠️ Tecnologias

- HTML5
- CSS3
- JavaScript (Vanilla)
- Supabase (Backend as a Service)
