-- ================================================================
-- TIME-CONSTRAINED PROFESSIONAL AI EDUCATION PLATFORM SCHEMA
-- Production-Ready PostgreSQL Database for Micro-Learning & Career Advancement
-- Optimized for 15-minute sessions, mobile-first, and workplace integration
-- ================================================================

-- ================================================================
-- SYSTEM CONFIGURATION & EXTENSIONS
-- ================================================================

-- Enable required extensions for advanced functionality
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";          -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";           -- Encryption functions
CREATE EXTENSION IF NOT EXISTS "vector";             -- Vector embeddings for semantic search
CREATE EXTENSION IF NOT EXISTS "pg_trgm";            -- Trigram matching for fuzzy search
CREATE EXTENSION IF NOT EXISTS "tablefunc";          -- Crosstab and pivot functionality
CREATE EXTENSION IF NOT EXISTS "btree_gin";          -- GIN indexes for arrays
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements"; -- Query performance monitoring
CREATE EXTENSION IF NOT EXISTS "pg_cron";            -- Automated tasks scheduling
CREATE EXTENSION IF NOT EXISTS "timescaledb";        -- Time-series data for learning analytics

-- Set timezone for consistent timestamps
SET timezone = 'UTC';

-- ================================================================
-- ENHANCED ENUMS & TYPES FOR MICRO-LEARNING PROFESSIONALS
-- ================================================================

-- Professional development goals
CREATE TYPE career_objective AS ENUM (
    'skill_advancement', 'role_transition', 'productivity_enhancement', 
    'automation_expertise', 'leadership_preparation', 'technical_credibility'
);

-- Learning session efficiency levels
CREATE TYPE efficiency_level AS ENUM (
    'low', 'moderate', 'high', 'optimal', 'exceptional'
);

-- Mobile learning contexts
CREATE TYPE learning_context AS ENUM (
    'commute', 'lunch_break', 'morning_routine', 'evening_study', 
    'weekend_focus', 'workplace_application'
);

-- Workplace application areas
CREATE TYPE workplace_domain AS ENUM (
    'data_analysis', 'process_automation', 'reporting', 'system_integration',
    'quality_assurance', 'project_management', 'business_intelligence', 'api_development'
);

-- Session completion status optimized for micro-learning
CREATE TYPE micro_session_status AS ENUM (
    'not_started', 'in_progress', 'paused', 'completed', 'reviewed', 'applied'
);

-- Professional skill proficiency levels
CREATE TYPE proficiency_level AS ENUM (
    'awareness', 'novice', 'intermediate', 'proficient', 'expert', 'thought_leader'
);

-- Content delivery optimized for mobile/time constraints
CREATE TYPE delivery_format AS ENUM (
    'micro_video', 'interactive_snippet', 'mobile_quiz', 'code_challenge',
    'business_scenario', 'offline_reading', 'audio_summary', 'visual_diagram'
);

-- Assessment types for busy professionals
CREATE TYPE assessment_format AS ENUM (
    'quick_quiz', 'code_snippet', 'scenario_analysis', 'practical_application',
    'peer_review', 'workplace_project', 'efficiency_challenge', 'mobile_assessment'
);

-- AI Avatar roles optimized for professional development
CREATE TYPE professional_avatar_role AS ENUM (
    'efficiency_coach', 'career_advisor', 'technical_mentor', 'productivity_expert',
    'workplace_consultant', 'skill_optimizer', 'time_manager', 'industry_expert'
);

-- Progress tracking states for professionals
CREATE TYPE professional_progress AS ENUM (
    'planned', 'started', 'practicing', 'applying_at_work', 'mastered', 'teaching_others'
);

-- Workplace integration status
CREATE TYPE workplace_integration AS ENUM (
    'theoretical', 'experimental', 'pilot_project', 'production_use', 'standard_practice'
);

-- ================================================================
-- 1. PROFESSIONAL USER PROFILES & CAREER TRACKING
-- ================================================================

-- Professional user profiles optimized for career development
CREATE TABLE professional_profiles (
    profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE, -- Links to external user system
    
    -- Professional information
    full_name VARCHAR(200) NOT NULL,
    job_title VARCHAR(150),
    company_name VARCHAR(200),
    industry VARCHAR(100),
    years_of_experience INTEGER DEFAULT 0,
    
    -- Career objectives
    primary_objectives career_objective[] NOT NULL,
    target_role VARCHAR(200),
    promotion_timeline_months INTEGER DEFAULT 12,
    skill_gap_priorities JSONB, -- Skills needed for career advancement
    
    -- Learning constraints and preferences
    weekly_available_hours INTEGER DEFAULT 4, -- 3-5 hours typical
    preferred_session_duration INTEGER DEFAULT 15, -- minutes
    preferred_learning_contexts learning_context[] NOT NULL,
    mobile_primary BOOLEAN DEFAULT true,
    
    -- Workplace context
    current_tech_stack JSONB, -- Technologies used at work
    automation_opportunities JSONB, -- Areas for process improvement
    team_size INTEGER DEFAULT 1,
    reporting_level VARCHAR(50), -- 'individual', 'team_lead', 'manager', 'director'
    
    -- Learning efficiency tracking
    target_efficiency_rate DECIMAL(3,2) DEFAULT 0.85, -- 85% target
    average_session_efficiency DECIMAL(3,2) DEFAULT 0.70,
    learning_streak_days INTEGER DEFAULT 0,
    consistency_score DECIMAL(3,2) DEFAULT 0.00, -- Based on daily usage
    
    -- Career advancement metrics
    skills_applied_at_work INTEGER DEFAULT 0,
    workplace_projects_improved INTEGER DEFAULT 0,
    productivity_improvement_percentage DECIMAL(5,2) DEFAULT 0,
    peer_recognition_events INTEGER DEFAULT 0,
    
    -- Mobile and offline preferences
    offline_content_sync BOOLEAN DEFAULT true,
    push_notifications_enabled BOOLEAN DEFAULT true,
    optimal_notification_times TIME[] DEFAULT ARRAY['08:00'::TIME, '12:30'::TIME, '18:00'::TIME],
    
    -- Professional development tracking
    last_performance_review DATE,
    next_career_milestone DATE,
    skill_certification_goals JSONB,
    professional_network_size INTEGER DEFAULT 0,
    
    -- Platform engagement
    last_login TIMESTAMPTZ,
    total_learning_hours DECIMAL(6,2) DEFAULT 0,
    micro_sessions_completed INTEGER DEFAULT 0,
    workplace_applications INTEGER DEFAULT 0,
    
    -- Audit fields
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_experience_range CHECK (years_of_experience >= 0 AND years_of_experience <= 50),
    CONSTRAINT chk_efficiency_rate CHECK (target_efficiency_rate BETWEEN 0 AND 1),
    CONSTRAINT chk_session_duration CHECK (preferred_session_duration BETWEEN 5 AND 30)
);

-- Professional skill taxonomy with workplace relevance
CREATE TABLE professional_skills (
    skill_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    skill_code VARCHAR(50) NOT NULL UNIQUE,
    skill_name VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Professional categorization
    workplace_domain workplace_domain NOT NULL,
    skill_category VARCHAR(100), -- 'technical', 'analytical', 'automation', 'communication'
    career_impact_score INTEGER DEFAULT 5, -- 1-10 impact on career advancement
    
    -- Learning characteristics
    typical_learning_time_hours DECIMAL(4,1), -- Time to basic proficiency
    prerequisite_skills UUID[], -- Array of skill IDs
    complementary_skills UUID[], -- Skills that enhance this one
    
    -- Professional relevance
    job_market_demand INTEGER DEFAULT 5, -- 1-10 scale
    salary_impact_percentage DECIMAL(4,1), -- Average salary impact
    industry_growth_trend VARCHAR(20) DEFAULT 'stable', -- 'declining', 'stable', 'growing'
    
    -- Workplace application
    automation_potential INTEGER DEFAULT 5, -- 1-10 scale for process automation
    collaboration_enhancement INTEGER DEFAULT 5, -- 1-10 scale for team productivity
    leadership_relevance INTEGER DEFAULT 3, -- 1-10 scale for management roles
    
    -- Learning efficiency factors
    micro_learning_friendly BOOLEAN DEFAULT true,
    mobile_practice_suitable BOOLEAN DEFAULT true,
    hands_on_practice_required BOOLEAN DEFAULT true,
    
    -- Content and resources
    best_practice_resources JSONB,
    industry_use_cases JSONB,
    common_pitfalls JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_impact_scores CHECK (
        career_impact_score BETWEEN 1 AND 10 AND
        job_market_demand BETWEEN 1 AND 10 AND
        automation_potential BETWEEN 1 AND 10
    )
);

-- Career development milestones tracking
CREATE TABLE career_milestones (
    milestone_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Milestone details
    milestone_name VARCHAR(200) NOT NULL,
    milestone_category VARCHAR(50) NOT NULL, -- 'promotion', 'skill_mastery', 'project_success', 'recognition'
    target_date DATE,
    achieved_date DATE,
    
    -- Skill development connection
    required_skills UUID[] NOT NULL, -- Skills needed for this milestone
    current_skill_readiness DECIMAL(3,2) DEFAULT 0, -- 0-1 scale
    learning_plan_id UUID, -- Reference to structured learning plan
    
    -- Professional context
    workplace_relevance INTEGER DEFAULT 5, -- 1-10 scale
    team_impact INTEGER DEFAULT 3, -- 1-10 scale
    business_value TEXT,
    
    -- Progress tracking
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    obstacles_identified JSONB,
    support_needed JSONB,
    success_metrics JSONB,
    
    -- Achievement validation
    verification_method VARCHAR(100), -- 'self_assessment', 'peer_review', 'supervisor_confirmation'
    evidence_artifacts JSONB, -- Projects, certifications, testimonials
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_readiness_percentage CHECK (current_skill_readiness BETWEEN 0 AND 1)
);

