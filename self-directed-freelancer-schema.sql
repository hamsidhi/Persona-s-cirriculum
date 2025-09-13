-- ================================================================
-- SELF-DIRECTED FREELANCER AI EDUCATION PLATFORM SCHEMA
-- Production-Ready PostgreSQL Database for Business-Focused Learning
-- Optimized for Revenue Generation and Client Project Application
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

-- Set timezone for consistent timestamps
SET timezone = 'UTC';

-- ================================================================
-- ENHANCED ENUMS & TYPES FOR FREELANCER-FOCUSED LEARNING
-- ================================================================

-- Freelancer-specific learning objectives
CREATE TYPE freelancer_goal AS ENUM (
    'skill_acquisition', 'client_acquisition', 'revenue_increase', 
    'business_development', 'portfolio_building', 'niche_specialization'
);

-- Business application categories
CREATE TYPE business_domain AS ENUM (
    'web_development', 'data_analysis', 'automation', 'api_development',
    'machine_learning', 'financial_modeling', 'report_generation',
    'system_integration', 'performance_optimization', 'security'
);

-- Client project types
CREATE TYPE project_type AS ENUM (
    'proof_of_concept', 'mvp_development', 'system_integration',
    'data_migration', 'performance_optimization', 'maintenance',
    'consulting', 'training', 'custom_solution'
);

-- Revenue impact levels
CREATE TYPE revenue_impact AS ENUM (
    'no_impact', 'indirect_benefit', 'direct_application', 
    'immediate_revenue', 'recurring_revenue', 'portfolio_enhancement'
);

-- Content formats with business focus
CREATE TYPE content_format AS ENUM (
    'markdown', 'html', 'jupyter_notebook', 'video', 'audio', 'interactive',
    'code_snippet', 'case_study', 'client_template', 'business_tool',
    'proposal_template', 'contract_template', 'pricing_guide'
);

-- Learning delivery modes for self-directed learners
CREATE TYPE delivery_mode AS ENUM (
    'self_paced', 'milestone_based', 'project_driven', 'case_study',
    'live_coding', 'peer_collaboration', 'mentor_guided'
);

-- Skill monetization status
CREATE TYPE monetization_status AS ENUM (
    'learning', 'practicing', 'portfolio_ready', 'client_ready',
    'generating_revenue', 'expertise_level'
);

-- Assessment types with business validation
CREATE TYPE assessment_type AS ENUM (
    'multiple_choice', 'short_answer', 'coding_challenge', 'project_submission',
    'case_study_analysis', 'client_simulation', 'portfolio_review',
    'business_plan', 'roi_calculation', 'peer_review'
);

-- AI Avatar roles for freelancer guidance
CREATE TYPE avatar_role AS ENUM (
    'business_mentor', 'technical_coach', 'client_advisor', 'pricing_consultant',
    'portfolio_reviewer', 'skill_assessor', 'project_manager', 'industry_expert'
);

-- Progress tracking states
CREATE TYPE progress_status AS ENUM (
    'not_started', 'in_progress', 'skill_acquired', 'portfolio_ready',
    'client_applied', 'revenue_generated', 'mastered'
);

-- Client interaction types
CREATE TYPE client_interaction AS ENUM (
    'discovery_call', 'requirement_gathering', 'proposal_presentation',
    'project_kickoff', 'progress_update', 'delivery_review',
    'feedback_session', 'contract_negotiation'
);

-- ================================================================
-- 1. FREELANCER PERSONA & BUSINESS MANAGEMENT
-- ================================================================

-- Freelancer-specific user profiles with business focus
CREATE TABLE freelancer_profiles (
    profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE, -- Links to external user system
    
    -- Personal and professional information
    full_name VARCHAR(200) NOT NULL,
    professional_title VARCHAR(150),
    years_of_experience INTEGER DEFAULT 0,
    current_hourly_rate DECIMAL(8,2),
    target_hourly_rate DECIMAL(8,2),
    
    -- Business objectives
    primary_goals freelancer_goal[] NOT NULL,
    target_specializations business_domain[] NOT NULL,
    revenue_targets JSONB, -- Monthly/yearly revenue goals
    
    -- Learning preferences
    preferred_session_duration INTEGER DEFAULT 90, -- minutes
    weekly_learning_hours INTEGER DEFAULT 12,
    learning_intensity VARCHAR(20) DEFAULT 'self_paced', -- 'intensive', 'moderate', 'self_paced'
    
    -- Business setup
    business_structure VARCHAR(50), -- 'sole_proprietor', 'llc', 'corporation'
    tax_jurisdiction VARCHAR(100),
    business_registration_date DATE,
    
    -- Current status
    active_clients INTEGER DEFAULT 0,
    monthly_revenue DECIMAL(10,2) DEFAULT 0,
    portfolio_projects INTEGER DEFAULT 0,
    skills_monetized INTEGER DEFAULT 0,
    
    -- Platform engagement
    last_login TIMESTAMPTZ,
    learning_streak_days INTEGER DEFAULT 0,
    projects_completed INTEGER DEFAULT 0,
    revenue_attributed_to_platform DECIMAL(10,2) DEFAULT 0,
    
    -- Professional services
    services_offered JSONB, -- Array of services with descriptions and rates
    client_testimonials JSONB, -- Client feedback and testimonials
    certifications JSONB, -- Professional certifications and dates
    
    -- Communication preferences
    timezone VARCHAR(50) DEFAULT 'UTC',
    preferred_contact_method VARCHAR(20) DEFAULT 'email',
    availability_schedule JSONB, -- Weekly availability schedule
    
    -- Audit fields
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_rates CHECK (
        (current_hourly_rate IS NULL OR current_hourly_rate >= 0) AND
        (target_hourly_rate IS NULL OR target_hourly_rate >= 0)
    ),
    CONSTRAINT chk_experience_range CHECK (years_of_experience >= 0 AND years_of_experience <= 50)
);

-- Business skill taxonomy with monetization potential
CREATE TABLE freelancer_skills (
    skill_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    skill_code VARCHAR(50) NOT NULL UNIQUE,
    skill_name VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Business categorization
    business_domain business_domain NOT NULL,
    skill_category VARCHAR(100), -- 'core_technical', 'business_development', 'client_management'
    market_demand INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Monetization information
    average_hourly_rate DECIMAL(8,2),
    rate_range_min DECIMAL(8,2),
    rate_range_max DECIMAL(8,2),
    market_saturation VARCHAR(20) DEFAULT 'moderate', -- 'low', 'moderate', 'high', 'oversaturated'
    
    -- Skill requirements
    learning_time_hours INTEGER, -- Average time to acquire skill
    prerequisite_skills UUID[], -- Array of skill IDs
    complementary_skills UUID[], -- Skills that work well together
    
    -- Market analysis
    job_posting_frequency INTEGER DEFAULT 0, -- Weekly job postings requiring this skill
    freelance_demand_score INTEGER DEFAULT 5, -- 1-10 scale
    enterprise_demand_score INTEGER DEFAULT 5, -- 1-10 scale
    startup_demand_score INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Trend information
    growth_trend VARCHAR(20) DEFAULT 'stable', -- 'declining', 'stable', 'growing', 'exploding'
    trend_confidence INTEGER DEFAULT 5, -- 1-10 confidence in trend assessment
    last_market_analysis DATE,
    
    -- Skill development path
    beginner_resources JSONB,
    intermediate_resources JSONB,
    advanced_resources JSONB,
    certification_paths JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_rates_logical CHECK (
        rate_range_min IS NULL OR rate_range_max IS NULL OR rate_range_min <= rate_range_max
    ),
    CONSTRAINT chk_score_ranges CHECK (
        market_demand BETWEEN 1 AND 10 AND
        freelance_demand_score BETWEEN 1 AND 10 AND
        enterprise_demand_score BETWEEN 1 AND 10 AND
        startup_demand_score BETWEEN 1 AND 10
    )
);

-- Client project types and templates
CREATE TABLE project_templates (
    template_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_name VARCHAR(200) NOT NULL,
    project_type project_type NOT NULL,
    business_domain business_domain NOT NULL,
    
    -- Project characteristics
    typical_duration_weeks INTEGER NOT NULL,
    complexity_level INTEGER DEFAULT 5, -- 1-10 scale
    typical_budget_range JSONB, -- Min/max budget expectations
    
    -- Requirements template
    requirements_template JSONB NOT NULL,
    deliverables_template JSONB NOT NULL,
    milestones_template JSONB,
    
    -- Skills required
    required_skills UUID[] NOT NULL, -- Array of skill IDs
    optional_skills UUID[],
    skill_level_required INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Business aspects
    client_communication_plan JSONB,
    pricing_guidelines JSONB,
    contract_templates JSONB,
    risk_factors JSONB,
    
    -- Success metrics
    success_criteria JSONB,
    quality_checklist JSONB,
    client_satisfaction_factors JSONB,
    
    -- Template usage
    usage_count INTEGER DEFAULT 0,
    success_rate DECIMAL(5,4), -- Percentage of successful projects using this template
    average_client_satisfaction DECIMAL(3,2), -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_duration_positive CHECK (typical_duration_weeks > 0),
    CONSTRAINT chk_complexity_range CHECK (complexity_level BETWEEN 1 AND 10)
);

