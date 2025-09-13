-- ================================================================
-- CONTINUOUS LEARNING ENTHUSIAST - POSTGRESQL SCHEMA
-- Production-Ready Exploration-Driven AI Avatar Learning Platform
-- ================================================================

-- ================================================================
-- EXTENSIONS & PREREQUISITES
-- ================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "tablefunc";
CREATE EXTENSION IF NOT EXISTS "btree_gin";

-- Set timezone for consistent timestamps
SET timezone = 'UTC';

-- ================================================================
-- ENHANCED ENUMS & TYPES FOR CONTINUOUS LEARNING
-- ================================================================

-- Exploration depth levels
CREATE TYPE exploration_depth AS ENUM (
    'surface', 'moderate', 'deep', 'expert', 'research_level'
);

-- Learning modes for flexible exploration
CREATE TYPE learning_mode AS ENUM (
    'discovery', 'comparison', 'deep_dive', 'experimentation', 'synthesis', 'contribution'
);

-- Technology trend status
CREATE TYPE trend_status AS ENUM (
    'emerging', 'rising', 'mainstream', 'mature', 'declining', 'deprecated'
);

-- Exploration session types
CREATE TYPE session_type AS ENUM (
    'quick_exploration', 'focused_research', 'hands_on_experiment', 'comparison_analysis',
    'trend_investigation', 'community_contribution', 'knowledge_synthesis'
);

-- Innovation project stages
CREATE TYPE innovation_stage AS ENUM (
    'ideation', 'research', 'prototyping', 'experimentation', 'refinement', 'showcase', 'open_source'
);

-- Community contribution types
CREATE TYPE contribution_type AS ENUM (
    'blog_post', 'tutorial', 'code_example', 'library_contribution', 'conference_talk',
    'workshop', 'mentorship', 'documentation', 'translation', 'bug_report', 'feature_request'
);

-- Technology ecosystem categories
CREATE TYPE tech_ecosystem AS ENUM (
    'web_frameworks', 'data_science', 'machine_learning', 'cloud_computing', 'devops',
    'databases', 'frontend', 'mobile', 'iot', 'blockchain', 'quantum_computing',
    'edge_computing', 'cybersecurity', 'game_development', 'scientific_computing'
);

-- Knowledge synthesis types
CREATE TYPE synthesis_type AS ENUM (
    'technology_comparison', 'trend_analysis', 'ecosystem_mapping', 'best_practices',
    'architecture_patterns', 'performance_analysis', 'future_predictions'
);

-- Learning outcome types for enthusiasts
CREATE TYPE outcome_type AS ENUM (
    'knowledge_acquired', 'skill_developed', 'project_completed', 'contribution_made',
    'trend_identified', 'connection_discovered', 'innovation_created', 'teaching_delivered'
);

-- ================================================================
-- 1. CONTINUOUS LEARNING ENTHUSIAST PERSONA & USER MANAGEMENT
-- ================================================================

