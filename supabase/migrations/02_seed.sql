-- ==============================================================================
-- CARGA DE DADOS DE DEMONSTRAÇÃO (SEED)
-- ==============================================================================

DO $$
DECLARE
    v_escola_id UUID := 'e1000000-0000-0000-0000-000000000001';
    v_turma_bercario UUID := 'b1000000-0000-0000-0000-000000000001';
    v_turma_maternal UUID := 'b2000000-0000-0000-0000-000000000002';
    
    v_aluno_alice UUID := 'a1000000-0000-0000-0000-000000000001';
    v_aluno_theo UUID := 'a2000000-0000-0000-0000-000000000002';
    v_aluno_helena UUID := 'a3000000-0000-0000-0000-000000000003';
    v_aluno_gael UUID := 'a4000000-0000-0000-0000-000000000004';
BEGIN

    -- 1. Inserir Escola Piloto
    INSERT INTO public.escolas (id, nome, subdominio, ativo)
    VALUES (v_escola_id, 'Escola Cantinho do Saber', 'cantinho-saber', true)
    ON CONFLICT (id) DO NOTHING;

    -- 2. Inserir Turmas
    INSERT INTO public.turmas (id, escola_id, nome, turno, ano_letivo)
    VALUES 
        (v_turma_bercario, v_escola_id, 'Berçário I (Estrelinhas)', 'INTEGRAL', 2026),
        (v_turma_maternal, v_escola_id, 'Maternal II (Arco-Íris)', 'TARDE', 2026)
    ON CONFLICT (id) DO NOTHING;

    -- 3. Inserir Alunos com Alertas e Dados de Família
    INSERT INTO public.alunos (id, escola_id, turma_id, nome_completo, data_nascimento, foto_url, alergias_restricoes, responsavel_nome, responsavel_telefone)
    VALUES 
        (
            v_aluno_alice, 
            v_escola_id, 
            v_turma_bercario, 
            'Alice Rocha', 
            '2025-05-14', 
            'https://images.unsplash.com/photo-1544717305-2782549b5136?w=150&auto=format&fit=crop&q=80',
            'Alérgica severa a Amendoim e derivados', 
            'Mariana Rocha (Mãe)', 
            '(11) 98765-4321'
        ),
        (
            v_aluno_theo, 
            v_escola_id, 
            v_turma_bercario, 
            'Theo Souza', 
            '2025-08-20', 
            'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=150&auto=format&fit=crop&q=80',
            NULL, 
            'Carlos Souza (Pai)', 
            '(11) 97654-3210'
        ),
        (
            v_aluno_helena, 
            v_escola_id, 
            v_turma_maternal, 
            'Helena Duarte', 
            '2024-03-10', 
            'https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?w=150&auto=format&fit=crop&q=80',
            'Intolerância à Lactose (leite especial)', 
            'Patrícia Duarte (Mãe)', 
            '(11) 96543-2109'
        ),
        (
            v_aluno_gael, 
            v_escola_id, 
            v_turma_maternal, 
            'Gael Ferreira', 
            '2024-06-25', 
            'https://images.unsplash.com/photo-1595454223600-91fb55979c32?w=150&auto=format&fit=crop&q=80',
            NULL, 
            'Lucas Ferreira (Pai)', 
            '(11) 95432-1098'
        )
    ON CONFLICT (id) DO NOTHING;

    -- 4. Inserir Estoque Inicial de Insumos da Mochila
    INSERT INTO public.estoque_insumos (escola_id, aluno_id, tipo_item, saldo_atual, alerta_minimo)
    VALUES 
        (v_escola_id, v_aluno_alice, 'FRALDA', 3, 5),    -- Alerta baixo para demonstrar notificação!
        (v_escola_id, v_aluno_theo, 'FRALDA', 14, 5),
        (v_escola_id, v_aluno_helena, 'FRALDA', 8, 5),
        (v_escola_id, v_aluno_gael, 'FRALDA', 10, 5)
    ON CONFLICT DO NOTHING;

    -- 5. Inserir Diário de Bordo do Dia
    INSERT INTO public.diarios_bordo (escola_id, aluno_id, data_referencia, alimentacao, hidratacao, higiene_fraldas, sono, observacoes)
    VALUES 
        (
            v_escola_id, 
            v_aluno_alice, 
            CURRENT_DATE, 
            'Comeu tudo (papa de frutas e purê de legumes)', 
            'Excelente (350ml de água)', 
            '3 trocas (urina e evacuação normal)', 
            'Dormiu 1h30 tranquila no soninho da tarde', 
            'Alice participou ativamente da aula de musicalização com chocalhos. Esteve muito alegre hoje!'
        ),
        (
            v_escola_id, 
            v_aluno_theo, 
            CURRENT_DATE, 
            'Metade (recusou a sopa no almoço)', 
            'Regular (180ml)', 
            '2 trocas de fralda (urina)', 
            'Dormiu 40 min (sono um pouco agitado)', 
            'Theo chorou um pouquinho na hora da soneca querendo o paninho, mas depois se acalmou.'
        )
    ON CONFLICT DO NOTHING;

    -- 6. Inserir Prescrição de Medicamento do Dia
    INSERT INTO public.medicacoes_dia (escola_id, aluno_id, medicamento, dosagem, horario_previsto, administrado_em, administrado_por)
    VALUES 
        (
            v_escola_id, 
            v_aluno_helena, 
            'Amoxicilina Suspensão Oral', 
            '5 ml', 
            '14:00', 
            NULL, 
            NULL
        )
    ON CONFLICT DO NOTHING;

    -- 7. Inserir Recados de Demonstração
    INSERT INTO public.recados (escola_id, aluno_id, remetente_tipo, remetente_nome, mensagem)
    VALUES 
        (
            v_escola_id, 
            v_aluno_alice, 
            'PROFESSORA', 
            'Professora Juliana', 
            'Querida família, o estoque de fraldas da Alice está quase no fim (restam apenas 3 unidades). Por favor, enviar um novo pacote amanhã. Obrigado!'
        ),
        (
            v_escola_id, 
            v_aluno_helena, 
            'RESPONSAVEL', 
            'Patrícia Duarte (Mãe)', 
            'Boa tarde, professora! Enviei a garrafinha de água azul nova na mochila da Helena hoje.'
        )
    ON CONFLICT DO NOTHING;

END $$;
