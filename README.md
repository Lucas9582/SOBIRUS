# 🌟 SOBRIUS - Aplicativo de Recuperação de Vícios

## 📋 Informações do Projeto

**Instituição:** Universidade  
**Disciplina:** Programação Orientada a Objetos  
**Período:** 2024/2025

### 👥 Integrantes
- Breno Vinícius de Carvalho Filho - 12300934
- Lincoln Sales e Gonçalves - 12400289
- Lucas Corrêa Papa - 12301760
- Lucas Brooklyn Gallo do Amaral - 12302970
- Marco Henri Dias Pinheiro - 12401854

---

## 🎯 Sobre o Projeto

Sobrius é um aplicativo móvel desenvolvido em Flutter que auxilia pessoas em processo de recuperação de vícios, oferecendo ferramentas de acompanhamento, motivação e suporte comunitário.

---

## ✨ Funcionalidades Implementadas (20 funcionalidades)

### 🔐 Autenticação (3)
- ✅ RF01: Cadastro de usuários
- ✅ RF02: Redefinição de senha
- ✅ RF06: Login com Google

### 👤 Perfil (5)
- ✅ RF10: Cadastro de motivo pessoal
- ✅ RF11: Seleção de vício
- ✅ RF18: Foto de perfil
- ✅ RF19: Descrição do perfil
- ✅ RF20: Sistema de progressão

### 📊 Acompanhamento (6)
- ✅ RF04: Calendário de recaídas
- ✅ RF05: Timer de sobriedade
- ✅ RF07: Cadastro de recaídas
- ✅ RF08: Cadastro de gatilhos
- ✅ RF15: Sistema de conquistas
- ✅ RF16: Relatórios e gráficos

### 🤝 Suporte (6)
- ✅ RF03: Notificações de motivação
- ✅ RF09: Fórum anônimo
- ✅ RF12: Recomendações personalizadas
- ✅ RF13: Busca de centros de apoio
- ✅ RF14: IA para personalização
- ✅ RF17: Alertas de gatilhos

---

## 🏗️ Arquitetura

### Padrão MVC (Model-View-Controller)
```
Views (Pages) → ViewModels (Estado) → Controllers → Repositories → Services → Models
```

### Padrão Repository
Abstração da camada de persistência:
- `ProfileRepository`
- `RelapseRepository`
- `AchievementRepository`
- `TriggerRepository`

---

## 🎨 Padrões GoF Implementados

### 1️⃣ Singleton - Conexão Firebase
**Arquivo:** `lib/core/database/firebase_connection.dart`

**Justificativa:** Garante uma única instância de conexão com Firebase em toda a aplicação, evitando múltiplas inicializações e economizando recursos do sistema.

**Implementação:**
```dart
class FirebaseConnection {
  static FirebaseConnection? _instance;
  
  FirebaseConnection._internal() {
    // Inicialização única
  }
  
  static FirebaseConnection getInstance() {
    _instance ??= FirebaseConnection._internal();
    return _instance!;
  }
}
```

**Uso:**
```dart
final firebase = FirebaseConnection.getInstance();
final firestore = firebase.firestore;
```

---

### 2️⃣ Factory Method - Criação de Models
**Arquivos:** 
- `lib/core/factories/model_factory.dart`
- `lib/models/factories/profile_factory.dart`
- `lib/models/factories/relapse_factory.dart`

**Justificativa:** Centraliza e padroniza a criação de objetos complexos (ProfileModel, RelapseModel), facilitando manutenção, validação e testes.

**Implementação:**
```dart
abstract class ModelFactory<T> {
  T createFromMap(String id, Map<String, dynamic> map);
  T createEmpty();
}

class ProfileFactory implements ModelFactory<ProfileModel> {
  @override
  ProfileModel createFromMap(String id, Map<String, dynamic> map) {
    // Lógica de criação com validação
  }
}
```

**Benefícios:**
- ✅ Validação centralizada
- ✅ Facilita adição de novos tipos
- ✅ Reduz código duplicado

---

### 3️⃣ Observer - Sistema de Notificações
**Arquivos:**
- `lib/core/observers/notification_observer.dart`
- `lib/core/observers/notification_subject.dart`
- `lib/services/notification_service.dart`