CREATE TABLE enthusiast_profiles (
    profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE, -- Links to external user system
    
    -- Enthusiast characteristics
    current_expertise_level VARCHAR(50) DEFAULT 'intermediate', -- 'beginner', 'intermediate', 'advanced', 'expert'
    primary_focus_areas tech_ecosystem[], -- Areas of primary interest
    exploration_style learning_mode[] DEFAULT ARRAY['discovery', 'experimentation']::learning_mode[],
    preferred_session_duration INTEGER DEFAULT 25, -- Minutes
    
    -- Learning preferences and goals
    learning_objectives JSONB, -- Flexible goals and interests
    curiosity_drivers JSONB, -- What motivates their learning
    knowledge_sharing_goals JSONB, -- Community contribution aspirations
    innovation_interests JSONB, -- Types of innovation projects they want to explore
    
    -- Technology tracking preferences
    trend_following_areas tech_ecosystem[], -- Ecosystems they track
    emerging_tech_interest_level INTEGER DEFAULT 8, -- 1-10 scale
    experimental_risk_tolerance VARCHAR(20) DEFAULT 'high', -- 'low', 'moderate', 'high', 'very_high'
    cutting_edge_adoption_speed VARCHAR(20) DEFAULT 'early_adopter', -- 'conservative', 'mainstream', 'early_adopter', 'bleeding_edge'
    
    -- Time and availability
    available_hours_per_week INTEGER DEFAULT 3,
    flexible_scheduling BOOLEAN DEFAULT true,
    deep_dive_availability INTEGER DEFAULT 4, -- Hours per month for deep dives
    
    -- Community engagement preferences
    knowledge_sharing_frequency VARCHAR(20) DEFAULT 'weekly', -- 'daily', 'weekly', 'monthly', 'occasional'
    mentorship_interest BOOLEAN DEFAULT true,
    conference_participation BOOLEAN DEFAULT false,
    open_source_contribution_level VARCHAR(20) DEFAULT 'moderate', -- 'minimal', 'moderate', 'active', 'maintainer'
    
    -- Platform engagement metrics
    exploration_streak_days INTEGER DEFAULT 0,
    contribution_points INTEGER DEFAULT 0,
    community_reputation_score DECIMAL(5,2) DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Technology ecosystem definitions and trends
CREATE TABLE technology_ecosystems (
    ecosystem_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ecosystem_name tech_ecosystem NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    
    -- Ecosystem characteristics
    maturity_level VARCHAR(20), -- 'emerging', 'growing', 'mature', 'declining'
    innovation_velocity VARCHAR(20), -- 'slow', 'moderate', 'fast', 'very_fast'
    learning_curve VARCHAR(20), -- 'easy', 'moderate', 'steep', 'expert'
    market_adoption VARCHAR(20), -- 'niche', 'growing', 'mainstream', 'ubiquitous'
    
    -- Key technologies and trends
    core_technologies JSONB, -- Main technologies in this ecosystem
    emerging_technologies JSONB, -- New and emerging tech
    trending_libraries JSONB, -- Popular libraries and frameworks
    key_concepts JSONB, -- Important concepts to understand
    
    -- Learning resources and paths
    recommended_starting_points JSONB, -- Where to begin exploration
    essential_skills JSONB, -- Core skills needed
    advanced_topics JSONB, -- Deep-dive opportunities
    experimentation_ideas JSONB, -- Project ideas for hands-on learning
    
    -- Community and contribution opportunities
    major_conferences JSONB, -- Key conferences and events
    influential_figures JSONB, -- Thought leaders and experts
    contribution_opportunities JSONB, -- Ways to contribute back
    learning_communities JSONB, -- Forums, Discord, etc.
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Technology trend tracking
CREATE TABLE technology_trends (
    trend_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ecosystem_id UUID NOT NULL REFERENCES technology_ecosystems(ecosystem_id),
    
    trend_name VARCHAR(200) NOT NULL,
    trend_description TEXT,
    trend_status trend_status NOT NULL,
    
    -- Trend metrics
    momentum_score INTEGER DEFAULT 5, -- 1-10 scale
    adoption_rate VARCHAR(20), -- 'slow', 'moderate', 'rapid', 'explosive'
    market_impact_prediction INTEGER DEFAULT 5, -- 1-10 scale
    learning_priority_score INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Trend data sources
    github_stars INTEGER,
    stackoverflow_questions INTEGER,
    job_postings_count INTEGER,
    conference_mentions INTEGER,
    blog_post_mentions INTEGER,
    
    -- Timeline and predictions
    first_detected_date DATE,
    peak_prediction_date DATE,
    maturity_timeline_months INTEGER,
    
    -- Related technologies
    related_trends JSONB, -- Related trend IDs and relationships
    prerequisite_knowledge JSONB, -- What you need to know first
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_momentum_score CHECK (momentum_score BETWEEN 1 AND 10),
    CONSTRAINT chk_impact_prediction CHECK (market_impact_prediction BETWEEN 1 AND 10),
    CONSTRAINT chk_priority_score CHECK (learning_priority_score BETWEEN 1 AND 10)
);

-- ================================================================
-- 2. EXPLORATION-DRIVEN CURRICULUM HIERARCHY
-- ================================================================

-- Level 1: Exploration Domains (Flexible topic areas)
CREATE TABLE exploration_domains (
    domain_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    domain_code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Domain characteristics
    ecosystem_category tech_ecosystem NOT NULL,
    exploration_complexity exploration_depth DEFAULT 'moderate',
    recommended_prerequisites JSONB,
    
    -- Flexible learning paths
    discovery_pathways JSONB, -- Different ways to explore this domain
    experimentation_opportunities JSONB, -- Hands-on project ideas
    comparison_opportunities JSONB, -- Technologies to compare
    deep_dive_suggestions JSONB, -- Advanced exploration areas
    
    -- Innovation and contribution potential
    innovation_potential INTEGER DEFAULT 5, -- 1-10 scale
    contribution_opportunities JSONB, -- Ways to contribute back
    community_connections JSONB, -- Related communities
    
    -- Trend alignment
    trend_relevance INTEGER DEFAULT 5, -- 1-10 scale
    future_outlook VARCHAR(20), -- 'declining', 'stable', 'growing', 'explosive'
    
    -- Metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    is_active BOOLEAN DEFAULT true,
    
    CONSTRAINT chk_innovation_potential CHECK (innovation_potential BETWEEN 1 AND 10),
    CONSTRAINT chk_trend_relevance CHECK (trend_relevance BETWEEN 1 AND 10)
);

-- Level 2: Exploration Topics (Specific areas within domains)
CREATE TABLE exploration_topics (
    topic_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    domain_id UUID NOT NULL REFERENCES exploration_domains(domain_id) ON DELETE CASCADE,
    topic_code VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Topic characteristics
    exploration_modes learning_mode[] DEFAULT ARRAY['discovery']::learning_mode[],
    depth_levels exploration_depth[] DEFAULT ARRAY['moderate']::exploration_depth[],
    estimated_exploration_time_minutes INTEGER DEFAULT 30,
    
    -- Flexibility and options
    quick_exploration_summary TEXT, -- 5-minute overview
    focused_exploration_guide TEXT, -- 30-minute deep dive
    hands_on_experiments JSONB, -- Practical exercises
    comparison_frameworks JSONB, -- How to compare with alternatives
    
    -- Innovation and experimentation
    experimental_ideas JSONB, -- Creative project suggestions
    combination_opportunities JSONB, -- How to combine with other technologies
    research_questions JSONB, -- Open questions worth investigating
    
    -- Community and contribution
    expert_insights JSONB, -- Insights from domain experts
    contribution_starting_points JSONB, -- How beginners can contribute
    learning_resources JSONB, -- Curated external resources
    
    -- Trend and future relevance
    current_trend_alignment INTEGER DEFAULT 5, -- 1-10 scale
    future_potential INTEGER DEFAULT 5, -- 1-10 scale
    skill_transferability INTEGER DEFAULT 5, -- 1-10 scale
    
    order_index INTEGER DEFAULT 100, -- For suggested exploration order
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(domain_id, topic_code),
    CONSTRAINT chk_trend_alignment CHECK (current_trend_alignment BETWEEN 1 AND 10),
    CONSTRAINT chk_future_potential CHECK (future_potential BETWEEN 1 AND 10),
    CONSTRAINT chk_skill_transferability CHECK (skill_transferability BETWEEN 1 AND 10)
);

-- Level 3: Exploration Units (Atomic learning/discovery units)
CREATE TABLE exploration_units (
    unit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id UUID NOT NULL REFERENCES exploration_topics(topic_id) ON DELETE CASCADE,
    unit_code VARCHAR(100) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Unit type and approach
    primary_mode learning_mode NOT NULL,
    depth_level exploration_depth DEFAULT 'moderate',
    estimated_duration_minutes INTEGER DEFAULT 15,
    
    -- Flexible exploration options
    quick_overview TEXT, -- 2-minute summary
    exploration_activities JSONB, -- Suggested activities
    experimentation_ideas JSONB, -- Ways to experiment
    discussion_prompts JSONB, -- Questions to consider/discuss
    
    -- Resources and tools
    required_tools JSONB, -- Tools/software needed
    optional_tools JSONB, -- Additional tools that could help
    external_resources JSONB, -- Links to documentation, tutorials, etc.
    
    -- Innovation potential
    creative_applications JSONB, -- Creative ways to apply this
    combination_potential JSONB, -- What to combine this with
    research_opportunities JSONB, -- Research directions
    
    -- Learning outcomes
    key_insights JSONB, -- Main takeaways
    skill_development JSONB, -- Skills this develops
    knowledge_connections JSONB, -- How this connects to other areas
    
    order_index INTEGER DEFAULT 100,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(topic_id, unit_code),
    CONSTRAINT chk_unit_duration CHECK (estimated_duration_minutes BETWEEN 1 AND 180)
);

-- ================================================================
-- 3. FLEXIBLE CONTENT MANAGEMENT FOR EXPLORATION
-- ================================================================

-- Exploration-focused content chunks
CREATE TABLE exploration_content (
    content_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES exploration_units(unit_id) ON DELETE CASCADE,
    
    -- Content identification
    external_id VARCHAR(100) UNIQUE,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    content_type VARCHAR(50) NOT NULL, -- 'overview', 'tutorial', 'experiment', 'comparison', 'analysis'
    format VARCHAR(50) DEFAULT 'markdown', -- 'markdown', 'html', 'jupyter', 'interactive', 'video'
    
    -- Content storage
    content_markdown TEXT,
    content_html TEXT,
    content_json JSONB,
    interactive_elements JSONB, -- Code snippets, demos, etc.
    
    -- Exploration-specific metadata
    exploration_mode learning_mode NOT NULL,
    depth_level exploration_depth NOT NULL,
    estimated_time_minutes INTEGER,
    complexity_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Trend and innovation relevance
    trend_alignment INTEGER DEFAULT 5, -- 1-10 scale
    innovation_potential INTEGER DEFAULT 5, -- 1-10 scale
    experimentation_value INTEGER DEFAULT 5, -- 1-10 scale
    knowledge_synthesis_value INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Technology ecosystem alignment
    ecosystem_tags tech_ecosystem[],
    technology_keywords TEXT[],
    skill_tags TEXT[],
    concept_tags TEXT[],
    
    -- Flexibility features
    quick_reference TEXT, -- Key points for quick reference
    deep_dive_extensions JSONB, -- How to go deeper
    related_explorations JSONB, -- Connected exploration opportunities
    prerequisite_knowledge JSONB, -- What you should know first
    
    -- Community and contribution
    discussion_questions JSONB, -- Questions to think about/discuss
    contribution_opportunities TEXT, -- Ways to contribute back
    expert_perspectives JSONB, -- Insights from domain experts
    community_resources JSONB, -- Related community content
    
    -- Quality and validation
    peer_rating DECIMAL(3,2), -- Community rating
    expert_validation BOOLEAN DEFAULT false,
    last_updated TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    update_frequency_days INTEGER, -- How often to review for updates
    
    -- Search and discovery
    search_keywords TEXT[],
    discovery_tags TEXT[], -- Tags for content discovery
    recommendation_weight INTEGER DEFAULT 5, -- For recommendation algorithms
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_complexity_rating CHECK (complexity_rating BETWEEN 1 AND 10),
    CONSTRAINT chk_trend_alignment CHECK (trend_alignment BETWEEN 1 AND 10),
    CONSTRAINT chk_innovation_potential CHECK (innovation_potential BETWEEN 1 AND 10)
);

-- Technology comparison frameworks
CREATE TABLE technology_comparisons (
    comparison_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES exploration_content(content_id) ON DELETE CASCADE,
    
    comparison_title VARCHAR(300) NOT NULL,
    comparison_description TEXT,
    ecosystem_category tech_ecosystem NOT NULL,
    
    -- Technologies being compared
    technologies_compared JSONB NOT NULL, -- Array of technologies with details
    comparison_criteria JSONB NOT NULL, -- Criteria used for comparison
    
    -- Comparison results
    detailed_analysis JSONB, -- Detailed comparison results
    summary_recommendations TEXT, -- High-level recommendations
    use_case_recommendations JSONB, -- When to use each technology
    
    -- Context and methodology
    comparison_methodology TEXT,
    testing_environment JSONB, -- Environment used for testing
    benchmark_results JSONB, -- Performance benchmarks if applicable
    
    -- Maintenance and updates
    last_verified_date DATE,
    needs_update BOOLEAN DEFAULT false,
    update_notes TEXT,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Innovation project templates and ideas
CREATE TABLE innovation_projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES exploration_content(content_id) ON DELETE CASCADE,
    
    project_title VARCHAR(300) NOT NULL,
    project_description TEXT NOT NULL,
    innovation_type VARCHAR(50), -- 'prototype', 'experiment', 'tool', 'library', 'application'
    
    -- Project scope and complexity
    difficulty_level exploration_depth NOT NULL,
    estimated_time_hours INTEGER,
    required_skills JSONB,
    optional_skills JSONB,
    
    -- Technologies and tools
    primary_technologies JSONB NOT NULL,
    supporting_technologies JSONB,
    development_tools JSONB,
    
    -- Project structure
    project_phases JSONB, -- Suggested phases/milestones
    deliverables JSONB, -- Expected outputs
    success_criteria JSONB, -- How to measure success
    
    -- Innovation aspects
    novel_combinations JSONB, -- Interesting technology combinations
    creative_applications JSONB, -- Creative use cases
    research_directions JSONB, -- Potential research opportunities
    
    -- Community and sharing
    open_source_potential BOOLEAN DEFAULT true,
    collaboration_opportunities TEXT,
    presentation_ideas JSONB, -- How to present/share results
    
    -- Extensions and variations
    project_variations JSONB, -- Alternative approaches
    extension_ideas JSONB, -- How to extend the project
    combination_opportunities JSONB, -- Other projects to combine with
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_estimated_time CHECK (estimated_time_hours > 0)
);

-- ================================================================
-- 4. EXPLORATION SESSION & ACTIVITY TRACKING
-- ================================================================

-- User exploration sessions
CREATE TABLE exploration_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Session details
    session_type session_type NOT NULL,
    session_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    planned_duration_minutes INTEGER,
    actual_duration_minutes INTEGER,
    
    -- Session focus
    primary_ecosystem tech_ecosystem,
    exploration_mode learning_mode NOT NULL,
    session_objectives JSONB, -- What they wanted to accomplish
    
    -- Content explored
    domains_explored UUID[], -- Array of domain IDs
    topics_explored UUID[], -- Array of topic IDs  
    units_completed UUID[], -- Array of unit IDs
    content_consumed UUID[], -- Array of content IDs
    
    -- Session activities
    experiments_conducted JSONB, -- Hands-on experiments performed
    comparisons_made JSONB, -- Technology comparisons completed
    notes_taken TEXT, -- Session notes
    discoveries_made JSONB, -- New insights or discoveries
    
    -- Innovation and creativity
    ideas_generated JSONB, -- Project or research ideas
    connections_identified JSONB, -- Connections between technologies
    questions_raised JSONB, -- Questions that came up
    
    -- Follow-up planning
    next_explorations JSONB, -- What to explore next
    deep_dive_candidates JSONB, -- Topics for future deep dives
    contribution_ideas JSONB, -- Ideas for community contribution
    
    -- Engagement metrics
    engagement_level INTEGER DEFAULT 5, -- 1-10 scale
    satisfaction_rating INTEGER DEFAULT 5, -- 1-10 scale
    knowledge_gained_rating INTEGER DEFAULT 5, -- 1-10 scale
    inspiration_level INTEGER DEFAULT 5, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_engagement_metrics CHECK (
        engagement_level BETWEEN 1 AND 10 AND
        satisfaction_rating BETWEEN 1 AND 10 AND
        knowledge_gained_rating BETWEEN 1 AND 10 AND
        inspiration_level BETWEEN 1 AND 10
    )
);

-- Deep dive exploration tracking
CREATE TABLE deep_dive_explorations (
    deep_dive_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Deep dive details
    topic_id UUID REFERENCES exploration_topics(topic_id),
    deep_dive_title VARCHAR(300) NOT NULL,
    exploration_question TEXT, -- The question driving the exploration
    hypothesis_or_goal TEXT, -- What they expect to find or achieve
    
    -- Timeline
    started_date DATE NOT NULL,
    planned_completion_date DATE,
    actual_completion_date DATE,
    total_hours_invested INTEGER DEFAULT 0,
    
    -- Exploration approach
    exploration_methodology TEXT,
    resources_used JSONB, -- Books, papers, tutorials, etc.
    tools_and_technologies JSONB, -- Tools used in exploration
    experiments_designed JSONB, -- Experiments they designed
    
    -- Findings and insights
    key_discoveries JSONB, -- Major discoveries or insights
    unexpected_findings JSONB, -- Surprises along the way
    challenges_encountered JSONB, -- Difficulties faced
    solutions_found JSONB, -- How they overcame challenges
    
    -- Knowledge synthesis
    connections_made JSONB, -- Connections to other areas
    mental_model_changes TEXT, -- How their understanding changed
    new_questions_raised JSONB, -- New questions that emerged
    future_research_directions JSONB, -- Where to go next
    
    -- Outputs and contributions
    documentation_created TEXT, -- Notes, reports, documentation
    code_repositories JSONB, -- Code repositories created
    blog_posts_written JSONB, -- Blog posts or articles
    presentations_given JSONB, -- Talks or presentations
    contributions_made JSONB, -- Open source contributions
    
    -- Impact and value
    personal_value_rating INTEGER DEFAULT 5, -- 1-10 scale
    community_impact_potential INTEGER DEFAULT 5, -- 1-10 scale
    follow_up_projects_spawned JSONB, -- Projects that grew from this
    
    -- Status tracking
    status VARCHAR(20) DEFAULT 'in_progress', -- 'planned', 'in_progress', 'completed', 'paused', 'abandoned'
    completion_percentage INTEGER DEFAULT 0,
    sharing_readiness BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_completion_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_value_ratings CHECK (
        personal_value_rating BETWEEN 1 AND 10 AND
        community_impact_potential BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 5. INNOVATION PROJECT MANAGEMENT
-- ================================================================

-- User innovation projects
CREATE TABLE user_innovation_projects (
    user_project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    template_id UUID REFERENCES innovation_projects(project_id),
    
    -- Project identification
    project_name VARCHAR(300) NOT NULL,
    project_description TEXT NOT NULL,
    innovation_stage innovation_stage DEFAULT 'ideation',
    
    -- Project scope and approach
    original_idea TEXT, -- The original inspiration
    innovation_approach TEXT, -- How they're approaching innovation
    technologies_chosen JSONB, -- Technologies they decided to use
    unique_angle TEXT, -- What makes their approach unique
    
    -- Timeline and progress
    started_date DATE NOT NULL,
    target_completion_date DATE,
    last_activity_date DATE,
    hours_invested INTEGER DEFAULT 0,
    progress_milestones JSONB, -- Milestones achieved
    
    -- Development tracking
    repository_url TEXT, -- Git repository
    demo_url TEXT, -- Live demo link
    documentation_url TEXT, -- Documentation
    current_status TEXT, -- Current development status
    
    -- Innovation aspects
    novel_combinations JSONB, -- Unique technology combinations used
    creative_solutions JSONB, -- Creative solutions developed
    research_contributions JSONB, -- Research insights gained
    
    -- Learning and insights
    skills_developed JSONB, -- New skills acquired
    knowledge_gained JSONB, -- Knowledge insights
    challenges_overcome JSONB, -- Problems solved
    lessons_learned TEXT, -- Key lessons
    
    -- Community and sharing
    collaboration_partners JSONB, -- People who helped or collaborated
    community_feedback JSONB, -- Feedback received
    presentation_opportunities JSONB, -- Where it was presented
    open_source_contributions JSONB, -- OSS contributions made
    
    -- Impact and outcomes
    personal_satisfaction_rating INTEGER DEFAULT 5, -- 1-10 scale
    learning_value_rating INTEGER DEFAULT 5, -- 1-10 scale
    innovation_impact_rating INTEGER DEFAULT 5, -- 1-10 scale
    community_response_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Future directions
    next_steps JSONB, -- Planned next steps
    extension_ideas JSONB, -- Ways to extend the project
    spin_off_opportunities JSONB, -- Other projects this could spawn
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_satisfaction_ratings CHECK (
        personal_satisfaction_rating BETWEEN 1 AND 10 AND
        learning_value_rating BETWEEN 1 AND 10 AND
        innovation_impact_rating BETWEEN 1 AND 10 AND
        community_response_rating BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 6. COMMUNITY CONTRIBUTION & KNOWLEDGE SHARING
-- ================================================================

-- Community contributions tracking
CREATE TABLE community_contributions (
    contribution_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Contribution details
    contribution_type contribution_type NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT NOT NULL,
    
    -- Content and links
    content_url TEXT, -- Link to blog post, repository, etc.
    presentation_url TEXT, -- Link to slides or recording
    repository_url TEXT, -- Git repository if applicable
    demonstration_url TEXT, -- Demo or live example
    
    -- Scope and impact
    target_audience VARCHAR(100), -- Who this is for
    technology_focus tech_ecosystem[],
    skill_level_target exploration_depth DEFAULT 'moderate',
    
    -- Effort and quality
    time_invested_hours INTEGER DEFAULT 1,
    quality_self_rating INTEGER DEFAULT 5, -- 1-10 scale
    effort_level INTEGER DEFAULT 5, -- 1-10 scale
    originality_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Community response
    views_or_downloads INTEGER DEFAULT 0,
    likes_or_stars INTEGER DEFAULT 0,
    comments_or_feedback INTEGER DEFAULT 0,
    shares_or_forks INTEGER DEFAULT 0,
    community_rating DECIMAL(3,2), -- Average community rating
    
    -- Impact tracking
    helped_users_count INTEGER DEFAULT 0,
    spawned_discussions_count INTEGER DEFAULT 0,
    follow_up_contributions_count INTEGER DEFAULT 0,
    
    -- Learning and growth
    skills_used JSONB, -- Skills applied in this contribution
    new_skills_developed JSONB, -- Skills developed while creating
    feedback_received JSONB, -- Feedback from community
    lessons_learned TEXT, -- What they learned from the process
    
    -- Recognition and outcomes
    featured_or_highlighted BOOLEAN DEFAULT false,
    conference_acceptance BOOLEAN DEFAULT false,
    job_opportunities_generated INTEGER DEFAULT 0,
    collaboration_opportunities JSONB, -- New collaborations formed
    
    -- Publication and sharing dates
    created_date DATE NOT NULL,
    published_date DATE,
    last_updated_date DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_quality_ratings CHECK (
        quality_self_rating BETWEEN 1 AND 10 AND
        effort_level BETWEEN 1 AND 10 AND
        originality_rating BETWEEN 1 AND 10
    )
);

-- Knowledge synthesis and comparison projects
CREATE TABLE knowledge_synthesis_projects (
    synthesis_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Synthesis project details
    synthesis_type synthesis_type NOT NULL,
    project_title VARCHAR(300) NOT NULL,
    research_question TEXT NOT NULL,
    methodology_description TEXT,
    
    -- Scope and focus
    technologies_analyzed JSONB, -- Technologies being synthesized/compared
    ecosystem_focus tech_ecosystem[],
    time_period_analyzed VARCHAR(100), -- E.g., "2023-2024", "Last 5 years"
    
    -- Research and analysis
    data_sources_used JSONB, -- Where they got information
    analysis_framework JSONB, -- How they structured the analysis
    key_findings JSONB, -- Main discoveries
    surprising_insights JSONB, -- Unexpected discoveries
    
    -- Synthesis outputs
    summary_document TEXT, -- Executive summary
    detailed_analysis TEXT, -- Full analysis
    visual_representations JSONB, -- Charts, diagrams, etc.
    recommendations JSONB, -- Actionable recommendations
    
    -- Predictions and future outlook
    trend_predictions JSONB, -- What they predict will happen
    confidence_levels JSONB, -- How confident they are in predictions
    factors_to_watch JSONB, -- Key indicators to monitor
    
    -- Timeline and effort
    research_start_date DATE,
    analysis_completion_date DATE,
    total_research_hours INTEGER DEFAULT 0,
    
    -- Validation and peer review
    peer_reviewers JSONB, -- People who reviewed this
    expert_validation JSONB, -- Expert opinions sought
    community_feedback JSONB, -- Community response
    accuracy_tracking JSONB, -- How predictions turned out
    
    -- Impact and sharing
    sharing_channels JSONB, -- Where this was shared
    citations_or_references INTEGER DEFAULT 0,
    influenced_decisions JSONB, -- Decisions this influenced
    follow_up_research JSONB, -- Research this inspired
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 7. AI AVATAR SYSTEM FOR EXPLORATION LEARNING
-- ================================================================

-- AI Avatar roles optimized for exploration learning
CREATE TABLE exploration_avatar_roles (
    role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    role_description TEXT NOT NULL,
    
    -- Role characteristics for exploration learning
    interaction_style JSONB, -- How the avatar interacts
    exploration_guidance_style VARCHAR(50), -- 'discovery_focused', 'comparison_oriented', 'synthesis_driven'
    curiosity_stimulation_approach VARCHAR(50), -- 'questioning', 'challenging', 'inspiring'
    
    -- Specialized capabilities
    trend_analysis_capabilities JSONB, -- Trend spotting and analysis
    innovation_coaching_abilities JSONB, -- Innovation and creativity guidance
    community_connection_skills JSONB, -- Connecting to communities
    knowledge_synthesis_expertise JSONB, -- Synthesis and comparison skills
    
    -- Enthusiast-specific features
    cutting_edge_knowledge BOOLEAN DEFAULT true, -- Keeps up with latest trends
    experimental_mindset BOOLEAN DEFAULT true, -- Encourages experimentation
    community_orientation BOOLEAN DEFAULT true, -- Promotes community engagement
    synthesis_focus BOOLEAN DEFAULT true, -- Emphasizes connecting ideas
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Avatar content variations for exploration modes
CREATE TABLE exploration_content_variations (
    variation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES exploration_content(content_id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES exploration_avatar_roles(role_id) ON DELETE CASCADE,
    
    -- Exploration mode customizations
    discovery_guidance TEXT, -- How to guide discovery
    experimentation_suggestions JSONB, -- Experimentation ideas
    comparison_frameworks JSONB, -- How to compare technologies
    synthesis_approaches JSONB, -- Ways to synthesize knowledge
    
    -- Community connection elements
    discussion_starters JSONB, -- Questions to spark discussion
    sharing_encouragement TEXT, -- How to encourage sharing
    collaboration_suggestions JSONB, -- Collaboration opportunities
    contribution_ideas JSONB, -- Ways to contribute back
    
    -- Innovation and creativity prompts
    creative_applications JSONB, -- Creative ways to apply knowledge
    combination_suggestions JSONB, -- Technologies to combine
    research_directions JSONB, -- Research opportunities to explore
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, role_id)
);

-- ================================================================
-- 8. ENHANCED USER PROGRESS & EXPLORATION ANALYTICS
-- ================================================================

-- Flexible progress tracking for exploration learning
CREATE TABLE exploration_progress (
    progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    unit_id UUID NOT NULL REFERENCES exploration_units(unit_id) ON DELETE CASCADE,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Progress tracking
    exploration_status VARCHAR(20) DEFAULT 'not_started', -- 'not_started', 'exploring', 'experimenting', 'synthesizing', 'completed', 'mastered'
    depth_achieved exploration_depth DEFAULT 'surface',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Exploration modes used
    modes_explored learning_mode[], -- Which exploration modes were used
    time_spent_minutes INTEGER DEFAULT 0,
    session_count INTEGER DEFAULT 0,
    
    -- Learning outcomes
    insights_gained JSONB, -- Key insights discovered
    connections_made JSONB, -- Connections to other areas
    questions_raised JSONB, -- Questions that emerged
    experiments_conducted JSONB, -- Experiments performed
    
    -- Innovation and creativity
    ideas_generated JSONB, -- Creative ideas spawned
    projects_initiated JSONB, -- Projects started from this
    contributions_made JSONB, -- Community contributions inspired
    
    -- Knowledge synthesis
    comparisons_completed JSONB, -- Technology comparisons made
    synthesis_attempts JSONB, -- Knowledge synthesis efforts
    teaching_opportunities JSONB, -- Times they taught others
    
    -- Engagement metrics
    curiosity_level INTEGER DEFAULT 5, -- 1-10 scale
    satisfaction_rating INTEGER DEFAULT 5, -- 1-10 scale
    innovation_inspiration INTEGER DEFAULT 5, -- 1-10 scale
    sharing_likelihood INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Timeline tracking
    first_explored_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    last_activity_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    mastery_achieved_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, unit_id),
    CONSTRAINT chk_completion_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_engagement_ratings CHECK (
        curiosity_level BETWEEN 1 AND 10 AND
        satisfaction_rating BETWEEN 1 AND 10 AND
        innovation_inspiration BETWEEN 1 AND 10 AND
        sharing_likelihood BETWEEN 1 AND 10
    )
);

-- Technology expertise tracking
CREATE TABLE technology_expertise (
    expertise_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Technology identification
    technology_name VARCHAR(200) NOT NULL,
    ecosystem_category tech_ecosystem NOT NULL,
    technology_version VARCHAR(50), -- Specific version if applicable
    
    -- Expertise level and development
    current_expertise_level exploration_depth DEFAULT 'surface',
    learning_trajectory JSONB, -- How expertise developed over time
    confidence_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Experience breadth and depth
    use_cases_explored JSONB, -- Different ways they've used it
    projects_completed INTEGER DEFAULT 0,
    hours_of_experience INTEGER DEFAULT 0,
    
    -- Community involvement
    content_created_count INTEGER DEFAULT 0,
    questions_answered INTEGER DEFAULT 0,
    contributions_made INTEGER DEFAULT 0,
    presentations_given INTEGER DEFAULT 0,
    
    -- Knowledge depth indicators
    advanced_features_used JSONB, -- Advanced features they've used
    edge_cases_encountered JSONB, -- Edge cases they've handled
    performance_optimizations JSONB, -- Optimizations they've done
    troubleshooting_expertise JSONB, -- Problems they can solve
    
    -- Trend awareness
    version_migration_experience JSONB, -- Migrations they've done
    emerging_features_tracking JSONB, -- New features they're following
    ecosystem_changes_awareness JSONB, -- Ecosystem changes they track
    
    -- Teaching and mentoring
    teaching_opportunities INTEGER DEFAULT 0,
    mentoring_provided INTEGER DEFAULT 0,
    knowledge_sharing_frequency VARCHAR(20), -- 'never', 'rarely', 'sometimes', 'often', 'regularly'
    
    -- Validation and recognition
    community_recognition JSONB, -- Recognition received
    expert_endorsements JSONB, -- Endorsements from experts
    certifications JSONB, -- Relevant certifications
    
    -- Timeline tracking
    first_encountered_date DATE,
    last_used_date DATE,
    expertise_peak_date DATE, -- When they felt most expert
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, technology_name, ecosystem_category),
    CONSTRAINT chk_confidence_rating CHECK (confidence_rating BETWEEN 1 AND 10)
);

-- ================================================================
-- 9. TREND ANALYSIS & FUTURE PREDICTION SYSTEM
-- ================================================================

-- User trend analysis projects
CREATE TABLE trend_analysis_projects (
    analysis_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    profile_id UUID NOT NULL REFERENCES enthusiast_profiles(profile_id),
    
    -- Analysis scope
    analysis_title VARCHAR(300) NOT NULL,
    research_question TEXT NOT NULL,
    ecosystem_focus tech_ecosystem[],
    time_horizon VARCHAR(50), -- '6 months', '1 year', '3 years', etc.
    
    -- Methodology
    data_sources JSONB, -- Where they got trend data
    analysis_methods JSONB, -- How they analyzed trends
    validation_approaches JSONB, -- How they validated findings
    
    -- Trend findings
    emerging_trends_identified JSONB, -- New trends they spotted
    declining_trends_identified JSONB, -- Trends losing momentum
    trend_convergences JSONB, -- Trends coming together
    disruptive_potential JSONB, -- Potentially disruptive changes
    
    -- Predictions and forecasts
    short_term_predictions JSONB, -- 6-12 month predictions
    medium_term_predictions JSONB, -- 1-3 year predictions
    long_term_predictions JSONB, -- 3+ year predictions
    confidence_levels JSONB, -- Confidence in each prediction
    
    -- Implications and recommendations
    industry_implications JSONB, -- What this means for industry
    learning_recommendations JSONB, -- What developers should learn
    investment_suggestions JSONB, -- Where to invest time/effort
    risk_assessments JSONB, -- Potential risks and mitigation
    
    -- Validation and accuracy tracking
    peer_review_feedback JSONB, -- Feedback from peers
    expert_opinions JSONB, -- Expert validation
    prediction_accuracy_tracking JSONB, -- How predictions turned out
    
    -- Impact and sharing
    publication_channels JSONB, -- Where analysis was shared
    community_response JSONB, -- How community responded
    influenced_decisions JSONB, -- Decisions this influenced
    citations_received INTEGER DEFAULT 0,
    
    -- Timeline
    research_period_start DATE,
    research_period_end DATE,
    analysis_completion_date DATE,
    first_publication_date DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ================================================================
-- 10. VECTOR EMBEDDINGS & SEMANTIC SEARCH FOR EXPLORATION
-- ================================================================

-- Enhanced embedding models for exploration content
CREATE TABLE exploration_embedding_models (
    model_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(200) NOT NULL UNIQUE,
    model_version VARCHAR(50),
    provider VARCHAR(100),
    embedding_dimensions INTEGER NOT NULL,
    context_window INTEGER,
    
    -- Exploration-specific optimizations
    trend_analysis_optimized BOOLEAN DEFAULT false,
    technology_comparison_trained BOOLEAN DEFAULT false,
    innovation_pattern_recognition BOOLEAN DEFAULT false,
    community_content_aligned BOOLEAN DEFAULT false,
    
    -- Model characteristics
    update_frequency_days INTEGER DEFAULT 30,
    specialization_areas tech_ecosystem[],
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    is_default BOOLEAN DEFAULT false,
    
    CONSTRAINT chk_embedding_dims_positive CHECK (embedding_dimensions > 0)
);

-- Semantic embeddings for exploration content
CREATE TABLE exploration_content_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES exploration_content(content_id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES exploration_embedding_models(model_id),
    
    -- Vector embeddings
    content_vector vector NOT NULL,
    trend_relevance_vector vector, -- Trend-specific embedding
    innovation_potential_vector vector, -- Innovation-specific embedding
    technology_concept_vector vector, -- Technology concept embedding
    
    -- Embedding metadata
    content_hash TEXT NOT NULL,
    token_count INTEGER,
    generation_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    -- Exploration-specific metadata
    trend_keywords JSONB, -- Keywords related to trends
    innovation_keywords JSONB, -- Keywords related to innovation
    technology_keywords JSONB, -- Technology-specific keywords
    concept_relationships JSONB, -- Related concepts and connections
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, model_id)
);

-- ================================================================
-- 11. MATERIALIZED VIEWS FOR EXPLORATION ANALYTICS
-- ================================================================

-- User exploration analytics
CREATE MATERIALIZED VIEW mv_user_exploration_analytics AS
SELECT 
    ep.user_id,
    ep.profile_id,
    
    -- Overall exploration metrics
    COUNT(DISTINCT es.session_id) as total_exploration_sessions,
    COUNT(DISTINCT dde.deep_dive_id) as deep_dives_completed,
    COUNT(DISTINCT cc.contribution_id) as community_contributions,
    COUNT(DISTINCT uip.user_project_id) as innovation_projects,
    
    -- Time and engagement
    AVG(es.actual_duration_minutes) as avg_session_duration,
    SUM(es.actual_duration_minutes) as total_exploration_time,
    AVG(es.engagement_level) as avg_engagement_level,
    MAX(es.session_date) as last_exploration_date,
    
    -- Exploration breadth and depth
    COUNT(DISTINCT es.primary_ecosystem) as ecosystems_explored,
    array_agg(DISTINCT es.primary_ecosystem) as ecosystems_list,
    AVG(CASE WHEN ep2.depth_achieved = 'deep' THEN 1 ELSE 0 END) as deep_exploration_rate,
    
    -- Innovation and creativity
    COUNT(DISTINCT uip.user_project_id) as innovation_projects_started,
    COUNT(DISTINCT CASE WHEN uip.innovation_stage = 'showcase' THEN uip.user_project_id END) as projects_showcased,
    AVG(uip.innovation_impact_rating) as avg_innovation_impact,
    
    -- Community engagement
    COUNT(DISTINCT cc.contribution_id) as total_contributions,
    SUM(cc.views_or_downloads) as total_content_views,
    SUM(cc.likes_or_stars) as total_community_appreciation,
    AVG(cc.community_rating) as avg_contribution_quality,
    
    -- Knowledge synthesis
    COUNT(DISTINCT ksp.synthesis_id) as synthesis_projects_completed,
    COUNT(DISTINCT tap.analysis_id) as trend_analyses_completed,
    COUNT(DISTINCT tc.comparison_id) as technology_comparisons_made,
    
    -- Learning velocity and consistency
    COUNT(es.session_id) / NULLIF(EXTRACT(days FROM (MAX(es.session_date) - MIN(es.session_date))), 0) as exploration_frequency,
    ep.exploration_streak_days,
    ep.contribution_points,
    ep.community_reputation_score,
    
    -- Last updated
    MAX(GREATEST(es.session_date, dde.updated_at, cc.updated_at, uip.updated_at)) as last_activity
    
FROM enthusiast_profiles ep
LEFT JOIN exploration_sessions es ON ep.user_id = es.user_id
LEFT JOIN deep_dive_explorations dde ON ep.user_id = dde.user_id
LEFT JOIN community_contributions cc ON ep.user_id = cc.user_id
LEFT JOIN user_innovation_projects uip ON ep.user_id = uip.user_id
LEFT JOIN knowledge_synthesis_projects ksp ON ep.user_id = ksp.user_id
LEFT JOIN trend_analysis_projects tap ON ep.user_id = tap.user_id
LEFT JOIN technology_comparisons tc ON EXISTS (
    SELECT 1 FROM exploration_content ec WHERE ec.content_id = tc.content_id 
    AND EXISTS (SELECT 1 FROM exploration_progress ep2 WHERE ep2.user_id = ep.user_id AND ep2.unit_id IN (
        SELECT unit_id FROM exploration_units WHERE unit_id = ANY(
            SELECT unit_id FROM exploration_content WHERE content_id = ec.content_id
        )
    ))
)
LEFT JOIN exploration_progress ep2 ON ep.user_id = ep2.user_id
GROUP BY ep.user_id, ep.profile_id, ep.exploration_streak_days, ep.contribution_points, ep.community_reputation_score;

-- Technology ecosystem health analytics
CREATE MATERIALIZED VIEW mv_technology_ecosystem_health AS
SELECT 
    te.ecosystem_name,
    te.display_name,
    
    -- Trend metrics
    COUNT(DISTINCT tt.trend_id) as active_trends,
    COUNT(DISTINCT CASE WHEN tt.trend_status = 'emerging' THEN tt.trend_id END) as emerging_trends,
    COUNT(DISTINCT CASE WHEN tt.trend_status = 'rising' THEN tt.trend_id END) as rising_trends,
    AVG(tt.momentum_score) as avg_momentum_score,
    AVG(tt.learning_priority_score) as avg_learning_priority,
    
    -- Community engagement
    COUNT(DISTINCT ep.user_id) as active_learners,
    COUNT(DISTINCT es.session_id) as exploration_sessions,
    COUNT(DISTINCT cc.contribution_id) as community_contributions,
    AVG(es.engagement_level) as avg_engagement_level,
    
    -- Innovation activity
    COUNT(DISTINCT uip.user_project_id) as innovation_projects,
    COUNT(DISTINCT dde.deep_dive_id) as deep_dive_explorations,
    COUNT(DISTINCT tap.analysis_id) as trend_analyses,
    
    -- Content richness
    COUNT(DISTINCT ed.domain_id) as exploration_domains,
    COUNT(DISTINCT et.topic_id) as exploration_topics,
    COUNT(DISTINCT eu.unit_id) as exploration_units,
    COUNT(DISTINCT ec.content_id) as content_pieces,
    
    -- Quality metrics
    AVG(ec.peer_rating) as avg_content_rating,
    AVG(ec.trend_alignment) as avg_trend_alignment,
    AVG(ec.innovation_potential) as avg_innovation_potential,
    
    -- Activity recency
    MAX(es.session_date) as last_exploration_session,
    MAX(cc.created_at) as last_community_contribution,
    MAX(uip.updated_at) as last_innovation_project_update
    
FROM technology_ecosystems te
LEFT JOIN technology_trends tt ON te.ecosystem_id = tt.ecosystem_id
LEFT JOIN enthusiast_profiles ep ON te.ecosystem_name = ANY(ep.primary_focus_areas)
LEFT JOIN exploration_sessions es ON te.ecosystem_name = es.primary_ecosystem
LEFT JOIN community_contributions cc ON te.ecosystem_name = ANY(cc.technology_focus)
LEFT JOIN user_innovation_projects uip ON EXISTS (
    SELECT 1 FROM jsonb_array_elements_text(uip.technologies_chosen) tech 
    WHERE tech ILIKE '%' || te.ecosystem_name::text || '%'
)
LEFT JOIN deep_dive_explorations dde ON EXISTS (
    SELECT 1 FROM exploration_topics et2 
    JOIN exploration_domains ed2 ON et2.domain_id = ed2.domain_id 
    WHERE et2.topic_id = dde.topic_id AND ed2.ecosystem_category = te.ecosystem_name
)
LEFT JOIN trend_analysis_projects tap ON te.ecosystem_name = ANY(tap.ecosystem_focus)
LEFT JOIN exploration_domains ed ON ed.ecosystem_category = te.ecosystem_name
LEFT JOIN exploration_topics et ON et.domain_id = ed.domain_id
LEFT JOIN exploration_units eu ON eu.topic_id = et.topic_id
LEFT JOIN exploration_content ec ON ec.unit_id = eu.unit_id
GROUP BY te.ecosystem_name, te.display_name;

-- Innovation project success analytics
CREATE MATERIALIZED VIEW mv_innovation_project_success AS
SELECT 
    DATE_TRUNC('month', uip.started_date) as project_start_month,
    uip.innovation_stage,
    
    -- Project metrics
    COUNT(*) as total_projects,
    COUNT(CASE WHEN uip.innovation_stage IN ('showcase', 'open_source') THEN 1 END) as successful_projects,
    AVG(uip.hours_invested) as avg_hours_invested,
    AVG(uip.personal_satisfaction_rating) as avg_satisfaction,
    AVG(uip.learning_value_rating) as avg_learning_value,
    AVG(uip.innovation_impact_rating) as avg_innovation_impact,
    
    -- Success rate calculation
    ROUND(
        COUNT(CASE WHEN uip.innovation_stage IN ('showcase', 'open_source') THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(*), 0) * 100, 2
    ) as success_rate_percentage,
    
    -- Technology adoption patterns
    jsonb_agg(DISTINCT uip.technologies_chosen) as technologies_used,
    COUNT(DISTINCT uip.user_id) as unique_innovators,
    
    -- Community impact
    SUM(CASE WHEN cc.contribution_type = 'code_example' THEN 1 ELSE 0 END) as code_contributions,
    SUM(CASE WHEN cc.contribution_type = 'blog_post' THEN 1 ELSE 0 END) as blog_posts,
    SUM(CASE WHEN cc.contribution_type = 'conference_talk' THEN 1 ELSE 0 END) as presentations,
    
    -- Timeline analysis
    AVG(EXTRACT(days FROM (uip.target_completion_date - uip.started_date))) as avg_planned_duration_days,
    AVG(EXTRACT(days FROM (uip.last_activity_date - uip.started_date))) as avg_actual_duration_days
    
FROM user_innovation_projects uip
LEFT JOIN community_contributions cc ON uip.user_id = cc.user_id 
    AND cc.created_date BETWEEN uip.started_date AND COALESCE(uip.target_completion_date, uip.last_activity_date)
WHERE uip.started_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY DATE_TRUNC('month', uip.started_date), uip.innovation_stage
ORDER BY project_start_month DESC, uip.innovation_stage;

-- ================================================================
-- COMPREHENSIVE INDEXING STRATEGY
-- ================================================================

-- Profile and user indexes
CREATE INDEX idx_enthusiast_profiles_user ON enthusiast_profiles(user_id);
CREATE INDEX idx_enthusiast_profiles_focus_areas ON enthusiast_profiles USING GIN(primary_focus_areas);
CREATE INDEX idx_enthusiast_profiles_expertise ON enthusiast_profiles(current_expertise_level);
CREATE INDEX idx_enthusiast_profiles_active_hours ON enthusiast_profiles(available_hours_per_week);

-- Technology and trend tracking indexes
CREATE INDEX idx_technology_ecosystems_category ON technology_ecosystems(ecosystem_name);
CREATE INDEX idx_technology_trends_ecosystem ON technology_trends(ecosystem_id);
CREATE INDEX idx_technology_trends_status ON technology_trends(trend_status);
CREATE INDEX idx_technology_trends_momentum ON technology_trends(momentum_score DESC);
CREATE INDEX idx_technology_trends_priority ON technology_trends(learning_priority_score DESC);

-- Exploration content indexes
CREATE INDEX idx_exploration_domains_ecosystem ON exploration_domains(ecosystem_category);
CREATE INDEX idx_exploration_domains_complexity ON exploration_domains(exploration_complexity);
CREATE INDEX idx_exploration_topics_domain ON exploration_topics(domain_id, order_index);
CREATE INDEX idx_exploration_topics_trend_alignment ON exploration_topics(current_trend_alignment DESC);
CREATE INDEX idx_exploration_units_topic ON exploration_units(topic_id, order_index);
CREATE INDEX idx_exploration_units_mode ON exploration_units(primary_mode);

-- Content and search indexes
CREATE INDEX idx_exploration_content_unit ON exploration_content(unit_id);
CREATE INDEX idx_exploration_content_mode ON exploration_content(exploration_mode);
CREATE INDEX idx_exploration_content_ecosystem ON exploration_content USING GIN(ecosystem_tags);
CREATE INDEX idx_exploration_content_keywords ON exploration_content USING GIN(technology_keywords);
CREATE INDEX idx_exploration_content_trend_alignment ON exploration_content(trend_alignment DESC);
CREATE INDEX idx_exploration_content_innovation ON exploration_content(innovation_potential DESC);

-- Full-text search for exploration content
CREATE INDEX idx_exploration_content_search ON exploration_content 
    USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || 
    array_to_string(technology_keywords, ' ') || ' ' || array_to_string(search_keywords, ' ')));

-- Session and activity indexes
CREATE INDEX idx_exploration_sessions_user ON exploration_sessions(user_id);
CREATE INDEX idx_exploration_sessions_date ON exploration_sessions(session_date DESC);
CREATE INDEX idx_exploration_sessions_ecosystem ON exploration_sessions(primary_ecosystem);
CREATE INDEX idx_exploration_sessions_type ON exploration_sessions(session_type);
CREATE INDEX idx_deep_dive_explorations_user ON deep_dive_explorations(user_id);
CREATE INDEX idx_deep_dive_explorations_topic ON deep_dive_explorations(topic_id);
CREATE INDEX idx_deep_dive_explorations_status ON deep_dive_explorations(status);

-- Innovation project indexes
CREATE INDEX idx_user_innovation_projects_user ON user_innovation_projects(user_id);
CREATE INDEX idx_user_innovation_projects_stage ON user_innovation_projects(innovation_stage);
CREATE INDEX idx_user_innovation_projects_date ON user_innovation_projects(started_date DESC);
CREATE INDEX idx_user_innovation_projects_technologies ON user_innovation_projects USING GIN(technologies_chosen);

-- Community contribution indexes
CREATE INDEX idx_community_contributions_user ON community_contributions(user_id);
CREATE INDEX idx_community_contributions_type ON community_contributions(contribution_type);
CREATE INDEX idx_community_contributions_focus ON community_contributions USING GIN(technology_focus);
CREATE INDEX idx_community_contributions_date ON community_contributions(created_date DESC);
CREATE INDEX idx_community_contributions_rating ON community_contributions(community_rating DESC);

-- Progress tracking indexes
CREATE INDEX idx_exploration_progress_user ON exploration_progress(user_id);
CREATE INDEX idx_exploration_progress_unit ON exploration_progress(unit_id);
CREATE INDEX idx_exploration_progress_status ON exploration_progress(exploration_status);
CREATE INDEX idx_exploration_progress_modes ON exploration_progress USING GIN(modes_explored);
CREATE INDEX idx_technology_expertise_user ON technology_expertise(user_id);
CREATE INDEX idx_technology_expertise_tech ON technology_expertise(technology_name, ecosystem_category);
CREATE INDEX idx_technology_expertise_level ON technology_expertise(current_expertise_level);

-- Trend analysis indexes
CREATE INDEX idx_trend_analysis_projects_user ON trend_analysis_projects(user_id);
CREATE INDEX idx_trend_analysis_projects_focus ON trend_analysis_projects USING GIN(ecosystem_focus);
CREATE INDEX idx_trend_analysis_projects_date ON trend_analysis_projects(research_period_end DESC);
CREATE INDEX idx_knowledge_synthesis_projects_user ON knowledge_synthesis_projects(user_id);
CREATE INDEX idx_knowledge_synthesis_projects_type ON knowledge_synthesis_projects(synthesis_type);

-- Vector search indexes for exploration
CREATE INDEX idx_exploration_content_embeddings_vector ON exploration_content_embeddings 
    USING hnsw (content_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX idx_exploration_trend_vector ON exploration_content_embeddings 
    USING hnsw (trend_relevance_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE trend_relevance_vector IS NOT NULL;
CREATE INDEX idx_exploration_innovation_vector ON exploration_content_embeddings 
    USING hnsw (innovation_potential_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE innovation_potential_vector IS NOT NULL;

-- ================================================================
-- ROW LEVEL SECURITY (RLS) FOR EXPLORATION PLATFORM
-- ================================================================

-- Enable RLS on user-specific tables
ALTER TABLE enthusiast_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE exploration_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE deep_dive_explorations ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_innovation_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_contributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE exploration_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE technology_expertise ENABLE ROW LEVEL SECURITY;
ALTER TABLE trend_analysis_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE knowledge_synthesis_projects ENABLE ROW LEVEL SECURITY;

-- User isolation policies
CREATE POLICY enthusiast_profile_isolation ON enthusiast_profiles
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY exploration_session_isolation ON exploration_sessions
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY exploration_progress_isolation ON exploration_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY innovation_project_isolation ON user_innovation_projects
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Community content visibility policies
CREATE POLICY community_contribution_visibility ON community_contributions
    FOR SELECT TO application_users
    USING (true); -- Community contributions are publicly visible

CREATE POLICY community_contribution_ownership ON community_contributions
    FOR INSERT, UPDATE, DELETE TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Admin access policies
CREATE POLICY admin_full_access_profiles ON enthusiast_profiles
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_full_access_sessions ON exploration_sessions
    FOR ALL TO admin_users
    USING (true);

-- ================================================================
-- SPECIALIZED FUNCTIONS FOR EXPLORATION LEARNING
-- ================================================================

-- Function to recommend exploration content based on interests and trends
CREATE OR REPLACE FUNCTION recommend_exploration_content(
    p_user_id UUID,
    p_exploration_mode learning_mode DEFAULT 'discovery',
    p_limit INTEGER DEFAULT 10
) RETURNS TABLE (
    content_id UUID,
    title VARCHAR,
    exploration_mode learning_mode,
    trend_alignment INTEGER,
    innovation_potential INTEGER,
    recommendation_score DECIMAL
) AS $$
DECLARE
    user_ecosystems tech_ecosystem[];
    user_expertise_level VARCHAR(50);
BEGIN
    -- Get user preferences
    SELECT primary_focus_areas, current_expertise_level 
    INTO user_ecosystems, user_expertise_level
    FROM enthusiast_profiles 
    WHERE user_id = p_user_id;
    
    -- If no ecosystems specified, use all
    IF user_ecosystems IS NULL OR array_length(user_ecosystems, 1) = 0 THEN
        user_ecosystems := ARRAY['web_frameworks', 'data_science', 'machine_learning', 'cloud_computing']::tech_ecosystem[];
    END IF;
    
    RETURN QUERY
    WITH user_completed AS (
        SELECT ep.unit_id 
        FROM exploration_progress ep 
        WHERE ep.user_id = p_user_id 
        AND ep.exploration_status IN ('completed', 'mastered')
    ),
    candidate_content AS (
        SELECT 
            ec.content_id,
            ec.title,
            ec.exploration_mode,
            ec.trend_alignment,
            ec.innovation_potential,
            
            -- Ecosystem alignment scoring
            CASE 
                WHEN ec.ecosystem_tags && user_ecosystems THEN 10
                ELSE 3
            END as ecosystem_score,
            
            -- Mode preference scoring
            CASE 
                WHEN ec.exploration_mode = p_exploration_mode THEN 10
                WHEN ec.exploration_mode = ANY(ARRAY['discovery', 'experimentation']::learning_mode[]) THEN 7
                ELSE 5
            END as mode_score,
            
            -- Freshness and trend scoring
            CASE 
                WHEN ec.trend_alignment >= 8 THEN 10
                WHEN ec.trend_alignment >= 6 THEN 7
                ELSE 5
            END as trend_score,
            
            -- Innovation potential scoring
            CASE 
                WHEN ec.innovation_potential >= 8 THEN 10
                WHEN ec.innovation_potential >= 6 THEN 7
                ELSE 5
            END as innovation_score
            
        FROM exploration_content ec
        JOIN exploration_units eu ON ec.unit_id = eu.unit_id
        LEFT JOIN user_completed uc ON eu.unit_id = uc.unit_id
        
        WHERE uc.unit_id IS NULL -- Not already completed
        AND (ec.ecosystem_tags && user_ecosystems OR ec.ecosystem_tags IS NULL)
    )
    SELECT 
        cc.content_id,
        cc.title,
        cc.exploration_mode,
        cc.trend_alignment,
        cc.innovation_potential,
        ROUND(
            (cc.ecosystem_score * 0.3 + 
             cc.mode_score * 0.25 + 
             cc.trend_score * 0.25 + 
             cc.innovation_score * 0.2), 2
        ) as recommendation_score
    FROM candidate_content cc
    ORDER BY recommendation_score DESC, cc.trend_alignment DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to identify trending technologies for exploration
CREATE OR REPLACE FUNCTION identify_trending_technologies(
    p_ecosystem tech_ecosystem DEFAULT NULL,
    p_time_horizon VARCHAR DEFAULT '6 months',
    p_limit INTEGER DEFAULT 20
) RETURNS TABLE (
    trend_name VARCHAR,
    ecosystem_name tech_ecosystem,
    momentum_score INTEGER,
    learning_priority INTEGER,
    adoption_rate VARCHAR,
    exploration_opportunities INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tt.trend_name,
        tt.ecosystem_id as ecosystem_name,
        tt.momentum_score,
        tt.learning_priority_score,
        tt.adoption_rate,
        
        -- Count exploration opportunities
        COUNT(DISTINCT ec.content_id)::INTEGER as exploration_opportunities
        
    FROM technology_trends tt
    JOIN technology_ecosystems te ON tt.ecosystem_id = te.ecosystem_id
    LEFT JOIN exploration_content ec ON te.ecosystem_name = ANY(ec.ecosystem_tags)
    
    WHERE (p_ecosystem IS NULL OR te.ecosystem_name = p_ecosystem)
    AND tt.trend_status IN ('emerging', 'rising')
    AND tt.momentum_score >= 6
    
    GROUP BY tt.trend_name, tt.ecosystem_id, tt.momentum_score, tt.learning_priority_score, tt.adoption_rate
    ORDER BY tt.momentum_score DESC, tt.learning_priority_score DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to suggest innovation project ideas
CREATE OR REPLACE FUNCTION suggest_innovation_projects(
    p_user_id UUID,
    p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
    project_title VARCHAR,
    project_description TEXT,
    technologies JSONB,
    difficulty_level exploration_depth,
    innovation_score DECIMAL
) AS $$
DECLARE
    user_expertise JSONB;
    user_interests tech_ecosystem[];
BEGIN
    -- Get user expertise and interests
    SELECT 
        jsonb_object_agg(te.technology_name, te.current_expertise_level) as expertise,
        ep.primary_focus_areas
    INTO user_expertise, user_interests
    FROM enthusiast_profiles ep
    LEFT JOIN technology_expertise te ON ep.user_id = te.user_id
    WHERE ep.user_id = p_user_id
    GROUP BY ep.primary_focus_areas;
    
    RETURN QUERY
    WITH project_candidates AS (
        SELECT 
            ip.project_title,
            ip.project_description,
            ip.primary_technologies,
            ip.difficulty_level,
            
            -- Innovation scoring based on user fit
            CASE 
                WHEN ip.primary_technologies ?| (
                    SELECT array_agg(key) FROM jsonb_object_keys(user_expertise) as key
                ) THEN 10.0
                ELSE 5.0
            END as expertise_fit,
            
            -- Interest alignment
            CASE 
                WHEN EXISTS (
                    SELECT 1 FROM exploration_content ec 
                    WHERE ec.unit_id = ip.content_id 
                    AND ec.ecosystem_tags && user_interests
                ) THEN 10.0
                ELSE 7.0
            END as interest_fit,
            
            -- Novelty and innovation potential
            CASE 
                WHEN ip.innovation_type = 'prototype' THEN 10.0
                WHEN ip.innovation_type = 'experiment' THEN 8.0
                ELSE 6.0
            END as innovation_potential
            
        FROM innovation_projects ip
        WHERE ip.difficulty_level != 'expert' OR user_expertise IS NOT NULL
    )
    SELECT 
        pc.project_title,
        pc.project_description,
        pc.primary_technologies,
        pc.difficulty_level,
        ROUND((pc.expertise_fit * 0.4 + pc.interest_fit * 0.35 + pc.innovation_potential * 0.25), 2) as innovation_score
        
    FROM project_candidates pc
    ORDER BY innovation_score DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate user exploration analytics
CREATE OR REPLACE FUNCTION calculate_exploration_analytics(p_user_id UUID)
RETURNS JSONB AS $$
DECLARE
    analytics_result JSONB;
    exploration_velocity DECIMAL;
    innovation_index DECIMAL;
    community_impact DECIMAL;
    trend_awareness DECIMAL;
BEGIN
    -- Calculate exploration velocity (units per week)
    SELECT 
        COUNT(DISTINCT ep.unit_id)::DECIMAL / GREATEST(
            EXTRACT(weeks FROM (MAX(ep.last_activity_at) - MIN(ep.first_explored_at))), 1
        )
    INTO exploration_velocity
    FROM exploration_progress ep
    WHERE ep.user_id = p_user_id;
    
    -- Calculate innovation index
    SELECT 
        COALESCE(AVG(uip.innovation_impact_rating), 0) * 
        (COUNT(DISTINCT uip.user_project_id)::DECIMAL / 10.0) -- Normalize by project count
    INTO innovation_index
    FROM user_innovation_projects uip
    WHERE uip.user_id = p_user_id;
    
    -- Calculate community impact score
    SELECT 
        COALESCE(SUM(cc.views_or_downloads), 0)::DECIMAL / 1000.0 + -- Views normalized
        COALESCE(SUM(cc.likes_or_stars), 0)::DECIMAL / 100.0 + -- Appreciation normalized
        COUNT(DISTINCT cc.contribution_id)::DECIMAL -- Contribution count
    INTO community_impact
    FROM community_contributions cc
    WHERE cc.user_id = p_user_id;
    
    -- Calculate trend awareness score
    SELECT 
        COALESCE(AVG(ec.trend_alignment), 5)::DECIMAL
    INTO trend_awareness
    FROM exploration_progress ep
    JOIN exploration_content ec ON ep.unit_id = ec.unit_id
    WHERE ep.user_id = p_user_id
    AND ep.last_activity_at > CURRENT_DATE - INTERVAL '3 months';
    
    -- Compile analytics
    analytics_result := jsonb_build_object(
        'exploration_velocity', COALESCE(exploration_velocity, 0),
        'innovation_index', COALESCE(innovation_index, 0),
        'community_impact_score', COALESCE(community_impact, 0),
        'trend_awareness_score', COALESCE(trend_awareness, 5),
        'overall_score', ROUND(
            (COALESCE(exploration_velocity, 0) * 0.25 + 
             COALESCE(innovation_index, 0) * 0.25 + 
             COALESCE(community_impact, 0) * 0.25 + 
             COALESCE(trend_awareness, 5) * 0.25), 2
        ),
        'calculated_at', CURRENT_TIMESTAMP
    );
    
    RETURN analytics_result;
END;
$$ LANGUAGE plpgsql;

-- Function to refresh all materialized views
CREATE OR REPLACE FUNCTION refresh_exploration_analytics_views()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_user_exploration_analytics;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_technology_ecosystem_health;
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_innovation_project_success;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- ================================================================

-- Update timestamps trigger
CREATE OR REPLACE FUNCTION update_exploration_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply timestamp triggers
CREATE TRIGGER tr_enthusiast_profiles_updated_at
    BEFORE UPDATE ON enthusiast_profiles
    FOR EACH ROW EXECUTE FUNCTION update_exploration_updated_at();

CREATE TRIGGER tr_exploration_domains_updated_at
    BEFORE UPDATE ON exploration_domains
    FOR EACH ROW EXECUTE FUNCTION update_exploration_updated_at();

CREATE TRIGGER tr_exploration_content_updated_at
    BEFORE UPDATE ON exploration_content
    FOR EACH ROW EXECUTE FUNCTION update_exploration_updated_at();

CREATE TRIGGER tr_user_innovation_projects_updated_at
    BEFORE UPDATE ON user_innovation_projects
    FOR EACH ROW EXECUTE FUNCTION update_exploration_updated_at();

-- Update exploration streak and points
CREATE OR REPLACE FUNCTION update_exploration_streak()
RETURNS TRIGGER AS $$
DECLARE
    last_session_date DATE;
    current_streak INTEGER;
BEGIN
    -- Get last session date before this one
    SELECT MAX(session_date::DATE) INTO last_session_date
    FROM exploration_sessions 
    WHERE user_id = NEW.user_id 
    AND session_id != NEW.session_id;
    
    -- Get current streak
    SELECT exploration_streak_days INTO current_streak
    FROM enthusiast_profiles 
    WHERE user_id = NEW.user_id;
    
    -- Update streak based on session pattern
    IF last_session_date IS NULL THEN
        -- First session
        UPDATE enthusiast_profiles 
        SET exploration_streak_days = 1,
            contribution_points = contribution_points + 10
        WHERE user_id = NEW.user_id;
    ELSIF NEW.session_date::DATE = last_session_date + INTERVAL '1 day' THEN
        -- Consecutive day
        UPDATE enthusiast_profiles 
        SET exploration_streak_days = current_streak + 1,
            contribution_points = contribution_points + 10
        WHERE user_id = NEW.user_id;
    ELSIF NEW.session_date::DATE > last_session_date + INTERVAL '1 day' THEN
        -- Streak broken
        UPDATE enthusiast_profiles 
        SET exploration_streak_days = 1,
            contribution_points = contribution_points + 5
        WHERE user_id = NEW.user_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_exploration_streak
    AFTER INSERT ON exploration_sessions
    FOR EACH ROW EXECUTE FUNCTION update_exploration_streak();

-- ================================================================
-- INITIAL SETUP DATA FOR EXPLORATION LEARNING
-- ================================================================

-- Create default embedding model for exploration
INSERT INTO exploration_embedding_models (
    model_name, model_version, provider, embedding_dimensions,
    context_window, trend_analysis_optimized, technology_comparison_trained,
    innovation_pattern_recognition, community_content_aligned, is_active, is_default
) VALUES (
    'exploration-optimized-embeddings-v1', 'v1.0', 'custom', 384,
    512, true, true, true, true, true, true
);

-- Create AI avatar roles for exploration learning
INSERT INTO exploration_avatar_roles (
    role_name, display_name, role_description, interaction_style, 
    exploration_guidance_style, curiosity_stimulation_approach, 
    trend_analysis_capabilities, innovation_coaching_abilities,
    community_connection_skills, knowledge_synthesis_expertise,
    cutting_edge_knowledge, experimental_mindset, community_orientation, synthesis_focus
) VALUES 
('exploration_guide', 'Exploration Guide', 
 'Guides discovery-driven learning with focus on emerging trends and technologies',
 '{"approach": "discovery", "tone": "curious", "style": "exploratory"}'::jsonb,
 'discovery_focused', 'questioning',
 '{"trend_spotting": "advanced", "pattern_recognition": "expert", "prediction": "intermediate"}'::jsonb,
 '{"creative_thinking": "expert", "experimentation": "advanced", "ideation": "expert"}'::jsonb,
 '{"networking": "advanced", "collaboration": "expert", "knowledge_sharing": "expert"}'::jsonb,
 '{"comparison": "expert", "synthesis": "advanced", "connection_making": "expert"}'::jsonb,
 true, true, true, true),

('innovation_catalyst', 'Innovation Catalyst', 
 'Sparks creative thinking and guides innovative project development',
 '{"approach": "creative", "tone": "inspiring", "style": "experimental"}'::jsonb,
 'synthesis_driven', 'challenging',
 '{"emerging_tech": "expert", "disruptive_potential": "advanced", "market_analysis": "intermediate"}'::jsonb,
 '{"project_ideation": "expert", "prototype_guidance": "advanced", "creative_problem_solving": "expert"}'::jsonb,
 '{"innovation_communities": "expert", "collaboration_tools": "advanced", "showcase_platforms": "expert"}'::jsonb,
 '{"technology_fusion": "expert", "pattern_synthesis": "expert", "future_visioning": "advanced"}'::jsonb,
 true, true, true, true),

('trend_analyst', 'Technology Trend Analyst', 
 'Provides deep insights into technology trends and ecosystem evolution',
 '{"approach": "analytical", "tone": "insightful", "style": "comprehensive"}'::jsonb,
 'comparison_oriented', 'challenging',
 '{"trend_analysis": "expert", "market_research": "expert", "future_prediction": "advanced"}'::jsonb,
 '{"strategic_thinking": "advanced", "opportunity_identification": "expert", "risk_assessment": "intermediate"}'::jsonb,
 '{"industry_networks": "expert", "thought_leaders": "advanced", "research_communities": "expert"}'::jsonb,
 '{"ecosystem_mapping": "expert", "competitive_analysis": "expert", "strategic_synthesis": "advanced"}'::jsonb,
 true, false, true, true),

('community_connector', 'Community Connector', 
 'Facilitates community engagement, knowledge sharing, and collaborative learning',
 '{"approach": "collaborative", "tone": "encouraging", "style": "inclusive"}'::jsonb,
 'discovery_focused', 'inspiring',
 '{"community_trends": "advanced", "social_learning": "expert", "engagement_patterns": "expert"}'::jsonb,
 '{"collaboration_design": "expert", "group_innovation": "advanced", "peer_learning": "expert"}'::jsonb,
 '{"community_building": "expert", "network_facilitation": "expert", "knowledge_curation": "expert"}'::jsonb,
 '{"collective_intelligence": "expert", "crowd_sourcing": "advanced", "social_synthesis": "expert"}'::jsonb,
 true, true, true, true);

-- Create sample technology ecosystems
INSERT INTO technology_ecosystems (
    ecosystem_name, display_name, description, maturity_level, innovation_velocity,
    learning_curve, market_adoption, core_technologies, emerging_technologies,
    trending_libraries, key_concepts, recommended_starting_points, essential_skills,
    advanced_topics, experimentation_ideas, major_conferences, influential_figures,
    contribution_opportunities, learning_communities
) VALUES 
('machine_learning', 'Machine Learning & AI', 
 'Artificial intelligence, machine learning algorithms, and neural networks',
 'growing', 'very_fast', 'steep', 'mainstream',
 '["tensorflow", "pytorch", "scikit-learn", "numpy", "pandas"]'::jsonb,
 '["transformers", "diffusion_models", "reinforcement_learning", "graph_neural_networks"]'::jsonb,
 '["hugging_face_transformers", "pytorch_lightning", "ray", "wandb", "mlflow"]'::jsonb,
 '["neural_networks", "deep_learning", "supervised_learning", "unsupervised_learning"]'::jsonb,
 '["python_basics", "linear_algebra", "statistics", "tensorflow_tutorial"]'::jsonb,
 '["python", "mathematics", "statistics", "data_processing", "model_evaluation"]'::jsonb,
 '["transformer_architecture", "generative_models", "mlops", "distributed_training"]'::jsonb,
 '["image_classifier", "chatbot", "recommendation_system", "time_series_forecasting"]'::jsonb,
 '["NeurIPS", "ICML", "ICLR", "PyTorch_Conference"]'::jsonb,
 '["Andrew_Ng", "Yann_LeCun", "Geoffrey_Hinton", "Fei_Fei_Li"]'::jsonb,
 '["hugging_face_models", "pytorch_contributions", "kaggle_competitions", "research_papers"]'::jsonb,
 '["r/MachineLearning", "ML_Twitter", "Papers_With_Code", "Towards_Data_Science"]'::jsonb),

('web_frameworks', 'Web Development Frameworks', 
 'Modern web development frameworks and technologies',
 'mature', 'fast', 'moderate', 'ubiquitous',
 '["react", "vue", "angular", "nodejs", "express", "django", "flask"]'::jsonb,
 '["svelte", "solid", "qwik", "astro", "remix", "next_13", "vite"]'::jsonb,
 '["next_js", "nuxt", "sveltekit", "fastapi", "tailwind_css", "prisma"]'::jsonb,
 '["components", "state_management", "routing", "server_side_rendering", "api_design"]'::jsonb,
 '["html_css_basics", "javascript_fundamentals", "react_tutorial", "api_basics"]'::jsonb,
 '["javascript", "html", "css", "http", "databases", "version_control"]'::jsonb,
 '["micro_frontends", "serverless", "edge_computing", "web_assembly", "performance_optimization"]'::jsonb,
 '["todo_app", "blog_platform", "ecommerce_site", "real_time_chat", "portfolio_website"]'::jsonb,
 '["React_Conf", "VueConf", "JSConf", "Node_Congress"]'::jsonb,
 '["Dan_Abramov", "Evan_You", "Rich_Harris", "Kent_C_Dodds"]'::jsonb,
 '["open_source_components", "documentation", "tutorials", "framework_plugins"]'::jsonb,
 '["r/webdev", "DEV_Community", "Stack_Overflow", "Frontend_Masters", "Web_Dev_Discord"]'::jsonb);

-- Final schema summary
DO $$
BEGIN
    RAISE NOTICE '=== CONTINUOUS LEARNING ENTHUSIAST SCHEMA DEPLOYMENT COMPLETE ===';
    RAISE NOTICE 'Total Tables Created: 25+';
    RAISE NOTICE 'Total Fields: ~400+';
    RAISE NOTICE 'Indexes Created: 50+';
    RAISE NOTICE 'Materialized Views: 3';
    RAISE NOTICE 'Functions: 5';
    RAISE NOTICE 'Triggers: 6';
    RAISE NOTICE 'RLS Policies: 10';
    RAISE NOTICE 'Exploration-Specific Features: Trend Tracking, Innovation Projects, Community Contributions';
    RAISE NOTICE 'AI Avatar Roles: 4 (exploration_guide, innovation_catalyst, trend_analyst, community_connector)';
    RAISE NOTICE 'Specialized Content Types: Technology Comparisons, Innovation Projects, Trend Analysis';
    RAISE NOTICE '================================================================';
END $$;

-- Refresh materialized views for initial state
SELECT refresh_exploration_analytics_views();

COMMIT;