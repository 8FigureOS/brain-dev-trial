# Brain Developer Technical Trial

**Duration**: 4-6 hours (You will be paid for 5 hours)
**Level**: Senior Software Engineer (AI + Fullstack)  
**Language**: English

---

## 🎯 Context

You've been tasked to build a **Knowledge Extraction API** that processes meeting transcripts, extracts entities (people, organizations, topics), and provides intelligent querying capabilities. This simulates the core challenges you'll face working on Brain (our main product).

The system should:
1. Ingest meeting transcripts via API
2. Extract structured data (participants, topics, key decisions)
3. Store in a graph-like structure
4. Provide semantic search capabilities
5. Generate insights via LLM

---

## 📋 Requirements

### Part 1: Backend API (Required)

Build a REST API using **NestJS** or **Express + TypeScript** with the following endpoints:

#### 1.1 Ingestion Endpoint
```
POST /api/ingest
```

**Request Body**:
```json
{
  "transcript_id": "unique-id",
  "title": "Q4 Planning Meeting",
  "occurred_at": "2025-10-15T14:00:00Z",
  "duration_minutes": 45,
  "participants": [
    {
      "name": "John Doe",
      "email": "john@acme.com",
      "role": "speaker"
    }
  ],
  "transcript": "Full meeting transcript text here...",
  "metadata": {
    "platform": "zoom",
    "recording_url": "https://..."
  }
}
```

**Requirements**:
- Validate input data (use class-validator or Zod)
- Extract entities from transcript:
  - **Topics**: Use OpenAI to identify main themes discussed
  - **Action Items**: Extract tasks mentioned
  - **Decisions**: Identify key decisions made
  - **Sentiment**: Analyze overall meeting sentiment
- Store in a **relational database** (PostgreSQL or SQLite)
- Return processed data with extracted entities

**Response**:
```json
{
  "id": "...",
  "status": "processed",
  "extracted": {
    "topics": ["Budget Planning", "Q4 Goals", "Marketing Strategy"],
    "action_items": ["Review Q3 report", "Schedule follow-up"],
    "decisions": ["Approved budget increase of 15%"],
    "sentiment": "positive"
  }
}
```

#### 1.2 Query Endpoints

```
GET /api/transcripts
GET /api/transcripts/:id
GET /api/search?q=query
GET /api/analytics/topics
GET /api/analytics/participants
```

**Requirements**:
- `/api/search`: Implement **semantic search** using OpenAI embeddings
  - Store embeddings when ingesting transcripts
  - Compare query embedding with stored embeddings (cosine similarity)
  - Return top 5 most relevant transcripts
- `/api/analytics/topics`: Return aggregated topic statistics
- `/api/analytics/participants`: Return participant engagement metrics

#### 1.3 Graph Insights (Bonus - Extra Points)

```
GET /api/graph/connections
```

Return relationships between entities:
```json
{
  "connections": [
    {
      "person": "John Doe",
      "organization": "ACME Corp",
      "topics": ["Budget", "Marketing"],
      "interaction_count": 5
    }
  ]
}
```

### Part 2: Data Modeling (Required)

Design a database schema that supports:
1. **Transcripts** table
2. **Participants** table (with deduplication by email)
3. **Topics** table
4. **Action Items** table
5. **Embeddings** table (for semantic search)

**Requirements**:
- Use proper relationships (1-to-many, many-to-many)
- Create indexes for common queries
- Include a migration file
- Consider how to handle entity resolution (same person with different name variations)

### Part 3: Frontend Dashboard (Required)

Build a **Next.js** or **React** dashboard with:

#### 3.1 Pages
1. **Transcript List**: Display all transcripts with filters (date, participants, topics)
2. **Transcript Detail**: Show full transcript with highlighted entities
3. **Analytics Dashboard**: 
   - Top topics (bar chart)
   - Participant activity (table)
   - Sentiment trend over time (line chart)
4. **Search Page**: Semantic search interface

