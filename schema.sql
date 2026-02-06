-- Schema SQL para criar a tabela de lista de espera no Supabase
-- Execute este SQL no SQL Editor do Supabase

-- Criar tabela waitlist
CREATE TABLE IF NOT EXISTS waitlist (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nome TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    whatsapp TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Criar índice para melhorar performance nas buscas por email
CREATE INDEX IF NOT EXISTS idx_waitlist_email ON waitlist(email);

-- Criar índice para melhorar performance nas buscas por WhatsApp
CREATE INDEX IF NOT EXISTS idx_waitlist_whatsapp ON waitlist(whatsapp);

-- Criar índice para ordenação por data de criação
CREATE INDEX IF NOT EXISTS idx_waitlist_created_at ON waitlist(created_at DESC);

-- Habilitar Row Level Security (RLS)
ALTER TABLE waitlist ENABLE ROW LEVEL SECURITY;

-- Política para permitir inserção de novos emails (público)
CREATE POLICY "Permitir inserção pública de emails"
    ON waitlist
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

-- Política para permitir leitura pública (apenas contagem)
-- Você pode remover esta política se não quiser que usuários vejam outros emails
CREATE POLICY "Permitir leitura pública"
    ON waitlist
    FOR SELECT
    TO anon, authenticated
    USING (true);

-- Função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger para atualizar updated_at
CREATE TRIGGER update_waitlist_updated_at
    BEFORE UPDATE ON waitlist
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
