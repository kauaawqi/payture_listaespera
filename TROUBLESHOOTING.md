# Guia de Troubleshooting - Problemas com Formulário na Vercel

## Problema: Formulário não envia dados para o Supabase

### 1. Verificar Credenciais do Supabase

**Problema comum:** A chave anônima do Supabase pode estar incompleta ou incorreta.

**Solução:**
1. Acesse o painel do Supabase: https://app.supabase.com
2. Vá em **Settings** → **API**
3. Copie a **Project URL** completa
4. Copie a **anon/public key** completa (deve ter mais de 100 caracteres)
5. Atualize o arquivo `config.js` com as credenciais corretas

**Exemplo de chave válida:**
```javascript
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmY296bGJ2bG9qaXl5ZGJ6c2hqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ1Njg5MDAsImV4cCI6MjA1MDE0NDkwMH0.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
```

### 2. Verificar Políticas RLS (Row Level Security)

**Problema comum:** As políticas RLS podem estar bloqueando a inserção de dados.

**Solução:**
Execute este SQL no SQL Editor do Supabase:

```sql
-- Verificar se RLS está habilitado
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'waitlist';

-- Se necessário, recriar a política de inserção
DROP POLICY IF EXISTS "Permitir inserção pública de emails" ON waitlist;

CREATE POLICY "Permitir inserção pública de emails"
    ON waitlist
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);
```

### 3. Verificar Estrutura da Tabela

**Problema comum:** A tabela pode não ter os campos `nome` e `whatsapp`.

**Solução:**
Execute o script `migration.sql` no SQL Editor do Supabase para adicionar os campos necessários.

### 4. Verificar Console do Navegador

**Como verificar:**
1. Abra o site na Vercel
2. Pressione F12 para abrir o DevTools
3. Vá na aba **Console**
4. Tente enviar o formulário
5. Procure por erros em vermelho

**Erros comuns:**
- `SUPABASE_URL ou SUPABASE_ANON_KEY não estão definidos` → Problema com config.js
- `permission denied` ou `policy violation` → Problema com RLS
- `column "nome" does not exist` → Tabela não tem os campos necessários
- `network error` → Problema de CORS ou conexão

### 5. Verificar Caminho do Arquivo config.js na Vercel

**Problema comum:** O arquivo config.js pode não estar sendo carregado.

**Solução:**
1. Verifique se o arquivo `config.js` está na raiz do projeto
2. Verifique se o arquivo está sendo commitado no Git (não deve estar no .gitignore)
3. Na Vercel, verifique se o arquivo aparece nos arquivos deployados

### 6. Testar Conexão com Supabase

Adicione este código temporariamente no console do navegador para testar:

```javascript
// Testar conexão
const testConnection = async () => {
    try {
        const { data, error } = await supabaseClient
            .from('waitlist')
            .select('count', { count: 'exact', head: true });
        
        if (error) {
            console.error('Erro na conexão:', error);
        } else {
            console.log('Conexão OK!');
        }
    } catch (err) {
        console.error('Erro:', err);
    }
};

testConnection();
```

### 7. Verificar Variáveis de Ambiente na Vercel (Alternativa)

Se preferir usar variáveis de ambiente ao invés de config.js:

1. Na Vercel, vá em **Settings** → **Environment Variables**
2. Adicione:
   - `NEXT_PUBLIC_SUPABASE_URL` = sua URL do Supabase
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = sua chave anônima

3. Atualize o código para usar:
```javascript
const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL || window.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || window.SUPABASE_ANON_KEY;
```

## Checklist de Verificação

- [ ] Credenciais do Supabase estão corretas e completas
- [ ] Tabela `waitlist` existe com campos `nome`, `email` e `whatsapp`
- [ ] Políticas RLS permitem inserção pública
- [ ] Arquivo `config.js` está na raiz e sendo carregado
- [ ] Console do navegador não mostra erros
- [ ] Teste de conexão com Supabase funciona

## Contato

Se nenhuma das soluções acima resolver, verifique:
1. Logs da Vercel (Deployments → View Function Logs)
2. Logs do Supabase (Logs → API)
3. Network tab do DevTools para ver requisições HTTP