-- Workplace application tracking
CREATE TABLE workplace_applications (
    application_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Application details
    application_name VARCHAR(200) NOT NULL,
    description TEXT,
    workplace_domain workplace_domain NOT NULL,
    
    -- Skills applied
    skills_used UUID[] NOT NULL, -- Array of skill IDs
    learning_units_applied UUID[], -- Learning units that enabled this
    
    -- Implementation details
    implementation_date DATE,
    time_saved_hours DECIMAL(6,2), -- Time saved through automation/efficiency
    people_affected INTEGER DEFAULT 1, -- Team members benefiting
    process_improvement_description TEXT,
    
    -- Business impact
    productivity_gain_percentage DECIMAL(5,2),
    cost_savings_estimate DECIMAL(10,2), -- Dollar value if applicable
    quality_improvement_description TEXT,
    scalability_potential VARCHAR(100), -- 'individual', 'team', 'department', 'company'
    
    -- Recognition and feedback
    supervisor_feedback TEXT,
    peer_recognition_received BOOLEAN DEFAULT false,
    formal_recognition VARCHAR(100), -- 'none', 'verbal_praise', 'written_commendation', 'promotion'
    
    -- Integration status
    integration_status workplace_integration DEFAULT 'experimental',
    adoption_challenges JSONB,
    future_enhancement_plans JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 2. MICRO-LEARNING CURRICULUM STRUCTURE
-- ================================================================

-- Professional curriculum optimized for busy schedules
CREATE TABLE professional_curricula (
    curriculum_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    curriculum_code VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    
    -- Professional targeting
    target_career_objectives career_objective[] NOT NULL,
    target_job_roles VARCHAR(100)[] NOT NULL,
    workplace_domains workplace_domain[] NOT NULL,
    experience_level_min INTEGER DEFAULT 1, -- Years of experience
    experience_level_max INTEGER DEFAULT 20,
    
    -- Time optimization characteristics
    total_duration_weeks INTEGER DEFAULT 14, -- Accelerated 14-week program
    sessions_per_week INTEGER DEFAULT 5, -- Daily sessions target
    average_session_minutes INTEGER DEFAULT 15, -- Micro-learning sessions
    mobile_optimization_level INTEGER DEFAULT 9, -- 1-10 scale
    
    -- Efficiency and outcomes
    target_efficiency_rate DECIMAL(3,2) DEFAULT 0.85, -- 85% target
    skill_acquisition_velocity DECIMAL(3,1), -- Skills per month
    workplace_application_rate DECIMAL(3,2) DEFAULT 0.90, -- 90% target
    career_advancement_timeline_months INTEGER DEFAULT 12,
    
    -- Professional outcomes
    expected_productivity_increase DECIMAL(5,2), -- Percentage improvement
    expected_skill_certifications INTEGER DEFAULT 2,
    workplace_project_opportunities INTEGER DEFAULT 3,
    
    -- Learning design
    micro_learning_optimized BOOLEAN DEFAULT true,
    offline_capability_percentage DECIMAL(3,2) DEFAULT 0.80, -- 80% offline capable
    mobile_first_design BOOLEAN DEFAULT true,
    just_in_time_resources BOOLEAN DEFAULT true,
    
    -- Success metrics
    completion_rate DECIMAL(5,4), -- Historical completion rate
    career_advancement_success_rate DECIMAL(5,4), -- Promotion success rate
    workplace_application_success_rate DECIMAL(5,4),
    
    -- Curriculum metadata
    version VARCHAR(20) DEFAULT '1.0',
    status VARCHAR(20) DEFAULT 'active',
    last_industry_update DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_positive_duration CHECK (total_duration_weeks > 0),
    CONSTRAINT chk_efficiency_target CHECK (target_efficiency_rate BETWEEN 0.5 AND 1.0),
    CONSTRAINT chk_session_duration CHECK (average_session_minutes BETWEEN 5 AND 30)
);

-- Professional modules with workplace integration
CREATE TABLE professional_modules (
    module_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    curriculum_id UUID NOT NULL REFERENCES professional_curricula(curriculum_id) ON DELETE CASCADE,
    module_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    
    -- Module structure
    module_number INTEGER NOT NULL,
    duration_weeks INTEGER NOT NULL,
    estimated_hours INTEGER NOT NULL,
    micro_sessions_count INTEGER NOT NULL,
    
    -- Professional integration
    workplace_applications JSONB NOT NULL, -- Real workplace scenarios
    business_context TEXT NOT NULL, -- Why professionals need this
    career_impact_description TEXT, -- How this advances careers
    
    -- Learning objectives
    technical_skills_developed UUID[], -- Array of skill IDs
    professional_competencies JSONB, -- Soft skills, processes
    workplace_readiness_criteria JSONB,
    
    -- Efficiency optimization
    prerequisite_modules UUID[],
    parallel_learning_modules UUID[], -- Can be learned simultaneously
    critical_path BOOLEAN DEFAULT false, -- Must complete before others
    
    -- Mobile and time constraints
    mobile_friendly_percentage DECIMAL(3,2) DEFAULT 0.90,
    offline_content_percentage DECIMAL(3,2) DEFAULT 0.80,
    quick_reference_materials JSONB, -- Cheat sheets, summaries
    
    -- Assessment and validation
    micro_assessments_count INTEGER DEFAULT 0,
    workplace_project_required BOOLEAN DEFAULT false,
    peer_collaboration_opportunities INTEGER DEFAULT 0,
    
    -- Success tracking
    completion_efficiency_target DECIMAL(3,2) DEFAULT 0.85,
    workplace_application_target DECIMAL(3,2) DEFAULT 0.75,
    
    order_index INTEGER DEFAULT 100,
    is_core_module BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(curriculum_id, module_code),
    CONSTRAINT chk_positive_sessions CHECK (micro_sessions_count > 0)
);

-- Professional components optimized for 15-minute sessions
CREATE TABLE professional_components (
    component_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL REFERENCES professional_modules(module_id) ON DELETE CASCADE,
    component_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Component structure
    component_number DECIMAL(3,1) NOT NULL,
    estimated_duration_minutes INTEGER NOT NULL DEFAULT 15, -- Micro-learning focus
    
    -- Professional relevance
    workplace_scenario TEXT NOT NULL, -- Specific work situation
    business_value_proposition TEXT, -- Why professionals should learn this
    immediate_application_opportunities TEXT, -- How to use right away
    
    -- Learning design for busy professionals
    session_format delivery_format DEFAULT 'interactive_snippet',
    requires_internet BOOLEAN DEFAULT false, -- Offline capability
    mobile_optimized BOOLEAN DEFAULT true,
    can_pause_resume BOOLEAN DEFAULT true,
    
    -- Content organization
    key_concepts JSONB NOT NULL, -- Core concepts to master
    practical_examples JSONB, -- Work-relevant examples
    common_mistakes JSONB, -- Professional pitfalls to avoid
    best_practices JSONB, -- Industry standards
    
    -- Efficiency features
    prerequisite_knowledge JSONB, -- What to review first
    time_saving_tips JSONB, -- How to learn faster
    productivity_hacks JSONB, -- Efficiency tricks
    
    -- Professional tools and resources
    recommended_tools JSONB, -- Software, libraries, services
    industry_resources JSONB, -- Professional references
    continuing_education JSONB, -- Advanced learning paths
    
    order_index INTEGER DEFAULT 100,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(module_id, component_code),
    CONSTRAINT chk_micro_session_duration CHECK (estimated_duration_minutes BETWEEN 5 AND 20)
);

-- Professional topics with immediate workplace applicability
CREATE TABLE professional_topics (
    topic_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    component_id UUID NOT NULL REFERENCES professional_components(component_id) ON DELETE CASCADE,
    topic_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Topic characteristics
    estimated_duration_minutes INTEGER NOT NULL DEFAULT 5, -- Micro-topic
    difficulty_level INTEGER DEFAULT 5, -- 1-10 scale
    workplace_relevance_score INTEGER DEFAULT 8, -- 1-10 scale
    
    -- Professional learning objectives
    skill_outcomes UUID[] NOT NULL, -- Skills gained from this topic
    workplace_applications JSONB NOT NULL, -- How to apply at work
    professional_scenarios JSONB, -- When to use this knowledge
    
    -- Micro-learning optimization
    bite_sized_concepts JSONB NOT NULL, -- Digestible learning chunks
    quick_wins JSONB, -- Immediate benefits
    progressive_complexity JSONB, -- How difficulty builds
    
    -- Professional context
    industry_standards JSONB, -- Best practices for professionals
    compliance_considerations JSONB, -- Legal/regulatory aspects
    team_collaboration_aspects JSONB, -- Working with others
    
    -- Efficiency and productivity
    automation_opportunities JSONB, -- How to automate this
    time_saving_techniques JSONB, -- Efficiency improvements
    quality_improvement_tips JSONB, -- Professional excellence
    
    -- Assessment and practice
    quick_practice_exercises JSONB, -- 2-3 minute practice
    self_assessment_questions JSONB, -- Check understanding
    workplace_application_challenges JSONB, -- Real-world practice
    
    order_index INTEGER DEFAULT 100,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(component_id, topic_code),
    CONSTRAINT chk_micro_topic_duration CHECK (estimated_duration_minutes BETWEEN 1 AND 10),
    CONSTRAINT chk_relevance_score CHECK (workplace_relevance_score BETWEEN 1 AND 10)
);

-- Learning units optimized for mobile micro-learning
CREATE TABLE professional_learning_units (
    unit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id UUID NOT NULL REFERENCES professional_topics(topic_id) ON DELETE CASCADE,
    unit_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Unit characteristics for micro-learning
    estimated_duration_minutes INTEGER DEFAULT 3, -- Very focused
    complexity_score INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Professional learning focus
    learning_objective TEXT NOT NULL,
    workplace_application TEXT NOT NULL,
    immediate_value_proposition TEXT, -- Why learn this now
    
    -- Skill development
    primary_skill UUID REFERENCES professional_skills(skill_id),
    supporting_skills UUID[], -- Additional skills reinforced
    proficiency_target proficiency_level DEFAULT 'novice',
    
    -- Content structure
    theory_content_id UUID, -- References professional_content table
    practical_exercise_id UUID,
    workplace_scenario_id UUID,
    micro_assessment_id UUID,
    
    -- Mobile optimization
    offline_capable BOOLEAN DEFAULT true,
    mobile_friendly BOOLEAN DEFAULT true,
    interactive_elements JSONB, -- Touch-friendly interactions
    audio_narration_available BOOLEAN DEFAULT false,
    
    -- Prerequisites and flow
    prerequisite_units UUID[],
    recommended_follow_up_units UUID[],
    alternative_learning_paths JSONB,
    
    -- Professional development
    career_relevance_score INTEGER DEFAULT 7, -- 1-10 scale
    leadership_applicability INTEGER DEFAULT 3, -- 1-10 scale
    innovation_potential INTEGER DEFAULT 5, -- 1-10 scale
    
    order_index INTEGER DEFAULT 100,
    is_optional BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(topic_id, unit_code),
    CONSTRAINT chk_micro_unit_duration CHECK (estimated_duration_minutes BETWEEN 1 AND 5),
    CONSTRAINT chk_career_relevance CHECK (career_relevance_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 3. PROFESSIONAL CONTENT MANAGEMENT
-- ================================================================

-- Professional content optimized for mobile and efficiency
CREATE TABLE professional_content (
    content_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES professional_learning_units(unit_id) ON DELETE SET NULL,
    
    -- Content identification
    external_id VARCHAR(100) UNIQUE,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    content_type VARCHAR(50) NOT NULL,
    format delivery_format NOT NULL,
    
    -- Content storage optimized for mobile
    content_markdown TEXT,
    content_html TEXT,
    content_json JSONB,
    mobile_optimized_content TEXT, -- Responsive/mobile-specific content
    audio_transcript TEXT, -- For accessibility and offline use
    
    -- Mobile and offline features
    offline_cache_size_kb INTEGER, -- Cache size for offline use
    download_priority INTEGER DEFAULT 5, -- 1-10 download priority
    mobile_data_friendly BOOLEAN DEFAULT true, -- Low bandwidth friendly
    progressive_loading BOOLEAN DEFAULT true, -- Loads in chunks
    
    -- Professional context
    workplace_applications JSONB NOT NULL,
    business_scenarios JSONB, -- Real business situations
    professional_examples JSONB, -- Industry-relevant examples
    
    -- Learning design for busy professionals
    learning_objectives JSONB NOT NULL,
    prerequisite_knowledge JSONB,
    estimated_duration_minutes INTEGER NOT NULL,
    micro_learning_chunks JSONB, -- Break content into smaller pieces
    
    -- Professional development features
    industry_best_practices JSONB,
    common_professional_mistakes JSONB,
    career_advancement_tips JSONB,
    networking_opportunities JSONB,
    
    -- Quality and effectiveness
    content_quality_score DECIMAL(3,2) DEFAULT 0,
    professional_relevance_score DECIMAL(3,2) DEFAULT 7,
    mobile_experience_score DECIMAL(3,2) DEFAULT 7,
    learning_efficiency_score DECIMAL(3,2) DEFAULT 7,
    
    -- Usage analytics
    view_count INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,4),
    mobile_usage_percentage DECIMAL(3,2),
    average_session_duration DECIMAL(6,2), -- Minutes
    user_rating DECIMAL(3,2),
    
    -- Professional tags and search
    keywords TEXT[] NOT NULL,
    professional_tags VARCHAR(50)[] NOT NULL,
    skill_tags UUID[], -- References to professional_skills
    career_stage_tags VARCHAR(50)[], -- 'entry', 'mid', 'senior', 'executive'
    industry_tags VARCHAR(50)[],
    
    -- Maintenance and updates
    last_professional_review DATE,
    industry_currency_score INTEGER DEFAULT 7, -- 1-10 how current/relevant
    needs_update BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_duration_positive CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_quality_scores CHECK (
        professional_relevance_score BETWEEN 1 AND 10 AND
        mobile_experience_score BETWEEN 1 AND 10 AND
        learning_efficiency_score BETWEEN 1 AND 10
    )
);

-- Workplace scenarios with real-world context
CREATE TABLE workplace_scenarios (
    scenario_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES professional_content(content_id) ON DELETE CASCADE,
    
    -- Scenario details
    scenario_name VARCHAR(200) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    job_role VARCHAR(100) NOT NULL,
    company_size VARCHAR(50), -- 'startup', 'small', 'medium', 'large', 'enterprise'
    
    -- Problem and context
    business_problem TEXT NOT NULL,
    stakeholders_involved JSONB,
    constraints_and_limitations JSONB,
    success_criteria JSONB,
    
    -- Technical requirements
    technical_challenges JSONB,
    tools_and_technologies JSONB,
    data_requirements JSONB,
    integration_needs JSONB,
    
    -- Solution approach
    recommended_approach TEXT,
    alternative_approaches JSONB,
    implementation_steps JSONB,
    best_practices_applied JSONB,
    
    -- Professional development aspects
    skills_demonstrated UUID[], -- Array of skill IDs
    career_advancement_opportunities TEXT,
    leadership_aspects JSONB,
    collaboration_requirements JSONB,
    
    -- Realistic constraints
    time_constraints VARCHAR(100), -- 'urgent', 'standard', 'long_term'
    budget_considerations TEXT,
    resource_limitations JSONB,
    political_considerations TEXT, -- Office politics, stakeholder management
    
    -- Learning value
    key_learning_points JSONB,
    common_mistakes_to_avoid JSONB,
    professional_growth_opportunities JSONB,
    networking_potential JSONB,
    
    -- Validation and authenticity
    based_on_real_experience BOOLEAN DEFAULT true,
    industry_reviewed BOOLEAN DEFAULT false,
    difficulty_level INTEGER DEFAULT 5, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_difficulty_range CHECK (difficulty_level BETWEEN 1 AND 10)
);

-- Professional templates and quick references
CREATE TABLE professional_resources (
    resource_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES professional_content(content_id) ON DELETE CASCADE,
    
    -- Resource identification
    resource_name VARCHAR(200) NOT NULL,
    resource_category VARCHAR(100) NOT NULL, -- 'cheat_sheet', 'template', 'checklist', 'reference'
    resource_type VARCHAR(50) NOT NULL, -- 'quick_reference', 'code_template', 'process_guide'
    
    -- Professional context
    workplace_domain workplace_domain NOT NULL,
    use_cases JSONB NOT NULL, -- When to use this resource
    
    -- Resource content
    resource_content TEXT NOT NULL,
    resource_format VARCHAR(50) DEFAULT 'markdown',
    
    -- Mobile optimization
    mobile_friendly BOOLEAN DEFAULT true,
    offline_accessible BOOLEAN DEFAULT true,
    quick_search_enabled BOOLEAN DEFAULT true,
    
    -- Professional utility
    time_saving_potential INTEGER DEFAULT 5, -- 1-10 scale
    professional_impact INTEGER DEFAULT 5, -- 1-10 scale
    reusability_score INTEGER DEFAULT 7, -- 1-10 scale
    
    -- Usage instructions
    usage_instructions TEXT,
    customization_guide TEXT,
    integration_tips JSONB,
    professional_considerations JSONB,
    
    -- Effectiveness metrics
    usage_count INTEGER DEFAULT 0,
    user_rating DECIMAL(3,2),
    time_saved_reported_minutes INTEGER DEFAULT 0,
    
    -- Professional standards
    industry_compliance JSONB, -- Legal, regulatory considerations
    best_practice_alignment INTEGER DEFAULT 7, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_professional_scores CHECK (
        time_saving_potential BETWEEN 1 AND 10 AND
        professional_impact BETWEEN 1 AND 10 AND
        reusability_score BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 4. AI AVATAR SYSTEM FOR PROFESSIONAL GUIDANCE
-- ================================================================

-- Professional AI avatars optimized for career development
CREATE TABLE professional_ai_avatars (
    avatar_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    avatar_name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    
    -- Avatar specialization
    primary_role professional_avatar_role NOT NULL,
    specialization_areas workplace_domain[] NOT NULL,
    career_level_expertise VARCHAR(50), -- 'mid_career', 'senior', 'executive', 'all_levels'
    
    -- Professional persona
    years_of_simulated_experience INTEGER DEFAULT 10,
    industry_background VARCHAR(100)[],
    management_experience BOOLEAN DEFAULT false,
    consulting_background BOOLEAN DEFAULT false,
    
    -- Avatar capabilities optimized for professionals
    can_provide_career_advice BOOLEAN DEFAULT false,
    can_review_code_professionally BOOLEAN DEFAULT false,
    can_suggest_productivity_improvements BOOLEAN DEFAULT false,
    can_analyze_workplace_scenarios BOOLEAN DEFAULT false,
    can_provide_time_management_tips BOOLEAN DEFAULT true,
    can_recommend_skill_priorities BOOLEAN DEFAULT true,
    
    -- Communication style for busy professionals
    communication_efficiency INTEGER DEFAULT 8, -- 1-10 conciseness
    professional_formality INTEGER DEFAULT 7, -- 1-10 formality level
    encouragement_style VARCHAR(50) DEFAULT 'professional', -- 'motivational', 'professional', 'analytical'
    
    -- Micro-learning optimization
    optimized_for_short_sessions BOOLEAN DEFAULT true,
    mobile_interaction_friendly BOOLEAN DEFAULT true,
    quick_tip_specialist BOOLEAN DEFAULT true,
    
    -- Professional guidance features
    career_coaching_enabled BOOLEAN DEFAULT false,
    workplace_scenario_expertise BOOLEAN DEFAULT false,
    industry_insight_access BOOLEAN DEFAULT false,
    networking_advice_capability BOOLEAN DEFAULT false,
    
    -- Avatar status
    is_active BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '1.0',
    last_professional_update DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_professional_levels CHECK (
        communication_efficiency BETWEEN 1 AND 10 AND
        professional_formality BETWEEN 1 AND 10
    )
);

-- Avatar content variations for professional contexts
CREATE TABLE professional_avatar_content (
    variation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES professional_content(content_id) ON DELETE CASCADE,
    avatar_id UUID NOT NULL REFERENCES professional_ai_avatars(avatar_id) ON DELETE CASCADE,
    
    -- Professional context adaptation
    workplace_context_intro TEXT,
    career_relevance_explanation TEXT,
    industry_specific_examples JSONB,
    
    -- Avatar-specific professional guidance
    efficiency_tips JSONB, -- Time-saving and productivity tips
    career_advancement_insights JSONB, -- How this helps career growth
    workplace_application_guidance JSONB, -- How to apply at work
    
    -- Professional communication style
    communication_tone TEXT, -- How this avatar communicates
    professional_anecdotes JSONB, -- Work-related stories and examples
    industry_references JSONB, -- References to industry practices
    
    -- Interactive professional elements
    coaching_questions JSONB, -- Questions to guide professional thinking
    scenario_challenges JSONB, -- Workplace challenges to consider
    skill_assessment_prompts JSONB, -- Self-evaluation guidance
    
    -- Time-constrained optimizations
    quick_summary TEXT, -- 30-second version
    key_takeaways JSONB, -- Bullet point summary
    immediate_action_items JSONB, -- What to do right now
    
    -- Workplace integration support
    implementation_roadmap JSONB, -- Step-by-step workplace application
    stakeholder_communication_tips JSONB, -- How to present to colleagues
    risk_mitigation_advice JSONB, -- Potential workplace challenges
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, avatar_id)
);

-- ================================================================
-- 5. PROFESSIONAL ASSESSMENT SYSTEM
-- ================================================================

-- Professional assessments optimized for busy schedules
CREATE TABLE professional_assessments (
    assessment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES professional_learning_units(unit_id) ON DELETE CASCADE,
    
    -- Assessment identification
    assessment_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Assessment format for professionals
    assessment_type assessment_format NOT NULL,
    workplace_scenario_based BOOLEAN DEFAULT true,
    real_world_application BOOLEAN DEFAULT true,
    
    -- Time optimization for busy professionals
    estimated_duration_minutes INTEGER DEFAULT 5, -- Quick assessments
    mobile_friendly BOOLEAN DEFAULT true,
    can_pause_resume BOOLEAN DEFAULT true,
    offline_capable BOOLEAN DEFAULT false,
    
    -- Scoring and evaluation
    total_points INTEGER DEFAULT 100,
    passing_score INTEGER DEFAULT 70,
    professional_application_weight DECIMAL(3,2) DEFAULT 0.5, -- 50% on application
    
    -- Assessment parameters
    attempts_allowed INTEGER DEFAULT 3,
    immediate_feedback BOOLEAN DEFAULT true,
    detailed_explanations_provided BOOLEAN DEFAULT true,
    
    -- Professional context
    industry_relevance INTEGER DEFAULT 8, -- 1-10 scale
    career_advancement_indicator BOOLEAN DEFAULT false,
    workplace_readiness_assessment BOOLEAN DEFAULT false,
    
    -- Instructions and feedback
    instructions TEXT NOT NULL,
    professional_context_explanation TEXT,
    success_criteria JSONB,
    
    -- Results and improvement
    success_message TEXT,
    improvement_guidance TEXT,
    additional_resources JSONB,
    next_steps_recommendations JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_micro_assessment_duration CHECK (estimated_duration_minutes BETWEEN 2 AND 15),
    CONSTRAINT chk_passing_score_valid CHECK (passing_score <= total_points)
);

-- Professional assessment questions with workplace context
CREATE TABLE professional_assessment_questions (
    question_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID NOT NULL REFERENCES professional_assessments(assessment_id) ON DELETE CASCADE,
    
    -- Question content
    question_text TEXT NOT NULL,
    question_type assessment_format NOT NULL,
    points INTEGER DEFAULT 1,
    
    -- Professional context
    workplace_scenario TEXT, -- Professional situation
    business_context TEXT, -- Why this matters professionally
    stakeholder_considerations TEXT, -- Who else is affected
    
    -- Question data
    options JSONB, -- Multiple choice or other options
    correct_answer JSONB NOT NULL,
    
    -- Code challenge specifics for professionals
    starter_code TEXT,
    business_requirements JSONB, -- Real-world requirements
    test_cases JSONB,
    solution_code TEXT,
    professional_best_practices JSONB,
    
    -- Professional evaluation criteria
    technical_accuracy_weight DECIMAL(3,2) DEFAULT 0.5,
    professional_approach_weight DECIMAL(3,2) DEFAULT 0.3,
    efficiency_consideration_weight DECIMAL(3,2) DEFAULT 0.2,
    
    -- Question characteristics
    difficulty_level INTEGER DEFAULT 5, -- 1-10 scale
    industry_relevance INTEGER DEFAULT 7, -- 1-10 scale
    time_pressure_realistic BOOLEAN DEFAULT true,
    estimated_time_minutes INTEGER DEFAULT 2,
    
    -- Learning support for busy professionals
    hints JSONB,
    professional_tips JSONB, -- Industry insights
    common_mistakes JSONB,
    explanation TEXT,
    further_reading JSONB, -- Quick references
    
    -- Question performance tracking
    usage_count INTEGER DEFAULT 0,
    success_rate DECIMAL(5,4),
    average_completion_time INTEGER, -- Seconds
    professional_feedback_rating DECIMAL(3,2),
    
    order_index INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_points CHECK (points > 0),
    CONSTRAINT chk_professional_ratings CHECK (
        difficulty_level BETWEEN 1 AND 10 AND
        industry_relevance BETWEEN 1 AND 10
    ),
    CONSTRAINT chk_weight_balance CHECK (
        technical_accuracy_weight + professional_approach_weight + efficiency_consideration_weight = 1.0
    )
);

-- Workplace project assessments
CREATE TABLE workplace_projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID REFERENCES professional_assessments(assessment_id) ON DELETE CASCADE,
    user_id UUID NOT NULL, -- Who completed this project
    
    -- Project identification
    project_name VARCHAR(200) NOT NULL,
    project_description TEXT NOT NULL,
    workplace_domain workplace_domain NOT NULL,
    
    -- Project requirements
    business_objectives JSONB NOT NULL,
    technical_requirements JSONB NOT NULL,
    stakeholder_requirements JSONB,
    timeline_constraints JSONB,
    
    -- Implementation tracking
    skills_applied UUID[] NOT NULL, -- Array of skill IDs
    tools_and_technologies JSONB,
    implementation_approach TEXT,
    challenges_encountered JSONB,
    solutions_implemented JSONB,
    
    -- Professional development aspects
    collaboration_involved BOOLEAN DEFAULT false,
    leadership_demonstrated BOOLEAN DEFAULT false,
    innovation_applied BOOLEAN DEFAULT false,
    process_improvement_achieved BOOLEAN DEFAULT false,
    
    -- Project outcomes
    technical_success BOOLEAN DEFAULT false,
    business_value_delivered TEXT,
    stakeholder_satisfaction INTEGER, -- 1-10 scale
    time_efficiency_achieved BOOLEAN DEFAULT false,
    
    -- Learning and growth
    skills_developed JSONB,
    professional_insights_gained JSONB,
    career_advancement_potential TEXT,
    future_application_opportunities JSONB,
    
    -- Project artifacts
    code_repository_url TEXT,
    documentation_artifacts JSONB,
    presentation_materials JSONB,
    metrics_and_results JSONB,
    
    -- Evaluation and feedback
    self_assessment_score INTEGER, -- 1-10 scale
    peer_feedback JSONB,
    mentor_evaluation JSONB,
    industry_relevance_score INTEGER DEFAULT 7, -- 1-10 scale
    
    -- Project timeline
    started_date DATE,
    completed_date DATE,
    presentation_date DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_satisfaction_range CHECK (
        stakeholder_satisfaction IS NULL OR 
        stakeholder_satisfaction BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 6. MICRO-LEARNING PROGRESS TRACKING
-- ================================================================

-- Professional progress tracking optimized for micro-sessions
CREATE TABLE professional_progress (
    progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    unit_id UUID NOT NULL REFERENCES professional_learning_units(unit_id) ON DELETE CASCADE,
    
    -- Progress status
    status professional_progress DEFAULT 'planned',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Micro-learning session tracking
    total_micro_sessions INTEGER DEFAULT 0,
    completed_micro_sessions INTEGER DEFAULT 0,
    average_session_duration_minutes DECIMAL(4,1) DEFAULT 0,
    optimal_session_duration_minutes INTEGER DEFAULT 15,
    
    -- Time and efficiency tracking
    total_time_spent_minutes INTEGER DEFAULT 0,
    planned_learning_time INTEGER, -- Minutes originally allocated
    efficiency_score DECIMAL(3,2) DEFAULT 0, -- Actual vs planned time
    learning_velocity DECIMAL(4,2) DEFAULT 0, -- Concepts per hour
    
    -- Context and environment
    primary_learning_contexts learning_context[],
    mobile_usage_percentage DECIMAL(3,2) DEFAULT 0,
    offline_usage_percentage DECIMAL(3,2) DEFAULT 0,
    interruption_frequency INTEGER DEFAULT 0, -- Interruptions per session
    
    -- Professional application
    workplace_application_attempted BOOLEAN DEFAULT false,
    workplace_application_successful BOOLEAN DEFAULT false,
    immediate_productivity_impact BOOLEAN DEFAULT false,
    colleagues_benefited INTEGER DEFAULT 0,
    
    -- Learning effectiveness
    comprehension_score DECIMAL(3,2), -- 1-10 scale
    retention_score DECIMAL(3,2), -- Based on spaced repetition
    practical_application_confidence DECIMAL(3,2), -- 1-10 scale
    professional_readiness_score DECIMAL(3,2), -- 1-10 scale
    
    -- Career development impact
    skill_certification_readiness DECIMAL(3,2), -- 1-10 scale
    promotion_readiness_contribution DECIMAL(3,2), -- 1-10 scale
    leadership_skill_development DECIMAL(3,2), -- 1-10 scale
    
    -- Engagement and motivation
    engagement_level INTEGER DEFAULT 5, -- 1-10 scale
    motivation_score INTEGER DEFAULT 7, -- 1-10 scale
    frustration_incidents INTEGER DEFAULT 0,
    breakthrough_moments INTEGER DEFAULT 0,
    
    -- Session timestamps
    first_accessed_at TIMESTAMPTZ,
    last_accessed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    workplace_applied_at TIMESTAMPTZ,
    
    -- Notes and reflection
    user_notes TEXT,
    key_insights JSONB,
    challenges_encountered JSONB,
    success_strategies JSONB,
    
    -- Next steps and planning
    follow_up_actions JSONB,
    workplace_implementation_plan JSONB,
    skill_practice_schedule JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, unit_id),
    CONSTRAINT chk_progress_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_efficiency_score CHECK (efficiency_score >= 0)
);

-- Professional skill development tracking
CREATE TABLE professional_skill_development (
    development_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    skill_id UUID NOT NULL REFERENCES professional_skills(skill_id) ON DELETE CASCADE,
    
    -- Current skill status
    current_proficiency proficiency_level DEFAULT 'awareness',
    target_proficiency proficiency_level DEFAULT 'proficient',
    proficiency_score DECIMAL(3,2) DEFAULT 1, -- 1-10 scale
    
    -- Learning journey tracking
    learning_start_date DATE,
    target_completion_date DATE,
    workplace_application_date DATE,
    mastery_achieved_date DATE,
    certification_obtained_date DATE,
    
    -- Professional development metrics
    workplace_projects_applied INTEGER DEFAULT 0,
    team_contributions_made INTEGER DEFAULT 0,
    process_improvements_implemented INTEGER DEFAULT 0,
    mentoring_others_count INTEGER DEFAULT 0,
    
    -- Career impact tracking
    performance_review_recognition BOOLEAN DEFAULT false,
    promotion_factor BOOLEAN DEFAULT false,
    salary_increase_factor BOOLEAN DEFAULT false,
    leadership_opportunity_created BOOLEAN DEFAULT false,
    
    -- Learning efficiency
    total_learning_hours DECIMAL(6,2) DEFAULT 0,
    micro_sessions_completed INTEGER DEFAULT 0,
    average_session_efficiency DECIMAL(3,2) DEFAULT 0.7, -- Target 70%+
    retention_rate DECIMAL(3,2) DEFAULT 0.8, -- Based on assessments
    
    -- Professional validation
    peer_recognition_received BOOLEAN DEFAULT false,
    supervisor_acknowledgment BOOLEAN DEFAULT false,
    client_feedback_positive BOOLEAN DEFAULT false,
    industry_recognition BOOLEAN DEFAULT false,
    
    -- Skill application context
    primary_workplace_use_case TEXT,
    secondary_workplace_use_cases JSONB,
    collaboration_improvements JSONB,
    automation_achievements JSONB,
    
    -- Development activities
    formal_training_hours DECIMAL(5,2) DEFAULT 0,
    self_study_hours DECIMAL(5,2) DEFAULT 0,
    practical_project_hours DECIMAL(5,2) DEFAULT 0,
    peer_learning_hours DECIMAL(5,2) DEFAULT 0,
    
    -- Continuous improvement
    current_learning_resources JSONB,
    next_level_learning_plan JSONB,
    skill_maintenance_plan JSONB,
    advanced_specialization_interests JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, skill_id),
    CONSTRAINT chk_proficiency_progression CHECK (
        current_proficiency != 'expert' OR target_proficiency = 'expert'
    )
);

-- Learning session details for micro-learning optimization
CREATE TABLE learning_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Session identification
    session_type VARCHAR(50) DEFAULT 'micro_learning', -- 'micro_learning', 'focused_study', 'practice'
    learning_context learning_context NOT NULL,
    
    -- Session timing
    started_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMPTZ,
    planned_duration_minutes INTEGER DEFAULT 15,
    actual_duration_minutes INTEGER,
    
    -- Content and progress
    units_studied UUID[],
    content_consumed_count INTEGER DEFAULT 0,
    assessments_attempted INTEGER DEFAULT 0,
    assessments_passed INTEGER DEFAULT 0,
    
    -- Session quality metrics
    interruptions_count INTEGER DEFAULT 0,
    focus_quality INTEGER DEFAULT 7, -- 1-10 scale
    comprehension_self_rating INTEGER DEFAULT 7, -- 1-10 scale
    satisfaction_rating INTEGER DEFAULT 7, -- 1-10 scale
    
    -- Professional context
    workplace_application_identified BOOLEAN DEFAULT false,
    immediate_implementation_planned BOOLEAN DEFAULT false,
    collaboration_opportunities_noted BOOLEAN DEFAULT false,
    
    -- Technical environment
    device_used VARCHAR(50), -- 'mobile', 'tablet', 'desktop'
    internet_connection VARCHAR(20), -- 'wifi', 'cellular', 'offline'
    location VARCHAR(100), -- 'home', 'office', 'commute', 'cafe'
    
    -- Session effectiveness
    learning_objectives_met DECIMAL(3,2) DEFAULT 0.7, -- Percentage
    time_efficiency_score DECIMAL(3,2) DEFAULT 0.8, -- Time well spent
    motivation_impact INTEGER DEFAULT 5, -- -5 to +5 scale
    
    -- Follow-up actions
    notes_taken TEXT,
    action_items JSONB,
    questions_for_followup JSONB,
    workplace_application_ideas JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Professional learning efficiency tracking
CREATE TABLE efficiency_metrics (
    metric_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    measurement_date DATE NOT NULL,
    
    -- Daily efficiency metrics
    sessions_planned INTEGER DEFAULT 0,
    sessions_completed INTEGER DEFAULT 0,
    total_planned_minutes INTEGER DEFAULT 0,
    total_actual_minutes INTEGER DEFAULT 0,
    
    -- Learning velocity
    concepts_learned INTEGER DEFAULT 0,
    skills_practiced INTEGER DEFAULT 0,
    assessments_completed INTEGER DEFAULT 0,
    workplace_applications INTEGER DEFAULT 0,
    
    -- Quality metrics
    average_comprehension_score DECIMAL(3,2) DEFAULT 0,
    average_retention_score DECIMAL(3,2) DEFAULT 0,
    average_satisfaction_rating DECIMAL(3,2) DEFAULT 0,
    
    -- Professional development
    workplace_improvements_implemented INTEGER DEFAULT 0,
    colleagues_helped INTEGER DEFAULT 0,
    processes_automated INTEGER DEFAULT 0,
    time_saved_for_team_minutes INTEGER DEFAULT 0,
    
    -- Efficiency calculations
    learning_efficiency_rate DECIMAL(5,4), -- concepts learned per minute
    time_utilization_rate DECIMAL(5,4), -- actual vs planned time
    practical_application_rate DECIMAL(5,4), -- applications per learning unit
    
    -- Contextual factors
    primary_learning_context learning_context,
    interruption_frequency DECIMAL(4,2), -- interruptions per hour
    mobile_usage_percentage DECIMAL(3,2),
    offline_learning_percentage DECIMAL(3,2),
    
    -- Career impact indicators
    performance_improvement_indicators JSONB,
    skill_advancement_evidence JSONB,
    recognition_received JSONB,
    leadership_growth_signs JSONB,
    
    -- Aggregate scores
    daily_efficiency_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    professional_impact_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    career_advancement_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, measurement_date),
    CONSTRAINT chk_efficiency_rates CHECK (
        learning_efficiency_rate >= 0 AND
        time_utilization_rate BETWEEN 0 AND 2 AND
        practical_application_rate >= 0
    )
);

-- ================================================================
-- 7. SEMANTIC SEARCH & PROFESSIONAL INTELLIGENCE
-- ================================================================

-- Professional embedding models
CREATE TABLE professional_embedding_models (
    model_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(100) NOT NULL UNIQUE,
    provider VARCHAR(50) NOT NULL,
    model_version VARCHAR(20),
    embedding_dimensions INTEGER NOT NULL,
    
    -- Professional optimization
    workplace_domain_optimized workplace_domain[],
    career_level_optimized VARCHAR(50)[], -- 'entry', 'mid', 'senior', 'executive'
    micro_learning_optimized BOOLEAN DEFAULT false,
    
    -- Model characteristics
    context_window INTEGER,
    accuracy_score DECIMAL(5,4),
    professional_relevance_score DECIMAL(5,4),
    mobile_processing_capable BOOLEAN DEFAULT false,
    
    -- Efficiency for time-constrained users
    processing_speed_ms INTEGER, -- Average processing time
    offline_capability BOOLEAN DEFAULT false,
    bandwidth_efficiency INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    is_primary BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_dimensions_positive CHECK (embedding_dimensions > 0)
);

-- Professional content embeddings
CREATE TABLE professional_content_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES professional_content(content_id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES professional_embedding_models(model_id),
    
    -- Vector embeddings optimized for professional content
    content_vector vector NOT NULL,
    workplace_context_vector vector,
    career_relevance_vector vector,
    skill_application_vector vector,
    
    -- Professional semantic features
    industry_keywords_vector vector,
    professional_scenario_vector vector,
    efficiency_context_vector vector,
    
    -- Embedding metadata
    content_hash VARCHAR(64) NOT NULL,
    token_count INTEGER,
    professional_keywords JSONB,
    workplace_context_keywords JSONB,
    career_advancement_keywords JSONB,
    
    -- Quality and optimization
    embedding_quality_score DECIMAL(5,4),
    professional_relevance_score DECIMAL(5,4),
    search_optimization_score DECIMAL(5,4),
    mobile_search_optimized BOOLEAN DEFAULT false,
    
    -- Performance metrics
    search_frequency INTEGER DEFAULT 0,
    professional_match_accuracy DECIMAL(5,4),
    user_relevance_rating DECIMAL(3,2),
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, model_id)
);

