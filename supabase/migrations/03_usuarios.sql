-- ==============================================================================
-- TABELAS DE USUÁRIOS, PERFIS (RBAC) E VÍNCULOS FAMILIARES
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    escola_id UUID REFERENCES public.escolas(id) ON DELETE CASCADE,
    nome TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    senha TEXT NOT NULL,
    perfil TEXT NOT NULL, -- DIRETORIA | PROFESSOR | AUXILIAR | FAMILIA | PORTARIA
    telefone TEXT,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.usuarios_alunos (
    usuario_id UUID REFERENCES public.usuarios(id) ON DELETE CASCADE,
    aluno_id UUID REFERENCES public.alunos(id) ON DELETE CASCADE,
    parentesco TEXT DEFAULT 'Mãe/Pai',
    PRIMARY KEY (usuario_id, aluno_id)
);

ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usuarios_alunos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Acesso total publico usuarios" ON public.usuarios;
CREATE POLICY "Acesso total publico usuarios" ON public.usuarios FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Acesso total publico usuarios_alunos" ON public.usuarios_alunos;
CREATE POLICY "Acesso total publico usuarios_alunos" ON public.usuarios_alunos FOR ALL USING (true) WITH CHECK (true);

GRANT ALL ON public.usuarios TO anon, authenticated, postgres;
GRANT ALL ON public.usuarios_alunos TO anon, authenticated, postgres;

-- Usuários Padrão para Demonstração
INSERT INTO public.usuarios (id, escola_id, nome, email, senha, perfil)
VALUES 
    ('c1000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001', 'Dra. Renata Vasconcelos', 'diretoria@escola.com', 'teste123', 'DIRETORIA'),
    ('c2000000-0000-0000-0000-000000000002', 'e1000000-0000-0000-0000-000000000001', 'Profª Juliana Mendes', 'professora@escola.com', 'teste123', 'PROFESSOR'),
    ('c3000000-0000-0000-0000-000000000003', 'e1000000-0000-0000-0000-000000000001', 'Monitª Beatriz Lima', 'auxiliar@escola.com', 'teste123', 'AUXILIAR'),
    ('c4000000-0000-0000-0000-000000000004', 'e1000000-0000-0000-0000-000000000001', 'Mariana Rocha (Família)', 'familia@escola.com', 'teste123', 'FAMILIA'),
    ('c5000000-0000-0000-0000-000000000005', 'e1000000-0000-0000-0000-000000000001', 'Seu José (Portaria)', 'portaria@escola.com', 'teste123', 'PORTARIA')
ON CONFLICT (email) DO NOTHING;

-- Vínculo da Família aos 2 filhos em turmas diferentes (Alice no Berçário e Helena no Maternal)
INSERT INTO public.usuarios_alunos (usuario_id, aluno_id, parentesco)
VALUES 
    ('c4000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'Mãe'),
    ('c4000000-0000-0000-0000-000000000004', 'a3000000-0000-0000-0000-000000000003', 'Mãe')
ON CONFLICT DO NOTHING;
