# 🎓 LMS Salesforce Project

Um sistema de **Learning Management System (LMS)** completo desenvolvido na plataforma Salesforce, gerenciando cursos, estudantes, matrículas, instrutores e certificações.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Arquitetura](#arquitetura)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Uso](#uso)
- [Desenvolvimento](#desenvolvimento)
- [Testes](#testes)
- [Contribuição](#contribuição)
- [Licença](#licença)

## 🎯 Sobre o Projeto

Este projeto implementa um sistema LMS completo no Salesforce, permitindo:

- **Gestão de Cursos**: Criação e administração de cursos educacionais
- **Gestão de Estudantes**: Cadastro e acompanhamento de estudantes
- **Sistema de Matrículas**: Processo de inscrição em cursos
- **Gestão de Instrutores**: Administração de professores e facilitadores
- **Sistema de Certificações**: Emissão automática de certificados
- **API REST**: Endpoints para integração com sistemas externos

## 🏗️ Arquitetura

O projeto segue uma arquitetura **n-tier** bem estruturada:

```
📦 Arquitetura
├── 🎨 Presentation Layer (LWC/Aura)
├── 🔧 Service Layer (Apex Services)
├── 📊 Repository Layer (Data Access)
├── ⚡ Trigger Handlers (Business Logic)
├── 🗄️ Data Model (Custom Objects)
└── 🌐 API Layer (REST Controllers)
```

### Padrões Implementados

- **Repository Pattern**: Isolamento da lógica de acesso a dados
- **Service Layer Pattern**: Centralização da lógica de negócio
- **Trigger Handler Pattern**: Processamento de eventos de dados
- **Queueable Pattern**: Processamento assíncrono para certificados

## ✨ Funcionalidades

### 🎓 Gestão de Cursos
- Criação e edição de cursos
- Associação com instrutores
- Controle de status e disponibilidade

### 👨‍🎓 Gestão de Estudantes
- Cadastro completo de estudantes
- Histórico de matrículas
- Acompanhamento de progresso

### 📝 Sistema de Matrículas
- Processo de inscrição em cursos
- Controle de status de matrícula
- Gestão de datas e prazos

### 👨‍🏫 Gestão de Instrutores
- Cadastro de instrutores
- Associação com cursos
- Controle de disponibilidade

### 🏆 Sistema de Certificações
- Emissão automática de certificados
- Processamento assíncrono via Queueable
- Controle de status de certificação

### 🔄 Processos Automatizados
- **ExpireEnrollmentBatch**: Expiração automática de matrículas
- **CertificateQueueable**: Processamento assíncrono de certificados
- **Triggers**: Validações e atualizações automáticas

## 📁 Estrutura do Projeto

```
force-app/main/default/
├── 📂 classes/
│   ├── 📂 async/                    # Classes assíncronas
│   │   ├── CertificateQueueable.cls
│   │   └── ExpireEnrollmentBatch.cls
│   ├── 📂 handlers/                 # Trigger Handlers
│   │   ├── CertificateTriggerHandler.cls
│   │   ├── CourseTriggerHandler.cls
│   │   ├── EnrollmentTriggerHandler.cls
│   │   └── StudentTriggerHandler.cls
│   ├── 📂 repositorys/              # Repository Pattern
│   │   ├── CertificateRepository.cls
│   │   ├── CourseRepository.cls
│   │   ├── EnrollmentRepository.cls
│   │   └── StudentRepository.cls
│   ├── 📂 rest/                     # API REST
│   │   └── LMSRestController.cls
│   └── 📂 Service/                  # Service Layer
│       ├── CertificateService.cls
│       ├── CourseService.cls
│       └── EnrollmentService.cls
├── 📂 objects/                      # Custom Objects
│   ├── 📂 Certificate__c/
│   ├── 📂 Course__c/
│   ├── 📂 Enrollment__c/
│   ├── 📂 Instructor__c/
│   └── 📂 Student__c/
└── 📂 triggers/                     # Triggers
    ├── CertificateTrigger.trigger
    ├── CourseTrigger.trigger
    ├── EnrollmentTrigger.trigger
    └── StudentTrigger.trigger
```

### 🗄️ Modelo de Dados

#### **Course__c** - Cursos
- Nome do curso
- Descrição
- Status
- Instrutor responsável
- Data de início/fim

#### **Student__c** - Estudantes
- Nome do estudante
- Email
- Telefone
- Data de cadastro
- Status

#### **Enrollment__c** - Matrículas
- Estudante
- Curso
- Data de matrícula
- Status da matrícula
- Instrutor

#### **Certificate__c** - Certificados
- Estudante
- Curso
- Data de emissão
- Status do certificado

#### **Instructor__c** - Instrutores
- Nome do instrutor
- Especialidade
- Cursos ministrados

## 🔧 Pré-requisitos

- **Salesforce CLI** (versão mais recente)
- **Node.js** (versão 16 ou superior)
- **npm** ou **yarn**
- **Git**
- Conta **Salesforce Developer** ou **Trailhead Playground**

## 📦 Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/lms-salesforce-project.git
cd lms-salesforce-project
```

2. **Instale as dependências**
```bash
npm install
```

3. **Autentique no Salesforce**
```bash
sfdx auth:web:login -d -a MyDevHub
```

4. **Crie um org de desenvolvimento**
```bash
sfdx force:org:create -f config/project-scratch-def.json -a LMSOrg -s
```

5. **Deploy o código**
```bash
sfdx force:source:push -u LMSOrg
```

## ⚙️ Configuração

### Variáveis de Ambiente
Crie um arquivo `.env` na raiz do projeto:

```env
SF_USERNAME=seu-username@salesforce.com
SF_PASSWORD=sua-senha
SF_SECURITY_TOKEN=seu-security-token
```

### Configuração do Scratch Org
O arquivo `config/project-scratch-def.json` já está configurado com as permissões necessárias.

## 🚀 Uso

### Comandos Principais

```bash
# Executar testes
npm run test

# Linting
npm run lint

# Formatação de código
npm run prettier

# Deploy para produção
sfdx force:source:deploy -u Production

# Abrir org
sfdx force:org:open -u LMSOrg
```

### Fluxo de Trabalho

1. **Criar Curso**: Use o objeto `Course__c` para cadastrar novos cursos
2. **Cadastrar Estudante**: Use o objeto `Student__c` para registrar estudantes
3. **Realizar Matrícula**: Use o objeto `Enrollment__c` para matricular estudantes
4. **Certificação Automática**: O sistema gera certificados automaticamente

## 🛠️ Desenvolvimento

### Estrutura de Branches
- `main`: Branch principal (produção)
- `develop`: Branch de desenvolvimento
- `feature/*`: Branches de funcionalidades
- `hotfix/*`: Branches de correções urgentes

### Convenções de Código

- **Apex**: PascalCase para classes, camelCase para métodos
- **Triggers**: Sufixo "Trigger" obrigatório
- **Handlers**: Sufixo "TriggerHandler" obrigatório
- **Services**: Sufixo "Service" obrigatório
- **Repositories**: Sufixo "Repository" obrigatório

### Linting e Formatação
O projeto utiliza:
- **ESLint** para JavaScript/LWC
- **Prettier** para formatação de código
- **Husky** para pre-commit hooks

## 🧪 Testes

### Executar Testes Unitários
```bash
# Todos os testes
npm run test

# Testes com cobertura
npm run test:unit:coverage

# Testes em modo watch
npm run test:unit:watch
```

### Testes Apex
```bash
# Executar testes Apex
sfdx force:apex:test:run -u LMSOrg

# Testes com cobertura
sfdx force:apex:test:run -c -u LMSOrg
```

### Cobertura de Código
O projeto mantém uma cobertura de testes acima de 75% para garantir qualidade.

## 📊 Monitoramento

### Logs e Debug
- Use `System.debug()` para logs de desenvolvimento
- Configure debug logs no Setup do Salesforce
- Monitore performance com Developer Console

### Métricas Importantes
- Tempo de execução de triggers
- Cobertura de testes
- Uso de limites de governor

## 🤝 Contribuição

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. **Commit** suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. **Push** para a branch (`git push origin feature/AmazingFeature`)
5. **Abra** um Pull Request

### Padrões de Contribuição
- Seguir as convenções de código estabelecidas
- Escrever testes para novas funcionalidades
- Atualizar documentação quando necessário
- Revisar código antes de fazer merge

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Suporte

- **Issues**: Use o sistema de issues do GitHub
- **Documentação**: Consulte a documentação do Salesforce
- **Comunidade**: Trailblazer Community

## 🔗 Links Úteis

- [Salesforce Developer Documentation](https://developer.salesforce.com/)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Lightning Web Components](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli)

---

**Desenvolvido com ❤️ na plataforma Salesforce**

*Última atualização: $(date)*
