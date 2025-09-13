-- ================================================================
-- CAREER TRANSFORMATION SEEKER - POSTGRESQL SCHEMA
-- Production-Ready Career-Focused AI Avatar Education Platform
-- ================================================================

-- ================================================================
-- EXTENSIONS & PREREQUISITES
-- ================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "tablefunc"; -- For pivot operations

-- Set timezone for consistent timestamps
SET timezone = 'UTC';

-- ================================================================
-- ENHANCED ENUMS & TYPES FOR CAREER TRANSFORMATION
-- ================================================================

-- Content difficulty levels
CREATE TYPE difficulty_level AS ENUM (
    'beginner', 'intermediate', 'advanced', 'expert', 'industry_level'
);

-- Content status lifecycle
CREATE TYPE content_status AS ENUM (
    'draft', 'review', 'approved', 'published', 'archived', 'deprecated'
);

-- Career transformation specific content types
CREATE TYPE content_type AS ENUM (
    'concept_explanation', 'step_by_step_tutorial', 'code_example', 
    'practice_exercise', 'assessment_question', 'troubleshooting_guide',
    'case_study', 'industry_project', 'portfolio_template', 'interview_prep',
    'career_coaching', 'mentor_guide', 'industry_insight', 'reference',
    'certification_prep', 'job_search_tool'
);

-- Content formats
CREATE TYPE content_format AS ENUM (
    'markdown', 'html', 'json', 'code', 'video', 'audio', 'image', 
    'interactive', 'pdf', 'presentation', 'worksheet', 'template'
);

