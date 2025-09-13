-- ================================================================
-- SKILLMIND AI - PERSONA-BASED SYLLABUS KNOWLEDGE BASE SCHEMA
-- Production-Ready PostgreSQL Schema for AI Avatar Education Platform
-- ================================================================

-- ================================================================
-- EXTENSIONS & PREREQUISITES
-- ================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- Set timezone for consistent timestamps
SET timezone = 'UTC';

-- ================================================================
-- CORE ENUMS & TYPES
-- ================================================================

-- Content difficulty levels
CREATE TYPE difficulty_level AS ENUM (
    'beginner', 'intermediate', 'advanced', 'expert'
);

-- Content status lifecycle
CREATE TYPE content_status AS ENUM (
    'draft', 'review', 'approved', 'published', 'archived', 'deprecated'
);

-- Content types
CREATE TYPE content_type AS ENUM (
    'concept_explanation', 'step_by_step_tutorial', 'code_example', 
    'practice_exercise', 'assessment_question', 'troubleshooting_guide',
    'project', 'case_study', 'reference', 'media'
);

-- Content formats
CREATE TYPE content_format AS ENUM (
    'markdown', 'html', 'json', 'code', 'video', 'audio', 'image', 'interactive'
);

-- Cognitive levels (Bloom's Taxonomy)
CREATE TYPE cognitive_level AS ENUM (
    'remember', 'understand', 'apply', 'analyze', 'evaluate', 'create'
);

-- Learning styles
CREATE TYPE learning_style AS ENUM (
    'visual', 'auditory', 'kinesthetic', 'reading_writing', 'multimodal'
);

-- User progress states
CREATE TYPE progress_status AS ENUM (
    'not_started', 'in_progress', 'completed', 'mastered', 'needs_review'
);

-- Assessment types
CREATE TYPE assessment_type AS ENUM (
    'multiple_choice', 'single_choice', 'true_false', 'short_answer', 
    'coding_challenge', 'project', 'peer_review', 'portfolio'
);

-- Relationship types between content
CREATE TYPE relationship_type AS ENUM (
    'prerequisite', 'leads_to', 'related', 'depends_on', 'blocks', 'enhances'
);

-- AI Avatar roles
CREATE TYPE avatar_role AS ENUM (
    'teacher', 'tutor', 'mentor', 'examiner', 'peer'
);

-- ================================================================
-- 1. PERSONA MANAGEMENT
-- ================================================================

CREATE TABLE persona_profiles (
    persona_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    persona_name VARCHAR(100) NOT NULL UNIQUE,
    persona_code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    target_audience JSONB, -- Array of learner characteristics
    learning_objectives JSONB, -- Array of primary goals
    preferred_learning_styles learning_style[],
    difficulty_preference difficulty_level DEFAULT 'intermediate',
    pacing_preference VARCHAR(20) DEFAULT 'adaptive', -- 'fast', 'medium', 'slow', 'adaptive'
    engagement_preferences JSONB, -- Interaction styles, content types
    career_focus VARCHAR(100),
    time_commitment_hours_week INTEGER,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    is_active BOOLEAN DEFAULT true
);

CREATE INDEX idx_persona_profiles_code ON persona_profiles(persona_code);
CREATE INDEX idx_persona_profiles_active ON persona_profiles(is_active) WHERE is_active = true;

-- ================================================================
-- 2. CURRICULUM HIERARCHY (4 LEVELS)
-- ================================================================

-- Level 1: Modules (High-level organization)
CREATE TABLE curriculum_modules (
    module_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    learning_objectives JSONB, -- Array of module-level objectives
    difficulty_level difficulty_level NOT NULL,
    estimated_duration_minutes INTEGER,
    prerequisites TEXT[], -- Array of prerequisite module codes
    order_index INTEGER NOT NULL,
    
    -- Persona customization
    persona_adaptations JSONB, -- Persona-specific modifications
    
    -- Metadata
    version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    status content_status DEFAULT 'draft',
    
    CONSTRAINT chk_module_duration_positive CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_module_order_positive CHECK (order_index > 0)
);

-- Level 2: Components (Major topic groupings)
CREATE TABLE curriculum_components (
    component_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL REFERENCES curriculum_modules(module_id) ON DELETE CASCADE,
    component_code VARCHAR(20) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    learning_objectives JSONB,
    estimated_duration_minutes INTEGER,
    order_index INTEGER NOT NULL,
    
    -- Persona customization
    persona_emphasis JSONB, -- Different emphasis levels per persona
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(module_id, component_code),
    CONSTRAINT chk_component_duration_positive CHECK (estimated_duration_minutes > 0)
);

-- Level 3: Topics (Specific learning areas)
CREATE TABLE curriculum_topics (
    topic_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    component_id UUID NOT NULL REFERENCES curriculum_components(component_id) ON DELETE CASCADE,
    topic_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    learning_objectives JSONB,
    prerequisites TEXT[], -- Topic-level prerequisites
    estimated_duration_minutes INTEGER,
    difficulty_level difficulty_level,
    cognitive_level cognitive_level,
    order_index INTEGER NOT NULL,
    
    -- Skills taxonomy
    primary_skills TEXT[], -- Array of skill codes
    secondary_skills TEXT[], -- Supporting skills
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(component_id, topic_code)
);

-- Level 4: Concepts (Atomic learning units)
CREATE TABLE curriculum_concepts (
    concept_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id UUID NOT NULL REFERENCES curriculum_topics(topic_id) ON DELETE CASCADE,
    concept_code VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    content_type content_type NOT NULL,
    cognitive_level cognitive_level NOT NULL,
    estimated_duration_minutes INTEGER,
    complexity_score INTEGER DEFAULT 1, -- 1-10 scale
    order_index INTEGER NOT NULL,
    
    -- Learning design
    learning_objectives JSONB,
    key_concepts TEXT[], -- Important terms/concepts
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(topic_id, concept_code),
    CONSTRAINT chk_concept_complexity CHECK (complexity_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 3. CONTENT MANAGEMENT
-- ================================================================

-- Main content storage
CREATE TABLE content_chunks (
    chunk_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    concept_id UUID NOT NULL REFERENCES curriculum_concepts(concept_id) ON DELETE CASCADE,
    
    -- Basic information
    external_id VARCHAR(100) UNIQUE, -- For CSV imports and external references
    title VARCHAR(300) NOT NULL,
    description TEXT,
    content_type content_type NOT NULL,
    format content_format NOT NULL,
    language VARCHAR(10) DEFAULT 'en',
    
    -- Content storage
    content_markdown TEXT,
    content_html TEXT,
    content_json JSONB,
    content_plain_text TEXT, -- For search and embedding
    content_preview TEXT, -- First 200 characters for preview
    
    -- Educational metadata
    learning_objectives JSONB,
    prerequisites TEXT[],
    estimated_duration_minutes INTEGER,
    difficulty_level difficulty_level NOT NULL,
    cognitive_level cognitive_level NOT NULL,
    complexity_score INTEGER DEFAULT 1,
    
    -- Content quality metrics
    word_count INTEGER,
    token_count INTEGER,
    readability_score DECIMAL(3,1), -- Flesch-Kincaid grade level
    quality_score DECIMAL(3,1) DEFAULT 0, -- 0-10 calculated quality
    
    -- Search and discovery
    keywords TEXT[],
    search_weight INTEGER DEFAULT 5, -- 1-10 for search ranking
    
    -- Version control
    version VARCHAR(20) DEFAULT '1.0',
    parent_chunk_id UUID REFERENCES content_chunks(chunk_id),
    
    -- Lifecycle management
    status content_status DEFAULT 'draft',
    published_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    
    -- Audit fields
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    last_modified_by UUID,
    
    CONSTRAINT chk_content_duration_positive CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_content_complexity CHECK (complexity_score BETWEEN 1 AND 10),
    CONSTRAINT chk_content_quality CHECK (quality_score BETWEEN 0 AND 10),
    CONSTRAINT chk_search_weight CHECK (search_weight BETWEEN 1 AND 10)
);

-- Content versions for change tracking
CREATE TABLE content_versions (
    version_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    version_number VARCHAR(20) NOT NULL,
    content_snapshot JSONB NOT NULL, -- Full content at this version
    change_summary TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    
    UNIQUE(chunk_id, version_number)
);

-- Code examples (specialized content type)
CREATE TABLE code_examples (
    example_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    
    title VARCHAR(200) NOT NULL,
    description TEXT,
    programming_language VARCHAR(50) NOT NULL DEFAULT 'python',
    code_content TEXT NOT NULL,
    expected_output TEXT,
    explanation TEXT,
    
    -- Execution metadata
    is_executable BOOLEAN DEFAULT false,
    execution_environment VARCHAR(100),
    dependencies TEXT[], -- Required packages/imports
    
    -- Educational context
    concepts_demonstrated TEXT[],
    difficulty_level difficulty_level NOT NULL,
    estimated_runtime_seconds INTEGER,
    
    -- Quality assurance
    is_tested BOOLEAN DEFAULT false,
    test_results JSONB,
    last_tested_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Media assets
CREATE TABLE content_media_assets (
    asset_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    
    asset_type VARCHAR(50) NOT NULL, -- 'image', 'video', 'audio', 'document'
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    file_size_bytes BIGINT,
    mime_type VARCHAR(100),
    
    -- Media metadata
    title VARCHAR(200),
    description TEXT,
    alt_text TEXT, -- For accessibility
    duration_seconds INTEGER, -- For video/audio
    resolution VARCHAR(20), -- For images/video
    
    -- Usage tracking
    download_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Content relationships (prerequisites, dependencies, etc.)
CREATE TABLE content_relationships (
    relationship_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    source_chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    target_chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    relationship_type relationship_type NOT NULL,
    relationship_strength VARCHAR(20) DEFAULT 'medium', -- 'weak', 'medium', 'strong'
    weight DECIMAL(3,2) DEFAULT 1.0, -- For algorithms
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    UNIQUE(source_chunk_id, target_chunk_id, relationship_type),
    CONSTRAINT chk_no_self_reference CHECK (source_chunk_id != target_chunk_id)
);

-- ================================================================
-- 4. AI AVATAR SYSTEM
-- ================================================================

-- AI Avatar role definitions
CREATE TABLE ai_avatar_roles (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name avatar_role NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    role_description TEXT NOT NULL,
    
    -- Role characteristics
    interaction_style JSONB, -- Teaching approach, tone, etc.
    assessment_types JSONB, -- Types of assessment this role provides
    content_focus JSONB, -- What content types this role emphasizes
    target_audience JSONB, -- Which learner types benefit most
    
    -- Behavioral parameters
    feedback_style VARCHAR(50), -- 'detailed', 'concise', 'encouraging'
    questioning_approach VARCHAR(50), -- 'socratic', 'direct', 'guided'
    error_handling_style VARCHAR(50), -- 'corrective', 'supportive', 'challenging'
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Role-specific content variations
CREATE TABLE content_role_variations (
    variation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES ai_avatar_roles(role_id) ON DELETE CASCADE,
    
    -- Role-specific delivery parameters
    instruction_type VARCHAR(50), -- 'direct', 'guided_discovery', 'socratic'
    teaching_strategy VARCHAR(50), -- 'lecture', 'demonstration', 'practice'
    interaction_style VARCHAR(50), -- 'formal', 'conversational', 'encouraging'
    
    -- Customized content elements
    role_specific_intro TEXT,
    role_specific_summary TEXT,
    role_specific_exercises JSONB,
    
    -- Assessment approach for this role
    help_type VARCHAR(50), -- 'hint', 'explanation', 'example'
    assessment_type VARCHAR(50),
    question_format VARCHAR(50),
    
    -- Collaboration settings
    collaboration_type VARCHAR(50), -- 'individual', 'group', 'peer_review'
    guidance_type VARCHAR(50), -- 'step_by_step', 'milestone', 'self_directed'
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(chunk_id, role_id)
);

-- Persona-specific content adaptations
CREATE TABLE persona_content_adaptations (
    adaptation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    persona_id UUID NOT NULL REFERENCES persona_profiles(persona_id) ON DELETE CASCADE,
    
    -- Adaptation parameters
    difficulty_adjustment INTEGER DEFAULT 0, -- -2 to +2 relative to base
    pacing_multiplier DECIMAL(3,2) DEFAULT 1.0, -- Speed adjustment
    emphasis_level VARCHAR(20) DEFAULT 'standard', -- 'light', 'standard', 'heavy'
    
    -- Content modifications
    additional_examples JSONB,
    simplified_explanations TEXT,
    advanced_extensions TEXT,
    persona_specific_context TEXT,
    
    -- Delivery preferences
    preferred_formats content_format[],
    interaction_preferences JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(chunk_id, persona_id)
);

-- ================================================================
-- 5. SKILLS TAXONOMY & TAGGING
-- ================================================================

-- Skills taxonomy (hierarchical skill structure)
CREATE TABLE skill_taxonomy (
    skill_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_skill_id UUID REFERENCES skill_taxonomy(skill_id),
    
    skill_name VARCHAR(200) NOT NULL,
    skill_code VARCHAR(50) NOT NULL UNIQUE,
    skill_description TEXT,
    skill_level INTEGER NOT NULL DEFAULT 1, -- Depth in hierarchy
    skill_category VARCHAR(100), -- 'technical', 'soft', 'domain'
    
    -- Industry relevance
    industry_relevance JSONB, -- Which industries value this skill
    job_roles JSONB, -- Job roles that need this skill
    skill_demand_score INTEGER, -- 1-10 market demand
    
    -- Learning metadata
    typical_learning_duration_hours INTEGER,
    prerequisite_skills UUID[], -- Array of skill_ids
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    
    CONSTRAINT chk_skill_level_positive CHECK (skill_level > 0),
    CONSTRAINT chk_skill_demand CHECK (skill_demand_score BETWEEN 1 AND 10)
);

-- Tag vocabularies (controlled vocabulary for tagging)
CREATE TABLE tag_vocabularies (
    vocabulary_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category VARCHAR(50) NOT NULL,
    tag_value VARCHAR(100) NOT NULL,
    display_name VARCHAR(200) NOT NULL,
    description TEXT,
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(category, tag_value)
);

-- Content tagging system
CREATE TABLE content_tags (
    tag_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    tag_category VARCHAR(50) NOT NULL,
    tag_value VARCHAR(100) NOT NULL,
    tag_weight DECIMAL(3,2) DEFAULT 1.0, -- Relevance weight
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    UNIQUE(chunk_id, tag_category, tag_value),
    CONSTRAINT chk_tag_weight CHECK (tag_weight BETWEEN 0 AND 2.0),
    FOREIGN KEY (tag_category, tag_value) 
        REFERENCES tag_vocabularies(category, tag_value) ON UPDATE CASCADE
);

-- ================================================================
-- 6. VECTOR EMBEDDINGS & SEMANTIC SEARCH
-- ================================================================

-- Embedding models registry
CREATE TABLE embedding_models (
    model_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(200) NOT NULL UNIQUE,
    model_version VARCHAR(50),
    provider VARCHAR(100), -- 'openai', 'huggingface', 'cohere', etc.
    embedding_dimensions INTEGER NOT NULL,
    context_window INTEGER,
    model_description TEXT,
    
    -- Performance characteristics
    tokens_per_request_limit INTEGER,
    requests_per_minute_limit INTEGER,
    cost_per_1k_tokens DECIMAL(10,6),
    
    -- Configuration
    model_parameters JSONB,
    is_active BOOLEAN DEFAULT true,
    is_default BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_embedding_dims_positive CHECK (embedding_dimensions > 0)
);

-- Vector embeddings storage
CREATE TABLE content_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES embedding_models(model_id),
    
    -- Vector data
    embedding_vector vector NOT NULL, -- pgvector type
    embedding_metadata JSONB,
    
    -- Generation metadata
    content_hash TEXT NOT NULL, -- Hash of content when embedded
    token_count INTEGER,
    generation_time_ms INTEGER,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(chunk_id, model_id)
);

-- ================================================================
-- 7. ASSESSMENT SYSTEM
-- ================================================================

-- Assessment definitions
CREATE TABLE assessments (
    assessment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    
    -- Basic information
    title VARCHAR(300) NOT NULL,
    description TEXT,
    assessment_type assessment_type NOT NULL,
    difficulty_level difficulty_level NOT NULL,
    
    -- Assessment content
    question_text TEXT NOT NULL,
    instructions TEXT,
    hints JSONB, -- Array of hints
    
    -- Scoring configuration
    points_possible INTEGER DEFAULT 100,
    passing_score INTEGER DEFAULT 70,
    time_limit_minutes INTEGER,
    attempts_allowed INTEGER DEFAULT 3,
    
    -- Question metadata
    cognitive_level cognitive_level NOT NULL,
    estimated_time_minutes INTEGER,
    auto_gradable BOOLEAN DEFAULT false,
    
    -- Randomization
    randomize_options BOOLEAN DEFAULT false,
    option_pool_size INTEGER, -- For question banks
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    
    CONSTRAINT chk_points_positive CHECK (points_possible > 0),
    CONSTRAINT chk_passing_reasonable CHECK (passing_score BETWEEN 0 AND points_possible)
);

-- Multiple choice options
CREATE TABLE assessment_options (
    option_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID NOT NULL REFERENCES assessments(assessment_id) ON DELETE CASCADE,
    
    option_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT false,
    explanation TEXT,
    order_index INTEGER NOT NULL,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(assessment_id, order_index)
);

-- Coding challenge test cases
CREATE TABLE assessment_test_cases (
    test_case_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID NOT NULL REFERENCES assessments(assessment_id) ON DELETE CASCADE,
    
    test_name VARCHAR(200) NOT NULL,
    input_data TEXT,
    expected_output TEXT NOT NULL,
    is_public BOOLEAN DEFAULT false, -- Visible to students
    weight DECIMAL(3,2) DEFAULT 1.0, -- Relative importance
    timeout_seconds INTEGER DEFAULT 10,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_test_weight CHECK (weight > 0)
);

-- ================================================================
-- 8. USER PROGRESS & ANALYTICS
-- ================================================================

-- User learning progress tracking
CREATE TABLE user_progress (
    progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL, -- Links to external user system
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    persona_id UUID REFERENCES persona_profiles(persona_id),
    role_id UUID REFERENCES ai_avatar_roles(role_id),
    
    -- Progress status
    status progress_status NOT NULL DEFAULT 'not_started',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    mastery_score DECIMAL(5,2), -- Final mastery level achieved
    
    -- Engagement metrics
    time_spent_minutes INTEGER DEFAULT 0,
    session_count INTEGER DEFAULT 0,
    interaction_count INTEGER DEFAULT 0,
    
    -- Learning analytics
    difficulty_experienced difficulty_level,
    help_requests_count INTEGER DEFAULT 0,
    error_count INTEGER DEFAULT 0,
    retry_count INTEGER DEFAULT 0,
    
    -- Timestamps
    first_accessed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_accessed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,
    
    -- Audit
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, chunk_id),
    CONSTRAINT chk_completion_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_mastery_score CHECK (mastery_score BETWEEN 0 AND 100)
);

-- Assessment attempt tracking
CREATE TABLE user_assessment_attempts (
    attempt_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    assessment_id UUID NOT NULL REFERENCES assessments(assessment_id) ON DELETE CASCADE,
    
    attempt_number INTEGER NOT NULL, -- 1st, 2nd attempt, etc.
    responses JSONB NOT NULL, -- User's answers
    
    -- Scoring
    score_earned DECIMAL(8,2),
    max_score_possible DECIMAL(8,2),
    percentage_score DECIMAL(5,2),
    is_passing BOOLEAN,
    
    -- Timing
    time_spent_minutes INTEGER,
    started_at TIMESTAMPTZ NOT NULL,
    submitted_at TIMESTAMPTZ,
    
    -- Grading
    auto_graded BOOLEAN DEFAULT false,
    graded_at TIMESTAMPTZ,
    graded_by UUID,
    feedback_provided TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, assessment_id, attempt_number),
    CONSTRAINT chk_attempt_number_positive CHECK (attempt_number > 0)
);

-- Adaptive learning path adjustments
CREATE TABLE user_learning_adaptations (
    adaptation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    persona_id UUID REFERENCES persona_profiles(persona_id),
    
    -- Adaptation details
    adaptation_type VARCHAR(50) NOT NULL, -- 'difficulty', 'pacing', 'style', 'content'
    adaptation_reason TEXT,
    original_value TEXT,
    adapted_value TEXT,
    
    -- Effectiveness tracking
    improvement_observed BOOLEAN,
    effectiveness_score DECIMAL(3,1), -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(50), -- 'system', 'instructor', 'self'
    
    UNIQUE(user_id, chunk_id, adaptation_type)
);

-- Learning path sequences
CREATE TABLE learning_paths (
    path_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    persona_id UUID NOT NULL REFERENCES persona_profiles(persona_id),
    
    path_name VARCHAR(200) NOT NULL,
    path_description TEXT,
    
    -- Path configuration
    target_skills JSONB, -- Array of skill objectives
    estimated_completion_weeks INTEGER,
    difficulty_progression difficulty_level[],
    
    -- Path sequence
    chunk_sequence UUID[], -- Ordered array of chunk_ids
    current_position INTEGER DEFAULT 0,
    
    -- Progress tracking
    started_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estimated_completion_at TIMESTAMPTZ,
    actual_completion_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 9. SYSTEM LOGGING & AUDIT
-- ================================================================

-- System activity logging
CREATE TABLE system_logs (
    log_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    log_level VARCHAR(20) NOT NULL DEFAULT 'INFO', -- DEBUG, INFO, WARN, ERROR, FATAL
    log_type VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    
    -- Context information
    user_id UUID,
    session_id UUID,
    chunk_id UUID,
    
    -- Technical details
    metadata JSONB,
    stack_trace TEXT,
    request_id UUID,
    ip_address INET,
    user_agent TEXT,
    
    -- Performance metrics
    response_time_ms INTEGER,
    memory_usage_mb INTEGER,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_log_level CHECK (log_level IN ('DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'))
);

-- ================================================================
-- 10. MATERIALIZED VIEWS FOR ANALYTICS
-- ================================================================

-- Content hierarchy with full path
CREATE MATERIALIZED VIEW mv_content_hierarchy AS
SELECT 
    co.concept_id,
    co.title as concept_title,
    t.topic_id,
    t.title as topic_title,
    comp.component_id,
    comp.title as component_title,
    m.module_id,
    m.title as module_title,
    
    -- Full path for navigation
    m.module_code || ' → ' || comp.component_code || ' → ' || t.topic_code || ' → ' || co.concept_code as full_path,
    
    -- Aggregated metadata
    co.difficulty_level,
    co.cognitive_level,
    co.estimated_duration_minutes,
    m.prerequisites as module_prerequisites,
    
    -- Ordering
    m.order_index as module_order,
    comp.order_index as component_order,
    t.order_index as topic_order,
    co.order_index as concept_order
    
FROM curriculum_concepts co
JOIN curriculum_topics t ON co.topic_id = t.topic_id
JOIN curriculum_components comp ON t.component_id = comp.component_id
JOIN curriculum_modules m ON comp.module_id = m.module_id
ORDER BY m.order_index, comp.order_index, t.order_index, co.order_index;

-- User progress summary by user and module
CREATE MATERIALIZED VIEW mv_user_progress_summary AS
SELECT 
    up.user_id,
    ch.module_id,
    up.persona_id,
    
    -- Progress metrics
    COUNT(*) as total_concepts,
    COUNT(CASE WHEN up.status = 'completed' THEN 1 END) as completed_concepts,
    COUNT(CASE WHEN up.status = 'in_progress' THEN 1 END) as in_progress_concepts,
    
    -- Completion percentage
    ROUND(
        COUNT(CASE WHEN up.status = 'completed' THEN 1 END)::DECIMAL / 
        COUNT(*)::DECIMAL * 100, 2
    ) as completion_percentage,
    
    -- Time metrics
    SUM(up.time_spent_minutes) as total_time_minutes,
    AVG(up.mastery_score) as average_mastery_score,
    
    -- Engagement metrics
    SUM(up.session_count) as total_sessions,
    SUM(up.interaction_count) as total_interactions,
    
    -- Timeline
    MIN(up.first_accessed_at) as first_access,
    MAX(up.last_accessed_at) as last_access
    
FROM user_progress up
JOIN content_chunks cc ON up.chunk_id = cc.chunk_id
JOIN curriculum_concepts co ON cc.concept_id = co.concept_id
JOIN mv_content_hierarchy ch ON co.concept_id = ch.concept_id
GROUP BY up.user_id, ch.module_id, up.persona_id;

-- Content analytics and effectiveness
CREATE MATERIALIZED VIEW mv_content_analytics AS
SELECT 
    cc.chunk_id,
    cc.title,
    cc.content_type,
    cc.difficulty_level,
    
    -- Usage statistics
    COUNT(up.user_id) as total_users,
    COUNT(CASE WHEN up.status = 'completed' THEN 1 END) as completion_count,
    COUNT(CASE WHEN up.status = 'in_progress' THEN 1 END) as in_progress_count,
    
    -- Effectiveness metrics
    ROUND(
        COUNT(CASE WHEN up.status = 'completed' THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(up.user_id), 0)::DECIMAL * 100, 2
    ) as completion_rate,
    
    AVG(up.time_spent_minutes) as avg_time_spent,
    AVG(up.mastery_score) as avg_mastery_score,
    AVG(up.session_count) as avg_sessions_needed,
    
    -- Difficulty analysis
    AVG(CASE 
        WHEN up.difficulty_experienced = 'beginner' THEN 1
        WHEN up.difficulty_experienced = 'intermediate' THEN 2
        WHEN up.difficulty_experienced = 'advanced' THEN 3
        WHEN up.difficulty_experienced = 'expert' THEN 4
        ELSE NULL
    END) as avg_difficulty_experienced,
    
    -- Quality indicators
    cc.quality_score,
    cc.word_count,
    cc.readability_score,
    
    -- Last updated
    MAX(up.updated_at) as last_activity
    
FROM content_chunks cc
LEFT JOIN user_progress up ON cc.chunk_id = up.chunk_id
GROUP BY cc.chunk_id, cc.title, cc.content_type, cc.difficulty_level, 
         cc.quality_score, cc.word_count, cc.readability_score;

-- ================================================================
-- INDEXES FOR PERFORMANCE
-- ================================================================

-- Curriculum hierarchy indexes
CREATE INDEX idx_curriculum_modules_code ON curriculum_modules(module_code);
CREATE INDEX idx_curriculum_modules_status ON curriculum_modules(status);
CREATE INDEX idx_curriculum_modules_difficulty ON curriculum_modules(difficulty_level);
CREATE INDEX idx_curriculum_components_module ON curriculum_components(module_id, order_index);
CREATE INDEX idx_curriculum_topics_component ON curriculum_topics(component_id, order_index);
CREATE INDEX idx_curriculum_concepts_topic ON curriculum_concepts(topic_id, order_index);

-- Content indexes
CREATE INDEX idx_content_chunks_concept ON content_chunks(concept_id);
CREATE INDEX idx_content_chunks_external_id ON content_chunks(external_id) WHERE external_id IS NOT NULL;
CREATE INDEX idx_content_chunks_type_status ON content_chunks(content_type, status);
CREATE INDEX idx_content_chunks_difficulty ON content_chunks(difficulty_level);
CREATE INDEX idx_content_chunks_search_weight ON content_chunks(search_weight DESC);
CREATE INDEX idx_content_chunks_published ON content_chunks(published_at DESC) WHERE status = 'published';

-- Full text search indexes
CREATE INDEX idx_content_chunks_search_text ON content_chunks 
    USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || COALESCE(content_plain_text, '')));
CREATE INDEX idx_content_chunks_keywords ON content_chunks USING GIN(keywords);

-- Vector search indexes (HNSW for pgvector)
CREATE INDEX idx_content_embeddings_vector ON content_embeddings 
    USING hnsw (embedding_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX idx_content_embeddings_chunk ON content_embeddings(chunk_id);

-- Relationship indexes
CREATE INDEX idx_content_relationships_source ON content_relationships(source_chunk_id, relationship_type);
CREATE INDEX idx_content_relationships_target ON content_relationships(target_chunk_id, relationship_type);

-- AI Avatar system indexes
CREATE INDEX idx_avatar_roles_active ON ai_avatar_roles(is_active) WHERE is_active = true;
CREATE INDEX idx_content_role_variations_chunk_role ON content_role_variations(chunk_id, role_id);

-- Tagging indexes
CREATE INDEX idx_content_tags_chunk ON content_tags(chunk_id);
CREATE INDEX idx_content_tags_category_value ON content_tags(tag_category, tag_value);
CREATE INDEX idx_content_tags_weight ON content_tags(tag_weight DESC);

-- Skills taxonomy indexes
CREATE INDEX idx_skill_taxonomy_parent ON skill_taxonomy(parent_skill_id);
CREATE INDEX idx_skill_taxonomy_code ON skill_taxonomy(skill_code);
CREATE INDEX idx_skill_taxonomy_category ON skill_taxonomy(skill_category);

-- Assessment indexes
CREATE INDEX idx_assessments_chunk ON assessments(chunk_id);
CREATE INDEX idx_assessments_type_difficulty ON assessments(assessment_type, difficulty_level);
CREATE INDEX idx_assessment_options_assessment ON assessment_options(assessment_id, order_index);

-- User progress indexes
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_chunk ON user_progress(chunk_id);
CREATE INDEX idx_user_progress_status ON user_progress(status);
CREATE INDEX idx_user_progress_user_status ON user_progress(user_id, status);
CREATE INDEX idx_user_progress_persona ON user_progress(persona_id) WHERE persona_id IS NOT NULL;
CREATE INDEX idx_user_progress_updated ON user_progress(updated_at DESC);

-- Assessment attempts indexes
CREATE INDEX idx_user_assessment_attempts_user ON user_assessment_attempts(user_id);
CREATE INDEX idx_user_assessment_attempts_assessment ON user_assessment_attempts(assessment_id);
CREATE INDEX idx_user_assessment_attempts_submitted ON user_assessment_attempts(submitted_at DESC) WHERE submitted_at IS NOT NULL;

-- System logs indexes (partitioning recommended for large scale)
CREATE INDEX idx_system_logs_created ON system_logs(created_at DESC);
CREATE INDEX idx_system_logs_type_level ON system_logs(log_type, log_level);
CREATE INDEX idx_system_logs_user ON system_logs(user_id) WHERE user_id IS NOT NULL;

-- ================================================================
-- ROW LEVEL SECURITY (RLS)
-- ================================================================

-- Enable RLS on user-specific tables
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_assessment_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_learning_adaptations ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_paths ENABLE ROW LEVEL SECURITY;

-- Create security policies

-- Users can only access their own progress
CREATE POLICY user_progress_isolation ON user_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Users can only access their own assessment attempts
CREATE POLICY user_assessment_isolation ON user_assessment_attempts
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Users can only access their own learning adaptations
CREATE POLICY user_adaptation_isolation ON user_learning_adaptations
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Users can only access their own learning paths
CREATE POLICY user_path_isolation ON learning_paths
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Admin bypass policies (create role-based access)
CREATE POLICY admin_full_access ON user_progress
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_full_access ON user_assessment_attempts
    FOR ALL TO admin_users
    USING (true);

-- ================================================================
-- UTILITY FUNCTIONS
-- ================================================================

-- Function to refresh materialized views
CREATE OR REPLACE FUNCTION refresh_analytics_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_content_hierarchy;
    REFRESH MATERIALIZED VIEW mv_user_progress_summary;
    REFRESH MATERIALIZED VIEW mv_content_analytics;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate content quality score
CREATE OR REPLACE FUNCTION calculate_content_quality(
    p_chunk_id UUID
) RETURNS DECIMAL AS $$
DECLARE
    quality_score DECIMAL;
    word_count_score DECIMAL;
    readability_score_adj DECIMAL;
    tag_completeness_score DECIMAL;
    engagement_score DECIMAL;
BEGIN
    -- Get basic content metrics
    SELECT 
        CASE 
            WHEN cc.word_count < 100 THEN 2
            WHEN cc.word_count < 300 THEN 6
            WHEN cc.word_count < 800 THEN 10
            WHEN cc.word_count < 1500 THEN 8
            ELSE 6
        END,
        CASE 
            WHEN cc.readability_score IS NULL THEN 5
            WHEN cc.readability_score BETWEEN 6 AND 12 THEN 10
            WHEN cc.readability_score BETWEEN 4 AND 15 THEN 7
            ELSE 4
        END
    INTO word_count_score, readability_score_adj
    FROM content_chunks cc
    WHERE cc.chunk_id = p_chunk_id;
    
    -- Calculate tag completeness (having diverse tags)
    SELECT 
        CASE 
            WHEN COUNT(DISTINCT ct.tag_category) >= 4 THEN 10
            WHEN COUNT(DISTINCT ct.tag_category) >= 2 THEN 7
            WHEN COUNT(DISTINCT ct.tag_category) >= 1 THEN 5
            ELSE 2
        END
    INTO tag_completeness_score
    FROM content_tags ct
    WHERE ct.chunk_id = p_chunk_id;
    
    -- Calculate engagement score from user progress
    SELECT 
        CASE 
            WHEN AVG(up.mastery_score) >= 85 THEN 10
            WHEN AVG(up.mastery_score) >= 70 THEN 8
            WHEN AVG(up.mastery_score) >= 50 THEN 6
            ELSE 4
        END
    INTO engagement_score
    FROM user_progress up
    WHERE up.chunk_id = p_chunk_id AND up.mastery_score IS NOT NULL;
    
    -- Calculate weighted average
    quality_score := (
        (word_count_score * 0.25) + 
        (COALESCE(readability_score_adj, 5) * 0.25) + 
        (tag_completeness_score * 0.25) + 
        (COALESCE(engagement_score, 5) * 0.25)
    );
    
    RETURN ROUND(quality_score, 1);
END;
$$ LANGUAGE plpgsql;

-- Function to get content recommendations based on user progress
CREATE OR REPLACE FUNCTION get_content_recommendations(
    p_user_id UUID,
    p_persona_id UUID DEFAULT NULL,
    p_limit INTEGER DEFAULT 10
) RETURNS TABLE (
    chunk_id UUID,
    title VARCHAR,
    content_type content_type,
    difficulty_level difficulty_level,
    estimated_duration_minutes INTEGER,
    recommendation_score DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    WITH user_completed_content AS (
        SELECT up.chunk_id, up.mastery_score
        FROM user_progress up
        WHERE up.user_id = p_user_id 
        AND up.status IN ('completed', 'mastered')
    ),
    user_preferences AS (
        SELECT 
            mode() WITHIN GROUP (ORDER BY cc.difficulty_level) as preferred_difficulty,
            mode() WITHIN GROUP (ORDER BY cc.content_type) as preferred_type
        FROM user_completed_content ucc
        JOIN content_chunks cc ON ucc.chunk_id = cc.chunk_id
    ),
    candidate_content AS (
        SELECT 
            cc.chunk_id,
            cc.title,
            cc.content_type,
            cc.difficulty_level,
            cc.estimated_duration_minutes,
            
            -- Scoring factors
            CASE WHEN cc.difficulty_level = up.preferred_difficulty THEN 3.0 ELSE 1.0 END as difficulty_match,
            CASE WHEN cc.content_type = up.preferred_type THEN 2.0 ELSE 1.0 END as type_match,
            cc.quality_score,
            cc.search_weight,
            
            -- Persona adaptation bonus
            CASE WHEN pca.persona_id IS NOT NULL THEN 1.5 ELSE 1.0 END as persona_bonus
            
        FROM content_chunks cc
        CROSS JOIN user_preferences up
        LEFT JOIN user_completed_content ucc ON cc.chunk_id = ucc.chunk_id
        LEFT JOIN persona_content_adaptations pca ON cc.chunk_id = pca.chunk_id AND pca.persona_id = p_persona_id
        
        WHERE cc.status = 'published'
        AND ucc.chunk_id IS NULL  -- Not already completed
        AND NOT EXISTS (
            SELECT 1 FROM user_progress up2 
            WHERE up2.user_id = p_user_id AND up2.chunk_id = cc.chunk_id
        )
    )
    SELECT 
        cc.chunk_id,
        cc.title,
        cc.content_type,
        cc.difficulty_level,
        cc.estimated_duration_minutes,
        ROUND(
            (cc.difficulty_match * cc.type_match * cc.persona_bonus * 
             (cc.quality_score + cc.search_weight) / 2.0), 2
        ) as recommendation_score
    FROM candidate_content cc
    ORDER BY recommendation_score DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to update content quality scores for all content
CREATE OR REPLACE FUNCTION update_all_content_quality_scores()
RETURNS INTEGER AS $$
DECLARE
    updated_count INTEGER := 0;
    chunk_record RECORD;
    new_quality_score DECIMAL;
BEGIN
    FOR chunk_record IN 
        SELECT chunk_id FROM content_chunks WHERE status = 'published'
    LOOP
        new_quality_score := calculate_content_quality(chunk_record.chunk_id);
        
        UPDATE content_chunks 
        SET quality_score = new_quality_score,
            updated_at = CURRENT_TIMESTAMP
        WHERE chunk_id = chunk_record.chunk_id;
        
        updated_count := updated_count + 1;
    END LOOP;
    
    RETURN updated_count;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ================================================================

-- Update timestamps trigger function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply timestamp triggers to relevant tables
CREATE TRIGGER tr_persona_profiles_updated_at
    BEFORE UPDATE ON persona_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_curriculum_modules_updated_at
    BEFORE UPDATE ON curriculum_modules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_content_chunks_updated_at
    BEFORE UPDATE ON content_chunks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER tr_user_progress_updated_at
    BEFORE UPDATE ON user_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Version tracking trigger for content_chunks
CREATE OR REPLACE FUNCTION create_content_version()
RETURNS TRIGGER AS $$
BEGIN
    -- Only create version if content actually changed
    IF OLD IS DISTINCT FROM NEW AND 
       (OLD.content_markdown IS DISTINCT FROM NEW.content_markdown OR
        OLD.title IS DISTINCT FROM NEW.title OR
        OLD.description IS DISTINCT FROM NEW.description) THEN
        
        INSERT INTO content_versions (
            chunk_id, version_number, content_snapshot, 
            change_summary, created_by
        ) VALUES (
            NEW.chunk_id, 
            NEW.version,
            row_to_json(OLD),
            'Automated version on update',
            NEW.last_modified_by
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_content_chunks_versioning
    AFTER UPDATE ON content_chunks
    FOR EACH ROW EXECUTE FUNCTION create_content_version();

-- ================================================================
-- INITIAL SETUP DATA
-- ================================================================

-- Create default embedding model
INSERT INTO embedding_models (
    model_name, model_version, provider, embedding_dimensions,
    context_window, model_description, is_active, is_default
) VALUES (
    'sentence-transformers/all-MiniLM-L6-v2', 'v1', 'huggingface', 384,
    512, 'Lightweight sentence transformer optimized for educational content',
    true, true
);

-- Create default AI avatar roles
INSERT INTO ai_avatar_roles (role_name, display_name, role_description, interaction_style, assessment_types, content_focus, target_audience, feedback_style, questioning_approach, error_handling_style) VALUES
('teacher', 'AI Teacher', 'Direct instructional role providing comprehensive explanations', 
 '{"approach": "structured", "tone": "authoritative", "style": "comprehensive"}'::jsonb,
 '["knowledge_check", "comprehensive_exam", "project_evaluation"]'::jsonb,
 '["concept_explanation", "tutorial", "reference"]'::jsonb,
 '["visual_learners", "structured_learners", "comprehensive_learners"]'::jsonb,
 'detailed', 'direct', 'corrective'),

('tutor', 'AI Tutor', 'Interactive support providing personalized guidance', 
 '{"approach": "adaptive", "tone": "supportive", "style": "interactive"}'::jsonb,
 '["practice_exercise", "hint_provision", "progress_check"]'::jsonb,
 '["step_by_step_tutorial", "practice_exercise", "troubleshooting_guide"]'::jsonb,
 '["struggling_learners", "interactive_learners", "adaptive_learners"]'::jsonb,
 'encouraging', 'guided', 'supportive'),

('mentor', 'AI Mentor', 'Career guidance and industry insights provider', 
 '{"approach": "advisory", "tone": "experienced", "style": "strategic"}'::jsonb,
 '["career_guidance", "industry_project", "portfolio_review"]'::jsonb,
 '["case_study", "project", "industry_example"]'::jsonb,
 '["career_switchers", "professionals", "goal_oriented_learners"]'::jsonb,
 'strategic', 'socratic', 'challenging'),

('examiner', 'AI Examiner', 'Assessment and evaluation specialist', 
 '{"approach": "evaluative", "tone": "objective", "style": "precise"}'::jsonb,
 '["formal_assessment", "certification_exam", "skill_validation"]'::jsonb,
 '["assessment_question", "coding_challenge", "project"]'::jsonb,
 '["certification_seekers", "competency_focused", "goal_oriented_learners"]'::jsonb,
 'objective', 'direct', 'corrective'),

('peer', 'AI Study Buddy', 'Collaborative learning facilitator', 
 '{"approach": "collaborative", "tone": "casual", "style": "friendly"}'::jsonb,
 '["peer_review", "group_discussion", "collaborative_project"]'::jsonb,
 '["practice_exercise", "case_study", "project"]'::jsonb,
 '["social_learners", "collaborative_workers", "discussion_oriented"]'::jsonb,
 'casual', 'collaborative', 'supportive');

-- Create default tag vocabularies
INSERT INTO tag_vocabularies (category, tag_value, display_name, description) VALUES
-- Difficulty levels
('difficulty', 'beginner', 'Beginner', 'Suitable for absolute beginners'),
('difficulty', 'intermediate', 'Intermediate', 'Requires basic understanding'),
('difficulty', 'advanced', 'Advanced', 'For experienced learners'),
('difficulty', 'expert', 'Expert', 'Highly specialized content'),

-- Learning styles
('learning_style', 'visual', 'Visual', 'Diagrams, charts, and visual aids'),
('learning_style', 'auditory', 'Auditory', 'Audio explanations and discussions'),
('learning_style', 'kinesthetic', 'Hands-on', 'Interactive exercises and practice'),
('learning_style', 'reading_writing', 'Reading/Writing', 'Text-based learning'),

-- Subject areas
('subject', 'python', 'Python Programming', 'Python language specific'),
('subject', 'programming', 'General Programming', 'Programming concepts'),
('subject', 'computer_science', 'Computer Science', 'CS fundamentals'),

-- Content focus areas
('focus_area', 'installation_setup', 'Installation & Setup', 'Environment configuration'),
('focus_area', 'syntax_basics', 'Language Syntax', 'Programming syntax and structure'),
('focus_area', 'data_structures', 'Data Structures', 'Lists, dicts, sets, tuples'),
('focus_area', 'control_flow', 'Control Flow', 'Conditionals and loops'),
('focus_area', 'functions', 'Functions', 'Function definition and usage'),
('focus_area', 'oop', 'Object-Oriented Programming', 'Classes and objects'),
('focus_area', 'file_handling', 'File Operations', 'File I/O operations'),
('focus_area', 'error_handling', 'Error Handling', 'Exceptions and debugging'),
('focus_area', 'libraries', 'Libraries & Modules', 'External libraries'),
('focus_area', 'projects', 'Projects & Applications', 'Real-world applications');

-- Create ambitious placement seeker persona
INSERT INTO persona_profiles (
    persona_name, persona_code, description, target_audience, learning_objectives,
    preferred_learning_styles, difficulty_preference, pacing_preference,
    engagement_preferences, career_focus, time_commitment_hours_week
) VALUES (
    'Ambitious Placement Seeker', 'ambitious-placement-seeker',
    'Goal-driven learners focused on securing high-paying tech jobs through intensive skill development',
    '["college_students", "career_switchers", "bootcamp_graduates", "job_seekers"]'::jsonb,
    '["master_technical_interviews", "build_impressive_portfolio", "understand_system_design", "develop_problem_solving_skills"]'::jsonb,
    ARRAY['kinesthetic', 'visual']::learning_style[],
    'intermediate',
    'fast',
    '{"interaction_style": "challenge_focused", "feedback_preference": "immediate", "difficulty_progression": "rapid"}'::jsonb,
    'Software Engineering',
    25
);

-- ================================================================
-- PERFORMANCE OPTIMIZATION RECOMMENDATIONS
-- ================================================================

/*
PERFORMANCE OPTIMIZATION NOTES:

1. **Partitioning Strategy**
   - Partition system_logs by created_at (monthly partitions)
   - Partition user_progress by user_id hash for large user bases
   - Consider partitioning user_assessment_attempts by created_at

2. **Connection Pooling**
   - Use PgBouncer with transaction pooling
   - Configure pool sizes based on concurrent users
   - Monitor connection usage patterns

3. **Caching Strategy**
   - Cache frequently accessed content_chunks in Redis
   - Cache user progress summaries for active users
   - Cache materialized view results with TTL

4. **Vector Search Optimization**
   - Tune HNSW parameters based on dataset size
   - Use ef_search parameter optimization
   - Consider multiple embedding models for different content types

5. **Query Optimization**
   - Monitor slow queries with pg_stat_statements
   - Use EXPLAIN ANALYZE for complex queries
   - Consider query result caching for analytics

6. **Storage Optimization**
   - Use TOAST for large content fields
   - Consider compression for historical data
   - Archive old system logs regularly

7. **Backup Strategy**
   - Point-in-time recovery configuration
   - Regular full backups with incremental WAL
   - Cross-region backup replication

8. **Monitoring Setup**
   - PostgreSQL metrics (pg_stat_*)
   - Query performance monitoring
   - Resource usage alerts
   - Custom business metrics dashboard

9. **Scaling Considerations**
   - Read replicas for analytics workloads
   - Write scaling through application-level sharding
   - Separate OLTP and OLAP workloads

10. **Security Enhancements**
    - SSL/TLS encryption for all connections
    - Regular security updates
    - Audit logging for sensitive operations
    - Backup encryption
*/

-- ================================================================
-- SCHEMA VALIDATION & HEALTH CHECKS
-- ================================================================

-- Function to validate schema integrity
CREATE OR REPLACE FUNCTION validate_schema_integrity()
RETURNS TABLE (
    check_name TEXT,
    status TEXT,
    message TEXT
) AS $$
BEGIN
    -- Check for orphaned records
    RETURN QUERY
    SELECT 'Orphaned Content Chunks', 
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'FAIL' END,
           'Found ' || COUNT(*) || ' content chunks without valid concepts'
    FROM content_chunks cc
    LEFT JOIN curriculum_concepts co ON cc.concept_id = co.concept_id
    WHERE co.concept_id IS NULL;
    
    -- Check embedding consistency
    RETURN QUERY
    SELECT 'Missing Embeddings',
           CASE WHEN COUNT(*) = 0 THEN 'PASS' ELSE 'WARN' END,
           'Found ' || COUNT(*) || ' published content without embeddings'
    FROM content_chunks cc
    LEFT JOIN content_embeddings ce ON cc.chunk_id = ce.chunk_id
    WHERE cc.status = 'published' AND ce.embedding_id IS NULL;
    
    -- Check materialized view freshness
    RETURN QUERY
    SELECT 'Materialized Views Freshness',
           CASE WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(created_at)))/3600 < 24 
                THEN 'PASS' ELSE 'WARN' END,
           'Last refresh was ' || ROUND(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(created_at)))/3600, 1) || ' hours ago'
    FROM (
        SELECT CURRENT_TIMESTAMP as created_at WHERE false  -- Placeholder for actual MV stats
    ) t;
    
END;
$$ LANGUAGE plpgsql;

-- Final schema summary
DO $$
BEGIN
    RAISE NOTICE '=== SKILLMIND AI SCHEMA DEPLOYMENT COMPLETE ===';
    RAISE NOTICE 'Total Tables Created: 25+';
    RAISE NOTICE 'Total Fields: ~350+';
    RAISE NOTICE 'Indexes Created: 40+';
    RAISE NOTICE 'Materialized Views: 3';
    RAISE NOTICE 'Functions: 6';
    RAISE NOTICE 'Triggers: 4';
    RAISE NOTICE 'RLS Policies: 6';
    RAISE NOTICE '==============================================';
END $$;

-- Refresh materialized views for initial state
SELECT refresh_analytics_views();

COMMIT;