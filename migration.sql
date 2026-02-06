-- Script de migração para adicionar campos nome e whatsapp à tabela waitlist existente
-- Execute este SQL no SQL Editor do Supabase se a tabela já existir

-- Adicionar coluna nome (se não existir)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'waitlist' AND column_name = 'nome') THEN
        ALTER TABLE waitlist ADD COLUMN nome TEXT;
    END IF;
END $$;

-- Adicionar coluna whatsapp (se não existir)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'waitlist' AND column_name = 'whatsapp') THEN
        ALTER TABLE waitlist ADD COLUMN whatsapp TEXT;
    END IF;
END $$;

-- Tornar nome obrigatório (após adicionar valores padrão se necessário)
-- ATENÇÃO: Execute apenas se não houver dados na tabela ou após preencher os dados existentes
-- ALTER TABLE waitlist ALTER COLUMN nome SET NOT NULL;
-- ALTER TABLE waitlist ALTER COLUMN whatsapp SET NOT NULL;

-- Criar índice para melhorar performance nas buscas por WhatsApp
CREATE INDEX IF NOT EXISTS idx_waitlist_whatsapp ON waitlist(whatsapp);