-- ================================================================
-- 2. BUSINESS-FOCUSED CURRICULUM STRUCTURE
-- ================================================================

-- Business-oriented curriculum with ROI focus
CREATE TABLE business_curricula (
    curriculum_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    curriculum_code VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    
    -- Business positioning
    target_business_domains business_domain[] NOT NULL,
    revenue_potential INTEGER DEFAULT 5, -- 1-10 scale
    market_demand INTEGER DEFAULT 5, -- 1-10 scale
    skill_acquisition_speed DECIMAL(3,1), -- Skills per month target
    
    -- Learning characteristics
    total_duration_weeks INTEGER DEFAULT 16,
    intensity_level VARCHAR(20) DEFAULT 'moderate',
    prerequisite_revenue_level DECIMAL(10,2) DEFAULT 0,
    
    -- Business outcomes
    expected_hourly_rate_increase DECIMAL(8,2),
    expected_client_acquisition INTEGER, -- Number of new clients expected
    portfolio_projects_generated INTEGER,
    roi_timeline_months INTEGER, -- Expected time to ROI
    
    -- Success metrics
    completion_rate DECIMAL(5,4), -- Historical completion rate
    revenue_impact_average DECIMAL(10,2), -- Average revenue increase
    client_satisfaction_score DECIMAL(3,2), -- 1-10 scale
    
    -- Curriculum metadata
    version VARCHAR(20) DEFAULT '1.0',
    status VARCHAR(20) DEFAULT 'active',
    last_market_validation DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_positive_duration CHECK (total_duration_weeks > 0),
    CONSTRAINT chk_score_ranges CHECK (
        revenue_potential BETWEEN 1 AND 10 AND
        market_demand BETWEEN 1 AND 10
    )
);

-- Business modules with client application focus
CREATE TABLE business_modules (
    module_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    curriculum_id UUID NOT NULL REFERENCES business_curricula(curriculum_id) ON DELETE CASCADE,
    module_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    
    -- Module structure
    module_number INTEGER NOT NULL,
    duration_weeks INTEGER NOT NULL,
    estimated_hours INTEGER NOT NULL,
    
    -- Business focus
    business_applications JSONB NOT NULL, -- Real-world applications
    client_deliverables JSONB, -- What clients get from this module
    revenue_impact revenue_impact DEFAULT 'indirect_benefit',
    
    -- Learning objectives with business context
    technical_objectives JSONB NOT NULL,
    business_objectives JSONB NOT NULL,
    client_communication_skills JSONB,
    
    -- Prerequisites and dependencies
    prerequisite_modules UUID[],
    prerequisite_revenue_level DECIMAL(10,2),
    prerequisite_client_experience INTEGER DEFAULT 0,
    
    -- Project components
    case_studies JSONB, -- Real client case studies
    project_templates UUID[], -- References to project_templates
    client_simulation_scenarios JSONB,
    
    -- Success measurement
    skill_acquisition_metrics JSONB,
    business_impact_kpis JSONB,
    client_readiness_criteria JSONB,
    
    order_index INTEGER DEFAULT 100,
    is_core_module BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(curriculum_id, module_code),
    CONSTRAINT chk_positive_hours CHECK (estimated_hours > 0)
);

-- Business components with practical application
CREATE TABLE business_components (
    component_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL REFERENCES business_modules(module_id) ON DELETE CASCADE,
    component_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Component structure
    component_number DECIMAL(3,1) NOT NULL,
    estimated_duration_minutes INTEGER NOT NULL,
    
    -- Business application focus
    client_application TEXT NOT NULL, -- How this applies to client work
    revenue_opportunity TEXT, -- How this can generate revenue
    portfolio_value INTEGER DEFAULT 5, -- 1-10 portfolio enhancement value
    
    -- Learning design
    practical_activities JSONB NOT NULL,
    business_scenarios JSONB,
    client_interaction_practice JSONB,
    
    -- Tools and resources
    required_tools JSONB,
    business_templates JSONB, -- Proposals, contracts, etc.
    industry_resources JSONB,
    
    -- Delivery methods
    primary_delivery_mode delivery_mode DEFAULT 'self_paced',
    interaction_types client_interaction[],
    
    order_index INTEGER DEFAULT 100,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(module_id, component_code),
    CONSTRAINT chk_component_duration CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_portfolio_value CHECK (portfolio_value BETWEEN 1 AND 10)
);

-- Business topics with market relevance
CREATE TABLE business_topics (
    topic_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    component_id UUID NOT NULL REFERENCES business_components(component_id) ON DELETE CASCADE,
    topic_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Topic characteristics
    estimated_duration_minutes INTEGER NOT NULL,
    difficulty_level INTEGER DEFAULT 5, -- 1-10 scale
    market_relevance INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Business learning objectives
    technical_skills JSONB NOT NULL,
    business_skills JSONB NOT NULL,
    client_communication_aspects JSONB,
    
    -- Market context
    industry_applications JSONB,
    client_pain_points JSONB, -- What client problems this solves
    competitive_advantages JSONB, -- How this differentiates freelancer
    
    -- Practical application
    hands_on_exercises JSONB,
    real_world_examples JSONB,
    common_pitfalls JSONB,
    best_practices JSONB,
    
    -- Monetization aspects
    pricing_guidance JSONB,
    service_packaging_ideas JSONB,
    upselling_opportunities JSONB,
    
    order_index INTEGER DEFAULT 100,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(component_id, topic_code),
    CONSTRAINT chk_topic_duration CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_rating_ranges CHECK (
        difficulty_level BETWEEN 1 AND 10 AND
        market_relevance BETWEEN 1 AND 10
    )
);

