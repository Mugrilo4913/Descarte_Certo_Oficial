DROP DATABASE IF EXISTS descartecerto;
CREATE DATABASE IF NOT EXISTS descartecerto
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE descartecerto;

CREATE TABLE IF NOT EXISTS locais_descarte (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(160) NOT NULL,
  tipo_local ENUM('estacao_coleta','ponto_especial','coleta_domiciliar') NOT NULL,
  endereco VARCHAR(255),
  cep VARCHAR(9),
  bairro VARCHAR(120),
  cidade VARCHAR(100) NOT NULL DEFAULT 'Santo André',
  estado CHAR(2) NOT NULL DEFAULT 'SP',
  latitude DECIMAL(18,14) NULL,
  longitude DECIMAL(18,14) NULL,
  horario_funcionamento VARCHAR(255),
  observacoes TEXT,
  fonte_url VARCHAR(500),
  status_verificacao ENUM('verificado_fonte_oficial','confirmar_detalhes') NOT NULL DEFAULT 'verificado_fonte_oficial',
  atualizado_em DATE NOT NULL DEFAULT (CURRENT_DATE),
  UNIQUE KEY uq_local_nome_endereco (nome, endereco)
);

CREATE TABLE IF NOT EXISTS tipos_residuos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  slug VARCHAR(50) NOT NULL UNIQUE,
  descricao TEXT
);