-- Professional skill-content mapping with career context
CREATE TABLE professional_skill_content_mapping (
    mapping_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES professional_content(content_id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES professional_skills(skill_id) ON DELETE CASCADE,
    
    -- Mapping characteristics
    relevance_score DECIMAL(3,2) NOT NULL, -- 1-10 scale
    skill_development_contribution DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    career_advancement_value DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Professional application context
    workplace_applicability DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    immediate_utility DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    long_term_career_impact DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Learning progression context
    introduces_skill BOOLEAN DEFAULT false,
    reinforces_skill BOOLEAN DEFAULT true,
    advances_skill BOOLEAN DEFAULT false,
    applies_skill_professionally BOOLEAN DEFAULT false,
    
    -- Time and efficiency factors
    learning_time_efficiency DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    micro_learning_suitability DECIMAL(3,2) DEFAULT 7, -- 1-10 scale
    mobile_learning_compatibility DECIMAL(3,2) DEFAULT 7, -- 1-10 scale
    
    -- Professional development stages
    awareness_building BOOLEAN DEFAULT false,
    skill_development BOOLEAN DEFAULT true,
    professional_application BOOLEAN DEFAULT false,
    mastery_advancement BOOLEAN DEFAULT false,
    teaching_preparation BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, skill_id),
    CONSTRAINT chk_mapping_scores CHECK (
        relevance_score BETWEEN 1 AND 10 AND
        career_advancement_value BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 8. PROFESSIONAL ANALYTICS & PERFORMANCE TRACKING
-- ================================================================

-- Professional learning analytics optimized for career tracking
CREATE TABLE professional_learning_analytics (
    analytics_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    analysis_date DATE NOT NULL,
    
    -- Learning efficiency metrics
    daily_session_count INTEGER DEFAULT 0,
    total_learning_minutes INTEGER DEFAULT 0,
    average_session_duration DECIMAL(4,1) DEFAULT 0,
    learning_efficiency_rate DECIMAL(3,2) DEFAULT 0, -- Target 85%
    
    -- Professional skill development
    skills_in_progress INTEGER DEFAULT 0,
    skills_workplace_ready INTEGER DEFAULT 0,
    skills_professionally_applied INTEGER DEFAULT 0,
    skills_mastered INTEGER DEFAULT 0,
    
    -- Career advancement indicators
    workplace_applications_count INTEGER DEFAULT 0,
    process_improvements_implemented INTEGER DEFAULT 0,
    team_collaboration_enhancements INTEGER DEFAULT 0,
    leadership_opportunities_created INTEGER DEFAULT 0,
    
    -- Learning context analysis
    mobile_learning_percentage DECIMAL(3,2) DEFAULT 0,
    commute_learning_percentage DECIMAL(3,2) DEFAULT 0,
    workplace_break_learning_percentage DECIMAL(3,2) DEFAULT 0,
    focused_evening_study_percentage DECIMAL(3,2) DEFAULT 0,
    
    -- Professional development outcomes
    performance_review_improvements INTEGER DEFAULT 0,
    peer_recognition_events INTEGER DEFAULT 0,
    supervisor_acknowledgments INTEGER DEFAULT 0,
    promotion_readiness_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Efficiency and optimization
    interruption_frequency DECIMAL(4,2) DEFAULT 0, -- per hour
    focus_quality_average DECIMAL(3,2) DEFAULT 7, -- 1-10 scale
    time_optimization_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    learning_velocity DECIMAL(4,2) DEFAULT 0, -- concepts per hour
    
    -- Professional network and influence
    colleagues_helped INTEGER DEFAULT 0,
    knowledge_sharing_sessions INTEGER DEFAULT 0,
    mentoring_activities INTEGER DEFAULT 0,
    industry_networking_events INTEGER DEFAULT 0,
    
    -- Career trajectory indicators
    skill_gap_reduction_percentage DECIMAL(3,2) DEFAULT 0,
    target_role_readiness_percentage DECIMAL(3,2) DEFAULT 0,
    industry_credibility_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    thought_leadership_activities INTEGER DEFAULT 0,
    
    -- Learning satisfaction and motivation
    learning_satisfaction_average DECIMAL(3,2) DEFAULT 7, -- 1-10 scale
    career_confidence_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    motivation_level INTEGER DEFAULT 7, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, analysis_date)
);

-- Workplace impact tracking
CREATE TABLE workplace_impact_metrics (
    impact_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    measurement_period_start DATE NOT NULL,
    measurement_period_end DATE NOT NULL,
    
    -- Productivity improvements
    time_saved_hours DECIMAL(8,2) DEFAULT 0,
    processes_automated INTEGER DEFAULT 0,
    efficiency_improvements_implemented INTEGER DEFAULT 0,
    quality_improvements_documented INTEGER DEFAULT 0,
    
    -- Team and collaboration impact
    team_members_trained INTEGER DEFAULT 0,
    cross_functional_projects_initiated INTEGER DEFAULT 0,
    knowledge_sharing_sessions_led INTEGER DEFAULT 0,
    process_documentation_created INTEGER DEFAULT 0,
    
    -- Professional recognition
    supervisor_commendations INTEGER DEFAULT 0,
    peer_nominations INTEGER DEFAULT 0,
    client_positive_feedback INTEGER DEFAULT 0,
    industry_recognition_events INTEGER DEFAULT 0,
    
    -- Career advancement indicators
    new_responsibilities_assigned INTEGER DEFAULT 0,
    project_leadership_opportunities INTEGER DEFAULT 0,
    budget_responsibility_increases DECIMAL(12,2) DEFAULT 0,
    team_size_management_increases INTEGER DEFAULT 0,
    
    -- Skills application in workplace
    technical_skills_applied_count INTEGER DEFAULT 0,
    soft_skills_demonstrated_count INTEGER DEFAULT 0,
    innovation_projects_initiated INTEGER DEFAULT 0,
    problem_solving_contributions INTEGER DEFAULT 0,
    
    -- Professional development outcomes
    certifications_earned INTEGER DEFAULT 0,
    conference_presentations INTEGER DEFAULT 0,
    professional_publications INTEGER DEFAULT 0,
    industry_speaking_engagements INTEGER DEFAULT 0,
    
    -- Financial and business impact
    cost_savings_generated DECIMAL(12,2) DEFAULT 0,
    revenue_improvements_contributed DECIMAL(12,2) DEFAULT 0,
    customer_satisfaction_improvements DECIMAL(5,2) DEFAULT 0,
    business_process_optimizations INTEGER DEFAULT 0,
    
    -- Professional network growth
    industry_connections_made INTEGER DEFAULT 0,
    mentorship_relationships_established INTEGER DEFAULT 0,
    collaborative_partnerships_formed INTEGER DEFAULT 0,
    thought_leadership_following INTEGER DEFAULT 0,
    
    -- Learning attribution
    skills_directly_applied UUID[], -- Skills from learning applied at work
    learning_units_implemented UUID[], -- Learning units applied at work
    workplace_project_success_rate DECIMAL(5,4) DEFAULT 1.0,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_period CHECK (measurement_period_end >= measurement_period_start)
);

-- Professional development ROI tracking
CREATE TABLE professional_development_roi (
    roi_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    measurement_date DATE NOT NULL,
    
    -- Time investment
    total_learning_hours DECIMAL(8,2) NOT NULL,
    platform_usage_hours DECIMAL(8,2) DEFAULT 0,
    self_study_hours DECIMAL(8,2) DEFAULT 0,
    practical_application_hours DECIMAL(8,2) DEFAULT 0,
    
    -- Career advancement outcomes
    salary_increase_percentage DECIMAL(5,2) DEFAULT 0,
    promotion_achieved BOOLEAN DEFAULT false,
    role_expansion BOOLEAN DEFAULT false,
    market_value_increase_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Professional skill development
    skills_mastered_count INTEGER DEFAULT 0,
    certifications_obtained INTEGER DEFAULT 0,
    industry_recognition_level INTEGER DEFAULT 1, -- 1-10 scale
    professional_credibility_score INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Workplace productivity gains
    personal_productivity_increase_percentage DECIMAL(5,2) DEFAULT 0,
    team_productivity_contribution_hours DECIMAL(8,2) DEFAULT 0,
    process_improvement_time_savings_hours DECIMAL(8,2) DEFAULT 0,
    automation_time_savings_hours DECIMAL(8,2) DEFAULT 0,
    
    -- Network and influence growth
    professional_network_expansion_count INTEGER DEFAULT 0,
    mentoring_opportunities INTEGER DEFAULT 0,
    speaking_opportunities INTEGER DEFAULT 0,
    industry_influence_score INTEGER DEFAULT 1, -- 1-10 scale
    
    -- ROI calculations
    total_financial_benefit DECIMAL(12,2) DEFAULT 0, -- Salary increases, bonuses, etc.
    total_time_investment_cost DECIMAL(12,2) DEFAULT 0, -- Opportunity cost of time
    net_roi_percentage DECIMAL(8,4) DEFAULT 0, -- (Benefits - Costs) / Costs * 100
    
    -- Qualitative benefits
    job_satisfaction_improvement INTEGER DEFAULT 0, -- -5 to +5 scale
    career_confidence_increase INTEGER DEFAULT 0, -- -5 to +5 scale
    work_life_balance_improvement INTEGER DEFAULT 0, -- -5 to +5 scale
    professional_identity_strengthening INTEGER DEFAULT 0, -- -5 to +5 scale
    
    -- Future potential indicators
    career_trajectory_acceleration BOOLEAN DEFAULT false,
    leadership_pipeline_entry BOOLEAN DEFAULT false,
    entrepreneurial_opportunity_readiness BOOLEAN DEFAULT false,
    industry_thought_leader_potential INTEGER DEFAULT 3, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, measurement_date),
    CONSTRAINT chk_positive_learning_hours CHECK (total_learning_hours > 0)
);