-- Learning units with immediate business application
CREATE TABLE business_learning_units (
    unit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id UUID NOT NULL REFERENCES business_topics(topic_id) ON DELETE CASCADE,
    unit_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Unit characteristics
    estimated_duration_minutes INTEGER DEFAULT 15,
    complexity_score INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Business learning focus
    learning_objective TEXT NOT NULL,
    business_application TEXT NOT NULL,
    client_value_proposition TEXT,
    
    -- Skill development
    skill_being_developed UUID REFERENCES freelancer_skills(skill_id),
    proficiency_level_target INTEGER DEFAULT 5, -- 1-10 scale
    monetization_readiness monetization_status DEFAULT 'learning',
    
    -- Content structure
    theory_content_id UUID, -- References business_content table
    practical_exercise_id UUID,
    case_study_id UUID,
    assessment_id UUID,
    
    -- Prerequisites and flow
    prerequisite_units UUID[],
    prerequisite_skills UUID[],
    follow_up_opportunities JSONB,
    
    order_index INTEGER DEFAULT 100,
    is_optional BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(topic_id, unit_code),
    CONSTRAINT chk_unit_duration CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_complexity_range CHECK (complexity_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 3. BUSINESS-FOCUSED CONTENT MANAGEMENT
-- ================================================================

-- Business content with revenue focus
CREATE TABLE business_content (
    content_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES business_learning_units(unit_id) ON DELETE SET NULL,
    
    -- Content identification
    external_id VARCHAR(100) UNIQUE,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    content_type VARCHAR(50) NOT NULL,
    format content_format NOT NULL,
    
    -- Content storage
    content_markdown TEXT,
    content_html TEXT,
    content_json JSONB,
    media_urls JSONB,
    interactive_elements JSONB,
    
    -- Business context
    business_applications JSONB NOT NULL,
    client_use_cases JSONB,
    revenue_potential INTEGER DEFAULT 5, -- 1-10 scale
    market_demand INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Learning design
    learning_objectives JSONB NOT NULL,
    prerequisite_knowledge JSONB,
    estimated_duration_minutes INTEGER NOT NULL,
    
    -- Business tools and templates
    business_templates JSONB, -- Contracts, proposals, etc.
    pricing_guidelines JSONB,
    client_communication_scripts JSONB,
    industry_resources JSONB,
    
    -- Quality and effectiveness
    content_quality_score DECIMAL(3,2) DEFAULT 0,
    business_relevance_score DECIMAL(3,2) DEFAULT 5,
    client_applicability_score DECIMAL(3,2) DEFAULT 5,
    
    -- Usage analytics
    view_count INTEGER DEFAULT 0,
    completion_rate DECIMAL(5,4),
    user_rating DECIMAL(3,2),
    revenue_attribution DECIMAL(10,2) DEFAULT 0, -- Revenue attributed to this content
    
    -- Search and discovery
    keywords TEXT[] NOT NULL,
    business_tags VARCHAR(50)[] NOT NULL,
    skill_tags UUID[], -- References to freelancer_skills
    
    -- Maintenance
    last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    content_hash VARCHAR(64),
    needs_review BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_duration_positive CHECK (estimated_duration_minutes > 0),
    CONSTRAINT chk_score_ranges CHECK (
        revenue_potential BETWEEN 1 AND 10 AND
        market_demand BETWEEN 1 AND 10
    )
);

-- Case studies with real client scenarios
CREATE TABLE client_case_studies (
    case_study_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES business_content(content_id) ON DELETE CASCADE,
    
    -- Case study details
    title VARCHAR(200) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    client_size VARCHAR(50), -- 'startup', 'small_business', 'enterprise'
    project_type project_type NOT NULL,
    
    -- Problem and solution
    client_problem TEXT NOT NULL,
    technical_challenges JSONB,
    business_constraints JSONB,
    solution_overview TEXT NOT NULL,
    
    -- Implementation details
    technologies_used JSONB NOT NULL,
    timeline_weeks INTEGER,
    team_size INTEGER DEFAULT 1,
    development_phases JSONB,
    
    -- Business aspects
    project_budget DECIMAL(10,2),
    final_cost DECIMAL(10,2),
    hourly_rate DECIMAL(8,2),
    profitability_analysis JSONB,
    
    -- Outcomes and results
    technical_outcomes JSONB,
    business_outcomes JSONB,
    client_satisfaction_score INTEGER, -- 1-10 scale
    follow_up_projects JSONB,
    
    -- Learning value
    key_learnings JSONB,
    mistakes_to_avoid JSONB,
    best_practices JSONB,
    skills_demonstrated UUID[], -- Array of skill IDs
    
    -- Validation and authenticity
    client_testimonial TEXT,
    project_evidence JSONB, -- Screenshots, metrics, etc.
    is_verified BOOLEAN DEFAULT false,
    anonymization_level VARCHAR(20) DEFAULT 'partial', -- 'none', 'partial', 'full'
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_timeline CHECK (timeline_weeks IS NULL OR timeline_weeks > 0),
    CONSTRAINT chk_satisfaction_range CHECK (
        client_satisfaction_score IS NULL OR 
        client_satisfaction_score BETWEEN 1 AND 10
    )
);

-- Business templates and tools
CREATE TABLE business_templates (
    template_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES business_content(content_id) ON DELETE CASCADE,
    
    -- Template identification
    template_name VARCHAR(200) NOT NULL,
    template_category VARCHAR(100) NOT NULL, -- 'proposal', 'contract', 'statement_of_work', etc.
    business_domain business_domain,
    
    -- Template content
    template_content TEXT NOT NULL,
    template_format VARCHAR(50) DEFAULT 'markdown', -- 'markdown', 'docx', 'pdf', 'html'
    
    -- Customization instructions
    customization_guide TEXT,
    required_variables JSONB, -- Variables that must be filled
    optional_variables JSONB,
    
    -- Usage guidelines
    usage_instructions TEXT,
    legal_considerations TEXT,
    best_practices JSONB,
    common_modifications JSONB,
    
    -- Effectiveness metrics
    usage_count INTEGER DEFAULT 0,
    success_rate DECIMAL(5,4), -- Percentage of successful uses
    user_rating DECIMAL(3,2),
    
    -- Business impact
    average_project_value DECIMAL(10,2), -- Average value of projects using this template
    conversion_rate DECIMAL(5,4), -- Proposal to contract conversion rate
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_template_content_not_empty CHECK (LENGTH(template_content) > 0)
);

-- ================================================================
-- 4. AI AVATAR SYSTEM FOR BUSINESS GUIDANCE
-- ================================================================

-- Business-focused AI avatars
CREATE TABLE business_ai_avatars (
    avatar_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    avatar_name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    
    -- Avatar specialization
    primary_role avatar_role NOT NULL,
    specialization_areas business_domain[] NOT NULL,
    expertise_level INTEGER DEFAULT 7, -- 1-10 scale
    
    -- Personality and approach
    personality_traits JSONB NOT NULL,
    communication_style JSONB NOT NULL,
    coaching_approach VARCHAR(50), -- 'supportive', 'challenging', 'analytical', 'practical'
    
    -- Business expertise
    years_of_industry_experience INTEGER DEFAULT 10,
    client_types_worked_with JSONB, -- Types of clients avatar has "experience" with
    successful_projects_portfolio JSONB,
    
    -- Avatar capabilities
    can_review_proposals BOOLEAN DEFAULT false,
    can_analyze_pricing BOOLEAN DEFAULT false,
    can_provide_market_insights BOOLEAN DEFAULT false,
    can_simulate_client_calls BOOLEAN DEFAULT false,
    can_review_portfolios BOOLEAN DEFAULT false,
    
    -- Interaction parameters
    response_style VARCHAR(50) DEFAULT 'professional', -- 'casual', 'professional', 'technical'
    detail_level VARCHAR(20) DEFAULT 'moderate', -- 'brief', 'moderate', 'detailed'
    encouragement_level INTEGER DEFAULT 7, -- 1-10 scale
    challenge_level INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Avatar status
    is_active BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '1.0',
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_avatar_levels CHECK (
        expertise_level BETWEEN 1 AND 10 AND
        encouragement_level BETWEEN 1 AND 10 AND
        challenge_level BETWEEN 1 AND 10
    )
);

-- Avatar content customization for business scenarios
CREATE TABLE business_avatar_content (
    variation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES business_content(content_id) ON DELETE CASCADE,
    avatar_id UUID NOT NULL REFERENCES business_ai_avatars(avatar_id) ON DELETE CASCADE,
    
    -- Business-specific guidance
    business_context_intro TEXT,
    client_scenario_setup TEXT,
    practical_application_tips JSONB,
    
    -- Avatar-specific content variations
    explanation_style TEXT, -- How this avatar explains concepts
    examples_provided JSONB, -- Business examples this avatar uses
    client_stories JSONB, -- Client scenarios and anecdotes
    
    -- Interactive elements
    coaching_questions JSONB, -- Questions avatar asks to guide learning
    challenge_scenarios JSONB, -- Challenging situations avatar presents
    encouragement_messages JSONB,
    
    -- Business guidance
    pricing_advice TEXT,
    client_communication_tips JSONB,
    proposal_review_criteria JSONB,
    portfolio_enhancement_suggestions JSONB,
    
    -- Difficulty adaptation
    beginner_entrepreneur_version TEXT,
    experienced_freelancer_version TEXT,
    scaling_business_version TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, avatar_id)
);

-- ================================================================
-- 5. FREELANCER-SPECIFIC ASSESSMENT SYSTEM
-- ================================================================

-- Business-focused assessments
CREATE TABLE business_assessments (
    assessment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES business_learning_units(unit_id) ON DELETE CASCADE,
    
    -- Assessment identification
    assessment_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Assessment type and structure
    assessment_type assessment_type NOT NULL,
    business_scenario TEXT, -- Business context for the assessment
    client_simulation BOOLEAN DEFAULT false,
    
    -- Scoring and evaluation
    total_points INTEGER DEFAULT 100,
    passing_score INTEGER DEFAULT 70,
    business_application_weight DECIMAL(3,2) DEFAULT 0.4, -- Weight of business application in score
    
    -- Assessment parameters
    time_limit_minutes INTEGER,
    attempts_allowed INTEGER DEFAULT 3,
    requires_portfolio_submission BOOLEAN DEFAULT false,
    requires_peer_review BOOLEAN DEFAULT false,
    
    -- Business validation
    industry_relevance INTEGER DEFAULT 5, -- 1-10 scale
    client_readiness_indicator BOOLEAN DEFAULT false,
    portfolio_enhancement_value INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Instructions and feedback
    instructions TEXT NOT NULL,
    business_context_instructions TEXT,
    evaluation_criteria JSONB,
    
    -- Success indicators
    success_message TEXT,
    failure_guidance TEXT,
    improvement_suggestions JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_passing_score_valid CHECK (passing_score <= total_points),
    CONSTRAINT chk_business_weight CHECK (business_application_weight BETWEEN 0 AND 1)
);

-- Business-focused assessment questions
CREATE TABLE business_assessment_questions (
    question_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID NOT NULL REFERENCES business_assessments(assessment_id) ON DELETE CASCADE,
    
    -- Question content
    question_text TEXT NOT NULL,
    question_type assessment_type NOT NULL,
    points INTEGER DEFAULT 1,
    
    -- Business context
    business_scenario TEXT, -- Specific business scenario for this question
    client_context TEXT, -- Client background and requirements
    
    -- Question data
    options JSONB, -- Multiple choice options
    correct_answer JSONB NOT NULL,
    
    -- Code challenge specifics
    starter_code TEXT,
    business_requirements JSONB, -- Business requirements to implement
    test_cases JSONB,
    solution_code TEXT,
    
    -- Business evaluation criteria
    technical_criteria JSONB,
    business_criteria JSONB,
    client_presentation_criteria JSONB,
    
    -- Question metadata
    difficulty_level INTEGER DEFAULT 5, -- 1-10 scale
    business_relevance INTEGER DEFAULT 5, -- 1-10 scale
    estimated_time_minutes INTEGER DEFAULT 5,
    
    -- Learning support
    hints JSONB,
    business_tips JSONB,
    common_mistakes JSONB,
    explanation TEXT,
    
    -- Question performance
    usage_count INTEGER DEFAULT 0,
    success_rate DECIMAL(5,4),
    average_completion_time INTEGER,
    
    order_index INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_points CHECK (points > 0),
    CONSTRAINT chk_question_ratings CHECK (
        difficulty_level BETWEEN 1 AND 10 AND
        business_relevance BETWEEN 1 AND 10
    )
);

-- Client project simulations
CREATE TABLE client_project_simulations (
    simulation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID REFERENCES business_assessments(assessment_id) ON DELETE CASCADE,
    
    -- Simulation setup
    simulation_name VARCHAR(200) NOT NULL,
    client_profile JSONB NOT NULL, -- Client background, industry, size, etc.
    project_brief TEXT NOT NULL,
    
    -- Project requirements
    functional_requirements JSONB NOT NULL,
    non_functional_requirements JSONB,
    business_constraints JSONB,
    timeline_requirements JSONB,
    budget_constraints JSONB,
    
    -- Simulation phases
    discovery_phase JSONB, -- Questions and requirements gathering
    proposal_phase JSONB, -- Proposal creation and presentation
    development_phase JSONB, -- Implementation tasks
    delivery_phase JSONB, -- Delivery and client feedback
    
    -- Evaluation criteria
    technical_evaluation JSONB,
    business_evaluation JSONB,
    client_communication_evaluation JSONB,
    project_management_evaluation JSONB,
    
    -- Simulation difficulty
    complexity_level INTEGER DEFAULT 5, -- 1-10 scale
    estimated_completion_hours INTEGER,
    required_skills UUID[], -- Array of skill IDs
    
    -- Success metrics
    success_criteria JSONB,
    client_satisfaction_metrics JSONB,
    profitability_targets JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_complexity_range CHECK (complexity_level BETWEEN 1 AND 10)
);

-- ================================================================
-- 6. FREELANCER PROGRESS & BUSINESS TRACKING
-- ================================================================

-- Business-focused user progress tracking
CREATE TABLE freelancer_progress (
    progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    unit_id UUID NOT NULL REFERENCES business_learning_units(unit_id) ON DELETE CASCADE,
    
    -- Progress status
    status progress_status DEFAULT 'not_started',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Time and effort tracking
    total_time_spent_minutes INTEGER DEFAULT 0,
    session_count INTEGER DEFAULT 0,
    first_accessed_at TIMESTAMPTZ,
    last_accessed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    
    -- Learning effectiveness
    comprehension_score DECIMAL(3,2), -- 1-10 scale
    practical_application_score DECIMAL(3,2), -- How well they applied it
    business_readiness_score DECIMAL(3,2), -- Ready for client work
    
    -- Business application
    applied_to_client_work BOOLEAN DEFAULT false,
    client_project_reference TEXT, -- Reference to actual client project
    revenue_generated DECIMAL(10,2) DEFAULT 0,
    client_feedback JSONB,
    
    -- Skill development tracking
    skill_proficiency_before INTEGER, -- 1-10 scale before learning
    skill_proficiency_after INTEGER, -- 1-10 scale after learning
    monetization_status monetization_status DEFAULT 'learning',
    
    -- Portfolio development
    portfolio_artifact_created BOOLEAN DEFAULT false,
    portfolio_item_description TEXT,
    portfolio_item_url TEXT,
    
    -- Notes and reflection
    user_notes TEXT,
    key_learnings JSONB,
    challenges_faced JSONB,
    improvement_areas JSONB,
    
    -- Follow-up actions
    next_steps JSONB,
    practice_plan JSONB,
    client_application_plan JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, unit_id),
    CONSTRAINT chk_progress_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_proficiency_ranges CHECK (
        (skill_proficiency_before IS NULL OR skill_proficiency_before BETWEEN 1 AND 10) AND
        (skill_proficiency_after IS NULL OR skill_proficiency_after BETWEEN 1 AND 10)
    )
);