-- Cognitive levels (Bloom's Taxonomy + Career Application)
CREATE TYPE cognitive_level AS ENUM (
    'remember', 'understand', 'apply', 'analyze', 'evaluate', 'create', 'implement_professionally'
);

-- Learning styles
CREATE TYPE learning_style AS ENUM (
    'visual', 'auditory', 'kinesthetic', 'reading_writing', 'multimodal', 'collaborative', 'mentored'
);

-- User progress states with career focus
CREATE TYPE progress_status AS ENUM (
    'not_started', 'in_progress', 'completed', 'mastered', 'needs_review', 'industry_ready', 'certified'
);

-- Assessment types for career transformation
CREATE TYPE assessment_type AS ENUM (
    'multiple_choice', 'single_choice', 'true_false', 'short_answer', 
    'coding_challenge', 'project', 'peer_review', 'portfolio', 'case_study_analysis',
    'interview_simulation', 'presentation', 'industry_scenario', 'certification_exam'
);

-- Relationship types between content
CREATE TYPE relationship_type AS ENUM (
    'prerequisite', 'leads_to', 'related', 'depends_on', 'blocks', 'enhances',
    'industry_application', 'career_milestone', 'portfolio_component'
);

-- AI Avatar roles for career transformation
CREATE TYPE avatar_role AS ENUM (
    'teacher', 'tutor', 'mentor', 'career_coach', 'industry_expert', 'examiner', 'peer'
);

-- Career transition stages
CREATE TYPE career_stage AS ENUM (
    'assessment', 'foundation_building', 'skill_development', 'portfolio_creation',
    'interview_preparation', 'job_search', 'transition_complete', 'career_advancement'
);

-- Industry sectors
CREATE TYPE industry_sector AS ENUM (
    'technology', 'data_science', 'cybersecurity', 'cloud_computing', 'ai_ml',
    'web_development', 'mobile_development', 'devops', 'product_management',
    'digital_marketing', 'fintech', 'healthcare_tech', 'consulting', 'startup'
);

-- Employment status
CREATE TYPE employment_status AS ENUM (
    'employed', 'unemployed', 'self_employed', 'student', 'career_break', 'transitioning'
);

-- Mentorship relationship status
CREATE TYPE mentorship_status AS ENUM (
    'active', 'paused', 'completed', 'ended', 'seeking_mentor', 'available_mentor'
);

-- Project status for portfolio
CREATE TYPE project_status AS ENUM (
    'planning', 'in_development', 'completed', 'reviewed', 'showcase_ready', 'industry_validated'
);

-- ================================================================
-- 1. CAREER TRANSFORMATION PERSONA & USER MANAGEMENT
-- ================================================================

CREATE TABLE persona_profiles (
    persona_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    persona_name VARCHAR(100) NOT NULL UNIQUE,
    persona_code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    target_audience JSONB, -- Array of learner characteristics
    career_focus JSONB, -- Target industries and roles
    learning_objectives JSONB, -- Array of primary goals
    preferred_learning_styles learning_style[],
    difficulty_preference difficulty_level DEFAULT 'intermediate',
    pacing_preference VARCHAR(20) DEFAULT 'adaptive', -- 'fast', 'medium', 'slow', 'adaptive'
    engagement_preferences JSONB, -- Interaction styles, content types
    
    -- Career transformation specific
    typical_background JSONB, -- Previous career backgrounds
    target_industries industry_sector[],
    expected_transition_timeline_weeks INTEGER,
    mentorship_requirements JSONB,
    portfolio_requirements JSONB,
    certification_pathways JSONB,
    
    -- Time and commitment
    time_commitment_hours_week INTEGER,
    session_duration_minutes INTEGER DEFAULT 35,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    is_active BOOLEAN DEFAULT true
);

-- Career profiles for individual users
CREATE TABLE user_career_profiles (
    profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE, -- Links to external user system
    persona_id UUID REFERENCES persona_profiles(persona_id),
    
    -- Current career information
    current_job_title VARCHAR(200),
    current_industry industry_sector,
    current_company VARCHAR(200),
    years_of_experience INTEGER,
    employment_status employment_status DEFAULT 'employed',
    
    -- Target career information
    target_job_title VARCHAR(200),
    target_industry industry_sector NOT NULL,
    target_companies JSONB, -- Array of target companies
    target_salary_range JSONB, -- Min/max salary expectations
    geographic_preferences JSONB, -- Location preferences
    
    -- Transformation goals and timeline
    transformation_goals JSONB, -- Specific career objectives
    target_start_date DATE,
    expected_completion_date DATE,
    transition_urgency VARCHAR(20) DEFAULT 'moderate', -- 'low', 'moderate', 'high', 'urgent'
    
    -- Skills and background
    current_skills JSONB, -- Current skill inventory
    transferable_skills JSONB, -- Skills that transfer to new field
    skill_gaps JSONB, -- Skills that need development
    educational_background JSONB,
    certifications_current JSONB,
    certifications_target JSONB,
    
    -- Support and resources
    available_study_hours_week INTEGER,
    preferred_study_schedule JSONB,
    support_network JSONB, -- Family, colleague support levels
    budget_for_training DECIMAL(10,2),
    
    -- Progress tracking
    career_stage career_stage DEFAULT 'assessment',
    stage_progress_percentage DECIMAL(5,2) DEFAULT 0,
    milestone_achievements JSONB,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_experience_positive CHECK (years_of_experience >= 0),
    CONSTRAINT chk_study_hours_realistic CHECK (available_study_hours_week BETWEEN 1 AND 80),
    CONSTRAINT chk_stage_progress CHECK (stage_progress_percentage BETWEEN 0 AND 100)
);

-- Industry sector definitions and requirements
CREATE TABLE industry_sectors (
    sector_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sector_name industry_sector NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    
    -- Market information
    growth_outlook VARCHAR(20), -- 'declining', 'stable', 'growing', 'high_growth'
    average_salary_range JSONB,
    job_market_demand VARCHAR(20), -- 'low', 'moderate', 'high', 'very_high'
    remote_work_availability DECIMAL(3,1), -- Percentage of remote positions
    
    -- Skills and requirements
    required_skills JSONB, -- Core skills needed
    preferred_skills JSONB, -- Nice-to-have skills
    common_tools JSONB, -- Industry standard tools
    typical_certifications JSONB,
    
    -- Career progression
    entry_level_roles JSONB,
    mid_level_roles JSONB,
    senior_level_roles JSONB,
    typical_career_progression JSONB,
    
    -- Learning paths
    recommended_learning_sequence JSONB,
    average_transition_time_months INTEGER,
    success_factors JSONB,
    common_challenges JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 2. ENHANCED CURRICULUM HIERARCHY WITH CAREER FOCUS
-- ================================================================

-- Level 1: Modules (High-level organization) - Enhanced for career transformation
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
    
    -- Career transformation specific
    career_relevance JSONB, -- Which industries/roles this supports
    industry_applications JSONB, -- Real-world applications
    career_stage_alignment career_stage[], -- Which stages this supports
    portfolio_components JSONB, -- What portfolio pieces this enables
    certification_alignment JSONB, -- Which certifications this supports
    
    -- Professional development
    transferable_skills JSONB, -- Skills that transfer across industries
    industry_case_studies JSONB, -- Industry examples and case studies
    mentor_guidance_notes TEXT,
    
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

-- Level 2: Components (Major topic groupings) - Enhanced
CREATE TABLE curriculum_components (
    component_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL REFERENCES curriculum_modules(module_id) ON DELETE CASCADE,
    component_code VARCHAR(20) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    learning_objectives JSONB,
    estimated_duration_minutes INTEGER,
    order_index INTEGER NOT NULL,
    
    -- Career transformation enhancements
    industry_relevance JSONB, -- Industry-specific importance
    job_role_mapping JSONB, -- Which roles need these skills
    skill_level_requirements JSONB, -- Beginner/intermediate/advanced for different roles
    real_world_applications JSONB,
    
    -- Persona customization
    persona_emphasis JSONB, -- Different emphasis levels per persona
    mentorship_focus_areas JSONB,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(module_id, component_code),
    CONSTRAINT chk_component_duration_positive CHECK (estimated_duration_minutes > 0)
);

-- Level 3: Topics (Specific learning areas) - Enhanced
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
    industry_skills JSONB, -- Industry-specific skill mappings
    
    -- Career application
    workplace_scenarios JSONB, -- How this applies in work settings
    interview_relevance INTEGER DEFAULT 5, -- 1-10 scale for interview importance
    portfolio_integration JSONB,
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(component_id, topic_code)
);

-- Level 4: Concepts (Atomic learning units) - Enhanced
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
    
    -- Career application specific
    industry_context JSONB, -- How this applies in different industries
    professional_use_cases JSONB, -- Real professional scenarios
    career_impact_score INTEGER DEFAULT 5, -- 1-10 importance for career
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(topic_id, concept_code),
    CONSTRAINT chk_concept_complexity CHECK (complexity_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 3. ENHANCED CONTENT MANAGEMENT WITH CAREER FOCUS
-- ================================================================

-- Main content storage - Enhanced for career transformation
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
    
    -- Career transformation specific metadata
    industry_relevance JSONB, -- Which industries this applies to
    job_role_relevance JSONB, -- Which job roles need this
    career_stage_applicability career_stage[],
    interview_preparation_value INTEGER DEFAULT 0, -- 0-10 scale
    portfolio_integration_potential INTEGER DEFAULT 0, -- 0-10 scale
    certification_alignment JSONB, -- Which certifications this supports
    
    -- Real-world application
    workplace_scenarios JSONB, -- How this is used in actual work
    industry_case_studies JSONB, -- Real examples from industry
    professional_tools JSONB, -- Tools used with this knowledge
    
    -- Mentorship and coaching
    mentor_guidance_notes TEXT,
    coaching_conversation_starters JSONB,
    common_career_questions JSONB,
    
    -- Content quality metrics
    word_count INTEGER,
    token_count INTEGER,
    readability_score DECIMAL(3,1), -- Flesch-Kincaid grade level
    quality_score DECIMAL(3,1) DEFAULT 0, -- 0-10 calculated quality
    industry_validation_score DECIMAL(3,1) DEFAULT 0, -- Industry expert validation
    
    -- Search and discovery
    keywords TEXT[],
    industry_keywords TEXT[], -- Industry-specific terms
    search_weight INTEGER DEFAULT 5, -- 1-10 for search ranking
    
    -- Version control
    version VARCHAR(20) DEFAULT '1.0',
    parent_chunk_id UUID REFERENCES content_chunks(chunk_id),
    
    -- Lifecycle management
    status content_status DEFAULT 'draft',
    published_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    last_industry_review TIMESTAMPTZ, -- When industry expert last reviewed
    
    -- Audit fields
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    last_modified_by UUID,
    industry_reviewer_id UUID, -- Industry expert who validated content
    
    CONSTRAINT chk_content_duration_positive CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_content_complexity CHECK (complexity_score BETWEEN 1 AND 10),
    CONSTRAINT chk_content_quality CHECK (quality_score BETWEEN 0 AND 10),
    CONSTRAINT chk_interview_value CHECK (interview_preparation_value BETWEEN 0 AND 10),
    CONSTRAINT chk_portfolio_value CHECK (portfolio_integration_potential BETWEEN 0 AND 10)
);

-- Industry case studies (specialized content)
CREATE TABLE industry_case_studies (
    case_study_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    
    title VARCHAR(300) NOT NULL,
    industry industry_sector NOT NULL,
    company_name VARCHAR(200), -- Can be anonymized
    company_size VARCHAR(50), -- 'startup', 'small', 'medium', 'large', 'enterprise'
    
    -- Case study content
    background_context TEXT NOT NULL,
    challenge_description TEXT NOT NULL,
    solution_approach TEXT NOT NULL,
    implementation_details TEXT,
    outcomes_achieved TEXT NOT NULL,
    lessons_learned TEXT,
    
    -- Technical details
    technologies_used JSONB,
    skills_demonstrated JSONB,
    complexity_level difficulty_level NOT NULL,
    
    -- Career relevance
    job_roles_applicable JSONB,
    interview_scenarios JSONB,
    portfolio_application_ideas TEXT,
    
    -- Validation
    is_validated BOOLEAN DEFAULT false,
    validated_by UUID, -- Industry expert validator
    validated_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Professional project templates
CREATE TABLE professional_project_templates (
    template_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    
    project_name VARCHAR(300) NOT NULL,
    project_description TEXT NOT NULL,
    target_industries industry_sector[],
    target_roles JSONB,
    difficulty_level difficulty_level NOT NULL,
    estimated_completion_hours INTEGER,
    
    -- Project structure
    project_requirements TEXT NOT NULL,
    technical_specifications JSONB,
    deliverables JSONB,
    evaluation_criteria JSONB,
    
    -- Skills and learning
    skills_demonstrated JSONB,
    technologies_required JSONB,
    prerequisite_knowledge JSONB,
    
    -- Career impact
    portfolio_value INTEGER DEFAULT 5, -- 1-10 scale
    interview_story_potential INTEGER DEFAULT 5, -- 1-10 scale
    industry_relevance_score INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Resources
    starter_code_url TEXT,
    dataset_urls JSONB,
    documentation_templates JSONB,
    reference_implementations JSONB,
    
    -- Mentorship support
    mentor_checkpoints JSONB, -- When mentors should review progress
    common_challenges JSONB,
    success_indicators JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_completion_hours_positive CHECK (estimated_completion_hours > 0),
    CONSTRAINT chk_portfolio_value CHECK (portfolio_value BETWEEN 1 AND 10)
);

-- ================================================================
-- 4. CAREER-FOCUSED AI AVATAR SYSTEM
-- ================================================================

-- Enhanced AI Avatar roles for career transformation
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
    
    -- Career transformation specific
    career_coaching_capabilities JSONB,
    industry_expertise JSONB, -- Industries this avatar knows about
    mentorship_style VARCHAR(50),
    professional_experience_simulation JSONB,
    
    -- Behavioral parameters
    feedback_style VARCHAR(50), -- 'detailed', 'concise', 'encouraging'
    questioning_approach VARCHAR(50), -- 'socratic', 'direct', 'guided'
    error_handling_style VARCHAR(50), -- 'corrective', 'supportive', 'challenging'
    career_guidance_approach VARCHAR(50), -- 'directive', 'collaborative', 'exploratory'
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Role-specific content variations - Enhanced
CREATE TABLE content_role_variations (
    variation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES ai_avatar_roles(role_id) ON DELETE CASCADE,
    
    -- Role-specific delivery parameters
    instruction_type VARCHAR(50), -- 'direct', 'guided_discovery', 'socratic'
    teaching_strategy VARCHAR(50), -- 'lecture', 'demonstration', 'practice'
    interaction_style VARCHAR(50), -- 'formal', 'conversational', 'encouraging'
    
    -- Career-specific adaptations
    industry_context_adaptation JSONB,
    professional_scenario_integration TEXT,
    career_coaching_elements JSONB,
    mentorship_conversation_prompts JSONB,
    
    -- Customized content elements
    role_specific_intro TEXT,
    role_specific_summary TEXT,
    role_specific_exercises JSONB,
    career_application_examples TEXT,
    
    -- Assessment approach for this role
    help_type VARCHAR(50), -- 'hint', 'explanation', 'example'
    assessment_type VARCHAR(50),
    question_format VARCHAR(50),
    career_readiness_indicators JSONB,
    
    -- Collaboration settings
    collaboration_type VARCHAR(50), -- 'individual', 'group', 'peer_review'
    guidance_type VARCHAR(50), -- 'step_by_step', 'milestone', 'self_directed'
    professional_networking_elements JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(chunk_id, role_id)
);

-- Persona-specific content adaptations - Enhanced for career transformation
CREATE TABLE persona_content_adaptations (
    adaptation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    persona_id UUID NOT NULL REFERENCES persona_profiles(persona_id) ON DELETE CASCADE,
    
    -- Adaptation parameters
    difficulty_adjustment INTEGER DEFAULT 0, -- -2 to +2 relative to base
    pacing_multiplier DECIMAL(3,2) DEFAULT 1.0, -- Speed adjustment
    emphasis_level VARCHAR(20) DEFAULT 'standard', -- 'light', 'standard', 'heavy'
    
    -- Career-specific adaptations
    industry_focus_adjustment JSONB, -- Industry-specific emphasis
    career_stage_customization JSONB, -- Different for different stages
    background_consideration JSONB, -- Based on previous career
    
    -- Content modifications
    additional_examples JSONB,
    simplified_explanations TEXT,
    advanced_extensions TEXT,
    persona_specific_context TEXT,
    career_transition_context TEXT,
    
    -- Professional development elements
    networking_opportunities TEXT,
    industry_connection_suggestions JSONB,
    certification_pathway_integration TEXT,
    
    -- Delivery preferences
    preferred_formats content_format[],
    interaction_preferences JSONB,
    mentorship_integration_level VARCHAR(20), -- 'minimal', 'moderate', 'intensive'
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(chunk_id, persona_id)
);

-- ================================================================
-- 5. MENTORSHIP AND CAREER COACHING SYSTEM
-- ================================================================

-- Mentor profiles and qualifications
CREATE TABLE mentor_profiles (
    mentor_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID UNIQUE, -- If mentor is also a user in the system
    
    -- Personal information
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(254) UNIQUE,
    linkedin_profile VARCHAR(500),
    professional_photo_url TEXT,
    
    -- Professional background
    current_job_title VARCHAR(200),
    current_company VARCHAR(200),
    current_industry industry_sector,
    years_of_experience INTEGER,
    previous_roles JSONB,
    career_transition_experience JSONB, -- Their own transition story
    
    -- Mentorship capabilities
    expertise_areas JSONB, -- Technical and domain expertise
    industries_served industry_sector[],
    mentorship_specialties JSONB, -- e.g., 'interview_prep', 'portfolio_review'
    languages_spoken VARCHAR(200)[],
    
    -- Availability and preferences
    availability_schedule JSONB, -- When they're available
    max_mentees INTEGER DEFAULT 5,
    current_mentee_count INTEGER DEFAULT 0,
    preferred_session_duration INTEGER DEFAULT 60, -- Minutes
    session_rate DECIMAL(8,2), -- If paid mentorship
    
    -- Mentoring approach
    mentoring_style JSONB,
    communication_preferences JSONB,
    specialization_focus JSONB,
    
    -- Performance metrics
    total_mentees_helped INTEGER DEFAULT 0,
    average_rating DECIMAL(3,2),
    success_rate DECIMAL(5,2), -- Percentage of mentees who achieve goals
    
    -- Status and verification
    is_verified BOOLEAN DEFAULT false,
    verification_date TIMESTAMPTZ,
    status mentorship_status DEFAULT 'available_mentor',
    background_check_completed BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_experience_positive CHECK (years_of_experience >= 0),
    CONSTRAINT chk_max_mentees_reasonable CHECK (max_mentees BETWEEN 1 AND 50),
    CONSTRAINT chk_rating_valid CHECK (average_rating BETWEEN 0 AND 5)
);

-- Mentorship relationships
CREATE TABLE mentorship_relationships (
    relationship_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    mentor_id UUID NOT NULL REFERENCES mentor_profiles(mentor_id),
    mentee_user_id UUID NOT NULL, -- Links to external user system
    persona_id UUID REFERENCES persona_profiles(persona_id),
    
    -- Relationship details
    relationship_status mentorship_status DEFAULT 'active',
    start_date DATE NOT NULL,
    planned_end_date DATE,
    actual_end_date DATE,
    
    -- Goals and objectives
    mentorship_goals JSONB NOT NULL,
    success_criteria JSONB,
    focus_areas JSONB,
    meeting_frequency VARCHAR(20), -- 'weekly', 'biweekly', 'monthly'
    
    -- Progress tracking
    sessions_completed INTEGER DEFAULT 0,
    goals_achieved INTEGER DEFAULT 0,
    current_focus TEXT,
    progress_notes TEXT,
    
    -- Satisfaction and feedback
    mentee_satisfaction_rating DECIMAL(3,2),
    mentor_satisfaction_rating DECIMAL(3,2),
    relationship_notes TEXT,
    
    -- Administrative
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(mentor_id, mentee_user_id),
    CONSTRAINT chk_dates_logical CHECK (planned_end_date > start_date),
    CONSTRAINT chk_sessions_non_negative CHECK (sessions_completed >= 0)
);

-- Career coaching sessions
CREATE TABLE career_coaching_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    relationship_id UUID REFERENCES mentorship_relationships(relationship_id),
    user_id UUID NOT NULL, -- For users without formal mentor relationships
    
    -- Session details
    session_type VARCHAR(50) NOT NULL, -- 'mentorship', 'career_planning', 'interview_prep', 'portfolio_review'
    session_date TIMESTAMPTZ NOT NULL,
    duration_minutes INTEGER NOT NULL,
    session_mode VARCHAR(20) DEFAULT 'video_call', -- 'video_call', 'phone', 'in_person', 'chat'
    
    -- Session content
    session_objectives JSONB,
    topics_covered JSONB,
    key_insights JSONB,
    action_items JSONB,
    resources_shared JSONB,
    
    -- Outcomes and next steps
    session_outcomes TEXT,
    homework_assigned JSONB,
    next_session_planned TIMESTAMPTZ,
    follow_up_required BOOLEAN DEFAULT false,
    
    -- Feedback and ratings
    mentee_session_rating DECIMAL(3,2),
    mentor_session_rating DECIMAL(3,2),
    session_feedback TEXT,
    
    -- Progress tracking
    goals_progress_made JSONB,
    challenges_discussed JSONB,
    breakthroughs_achieved JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_duration_reasonable CHECK (duration_minutes BETWEEN 15 AND 180),
    CONSTRAINT chk_mentee_rating CHECK (mentee_session_rating BETWEEN 1 AND 5),
    CONSTRAINT chk_mentor_rating CHECK (mentor_session_rating BETWEEN 1 AND 5)
);

-- Career milestones and achievements
CREATE TABLE career_milestones (
    milestone_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    career_profile_id UUID REFERENCES user_career_profiles(profile_id),
    
    -- Milestone details
    milestone_name VARCHAR(200) NOT NULL,
    milestone_description TEXT,
    milestone_type VARCHAR(50) NOT NULL, -- 'skill_achievement', 'project_completion', 'certification', 'interview', 'job_offer'
    target_date DATE,
    achieved_date DATE,
    
    -- Progress and status
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    is_achieved BOOLEAN DEFAULT false,
    verification_method VARCHAR(100),
    evidence_urls JSONB, -- Links to portfolios, certificates, etc.
    
    -- Impact and significance
    career_impact_score INTEGER DEFAULT 5, -- 1-10 scale
    skill_development_areas JSONB,
    industry_recognition JSONB,
    
    -- Support and guidance
    mentor_involvement BOOLEAN DEFAULT false,
    coaching_sessions_related UUID[], -- Array of session IDs
    community_support_received JSONB,
    
    -- Reflection and learning
    lessons_learned TEXT,
    challenges_overcome JSONB,
    celebration_notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_progress_percentage CHECK (progress_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_impact_score CHECK (career_impact_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 6. PROFESSIONAL PORTFOLIO AND PROJECT MANAGEMENT
-- ================================================================

-- User portfolio projects
CREATE TABLE user_portfolio_projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    template_id UUID REFERENCES professional_project_templates(template_id),
    career_profile_id UUID REFERENCES user_career_profiles(profile_id),
    
    -- Project identification
    project_name VARCHAR(300) NOT NULL,
    project_description TEXT NOT NULL,
    project_status project_status DEFAULT 'planning',
    
    -- Timeline
    start_date DATE,
    target_completion_date DATE,
    actual_completion_date DATE,
    last_activity_date DATE,
    
    -- Project details
    technologies_used JSONB,
    skills_demonstrated JSONB,
    industry_application industry_sector,
    target_job_roles JSONB,
    
    -- Development tracking
    requirements_completed JSONB,
    milestones_achieved JSONB,
    current_challenges JSONB,
    next_steps JSONB,
    
    -- Quality and validation
    code_quality_score DECIMAL(3,1), -- 1-10 scale
    industry_feedback JSONB,
    peer_review_feedback JSONB,
    mentor_review_feedback JSONB,
    
    -- Showcase readiness
    is_showcase_ready BOOLEAN DEFAULT false,
    portfolio_presentation_url TEXT,
    demo_url TEXT,
    source_code_url TEXT,
    documentation_url TEXT,
    
    -- Career impact
    interview_stories JSONB, -- How to present this in interviews
    resume_bullet_points JSONB,
    linkedin_showcase_content TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_quality_score CHECK (code_quality_score BETWEEN 1 AND 10)
);

-- Project reviews and feedback
CREATE TABLE project_reviews (
    review_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES user_portfolio_projects(project_id),
    reviewer_user_id UUID, -- Could be mentor, peer, or industry expert
    reviewer_type VARCHAR(20) NOT NULL, -- 'mentor', 'peer', 'industry_expert', 'instructor'
    
    -- Review details
    review_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    overall_rating DECIMAL(3,2), -- 1-5 scale
    review_type VARCHAR(50), -- 'initial', 'progress', 'final', 'showcase_prep'
    
    -- Detailed feedback
    strengths_identified JSONB,
    areas_for_improvement JSONB,
    technical_feedback JSONB,
    presentation_feedback JSONB,
    industry_readiness_feedback JSONB,
    
    -- Recommendations
    next_steps_recommended JSONB,
    additional_resources JSONB,
    skill_development_suggestions JSONB,
    
    -- Specific scores
    technical_quality_score DECIMAL(3,2), -- 1-5
    presentation_quality_score DECIMAL(3,2), -- 1-5
    industry_relevance_score DECIMAL(3,2), -- 1-5
    interview_readiness_score DECIMAL(3,2), -- 1-5
    
    -- Follow-up
    follow_up_required BOOLEAN DEFAULT false,
    follow_up_date TIMESTAMPTZ,
    action_items JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_overall_rating CHECK (overall_rating BETWEEN 1 AND 5),
    CONSTRAINT chk_technical_score CHECK (technical_quality_score BETWEEN 1 AND 5)
);

-- ================================================================
-- 7. ENHANCED SKILLS TAXONOMY WITH INDUSTRY ALIGNMENT
-- ================================================================

-- Enhanced skills taxonomy with industry focus
CREATE TABLE skill_taxonomy (
    skill_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_skill_id UUID REFERENCES skill_taxonomy(skill_id),
    
    skill_name VARCHAR(200) NOT NULL,
    skill_code VARCHAR(50) NOT NULL UNIQUE,
    skill_description TEXT,
    skill_level INTEGER NOT NULL DEFAULT 1, -- Depth in hierarchy
    skill_category VARCHAR(100), -- 'technical', 'soft', 'domain', 'tool'
    
    -- Industry relevance - Enhanced
    industry_demand JSONB, -- Demand by industry with scores
    job_role_requirements JSONB, -- Which roles require this skill
    skill_market_value DECIMAL(10,2), -- Salary impact
    future_outlook VARCHAR(20), -- 'declining', 'stable', 'growing', 'emerging'
    
    -- Skill development
    typical_learning_duration_hours INTEGER,
    prerequisite_skills UUID[], -- Array of skill_ids
    complementary_skills UUID[], -- Skills often learned together
    certification_pathways JSONB,
    
    -- Assessment and validation
    assessment_methods JSONB, -- How this skill is typically evaluated
    industry_validation_criteria JSONB,
    benchmark_projects JSONB, -- Projects that demonstrate this skill
    
    -- Career progression
    entry_level_proficiency JSONB, -- What entry-level looks like
    mid_level_proficiency JSONB,
    senior_level_proficiency JSONB,
    expert_level_proficiency JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    
    CONSTRAINT chk_skill_level_positive CHECK (skill_level > 0)
);

-- User skill assessments and tracking
CREATE TABLE user_skill_assessments (
    assessment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    skill_id UUID NOT NULL REFERENCES skill_taxonomy(skill_id),
    career_profile_id UUID REFERENCES user_career_profiles(profile_id),
    
    -- Assessment details
    assessment_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    assessment_method VARCHAR(50), -- 'self_assessment', 'project_based', 'interview', 'test', 'mentor_evaluation'
    assessor_id UUID, -- Who conducted the assessment (mentor, peer, etc.)
    
    -- Skill level evaluation
    current_proficiency_level VARCHAR(20), -- 'novice', 'beginner', 'intermediate', 'advanced', 'expert'
    proficiency_score DECIMAL(4,2), -- 0-100 score
    confidence_level VARCHAR(20), -- 'low', 'moderate', 'high', 'very_high'
    
    -- Evidence and validation
    evidence_provided JSONB, -- Projects, certificates, work samples
    validation_status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'validated', 'disputed'
    validator_notes TEXT,
    
    -- Development planning
    target_proficiency_level VARCHAR(20),
    development_plan JSONB,
    estimated_improvement_timeline_weeks INTEGER,
    
    -- Progress tracking
    previous_assessment_id UUID REFERENCES user_skill_assessments(assessment_id),
    improvement_since_last DECIMAL(5,2), -- Percentage improvement
    skill_development_velocity DECIMAL(5,2), -- Skills gained per week
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, skill_id, assessment_date),
    CONSTRAINT chk_proficiency_score CHECK (proficiency_score BETWEEN 0 AND 100),
    CONSTRAINT chk_improvement_timeline CHECK (estimated_improvement_timeline_weeks > 0)
);

-- ================================================================
-- 8. INTERVIEW PREPARATION AND JOB SEARCH SUPPORT
-- ================================================================

-- Interview preparation tracking
CREATE TABLE interview_preparation (
    preparation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    career_profile_id UUID REFERENCES user_career_profiles(profile_id),
    
    -- Preparation focus
    target_company VARCHAR(200),
    target_role VARCHAR(200),
    interview_type VARCHAR(50), -- 'technical', 'behavioral', 'case_study', 'presentation'
    preparation_stage VARCHAR(50), -- 'research', 'practice', 'mock_interview', 'ready'
    
    -- Preparation content
    research_completed JSONB, -- Company research, role research
    questions_practiced JSONB, -- Interview questions practiced
    answers_prepared JSONB, -- STAR format answers
    technical_topics_studied JSONB,
    mock_interviews_completed INTEGER DEFAULT 0,
    
    -- Performance tracking
    confidence_level INTEGER DEFAULT 5, -- 1-10 scale
    readiness_score DECIMAL(3,1), -- 1-10 calculated readiness
    areas_for_improvement JSONB,
    strengths_to_highlight JSONB,
    
    -- Practice session results
    latest_mock_interview_score DECIMAL(3,2), -- 1-5 scale
    communication_score DECIMAL(3,2),
    technical_knowledge_score DECIMAL(3,2),
    problem_solving_score DECIMAL(3,2),
    cultural_fit_score DECIMAL(3,2),
    
    -- Coaching and support
    coach_assigned UUID REFERENCES mentor_profiles(mentor_id),
    coaching_sessions_completed INTEGER DEFAULT 0,
    peer_practice_partners JSONB,
    
    -- Scheduled interviews
    interview_scheduled_date TIMESTAMPTZ,
    interview_completed BOOLEAN DEFAULT false,
    interview_outcome VARCHAR(50), -- 'pending', 'passed', 'failed', 'offer_received'
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_confidence_level CHECK (confidence_level BETWEEN 1 AND 10),
    CONSTRAINT chk_readiness_score CHECK (readiness_score BETWEEN 1 AND 10),
    CONSTRAINT chk_mock_interviews CHECK (mock_interviews_completed >= 0)
);

-- Job application tracking
CREATE TABLE job_applications (
    application_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    career_profile_id UUID REFERENCES user_career_profiles(profile_id),
    
    -- Job details
    company_name VARCHAR(200) NOT NULL,
    job_title VARCHAR(200) NOT NULL,
    job_posting_url TEXT,
    salary_range JSONB,
    location VARCHAR(200),
    remote_option BOOLEAN DEFAULT false,
    
    -- Application tracking
    application_date DATE NOT NULL,
    application_status VARCHAR(50) DEFAULT 'applied', -- 'applied', 'screening', 'interview', 'offer', 'rejected', 'withdrawn'
    application_method VARCHAR(50), -- 'online', 'referral', 'recruiter', 'direct'
    
    -- Job matching
    skills_match_percentage DECIMAL(5,2),
    requirements_met JSONB, -- Which requirements are met
    requirements_gaps JSONB, -- Which requirements are missing
    culture_fit_assessment JSONB,
    
    -- Application materials
    resume_version VARCHAR(100),
    cover_letter_customization TEXT,
    portfolio_pieces_submitted JSONB,
    
    -- Interview process
    interview_stages JSONB, -- Details of interview process
    current_interview_stage VARCHAR(100),
    interview_feedback JSONB,
    
    -- Outcome and feedback
    final_outcome VARCHAR(50),
    outcome_date DATE,
    salary_offered DECIMAL(12,2),
    rejection_reason TEXT,
    feedback_received TEXT,
    
    -- Follow-up and networking
    follow_up_actions JSONB,
    connections_made JSONB,
    lessons_learned TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_skills_match CHECK (skills_match_percentage BETWEEN 0 AND 100)
);

-- ================================================================
-- 9. ENHANCED VECTOR EMBEDDINGS & SEMANTIC SEARCH
-- ================================================================

-- Enhanced embedding models registry for career-focused search
CREATE TABLE embedding_models (
    model_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(200) NOT NULL UNIQUE,
    model_version VARCHAR(50),
    provider VARCHAR(100), -- 'openai', 'huggingface', 'cohere', etc.
    embedding_dimensions INTEGER NOT NULL,
    context_window INTEGER,
    model_description TEXT,
    
    -- Career-specific optimization
    career_content_optimized BOOLEAN DEFAULT false,
    industry_terminology_trained BOOLEAN DEFAULT false,
    job_matching_capabilities BOOLEAN DEFAULT false,
    
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

-- Enhanced vector embeddings storage
CREATE TABLE content_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES embedding_models(model_id),
    
    -- Vector data
    embedding_vector vector NOT NULL, -- pgvector type
    embedding_metadata JSONB,
    
    -- Career-specific embeddings
    industry_context_vector vector, -- Industry-specific embedding
    job_role_relevance_vector vector, -- Job role relevance embedding
    career_stage_alignment_vector vector, -- Career stage alignment
    
    -- Generation metadata
    content_hash TEXT NOT NULL, -- Hash of content when embedded
    token_count INTEGER,
    generation_time_ms INTEGER,
    
    -- Career enhancement metadata
    industry_keywords_embedded JSONB,
    job_role_keywords_embedded JSONB,
    skill_keywords_embedded JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(chunk_id, model_id)
);

-- ================================================================
-- 10. ENHANCED ASSESSMENT SYSTEM WITH CAREER FOCUS
-- ================================================================

-- Enhanced assessments with career application
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
    
    -- Career application
    industry_context TEXT,
    real_world_scenario TEXT,
    job_role_relevance JSONB,
    interview_preparation_value INTEGER DEFAULT 0, -- 0-10 scale
    portfolio_integration_potential INTEGER DEFAULT 0, -- 0-10 scale
    
    -- Professional skills assessment
    technical_skills_assessed JSONB,
    soft_skills_assessed JSONB,
    problem_solving_approach_evaluated BOOLEAN DEFAULT false,
    communication_skills_evaluated BOOLEAN DEFAULT false,
    
    -- Scoring configuration
    points_possible INTEGER DEFAULT 100,
    passing_score INTEGER DEFAULT 70,
    industry_benchmark_score INTEGER, -- What professionals typically score
    time_limit_minutes INTEGER,
    attempts_allowed INTEGER DEFAULT 3,
    
    -- Question metadata
    cognitive_level cognitive_level NOT NULL,
    estimated_time_minutes INTEGER,
    auto_gradable BOOLEAN DEFAULT false,
    requires_human_review BOOLEAN DEFAULT false,
    
    -- Career coaching integration
    coaching_conversation_triggers JSONB,
    mentorship_discussion_points JSONB,
    skill_development_recommendations JSONB,
    
    -- Randomization
    randomize_options BOOLEAN DEFAULT false,
    option_pool_size INTEGER, -- For question banks
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID NOT NULL,
    
    CONSTRAINT chk_points_positive CHECK (points_possible > 0),
    CONSTRAINT chk_passing_reasonable CHECK (passing_score BETWEEN 0 AND points_possible),
    CONSTRAINT chk_interview_value CHECK (interview_preparation_value BETWEEN 0 AND 10),
    CONSTRAINT chk_portfolio_potential CHECK (portfolio_integration_potential BETWEEN 0 AND 10)
);

-- ================================================================
-- 11. ENHANCED USER PROGRESS & CAREER ANALYTICS
-- ================================================================

-- Enhanced user learning progress with career focus
CREATE TABLE user_progress (
    progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL, -- Links to external user system
    chunk_id UUID NOT NULL REFERENCES content_chunks(chunk_id) ON DELETE CASCADE,
    persona_id UUID REFERENCES persona_profiles(persona_id),
    role_id UUID REFERENCES ai_avatar_roles(role_id),
    career_profile_id UUID REFERENCES user_career_profiles(profile_id),
    
    -- Progress status
    status progress_status NOT NULL DEFAULT 'not_started',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    mastery_score DECIMAL(5,2), -- Final mastery level achieved
    
    -- Career readiness indicators
    industry_readiness_score DECIMAL(5,2), -- How ready for industry application
    interview_readiness_contribution DECIMAL(5,2), -- Contribution to interview prep
    portfolio_readiness_contribution DECIMAL(5,2), -- Contribution to portfolio
    
    -- Engagement metrics
    time_spent_minutes INTEGER DEFAULT 0,
    session_count INTEGER DEFAULT 0,
    interaction_count INTEGER DEFAULT 0,
    
    -- Learning analytics
    difficulty_experienced difficulty_level,
    help_requests_count INTEGER DEFAULT 0,
    error_count INTEGER DEFAULT 0,
    retry_count INTEGER DEFAULT 0,
    mentor_consultations INTEGER DEFAULT 0,
    
    -- Career application tracking
    real_world_application_attempts INTEGER DEFAULT 0,
    industry_context_understanding_score DECIMAL(5,2),
    professional_scenario_success_rate DECIMAL(5,2),
    
    -- Timestamps
    first_accessed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_accessed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,
    industry_ready_at TIMESTAMPTZ, -- When marked as industry ready
    
    -- Audit
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, chunk_id),
    CONSTRAINT chk_completion_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_mastery_score CHECK (mastery_score BETWEEN 0 AND 100),
    CONSTRAINT chk_industry_readiness CHECK (industry_readiness_score BETWEEN 0 AND 100)
);