-- ================================================================
-- 9. MATERIALIZED VIEWS FOR PROFESSIONAL ANALYTICS
-- ================================================================

-- Professional user performance analytics
CREATE MATERIALIZED VIEW mv_professional_user_analytics AS
SELECT 
    pp.user_id,
    pp.full_name,
    pp.job_title,
    pp.industry,
    pp.years_of_experience,
    pp.weekly_available_hours,
    pp.target_efficiency_rate,
    pp.average_session_efficiency,
    
    -- Learning engagement metrics
    COUNT(DISTINCT ls.session_id) as total_learning_sessions,
    AVG(ls.actual_duration_minutes) as avg_session_duration,
    SUM(ls.actual_duration_minutes) as total_learning_minutes,
    AVG(ls.focus_quality) as avg_focus_quality,
    AVG(ls.satisfaction_rating) as avg_satisfaction,
    
    -- Professional skill development
    COUNT(DISTINCT psd.skill_id) as skills_in_development,
    COUNT(CASE WHEN psd.current_proficiency IN ('proficient', 'expert') THEN 1 END) as skills_mastered,
    AVG(psd.proficiency_score) as avg_skill_proficiency,
    COUNT(CASE WHEN psd.workplace_projects_applied > 0 THEN 1 END) as skills_applied_at_work,
    
    -- Career advancement indicators
    COUNT(DISTINCT cm.milestone_id) as career_milestones,
    COUNT(CASE WHEN cm.achieved_date IS NOT NULL THEN 1 END) as milestones_achieved,
    AVG(cm.current_skill_readiness) as avg_milestone_readiness,
    
    -- Workplace impact
    COUNT(DISTINCT wa.application_id) as workplace_applications,
    AVG(wa.productivity_gain_percentage) as avg_productivity_gain,
    SUM(wa.time_saved_hours) as total_time_saved_hours,
    COUNT(CASE WHEN wa.formal_recognition != 'none' THEN 1 END) as recognition_events,
    
    -- Learning efficiency
    CASE 
        WHEN SUM(ls.planned_duration_minutes) > 0 THEN
            AVG(ls.actual_duration_minutes::DECIMAL / NULLIF(ls.planned_duration_minutes, 0))
        ELSE 1.0
    END as time_utilization_efficiency,
    
    -- Professional development ROI
    AVG(pdr.net_roi_percentage) as avg_development_roi,
    AVG(pdr.career_confidence_increase) as avg_confidence_increase,
    AVG(pdr.professional_credibility_score) as avg_credibility_score,
    
    -- Recent activity indicators
    MAX(ls.started_at) as last_learning_session,
    MAX(wa.implementation_date) as last_workplace_application,
    COUNT(CASE WHEN ls.started_at > CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as sessions_last_week
    
FROM professional_profiles pp
LEFT JOIN learning_sessions ls ON pp.user_id = ls.user_id
LEFT JOIN professional_skill_development psd ON pp.user_id = psd.user_id
LEFT JOIN career_milestones cm ON pp.user_id = cm.user_id
LEFT JOIN workplace_applications wa ON pp.user_id = wa.user_id
LEFT JOIN professional_development_roi pdr ON pp.user_id = pdr.user_id
GROUP BY pp.user_id, pp.full_name, pp.job_title, pp.industry, pp.years_of_experience,
         pp.weekly_available_hours, pp.target_efficiency_rate, pp.average_session_efficiency;

-- Professional skill market analysis
CREATE MATERIALIZED VIEW mv_professional_skill_analysis AS
SELECT 
    ps.skill_id,
    ps.skill_name,
    ps.workplace_domain,
    ps.career_impact_score,
    ps.job_market_demand,
    ps.salary_impact_percentage,
    ps.industry_growth_trend,
    
    -- Learning adoption metrics
    COUNT(DISTINCT psd.user_id) as professionals_learning,
    AVG(psd.proficiency_score) as avg_proficiency_level,
    COUNT(CASE WHEN psd.current_proficiency IN ('proficient', 'expert') THEN 1 END) as professionals_mastered,
    
    -- Workplace application success
    COUNT(DISTINCT wa.application_id) as workplace_applications,
    AVG(wa.productivity_gain_percentage) as avg_productivity_impact,
    COUNT(CASE WHEN wa.formal_recognition != 'none' THEN 1 END) as recognition_generating_applications,
    
    -- Professional development effectiveness
    AVG(psd.total_learning_hours) as avg_learning_time_required,
    COUNT(CASE WHEN psd.promotion_factor THEN 1 END) as promotion_contributing_cases,
    COUNT(CASE WHEN psd.salary_increase_factor THEN 1 END) as salary_increase_cases,
    
    -- Content and learning resources
    COUNT(DISTINCT pscm.content_id) as learning_content_available,
    AVG(pscm.career_advancement_value) as avg_career_advancement_value,
    AVG(pscm.workplace_applicability) as avg_workplace_applicability,
    
    -- Professional progression patterns
    AVG(EXTRACT(DAYS FROM (psd.workplace_application_date - psd.learning_start_date))) as avg_days_to_application,
    COUNT(CASE WHEN psd.mentoring_others_count > 0 THEN 1 END) as teaching_others_count,
    
    -- ROI and efficiency metrics
    CASE 
        WHEN AVG(psd.total_learning_hours) > 0 AND COUNT(DISTINCT pdr.roi_id) > 0 THEN
            AVG(pdr.total_financial_benefit / psd.total_learning_hours)
        ELSE 0
    END as avg_financial_roi_per_hour,
    
    -- Professional credibility building
    AVG(psd.performance_review_recognition::INTEGER) as performance_review_impact_rate,
    COUNT(CASE WHEN psd.leadership_opportunity_created THEN 1 END) as leadership_opportunities_created
    
FROM professional_skills ps
LEFT JOIN professional_skill_development psd ON ps.skill_id = psd.skill_id
LEFT JOIN workplace_applications wa ON ps.skill_id = ANY(wa.skills_used)
LEFT JOIN professional_skill_content_mapping pscm ON ps.skill_id = pscm.skill_id
LEFT JOIN professional_development_roi pdr ON psd.user_id = pdr.user_id
GROUP BY ps.skill_id, ps.skill_name, ps.workplace_domain, ps.career_impact_score,
         ps.job_market_demand, ps.salary_impact_percentage, ps.industry_growth_trend;

-- Professional content effectiveness analysis
CREATE MATERIALIZED VIEW mv_professional_content_effectiveness AS
SELECT 
    pc.content_id,
    pc.title,
    pc.format,
    pc.workplace_applications,
    pc.estimated_duration_minutes,
    pc.mobile_data_friendly,
    
    -- Usage and engagement metrics
    COUNT(DISTINCT pp_progress.user_id) as unique_professional_users,
    AVG(pp_progress.total_time_spent_minutes) as avg_time_spent,
    AVG(pp_progress.completion_percentage) as avg_completion_rate,
    COUNT(CASE WHEN pp_progress.status = 'applied' THEN 1 END) as workplace_applications_count,
    
    -- Professional learning effectiveness
    AVG(pp_progress.comprehension_score) as avg_comprehension,
    AVG(pp_progress.practical_application_confidence) as avg_application_confidence,
    AVG(pp_progress.professional_readiness_score) as avg_professional_readiness,
    
    -- Career advancement contribution
    COUNT(CASE WHEN pp_progress.workplace_application_successful THEN 1 END) as successful_workplace_applications,
    AVG(pp_progress.colleagues_benefited) as avg_colleagues_benefited,
    COUNT(CASE WHEN pp_progress.immediate_productivity_impact THEN 1 END) as immediate_impact_cases,
    
    -- Mobile and efficiency metrics
    AVG(pp_progress.mobile_usage_percentage) as avg_mobile_usage,
    AVG(pp_progress.efficiency_score) as avg_learning_efficiency,
    AVG(pp_progress.interruption_frequency) as avg_interruption_frequency,
    
    -- Professional skill development
    COUNT(DISTINCT pscm.skill_id) as skills_addressed,
    AVG(pscm.career_advancement_value) as avg_career_advancement_value,
    AVG(pscm.immediate_utility) as avg_immediate_utility,
    
    -- Quality and satisfaction
    pc.professional_relevance_score,
    pc.mobile_experience_score,
    pc.learning_efficiency_score,
    AVG(pp_progress.engagement_level) as avg_user_engagement,
    
    -- Professional context effectiveness
    COUNT(DISTINCT ws.scenario_id) as workplace_scenarios_count,
    AVG(ws.difficulty_level) as avg_scenario_difficulty,
    COUNT(DISTINCT pr.resource_id) as professional_resources_count,
    AVG(pr.time_saving_potential) as avg_time_saving_potential
    
FROM professional_content pc
LEFT JOIN professional_progress pp_progress ON pc.unit_id = pp_progress.unit_id
LEFT JOIN professional_skill_content_mapping pscm ON pc.content_id = pscm.content_id
LEFT JOIN workplace_scenarios ws ON pc.content_id = ws.content_id
LEFT JOIN professional_resources pr ON pc.content_id = pr.content_id
GROUP BY pc.content_id, pc.title, pc.format, pc.workplace_applications,
         pc.estimated_duration_minutes, pc.mobile_data_friendly, 
         pc.professional_relevance_score, pc.mobile_experience_score, 
         pc.learning_efficiency_score;

-- ================================================================
-- COMPREHENSIVE INDEXING STRATEGY FOR PROFESSIONAL USERS
-- ================================================================

-- Professional profile indexes
CREATE INDEX idx_professional_profiles_user ON professional_profiles(user_id);
CREATE INDEX idx_professional_profiles_objectives ON professional_profiles USING GIN(primary_objectives);
CREATE INDEX idx_professional_profiles_industry ON professional_profiles(industry);
CREATE INDEX idx_professional_profiles_experience ON professional_profiles(years_of_experience);
CREATE INDEX idx_professional_profiles_efficiency ON professional_profiles(target_efficiency_rate DESC);
CREATE INDEX idx_professional_profiles_active ON professional_profiles(last_login DESC) WHERE last_login IS NOT NULL;

-- Professional skill indexes
CREATE INDEX idx_professional_skills_domain ON professional_skills(workplace_domain);
CREATE INDEX idx_professional_skills_career_impact ON professional_skills(career_impact_score DESC, job_market_demand DESC);
CREATE INDEX idx_professional_skills_learning_friendly ON professional_skills(micro_learning_friendly, mobile_practice_suitable);
CREATE INDEX idx_professional_skills_growth ON professional_skills(industry_growth_trend, salary_impact_percentage DESC);

-- Curriculum and learning structure indexes
CREATE INDEX idx_professional_curricula_objectives ON professional_curricula USING GIN(target_career_objectives);
CREATE INDEX idx_professional_curricula_domains ON professional_curricula USING GIN(workplace_domains);
CREATE INDEX idx_professional_curricula_efficiency ON professional_curricula(target_efficiency_rate DESC);
CREATE INDEX idx_professional_modules_curriculum ON professional_modules(curriculum_id, module_number);
CREATE INDEX idx_professional_components_module ON professional_components(module_id, order_index);
CREATE INDEX idx_professional_topics_component ON professional_topics(component_id, order_index);
CREATE INDEX idx_professional_learning_units_topic ON professional_learning_units(topic_id, order_index);

-- Content management indexes
CREATE INDEX idx_professional_content_unit ON professional_content(unit_id);
CREATE INDEX idx_professional_content_format ON professional_content(format);
CREATE INDEX idx_professional_content_mobile ON professional_content(mobile_data_friendly, offline_cache_size_kb);
CREATE INDEX idx_professional_content_relevance ON professional_content(professional_relevance_score DESC);
CREATE INDEX idx_professional_content_tags ON professional_content USING GIN(professional_tags);
CREATE INDEX idx_professional_content_career_tags ON professional_content USING GIN(career_stage_tags);

-- Full-text search for professional content
CREATE INDEX idx_professional_content_search ON professional_content 
    USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || 
    array_to_string(keywords, ' ') || ' ' || array_to_string(professional_tags, ' ')));