-- Freelancer skill development tracking
CREATE TABLE freelancer_skill_progress (
    skill_progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    skill_id UUID NOT NULL REFERENCES freelancer_skills(skill_id) ON DELETE CASCADE,
    
    -- Current skill status
    current_proficiency INTEGER DEFAULT 1, -- 1-10 scale
    target_proficiency INTEGER DEFAULT 7,
    monetization_status monetization_status DEFAULT 'learning',
    
    -- Learning journey
    learning_start_date DATE,
    first_client_application_date DATE,
    first_revenue_date DATE,
    mastery_achieved_date DATE,
    
    -- Business metrics
    current_hourly_rate DECIMAL(8,2),
    projects_using_skill INTEGER DEFAULT 0,
    revenue_from_skill DECIMAL(10,2) DEFAULT 0,
    client_satisfaction_avg DECIMAL(3,2),
    
    -- Market positioning
    competitive_advantage_level INTEGER DEFAULT 5, -- 1-10 scale
    market_differentiation TEXT,
    unique_value_proposition TEXT,
    
    -- Skill development activities
    learning_resources_used JSONB,
    practice_projects JSONB,
    certifications_pursued JSONB,
    
    -- Performance tracking
    skill_assessment_scores JSONB, -- Historical assessment scores
    peer_review_feedback JSONB,
    client_feedback_summary JSONB,
    
    -- Future planning
    improvement_plan JSONB,
    target_market_segments JSONB,
    revenue_goals JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, skill_id),
    CONSTRAINT chk_proficiency_levels CHECK (
        current_proficiency BETWEEN 1 AND 10 AND
        target_proficiency BETWEEN 1 AND 10 AND
        target_proficiency >= current_proficiency
    )
);

-- Client project tracking
CREATE TABLE client_projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Project identification
    project_name VARCHAR(200) NOT NULL,
    client_name VARCHAR(200),
    project_type project_type NOT NULL,
    business_domain business_domain NOT NULL,
    
    -- Project timeline
    start_date DATE NOT NULL,
    planned_end_date DATE,
    actual_end_date DATE,
    project_status VARCHAR(20) DEFAULT 'active', -- 'planned', 'active', 'completed', 'cancelled'
    
    -- Project scope and requirements
    project_description TEXT,
    requirements JSONB,
    deliverables JSONB,
    success_criteria JSONB,
    
    -- Skills and learning application
    skills_applied UUID[] NOT NULL, -- Array of skill IDs
    learning_units_applied UUID[], -- Array of unit IDs
    new_skills_developed JSONB,
    
    -- Financial aspects
    project_budget DECIMAL(10,2),
    hourly_rate DECIMAL(8,2),
    total_hours_worked INTEGER,
    total_revenue DECIMAL(10,2),
    project_profitability DECIMAL(10,2),
    
    -- Project outcomes
    technical_outcomes JSONB,
    business_outcomes JSONB,
    client_satisfaction_score INTEGER, -- 1-10 scale
    
    -- Learning and portfolio value
    portfolio_enhancement_value INTEGER DEFAULT 5, -- 1-10 scale
    testimonial_received TEXT,
    case_study_potential BOOLEAN DEFAULT false,
    referrals_generated INTEGER DEFAULT 0,
    
    -- Project retrospective
    what_went_well JSONB,
    challenges_faced JSONB,
    lessons_learned JSONB,
    areas_for_improvement JSONB,
    
    -- Follow-up opportunities
    follow_up_projects JSONB,
    upselling_opportunities JSONB,
    client_expansion_potential INTEGER DEFAULT 5, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_revenue CHECK (total_revenue IS NULL OR total_revenue >= 0),
    CONSTRAINT chk_satisfaction_range CHECK (
        client_satisfaction_score IS NULL OR 
        client_satisfaction_score BETWEEN 1 AND 10
    )
);