**Justificativa:** Implementa sistema de notificações desacoplado para RF03 (notificações motivacionais) e RF17 (alertas de gatilhos), permitindo múltiplos observadores receberem atualizações.

**Implementação:**
```dart
abstract class NotificationObserver {
  void onNotificationReceived(String message, NotificationType type);
}

class NotificationSubject {
  final List<NotificationObserver> _observers = [];
  
  void notify(String message, NotificationType type) {
    for (var observer in _observers) {
      observer.onNotificationReceived(message, type);
    }
  }
}
```

**Benefícios:**
- ✅ Desacoplamento emissor/receptor
- ✅ Múltiplos observadores por evento
- ✅ Fácil adicionar novos tipos

---

### 4️⃣ Strategy - Recomendações Personalizadas
**Arquivos:**
- `lib/core/strategies/recommendation_strategy.dart`
- `lib/strategies/alcohol_recommendation_strategy.dart`
- `lib/strategies/smoking_recommendation_strategy.dart`
- `lib/strategies/generic_recommendation_strategy.dart`
- `lib/services/recommendation_service.dart`

**Justificativa:** Implementa RF12 (recomendações personalizadas) permitindo diferentes algoritmos de recomendação baseados no tipo de vício, facilitando adição de novos vícios sem modificar código existente.

**Implementação:**
```dart
abstract class RecommendationStrategy {
  List<Recommendation> generateRecommendations(int daysClean);
  String get addictionName;
}

class AlcoholRecommendationStrategy implements RecommendationStrategy {
  @override
  List<Recommendation> generateRecommendations(int daysClean) {
    // Lógica específica para álcool
  }
}
```

**Benefícios:**
- ✅ Algoritmos intercambiáveis
- ✅ Fácil adicionar novos vícios
- ✅ Testável isoladamente
- ✅ Personalização por contexto

---

## 🛠️ Tecnologias

- **Framework:** Flutter 3.0+
- **Linguagem:** Dart 3.0+
- **Backend:** Firebase (Auth, Firestore, Storage)
- **State Management:** Provider
- **Navigation:** GoRouter
- **Charts:** FL Chart
- **Calendar:** Table Calendar

---

## 💻 Como Rodar

### Pré-requisitos
- Flutter SDK 3.0+
- Android Studio ou VS Code
- Firebase configurado

### Passos

1. **Clone o repositório**
```bash
git clone https://github.com/seu-usuario/sobrius.git
cd sobrius
```

2. **Instale dependências**
```bash
flutter pub get
```

3. **Configure Firebase**
- Crie projeto no Firebase Console
- Baixe `google-services.json` → `android/app/`
- Baixe `GoogleService-Info.plist` → `ios/Runner/`
- Execute: `flutterfire configure`

4. **Execute**
```bash
flutter run
```

---

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── database/
│   │   └── firebase_connection.dart     # Singleton
│   ├── factories/
│   │   └── model_factory.dart           # Factory
│   ├── observers/
│   │   ├── notification_observer.dart   # Observer
│   │   └── notification_subject.dart
│   └── strategies/
│       └── recommendation_strategy.dart  # Strategy
├── models/
│   ├── profile_model.dart
│   ├── relapse_model.dart
│   └── factories/
│       ├── profile_factory.dart
│       └── relapse_factory.dart
├── repositories/
│   ├── profile_repository.dart
│   └── relapse_repository.dart
├── services/
│   ├── profile_service.dart
│   ├── relapse_service.dart
│   ├── notification_service.dart
│   └── recommendation_service.dart
├── viewmodels/
│   ├── auth_viewmodel.dart
│   ├── profile_viewmodel.dart
│   └── relapse_viewmodel.dart
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── profile_page.dart
│   └── calendar_page.dart
└── strategies/
    ├── alcohol_recommendation_strategy.dart
    ├── smoking_recommendation_strategy.dart
    └── generic_recommendation_strategy.dart
```


---

## ⚠️ Aviso Legal

Este aplicativo é uma ferramenta de suporte educacional e **NÃO substitui** tratamento profissional, terapia ou aconselhamento médico.

---

**Desenvolvido com ❤️ pela Equipe Sobrius**
