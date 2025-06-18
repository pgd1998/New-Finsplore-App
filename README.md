# Finsplore - Unified Financial Management Platform

> **🚀 A comprehensive financial management platform combining the best features from BlueRing and RedBack implementations**

Finsplore is a modern, secure, and intelligent financial management application that helps users take control of their finances through real-time transaction tracking, AI-powered insights, and seamless bank account integration.

## ✨ Key Features

### 🔐 **Secure Authentication & User Management**
- JWT-based authentication with token blacklisting
- Email verification and password reset
- Secure user profile management
- Enterprise-grade security patterns

### 🏦 **Banking Integration**
- **Basiq API Integration** - Secure connection to Australian banks via Open Banking
- Real-time transaction fetching and synchronization
- Account balance tracking across multiple bank accounts
- Secure bank account linking and management

### 💰 **Transaction Management**
- Automatic transaction categorization with AI
- Manual transaction editing and recategorization
- Advanced transaction filtering and search
- Transaction analytics and insights

### 📊 **Budget & Goal Management**
- Personalized budget creation and tracking
- Financial goal setting with progress monitoring
- Budget vs. actual spending analysis
- Smart spending recommendations

### 🧾 **Bill Management**
- Recurring bill tracking and notifications
- Bill payment reminders
- Bill categorization and analysis

### 🤖 **AI-Powered Financial Assistant**
- **OpenAI Integration** - Intelligent financial chatbot
- Personalized financial advice and insights
- Spending pattern analysis
- Financial goal recommendations

### 📈 **Analytics & Insights**
- Visual spending analytics and trends
- Category-wise expense breakdown
- Income vs. expense tracking
- Financial health scoring

## 🏗️ Architecture

### Backend (Spring Boot)
```
backend/
├── src/main/java/com/finsplore/
│   ├── common/                 # Standardized API responses
│   ├── controller/             # REST API endpoints
│   ├── dto/                    # Data Transfer Objects
│   ├── entity/                 # JPA entities
│   ├── exception/              # Global exception handling
│   ├── repository/             # Data access layer
│   ├── security/               # JWT & Spring Security
│   ├── service/                # Business logic
│   └── util/                   # Utility classes
└── src/main/resources/
    └── application.properties  # Configuration
```

### Frontend (Flutter)
```
frontend/
├── lib/
│   ├── app/                    # Stacked configuration
│   ├── api/                    # API service layer
│   ├── models/                 # Data models
│   ├── services/               # Business services
│   ├── ui/                     # User interface
│   │   ├── views/              # Screen implementations
│   │   └── common/             # Shared UI components
│   └── utils/                  # Utility functions
```

## 🛠️ Technology Stack

### Backend
- **Framework**: Spring Boot 3.4.4
- **Language**: Java 21
- **Database**: PostgreSQL
- **Cache**: Redis
- **Security**: Spring Security + JWT
- **Build Tool**: Maven
- **APIs**: 
  - Basiq (Open Banking)
  - OpenAI (AI Assistant)
  - Email Services

### Frontend
- **Framework**: Flutter
- **Architecture**: MVVM with Stacked
- **State Management**: Stacked Services
- **API Client**: Dio with interceptors
- **Storage**: Secure Storage + Shared Preferences
- **Charts**: FL Chart

## 🚀 Quick Start

### Prerequisites
- **Java 21** or higher
- **Maven 3.9.9** or higher
- **PostgreSQL 12** or higher
- **Redis 6** or higher
- **Flutter 3.0** or higher

### Backend Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd New-Finsplore-App/backend
   ```

2. **Configure Database**
   ```bash
   # Create PostgreSQL database
   createdb finsplore
   
   # Update application.properties with your database credentials
   ```

3. **Configure External Services**
   ```bash
   # Copy configuration template
   cp src/main/resources/application.properties.template src/main/resources/application.properties
   
   # Edit application.properties and add:
   # - Database credentials
   # - Basiq API key
   # - OpenAI API key
   # - Email configuration
   # - JWT secret
   ```

4. **Run the backend**
   ```bash
   ./mvnw spring-boot:run
   ```

   The backend will start at `http://localhost:8080`

### Frontend Setup

1. **Navigate to frontend directory**
   ```bash
   cd ../frontend
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   ```bash
   # Create .env file
   echo "BASE_URL=http://localhost:8080" > .env
   ```

4. **Run the app**
   ```bash
   # Start emulator first, then run:
   flutter run
   ```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SPRING_DATASOURCE_URL` | PostgreSQL connection URL | `jdbc:postgresql://localhost:5432/finsplore` |
