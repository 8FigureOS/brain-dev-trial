# Quick Setup Guide for Candidates

**This guide helps you get started quickly with the Brain Developer Trial**

---

## 🚀 Prerequisites

Before starting, ensure you have:

- [ ] **Node.js 20+** installed ([nodejs.org](https://nodejs.org/))
- [ ] **PostgreSQL** installed locally OR Docker Desktop
- [ ] **OpenAI API Key** ([platform.openai.com/api-keys](https://platform.openai.com/api-keys))
- [ ] **Git** for version control
- [ ] **Code editor** (VS Code recommended)

---

## 📁 Recommended Project Structure

Create this structure for your submission:

```
knowledge-extraction-api/
├── README.md                    # Your main documentation
├── .env.example                # Environment template
├── docker-compose.yml          # Docker setup (optional but nice)
├── backend/
│   ├── package.json
│   ├── tsconfig.json
│   ├── src/
│   │   ├── main.ts
│   │   ├── app.module.ts
│   │   ├── ingestion/          # Ingestion module
│   │   ├── transcripts/        # Transcript CRUD
│   │   ├── search/             # Semantic search
│   │   ├── analytics/          # Analytics endpoints
│   │   └── ai/                 # OpenAI integration
│   └── migrations/             # Database migrations
└── frontend/
    ├── package.json
    ├── tsconfig.json
    ├── tailwind.config.ts
    └── src/
        ├── app/
        │   ├── page.tsx        # Home page
        │   ├── transcripts/    # Transcript pages
        │   ├── search/         # Search page
        │   └── analytics/      # Analytics dashboard
        └── components/         # Reusable components
```

---

## ⚡ Quick Start Path

### Option A: Docker (Easiest)

```bash
# 1. Clone template or create project
mkdir knowledge-extraction-api
cd knowledge-extraction-api

# 2. Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: knowledge_db
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: devpass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF

# 3. Start database
docker-compose up -d

# 4. Create backend
npx @nestjs/cli new backend
cd backend

# 5. Install dependencies
npm install @nestjs/typeorm typeorm pg openai class-validator class-transformer @nestjs/swagger

# 6. Set up .env
cat > .env << 'EOF'
DATABASE_URL=postgresql://dev:devpass@localhost:5432/knowledge_db
OPENAI_API_KEY=sk-proj-YOUR-KEY-HERE
PORT=3000
EOF

# 7. Start coding!
```

### Option B: Local Setup

```bash
# 1. Install PostgreSQL locally
# macOS:
brew install postgresql@16
brew services start postgresql@16

# Linux:
sudo apt-get install postgresql-16

# Windows:
# Download from https://www.postgresql.org/download/windows/

# 2. Create database
createdb knowledge_db

# 3. Follow steps 4-7 from Option A
```

---

## 🧪 Testing Your Implementation

### Step 1: Test Ingestion

```bash
curl -X POST http://localhost:3000/api/ingest \
  -H "Content-Type: application/json" \
  -d '{
    "transcript_id": "test-001",
    "title": "Test Meeting",
    "occurred_at": "2025-10-20T10:00:00Z",
    "duration_minutes": 30,
    "participants": [
      {
        "name": "Alice Johnson",
        "email": "alice@example.com",
        "role": "speaker"
      }
    ],
    "transcript": "Alice: Let us discuss the budget. We need to allocate $50k for marketing. I will prepare the proposal by Friday.",
    "metadata": {
      "platform": "zoom"
    }
  }'
```

**Expected Response**:
```json
{
  "id": "...",
  "status": "processed",
  "extracted": {
    "topics": ["Budget Planning", "Marketing Allocation"],
    "action_items": [
      {
        "text": "Prepare marketing budget proposal",
        "assignee": "Alice Johnson",
        "due_date": "2025-10-25",
        "priority": "medium"
      }
    ],
    "decisions": ["Allocate $50k for marketing"],
    "sentiment": "positive"
  }
}
```

### Step 2: Test Search

```bash
# Should return relevant transcripts
curl "http://localhost:3000/api/search?q=budget%20planning"
```

### Step 3: Test Analytics

```bash
curl http://localhost:3000/api/analytics/topics
curl http://localhost:3000/api/analytics/participants
```

### Step 4: Test Frontend

Visit: http://localhost:3001

- ✅ Can see list of transcripts
- ✅ Can view transcript details
- ✅ Search works and returns results
- ✅ Analytics page shows charts

---

## 📝 README Template

Your README should cover:

```markdown
# Knowledge Extraction API

Brief description of your solution.

## Architecture

[Diagram or explanation of your approach]

## Tech Stack

- Backend: NestJS + TypeScript
- Database: PostgreSQL
- AI: OpenAI GPT-4 + text-embedding-3-small
- Frontend: Next.js 14
- Styling: Tailwind CSS

## Setup Instructions

### Prerequisites
- Node.js 20+
- PostgreSQL 16+ OR Docker
- OpenAI API key

### Installation

1. Clone repository
   ```bash
   git clone ...
   cd knowledge-extraction-api
   ```

2. Set up environment
   ```bash
   cp .env.example .env
   # Edit .env and add your OPENAI_API_KEY
   ```

3. Start database
   ```bash
   docker-compose up -d
   ```

4. Install and run backend
   ```bash
   cd backend
   npm install
   npm run migration:run
   npm run start:dev
   ```

5. Install and run frontend
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

6. Access application
   - API: http://localhost:3000
   - Frontend: http://localhost:3001
   - API Docs: http://localhost:3000/api/docs

## API Documentation

[Link to Swagger or list endpoints]

## Design Decisions

**Why PostgreSQL?**
[Your reasoning]

**Why this schema design?**
[Your reasoning]

**How does semantic search work?**
[Explain embeddings approach]

## Trade-offs and Future Improvements

With more time, I would:
- [ ] Add caching layer (Redis)
- [ ] Implement proper authentication
- [ ] Add comprehensive tests
- [ ] Use pgvector for faster similarity search
- [ ] Add rate limiting
- [ ] Improve entity deduplication

## Testing

[How to test the application]
```

---

## 🎨 Frontend Quick Start

### Using shadcn/ui (Recommended)

```bash
# Create Next.js app
npx create-next-app@latest frontend --typescript --tailwind --app

cd frontend

# Add shadcn/ui
npx shadcn-ui@latest init

# Add components
npx shadcn-ui@latest add button
npx shadcn-ui@latest add card
npx shadcn-ui@latest add input
npx shadcn-ui@latest add table
npx shadcn-ui@latest add badge
```

### Basic Layout

```typescript
// src/app/layout.tsx
import './globals.css'

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <nav className="border-b">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between h-16 items-center">
              <div className="flex space-x-8">
                <a href="/" className="font-semibold">Knowledge API</a>
                <a href="/transcripts">Transcripts</a>
                <a href="/search">Search</a>
                <a href="/analytics">Analytics</a>
              </div>
            </div>
          </div>
        </nav>
        <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {children}
        </main>
      </body>
    </html>
  )
}
```

---

## 🐛 Common Issues and Solutions

### Issue: "OpenAI API errors"

**Solution**:
- Check API key is valid
- Check you have credits
- Add error handling and retries
- Use try-catch blocks

### Issue: "Database connection failed"

**Solution**:
```bash
# Check PostgreSQL is running
pg_isready

# Or with Docker
docker-compose ps

# Test connection
psql -h localhost -U dev -d knowledge_db
```

### Issue: "Embeddings are slow"

**Solution**:
- Use `text-embedding-3-small` (faster, cheaper)
- Cache embeddings (don't regenerate)
- Process embeddings async
- Batch multiple embeddings in one call

### Issue: "CORS errors on frontend"

**Solution**:
```typescript
// backend/src/main.ts
app.enableCors({
  origin: 'http://localhost:3001',
  credentials: true
});
```

---

## 💡 Tips for Success

### Do's ✅

1. **Start with data modeling** - Get your schema right first
2. **Test incrementally** - Don't build everything then test
3. **Read OpenAI docs** - Understand embeddings and structured output
4. **Use TypeScript properly** - Types are your friend
5. **Write good prompts** - Spend time on prompt engineering
6. **Handle errors gracefully** - Everything can fail
7. **Document as you go** - Don't leave it to the end

### Don'ts ❌

1. **Don't use `any` everywhere** - This is a TypeScript test
2. **Don't skip validation** - Input validation is critical
3. **Don't ignore errors** - Handle LLM failures gracefully
4. **Don't over-engineer** - Keep it simple but solid
5. **Don't skip the README** - Documentation matters
6. **Don't forget indexes** - Database performance matters

---

## 🎯 Time Management

**Recommended time allocation** (6 hours total):

- **Hour 1**: Project setup, database schema, basic API structure
- **Hour 2**: Ingestion endpoint + OpenAI integration
- **Hour 3**: Entity extraction, database storage
- **Hour 4**: Semantic search implementation
- **Hour 5**: Frontend pages (list, detail, search)
- **Hour 6**: Analytics, polish, documentation

**If running out of time**:
- Prioritize: Core API → AI integration → Basic frontend
- Skip: Advanced analytics, bonus features, perfect UI
- Document what you'd do with more time

---

## 📚 Helpful Resources

### NestJS
- [NestJS Docs](https://docs.nestjs.com/)
- [NestJS TypeORM Integration](https://docs.nestjs.com/techniques/database)
- [NestJS Validation](https://docs.nestjs.com/techniques/validation)

### OpenAI
- [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)
- [Structured Outputs](https://platform.openai.com/docs/guides/structured-outputs)
- [Best Practices](https://platform.openai.com/docs/guides/prompt-engineering)

### TypeORM
- [Entity Relations](https://typeorm.io/relations)
- [Migrations](https://typeorm.io/migrations)

### Next.js
- [App Router](https://nextjs.org/docs/app)
- [Data Fetching](https://nextjs.org/docs/app/building-your-application/data-fetching)

### Semantic Search
- [Understanding Embeddings](https://platform.openai.com/docs/guides/embeddings/what-are-embeddings)
- [Vector Similarity](https://www.pinecone.io/learn/vector-similarity/)

---

## 🆘 Getting Help

### Allowed
- ✅ Google/StackOverflow for syntax
- ✅ Official documentation
- ✅ ChatGPT for boilerplate (but understand it!)
- ✅ Code examples from docs

### Not Allowed
- ❌ Copying entire solutions from GitHub
- ❌ Getting someone else to do it
- ❌ Using pre-built "meeting analyzer" libraries

**Remember**: We're evaluating YOUR skills, not your ability to find code online.

---

## 📊 Self-Assessment Checklist

Before submitting, check:

### Backend
- [ ] All endpoints return proper status codes (200, 201, 400, 500)
- [ ] Input validation works (try sending invalid data)
- [ ] OpenAI integration extracts reasonable entities
- [ ] Semantic search returns relevant results
- [ ] Database schema has proper relationships
- [ ] No unhandled promise rejections in logs

### Frontend  
- [ ] All pages load without errors
- [ ] Search actually works
- [ ] UI is responsive (test on mobile)
- [ ] Loading states are visible
- [ ] Error states are handled

### Documentation
- [ ] README has clear setup steps
- [ ] Can someone else run your project?
- [ ] Design decisions are explained
- [ ] API endpoints are documented

### Code Quality
- [ ] TypeScript is used properly (minimal `any`)
- [ ] Code is organized into modules/components
- [ ] Error handling is present
- [ ] No console.logs in production code

---

## 🎬 Submission Checklist

Final checklist before sending:

- [ ] Code is in a GitHub repository
- [ ] README.md is complete and clear
- [ ] .env.example is included (without actual secrets)
- [ ] All dependencies are in package.json
- [ ] Project runs successfully from scratch
- [ ] Database migrations/schema are included
- [ ] You can run it yourself following your own README
- [ ] You've tested all main features
- [ ] Code is pushed to repository
- [ ] Repository is public OR we're added as collaborators

**Submit**:
- GitHub repository URL
- Brief video walkthrough (5-10 min, Loom or YouTube)
- Any notes about your approach

---

## 💬 What We're Actually Looking For

**We care MORE about**:
- Clean, readable code
- Proper TypeScript usage
- Understanding of AI/embeddings
- Thoughtful data modeling
- Good error handling

**We care LESS about**:
- Pixel-perfect UI
- 100% test coverage
- Advanced features
- Performance optimization

**We DON'T care about**:
- Using the "right" libraries (there are many good choices)
- Perfect code (we all iterate)
- Completing every bonus (focus on quality over quantity)

---

## 🎯 Final Tips

1. **Read the requirements twice** before starting
2. **Start simple** - Get basic flow working first
3. **Test as you go** - Don't wait until the end
4. **Use sample data** provided in `/sample-data`
5. **Time-box** - Don't spend 3 hours on perfect prompts
6. **Document decisions** - Explain your reasoning
7. **Ask yourself** - "Would I want to maintain this code?"

---

## 🤔 Expected Timeline

**Setup + Core Backend**:
- Project setup
- Database schema
- Basic ingestion endpoint
- OpenAI integration

**Search + Frontend**:
- Semantic search
- Frontend pages
- Analytics endpoint
- Documentation

**Polish**:
- Testing
- Error handling
- UI improvements
- Final documentation

---

## 📞 Questions?

If you have questions about the test:
- Re-read the main README.md
- Check this setup guide
- Review the sample data

If still unclear, email us at: [recruiting@8figureagency.co]

**What you CAN ask**:
- Clarification on requirements
- Technical setup issues
- Ambiguous specifications

**What you SHOULDN'T ask**:
- How to implement specific features
- Architecture decisions
- "Is this the right approach?"

---

Good luck! We're excited to see what you build. 🚀

---

*Brain Developer Trial - Setup Guide v1.0*