CREATE TABLE IF NOT EXISTS locais_residuos (
  local_id INT NOT NULL,
  residuo_id INT NOT NULL,
  observacao VARCHAR(255),
  PRIMARY KEY (local_id, residuo_id),
  CONSTRAINT fk_lr_local FOREIGN KEY (local_id) REFERENCES locais_descarte(id) ON DELETE CASCADE,
  CONSTRAINT fk_lr_residuo FOREIGN KEY (residuo_id) REFERENCES tipos_residuos(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS horarios_coleta (
  id INT AUTO_INCREMENT PRIMARY KEY,
  bairro VARCHAR(120) NOT NULL,
  tipo_coleta ENUM('reciclaveis','umidos') NOT NULL,
  dias_semana VARCHAR(150) NOT NULL,
  horario_a_partir TIME NOT NULL,
  observacoes VARCHAR(255),
  fonte_url VARCHAR(500) NOT NULL,
  atualizado_em DATE NOT NULL DEFAULT (CURRENT_DATE),
  UNIQUE KEY uq_bairro_tipo (bairro, tipo_coleta)
);

-- Inserindo os 10 tipos de resíduos exatamente iguais às pastas/ícones da imagem
INSERT INTO tipos_residuos (nome, slug, descricao) VALUES
('Eletrônicos', 'eletronicos', 'Equipamentos eletroeletrônicos, computadores, celulares e componentes.'),
('Madeira', 'madeira', 'Móveis de madeira, pedaços de madeira e restos de poda/madeiramento.'),
('Metal', 'metal', 'Latas, ferragens e objetos metálicos recicláveis.'),
('Não Reciclável', 'naoreciclavel', 'Rejeitos gerais e materiais não passíveis de reciclagem tradicional.'),
('Orgânicos', 'organicos', 'Restos de alimentos e resíduos biodegradáveis/úmidos.'),
('Papel', 'papel', 'Papéis, caixas de papelão e embalagens de papel limpas e secas.'),
('Plástico', 'plastico', 'Garrafas PET, embalagens e objetos plásticos diversos.'),
('Radiação', 'radiacao', 'Resíduos radioativos ou sujeitos a controle especial de radiação.'),
('Saúde Domiciliar', 'saudeDomiciliar', 'Medicamentos vencidos, seringas e resíduos de cuidados de saúde em casa.'),
('Vidro', 'vidro', 'Garrafas, frascos e potes de vidro.');

-- Inserindo Estações de Coleta e Pontos Especiais mantendo a precisão completa das coordenadas
INSERT INTO locais_descarte
(nome, tipo_local, endereco, bairro, latitude, longitude, horario_funcionamento, observacoes, fonte_url)
VALUES
('Estação de Coleta Paraíso', 'estacao_coleta', 'Rua Juquiá, 200', 'Paraíso', -23.679958770789213, -46.53233231773729, 'Todos os dias, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Aceita telha de amianto e gesso conforme lista oficial.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Estação de Coleta Bom Pastor', 'estacao_coleta', 'Avenida Bom Pastor, 1150', 'Jardim Bom Pastor', -23.67899471404497, -46.55360108890036, 'Todos os dias, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Aceita telha de amianto, poda de vegetação e gesso conforme lista oficial.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Estação de Coleta Vila Guiomar', 'estacao_coleta', 'Avenida Dom Jorge Marcos de Oliveira, 151', 'Vila Guiomar', -23.658408816681032, -46.54483451301886, 'Segunda a sábado, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Aceita telha de amianto conforme lista oficial.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Estação de Coleta Caminho do Pilar', 'estacao_coleta', 'Rua Caminho do Pilar, 1541', 'Pinheirinho', -23.674633264385264, -46.54211934657254, 'Segunda a sábado, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Confirmar materiais específicos com a SEMASA.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Estação de Coleta Palmeiras', 'estacao_coleta', 'Avenida Prestes Maia, 195', 'Bairro Jardim', -23.643961045615498, -46.54060151958928, 'Segunda a sábado, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Aceita poda de vegetação conforme lista oficial.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Estação de Coleta Centro', 'estacao_coleta', 'Travessa São Bento, 15', 'Bairro Jardim', -23.65190796112968, -46.531162575409674, 'Segunda a sábado, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Confirmar materiais específicos com a SEMASA.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Estação de Coleta Sacadura Cabral', 'estacao_coleta', 'Rua Lauro Muller, 400', 'Vila Sacadura Cabral', -23.65619878767879, -46.55816560424495, 'Segunda a sábado, inclusive feriados: 09:00-12:00 e 13:00-17:00', 'Aceita poda de vegetação conforme lista oficial.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/'),
('Hequipel Computer & Recycling', 'ponto_especial', 'Rua Taipas, 76', 'Vila Valparaíso', -23.6690652840003, -46.54629056191667, 'Consultar por telefone: (11) 2774-4040', 'Reciclagem e destinação de resíduos eletrônicos, como equipamentos de informática. Requer contato prévio.', NULL),
('Oito Elementos Sustentabilidade', 'ponto_especial', 'Rua Misericórdia, 119', 'Vila Assunção', -23.672143557088408, -46.52318979683769, 'Consultar por telefone: (11) 2324-6298', 'Trabalha com gestão de resíduos, educação ambiental e reciclagem de óleo de cozinha (condições específicas).', NULL),
('Estação de Coleta Ipanema', 'estacao_coleta', 'Avenida Capitão Mário Toledo de Camargo, 2.955', 'Vila América', -23.68601047806802, -46.506364304244535, '09:00-12:00 e 13:00-17:00', 'Unidade municipal do Semasa exclusiva para moradores de Santo André. Conferir regras de aceitação.', 'https://portais.santoandre.sp.gov.br/semasa/residuos/estacoes-de-coleta/');

-- Coleta domiciliar
INSERT INTO horarios_coleta
(bairro, tipo_coleta, dias_semana, horario_a_partir, observacoes, fonte_url)
VALUES
('Valparaíso','reciclaveis','Quarta-feira','07:00:00','Coleta domiciliar de recicláveis secos. Horário indicado como "a partir das 7h".','https://portais.santoandre.sp.gov.br/semasa/coleta-seletiva/dias-e-horarios-de-coleta/'),
('Valparaíso','umidos','Terça-feira, Quinta-feira e Sábado','17:00:00','Coleta domiciliar de resíduos úmidos. Horário indicado como "a partir das 17h".','https://portais.santoandre.sp.gov.br/semasa/coleta-seletiva/dias-e-horarios-de-coleta/')
ON DUPLICATE KEY UPDATE
dias_semana=VALUES(dias_semana),
horario_a_partir=VALUES(horario_a_partir),
observacoes=VALUES(observacoes),
fonte_url=VALUES(fonte_url),
atualizado_em=CURRENT_DATE;

-- Associando os novos tipos às Estações de Coleta
INSERT INTO locais_residuos (local_id, residuo_id, observacao)
SELECT l.id, r.id, 'Aceitação geral informada pela página oficial do SEMASA.'
FROM locais_descarte l
JOIN tipos_residuos r ON r.slug IN (
  'papel', 'plastico', 'vidro', 'metal', 'eletronicos', 'madeira'
)
WHERE l.tipo_local = 'estacao_coleta';

-- Associação para Ponto Especial de Eletrônicos
INSERT INTO locais_residuos (local_id, residuo_id, observacao)
SELECT l.id, r.id, 'Coleta mediante contato prévio pelo telefone.'
FROM locais_descarte l
JOIN tipos_residuos r ON r.slug = 'eletronicos'
WHERE l.nome = 'Hequipel Computer & Recycling';

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de CEPs dos usuários
CREATE TABLE IF NOT EXISTS ceps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    cep VARCHAR(9) NOT NULL,
    CONSTRAINT fk_usuario_cep FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);	