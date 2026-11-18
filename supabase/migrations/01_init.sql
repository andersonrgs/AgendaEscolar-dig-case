-- ==============================================================================
-- SCHEMA INICIAL - AGENDA DIGITAL ESCOLAR INFANTIL (SINTONIA KIDS)
-- ==============================================================================

-- 1. Habilitar extensão UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 2. Tabela de Escolas
CREATE TABLE IF NOT EXISTS public.escolas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome TEXT NOT NULL,
    subdominio TEXT UNIQUE,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMPTZ DEFAULT now()
);

-- 3. Tabela de Turmas
CREATE TABLE IF NOT EXISTS public.turmas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    nome TEXT NOT NULL,
    turno TEXT NOT NULL,
    ano_letivo INT DEFAULT 2026,
    criado_em TIMESTAMPTZ DEFAULT now()
);

-- 4. Tabela de Alunos
CREATE TABLE IF NOT EXISTS public.alunos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    turma_id UUID REFERENCES public.turmas(id) ON DELETE SET NULL,
    nome_completo TEXT NOT NULL,
    data_nascimento DATE,
    foto_url TEXT,
    alergias_restricoes TEXT,
    responsavel_nome TEXT,
    responsavel_telefone TEXT,
    criado_em TIMESTAMPTZ DEFAULT now()
);

-- 5. Tabela de Diários de Bordo
CREATE TABLE IF NOT EXISTS public.diarios_bordo (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    aluno_id UUID REFERENCES public.alunos(id) ON DELETE CASCADE,
    data_referencia DATE DEFAULT CURRENT_DATE,
    alimentacao TEXT,
    hidratacao TEXT,
    higiene_fraldas TEXT,
    sono TEXT,
    observacoes TEXT,
    publicado_em TIMESTAMPTZ DEFAULT now(),
    lido_responsavel_em TIMESTAMPTZ
);

-- 6. Tabela de Estoque de Insumos da Mochila
CREATE TABLE IF NOT EXISTS public.estoque_insumos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    aluno_id UUID REFERENCES public.alunos(id) ON DELETE CASCADE,
    tipo_item TEXT DEFAULT 'FRALDA',
    saldo_atual INT DEFAULT 12,
    alerta_minimo INT DEFAULT 5,
    atualizado_em TIMESTAMPTZ DEFAULT now()
);

-- 7. Tabela de Medicamentos do Dia
CREATE TABLE IF NOT EXISTS public.medicacoes_dia (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    aluno_id UUID REFERENCES public.alunos(id) ON DELETE CASCADE,
    medicamento TEXT NOT NULL,
    dosagem TEXT NOT NULL,
    horario_previsto TEXT NOT NULL,
    administrado_em TIMESTAMPTZ,
    administrado_por TEXT,
    criado_em TIMESTAMPTZ DEFAULT now()
);

-- 8. Tabela de Portaria Segura (Check-in / Check-out)
CREATE TABLE IF NOT EXISTS public.registros_portaria (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    aluno_id UUID REFERENCES public.alunos(id) ON DELETE CASCADE,
    tipo_evento TEXT DEFAULT 'SAIDA',
    retirado_por_nome TEXT NOT NULL,
    pin_autorizacao TEXT,
    validado_em TIMESTAMPTZ DEFAULT now()
);

-- 9. Tabela de Recados
CREATE TABLE IF NOT EXISTS public.recados (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    aluno_id UUID REFERENCES public.alunos(id) ON DELETE CASCADE,
    remetente_tipo TEXT NOT NULL,
    remetente_nome TEXT NOT NULL,
    mensagem TEXT NOT NULL,
    lido_em TIMESTAMPTZ,
    enviado_em TIMESTAMPTZ DEFAULT now()
);

-- Permissões para acesso público e cliente anônimo (Mockup Demo)
ALTER TABLE public.escolas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.turmas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.alunos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diarios_bordo ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.estoque_insumos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medicacoes_dia ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.registros_portaria ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recados ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.escolas;
CREATE POLICY "Acesso total publico para demonstracao" ON public.escolas FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.turmas;
CREATE POLICY "Acesso total publico para demonstracao" ON public.turmas FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.alunos;
CREATE POLICY "Acesso total publico para demonstracao" ON public.alunos FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.diarios_bordo;
CREATE POLICY "Acesso total publico para demonstracao" ON public.diarios_bordo FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.estoque_insumos;
CREATE POLICY "Acesso total publico para demonstracao" ON public.estoque_insumos FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.medicacoes_dia;
CREATE POLICY "Acesso total publico para demonstracao" ON public.medicacoes_dia FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.registros_portaria;
CREATE POLICY "Acesso total publico para demonstracao" ON public.registros_portaria FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico para demonstracao" ON public.recados;
CREATE POLICY "Acesso total publico para demonstracao" ON public.recados FOR ALL USING (true) WITH CHECK (true);

GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, postgres;