-- Workplace application indexes
CREATE INDEX idx_workplace_applications_user ON workplace_applications(user_id);
CREATE INDEX idx_workplace_applications_domain ON workplace_applications(workplace_domain);
CREATE INDEX idx_workplace_applications_date ON workplace_applications(implementation_date DESC);
CREATE INDEX idx_workplace_applications_impact ON workplace_applications(productivity_gain_percentage DESC);
CREATE INDEX idx_workplace_applications_integration ON workplace_applications(integration_status);

-- Career milestone indexes
CREATE INDEX idx_career_milestones_user ON career_milestones(user_id);
CREATE INDEX idx_career_milestones_category ON career_milestones(milestone_category);
CREATE INDEX idx_career_milestones_target_date ON career_milestones(target_date);
CREATE INDEX idx_career_milestones_achieved ON career_milestones(achieved_date DESC) WHERE achieved_date IS NOT NULL;

-- AI Avatar indexes
CREATE INDEX idx_professional_ai_avatars_role ON professional_ai_avatars(primary_role);
CREATE INDEX idx_professional_ai_avatars_specialization ON professional_ai_avatars USING GIN(specialization_areas);
CREATE INDEX idx_professional_ai_avatars_active ON professional_ai_avatars(is_active) WHERE is_active = true;
CREATE INDEX idx_professional_ai_avatars_mobile ON professional_ai_avatars(mobile_interaction_friendly);