| `SPRING_DATASOURCE_USERNAME` | Database username | `finsplore_user` |
| `SPRING_DATASOURCE_PASSWORD` | Database password | `finsplore_password` |
| `FINSPLORE_JWT_SECRET` | JWT signing secret | *(change in production)* |
| `BASIQ_API_KEY` | Basiq API key | *(required)* |
| `OPENAI_API_KEY` | OpenAI API key | *(required)* |
| `SPRING_MAIL_USERNAME` | Email service username | *(optional)* |
| `SPRING_MAIL_PASSWORD` | Email service password | *(optional)* |

### Database Schema

The application automatically creates the necessary database tables on startup. Key entities include:

- **Users** - User accounts and authentication
- **UserProfiles** - Extended user information
- **Transactions** - Financial transactions
- **Bills** - Recurring bills and payments
- **Budgets** - Budget tracking
- **Goals** - Financial goals
- **Categories** - Transaction categories

## 📡 API Documentation

### Authentication Endpoints

```http
POST /api/auth/register         # User registration
POST /api/auth/login           # User login
POST /api/auth/logout          # User logout
GET  /api/auth/profile         # Get user profile
```

### Transaction Endpoints

```http
GET    /api/transactions                # Get user transactions
POST   /api/transactions/fetch          # Fetch from bank
PUT    /api/transactions/{id}/category  # Update category
GET    /api/transactions/summary        # Get transaction summary
```

### Banking Endpoints

```http
GET    /api/bank/accounts              # Get linked accounts
POST   /api/bank/link                  # Generate auth link
DELETE /api/bank/accounts/{id}         # Remove account
GET    /api/bank/balance               # Get total balance
```

### Budget & Goals Endpoints

```http
GET    /api/budgets                    # Get user budgets
POST   /api/budgets                    # Create budget
PUT    /api/budgets/{id}               # Update budget
GET    /api/goals                      # Get financial goals
POST   /api/goals                      # Create goal
```

### AI Assistant Endpoints

```http
POST   /api/chat/message               # Send chat message
GET    /api/suggestions                # Get AI suggestions
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
./mvnw test
```

### Frontend Tests
```bash
cd frontend
flutter test
```

### Integration Tests
```bash
# Run backend integration tests
./mvnw verify

# Run frontend widget tests
flutter test integration_test/
```

## 🚀 Deployment

### Backend Deployment

1. **Build the application**
   ```bash
   ./mvnw clean package
   ```

2. **Run with production profile**
   ```bash
   java -jar target/finsplore-backend.jar --spring.profiles.active=prod
   ```

### Frontend Deployment

1. **Build for release**
   ```bash
   flutter build apk --release      # Android
   flutter build ios --release      # iOS
   flutter build web --release      # Web
   ```

### Docker Deployment

```bash
# Build and run with Docker Compose
docker-compose up --build
```

## 📊 Features Roadmap

### ✅ Completed Features
- [x] Secure authentication system
- [x] Bank account integration (Basiq)
- [x] Transaction management
- [x] AI-powered categorization
- [x] Basic budgeting
- [x] Financial goals
- [x] AI chatbot assistant
- [x] Bill management

### 🚧 In Progress
- [ ] Advanced analytics dashboard
- [ ] Mobile app optimization
- [ ] Real-time notifications
- [ ] Advanced reporting

### 📋 Future Enhancements
- [ ] Multi-currency support
- [ ] Investment tracking
- [ ] Tax preparation assistance
- [ ] Financial education content
- [ ] Social features (shared goals)
- [ ] Third-party integrations (PayPal, Stripe)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Process
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

### Core Contributors
- **BlueRing Team** - Original full-stack implementation
- **RedBack Team** - Professional architecture and frontend design
- **Integration Team** - Combined the best of both implementations

### Acknowledgments
- **Basiq** for Open Banking API
- **OpenAI** for AI assistant capabilities
- **Flutter** and **Spring Boot** communities

## 📞 Support

For support and questions:
- 📧 Email: support@finsplore.com
- 💬 Discord: [Finsplore Community](https://discord.gg/finsplore)
- 📖 Documentation: [docs.finsplore.com](https://docs.finsplore.com)

---

**Made with ❤️ by the Finsplore Team**