-- Business milestone tracking
CREATE TABLE business_milestones (
    milestone_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Milestone details
    milestone_name VARCHAR(200) NOT NULL,
    milestone_category VARCHAR(50) NOT NULL, -- 'revenue', 'client', 'skill', 'portfolio', 'business'
    description TEXT,
    
    -- Target and achievement
    target_value DECIMAL(12,2),
    achieved_value DECIMAL(12,2),
    target_date DATE,
    achieved_date DATE,
    
    -- Business context
    related_skills UUID[], -- Skills that contributed to this milestone
    related_projects UUID[], -- Projects that contributed to this milestone
    learning_units_that_helped UUID[], -- Learning units that contributed
    
    -- Milestone significance
    business_impact INTEGER DEFAULT 5, -- 1-10 scale
    career_advancement_value INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Celebration and recognition
    achievement_notes TEXT,
    celebration_plan JSONB,
    shared_publicly BOOLEAN DEFAULT false,
    
    -- Next steps
    next_milestone_ideas JSONB,
    improvement_opportunities JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 7. BUSINESS ANALYTICS & REVENUE TRACKING
-- ================================================================

-- Business performance sessions
CREATE TABLE business_learning_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Session details
    started_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMPTZ,
    duration_minutes INTEGER,
    session_type VARCHAR(50) DEFAULT 'self_study', -- 'self_study', 'case_study', 'client_simulation'
    
    -- Learning focus
    curriculum_id UUID REFERENCES business_curricula(curriculum_id),
    units_studied UUID[],
    skills_practiced UUID[],
    business_scenarios_completed JSONB,
    
    -- Business application
    client_work_applied BOOLEAN DEFAULT false,
    client_project_reference UUID REFERENCES client_projects(project_id),
    revenue_opportunity_identified BOOLEAN DEFAULT false,
    portfolio_enhancement BOOLEAN DEFAULT false,
    
    -- Session quality and outcomes
    focus_level INTEGER DEFAULT 5, -- 1-10 scale
    practical_application_level INTEGER DEFAULT 5, -- 1-10 scale
    business_insight_gained INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Immediate actions taken
    immediate_actions JSONB,
    follow_up_tasks JSONB,
    client_outreach_planned JSONB,
    
    -- Technical metadata
    device_used VARCHAR(50),
    location VARCHAR(100),
    interruptions_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Revenue attribution tracking
CREATE TABLE revenue_attribution (
    attribution_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Revenue details
    revenue_amount DECIMAL(10,2) NOT NULL,
    revenue_date DATE NOT NULL,
    revenue_source VARCHAR(100) NOT NULL, -- 'client_project', 'consulting', 'training', 'product_sale'
    
    -- Attribution to learning
    attributed_skills UUID[], -- Skills that contributed to this revenue
    attributed_learning_units UUID[], -- Learning units that contributed
    attributed_case_studies UUID[], -- Case studies that helped
    attribution_confidence INTEGER DEFAULT 5, -- 1-10 scale of confidence in attribution
    
    -- Client and project context
    client_project_id UUID REFERENCES client_projects(project_id),
    client_type VARCHAR(50), -- 'startup', 'small_business', 'enterprise', 'individual'
    project_complexity INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Revenue analysis
    hourly_rate DECIMAL(8,2),
    hours_worked INTEGER,
    profit_margin DECIMAL(5,4), -- Percentage
    
    -- Learning ROI calculation
    learning_time_invested_hours INTEGER, -- Time spent learning related skills
    learning_roi DECIMAL(8,2), -- Revenue per hour of learning time
    
    -- Business impact
    client_satisfaction_score INTEGER, -- 1-10 scale
    referral_potential INTEGER DEFAULT 5, -- 1-10 scale
    repeat_business_likelihood INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Notes and insights
    success_factors JSONB,
    key_learnings JSONB,
    improvement_opportunities JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_revenue CHECK (revenue_amount > 0),
    CONSTRAINT chk_attribution_confidence CHECK (attribution_confidence BETWEEN 1 AND 10)
);

-- Market insights and trends
CREATE TABLE market_insights (
    insight_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    
    -- Insight details
    insight_title VARCHAR(200) NOT NULL,
    insight_category VARCHAR(50) NOT NULL, -- 'skill_demand', 'rate_trends', 'industry_growth'
    business_domain business_domain,
    
    -- Market data
    data_points JSONB NOT NULL,
    trend_direction VARCHAR(20), -- 'increasing', 'stable', 'decreasing'
    confidence_level INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Business implications
    opportunities JSONB,
    threats JSONB,
    recommended_actions JSONB,
    
    -- Data sources and validation
    data_sources JSONB,
    last_updated DATE,
    validation_status VARCHAR(20) DEFAULT 'unverified', -- 'unverified', 'verified', 'outdated'
    
    -- Impact on freelancers
    skill_demand_impact JSONB,
    rate_impact JSONB,
    opportunity_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_confidence_range CHECK (confidence_level BETWEEN 1 AND 10)
);

-- ================================================================
-- 8. SEMANTIC SEARCH & BUSINESS INTELLIGENCE
-- ================================================================

-- Embedding models optimized for business content
CREATE TABLE business_embedding_models (
    model_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(100) NOT NULL UNIQUE,
    provider VARCHAR(50) NOT NULL,
    model_version VARCHAR(20),
    embedding_dimensions INTEGER NOT NULL,
    
    -- Business optimization
    business_domain_optimized business_domain[],
    client_scenario_trained BOOLEAN DEFAULT false,
    revenue_context_aware BOOLEAN DEFAULT false,
    
    -- Model characteristics
    context_window INTEGER,
    accuracy_score DECIMAL(5,4),
    business_relevance_score DECIMAL(5,4),
    
    -- Status
    is_active BOOLEAN DEFAULT true,
    is_primary BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_dimensions_positive CHECK (embedding_dimensions > 0)
);

-- Business content embeddings
CREATE TABLE business_content_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES business_content(content_id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES business_embedding_models(model_id),
    
    -- Vector embeddings
    content_vector vector NOT NULL,
    business_context_vector vector,
    client_scenario_vector vector,
    skill_application_vector vector,
    
    -- Embedding metadata
    content_hash VARCHAR(64) NOT NULL,
    token_count INTEGER,
    business_keywords JSONB,
    client_context_keywords JSONB,
    
    -- Quality metrics
    embedding_quality_score DECIMAL(5,4),
    business_relevance_score DECIMAL(5,4),
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, model_id)
);