#### 3.2 UI Requirements
- Modern, clean design (use Tailwind CSS or shadcn/ui)
- Responsive (mobile-friendly)
- Loading states and error handling
- Dark mode support (bonus)

### Part 4: AI Integration (Required)

Implement **at least 2** of the following AI features:

1. **Automatic Summarization**: Generate 2-3 sentence summary of each transcript
2. **Entity Extraction**: Extract people, companies, topics using GPT-4/GPT-3.5
3. **Semantic Search**: Use OpenAI embeddings for similarity search
4. **Insight Generation**: Generate "Key Insights" from a transcript
5. **Smart Tagging**: Auto-suggest relevant tags for transcripts

**Requirements**:
- Use OpenAI API (you'll need an API key)
- Handle rate limiting gracefully
- Cache results to avoid redundant API calls
- Include prompt engineering examples

---

## 🔧 Technical Constraints

### Required Technologies
- **Backend**: NestJS or Express with TypeScript
- **Frontend**: Next.js 14+ with TypeScript
- **Database**: PostgreSQL or SQLite
- **AI**: OpenAI API (GPT-4 or GPT-3.5-turbo for extraction, text-embedding-3-small for embeddings)

### Nice to Have
- Docker setup with docker-compose
- Graph database (Neo4j or any graph DB) for entity relationships
- Swagger/OpenAPI documentation
- Unit tests for critical paths
- Environment variable validation

---

## 📦 Deliverables

### 1. Code Repository
- Clean, well-structured code
- README.md with setup instructions
- .env.example with required variables
- Database migration files

### 2. Documentation
Include in your README:
- **Architecture overview** (diagram appreciated)
- **API documentation** (or link to Swagger)
- **Setup instructions** (step-by-step)
- **Design decisions**: Why did you choose X over Y?
- **Trade-offs**: What would you improve with more time?

### 3. Demo
Either:
- Deployed version (Vercel/Railway/Render)
- Video walkthrough (Loom/YouTube)
- Docker setup that runs with `docker-compose up`

---

## 🎯 Evaluation Criteria

### Code Quality (30%)
- TypeScript usage (proper typing, no `any` abuse)
- Clean architecture (separation of concerns)
- Error handling and validation
- Code organization and modularity

### AI Integration (25%)
- Effective prompt engineering
- Proper use of embeddings for semantic search
- Error handling for LLM calls
- Cost-awareness (caching, token optimization)

### Data Modeling (20%)
- Schema design quality
- Relationship modeling
- Query optimization
- Handling data consistency

### Frontend (15%)
- User experience
- Code organization
- State management
- Responsive design

### Documentation (10%)
- Clear setup instructions
- Architecture explanation
- API documentation
- Code comments where needed

---

## 🚀 Getting Started

1. Fork this repository or create a new one
2. Set up your development environment
3. Create `.env` file with your OpenAI API key:
   ```
   OPENAI_API_KEY=sk-proj-...
   DATABASE_URL=postgresql://...
   ```
4. Build the features incrementally
5. Test thoroughly
6. Document everything

---

## 💡 Sample Transcript for Testing

```json
{
  "transcript_id": "meeting-001",
  "title": "Q4 Marketing Strategy Meeting",
  "occurred_at": "2025-10-15T14:00:00Z",
  "duration_minutes": 45,
  "participants": [
    {
      "name": "Sarah Chen",
      "email": "sarah@acme.com",
      "role": "speaker"
    },
    {
      "name": "Michael Rodriguez",
      "email": "mike@acme.com",
      "role": "speaker"
    },
    {
      "name": "Jennifer Lee",
      "email": "jen@acme.com",
      "role": "participant"
    }
  ],
  "transcript": "Sarah: Thanks everyone for joining. Let's dive into our Q4 marketing strategy. We need to discuss our budget allocation and campaign priorities.\n\nMichael: Absolutely. I've been reviewing our Q3 numbers, and I think we should increase our content marketing budget by 25%. Our blog posts have been generating significant leads.\n\nJennifer: I agree with Mike. The data shows clear ROI. I'd also suggest we explore influencer partnerships for our enterprise segment.\n\nSarah: Great points. Let's make it official - we'll increase content budget by 25% and allocate $50k for influencer partnerships. Mike, can you prepare a detailed breakdown by Friday?\n\nMichael: Absolutely, I'll have it ready.\n\nSarah: Perfect. One more thing - we need to decide on our target accounts for ABM campaigns. Jennifer, your thoughts?\n\nJennifer: I've identified 15 high-value accounts in the healthcare and fintech sectors. I'll share the list in Slack after this call.\n\nSarah: Excellent. Let's reconvene next Tuesday to finalize the campaign roadmap. Thanks everyone!",
  "metadata": {
    "platform": "zoom",
    "recording_url": "https://zoom.us/rec/play/example"
  }
}
```

**Expected Extraction**:
- **Topics**: Budget Planning, Content Marketing, Influencer Partnerships, ABM Strategy, Q4 Planning
- **Action Items**: 
  - "Mike to prepare budget breakdown by Friday"
  - "Jennifer to share target account list in Slack"
  - "Reconvene next Tuesday for campaign roadmap"
- **Decisions**:
  - "Increase content marketing budget by 25%"
  - "Allocate $50k for influencer partnerships"
  - "Target healthcare and fintech sectors for ABM"
- **Sentiment**: Positive (collaborative, productive)
- **Key Participants**: Sarah Chen (meeting leader), Michael Rodriguez, Jennifer Lee

---

## 🏆 Bonus Challenges (Optional)

These are not required but will demonstrate exceptional skills:

### 1. Real-time Processing
- WebSocket endpoint for streaming LLM responses
- Progress updates during transcript processing

### 2. Multi-hop Querying
- "Show me all meetings where person X discussed topic Y"
- "Which topics were discussed by ACME Corp in October?"

### 3. Smart Deduplication
- Handle same person with name variations ("Mike", "Michael Rodriguez", "M. Rodriguez")
- Fuzzy matching for companies ("ACME", "ACME Corp", "ACME Corporation")

### 4. Advanced Analytics
- Topic co-occurrence matrix (which topics are discussed together?)
- Participant influence score (based on speaking patterns)
- Meeting effectiveness score

### 5. Graph Visualization
- Interactive network graph showing connections between people, topics, and meetings
- Use D3.js, vis.js, or similar

---

## ❓ Frequently Asked Questions

**Q: Can I use JavaScript instead of TypeScript?**  
A: We strongly prefer TypeScript. Our product is fully TypeScript, and type safety is critical.

**Q: Which LLM should I use?**  
A: OpenAI GPT-4/3.5 is recommended. If you use alternatives (Anthropic, local models), explain why.

**Q: Do I need to implement all bonus features?**  
A: No. Focus on core requirements first. Bonuses are for going above and beyond.

**Q: Can I use ORMs like Prisma/TypeORM?**  
A: Yes! We use Mongoose for MongoDB in Brain, so ORM experience is valuable.

**Q: How should I handle the OpenAI API key?**  
A: Environment variable. Include `.env.example` but never commit actual keys.

---

## 📬 Submission

When ready, send us:
1. Link to your GitHub repository (public or invite us as collaborator) to the recruiting team that contacted you
2. Brief video/Loom walkthrough (5-10 minutes)
3. Any notes about your approach or challenges faced
4. Your payment information to receive your hours

**Time Expectation**: 4-6 hours for core requirements. Take your time to do it well rather than rushing.

---

## 🧠 Why This Test?

This test simulates the core challenges you'll face in Brain:
- **Multi-database thinking**: Relational + embeddings (like our MongoDB + Weaviate + Memgraph)
- **Entity extraction & resolution**: Same challenges we face with people/org disambiguation
- **Semantic search**: Core feature of Brain's chat interface
- **LLM integration**: Prompt engineering, error handling, streaming
- **Data modeling**: How you think about relationships and schemas
- **Fullstack skills**: API design + modern frontend

Good luck! We're excited to see your solution. 🚀

---

**Brain Team @ 8 Figure Agency**