-- Assessment indexes
CREATE INDEX idx_professional_assessments_unit ON professional_assessments(unit_id);
CREATE INDEX idx_professional_assessments_format ON professional_assessments(assessment_type);
CREATE INDEX idx_professional_assessments_duration ON professional_assessments(estimated_duration_minutes);
CREATE INDEX idx_professional_assessment_questions_assessment ON professional_assessment_questions(assessment_id, order_index);

-- Progress tracking indexes
CREATE INDEX idx_professional_progress_user ON professional_progress(user_id);
CREATE INDEX idx_professional_progress_unit ON professional_progress(unit_id);
CREATE INDEX idx_professional_progress_status ON professional_progress(status);
CREATE INDEX idx_professional_progress_workplace ON professional_progress(workplace_application_successful);
CREATE INDEX idx_professional_progress_efficiency ON professional_progress(efficiency_score DESC);

-- Skill development indexes
CREATE INDEX idx_professional_skill_development_user ON professional_skill_development(user_id);
CREATE INDEX idx_professional_skill_development_skill ON professional_skill_development(skill_id);
CREATE INDEX idx_professional_skill_development_proficiency ON professional_skill_development(current_proficiency);
CREATE INDEX idx_professional_skill_development_workplace ON professional_skill_development(workplace_projects_applied DESC);

-- Learning session indexes for micro-learning optimization
CREATE INDEX idx_learning_sessions_user ON learning_sessions(user_id);
CREATE INDEX idx_learning_sessions_context ON learning_sessions(learning_context);
CREATE INDEX idx_learning_sessions_date ON learning_sessions(started_at DESC);
CREATE INDEX idx_learning_sessions_duration ON learning_sessions(actual_duration_minutes);
CREATE INDEX idx_learning_sessions_efficiency ON learning_sessions(time_efficiency_score DESC);
CREATE INDEX idx_learning_sessions_device ON learning_sessions(device_used);

-- Efficiency metrics indexes
CREATE INDEX idx_efficiency_metrics_user ON efficiency_metrics(user_id);
CREATE INDEX idx_efficiency_metrics_date ON efficiency_metrics(measurement_date DESC);
CREATE INDEX idx_efficiency_metrics_context ON efficiency_metrics(primary_learning_context);
CREATE INDEX idx_efficiency_metrics_efficiency ON efficiency_metrics(daily_efficiency_score DESC);