-- Business skill-content mapping
CREATE TABLE business_skill_content_mapping (
    mapping_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES business_content(content_id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES freelancer_skills(skill_id) ON DELETE CASCADE,
    
    -- Mapping characteristics
    relevance_score DECIMAL(3,2) NOT NULL, -- 1-10 scale
    skill_development_contribution DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    monetization_preparation_value DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Business application
    client_applicability DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    portfolio_enhancement_value DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Learning progression
    introduces_skill BOOLEAN DEFAULT false,
    reinforces_skill BOOLEAN DEFAULT true,
    masters_skill BOOLEAN DEFAULT false,
    applies_skill_to_business BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, skill_id),
    CONSTRAINT chk_relevance_score CHECK (relevance_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 9. MATERIALIZED VIEWS FOR BUSINESS ANALYTICS
-- ================================================================

-- Freelancer business performance analytics
CREATE MATERIALIZED VIEW mv_freelancer_business_analytics AS
SELECT 
    fp.user_id,
    fp.professional_title,
    fp.current_hourly_rate,
    fp.target_hourly_rate,
    fp.monthly_revenue,
    
    -- Learning metrics
    COUNT(DISTINCT fsp.skill_id) as skills_in_development,
    COUNT(CASE WHEN fsp.monetization_status = 'generating_revenue' THEN 1 END) as monetized_skills,
    AVG(fsp.current_proficiency) as avg_skill_proficiency,
    
    -- Project metrics
    COUNT(DISTINCT cp.project_id) as total_projects,
    COUNT(CASE WHEN cp.project_status = 'completed' THEN 1 END) as completed_projects,
    AVG(cp.client_satisfaction_score) as avg_client_satisfaction,
    SUM(cp.total_revenue) as total_project_revenue,
    
    -- Learning application
    COUNT(DISTINCT pr.unit_id) as units_completed,
    COUNT(CASE WHEN pr.applied_to_client_work THEN 1 END) as units_applied_to_work,
    SUM(pr.revenue_generated) as revenue_from_learning,
    
    -- Business milestones
    COUNT(DISTINCT bm.milestone_id) as milestones_achieved,
    MAX(bm.achieved_date) as last_milestone_date,
    
    -- ROI calculation
    CASE 
        WHEN SUM(bls.duration_minutes) > 0 THEN
            SUM(ra.revenue_amount) / (SUM(bls.duration_minutes) / 60.0)
        ELSE 0
    END as revenue_per_learning_hour,
    
    -- Recent activity
    MAX(bls.started_at) as last_learning_session,
    MAX(cp.updated_at) as last_project_update,
    
    -- Growth indicators
    COUNT(CASE WHEN ra.revenue_date > CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as recent_revenue_events,
    SUM(CASE WHEN ra.revenue_date > CURRENT_DATE - INTERVAL '30 days' THEN ra.revenue_amount ELSE 0 END) as revenue_last_30_days
    
FROM freelancer_profiles fp
LEFT JOIN freelancer_skill_progress fsp ON fp.user_id = fsp.user_id
LEFT JOIN client_projects cp ON fp.user_id = cp.user_id
LEFT JOIN freelancer_progress pr ON fp.user_id = pr.user_id
LEFT JOIN business_milestones bm ON fp.user_id = bm.user_id AND bm.achieved_date IS NOT NULL
LEFT JOIN business_learning_sessions bls ON fp.user_id = bls.user_id
LEFT JOIN revenue_attribution ra ON fp.user_id = ra.user_id
GROUP BY fp.user_id, fp.professional_title, fp.current_hourly_rate, 
         fp.target_hourly_rate, fp.monthly_revenue;

-- Skill market demand and profitability analysis
CREATE MATERIALIZED VIEW mv_skill_market_analysis AS
SELECT 
    fs.skill_id,
    fs.skill_name,
    fs.business_domain,
    fs.average_hourly_rate,
    fs.market_demand,
    fs.freelance_demand_score,
    
    -- Learning metrics
    COUNT(DISTINCT fsp.user_id) as freelancers_learning,
    AVG(fsp.current_proficiency) as avg_proficiency_level,
    COUNT(CASE WHEN fsp.monetization_status = 'generating_revenue' THEN 1 END) as monetizing_freelancers,
    
    -- Revenue metrics
    COUNT(DISTINCT ra.attribution_id) as revenue_attributions,
    SUM(ra.revenue_amount) as total_attributed_revenue,
    AVG(ra.revenue_amount) as avg_revenue_per_attribution,
    AVG(ra.hourly_rate) as avg_hourly_rate_achieved,
    
    -- Project application
    COUNT(DISTINCT cp.project_id) as projects_using_skill,
    AVG(cp.client_satisfaction_score) as avg_client_satisfaction,
    COUNT(CASE WHEN cp.project_status = 'completed' THEN 1 END) as successful_projects,
    
    -- Learning effectiveness
    COUNT(DISTINCT bscm.content_id) as learning_content_available,
    AVG(bscm.relevance_score) as avg_content_relevance,
    AVG(bscm.monetization_preparation_value) as avg_monetization_value,
    
    -- Market trends
    fs.growth_trend,
    fs.trend_confidence,
    fs.last_market_analysis,
    
    -- ROI indicators
    CASE 
        WHEN fs.learning_time_hours > 0 AND SUM(ra.revenue_amount) > 0 THEN
            SUM(ra.revenue_amount) / fs.learning_time_hours
        ELSE 0
    END as revenue_per_learning_hour,
    
    -- Competitiveness
    CASE 
        WHEN COUNT(DISTINCT fsp.user_id) > 0 THEN
            COUNT(CASE WHEN fsp.monetization_status = 'generating_revenue' THEN 1 END)::DECIMAL / 
            COUNT(DISTINCT fsp.user_id)
        ELSE 0
    END as monetization_success_rate
    
FROM freelancer_skills fs
LEFT JOIN freelancer_skill_progress fsp ON fs.skill_id = fsp.skill_id
LEFT JOIN revenue_attribution ra ON fs.skill_id = ANY(ra.attributed_skills)
LEFT JOIN client_projects cp ON fs.skill_id = ANY(cp.skills_applied)
LEFT JOIN business_skill_content_mapping bscm ON fs.skill_id = bscm.skill_id
GROUP BY fs.skill_id, fs.skill_name, fs.business_domain, fs.average_hourly_rate,
         fs.market_demand, fs.freelance_demand_score, fs.growth_trend,
         fs.trend_confidence, fs.last_market_analysis, fs.learning_time_hours;

-- Business content effectiveness for freelancer outcomes
CREATE MATERIALIZED VIEW mv_business_content_effectiveness AS
SELECT 
    bc.content_id,
    bc.title,
    bc.content_type,
    bc.business_applications,
    bc.revenue_potential,
    
    -- Usage metrics
    COUNT(DISTINCT pr.user_id) as unique_users,
    AVG(pr.total_time_spent_minutes) as avg_time_spent,
    COUNT(CASE WHEN pr.status = 'completed' THEN 1 END) as completions,
    
    -- Learning effectiveness
    AVG(pr.comprehension_score) as avg_comprehension,
    AVG(pr.practical_application_score) as avg_practical_application,
    AVG(pr.business_readiness_score) as avg_business_readiness,
    
    -- Business application
    COUNT(CASE WHEN pr.applied_to_client_work THEN 1 END) as client_applications,
    SUM(pr.revenue_generated) as total_revenue_attributed,
    COUNT(CASE WHEN pr.portfolio_artifact_created THEN 1 END) as portfolio_artifacts,
    
    -- Content quality indicators
    bc.content_quality_score,
    bc.business_relevance_score,
    bc.client_applicability_score,
    AVG(pr.practical_application_score) as user_practical_rating,
    
    -- Skills development
    COUNT(DISTINCT bscm.skill_id) as skills_addressed,
    AVG(bscm.monetization_preparation_value) as avg_monetization_prep,
    
    -- ROI metrics
    CASE 
        WHEN AVG(pr.total_time_spent_minutes) > 0 THEN
            SUM(pr.revenue_generated) / (AVG(pr.total_time_spent_minutes) / 60.0)
        ELSE 0
    END as revenue_per_hour_of_content,
    
    -- Case study integration
    COUNT(DISTINCT ccs.case_study_id) as related_case_studies,
    COUNT(DISTINCT bt.template_id) as business_templates_provided
    
FROM business_content bc
LEFT JOIN freelancer_progress pr ON bc.unit_id = pr.unit_id
LEFT JOIN business_skill_content_mapping bscm ON bc.content_id = bscm.content_id
LEFT JOIN client_case_studies ccs ON bc.content_id = ccs.content_id
LEFT JOIN business_templates bt ON bc.content_id = bt.content_id
GROUP BY bc.content_id, bc.title, bc.content_type, bc.business_applications,
         bc.revenue_potential, bc.content_quality_score, bc.business_relevance_score,
         bc.client_applicability_score;

-- ================================================================
-- COMPREHENSIVE INDEXING STRATEGY FOR BUSINESS FOCUS
-- ================================================================

-- Freelancer profile indexes
CREATE INDEX idx_freelancer_profiles_user ON freelancer_profiles(user_id);
CREATE INDEX idx_freelancer_profiles_domains ON freelancer_profiles USING GIN(target_specializations);
CREATE INDEX idx_freelancer_profiles_revenue ON freelancer_profiles(monthly_revenue DESC);
CREATE INDEX idx_freelancer_profiles_rate ON freelancer_profiles(current_hourly_rate DESC);

-- Business skill indexes
CREATE INDEX idx_freelancer_skills_domain ON freelancer_skills(business_domain);
CREATE INDEX idx_freelancer_skills_demand ON freelancer_skills(market_demand DESC, freelance_demand_score DESC);
CREATE INDEX idx_freelancer_skills_rate ON freelancer_skills(average_hourly_rate DESC);
CREATE INDEX idx_freelancer_skills_trend ON freelancer_skills(growth_trend, trend_confidence DESC);

-- Curriculum and content indexes
CREATE INDEX idx_business_curricula_domains ON business_curricula USING GIN(target_business_domains);
CREATE INDEX idx_business_curricula_revenue ON business_curricula(revenue_potential DESC);
CREATE INDEX idx_business_modules_curriculum ON business_modules(curriculum_id, module_number);
CREATE INDEX idx_business_components_module ON business_components(module_id, order_index);
CREATE INDEX idx_business_topics_component ON business_topics(component_id, order_index);
CREATE INDEX idx_business_learning_units_topic ON business_learning_units(topic_id, order_index);

-- Content management indexes
CREATE INDEX idx_business_content_unit ON business_content(unit_id);
CREATE INDEX idx_business_content_type ON business_content(content_type);
CREATE INDEX idx_business_content_revenue ON business_content(revenue_potential DESC);
CREATE INDEX idx_business_content_business_tags ON business_content USING GIN(business_tags);
CREATE INDEX idx_business_content_skill_tags ON business_content USING GIN(skill_tags);

-- Full-text search for business content
CREATE INDEX idx_business_content_search ON business_content 
    USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || 
    array_to_string(keywords, ' ') || ' ' || array_to_string(business_tags, ' ')));

-- Case study indexes
CREATE INDEX idx_client_case_studies_industry ON client_case_studies(industry);
CREATE INDEX idx_client_case_studies_project_type ON client_case_studies(project_type);
CREATE INDEX idx_client_case_studies_budget ON client_case_studies(project_budget DESC);
CREATE INDEX idx_client_case_studies_satisfaction ON client_case_studies(client_satisfaction_score DESC);

-- AI Avatar indexes
CREATE INDEX idx_business_ai_avatars_role ON business_ai_avatars(primary_role);
CREATE INDEX idx_business_ai_avatars_specialization ON business_ai_avatars USING GIN(specialization_areas);
CREATE INDEX idx_business_ai_avatars_active ON business_ai_avatars(is_active) WHERE is_active = true;

-- Assessment indexes
CREATE INDEX idx_business_assessments_unit ON business_assessments(unit_id);
CREATE INDEX idx_business_assessments_type ON business_assessments(assessment_type);
CREATE INDEX idx_business_assessment_questions_assessment ON business_assessment_questions(assessment_id, order_index);

-- Progress tracking indexes
CREATE INDEX idx_freelancer_progress_user ON freelancer_progress(user_id);
CREATE INDEX idx_freelancer_progress_unit ON freelancer_progress(unit_id);
CREATE INDEX idx_freelancer_progress_status ON freelancer_progress(status);
CREATE INDEX idx_freelancer_progress_revenue ON freelancer_progress(revenue_generated DESC);

-- Skill progress indexes
CREATE INDEX idx_freelancer_skill_progress_user ON freelancer_skill_progress(user_id);
CREATE INDEX idx_freelancer_skill_progress_skill ON freelancer_skill_progress(skill_id);
CREATE INDEX idx_freelancer_skill_progress_monetization ON freelancer_skill_progress(monetization_status);
CREATE INDEX idx_freelancer_skill_progress_proficiency ON freelancer_skill_progress(current_proficiency DESC);

-- Client project indexes
CREATE INDEX idx_client_projects_user ON client_projects(user_id);
CREATE INDEX idx_client_projects_type ON client_projects(project_type);
CREATE INDEX idx_client_projects_domain ON client_projects(business_domain);
CREATE INDEX idx_client_projects_revenue ON client_projects(total_revenue DESC);
CREATE INDEX idx_client_projects_status ON client_projects(project_status);
CREATE INDEX idx_client_projects_date ON client_projects(start_date DESC);

-- Revenue tracking indexes
CREATE INDEX idx_revenue_attribution_user ON revenue_attribution(user_id);
CREATE INDEX idx_revenue_attribution_date ON revenue_attribution(revenue_date DESC);
CREATE INDEX idx_revenue_attribution_amount ON revenue_attribution(revenue_amount DESC);
CREATE INDEX idx_revenue_attribution_skills ON revenue_attribution USING GIN(attributed_skills);

-- Session tracking indexes
CREATE INDEX idx_business_learning_sessions_user ON business_learning_sessions(user_id);
CREATE INDEX idx_business_learning_sessions_date ON business_learning_sessions(started_at DESC);
CREATE INDEX idx_business_learning_sessions_type ON business_learning_sessions(session_type);

-- Vector search indexes for business content
CREATE INDEX idx_business_content_embeddings_vector ON business_content_embeddings 
    USING hnsw (content_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX idx_business_content_embeddings_business_vector ON business_content_embeddings 
    USING hnsw (business_context_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE business_context_vector IS NOT NULL;
CREATE INDEX idx_business_content_embeddings_client_vector ON business_content_embeddings 
    USING hnsw (client_scenario_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE client_scenario_vector IS NOT NULL;

-- ================================================================
-- ROW LEVEL SECURITY FOR BUSINESS DATA
-- ================================================================

-- Enable RLS on user-specific tables
ALTER TABLE freelancer_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE freelancer_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE freelancer_skill_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_learning_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE revenue_attribution ENABLE ROW LEVEL SECURITY;

-- User data isolation policies
CREATE POLICY freelancer_profile_isolation ON freelancer_profiles
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY freelancer_progress_isolation ON freelancer_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY skill_progress_isolation ON freelancer_skill_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY client_projects_isolation ON client_projects
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY revenue_attribution_isolation ON revenue_attribution
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Shared content access policies
CREATE POLICY business_content_read_access ON business_content
    FOR SELECT TO application_users
    USING (true);

CREATE POLICY case_studies_read_access ON client_case_studies
    FOR SELECT TO application_users
    USING (true);

-- Admin access policies
CREATE POLICY admin_full_access_freelancer_profiles ON freelancer_profiles
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_full_access_business_content ON business_content
    FOR ALL TO admin_users
    USING (true);

-- ================================================================
-- SPECIALIZED FUNCTIONS FOR FREELANCER BUSINESS INTELLIGENCE
-- ================================================================

-- Function to get personalized skill recommendations based on market demand and user goals
CREATE OR REPLACE FUNCTION get_skill_recommendations(
    p_user_id UUID,
    p_target_revenue_increase DECIMAL DEFAULT 1000.00,
    p_limit INTEGER DEFAULT 10
) RETURNS TABLE (
    skill_id UUID,
    skill_name VARCHAR,
    business_domain business_domain,
    market_demand INTEGER,
    average_hourly_rate DECIMAL,
    learning_time_hours INTEGER,
    revenue_potential_score DECIMAL
) AS $$
DECLARE
    user_current_skills UUID[];
    user_domains business_domain[];
    user_current_rate DECIMAL;
BEGIN
    -- Get user's current skills and preferences
    SELECT target_specializations, current_hourly_rate 
    INTO user_domains, user_current_rate
    FROM freelancer_profiles 
    WHERE user_id = p_user_id;
    
    -- Get skills user is already developing
    SELECT array_agg(skill_id) INTO user_current_skills
    FROM freelancer_skill_progress 
    WHERE user_id = p_user_id;
    
    RETURN QUERY
    WITH skill_scores AS (
        SELECT 
            fs.skill_id,
            fs.skill_name,
            fs.business_domain,
            fs.market_demand,
            fs.average_hourly_rate,
            fs.learning_time_hours,
            
            -- Calculate revenue potential score
            (CASE 
                WHEN fs.business_domain = ANY(user_domains) THEN 10.0
                ELSE 5.0
            END +
            CASE 
                WHEN fs.average_hourly_rate > user_current_rate THEN 
                    LEAST(10.0, (fs.average_hourly_rate - user_current_rate) / 10.0)
                ELSE 3.0
            END +
            fs.market_demand::DECIMAL +
            fs.freelance_demand_score::DECIMAL +
            CASE 
                WHEN fs.growth_trend = 'exploding' THEN 10.0
                WHEN fs.growth_trend = 'growing' THEN 7.0
                WHEN fs.growth_trend = 'stable' THEN 5.0
                ELSE 2.0
            END) / 5.0 as revenue_potential_score
            
        FROM freelancer_skills fs
        WHERE (user_current_skills IS NULL OR fs.skill_id != ALL(user_current_skills))
        AND fs.average_hourly_rate IS NOT NULL
    )
    SELECT 
        ss.skill_id,
        ss.skill_name,
        ss.business_domain,
        ss.market_demand,
        ss.average_hourly_rate,
        ss.learning_time_hours,
        ss.revenue_potential_score
    FROM skill_scores ss
    ORDER BY ss.revenue_potential_score DESC, ss.average_hourly_rate DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate learning ROI for a specific skill
CREATE OR REPLACE FUNCTION calculate_skill_learning_roi(
    p_user_id UUID,
    p_skill_id UUID
) RETURNS JSONB AS $$
DECLARE
    skill_info RECORD;
    user_info RECORD;
    learning_time INTEGER;
    potential_rate_increase DECIMAL;
    projected_annual_revenue_increase DECIMAL;
    result JSONB;
BEGIN
    -- Get skill information
    SELECT skill_name, average_hourly_rate, learning_time_hours, market_demand, growth_trend
    INTO skill_info
    FROM freelancer_skills 
    WHERE skill_id = p_skill_id;
    
    -- Get user information
    SELECT current_hourly_rate, weekly_learning_hours, target_specializations
    INTO user_info
    FROM freelancer_profiles 
    WHERE user_id = p_user_id;
    
    -- Calculate learning time needed
    learning_time := skill_info.learning_time_hours;
    
    -- Calculate potential rate increase
    potential_rate_increase := GREATEST(0, skill_info.average_hourly_rate - user_info.current_hourly_rate);
    
    -- Project annual revenue increase (assuming 20 hours/week billable)
    projected_annual_revenue_increase := potential_rate_increase * 20 * 52;
    
    -- Build result JSON
    result := jsonb_build_object(
        'skill_name', skill_info.skill_name,
        'learning_time_hours', learning_time,
        'learning_time_weeks', ROUND(learning_time::DECIMAL / user_info.weekly_learning_hours, 1),
        'current_hourly_rate', user_info.current_hourly_rate,
        'projected_hourly_rate', skill_info.average_hourly_rate,
        'rate_increase', potential_rate_increase,
        'projected_annual_revenue_increase', projected_annual_revenue_increase,
        'roi_multiplier', 
            CASE WHEN learning_time > 0 THEN 
                ROUND(projected_annual_revenue_increase / learning_time, 2)
            ELSE 0 END,
        'market_demand', skill_info.market_demand,
        'growth_trend', skill_info.growth_trend,
        'recommendation_score', 
            CASE 
                WHEN potential_rate_increase > 20 AND skill_info.market_demand >= 7 THEN 'highly_recommended'
                WHEN potential_rate_increase > 10 AND skill_info.market_demand >= 5 THEN 'recommended'
                WHEN potential_rate_increase > 0 THEN 'consider'
                ELSE 'low_priority'
            END
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to identify business opportunities based on user skills and market trends
CREATE OR REPLACE FUNCTION identify_business_opportunities(
    p_user_id UUID,
    p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
    opportunity_type VARCHAR,
    opportunity_description TEXT,
    required_skills JSONB,
    revenue_potential DECIMAL,
    confidence_score INTEGER
) AS $$
DECLARE
    user_skills RECORD;
    skill_record RECORD;
BEGIN
    -- Get user's current skills with proficiency
    FOR user_skills IN
        SELECT fsp.skill_id, fs.skill_name, fs.business_domain, fsp.current_proficiency, fs.average_hourly_rate
        FROM freelancer_skill_progress fsp
        JOIN freelancer_skills fs ON fsp.skill_id = fs.skill_id
        WHERE fsp.user_id = p_user_id 
        AND fsp.current_proficiency >= 6 -- Only consider skills with decent proficiency
        AND fsp.monetization_status IN ('client_ready', 'generating_revenue')
    LOOP
        -- Identify opportunities based on high-demand skills
        RETURN QUERY
        SELECT 
            'high_demand_service'::VARCHAR as opportunity_type,
            'Offer ' || user_skills.skill_name || ' services in ' || user_skills.business_domain::text || ' domain' as opportunity_description,
            jsonb_build_array(jsonb_build_object('skill_name', user_skills.skill_name, 'required_proficiency', 7)) as required_skills,
            user_skills.average_hourly_rate * 160 as revenue_potential, -- Monthly potential at 40h/week
            CASE 
                WHEN user_skills.current_proficiency >= 8 THEN 9
                WHEN user_skills.current_proficiency >= 7 THEN 7
                ELSE 5
            END as confidence_score;
    END LOOP;
    
    -- Add combination opportunities
    RETURN QUERY
    SELECT 
        'skill_combination'::VARCHAR as opportunity_type,
        'Create comprehensive solutions combining multiple skills' as opportunity_description,
        jsonb_agg(jsonb_build_object('skill_name', fs.skill_name)) as required_skills,
        AVG(fs.average_hourly_rate) * 1.5 * 160 as revenue_potential, -- Premium for combination
        8 as confidence_score
    FROM freelancer_skill_progress fsp
    JOIN freelancer_skills fs ON fsp.skill_id = fs.skill_id
    WHERE fsp.user_id = p_user_id 
    AND fsp.current_proficiency >= 6
    GROUP BY fs.business_domain
    HAVING COUNT(*) >= 2
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to refresh all business materialized views
CREATE OR REPLACE FUNCTION refresh_business_analytics_views()
RETURNS JSONB AS $$
DECLARE
    start_time TIMESTAMPTZ;
    result JSONB := '{}';
BEGIN
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh freelancer business analytics
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_freelancer_business_analytics;
    result := result || jsonb_build_object('freelancer_analytics_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh skill market analysis
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_skill_market_analysis;
    result := result || jsonb_build_object('skill_market_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh content effectiveness
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_business_content_effectiveness;
    result := result || jsonb_build_object('content_effectiveness_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    result := result || jsonb_build_object('total_refresh_completed_at', CURRENT_TIMESTAMP);
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- TRIGGERS FOR AUTOMATIC BUSINESS LOGIC
-- ================================================================

-- Trigger function to update freelancer business metrics
CREATE OR REPLACE FUNCTION update_freelancer_business_metrics()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    
    -- Update monthly revenue calculation if needed
    IF TG_TABLE_NAME = 'revenue_attribution' THEN
        UPDATE freelancer_profiles 
        SET monthly_revenue = (
            SELECT COALESCE(SUM(revenue_amount), 0)
            FROM revenue_attribution 
            WHERE user_id = NEW.user_id 
            AND revenue_date >= DATE_TRUNC('month', CURRENT_DATE)
        ),
        revenue_attributed_to_platform = (
            SELECT COALESCE(SUM(revenue_amount), 0)
            FROM revenue_attribution 
            WHERE user_id = NEW.user_id
        )
        WHERE user_id = NEW.user_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply business metrics triggers
CREATE TRIGGER tr_update_business_metrics_revenue
    AFTER INSERT OR UPDATE ON revenue_attribution
    FOR EACH ROW EXECUTE FUNCTION update_freelancer_business_metrics();

CREATE TRIGGER tr_update_business_metrics_profiles
    BEFORE UPDATE ON freelancer_profiles
    FOR EACH ROW EXECUTE FUNCTION update_freelancer_business_metrics();

-- Trigger to update skill monetization status
CREATE OR REPLACE FUNCTION update_skill_monetization_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Update monetization status based on revenue attribution
    IF NEW.revenue_generated > 0 AND OLD.monetization_status != 'generating_revenue' THEN
        NEW.monetization_status = 'generating_revenue';
        
        -- Update the skill progress table
        UPDATE freelancer_skill_progress 
        SET monetization_status = 'generating_revenue',
            first_revenue_date = COALESCE(first_revenue_date, CURRENT_DATE),
            revenue_from_skill = revenue_from_skill + NEW.revenue_generated
        WHERE user_id = NEW.user_id 
        AND skill_id IN (
            SELECT unit_id FROM business_learning_units WHERE unit_id = NEW.unit_id
        );
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_skill_monetization
    BEFORE UPDATE ON freelancer_progress
    FOR EACH ROW EXECUTE FUNCTION update_skill_monetization_status();

-- ================================================================
-- INITIAL SYSTEM DATA FOR FREELANCER PLATFORM
-- ================================================================

-- Insert default business embedding model
INSERT INTO business_embedding_models (
    model_name, provider, embedding_dimensions, context_window,
    business_domain_optimized, client_scenario_trained, revenue_context_aware,
    is_active, is_primary
) VALUES (
    'business-optimized-embeddings-v1', 'sentence-transformers', 384, 512,
    ARRAY['web_development', 'data_analysis', 'automation']::business_domain[],
    true, true, true, true
);

-- Insert business-focused AI avatars
INSERT INTO business_ai_avatars (
    avatar_name, display_name, description, primary_role, specialization_areas,
    personality_traits, communication_style, years_of_industry_experience,
    can_review_proposals, can_analyze_pricing, can_provide_market_insights
) VALUES 
('business_mentor', 'Marcus - Business Development Mentor',
 'Experienced freelancer who helps with business strategy and client acquisition',
 'business_mentor', 
 ARRAY['web_development', 'data_analysis']::business_domain[],
 '{"supportive": 9, "practical": 10, "experienced": 10, "encouraging": 8}'::jsonb,
 '{"tone": "professional", "style": "conversational", "approach": "practical"}'::jsonb,
 15, true, true, true),

('client_advisor', 'Sarah - Client Relations Advisor',
 'Specialist in client communication, project management, and relationship building',
 'client_advisor',
 ARRAY['web_development', 'system_integration']::business_domain[],
 '{"diplomatic": 10, "professional": 9, "detail_oriented": 8, "client_focused": 10}'::jsonb,
 '{"tone": "professional", "style": "structured", "approach": "consultative"}'::jsonb,
 12, true, false, true),

('pricing_consultant', 'David - Pricing Strategy Consultant',
 'Expert in freelance pricing strategies, rate optimization, and value-based pricing',
 'pricing_consultant',
 ARRAY['web_development', 'data_analysis', 'automation']::business_domain[],
 '{"analytical": 10, "confident": 9, "strategic": 10, "results_oriented": 9}'::jsonb,
 '{"tone": "authoritative", "style": "data_driven", "approach": "strategic"}'::jsonb,
 20, true, true, true);

-- Insert sample high-demand freelancer skills
INSERT INTO freelancer_skills (
    skill_code, skill_name, description, business_domain, skill_category,
    market_demand, average_hourly_rate, rate_range_min, rate_range_max,
    learning_time_hours, freelance_demand_score, growth_trend
) VALUES 
('python_web_dev', 'Python Web Development', 'Full-stack web development using Python frameworks', 
 'web_development', 'core_technical', 9, 75.00, 50.00, 120.00, 120, 9, 'growing'),

('data_analysis_python', 'Python Data Analysis', 'Data analysis and visualization using pandas, numpy, matplotlib',
 'data_analysis', 'core_technical', 8, 80.00, 55.00, 130.00, 80, 8, 'exploding'),

('python_automation', 'Python Process Automation', 'Business process automation and scripting',
 'automation', 'core_technical', 8, 70.00, 45.00, 110.00, 60, 9, 'growing'),

('api_development', 'REST API Development', 'Building and maintaining RESTful APIs',
 'api_development', 'core_technical', 9, 85.00, 60.00, 140.00, 100, 9, 'stable'),

('machine_learning', 'Machine Learning Implementation', 'ML model development and deployment',
 'machine_learning', 'core_technical', 7, 95.00, 70.00, 160.00, 200, 7, 'exploding');

-- Insert sample project templates
INSERT INTO project_templates (
    template_name, project_type, business_domain, typical_duration_weeks,
    complexity_level, typical_budget_range, requirements_template,
    deliverables_template, required_skills
) VALUES 
('E-commerce Website Development', 'custom_solution', 'web_development', 6, 7,
 '{"min_budget": 5000, "max_budget": 25000}'::jsonb,
 '{"functional_requirements": ["user_registration", "product_catalog", "shopping_cart", "payment_integration"], "technical_requirements": ["responsive_design", "database_design", "security"]}'::jsonb,
 '{"deliverables": ["fully_functional_website", "admin_panel", "documentation", "deployment_guide", "training_materials"]}'::jsonb,
 (SELECT array_agg(skill_id) FROM freelancer_skills WHERE skill_code IN ('python_web_dev', 'api_development'))
),

('Business Data Analysis Dashboard', 'custom_solution', 'data_analysis', 4, 6,
 '{"min_budget": 3000, "max_budget": 15000}'::jsonb,
 '{"functional_requirements": ["data_integration", "interactive_dashboards", "automated_reporting"], "technical_requirements": ["data_pipeline", "visualization", "performance_optimization"]}'::jsonb,
 '{"deliverables": ["interactive_dashboard", "automated_reports", "data_pipeline", "documentation", "user_training"]}'::jsonb,
 (SELECT array_agg(skill_id) FROM freelancer_skills WHERE skill_code IN ('data_analysis_python', 'python_automation'))
);

-- Final deployment notification
DO $$
BEGIN
    RAISE NOTICE '=== FREELANCER BUSINESS-FOCUSED EDUCATION PLATFORM DEPLOYED ===';
    RAISE NOTICE 'Total Tables: 30 core tables + 3 materialized views';
    RAISE NOTICE 'Total Estimated Fields: ~450 fields across all tables';
    RAISE NOTICE 'Business Focus: Revenue tracking, client project management, skill monetization';
    RAISE NOTICE 'Vector Search: Enabled with business-optimized embeddings';
    RAISE NOTICE 'Row-Level Security: Configured for freelancer data protection';
    RAISE NOTICE 'AI Avatar Roles: 3 business-focused avatars configured';
    RAISE NOTICE 'Business Analytics: 3 materialized views for ROI tracking';
    RAISE NOTICE 'Specialized Functions: 4 business intelligence functions';
    RAISE NOTICE 'Market Intelligence: Skills taxonomy with demand/rate data';
    RAISE NOTICE 'Revenue Attribution: Comprehensive ROI and attribution tracking';
    RAISE NOTICE '=== READY FOR FREELANCER SUCCESS TRACKING ===';
END $$;

-- Refresh materialized views for initial state
SELECT refresh_business_analytics_views();

COMMIT;