-- Career transformation progress tracking
CREATE TABLE career_transformation_progress (
    transformation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE,
    career_profile_id UUID NOT NULL REFERENCES user_career_profiles(profile_id),
    
    -- Overall transformation status
    current_stage career_stage NOT NULL DEFAULT 'assessment',
    stage_start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    expected_completion_date DATE,
    overall_progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Stage-specific progress
    assessment_completion_percentage DECIMAL(5,2) DEFAULT 0,
    foundation_completion_percentage DECIMAL(5,2) DEFAULT 0,
    skill_development_percentage DECIMAL(5,2) DEFAULT 0,
    portfolio_completion_percentage DECIMAL(5,2) DEFAULT 0,
    interview_prep_percentage DECIMAL(5,2) DEFAULT 0,
    job_search_progress_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Skills and competencies
    skills_mastered JSONB,
    skills_in_progress JSONB,
    skills_planned JSONB,
    competency_gap_analysis JSONB,
    
    -- Portfolio and projects
    projects_completed INTEGER DEFAULT 0,
    projects_in_progress INTEGER DEFAULT 0,
    showcase_ready_projects INTEGER DEFAULT 0,
    industry_validated_projects INTEGER DEFAULT 0,
    
    -- Interview and job search readiness
    mock_interviews_completed INTEGER DEFAULT 0,
    interview_readiness_score DECIMAL(3,1) DEFAULT 0,
    job_applications_submitted INTEGER DEFAULT 0,
    interviews_scheduled INTEGER DEFAULT 0,
    offers_received INTEGER DEFAULT 0,
    
    -- Mentorship and support
    mentorship_relationship_active BOOLEAN DEFAULT false,
    coaching_sessions_completed INTEGER DEFAULT 0,
    peer_interactions_count INTEGER DEFAULT 0,
    community_engagement_level VARCHAR(20) DEFAULT 'low', -- 'low', 'moderate', 'high'
    
    -- Success metrics
    goal_achievement_rate DECIMAL(5,2) DEFAULT 0,
    milestone_completion_rate DECIMAL(5,2) DEFAULT 0,
    time_on_track BOOLEAN DEFAULT true,
    confidence_level INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Industry readiness
    industry_knowledge_score DECIMAL(3,1) DEFAULT 0,
    technical_competency_score DECIMAL(3,1) DEFAULT 0,
    professional_presentation_score DECIMAL(3,1) DEFAULT 0,
    networking_effectiveness_score DECIMAL(3,1) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_overall_progress CHECK (overall_progress_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_confidence_level CHECK (confidence_level BETWEEN 1 AND 10),
    CONSTRAINT chk_readiness_scores CHECK (
        industry_knowledge_score BETWEEN 0 AND 10 AND
        technical_competency_score BETWEEN 0 AND 10 AND
        professional_presentation_score BETWEEN 0 AND 10 AND
        networking_effectiveness_score BETWEEN 0 AND 10
    )
);

-- ================================================================
-- 12. EMPLOYER FEEDBACK & CAREER OUTCOME TRACKING
-- ================================================================

-- Employer feedback on graduates
CREATE TABLE employer_feedback (
    feedback_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL, -- Graduate user
    employer_company VARCHAR(200) NOT NULL,
    employer_contact_name VARCHAR(200),
    employer_title VARCHAR(200),
    feedback_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    -- Employment details
    hire_date DATE,
    job_title VARCHAR(200),
    starting_salary DECIMAL(12,2),
    employment_type VARCHAR(50), -- 'full_time', 'part_time', 'contract', 'internship'
    
    -- Performance evaluation
    overall_performance_rating DECIMAL(3,2), -- 1-5 scale
    technical_skills_rating DECIMAL(3,2), -- 1-5 scale
    problem_solving_rating DECIMAL(3,2), -- 1-5 scale
    communication_skills_rating DECIMAL(3,2), -- 1-5 scale
    teamwork_rating DECIMAL(3,2), -- 1-5 scale
    adaptability_rating DECIMAL(3,2), -- 1-5 scale
    
    -- Specific feedback
    strengths_identified JSONB,
    areas_for_improvement JSONB,
    training_program_effectiveness TEXT,
    preparation_quality_feedback TEXT,
    
    -- Hiring process feedback
    interview_performance_notes TEXT,
    portfolio_quality_feedback TEXT,
    technical_assessment_feedback TEXT,
    cultural_fit_assessment TEXT,
    
    -- Recommendations
    curriculum_improvement_suggestions JSONB,
    additional_skills_needed JSONB,
    industry_readiness_feedback TEXT,
    
    -- Follow-up and relationship
    willing_to_hire_more BOOLEAN,
    partnership_interest BOOLEAN DEFAULT false,
    mentorship_opportunities BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_performance_ratings CHECK (
        overall_performance_rating BETWEEN 1 AND 5 AND
        technical_skills_rating BETWEEN 1 AND 5 AND
        problem_solving_rating BETWEEN 1 AND 5 AND
        communication_skills_rating BETWEEN 1 AND 5 AND
        teamwork_rating BETWEEN 1 AND 5 AND
        adaptability_rating BETWEEN 1 AND 5
    )
);

-- Career outcome tracking
CREATE TABLE career_outcomes (
    outcome_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    career_profile_id UUID NOT NULL REFERENCES user_career_profiles(profile_id),
    
    -- Outcome details
    outcome_type VARCHAR(50) NOT NULL, -- 'job_placement', 'promotion', 'career_change', 'salary_increase', 'freelance_success'
    outcome_date DATE NOT NULL,
    verification_status VARCHAR(20) DEFAULT 'self_reported', -- 'self_reported', 'verified', 'employer_confirmed'
    
    -- Employment outcome details
    company_name VARCHAR(200),
    job_title VARCHAR(200),
    job_level VARCHAR(50), -- 'entry', 'junior', 'mid', 'senior', 'lead', 'management'
    industry_sector industry_sector,
    employment_type VARCHAR(50), -- 'full_time', 'part_time', 'contract', 'freelance'
    
    -- Compensation details
    starting_salary DECIMAL(12,2),
    salary_currency VARCHAR(3) DEFAULT 'USD',
    total_compensation DECIMAL(12,2), -- Including benefits, equity, etc.
    salary_increase_percentage DECIMAL(5,2), -- If promotion/raise
    
    -- Job search success metrics
    time_to_first_offer_days INTEGER,
    total_applications_submitted INTEGER,
    interviews_attended INTEGER,
    offers_received INTEGER,
    
    -- Skills and preparation impact
    skills_most_valuable JSONB, -- Skills that were most valuable in getting the job
    portfolio_projects_showcased JSONB,
    interview_preparation_effectiveness DECIMAL(3,2), -- 1-5 scale
    mentorship_impact_rating DECIMAL(3,2), -- 1-5 scale
    
    -- Geographic and work arrangement
    work_location VARCHAR(200),
    remote_work_percentage INTEGER, -- 0-100% remote
    relocation_required BOOLEAN DEFAULT false,
    
    -- Professional development
    career_growth_opportunities JSONB,
    continued_learning_requirements JSONB,
    mentorship_opportunities_available BOOLEAN DEFAULT false,
    
    -- Satisfaction and reflection
    job_satisfaction_rating DECIMAL(3,2), -- 1-5 scale
    career_transition_success_rating DECIMAL(3,2), -- 1-5 scale
    program_recommendation_likelihood DECIMAL(3,2), -- 1-5 scale
    success_story TEXT,
    
    -- Long-term tracking
    six_month_update JSONB,
    one_year_update JSONB,
    career_progression_notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_remote_percentage CHECK (remote_work_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_satisfaction_ratings CHECK (
        job_satisfaction_rating BETWEEN 1 AND 5 AND
        career_transition_success_rating BETWEEN 1 AND 5 AND
        program_recommendation_likelihood BETWEEN 1 AND 5
    )
);

-- ================================================================
-- 13. MATERIALIZED VIEWS FOR CAREER ANALYTICS
-- ================================================================

-- Career transformation success metrics
CREATE MATERIALIZED VIEW mv_career_transformation_metrics AS
SELECT 
    cp.target_industry,
    cp.persona_id,
    COUNT(DISTINCT ctp.user_id) as total_learners,
    COUNT(DISTINCT CASE WHEN ctp.current_stage = 'transition_complete' THEN ctp.user_id END) as successful_transitions,
    COUNT(DISTINCT CASE WHEN co.outcome_type = 'job_placement' THEN co.user_id END) as job_placements,
    
    -- Success rate calculations
    ROUND(
        COUNT(DISTINCT CASE WHEN ctp.current_stage = 'transition_complete' THEN ctp.user_id END)::DECIMAL / 
        NULLIF(COUNT(DISTINCT ctp.user_id), 0) * 100, 2
    ) as transition_success_rate,
    
    ROUND(
        COUNT(DISTINCT CASE WHEN co.outcome_type = 'job_placement' THEN co.user_id END)::DECIMAL / 
        NULLIF(COUNT(DISTINCT ctp.user_id), 0) * 100, 2
    ) as job_placement_rate,
    
    -- Timeline metrics
    AVG(EXTRACT(DAYS FROM (co.outcome_date - ctp.created_at::date))) as avg_time_to_placement_days,
    AVG(ctp.overall_progress_percentage) as avg_overall_progress,
    
    -- Compensation metrics
    AVG(co.starting_salary) as avg_starting_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY co.starting_salary) as median_starting_salary,
    
    -- Satisfaction metrics
    AVG(co.career_transition_success_rating) as avg_transition_satisfaction,
    AVG(co.program_recommendation_likelihood) as avg_program_recommendation,
    
    -- Activity metrics
    AVG(ctp.coaching_sessions_completed) as avg_coaching_sessions,
    AVG(ctp.projects_completed) as avg_projects_completed,
    AVG(ctp.mock_interviews_completed) as avg_mock_interviews,
    
    -- Last updated
    MAX(ctp.updated_at) as last_data_update
    
FROM career_transformation_progress ctp
JOIN user_career_profiles cp ON ctp.career_profile_id = cp.profile_id
LEFT JOIN career_outcomes co ON ctp.user_id = co.user_id
GROUP BY cp.target_industry, cp.persona_id;

-- Content effectiveness for career transformation
CREATE MATERIALIZED VIEW mv_career_content_effectiveness AS
SELECT 
    cc.chunk_id,
    cc.title,
    cc.content_type,
    cc.difficulty_level,
    
    -- Usage and engagement
    COUNT(DISTINCT up.user_id) as total_learners,
    COUNT(CASE WHEN up.status IN ('completed', 'mastered', 'industry_ready') THEN 1 END) as completions,
    COUNT(CASE WHEN up.status = 'industry_ready' THEN 1 END) as industry_ready_count,
    
    -- Effectiveness rates
    ROUND(
        COUNT(CASE WHEN up.status IN ('completed', 'mastered', 'industry_ready') THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(DISTINCT up.user_id), 0) * 100, 2
    ) as completion_rate,
    
    ROUND(
        COUNT(CASE WHEN up.status = 'industry_ready' THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(DISTINCT up.user_id), 0) * 100, 2
    ) as industry_readiness_rate,
    
    -- Career application metrics
    AVG(up.industry_readiness_score) as avg_industry_readiness_score,
    AVG(up.interview_readiness_contribution) as avg_interview_contribution,
    AVG(up.portfolio_readiness_contribution) as avg_portfolio_contribution,
    
    -- Learning efficiency
    AVG(up.time_spent_minutes) as avg_time_spent,
    AVG(up.session_count) as avg_sessions_needed,
    AVG(up.mastery_score) as avg_mastery_score,
    
    -- Support requirements
    AVG(up.help_requests_count) as avg_help_requests,
    AVG(up.mentor_consultations) as avg_mentor_consultations,
    AVG(up.retry_count) as avg_retry_count,
    
    -- Industry relevance
    cc.industry_relevance,
    cc.interview_preparation_value,
    cc.portfolio_integration_potential,
    
    -- Quality scores
    cc.quality_score,
    cc.industry_validation_score,
    
    -- Last activity
    MAX(up.updated_at) as last_activity
    
FROM content_chunks cc
LEFT JOIN user_progress up ON cc.chunk_id = up.chunk_id
GROUP BY cc.chunk_id, cc.title, cc.content_type, cc.difficulty_level, 
         cc.industry_relevance, cc.interview_preparation_value, 
         cc.portfolio_integration_potential, cc.quality_score, cc.industry_validation_score;

-- Mentorship effectiveness tracking
CREATE MATERIALIZED VIEW mv_mentorship_effectiveness AS
SELECT 
    mp.mentor_id,
    mp.full_name as mentor_name,
    mp.current_industry,
    mp.years_of_experience,
    
    -- Mentorship volume
    COUNT(DISTINCT mr.relationship_id) as total_mentees,
    COUNT(DISTINCT CASE WHEN mr.relationship_status = 'active' THEN mr.relationship_id END) as active_relationships,
    COUNT(DISTINCT CASE WHEN mr.relationship_status = 'completed' THEN mr.relationship_id END) as completed_relationships,
    
    -- Session metrics
    COUNT(ccs.session_id) as total_sessions_conducted,
    AVG(ccs.duration_minutes) as avg_session_duration,
    AVG(ccs.mentee_session_rating) as avg_mentee_rating,
    
    -- Mentee success outcomes
    COUNT(DISTINCT co.user_id) as mentees_with_career_outcomes,
    COUNT(DISTINCT CASE WHEN co.outcome_type = 'job_placement' THEN co.user_id END) as mentees_placed,
    
    -- Success rate calculations
    ROUND(
        COUNT(DISTINCT CASE WHEN co.outcome_type = 'job_placement' THEN co.user_id END)::DECIMAL / 
        NULLIF(COUNT(DISTINCT mr.mentee_user_id), 0) * 100, 2
    ) as mentee_placement_rate,
    
    -- Satisfaction and effectiveness
    mp.average_rating as mentor_overall_rating,
    mp.success_rate as reported_success_rate,
    
    -- Specializations and focus
    mp.expertise_areas,
    mp.mentorship_specialties,
    mp.industries_served,
    
    -- Availability and utilization
    mp.max_mentees,
    mp.current_mentee_count,
    ROUND(mp.current_mentee_count::DECIMAL / mp.max_mentees * 100, 2) as utilization_percentage,
    
    -- Performance indicators
    AVG(ctp.overall_progress_percentage) as avg_mentee_progress,
    AVG(ctp.confidence_level) as avg_mentee_confidence,
    
    -- Last activity
    MAX(ccs.session_date) as last_session_date
    
FROM mentor_profiles mp
LEFT JOIN mentorship_relationships mr ON mp.mentor_id = mr.mentor_id
LEFT JOIN career_coaching_sessions ccs ON mr.relationship_id = ccs.relationship_id
LEFT JOIN career_outcomes co ON mr.mentee_user_id = co.user_id
LEFT JOIN career_transformation_progress ctp ON mr.mentee_user_id = ctp.user_id
GROUP BY mp.mentor_id, mp.full_name, mp.current_industry, mp.years_of_experience,
         mp.average_rating, mp.success_rate, mp.expertise_areas, mp.mentorship_specialties,
         mp.industries_served, mp.max_mentees, mp.current_mentee_count;

-- ================================================================
-- COMPREHENSIVE INDEXING STRATEGY
-- ================================================================

-- Persona and career profile indexes
CREATE INDEX idx_persona_profiles_code ON persona_profiles(persona_code);
CREATE INDEX idx_persona_profiles_active ON persona_profiles(is_active) WHERE is_active = true;
CREATE INDEX idx_user_career_profiles_user ON user_career_profiles(user_id);
CREATE INDEX idx_user_career_profiles_target_industry ON user_career_profiles(target_industry);
CREATE INDEX idx_user_career_profiles_stage ON user_career_profiles(career_stage);

-- Curriculum hierarchy indexes
CREATE INDEX idx_curriculum_modules_code ON curriculum_modules(module_code);
CREATE INDEX idx_curriculum_modules_status ON curriculum_modules(status);
CREATE INDEX idx_curriculum_modules_difficulty ON curriculum_modules(difficulty_level);
CREATE INDEX idx_curriculum_components_module ON curriculum_components(module_id, order_index);
CREATE INDEX idx_curriculum_topics_component ON curriculum_topics(component_id, order_index);
CREATE INDEX idx_curriculum_concepts_topic ON curriculum_concepts(topic_id, order_index);

-- Content indexes with career focus
CREATE INDEX idx_content_chunks_concept ON content_chunks(concept_id);
CREATE INDEX idx_content_chunks_external_id ON content_chunks(external_id) WHERE external_id IS NOT NULL;
CREATE INDEX idx_content_chunks_type_status ON content_chunks(content_type, status);
CREATE INDEX idx_content_chunks_difficulty ON content_chunks(difficulty_level);
CREATE INDEX idx_content_chunks_career_stage ON content_chunks USING GIN(career_stage_applicability);
CREATE INDEX idx_content_chunks_industry_relevance ON content_chunks USING GIN(industry_relevance);
CREATE INDEX idx_content_chunks_interview_value ON content_chunks(interview_preparation_value DESC);
CREATE INDEX idx_content_chunks_portfolio_value ON content_chunks(portfolio_integration_potential DESC);

-- Industry and case study indexes
CREATE INDEX idx_industry_case_studies_industry ON industry_case_studies(industry);
CREATE INDEX idx_industry_case_studies_difficulty ON industry_case_studies(difficulty_level);
CREATE INDEX idx_industry_case_studies_validated ON industry_case_studies(is_validated) WHERE is_validated = true;

-- Mentorship system indexes
CREATE INDEX idx_mentor_profiles_industry ON mentor_profiles(current_industry);
CREATE INDEX idx_mentor_profiles_available ON mentor_profiles(status) WHERE status = 'available_mentor';
CREATE INDEX idx_mentor_profiles_verified ON mentor_profiles(is_verified) WHERE is_verified = true;
CREATE INDEX idx_mentorship_relationships_mentor ON mentorship_relationships(mentor_id);
CREATE INDEX idx_mentorship_relationships_mentee ON mentorship_relationships(mentee_user_id);
CREATE INDEX idx_mentorship_relationships_status ON mentorship_relationships(relationship_status);
CREATE INDEX idx_career_coaching_sessions_user ON career_coaching_sessions(user_id);
CREATE INDEX idx_career_coaching_sessions_date ON career_coaching_sessions(session_date DESC);

-- Portfolio and project indexes
CREATE INDEX idx_user_portfolio_projects_user ON user_portfolio_projects(user_id);
CREATE INDEX idx_user_portfolio_projects_status ON user_portfolio_projects(project_status);
CREATE INDEX idx_user_portfolio_projects_industry ON user_portfolio_projects(industry_application);
CREATE INDEX idx_user_portfolio_projects_showcase ON user_portfolio_projects(is_showcase_ready) WHERE is_showcase_ready = true;
CREATE INDEX idx_project_reviews_project ON project_reviews(project_id);
CREATE INDEX idx_project_reviews_reviewer ON project_reviews(reviewer_user_id);

-- Skills and assessment indexes
CREATE INDEX idx_skill_taxonomy_parent ON skill_taxonomy(parent_skill_id);
CREATE INDEX idx_skill_taxonomy_category ON skill_taxonomy(skill_category);
CREATE INDEX idx_skill_taxonomy_active ON skill_taxonomy(is_active) WHERE is_active = true;
CREATE INDEX idx_user_skill_assessments_user ON user_skill_assessments(user_id);
CREATE INDEX idx_user_skill_assessments_skill ON user_skill_assessments(skill_id);
CREATE INDEX idx_user_skill_assessments_date ON user_skill_assessments(assessment_date DESC);

-- Interview and job search indexes
CREATE INDEX idx_interview_preparation_user ON interview_preparation(user_id);
CREATE INDEX idx_interview_preparation_stage ON interview_preparation(preparation_stage);
CREATE INDEX idx_interview_preparation_scheduled ON interview_preparation(interview_scheduled_date) WHERE interview_scheduled_date IS NOT NULL;
CREATE INDEX idx_job_applications_user ON job_applications(user_id);
CREATE INDEX idx_job_applications_status ON job_applications(application_status);
CREATE INDEX idx_job_applications_company ON job_applications(company_name);

-- Career progress and outcome indexes
CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_chunk ON user_progress(chunk_id);
CREATE INDEX idx_user_progress_status ON user_progress(status);
CREATE INDEX idx_user_progress_career_profile ON user_progress(career_profile_id);
CREATE INDEX idx_career_transformation_progress_user ON career_transformation_progress(user_id);
CREATE INDEX idx_career_transformation_progress_stage ON career_transformation_progress(current_stage);
CREATE INDEX idx_career_outcomes_user ON career_outcomes(user_id);
CREATE INDEX idx_career_outcomes_type ON career_outcomes(outcome_type);
CREATE INDEX idx_career_outcomes_date ON career_outcomes(outcome_date DESC);
CREATE INDEX idx_employer_feedback_user ON employer_feedback(user_id);
CREATE INDEX idx_employer_feedback_company ON employer_feedback(employer_company);

-- Vector search indexes (Enhanced with career context)
CREATE INDEX idx_content_embeddings_vector ON content_embeddings 
    USING hnsw (embedding_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX idx_content_embeddings_industry_vector ON content_embeddings 
    USING hnsw (industry_context_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE industry_context_vector IS NOT NULL;
CREATE INDEX idx_content_embeddings_job_role_vector ON content_embeddings 
    USING hnsw (job_role_relevance_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE job_role_relevance_vector IS NOT NULL;

-- Full text search indexes
CREATE INDEX idx_content_chunks_search_text ON content_chunks 
    USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || COALESCE(content_plain_text, '')));
CREATE INDEX idx_content_chunks_keywords ON content_chunks USING GIN(keywords);
CREATE INDEX idx_content_chunks_industry_keywords ON content_chunks USING GIN(industry_keywords);

-- ================================================================
-- ROW LEVEL SECURITY (RLS) - ENHANCED FOR CAREER PLATFORM
-- ================================================================

-- Enable RLS on user-specific tables
ALTER TABLE user_career_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_portfolio_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_skill_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE career_transformation_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE career_coaching_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interview_preparation ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE career_outcomes ENABLE ROW LEVEL SECURITY;
ALTER TABLE career_milestones ENABLE ROW LEVEL SECURITY;

-- User data isolation policies
CREATE POLICY user_career_profile_isolation ON user_career_profiles
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY user_progress_isolation ON user_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY user_portfolio_isolation ON user_portfolio_projects
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY user_skill_assessment_isolation ON user_skill_assessments
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY user_transformation_progress_isolation ON career_transformation_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Mentorship access policies
CREATE POLICY mentorship_participant_access ON career_coaching_sessions
    FOR ALL TO application_users
    USING (
        user_id = current_setting('app.current_user_id', true)::uuid OR
        relationship_id IN (
            SELECT relationship_id FROM mentorship_relationships 
            WHERE mentor_id IN (
                SELECT mentor_id FROM mentor_profiles 
                WHERE user_id = current_setting('app.current_user_id', true)::uuid
            )
        )
    );

-- Admin and mentor bypass policies
CREATE POLICY admin_full_access ON user_career_profiles
    FOR ALL TO admin_users, mentor_users
    USING (true);

CREATE POLICY admin_progress_access ON user_progress
    FOR ALL TO admin_users
    USING (true);

-- Mentor access to their mentees
CREATE POLICY mentor_mentee_access ON user_career_profiles
    FOR SELECT TO mentor_users
    USING (
        user_id IN (
            SELECT mentee_user_id FROM mentorship_relationships mr
            JOIN mentor_profiles mp ON mr.mentor_id = mp.mentor_id
            WHERE mp.user_id = current_setting('app.current_user_id', true)::uuid
            AND mr.relationship_status = 'active'
        )
    );

-- ================================================================
-- UTILITY FUNCTIONS FOR CAREER TRANSFORMATION
-- ================================================================

-- Function to calculate career readiness score
CREATE OR REPLACE FUNCTION calculate_career_readiness_score(
    p_user_id UUID
) RETURNS JSONB AS $$
DECLARE
    readiness_scores JSONB;
    technical_score DECIMAL;
    portfolio_score DECIMAL;
    interview_score DECIMAL;
    professional_score DECIMAL;
    overall_score DECIMAL;
BEGIN
    -- Calculate technical competency score
    SELECT AVG(usa.proficiency_score)
    INTO technical_score
    FROM user_skill_assessments usa
    JOIN skill_taxonomy st ON usa.skill_id = st.skill_id
    WHERE usa.user_id = p_user_id 
    AND st.skill_category IN ('technical', 'tool')
    AND usa.assessment_date > CURRENT_DATE - INTERVAL '6 months';
    
    -- Calculate portfolio readiness score
    SELECT 
        CASE 
            WHEN COUNT(*) = 0 THEN 0
            WHEN COUNT(CASE WHEN project_status = 'showcase_ready' THEN 1 END) >= 3 THEN 100
            WHEN COUNT(CASE WHEN project_status = 'showcase_ready' THEN 1 END) >= 2 THEN 80
            WHEN COUNT(CASE WHEN project_status = 'showcase_ready' THEN 1 END) >= 1 THEN 60
            ELSE COUNT(*) * 20
        END
    INTO portfolio_score
    FROM user_portfolio_projects
    WHERE user_id = p_user_id;
    
    -- Calculate interview readiness score
    SELECT COALESCE(AVG(readiness_score * 10), 0)
    INTO interview_score
    FROM interview_preparation
    WHERE user_id = p_user_id
    AND created_at > CURRENT_DATE - INTERVAL '3 months';
    
    -- Calculate professional development score
    SELECT 
        CASE 
            WHEN AVG(coaching_sessions_completed) >= 10 THEN 100
            WHEN AVG(coaching_sessions_completed) >= 5 THEN 80
            WHEN AVG(coaching_sessions_completed) >= 2 THEN 60
            ELSE AVG(coaching_sessions_completed) * 20
        END
    INTO professional_score
    FROM career_transformation_progress
    WHERE user_id = p_user_id;
    
    -- Calculate weighted overall score
    overall_score := (
        (COALESCE(technical_score, 0) * 0.3) + 
        (COALESCE(portfolio_score, 0) * 0.25) + 
        (COALESCE(interview_score, 0) * 0.25) + 
        (COALESCE(professional_score, 0) * 0.2)
    );
    
    readiness_scores := jsonb_build_object(
        'technical_readiness', ROUND(COALESCE(technical_score, 0), 1),
        'portfolio_readiness', ROUND(COALESCE(portfolio_score, 0), 1),
        'interview_readiness', ROUND(COALESCE(interview_score, 0), 1),
        'professional_readiness', ROUND(COALESCE(professional_score, 0), 1),
        'overall_readiness', ROUND(overall_score, 1),
        'calculated_at', CURRENT_TIMESTAMP
    );
    
    RETURN readiness_scores;
END;
$$ LANGUAGE plpgsql;

-- Function to recommend career content based on user profile and progress
CREATE OR REPLACE FUNCTION get_career_content_recommendations(
    p_user_id UUID,
    p_target_industry industry_sector DEFAULT NULL,
    p_career_stage career_stage DEFAULT NULL,
    p_limit INTEGER DEFAULT 10
) RETURNS TABLE (
    chunk_id UUID,
    title VARCHAR,
    content_type content_type,
    difficulty_level difficulty_level,
    industry_relevance_score DECIMAL,
    interview_value INTEGER,
    portfolio_value INTEGER,
    recommendation_score DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    WITH user_profile AS (
        SELECT 
            COALESCE(p_target_industry, ucp.target_industry) as target_industry,
            COALESCE(p_career_stage, ucp.career_stage) as career_stage,
            ucp.current_skills,
            ucp.skill_gaps
        FROM user_career_profiles ucp
        WHERE ucp.user_id = p_user_id
    ),
    user_completed_content AS (
        SELECT up.chunk_id, up.mastery_score
        FROM user_progress up
        WHERE up.user_id = p_user_id 
        AND up.status IN ('completed', 'mastered', 'industry_ready')
    ),
    candidate_content AS (
        SELECT 
            cc.chunk_id,
            cc.title,
            cc.content_type,
            cc.difficulty_level,
            cc.interview_preparation_value,
            cc.portfolio_integration_potential,
            
            -- Industry relevance scoring
            CASE 
                WHEN cc.industry_relevance ? up.target_industry::text THEN 10.0
                WHEN cc.industry_relevance ? 'general' THEN 7.0
                ELSE 5.0
            END as industry_match_score,
            
            -- Career stage alignment
            CASE 
                WHEN up.career_stage = ANY(cc.career_stage_applicability) THEN 10.0
                ELSE 5.0
            END as stage_match_score,
            
            -- Skill gap alignment
            CASE 
                WHEN cc.learning_objectives ?| (
                    SELECT array_agg(skill) FROM jsonb_array_elements_text(up.skill_gaps) as skill
                ) THEN 10.0
                ELSE 5.0
            END as skill_gap_score,
            
            -- Quality indicators
            cc.quality_score,
            cc.industry_validation_score,
            cc.search_weight
            
        FROM content_chunks cc
        CROSS JOIN user_profile up
        LEFT JOIN user_completed_content ucc ON cc.chunk_id = ucc.chunk_id
        
        WHERE cc.status = 'published'
        AND ucc.chunk_id IS NULL  -- Not already completed
    )
    SELECT 
        cc.chunk_id,
        cc.title,
        cc.content_type,
        cc.difficulty_level,
        cc.industry_match_score as industry_relevance_score,
        cc.interview_preparation_value,
        cc.portfolio_integration_potential,
        ROUND(
            (cc.industry_match_score * 0.3 + 
             cc.stage_match_score * 0.25 + 
             cc.skill_gap_score * 0.25 + 
             (cc.quality_score + cc.industry_validation_score) / 2.0 * 0.2), 2
        ) as recommendation_score
    FROM candidate_content cc
    ORDER BY recommendation_score DESC, cc.interview_preparation_value DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to match users with mentors
CREATE OR REPLACE FUNCTION find_mentor_matches(
    p_user_id UUID,
    p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
    mentor_id UUID,
    mentor_name VARCHAR,
    industry_match_score INTEGER,
    expertise_match_score INTEGER,
    availability_score INTEGER,
    overall_match_score DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    WITH user_profile AS (
        SELECT 
            ucp.target_industry,
            ucp.skill_gaps,
            ucp.available_study_hours_week,
            ucp.transformation_goals
        FROM user_career_profiles ucp
        WHERE ucp.user_id = p_user_id
    )
    SELECT 
        mp.mentor_id,
        mp.full_name,
        
        -- Industry match scoring
        CASE 
            WHEN mp.current_industry = up.target_industry THEN 10
            WHEN up.target_industry = ANY(mp.industries_served) THEN 8
            ELSE 3
        END as industry_match_score,
        
        -- Expertise match scoring
        CASE 
            WHEN mp.expertise_areas ?| (
                SELECT array_agg(skill) FROM jsonb_array_elements_text(up.skill_gaps) as skill
            ) THEN 10
            ELSE 5
        END as expertise_match_score,
        
        -- Availability scoring
        CASE 
            WHEN mp.current_mentee_count < mp.max_mentees THEN 10
            WHEN mp.current_mentee_count = mp.max_mentees THEN 3
            ELSE 0
        END as availability_score,
        
        -- Overall match calculation
        ROUND(
            ((CASE 
                WHEN mp.current_industry = up.target_industry THEN 10
                WHEN up.target_industry = ANY(mp.industries_served) THEN 8
                ELSE 3
            END) * 0.4 + 
            (CASE 
                WHEN mp.expertise_areas ?| (
                    SELECT array_agg(skill) FROM jsonb_array_elements_text(up.skill_gaps) as skill
                ) THEN 10
                ELSE 5
            END) * 0.35 + 
            (CASE 
                WHEN mp.current_mentee_count < mp.max_mentees THEN 10
                WHEN mp.current_mentee_count = mp.max_mentees THEN 3
                ELSE 0
            END) * 0.15 +
            mp.average_rating * 2 * 0.1), 2
        ) as overall_match_score
        
    FROM mentor_profiles mp
    CROSS JOIN user_profile up
    WHERE mp.status = 'available_mentor'
    AND mp.is_verified = true
    AND mp.current_mentee_count < mp.max_mentees
    ORDER BY overall_match_score DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to update career transformation progress
CREATE OR REPLACE FUNCTION update_career_transformation_progress(
    p_user_id UUID
) RETURNS VOID AS $$
DECLARE
    progress_record career_transformation_progress%ROWTYPE;
    skills_completed INTEGER;
    total_skills INTEGER;
    projects_showcase_ready INTEGER;
    mock_interviews INTEGER;
    readiness_scores JSONB;
BEGIN
    -- Get or create progress record
    SELECT * INTO progress_record
    FROM career_transformation_progress
    WHERE user_id = p_user_id;
    
    -- Calculate skills progress
    SELECT 
        COUNT(CASE WHEN usa.proficiency_score >= 70 THEN 1 END),
        COUNT(*)
    INTO skills_completed, total_skills
    FROM user_skill_assessments usa
    WHERE usa.user_id = p_user_id
    AND usa.assessment_date = (
        SELECT MAX(assessment_date) 
        FROM user_skill_assessments usa2 
        WHERE usa2.user_id = usa.user_id AND usa2.skill_id = usa.skill_id
    );
    
    -- Calculate portfolio progress
    SELECT COUNT(*)
    INTO projects_showcase_ready
    FROM user_portfolio_projects
    WHERE user_id = p_user_id AND is_showcase_ready = true;
    
    -- Calculate interview preparation
    SELECT COALESCE(MAX(mock_interviews_completed), 0)
    INTO mock_interviews
    FROM interview_preparation
    WHERE user_id = p_user_id;
    
    -- Get career readiness scores
    readiness_scores := calculate_career_readiness_score(p_user_id);
    
    -- Update progress record
    UPDATE career_transformation_progress
    SET 
        skill_development_percentage = CASE 
            WHEN total_skills > 0 THEN (skills_completed::DECIMAL / total_skills * 100)
            ELSE 0 
        END,
        portfolio_completion_percentage = CASE 
            WHEN projects_showcase_ready >= 3 THEN 100
            ELSE projects_showcase_ready * 33.33
        END,
        interview_prep_percentage = CASE 
            WHEN mock_interviews >= 5 THEN 100
            ELSE mock_interviews * 20
        END,
        projects_completed = (
            SELECT COUNT(*) FROM user_portfolio_projects 
            WHERE user_id = p_user_id AND project_status = 'completed'
        ),
        showcase_ready_projects = projects_showcase_ready,
        mock_interviews_completed = mock_interviews,
        technical_competency_score = (readiness_scores->>'technical_readiness')::DECIMAL,
        professional_presentation_score = (readiness_scores->>'portfolio_readiness')::DECIMAL,
        updated_at = CURRENT_TIMESTAMP
    WHERE user_id = p_user_id;
    
    -- If no record exists, create one
    IF NOT FOUND THEN
        INSERT INTO career_transformation_progress (user_id, career_profile_id)
        SELECT p_user_id, profile_id
        FROM user_career_profiles
        WHERE user_id = p_user_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to refresh all materialized views
CREATE OR REPLACE FUNCTION refresh_career_analytics_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_career_transformation_metrics;
    REFRESH MATERIALIZED VIEW mv_career_content_effectiveness;
    REFRESH MATERIALIZED VIEW mv_mentorship_effectiveness;
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

CREATE TRIGGER tr_user_career_profiles_updated_at
    BEFORE UPDATE ON user_career_profiles
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

CREATE TRIGGER tr_career_transformation_progress_updated_at
    BEFORE UPDATE ON career_transformation_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Trigger to update career transformation progress when user progress changes
CREATE OR REPLACE FUNCTION trigger_update_career_progress()
RETURNS TRIGGER AS $$
BEGIN
    -- Update career transformation progress when user completes content
    IF NEW.status != OLD.status AND NEW.status IN ('completed', 'mastered', 'industry_ready') THEN
        PERFORM update_career_transformation_progress(NEW.user_id);
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_user_progress_career_update
    AFTER UPDATE ON user_progress
    FOR EACH ROW EXECUTE FUNCTION trigger_update_career_progress();

-- ================================================================
-- INITIAL SETUP DATA FOR CAREER TRANSFORMATION
-- ================================================================

-- Create default embedding model (career-optimized)
INSERT INTO embedding_models (
    model_name, model_version, provider, embedding_dimensions,
    context_window, model_description, career_content_optimized,
    industry_terminology_trained, job_matching_capabilities,
    is_active, is_default
) VALUES (
    'career-optimized-embeddings-v2', 'v2.1', 'custom', 384,
    512, 'Career transformation optimized sentence transformer with industry terminology',
    true, true, true, true, true
);

-- Create enhanced AI avatar roles for career transformation
INSERT INTO ai_avatar_roles (
    role_name, display_name, role_description, interaction_style, 
    assessment_types, content_focus, target_audience, 
    career_coaching_capabilities, industry_expertise, mentorship_style,
    feedback_style, questioning_approach, error_handling_style, career_guidance_approach
) VALUES
('teacher', 'AI Instructor', 'Comprehensive technical instruction with industry context', 
 '{"approach": "structured", "tone": "authoritative", "style": "comprehensive", "industry_context": "high"}'::jsonb,
 '["knowledge_check", "comprehensive_exam", "project_evaluation", "industry_scenario"]'::jsonb,
 '["concept_explanation", "tutorial", "reference", "case_study"]'::jsonb,
 '["visual_learners", "structured_learners", "comprehensive_learners"]'::jsonb,
 '["technical_instruction", "industry_context", "skill_mapping"]'::jsonb,
 '["technology", "data_science", "web_development", "cybersecurity"]'::jsonb,
 'instructional', 'detailed', 'direct', 'corrective', 'directive'),

('mentor', 'AI Career Mentor', 'Experienced industry professional providing career guidance', 
 '{"approach": "advisory", "tone": "experienced", "style": "strategic", "career_focused": "very_high"}'::jsonb,
 '["career_assessment", "portfolio_review", "interview_preparation", "goal_setting"]'::jsonb,
 '["case_study", "industry_project", "career_coaching", "professional_development"]'::jsonb,
 '["career_switchers", "professionals", "goal_oriented_learners"]'::jsonb,
 '["career_planning", "industry_navigation", "professional_development", "networking"]'::jsonb,
 '["all_industries"]'::jsonb,
 'advisory', 'strategic', 'socratic', 'challenging', 'collaborative'),

('career_coach', 'AI Career Coach', 'Specialized career transformation coaching and support', 
 '{"approach": "coaching", "tone": "supportive", "style": "empowering", "transformation_focused": "very_high"}'::jsonb,
 '["career_readiness", "skills_assessment", "goal_tracking", "confidence_building"]'::jsonb,
 '["career_coaching", "interview_prep", "professional_development", "mentorship"]'::jsonb,
 '["career_changers", "skill_builders", "confidence_seekers"]'::jsonb,
 '["transformation_planning", "confidence_building", "skill_development", "job_preparation"]'::jsonb,
 '["career_transition", "professional_development"]'::jsonb,
 'empowering', 'encouraging', 'guided', 'supportive', 'exploratory'),

('industry_expert', 'AI Industry Expert', 'Domain expert providing industry-specific insights and validation', 
 '{"approach": "expert", "tone": "professional", "style": "authoritative", "industry_depth": "very_high"}'::jsonb,
 '["industry_validation", "professional_scenarios", "market_trends", "skill_relevance"]'::jsonb,
 '["industry_insight", "case_study", "professional_scenarios", "market_analysis"]'::jsonb,
 '["industry_professionals", "career_switchers", "skill_validators"]'::jsonb,
 '["industry_trends", "market_analysis", "professional_standards", "skill_validation"]'::jsonb,
 '["technology", "data_science", "cybersecurity", "cloud_computing", "ai_ml"]'::jsonb,
 'authoritative', 'detailed', 'direct', 'corrective', 'directive'),

('tutor', 'AI Learning Tutor', 'Interactive learning support with career application context', 
 '{"approach": "adaptive", "tone": "supportive", "style": "interactive", "career_context": "moderate"}'::jsonb,
 '["practice_exercise", "skill_building", "progress_tracking", "adaptive_learning"]'::jsonb,
 '["step_by_step_tutorial", "practice_exercise", "troubleshooting_guide", "skill_building"]'::jsonb,
 '["struggling_learners", "interactive_learners", "adaptive_learners"]'::jsonb,
 '["personalized_learning", "skill_building", "progress_tracking"]'::jsonb,
 '["general_education", "skill_development"]'::jsonb,
 'supportive', 'encouraging', 'guided', 'supportive', 'collaborative'),

('examiner', 'AI Skills Assessor', 'Comprehensive assessment and evaluation specialist', 
 '{"approach": "evaluative", "tone": "objective", "style": "precise", "career_validation": "high"}'::jsonb,
 '["formal_assessment", "skills_validation", "certification_prep", "industry_readiness"]'::jsonb,
 '["assessment_question", "coding_challenge", "project", "industry_scenario"]'::jsonb,
 '["certification_seekers", "skill_validators", "career_ready_learners"]'::jsonb,
 '["skills_assessment", "industry_validation", "certification_preparation"]'::jsonb,
 '["technical_assessment", "professional_evaluation"]'::jsonb,
 'objective', 'objective', 'direct', 'corrective', 'directive'),

('peer', 'AI Study Partner', 'Collaborative learning facilitator and community connector', 
 '{"approach": "collaborative", "tone": "casual", "style": "friendly", "community_focused": "high"}'::jsonb,
 '["peer_review", "group_discussion", "collaborative_project", "study_group"]'::jsonb,
 '["practice_exercise", "case_study", "project", "peer_review"]'::jsonb,
 '["social_learners", "collaborative_workers", "discussion_oriented"]'::jsonb,
 '["peer_learning", "collaboration", "community_building"]'::jsonb,
 '["collaborative_learning", "peer_support"]'::jsonb,
 'collaborative', 'casual', 'collaborative', 'supportive', 'collaborative');

-- Create career transformation seeker persona
INSERT INTO persona_profiles (
    persona_name, persona_code, description, target_audience, career_focus,
    learning_objectives, preferred_learning_styles, difficulty_preference, 
    pacing_preference, engagement_preferences, typical_background,
    target_industries, expected_transition_timeline_weeks, mentorship_requirements,
    portfolio_requirements, certification_pathways, time_commitment_hours_week, 
    session_duration_minutes
) VALUES (
    'Career Transformation Seeker', 'career-transformation-seeker',
    'Motivated professionals seeking complete career domain transitions with structured guidance and mentorship support',
    '["working_professionals", "career_changers", "skill_builders", "industry_switchers"]'::jsonb,
    '["complete_career_transition", "industry_expertise", "professional_portfolio", "job_placement"]'::jsonb,
    '["master_new_domain_skills", "build_professional_portfolio", "develop_industry_network", "achieve_job_placement"]'::jsonb,
    ARRAY['mentored', 'collaborative', 'kinesthetic']::learning_style[],
    'intermediate',
    'adaptive',
    '{"mentorship_intensity": "high", "community_engagement": "high", "real_world_application": "very_high"}'::jsonb,
    '["business_professionals", "non_technical_backgrounds", "career_plateau", "industry_disruption_victims"]'::jsonb,
    ARRAY['technology', 'data_science', 'cybersecurity', 'cloud_computing']::industry_sector[],
    26,
    '{"mentor_sessions_per_week": 1, "coaching_sessions_per_month": 4, "industry_expert_consultations": 2}'::jsonb,
    '{"minimum_projects": 3, "showcase_ready_projects": 2, "industry_validated_projects": 1}'::jsonb,
    '{"recommended_certifications": ["AWS Cloud Practitioner", "Google Analytics", "CompTIA Security+"], "timeline": "6_months"}'::jsonb,
    12,
    35
);

-- Create industry sector definitions
INSERT INTO industry_sectors (
    sector_name, display_name, description, growth_outlook, average_salary_range,
    job_market_demand, remote_work_availability, required_skills, preferred_skills,
    common_tools, typical_certifications, entry_level_roles, mid_level_roles,
    senior_level_roles, typical_career_progression, recommended_learning_sequence,
    average_transition_time_months, success_factors, common_challenges
) VALUES 
('technology', 'Technology & Software Development', 
 'Software development, system architecture, and technology innovation',
 'high_growth', 
 '{"entry": 65000, "mid": 95000, "senior": 130000, "currency": "USD"}'::jsonb,
 'very_high', 85.5,
 '["python", "javascript", "sql", "git", "problem_solving", "system_design"]'::jsonb,
 '["cloud_platforms", "containerization", "microservices", "agile_methodologies"]'::jsonb,
 '["vscode", "git", "docker", "aws", "jira", "slack"]'::jsonb,
 '["aws_solutions_architect", "certified_kubernetes_administrator", "scrum_master"]'::jsonb,
 '["junior_developer", "software_engineer_i", "qa_engineer"]'::jsonb,
 '["senior_developer", "tech_lead", "solutions_architect"]'::jsonb,
 '["engineering_manager", "principal_engineer", "cto"]'::jsonb,
 '["individual_contributor", "team_lead", "management_track", "technical_track"]'::jsonb,
 '["programming_fundamentals", "web_development", "databases", "system_design", "cloud_computing"]'::jsonb,
 8,
 '["strong_portfolio", "continuous_learning", "networking", "open_source_contributions"]'::jsonb,
 '["imposter_syndrome", "rapidly_changing_technology", "technical_interview_preparation"]'::jsonb),

('data_science', 'Data Science & Analytics', 
 'Data analysis, machine learning, and business intelligence',
 'very_high', 
 '{"entry": 70000, "mid": 110000, "senior": 150000, "currency": "USD"}'::jsonb,
 'very_high', 75.2,
 '["python", "sql", "statistics", "machine_learning", "data_visualization"]'::jsonb,
 '["deep_learning", "big_data_tools", "cloud_ml_platforms", "domain_expertise"]'::jsonb,
 '["python", "r", "sql", "tableau", "jupyter", "tensorflow", "aws_sagemaker"]'::jsonb,
 '["google_professional_data_engineer", "microsoft_azure_data_scientist", "tableau_certified"]'::jsonb,
 '["data_analyst", "junior_data_scientist", "business_analyst"]'::jsonb,
 '["data_scientist", "ml_engineer", "analytics_manager"]'::jsonb,
 '["principal_data_scientist", "head_of_data", "chief_data_officer"]'::jsonb,
 '["analyst", "scientist", "engineering", "leadership"]'::jsonb,
 '["statistics_fundamentals", "python_programming", "data_manipulation", "machine_learning", "business_intelligence"]'::jsonb,
 10,
 '["portfolio_of_projects", "domain_expertise", "business_acumen", "communication_skills"]'::jsonb,
 '["math_background_requirements", "business_context_understanding", "model_deployment"]'::jsonb);

-- Create default skill taxonomy for career transformation
INSERT INTO skill_taxonomy (
    parent_skill_id, skill_name, skill_code, skill_description, skill_level,
    skill_category, industry_demand, job_role_requirements, skill_market_value,
    future_outlook, typical_learning_duration_hours, prerequisite_skills,
    complementary_skills, assessment_methods, industry_validation_criteria
) VALUES 
(NULL, 'Python Programming', 'python', 'Core Python programming language skills',
 1, 'technical',
 '{"technology": 10, "data_science": 10, "cybersecurity": 8, "cloud_computing": 7}'::jsonb,
 '{"software_engineer": "required", "data_scientist": "required", "devops_engineer": "preferred"}'::jsonb,
 15000, 'growing', 120, '[]'::UUID[],
 '["git", "sql", "problem_solving"]'::UUID[],
 '["coding_challenges", "project_based", "peer_review"]'::jsonb,
 '{"junior": "basic_syntax_and_data_structures", "mid": "oop_and_libraries", "senior": "advanced_patterns_and_architecture"}'::jsonb),

(NULL, 'SQL & Database Management', 'sql', 'Database querying and management skills',
 1, 'technical',
 '{"technology": 9, "data_science": 10, "cybersecurity": 7, "cloud_computing": 8}'::jsonb,
 '{"data_analyst": "required", "backend_developer": "required", "data_engineer": "required"}'::jsonb,
 12000, 'stable', 80, '[]'::UUID[],
 '["python", "data_analysis", "cloud_platforms"]'::UUID[],
 '["practical_queries", "database_design", "performance_optimization"]'::jsonb,
 '{"entry": "basic_queries_and_joins", "mid": "complex_queries_and_optimization", "senior": "database_architecture_and_tuning"}'::jsonb),

(NULL, 'Portfolio Development', 'portfolio', 'Professional portfolio creation and presentation skills',
 1, 'soft',
 '{"all_industries": 8}'::jsonb,
 '{"all_roles": "highly_preferred"}'::jsonb,
 8000, 'growing', 60, '[]'::UUID[],
 '["project_management", "presentation", "technical_writing"]'::UUID[],
 '["portfolio_review", "presentation", "peer_feedback"]'::jsonb,
 '{"entry": "3_completed_projects", "mid": "5_diverse_projects_with_documentation", "senior": "industry_validated_projects_with_impact_metrics"}'::jsonb);

-- Final schema summary
DO $$
BEGIN
    RAISE NOTICE '=== CAREER TRANSFORMATION SEEKER SCHEMA DEPLOYMENT COMPLETE ===';
    RAISE NOTICE 'Total Tables Created: 30+';
    RAISE NOTICE 'Total Fields: ~450+';
    RAISE NOTICE 'Indexes Created: 60+';
    RAISE NOTICE 'Materialized Views: 3';
    RAISE NOTICE 'Functions: 6';
    RAISE NOTICE 'Triggers: 8';
    RAISE NOTICE 'RLS Policies: 12';
    RAISE NOTICE 'Career-Specific Features: Industry Tracking, Mentorship, Portfolio Management';
    RAISE NOTICE 'AI Avatar Roles: 7 (including career_coach and industry_expert)';
    RAISE NOTICE 'Specialized Content Types: Case Studies, Industry Projects, Interview Prep';
    RAISE NOTICE '================================================================';
END $$;

-- Refresh materialized views for initial state
SELECT refresh_career_analytics_views();

COMMIT;