-- Vector search indexes for professional content
CREATE INDEX idx_professional_content_embeddings_vector ON professional_content_embeddings 
    USING hnsw (content_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX idx_professional_content_embeddings_workplace_vector ON professional_content_embeddings 
    USING hnsw (workplace_context_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE workplace_context_vector IS NOT NULL;
CREATE INDEX idx_professional_content_embeddings_career_vector ON professional_content_embeddings 
    USING hnsw (career_relevance_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE career_relevance_vector IS NOT NULL;

-- Analytics and ROI indexes
CREATE INDEX idx_professional_learning_analytics_user ON professional_learning_analytics(user_id);
CREATE INDEX idx_professional_learning_analytics_date ON professional_learning_analytics(analysis_date DESC);
CREATE INDEX idx_professional_development_roi_user ON professional_development_roi(user_id);
CREATE INDEX idx_professional_development_roi_date ON professional_development_roi(measurement_date DESC);
CREATE INDEX idx_workplace_impact_metrics_user ON workplace_impact_metrics(user_id);
CREATE INDEX idx_workplace_impact_metrics_period ON workplace_impact_metrics(measurement_period_end DESC);

-- ================================================================
-- ROW LEVEL SECURITY FOR PROFESSIONAL DATA
-- ================================================================

-- Enable RLS on user-specific tables
ALTER TABLE professional_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE career_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE workplace_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_skill_development ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE efficiency_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_learning_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE professional_development_roi ENABLE ROW LEVEL SECURITY;
ALTER TABLE workplace_impact_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE workplace_projects ENABLE ROW LEVEL SECURITY;

-- User data isolation policies
CREATE POLICY professional_profile_isolation ON professional_profiles
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY career_milestone_isolation ON career_milestones
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY workplace_application_isolation ON workplace_applications
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY professional_progress_isolation ON professional_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY skill_development_isolation ON professional_skill_development
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY learning_session_isolation ON learning_sessions
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY efficiency_metrics_isolation ON efficiency_metrics
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY roi_data_isolation ON professional_development_roi
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Shared professional content access policies
CREATE POLICY professional_content_read_access ON professional_content
    FOR SELECT TO application_users
    USING (true);

CREATE POLICY workplace_scenarios_read_access ON workplace_scenarios
    FOR SELECT TO application_users
    USING (true);

CREATE POLICY professional_resources_read_access ON professional_resources
    FOR SELECT TO application_users
    USING (true);

-- Admin access policies for professional platform
CREATE POLICY admin_full_access_professional_profiles ON professional_profiles
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_full_access_professional_content ON professional_content
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_analytics_access ON professional_learning_analytics
    FOR SELECT TO admin_users
    USING (true);

-- ================================================================
-- SPECIALIZED FUNCTIONS FOR PROFESSIONAL OPTIMIZATION
-- ================================================================

-- Function to get personalized learning recommendations based on career goals and time constraints
CREATE OR REPLACE FUNCTION get_professional_learning_recommendations(
    p_user_id UUID,
    p_available_minutes INTEGER DEFAULT 15,
    p_career_focus career_objective DEFAULT 'skill_advancement',
    p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
    unit_id UUID,
    title VARCHAR,
    estimated_duration_minutes INTEGER,
    workplace_relevance_score INTEGER,
    career_advancement_value DECIMAL,
    efficiency_score DECIMAL
) AS $$
DECLARE
    user_profile RECORD;
    user_completed_units UUID[];
BEGIN
    -- Get user profile information
    SELECT primary_objectives, target_role, workplace_domains, weekly_available_hours, target_efficiency_rate
    INTO user_profile
    FROM professional_profiles 
    WHERE user_id = p_user_id;
    
    -- Get completed units
    SELECT array_agg(unit_id) INTO user_completed_units
    FROM professional_progress 
    WHERE user_id = p_user_id AND completion_percentage >= 80;
    
    RETURN QUERY
    WITH recommendation_scores AS (
        SELECT 
            plu.unit_id,
            plu.title,
            plu.estimated_duration_minutes,
            pt.workplace_relevance_score,
            
            -- Calculate career advancement value
            COALESCE(AVG(pscm.career_advancement_value), 5.0) as career_advancement_value,
            
            -- Calculate efficiency score based on duration fit and mobile optimization
            (CASE 
                WHEN plu.estimated_duration_minutes <= p_available_minutes THEN 10.0
                WHEN plu.estimated_duration_minutes <= p_available_minutes * 1.2 THEN 8.0
                ELSE 5.0
            END +
            CASE WHEN plu.mobile_friendly THEN 3.0 ELSE 0.0 END +
            CASE WHEN plu.offline_capable THEN 2.0 ELSE 0.0 END +
            CASE WHEN pt.workplace_relevance_score >= 8 THEN 3.0 ELSE 1.0 END) / 4.0 as efficiency_score
            
        FROM professional_learning_units plu
        JOIN professional_topics pt ON plu.topic_id = pt.topic_id
        JOIN professional_components pc ON pt.component_id = pc.component_id
        JOIN professional_modules pm ON pc.module_id = pm.module_id
        JOIN professional_curricula pcur ON pm.curriculum_id = pcur.curriculum_id
        LEFT JOIN professional_skill_content_mapping pscm ON plu.unit_id = pscm.content_id
        WHERE (user_completed_units IS NULL OR plu.unit_id != ALL(user_completed_units))
        AND plu.estimated_duration_minutes <= p_available_minutes * 1.5 -- Allow some flexibility
        AND (p_career_focus = ANY(pcur.target_career_objectives) OR user_profile.primary_objectives && pcur.target_career_objectives)
        GROUP BY plu.unit_id, plu.title, plu.estimated_duration_minutes, pt.workplace_relevance_score,
                 plu.mobile_friendly, plu.offline_capable
    )
    SELECT 
        rs.unit_id,
        rs.title,
        rs.estimated_duration_minutes,
        rs.workplace_relevance_score,
        rs.career_advancement_value,
        rs.efficiency_score
    FROM recommendation_scores rs
    ORDER BY rs.efficiency_score DESC, rs.career_advancement_value DESC, rs.workplace_relevance_score DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate professional learning efficiency metrics
CREATE OR REPLACE FUNCTION calculate_professional_efficiency(
    p_user_id UUID,
    p_period_days INTEGER DEFAULT 30
) RETURNS JSONB AS $$
DECLARE
    efficiency_data RECORD;
    session_data RECORD;
    progress_data RECORD;
    result JSONB;
BEGIN
    -- Get session efficiency data
    SELECT 
        COUNT(*) as total_sessions,
        AVG(actual_duration_minutes) as avg_duration,
        AVG(focus_quality) as avg_focus,
        AVG(time_efficiency_score) as avg_time_efficiency,
        AVG(satisfaction_rating) as avg_satisfaction
    INTO session_data
    FROM learning_sessions 
    WHERE user_id = p_user_id 
    AND started_at >= CURRENT_TIMESTAMP - INTERVAL '1 day' * p_period_days;
    
    -- Get progress efficiency data
    SELECT 
        COUNT(*) as units_in_progress,
        COUNT(CASE WHEN completion_percentage >= 80 THEN 1 END) as units_completed,
        AVG(efficiency_score) as avg_learning_efficiency,
        COUNT(CASE WHEN workplace_application_successful THEN 1 END) as workplace_applications,
        AVG(professional_readiness_score) as avg_readiness
    INTO progress_data
    FROM professional_progress 
    WHERE user_id = p_user_id;
    
    -- Get overall efficiency metrics
    SELECT 
        target_efficiency_rate,
        average_session_efficiency,
        learning_streak_days,
        consistency_score
    INTO efficiency_data
    FROM professional_profiles 
    WHERE user_id = p_user_id;
    
    -- Build comprehensive efficiency report
    result := jsonb_build_object(
        'period_days', p_period_days,
        'session_metrics', jsonb_build_object(
            'total_sessions', COALESCE(session_data.total_sessions, 0),
            'avg_session_duration', ROUND(COALESCE(session_data.avg_duration, 0), 1),
            'avg_focus_quality', ROUND(COALESCE(session_data.avg_focus, 0), 1),
            'avg_time_efficiency', ROUND(COALESCE(session_data.avg_time_efficiency, 0), 2),
            'avg_satisfaction', ROUND(COALESCE(session_data.avg_satisfaction, 0), 1)
        ),
        'learning_progress', jsonb_build_object(
            'units_in_progress', COALESCE(progress_data.units_in_progress, 0),
            'units_completed', COALESCE(progress_data.units_completed, 0),
            'completion_rate', 
                CASE WHEN COALESCE(progress_data.units_in_progress, 0) > 0 THEN
                    ROUND(COALESCE(progress_data.units_completed, 0)::DECIMAL / progress_data.units_in_progress, 2)
                ELSE 0 END,
            'avg_learning_efficiency', ROUND(COALESCE(progress_data.avg_learning_efficiency, 0), 2),
            'workplace_applications', COALESCE(progress_data.workplace_applications, 0),
            'avg_professional_readiness', ROUND(COALESCE(progress_data.avg_readiness, 0), 1)
        ),
        'efficiency_targets', jsonb_build_object(
            'target_efficiency_rate', COALESCE(efficiency_data.target_efficiency_rate, 0.85),
            'current_efficiency_rate', COALESCE(efficiency_data.average_session_efficiency, 0),
            'efficiency_gap', COALESCE(efficiency_data.target_efficiency_rate, 0.85) - COALESCE(efficiency_data.average_session_efficiency, 0),
            'learning_streak_days', COALESCE(efficiency_data.learning_streak_days, 0),
            'consistency_score', COALESCE(efficiency_data.consistency_score, 0)
        ),
        'recommendations', jsonb_build_array(
            CASE WHEN COALESCE(session_data.avg_focus, 0) < 7 THEN 
                'Consider reducing session interruptions to improve focus quality'
            END,
            CASE WHEN COALESCE(progress_data.workplace_applications, 0) = 0 THEN 
                'Try applying learned concepts in workplace scenarios'
            END,
            CASE WHEN COALESCE(efficiency_data.average_session_efficiency, 0) < COALESCE(efficiency_data.target_efficiency_rate, 0.85) THEN 
                'Focus on micro-learning sessions that fit your available time slots'
            END
        )
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to identify career advancement opportunities based on current skills and market trends
CREATE OR REPLACE FUNCTION identify_career_opportunities(
    p_user_id UUID,
    p_industry VARCHAR DEFAULT NULL,
    p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
    opportunity_type VARCHAR,
    opportunity_description TEXT,
    required_skills JSONB,
    skill_readiness_percentage DECIMAL,
    market_demand INTEGER,
    salary_impact_percentage DECIMAL
) AS $$
DECLARE
    user_profile RECORD;
    user_skills RECORD;
BEGIN
    -- Get user profile
    SELECT industry, years_of_experience, job_title, primary_objectives
    INTO user_profile
    FROM professional_profiles 
    WHERE user_id = p_user_id;
    
    -- Use provided industry or user's current industry
    IF p_industry IS NULL THEN
        p_industry := user_profile.industry;
    END IF;
    
    -- Identify opportunities based on high-demand skills user is developing
    RETURN QUERY
    SELECT 
        'skill_advancement'::VARCHAR as opportunity_type,
        'Advance in ' || ps.skill_name || ' for ' || ps.workplace_domain::text || ' roles' as opportunity_description,
        jsonb_build_array(jsonb_build_object(
            'skill_name', ps.skill_name,
            'current_proficiency', COALESCE(psd.proficiency_score, 1),
            'target_proficiency', 8
        )) as required_skills,
        COALESCE(psd.proficiency_score, 1) / 8.0 as skill_readiness_percentage,
        ps.job_market_demand,
        ps.salary_impact_percentage
    FROM professional_skills ps
    LEFT JOIN professional_skill_development psd ON ps.skill_id = psd.skill_id AND psd.user_id = p_user_id
    WHERE ps.job_market_demand >= 7 -- High market demand
    AND ps.career_impact_score >= 7 -- High career impact
    AND (psd.current_proficiency IS NULL OR psd.current_proficiency NOT IN ('expert', 'thought_leader'))
    ORDER BY ps.career_impact_score DESC, ps.job_market_demand DESC
    LIMIT p_limit;
    
    -- Also identify role transition opportunities
    RETURN QUERY
    SELECT 
        'role_transition'::VARCHAR as opportunity_type,
        'Transition to roles requiring ' || ps.workplace_domain::text || ' expertise' as opportunity_description,
        jsonb_agg(jsonb_build_object(
            'skill_name', ps.skill_name,
            'importance', ps.career_impact_score
        )) as required_skills,
        AVG(COALESCE(psd.proficiency_score, 1)) / 8.0 as skill_readiness_percentage,
        CAST(AVG(ps.job_market_demand) AS INTEGER) as market_demand,
        AVG(ps.salary_impact_percentage) as salary_impact_percentage
    FROM professional_skills ps
    LEFT JOIN professional_skill_development psd ON ps.skill_id = psd.skill_id AND psd.user_id = p_user_id
    WHERE ps.career_impact_score >= 6
    GROUP BY ps.workplace_domain
    HAVING COUNT(*) >= 2 -- Need multiple skills for role transition
    ORDER BY AVG(ps.salary_impact_percentage) DESC
    LIMIT p_limit / 2; -- Half the results for role transitions
END;
$$ LANGUAGE plpgsql;

-- Function to optimize learning schedule based on professional constraints
CREATE OR REPLACE FUNCTION optimize_learning_schedule(
    p_user_id UUID,
    p_week_start_date DATE DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
    user_profile RECORD;
    schedule_result JSONB := '[]';
    daily_recommendations JSONB;
    day_counter INTEGER := 0;
    current_date DATE;
BEGIN
    -- Get user constraints and preferences
    SELECT 
        weekly_available_hours,
        preferred_session_duration,
        preferred_learning_contexts,
        optimal_notification_times
    INTO user_profile
    FROM professional_profiles 
    WHERE user_id = p_user_id;
    
    -- Use provided week start or current week
    IF p_week_start_date IS NULL THEN
        current_date := DATE_TRUNC('week', CURRENT_DATE);
    ELSE
        current_date := p_week_start_date;
    END IF;
    
    -- Generate optimized schedule for each day
    FOR day_counter IN 0..6 LOOP
        -- Calculate optimal sessions per day
        WITH daily_optimization AS (
            SELECT
                current_date + day_counter as schedule_date,
                CASE 
                    WHEN day_counter IN (0, 6) THEN -- Weekend
                        LEAST(3, FLOOR(user_profile.weekly_available_hours * 60 / 7 / user_profile.preferred_session_duration))
                    ELSE -- Weekday
                        LEAST(2, FLOOR(user_profile.weekly_available_hours * 60 / 7 / user_profile.preferred_session_duration))
                END as recommended_sessions,
                CASE 
                    WHEN day_counter IN (0, 6) THEN 'weekend_focus'
                    ELSE 'commute'
                END as primary_context
        )
        SELECT 
            jsonb_build_object(
                'date', do.schedule_date,
                'recommended_sessions', do.recommended_sessions,
                'session_duration_minutes', user_profile.preferred_session_duration,
                'primary_context', do.primary_context,
                'optimal_times', user_profile.optimal_notification_times,
                'total_learning_minutes', do.recommended_sessions * user_profile.preferred_session_duration
            )
        INTO daily_recommendations
        FROM daily_optimization do;
        
        -- Add to schedule result
        schedule_result := schedule_result || daily_recommendations;
    END LOOP;
    
    -- Return comprehensive schedule with weekly summary
    RETURN jsonb_build_object(
        'week_start_date', current_date,
        'user_constraints', jsonb_build_object(
            'weekly_available_hours', user_profile.weekly_available_hours,
            'preferred_session_duration', user_profile.preferred_session_duration,
            'preferred_contexts', user_profile.preferred_learning_contexts
        ),
        'daily_schedule', schedule_result,
        'weekly_summary', jsonb_build_object(
            'total_planned_sessions', (
                SELECT SUM((daily_rec->>'recommended_sessions')::INTEGER) 
                FROM jsonb_array_elements(schedule_result) daily_rec
            ),
            'total_planned_minutes', (
                SELECT SUM((daily_rec->>'total_learning_minutes')::INTEGER) 
                FROM jsonb_array_elements(schedule_result) daily_rec
            ),
            'efficiency_target', 0.85,
            'expected_units_completed', FLOOR((
                SELECT SUM((daily_rec->>'total_learning_minutes')::INTEGER) 
                FROM jsonb_array_elements(schedule_result) daily_rec
            ) / (user_profile.preferred_session_duration * 1.2)) -- Account for overhead
        )
    );
END;
$$ LANGUAGE plpgsql;

-- Function to refresh all professional analytics materialized views
CREATE OR REPLACE FUNCTION refresh_professional_analytics_views()
RETURNS JSONB AS $$
DECLARE
    start_time TIMESTAMPTZ;
    result JSONB := '{}';
BEGIN
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh professional user analytics
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_professional_user_analytics;
    result := result || jsonb_build_object('user_analytics_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh professional skill analysis
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_professional_skill_analysis;
    result := result || jsonb_build_object('skill_analysis_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh professional content effectiveness
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_professional_content_effectiveness;
    result := result || jsonb_build_object('content_effectiveness_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    result := result || jsonb_build_object('total_refresh_completed_at', CURRENT_TIMESTAMP);
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- TRIGGERS FOR PROFESSIONAL AUTOMATION
-- ================================================================

-- Trigger function to update professional efficiency metrics
CREATE OR REPLACE FUNCTION update_professional_efficiency_metrics()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    
    -- Update learning streak and consistency
    IF TG_TABLE_NAME = 'learning_sessions' AND NEW.ended_at IS NOT NULL THEN
        UPDATE professional_profiles 
        SET 
            learning_streak_days = CASE 
                WHEN last_login::date = CURRENT_DATE THEN learning_streak_days
                WHEN last_login::date = CURRENT_DATE - 1 THEN learning_streak_days + 1
                ELSE 1
            END,
            last_login = NEW.ended_at,
            total_learning_hours = total_learning_hours + (NEW.actual_duration_minutes / 60.0),
            micro_sessions_completed = micro_sessions_completed + 1
        WHERE user_id = NEW.user_id;
    END IF;
    
    -- Update workplace application counts
    IF TG_TABLE_NAME = 'workplace_applications' THEN
        UPDATE professional_profiles 
        SET 
            skills_applied_at_work = (
                SELECT COUNT(DISTINCT skill_id)
                FROM unnest(array(
                    SELECT unnest(skills_used) FROM workplace_applications WHERE user_id = NEW.user_id
                )) as skill_id
            ),
            workplace_projects_improved = (
                SELECT COUNT(*) FROM workplace_applications WHERE user_id = NEW.user_id
            )
        WHERE user_id = NEW.user_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply professional efficiency triggers
CREATE TRIGGER tr_update_learning_session_metrics
    AFTER INSERT OR UPDATE ON learning_sessions
    FOR EACH ROW EXECUTE FUNCTION update_professional_efficiency_metrics();

CREATE TRIGGER tr_update_workplace_application_metrics
    AFTER INSERT OR UPDATE ON workplace_applications
    FOR EACH ROW EXECUTE FUNCTION update_professional_efficiency_metrics();

CREATE TRIGGER tr_update_professional_profile_metrics
    BEFORE UPDATE ON professional_profiles
    FOR EACH ROW EXECUTE FUNCTION update_professional_efficiency_metrics();

-- Trigger to update skill proficiency based on usage and applications
CREATE OR REPLACE FUNCTION update_skill_proficiency()
RETURNS TRIGGER AS $$
DECLARE
    skill_usage_count INTEGER;
    workplace_app_count INTEGER;
BEGIN
    -- Calculate skill usage frequency
    SELECT COUNT(*) INTO skill_usage_count
    FROM professional_progress pp
    JOIN professional_skill_content_mapping pscm ON pp.unit_id = pscm.content_id
    WHERE pp.user_id = NEW.user_id 
    AND pscm.skill_id = NEW.skill_id
    AND pp.completion_percentage >= 80;
    
    -- Calculate workplace application frequency
    SELECT COUNT(*) INTO workplace_app_count
    FROM workplace_applications
    WHERE user_id = NEW.user_id
    AND NEW.skill_id = ANY(skills_used);
    
    -- Update proficiency based on learning and application
    NEW.proficiency_score = LEAST(10, 
        1 + -- Base score
        (skill_usage_count * 0.5) + -- Learning contribution
        (workplace_app_count * 2.0) + -- Application contribution
        (NEW.total_learning_hours / 10.0) -- Time investment
    );
    
    -- Update proficiency level based on score
    NEW.current_proficiency = CASE 
        WHEN NEW.proficiency_score >= 9 THEN 'expert'
        WHEN NEW.proficiency_score >= 7 THEN 'proficient'
        WHEN NEW.proficiency_score >= 5 THEN 'intermediate'
        WHEN NEW.proficiency_score >= 3 THEN 'novice'
        ELSE 'awareness'
    END;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_skill_proficiency
    BEFORE UPDATE ON professional_skill_development
    FOR EACH ROW EXECUTE FUNCTION update_skill_proficiency();

-- ================================================================
-- INITIAL SYSTEM DATA FOR PROFESSIONAL PLATFORM
-- ================================================================

-- Insert default professional embedding model
INSERT INTO professional_embedding_models (
    model_name, provider, embedding_dimensions, context_window,
    workplace_domain_optimized, career_level_optimized, micro_learning_optimized,
    mobile_processing_capable, processing_speed_ms, offline_capability,
    is_active, is_primary
) VALUES (
    'professional-micro-learning-v1', 'sentence-transformers', 384, 512,
    ARRAY['data_analysis', 'process_automation', 'business_intelligence']::workplace_domain[],
    ARRAY['entry', 'mid', 'senior'], true,
    true, 250, false, true, true
);

-- Insert professional AI avatars optimized for time-constrained professionals
INSERT INTO professional_ai_avatars (
    avatar_name, display_name, description, primary_role, specialization_areas,
    years_of_simulated_experience, career_level_expertise, management_experience,
    can_provide_career_advice, can_review_code_professionally, can_suggest_productivity_improvements,
    can_provide_time_management_tips, optimized_for_short_sessions, mobile_interaction_friendly,
    communication_efficiency, professional_formality
) VALUES 
('efficiency_coach', 'Alex - Learning Efficiency Coach',
 'Specializes in maximizing learning outcomes for time-constrained professionals',
 'efficiency_coach', 
 ARRAY['process_automation', 'business_intelligence']::workplace_domain[],
 8, 'all_levels', false,
 true, false, true, true, true, true, 9, 7),

('career_advisor', 'Morgan - Career Advancement Advisor',
 'Focuses on strategic skill development for career advancement',
 'career_advisor',
 ARRAY['data_analysis', 'project_management']::workplace_domain[],
 12, 'senior', true,
 true, false, false, true, true, true, 8, 8),

('productivity_expert', 'Jordan - Workplace Productivity Expert',
 'Helps professionals apply learning to immediate workplace improvements',
 'productivity_expert',
 ARRAY['process_automation', 'system_integration']::workplace_domain[],
 10, 'mid', false,
 false, true, true, true, true, true, 10, 6);

-- Insert sample high-impact professional skills
INSERT INTO professional_skills (
    skill_code, skill_name, description, workplace_domain, skill_category,
    career_impact_score, job_market_demand, salary_impact_percentage, industry_growth_trend,
    automation_potential, typical_learning_time_hours, micro_learning_friendly, mobile_practice_suitable
) VALUES 
('python_automation', 'Python Process Automation', 'Automating repetitive business tasks with Python', 
 'process_automation', 'technical', 9, 8, 15.5, 'growing',
 10, 25, true, true),

('data_analysis_pandas', 'Data Analysis with Pandas', 'Professional data analysis and reporting',
 'data_analysis', 'analytical', 8, 9, 12.8, 'growing',
 7, 30, true, true),

('business_intelligence', 'Business Intelligence Dashboards', 'Creating executive dashboards and reports',
 'business_intelligence', 'analytical', 8, 7, 18.2, 'stable',
 6, 35, false, false),

('api_integration', 'API Integration & Development', 'Connecting systems and building APIs',
 'system_integration', 'technical', 7, 8, 14.7, 'growing',
 8, 28, true, true),

('workplace_optimization', 'Workplace Process Optimization', 'Improving team productivity and efficiency',
 'project_management', 'analytical', 9, 6, 22.3, 'stable',
 5, 20, true, true);

-- Insert sample professional curriculum for time-constrained professionals
INSERT INTO professional_curricula (
    curriculum_code, title, description, target_career_objectives, target_job_roles,
    workplace_domains, total_duration_weeks, sessions_per_week, average_session_minutes,
    target_efficiency_rate, expected_productivity_increase, mobile_first_design
) VALUES 
('time-constrained-python-2024', 'Python for Time-Constrained Professionals', 
 'Accelerated Python curriculum designed for busy professionals seeking rapid skill advancement',
 ARRAY['skill_advancement', 'productivity_enhancement']::career_objective[],
 ARRAY['Business Analyst', 'Project Manager', 'Operations Manager', 'Consultant'],
 ARRAY['data_analysis', 'process_automation', 'business_intelligence']::workplace_domain[],
 14, 5, 15, 0.85, 25.5, true);

-- Final deployment notification
DO $$
BEGIN
    RAISE NOTICE '=== TIME-CONSTRAINED PROFESSIONAL EDUCATION PLATFORM DEPLOYED ===';
    RAISE NOTICE 'Total Tables: 31 core tables + 3 materialized views';
    RAISE NOTICE 'Total Estimated Fields: ~520 fields across all tables';
    RAISE NOTICE 'Micro-Learning Focus: 15-minute session optimization';
    RAISE NOTICE 'Mobile-First Design: Offline capability and responsive content';
    RAISE NOTICE 'Professional Integration: Workplace application tracking';
    RAISE NOTICE 'Efficiency Tracking: 85% learning efficiency target';
    RAISE NOTICE 'Career Advancement: ROI and professional development metrics';
    RAISE NOTICE 'Vector Search: Professional context-aware semantic search';
    RAISE NOTICE 'Row-Level Security: Complete professional data protection';
    RAISE NOTICE 'AI Avatars: 3 professional development specialists';
    RAISE NOTICE 'Analytics Views: 3 materialized views for performance tracking';
    RAISE NOTICE 'Specialized Functions: 4 professional optimization functions';
    RAISE NOTICE 'Time Optimization: Smart scheduling and efficiency recommendations';
    RAISE NOTICE '=== READY FOR PROFESSIONAL MICRO-LEARNING SUCCESS ===';
END $$;

-- Refresh materialized views for initial state
SELECT refresh_professional_analytics_views();

COMMIT;