-- ================================================================
-- CREDIBILITY-BUILDING GRADUATE AI EDUCATION PLATFORM SCHEMA
-- Production-Ready PostgreSQL Database for Academic Excellence & Research
-- Optimized for graduate-level learning, research, and academic credibility building
-- ================================================================

-- ================================================================
-- SYSTEM CONFIGURATION & EXTENSIONS
-- ================================================================

-- Enable required extensions for advanced academic functionality
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";          -- UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";           -- Encryption for academic records
CREATE EXTENSION IF NOT EXISTS "vector";             -- Vector embeddings for academic search
CREATE EXTENSION IF NOT EXISTS "pg_trgm";            -- Trigram matching for research content
CREATE EXTENSION IF NOT EXISTS "tablefunc";          -- Academic analytics and pivot functionality
CREATE EXTENSION IF NOT EXISTS "btree_gin";          -- GIN indexes for research arrays
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements"; -- Query performance monitoring
CREATE EXTENSION IF NOT EXISTS "pg_cron";            -- Academic milestone scheduling
CREATE EXTENSION IF NOT EXISTS "timescaledb";        -- Time-series data for research progress
CREATE EXTENSION IF NOT EXISTS "hstore";             -- Academic metadata storage

-- Set timezone for global academic coordination
SET timezone = 'UTC';

-- ================================================================
-- ENHANCED ENUMS & TYPES FOR ACADEMIC EXCELLENCE
-- ================================================================

-- Academic career objectives for graduate students
CREATE TYPE academic_objective AS ENUM (
    'masters_completion', 'phd_preparation', 'research_excellence', 'industry_transition',
    'academic_career', 'thought_leadership', 'publication_success', 'conference_speaking'
);

-- Graduate program types and levels
CREATE TYPE graduate_program_type AS ENUM (
    'masters_coursework', 'masters_thesis', 'masters_project', 'phd_coursework',
    'phd_comprehensive_exams', 'phd_candidacy', 'phd_dissertation', 'postdoc_research'
);

-- Research domain specializations
CREATE TYPE research_domain AS ENUM (
    'computer_science', 'data_science', 'machine_learning', 'artificial_intelligence',
    'software_engineering', 'cybersecurity', 'computational_biology', 'digital_humanities',
    'educational_technology', 'human_computer_interaction', 'systems_architecture'
);

-- Academic assessment complexity levels
CREATE TYPE academic_complexity AS ENUM (
    'foundational', 'intermediate', 'advanced', 'graduate', 'research', 'expert'
);

-- Research methodology approaches
CREATE TYPE research_methodology AS ENUM (
    'quantitative', 'qualitative', 'mixed_methods', 'experimental', 'theoretical',
    'computational', 'empirical', 'case_study', 'systematic_review'
);

-- Academic credibility stages
CREATE TYPE credibility_stage AS ENUM (
    'novice_researcher', 'developing_scholar', 'emerging_expert', 'recognized_researcher',
    'thought_leader', 'domain_authority', 'academic_influencer'
);

-- Publication types and academic outputs
CREATE TYPE publication_type AS ENUM (
    'journal_article', 'conference_paper', 'book_chapter', 'thesis', 'dissertation',
    'technical_report', 'white_paper', 'blog_post', 'workshop_paper', 'poster'
);

-- Peer review and collaboration types
CREATE TYPE collaboration_type AS ENUM (
    'study_group', 'research_team', 'writing_circle', 'peer_review', 'mentorship',
    'co_authorship', 'conference_collaboration', 'academic_networking'
);

-- Academic progress tracking states
CREATE TYPE academic_progress AS ENUM (
    'planned', 'enrolled', 'in_progress', 'completed', 'defended', 'published', 'cited'
);

-- Graduate-level avatar teaching roles
CREATE TYPE graduate_avatar_role AS ENUM (
    'research_advisor', 'thesis_supervisor', 'methodology_expert', 'writing_coach',
    'publication_mentor', 'conference_guide', 'academic_career_advisor', 'peer_collaborator'
);

-- Research project phases
CREATE TYPE research_phase AS ENUM (
    'conception', 'literature_review', 'methodology_design', 'data_collection',
    'analysis', 'writing', 'revision', 'submission', 'publication', 'dissemination'
);

-- ================================================================
-- 1. GRADUATE STUDENT PROFILES & ACADEMIC TRACKING
-- ================================================================

-- Graduate student profiles optimized for academic credibility building
CREATE TABLE graduate_profiles (
    profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE, -- Links to external user system
    
    -- Academic identification
    full_name VARCHAR(200) NOT NULL,
    academic_email VARCHAR(200) UNIQUE,
    student_id VARCHAR(50),
    orcid_id VARCHAR(19), -- ORCID identifier for academic identity
    
    -- Program and institution information
    institution_name VARCHAR(200),
    department VARCHAR(150),
    graduate_program graduate_program_type NOT NULL,
    program_start_date DATE,
    expected_completion_date DATE,
    advisor_name VARCHAR(200),
    committee_members TEXT[],
    
    -- Academic objectives and specialization
    primary_objectives academic_objective[] NOT NULL,
    research_domains research_domain[] NOT NULL,
    dissertation_topic TEXT,
    research_interests JSONB, -- Detailed research focus areas
    
    -- Academic background
    undergraduate_institution VARCHAR(200),
    undergraduate_gpa DECIMAL(3,2),
    previous_degrees JSONB, -- Array of previous academic qualifications
    academic_awards JSONB, -- Scholarships, fellowships, honors
    
    -- Research and credibility metrics
    current_credibility_stage credibility_stage DEFAULT 'novice_researcher',
    h_index INTEGER DEFAULT 0,
    citation_count INTEGER DEFAULT 0,
    publication_count INTEGER DEFAULT 0,
    conference_presentations INTEGER DEFAULT 0,
    
    -- Academic skill development
    research_methodology_expertise research_methodology[],
    technical_skills JSONB, -- Programming, tools, methodologies
    academic_writing_level INTEGER DEFAULT 3, -- 1-10 scale
    statistical_analysis_level INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Time management for academics
    weekly_study_hours INTEGER DEFAULT 40, -- Full-time graduate commitment
    research_hours_per_week INTEGER DEFAULT 20,
    coursework_hours_per_week INTEGER DEFAULT 15,
    preferred_study_schedule JSONB, -- Peak productivity times
    
    -- Academic networking and collaboration
    professional_memberships TEXT[],
    conference_attendance_history JSONB,
    academic_social_media JSONB, -- Twitter, LinkedIn, ResearchGate
    collaboration_preferences collaboration_type[],
    
    -- Career development goals
    post_graduation_plans VARCHAR(200), -- Academia, industry, entrepreneurship
    target_job_market VARCHAR(100), -- Geographic or sector preferences
    networking_goals INTEGER DEFAULT 0, -- Target professional connections
    publication_goals INTEGER DEFAULT 2, -- Target publications per year
    
    -- Learning and productivity tracking
    average_study_session_duration INTEGER DEFAULT 120, -- 2-hour focused sessions
    deep_work_capacity INTEGER DEFAULT 4, -- Hours of deep focus per day
    procrastination_tendency INTEGER DEFAULT 5, -- 1-10 scale (lower is better)
    academic_confidence INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Thesis and dissertation progress
    thesis_proposal_status VARCHAR(50), -- 'planning', 'drafted', 'approved', 'defended'
    thesis_progress_percentage DECIMAL(5,2) DEFAULT 0,
    chapters_completed INTEGER DEFAULT 0,
    total_planned_chapters INTEGER DEFAULT 5,
    defense_date DATE,
    
    -- Research output tracking
    papers_in_progress INTEGER DEFAULT 0,
    manuscripts_submitted INTEGER DEFAULT 0,
    papers_under_review INTEGER DEFAULT 0,
    accepted_publications INTEGER DEFAULT 0,
    
    -- Academic engagement
    last_login TIMESTAMPTZ,
    total_study_hours DECIMAL(8,2) DEFAULT 0,
    courses_completed INTEGER DEFAULT 0,
    research_projects_active INTEGER DEFAULT 1,
    
    -- Audit fields
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_gpa_range CHECK (undergraduate_gpa IS NULL OR undergraduate_gpa BETWEEN 0 AND 4.0),
    CONSTRAINT chk_academic_levels CHECK (
        academic_writing_level BETWEEN 1 AND 10 AND
        statistical_analysis_level BETWEEN 1 AND 10
    ),
    CONSTRAINT chk_progress_percentage CHECK (thesis_progress_percentage BETWEEN 0 AND 100)
);

-- Academic skills taxonomy with research focus
CREATE TABLE academic_skills (
    skill_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    skill_code VARCHAR(50) NOT NULL UNIQUE,
    skill_name VARCHAR(200) NOT NULL,
    description TEXT,
    
    -- Academic categorization
    research_domain research_domain,
    skill_category VARCHAR(100), -- 'research_methodology', 'technical', 'academic_writing', 'analysis'
    academic_level academic_complexity DEFAULT 'graduate',
    
    -- Learning characteristics for graduates
    prerequisite_knowledge TEXT,
    typical_mastery_time_weeks INTEGER, -- Time to achieve competency
    prerequisite_skills UUID[], -- Array of skill IDs
    advanced_applications JSONB, -- How this skill applies to advanced research
    
    -- Academic and industry relevance
    academic_importance INTEGER DEFAULT 8, -- 1-10 scale for academic careers
    industry_relevance INTEGER DEFAULT 5, -- 1-10 scale for industry transition
    research_applicability INTEGER DEFAULT 8, -- 1-10 scale for research projects
    publication_value INTEGER DEFAULT 6, -- 1-10 scale for publication potential
    
    -- Graduate learning optimization
    requires_deep_focus BOOLEAN DEFAULT true, -- Needs extended concentration
    collaborative_learning_suitable BOOLEAN DEFAULT true,
    practical_application_heavy BOOLEAN DEFAULT true,
    theoretical_foundation_required BOOLEAN DEFAULT true,
    
    -- Research and professional development
    leading_researchers JSONB, -- Key figures in this skill area
    essential_papers JSONB, -- Must-read publications
    key_conferences JSONB, -- Relevant academic conferences
    industry_applications JSONB, -- How this applies outside academia
    
    -- Academic credibility building
    certification_opportunities JSONB, -- Professional certifications available
    thought_leadership_potential INTEGER DEFAULT 5, -- 1-10 scale
    networking_value INTEGER DEFAULT 5, -- 1-10 scale for academic networking
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_academic_scores CHECK (
        academic_importance BETWEEN 1 AND 10 AND
        industry_relevance BETWEEN 1 AND 10 AND
        research_applicability BETWEEN 1 AND 10
    )
);

-- Research projects and academic work tracking
CREATE TABLE research_projects (
    project_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Project identification
    project_title VARCHAR(300) NOT NULL,
    project_type VARCHAR(100) NOT NULL, -- 'thesis', 'dissertation', 'independent_research', 'collaboration'
    research_domain research_domain NOT NULL,
    methodology research_methodology NOT NULL,
    
    -- Project scope and timeline
    project_description TEXT NOT NULL,
    research_questions JSONB NOT NULL, -- Primary and secondary research questions
    objectives JSONB NOT NULL, -- Specific, measurable objectives
    expected_outcomes JSONB, -- Anticipated results and contributions
    
    -- Timeline and milestones
    start_date DATE NOT NULL,
    expected_completion_date DATE,
    actual_completion_date DATE,
    current_phase research_phase DEFAULT 'conception',
    phase_deadlines JSONB, -- Deadlines for each research phase
    
    -- Academic supervision and collaboration
    primary_advisor_id UUID, -- Reference to advisor profile
    committee_members UUID[], -- Array of committee member IDs
    collaborators UUID[], -- Other students or researchers involved
    external_partners JSONB, -- Industry or institutional partners
    
    -- Research resources and requirements
    required_skills UUID[] NOT NULL, -- Skills needed for this project
    datasets_required JSONB, -- Data sources and requirements
    equipment_needed JSONB, -- Lab equipment, software, hardware
    budget_requirements DECIMAL(10,2), -- Estimated project costs
    
    -- Academic validation and assessment
    proposal_approval_date DATE,
    ethics_approval_required BOOLEAN DEFAULT false,
    ethics_approval_date DATE,
    institutional_review_status VARCHAR(50), -- IRB status if applicable
    
    -- Progress tracking
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    literature_review_completion DECIMAL(5,2) DEFAULT 0,
    methodology_development_completion DECIMAL(5,2) DEFAULT 0,
    data_collection_completion DECIMAL(5,2) DEFAULT 0,
    analysis_completion DECIMAL(5,2) DEFAULT 0,
    writing_completion DECIMAL(5,2) DEFAULT 0,
    
    -- Academic output and impact
    publications_planned INTEGER DEFAULT 1,
    publications_generated INTEGER DEFAULT 0,
    conference_presentations_planned INTEGER DEFAULT 2,
    conference_presentations_given INTEGER DEFAULT 0,
    
    -- Research impact metrics
    potential_citations INTEGER DEFAULT 0, -- Estimated citation potential
    academic_significance INTEGER DEFAULT 5, -- 1-10 scale
    industry_impact INTEGER DEFAULT 3, -- 1-10 scale
    social_impact INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Project challenges and support
    challenges_encountered JSONB,
    support_needed JSONB,
    resources_utilized JSONB,
    lessons_learned JSONB,
    
    -- Quality and validation
    peer_review_feedback JSONB,
    advisor_feedback JSONB,
    self_assessment JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_progress_ranges CHECK (
        progress_percentage BETWEEN 0 AND 100 AND
        literature_review_completion BETWEEN 0 AND 100 AND
        data_collection_completion BETWEEN 0 AND 100
    )
);

-- Academic publications and scholarly output tracking
CREATE TABLE academic_publications (
    publication_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    project_id UUID REFERENCES research_projects(project_id) ON DELETE SET NULL,
    
    -- Publication details
    title VARCHAR(500) NOT NULL,
    publication_type publication_type NOT NULL,
    abstract TEXT,
    keywords TEXT[] NOT NULL,
    
    -- Authorship and collaboration
    author_position INTEGER NOT NULL, -- 1st author, 2nd author, etc.
    co_authors JSONB NOT NULL, -- List of co-authors with affiliations
    corresponding_author BOOLEAN DEFAULT false,
    student_first_author BOOLEAN DEFAULT true,
    
    -- Publication venue
    venue_name VARCHAR(300), -- Journal, conference, publisher
    venue_type VARCHAR(50), -- 'journal', 'conference', 'book', 'workshop'
    venue_ranking VARCHAR(20), -- 'Q1', 'A*', 'top-tier', etc.
    venue_impact_factor DECIMAL(6,3),
    venue_acceptance_rate DECIMAL(5,2), -- Percentage
    
    -- Publication timeline
    first_draft_date DATE,
    submission_date DATE,
    review_completion_date DATE,
    acceptance_date DATE,
    publication_date DATE,
    revision_rounds INTEGER DEFAULT 0,
    
    -- Academic impact and metrics
    citation_count INTEGER DEFAULT 0,
    download_count INTEGER DEFAULT 0,
    altmetric_score INTEGER DEFAULT 0,
    media_mentions INTEGER DEFAULT 0,
    
    -- Publication quality indicators
    peer_review_score DECIMAL(3,1), -- Average reviewer score
    significance_rating INTEGER DEFAULT 5, -- 1-10 scale
    methodological_rigor INTEGER DEFAULT 5, -- 1-10 scale
    clarity_and_writing INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Research contribution
    novelty_score INTEGER DEFAULT 5, -- 1-10 scale for original contribution
    practical_impact INTEGER DEFAULT 3, -- 1-10 scale for real-world application
    theoretical_contribution INTEGER DEFAULT 5, -- 1-10 scale for theory advancement
    
    -- Publication status and availability
    publication_status VARCHAR(50) DEFAULT 'in_preparation', -- Status workflow
    open_access BOOLEAN DEFAULT false,
    doi VARCHAR(100) UNIQUE, -- Digital Object Identifier
    url TEXT, -- Link to published version
    preprint_url TEXT, -- Link to preprint version
    
    -- Academic recognition
    awards_received JSONB, -- Best paper awards, recognition
    invited_presentations JSONB, -- Invitations to present this work
    media_coverage JSONB, -- News articles, blog mentions
    
    -- Research data and reproducibility
    dataset_available BOOLEAN DEFAULT false,
    code_available BOOLEAN DEFAULT false,
    reproducibility_materials JSONB, -- Links to supplementary materials
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_author_position CHECK (author_position > 0),
    CONSTRAINT chk_quality_scores CHECK (
        significance_rating BETWEEN 1 AND 10 AND
        methodological_rigor BETWEEN 1 AND 10 AND
        novelty_score BETWEEN 1 AND 10
    )
);

-- Academic conferences and professional development
CREATE TABLE conference_participation (
    participation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    publication_id UUID REFERENCES academic_publications(publication_id) ON DELETE SET NULL,
    
    -- Conference details
    conference_name VARCHAR(300) NOT NULL,
    conference_acronym VARCHAR(20),
    conference_year INTEGER NOT NULL,
    location VARCHAR(200),
    conference_dates DATERANGE,
    
    -- Conference quality and reputation
    conference_ranking VARCHAR(20), -- 'A*', 'A', 'B', 'C'
    acceptance_rate DECIMAL(5,2), -- Percentage
    attendee_count INTEGER,
    international_scope BOOLEAN DEFAULT true,
    
    -- Participation type and contribution
    participation_type VARCHAR(50) NOT NULL, -- 'presenter', 'attendee', 'organizer', 'reviewer'
    presentation_type VARCHAR(50), -- 'oral', 'poster', 'workshop', 'tutorial'
    presentation_title VARCHAR(500),
    presentation_abstract TEXT,
    
    -- Academic networking and impact
    networking_contacts_made INTEGER DEFAULT 0,
    follow_up_collaborations INTEGER DEFAULT 0,
    media_attention_received BOOLEAN DEFAULT false,
    best_paper_nomination BOOLEAN DEFAULT false,
    
    -- Professional development outcomes
    feedback_received JSONB, -- Audience and peer feedback
    questions_and_discussions JSONB, -- Q&A session insights
    future_collaboration_opportunities JSONB,
    career_advancement_impact JSONB,
    
    -- Conference experience quality
    presentation_confidence_rating INTEGER DEFAULT 5, -- 1-10 scale
    networking_success_rating INTEGER DEFAULT 5, -- 1-10 scale
    learning_value_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Professional credibility building
    invited_to_present BOOLEAN DEFAULT false,
    session_chair_role BOOLEAN DEFAULT false,
    program_committee_member BOOLEAN DEFAULT false,
    keynote_speaker BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_conference_year CHECK (conference_year >= 2020 AND conference_year <= 2030),
    CONSTRAINT chk_rating_ranges CHECK (
        presentation_confidence_rating BETWEEN 1 AND 10 AND
        networking_success_rating BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 2. GRADUATE CURRICULUM STRUCTURE
-- ================================================================

-- Graduate curricula optimized for academic excellence
CREATE TABLE graduate_curricula (
    curriculum_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    curriculum_code VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(300) NOT NULL,
    description TEXT NOT NULL,
    
    -- Graduate program alignment
    program_types graduate_program_type[] NOT NULL,
    target_research_domains research_domain[] NOT NULL,
    academic_level academic_complexity DEFAULT 'graduate',
    prerequisites TEXT NOT NULL,
    
    -- Academic timeline and intensity
    total_duration_weeks INTEGER DEFAULT 32, -- Full academic year
    credit_hours INTEGER DEFAULT 3, -- Standard graduate course credits
    weekly_time_commitment INTEGER DEFAULT 9, -- Hours per week (3 credit * 3 hours)
    deep_work_sessions_per_week INTEGER DEFAULT 6, -- Extended focus sessions
    
    -- Research and scholarly focus
    research_component_percentage DECIMAL(3,2) DEFAULT 0.60, -- 60% research focus
    theoretical_foundation_emphasis DECIMAL(3,2) DEFAULT 0.40, -- 40% theory
    practical_application_level INTEGER DEFAULT 8, -- 1-10 scale
    
    -- Academic rigor and standards
    academic_writing_intensity INTEGER DEFAULT 8, -- 1-10 scale
    peer_review_component BOOLEAN DEFAULT true,
    original_research_required BOOLEAN DEFAULT true,
    publication_expectation BOOLEAN DEFAULT false, -- Not required but encouraged
    
    -- Graduate learning outcomes
    expected_skill_mastery_level INTEGER DEFAULT 8, -- 1-10 scale
    research_competency_development BOOLEAN DEFAULT true,
    critical_thinking_emphasis BOOLEAN DEFAULT true,
    methodology_mastery_required BOOLEAN DEFAULT true,
    
    -- Academic credibility building
    conference_presentation_opportunities INTEGER DEFAULT 2,
    publication_pathways JSONB, -- Opportunities for academic publishing
    networking_events INTEGER DEFAULT 4, -- Academic networking opportunities
    mentorship_structure JSONB, -- Faculty and peer mentoring
    
    -- Collaboration and community
    cohort_based_learning BOOLEAN DEFAULT true,
    international_collaboration BOOLEAN DEFAULT false,
    industry_partnership BOOLEAN DEFAULT false,
    interdisciplinary_focus BOOLEAN DEFAULT false,
    
    -- Assessment and evaluation philosophy
    formative_assessment_emphasis BOOLEAN DEFAULT true,
    peer_evaluation_component BOOLEAN DEFAULT true,
    self_reflection_requirements BOOLEAN DEFAULT true,
    portfolio_development BOOLEAN DEFAULT false,
    
    -- Success metrics and outcomes
    completion_rate DECIMAL(5,4), -- Historical completion rate
    average_gpa DECIMAL(3,2), -- Program average GPA
    publication_success_rate DECIMAL(5,4), -- Students who publish
    career_placement_rate DECIMAL(5,4), -- Job placement success
    
    -- Curriculum metadata
    version VARCHAR(20) DEFAULT '1.0',
    accreditation_status VARCHAR(50) DEFAULT 'accredited',
    last_curriculum_review DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_positive_duration CHECK (total_duration_weeks > 0),
    CONSTRAINT chk_percentage_ranges CHECK (
        research_component_percentage BETWEEN 0 AND 1 AND
        theoretical_foundation_emphasis BETWEEN 0 AND 1
    )
);

-- Graduate modules with academic depth
CREATE TABLE graduate_modules (
    module_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    curriculum_id UUID NOT NULL REFERENCES graduate_curricula(curriculum_id) ON DELETE CASCADE,
    module_code VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT NOT NULL,
    
    -- Module structure and academic positioning
    module_number INTEGER NOT NULL,
    duration_weeks INTEGER NOT NULL,
    credit_hours INTEGER DEFAULT 1, -- Partial credit within full course
    prerequisite_modules UUID[], -- Array of prerequisite module IDs
    
    -- Academic learning outcomes
    learning_objectives JSONB NOT NULL, -- Detailed, measurable objectives
    research_skills_developed UUID[], -- Array of skill IDs
    theoretical_concepts JSONB NOT NULL, -- Core concepts and theories
    practical_applications JSONB, -- Real-world applications
    
    -- Graduate-level academic requirements
    required_readings JSONB NOT NULL, -- Essential academic literature
    supplementary_resources JSONB, -- Additional resources for deeper study
    primary_sources JSONB, -- Foundational texts and papers
    current_research JSONB, -- Recent developments and ongoing research
    
    -- Research and writing components
    writing_assignments INTEGER DEFAULT 2, -- Academic writing requirements
    research_components INTEGER DEFAULT 1, -- Research-based assignments
    critical_analysis_requirements JSONB, -- Analytical thinking tasks
    literature_review_scope VARCHAR(100), -- Scope of literature review
    
    -- Assessment and evaluation
    major_assessment_types JSONB, -- Types of major assessments
    peer_review_requirements BOOLEAN DEFAULT false,
    presentation_requirements INTEGER DEFAULT 1,
    portfolio_contributions JSONB, -- What students add to their portfolio
    
    -- Academic collaboration and discussion
    seminar_discussions INTEGER DEFAULT 4, -- Discussion sessions per module
    group_projects INTEGER DEFAULT 0,
    peer_collaboration_opportunities JSONB,
    expert_guest_lectures INTEGER DEFAULT 1,
    
    -- Professional and research development
    industry_connections JSONB, -- Professional networking opportunities
    research_lab_involvement JSONB, -- Laboratory or research center engagement
    conference_relevance JSONB, -- Related conferences and academic events
    publication_opportunities JSONB, -- Potential for academic publication
    
    -- Module difficulty and support
    difficulty_rating INTEGER DEFAULT 7, -- 1-10 scale for graduate level
    support_resources JSONB, -- Academic support available
    office_hours_recommendation INTEGER DEFAULT 2, -- Hours per week
    
    order_index INTEGER DEFAULT 100,
    is_core_module BOOLEAN DEFAULT true,
    elective_alternative BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(curriculum_id, module_code),
    CONSTRAINT chk_positive_weeks CHECK (duration_weeks > 0),
    CONSTRAINT chk_graduate_difficulty CHECK (difficulty_rating BETWEEN 5 AND 10)
);

-- Graduate components with deep academic focus
CREATE TABLE graduate_components (
    component_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL REFERENCES graduate_modules(module_id) ON DELETE CASCADE,
    component_code VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    
    -- Component academic structure
    component_number DECIMAL(3,1) NOT NULL,
    estimated_study_hours INTEGER NOT NULL DEFAULT 6, -- Deep study sessions
    academic_complexity academic_complexity DEFAULT 'graduate',
    
    -- Graduate learning design
    theoretical_depth_required INTEGER DEFAULT 7, -- 1-10 scale
    practical_application_level INTEGER DEFAULT 6, -- 1-10 scale
    research_methodology_emphasis INTEGER DEFAULT 8, -- 1-10 scale
    critical_thinking_requirement INTEGER DEFAULT 8, -- 1-10 scale
    
    -- Academic content structure
    key_concepts JSONB NOT NULL, -- Central academic concepts
    theoretical_frameworks JSONB, -- Theoretical foundations
    research_methods JSONB, -- Methodological approaches
    case_studies JSONB, -- Academic and industry case studies
    
    -- Scholarly resources and literature
    essential_readings JSONB NOT NULL, -- Must-read academic sources
    research_papers JSONB, -- Key research publications
    seminal_works JSONB, -- Foundational texts in the field
    contemporary_research JSONB, -- Recent developments
    
    -- Academic skill development
    analytical_skills_developed JSONB, -- Critical thinking skills
    research_techniques JSONB, -- Specific research methods
    academic_writing_skills JSONB, -- Scholarly writing development
    presentation_skills JSONB, -- Academic presentation abilities
    
    -- Assessment and evaluation methods
    formative_assessments JSONB, -- Ongoing assessment approaches
    summative_assessments JSONB, -- Final evaluation methods
    peer_evaluation_component BOOLEAN DEFAULT false,
    self_assessment_requirements JSONB,
    
    -- Professional development integration
    career_relevance INTEGER DEFAULT 7, -- 1-10 scale for career application
    industry_connections JSONB, -- Professional world connections
    academic_career_preparation JSONB, -- Academic pathway preparation
    
    -- Collaboration and community building
    discussion_topics JSONB, -- Seminar discussion themes
    group_work_requirements JSONB, -- Collaborative learning components
    peer_learning_opportunities JSONB, -- Student-to-student learning
    
    order_index INTEGER DEFAULT 100,
    is_optional BOOLEAN DEFAULT false,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(module_id, component_code),
    CONSTRAINT chk_graduate_study_hours CHECK (estimated_study_hours BETWEEN 3 AND 20)
);

-- Graduate topics with research-level depth
CREATE TABLE graduate_topics (
    topic_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    component_id UUID NOT NULL REFERENCES graduate_components(component_id) ON DELETE CASCADE,
    topic_code VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    
    -- Topic academic characteristics
    estimated_study_hours INTEGER NOT NULL DEFAULT 3, -- Intensive study per topic
    academic_depth_level INTEGER DEFAULT 8, -- 1-10 scale
    research_application_potential INTEGER DEFAULT 7, -- 1-10 scale
    
    -- Graduate learning objectives
    learning_outcomes JSONB NOT NULL, -- Specific topic outcomes
    cognitive_skills_developed JSONB, -- Higher-order thinking skills
    research_applications JSONB, -- How this applies to research
    
    -- Academic content depth
    theoretical_foundations JSONB NOT NULL, -- Core theoretical concepts
    empirical_evidence JSONB, -- Research-based evidence
    controversies_and_debates JSONB, -- Academic debates and open questions
    future_research_directions JSONB, -- Emerging areas for investigation
    
    -- Scholarly engagement requirements
    required_preparation JSONB, -- Pre-reading and preparation
    discussion_questions JSONB, -- Thought-provoking questions
    critical_analysis_prompts JSONB, -- Analytical thinking exercises
    synthesis_opportunities JSONB, -- Integration with other topics
    
    -- Research methodology connection
    applicable_methods JSONB, -- Research methods relevant to this topic
    data_analysis_techniques JSONB, -- Statistical or analytical approaches
    ethical_considerations JSONB, -- Research ethics implications
    
    -- Academic assessment approaches
    knowledge_assessment_methods JSONB, -- How to evaluate understanding
    application_assessments JSONB, -- Practical application evaluations
    creative_synthesis_tasks JSONB, -- Original thinking assignments
    
    -- Professional and career connections
    academic_career_relevance INTEGER DEFAULT 8, -- 1-10 scale
    industry_applications JSONB, -- Professional world connections
    interdisciplinary_connections JSONB, -- Links to other fields
    
    order_index INTEGER DEFAULT 100,
    prerequisite_topics UUID[], -- Other topics that should be completed first
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(component_id, topic_code),
    CONSTRAINT chk_graduate_topic_hours CHECK (estimated_study_hours BETWEEN 1 AND 8)
);

-- Graduate learning units with scholarly depth
CREATE TABLE graduate_learning_units (
    unit_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    topic_id UUID NOT NULL REFERENCES graduate_topics(topic_id) ON DELETE CASCADE,
    unit_code VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    
    -- Unit characteristics for graduate learning
    estimated_study_hours INTEGER DEFAULT 2, -- Intensive focused study
    complexity_rating INTEGER DEFAULT 7, -- 1-10 scale for graduate level
    prerequisite_knowledge JSONB, -- Required background knowledge
    
    -- Graduate learning focus
    learning_objective TEXT NOT NULL,
    academic_skills_developed JSONB, -- Specific academic competencies
    research_relevance TEXT, -- How this contributes to research ability
    
    -- Scholarly content structure
    theoretical_content_depth INTEGER DEFAULT 8, -- 1-10 scale
    empirical_evidence_integration BOOLEAN DEFAULT true,
    methodological_focus JSONB, -- Research methodology emphasis
    critical_evaluation_required BOOLEAN DEFAULT true,
    
    -- Content references and citations
    primary_sources JSONB, -- Key academic sources
    supplementary_readings JSONB, -- Additional scholarly materials
    multimedia_resources JSONB, -- Academic videos, podcasts, presentations
    
    -- Graduate-level engagement
    discussion_preparation JSONB, -- Questions for seminar discussion
    reflection_prompts JSONB, -- Deep thinking and reflection exercises
    synthesis_activities JSONB, -- Integration with broader knowledge
    application_exercises JSONB, -- Practical application of concepts
    
    -- Academic skill development
    writing_skills_emphasis JSONB, -- Academic writing development
    research_skills_practice JSONB, -- Research methodology practice
    critical_thinking_exercises JSONB, -- Analytical skill development
    
    -- Assessment and feedback
    formative_assessment_opportunities JSONB, -- Ongoing feedback methods
    peer_learning_components JSONB, -- Collaborative learning elements
    self_evaluation_criteria JSONB, -- Self-assessment guidelines
    
    -- Professional development connections
    career_applications JSONB, -- How this applies to future career
    academic_networking_opportunities JSONB, -- Professional connections
    conference_relevance JSONB, -- Connections to academic conferences
    
    order_index INTEGER DEFAULT 100,
    is_optional BOOLEAN DEFAULT false,
    requires_prerequisite_completion BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(topic_id, unit_code),
    CONSTRAINT chk_graduate_unit_hours CHECK (estimated_study_hours BETWEEN 1 AND 4),
    CONSTRAINT chk_graduate_complexity CHECK (complexity_rating BETWEEN 5 AND 10)
);

-- ================================================================
-- 3. GRADUATE CONTENT MANAGEMENT
-- ================================================================

-- Graduate content with academic rigor and depth
CREATE TABLE graduate_content (
    content_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES graduate_learning_units(unit_id) ON DELETE SET NULL,
    
    -- Content identification and structure
    external_id VARCHAR(100) UNIQUE,
    title VARCHAR(500) NOT NULL,
    description TEXT,
    content_type VARCHAR(50) NOT NULL,
    academic_format VARCHAR(50) NOT NULL, -- 'research_paper', 'case_study', 'methodology_guide', 'theory_explanation'
    
    -- Graduate-level content storage
    content_markdown TEXT,
    content_html TEXT,
    content_json JSONB,
    academic_citations JSONB, -- Properly formatted academic citations
    bibliography JSONB, -- Complete bibliography in academic format
    
    -- Scholarly depth and rigor
    academic_level academic_complexity DEFAULT 'graduate',
    theoretical_depth INTEGER DEFAULT 7, -- 1-10 scale
    empirical_support INTEGER DEFAULT 6, -- 1-10 scale
    methodological_rigor INTEGER DEFAULT 7, -- 1-10 scale
    
    -- Research and academic context
    research_domain research_domain,
    methodology_focus research_methodology[],
    key_researchers JSONB, -- Leading scholars in this area
    foundational_works JSONB, -- Seminal publications and theories
    
    -- Graduate learning design
    learning_objectives JSONB NOT NULL,
    prerequisite_knowledge JSONB,
    estimated_study_time INTEGER NOT NULL, -- Deep study time required
    cognitive_load INTEGER DEFAULT 7, -- 1-10 scale for mental effort required
    
    -- Academic engagement features
    critical_questions JSONB, -- Questions to provoke critical thinking
    discussion_prompts JSONB, -- Seminar discussion starters
    reflection_exercises JSONB, -- Deep reflection activities
    synthesis_opportunities JSONB, -- Integration with other knowledge
    
    -- Research and methodology connections
    research_applications JSONB, -- How this applies to research projects
    methodology_examples JSONB, -- Examples of research methodologies
    ethical_considerations JSONB, -- Research ethics implications
    data_analysis_connections JSONB, -- Statistical or analytical connections
    
    -- Academic writing and communication
    writing_style_examples JSONB, -- Models of academic writing
    presentation_guidelines JSONB, -- Academic presentation standards
    citation_examples JSONB, -- Proper citation format examples
    peer_review_criteria JSONB, -- Standards for evaluating academic work
    
    -- Content quality and validation
    peer_review_status VARCHAR(50) DEFAULT 'draft', -- Review status
    academic_expert_validation BOOLEAN DEFAULT false,
    content_accuracy_score DECIMAL(3,2) DEFAULT 0,
    scholarly_rigor_rating DECIMAL(3,2) DEFAULT 7,
    
    -- Usage and effectiveness tracking
    engagement_metrics JSONB, -- How students interact with content
    comprehension_indicators JSONB, -- Evidence of student understanding
    application_success_rate DECIMAL(5,4), -- How well students apply concepts
    
    -- Academic tags and classification
    keywords TEXT[] NOT NULL,
    academic_tags VARCHAR(50)[] NOT NULL,
    skill_tags UUID[], -- References to academic_skills
    research_tags VARCHAR(50)[], -- Research methodology tags
    theory_tags VARCHAR(50)[], -- Theoretical framework tags
    
    -- Content maintenance and currency
    last_academic_review DATE,
    research_currency_score INTEGER DEFAULT 7, -- 1-10 how current with latest research
    needs_updating BOOLEAN DEFAULT false,
    update_priority INTEGER DEFAULT 5, -- 1-10 priority for updates
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    created_by UUID,
    
    CONSTRAINT chk_study_time_positive CHECK (estimated_study_time > 0),
    CONSTRAINT chk_academic_scores CHECK (
        theoretical_depth BETWEEN 1 AND 10 AND
        empirical_support BETWEEN 1 AND 10 AND
        methodological_rigor BETWEEN 1 AND 10
    )
);

-- Academic case studies and research scenarios
CREATE TABLE academic_case_studies (
    case_study_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES graduate_content(content_id) ON DELETE CASCADE,
    
    -- Case study identification
    case_title VARCHAR(300) NOT NULL,
    research_domain research_domain NOT NULL,
    methodology_demonstrated research_methodology NOT NULL,
    complexity_level academic_complexity DEFAULT 'graduate',
    
    -- Academic context and background
    theoretical_framework JSONB NOT NULL, -- Underlying theoretical foundations
    literature_context JSONB, -- How this fits in existing research
    research_questions JSONB NOT NULL, -- Questions this case study addresses
    
    -- Case study structure
    background_information TEXT NOT NULL, -- Context and setting
    problem_statement TEXT NOT NULL, -- Research problem or question
    methodology_description TEXT NOT NULL, -- How the research was conducted
    data_collection_methods JSONB, -- Specific data gathering approaches
    analysis_approaches JSONB, -- Data analysis techniques used
    
    -- Results and implications
    findings JSONB NOT NULL, -- Key findings and results
    implications JSONB, -- Theoretical and practical implications
    limitations JSONB, -- Study limitations and constraints
    future_research JSONB, -- Suggested future investigations
    
    -- Learning and pedagogical value
    learning_objectives JSONB, -- What students should learn
    critical_analysis_questions JSONB, -- Questions for critical evaluation
    discussion_topics JSONB, -- Topics for academic discussion
    alternative_approaches JSONB, -- Other ways to approach this problem
    
    -- Academic rigor and validation
    peer_review_comments JSONB, -- Academic peer feedback
    methodological_strengths JSONB, -- Strong aspects of methodology
    areas_for_improvement JSONB, -- Potential methodological improvements
    
    -- Professional development connections
    career_relevance INTEGER DEFAULT 7, -- 1-10 scale
    industry_applications JSONB, -- Real-world applications
    academic_career_preparation JSONB, -- Academic pathway relevance
    
    -- Citation and reference information
    original_publication JSONB, -- If based on published research
    key_citations JSONB, -- Important references
    related_case_studies JSONB, -- Similar cases for comparison
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_career_relevance CHECK (career_relevance BETWEEN 1 AND 10)
);

-- Academic resources and scholarly materials
CREATE TABLE academic_resources (
    resource_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID REFERENCES graduate_content(content_id) ON DELETE CASCADE,
    
    -- Resource identification and type
    resource_title VARCHAR(300) NOT NULL,
    resource_type VARCHAR(100) NOT NULL, -- 'journal_article', 'book_chapter', 'methodology_guide', 'dataset'
    academic_category VARCHAR(50) NOT NULL, -- 'primary_source', 'secondary_source', 'reference_material'
    
    -- Academic context and classification
    research_domain research_domain NOT NULL,
    academic_level academic_complexity DEFAULT 'graduate',
    theoretical_orientation JSONB, -- Theoretical perspectives
    
    -- Resource content and structure
    resource_description TEXT NOT NULL,
    abstract TEXT, -- Academic abstract if applicable
    key_concepts JSONB, -- Main concepts covered
    learning_value JSONB, -- Educational value and applications
    
    -- Academic citation and reference information
    full_citation TEXT, -- Complete academic citation
    doi VARCHAR(100), -- Digital Object Identifier
    isbn VARCHAR(20), -- For books
    publication_year INTEGER,
    journal_name VARCHAR(200),
    conference_name VARCHAR(200),
    
    -- Author and institutional information
    authors JSONB, -- Author names and affiliations
    institutions JSONB, -- Academic institutions involved
    corresponding_author JSONB, -- Contact information if available
    
    -- Academic quality indicators
    peer_reviewed BOOLEAN DEFAULT false,
    impact_factor DECIMAL(6,3), -- Journal impact factor if applicable
    citation_count INTEGER DEFAULT 0,
    academic_reputation INTEGER DEFAULT 5, -- 1-10 scale for academic standing
    
    -- Access and availability
    open_access BOOLEAN DEFAULT false,
    institutional_access BOOLEAN DEFAULT false,
    url TEXT, -- Link to resource
    library_location VARCHAR(200), -- Physical or digital library location
    
    -- Pedagogical information
    reading_difficulty INTEGER DEFAULT 6, -- 1-10 scale for graduate reading
    estimated_reading_time INTEGER, -- Minutes for thorough reading
    prerequisite_knowledge JSONB, -- Background needed to understand
    follow_up_resources JSONB, -- Related resources for deeper study
    
    -- Usage and application
    course_applications JSONB, -- How this is used in courses
    research_applications JSONB, -- How this applies to research
    methodology_demonstrations JSONB, -- Research methods illustrated
    
    -- Quality and validation
    academic_review_status VARCHAR(50) DEFAULT 'pending',
    faculty_recommendation BOOLEAN DEFAULT false,
    student_rating DECIMAL(3,2), -- Average student rating
    usage_frequency INTEGER DEFAULT 0, -- How often accessed
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_reading_difficulty CHECK (reading_difficulty BETWEEN 1 AND 10),
    CONSTRAINT chk_academic_reputation CHECK (academic_reputation BETWEEN 1 AND 10)
);

-- ================================================================
-- 4. GRADUATE AI AVATAR SYSTEM
-- ================================================================

-- Graduate AI avatars specialized for academic mentorship
CREATE TABLE graduate_ai_avatars (
    avatar_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    avatar_name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    
    -- Avatar academic specialization
    primary_role graduate_avatar_role NOT NULL,
    research_domains research_domain[] NOT NULL,
    academic_expertise academic_complexity[] DEFAULT ARRAY['graduate', 'research', 'expert'],
    
    -- Academic credentials and experience
    simulated_academic_background JSONB, -- PhD, postdoc, faculty experience
    years_of_academic_experience INTEGER DEFAULT 10,
    research_publications INTEGER DEFAULT 25,
    successful_students_mentored INTEGER DEFAULT 50,
    
    -- Avatar capabilities for graduate students
    can_guide_thesis_writing BOOLEAN DEFAULT false,
    can_provide_methodology_advice BOOLEAN DEFAULT false,
    can_review_academic_writing BOOLEAN DEFAULT false,
    can_suggest_research_directions BOOLEAN DEFAULT false,
    can_provide_career_guidance BOOLEAN DEFAULT false,
    can_facilitate_peer_review BOOLEAN DEFAULT false,
    
    -- Communication style for academic context
    academic_formality_level INTEGER DEFAULT 7, -- 1-10 scale, higher for academic
    encouragement_style VARCHAR(50) DEFAULT 'scholarly', -- 'supportive', 'challenging', 'scholarly'
    feedback_approach VARCHAR(50) DEFAULT 'constructive', -- 'direct', 'constructive', 'socratic'
    
    -- Graduate student mentorship approach
    mentorship_philosophy TEXT,
    research_guidance_style VARCHAR(50) DEFAULT 'collaborative', -- 'directive', 'collaborative', 'socratic'
    writing_feedback_focus VARCHAR(50) DEFAULT 'comprehensive', -- 'grammar', 'structure', 'comprehensive'
    
    -- Academic networking and professional development
    networking_facilitation BOOLEAN DEFAULT false,
    conference_preparation_support BOOLEAN DEFAULT false,
    publication_strategy_guidance BOOLEAN DEFAULT false,
    academic_career_counseling BOOLEAN DEFAULT false,
    
    -- Avatar knowledge and expertise areas
    theoretical_frameworks_expertise JSONB, -- Specific theories and frameworks
    methodology_expertise JSONB, -- Research methodologies mastered
    statistical_analysis_capabilities JSONB, -- Statistical methods supported
    academic_writing_specializations JSONB, -- Writing genres and formats
    
    -- Avatar status and versioning
    is_active BOOLEAN DEFAULT true,
    version VARCHAR(10) DEFAULT '1.0',
    last_knowledge_update DATE,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_academic_formality CHECK (academic_formality_level BETWEEN 1 AND 10),
    CONSTRAINT chk_academic_experience CHECK (years_of_academic_experience BETWEEN 5 AND 30)
);

-- Avatar academic content variations and mentoring approaches
CREATE TABLE graduate_avatar_content (
    variation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES graduate_content(content_id) ON DELETE CASCADE,
    avatar_id UUID NOT NULL REFERENCES graduate_ai_avatars(avatar_id) ON DELETE CASCADE,
    
    -- Academic mentoring context adaptation
    theoretical_perspective TEXT, -- How this avatar approaches the theory
    methodology_emphasis JSONB, -- Research methodology focus
    critical_analysis_approach TEXT, -- How to critically evaluate
    
    -- Avatar-specific academic guidance
    research_applications JSONB, -- How this applies to research projects
    thesis_integration_suggestions JSONB, -- How to integrate into thesis work
    publication_potential_assessment JSONB, -- Publishing opportunities
    
    -- Academic communication style
    scholarly_tone_adaptation TEXT, -- Academic writing style guidance
    discussion_facilitation JSONB, -- How to lead academic discussions
    peer_review_guidance JSONB, -- How to give and receive peer feedback
    
    -- Mentorship and development support
    skill_development_roadmap JSONB, -- Progression path for academic skills
    research_milestone_guidance JSONB, -- How to achieve research milestones
    academic_networking_advice JSONB, -- Professional development guidance
    
    -- Graduate student support features
    thesis_writing_support JSONB, -- Specific thesis writing guidance
    literature_review_strategy JSONB, -- How to conduct literature reviews
    methodology_selection_criteria JSONB, -- Choosing appropriate methods
    
    -- Academic career preparation
    academic_job_market_preparation JSONB, -- Academic career guidance
    industry_transition_advice JSONB, -- Moving from academia to industry
    conference_presentation_tips JSONB, -- Academic presentation skills
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, avatar_id)
);

-- ================================================================
-- 5. GRADUATE ASSESSMENT SYSTEM
-- ================================================================

-- Graduate assessments with academic rigor and depth
CREATE TABLE graduate_assessments (
    assessment_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    unit_id UUID REFERENCES graduate_learning_units(unit_id) ON DELETE CASCADE,
    
    -- Assessment identification and type
    assessment_code VARCHAR(50) NOT NULL,
    title VARCHAR(300) NOT NULL,
    description TEXT,
    
    -- Graduate-level assessment characteristics
    assessment_type VARCHAR(50) NOT NULL, -- 'research_paper', 'critical_analysis', 'methodology_design', 'literature_review'
    academic_rigor_level INTEGER DEFAULT 8, -- 1-10 scale for graduate level
    research_component_required BOOLEAN DEFAULT true,
    
    -- Assessment timeline and scope
    estimated_completion_hours INTEGER DEFAULT 15, -- Substantial time investment
    preparation_time_hours INTEGER DEFAULT 5, -- Research and planning time
    deadline_flexibility BOOLEAN DEFAULT false, -- Academic deadlines typically fixed
    
    -- Academic assessment criteria
    total_possible_points INTEGER DEFAULT 100,
    minimum_passing_score INTEGER DEFAULT 70, -- Graduate level standards
    theoretical_understanding_weight DECIMAL(3,2) DEFAULT 0.30,
    methodology_application_weight DECIMAL(3,2) DEFAULT 0.30,
    critical_analysis_weight DECIMAL(3,2) DEFAULT 0.25,
    academic_writing_weight DECIMAL(3,2) DEFAULT 0.15,
    
    -- Graduate learning assessment focus
    original_thinking_required BOOLEAN DEFAULT true,
    peer_review_component BOOLEAN DEFAULT false,
    presentation_component BOOLEAN DEFAULT false,
    collaboration_component BOOLEAN DEFAULT false,
    
    -- Academic standards and expectations
    citation_requirements JSONB, -- Academic citation standards
    writing_style_requirements JSONB, -- Academic writing expectations
    length_requirements JSONB, -- Word count or page requirements
    formatting_standards JSONB, -- Academic formatting guidelines
    
    -- Assessment instructions and guidelines
    instructions TEXT NOT NULL,
    grading_rubric JSONB NOT NULL, -- Detailed grading criteria
    submission_guidelines JSONB, -- How to submit work
    academic_integrity_requirements JSONB, -- Plagiarism and ethics guidelines
    
    -- Feedback and evaluation
    feedback_timeline VARCHAR(50) DEFAULT '2_weeks', -- Time to receive feedback
    revision_opportunities INTEGER DEFAULT 0, -- Chances to revise work
    peer_feedback_component BOOLEAN DEFAULT false,
    self_evaluation_component BOOLEAN DEFAULT false,
    
    -- Professional development connections
    career_relevance INTEGER DEFAULT 7, -- 1-10 scale
    portfolio_contribution JSONB, -- How this adds to student portfolio
    publication_potential JSONB, -- Opportunity for academic publication
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_graduate_rigor CHECK (academic_rigor_level BETWEEN 6 AND 10),
    CONSTRAINT chk_assessment_weights CHECK (
        theoretical_understanding_weight + methodology_application_weight + 
        critical_analysis_weight + academic_writing_weight = 1.0
    )
);

-- Graduate assessment questions with academic depth
CREATE TABLE graduate_assessment_questions (
    question_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assessment_id UUID NOT NULL REFERENCES graduate_assessments(assessment_id) ON DELETE CASCADE,
    
    -- Question content and structure
    question_text TEXT NOT NULL,
    question_type VARCHAR(50) NOT NULL, -- 'essay', 'research_design', 'critical_analysis', 'case_study_analysis'
    points_possible INTEGER DEFAULT 25,
    
    -- Graduate-level question characteristics
    cognitive_complexity INTEGER DEFAULT 8, -- 1-10 scale for higher-order thinking
    research_skills_assessed JSONB, -- Which research skills this evaluates
    theoretical_knowledge_required JSONB, -- Theoretical background needed
    
    -- Academic question content
    background_context TEXT, -- Academic context for the question
    theoretical_framework TEXT, -- Theoretical lens for analysis
    methodology_considerations TEXT, -- Research methodology aspects
    
    -- Assessment criteria and expectations
    evaluation_criteria JSONB NOT NULL, -- Specific grading criteria
    exemplary_response_characteristics JSONB, -- What constitutes excellent work
    common_mistakes_to_avoid JSONB, -- Typical errors students make
    
    -- Academic support materials
    required_readings JSONB, -- Specific readings for this question
    supplementary_resources JSONB, -- Additional helpful resources
    citation_expectations JSONB, -- Citation requirements for this question
    
    -- Research and methodology focus
    research_methods_application JSONB, -- How to apply research methods
    data_analysis_requirements JSONB, -- Any data analysis components
    ethical_considerations JSONB, -- Research ethics implications
    
    -- Question scaffolding and support
    guiding_questions JSONB, -- Sub-questions to guide thinking
    conceptual_framework JSONB, -- Conceptual structure for response
    suggested_approach JSONB, -- Recommended approach to answering
    
    -- Academic writing expectations
    writing_style_requirements JSONB, -- Academic writing standards
    structure_expectations JSONB, -- How response should be organized
    evidence_requirements JSONB, -- Types of evidence needed
    
    -- Question performance and analytics
    average_score DECIMAL(5,2), -- Historical average score
    completion_rate DECIMAL(5,4), -- Percentage who complete this question
    time_spent_average INTEGER, -- Average time spent in minutes
    
    order_index INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_positive_points CHECK (points_possible > 0),
    CONSTRAINT chk_graduate_complexity CHECK (cognitive_complexity BETWEEN 6 AND 10)
);

-- Graduate thesis and dissertation tracking
CREATE TABLE graduate_thesis_work (
    thesis_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    project_id UUID REFERENCES research_projects(project_id) ON DELETE SET NULL,
    
    -- Thesis identification and type
    thesis_title VARCHAR(500) NOT NULL,
    thesis_type graduate_program_type NOT NULL, -- 'masters_thesis', 'phd_dissertation'
    research_domain research_domain NOT NULL,
    methodology research_methodology NOT NULL,
    
    -- Academic supervision and committee
    primary_advisor_id UUID, -- Main thesis advisor
    committee_members JSONB, -- Thesis committee information
    external_examiner_id UUID, -- External examiner if applicable
    
    -- Thesis structure and progress
    total_planned_chapters INTEGER DEFAULT 5,
    chapters_completed INTEGER DEFAULT 0,
    current_chapter INTEGER DEFAULT 1,
    word_count_current INTEGER DEFAULT 0,
    word_count_target INTEGER DEFAULT 50000, -- Typical thesis length
    
    -- Academic timeline and milestones
    proposal_defense_date DATE,
    proposal_approval_date DATE,
    comprehensive_exam_date DATE, -- For PhD students
    candidacy_date DATE, -- When advanced to candidacy
    thesis_defense_date DATE,
    final_submission_date DATE,
    
    -- Progress tracking by section
    literature_review_progress DECIMAL(5,2) DEFAULT 0,
    methodology_section_progress DECIMAL(5,2) DEFAULT 0,
    data_collection_progress DECIMAL(5,2) DEFAULT 0,
    analysis_progress DECIMAL(5,2) DEFAULT 0,
    writing_progress DECIMAL(5,2) DEFAULT 0,
    revision_progress DECIMAL(5,2) DEFAULT 0,
    
    -- Academic quality and standards
    academic_writing_quality INTEGER DEFAULT 5, -- 1-10 scale
    research_rigor_level INTEGER DEFAULT 6, -- 1-10 scale
    original_contribution_significance INTEGER DEFAULT 5, -- 1-10 scale
    methodology_appropriateness INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Thesis content and contributions
    research_questions JSONB NOT NULL,
    theoretical_framework JSONB,
    key_contributions JSONB,
    implications_for_field JSONB,
    limitations_and_constraints JSONB,
    future_research_directions JSONB,
    
    -- Academic support and feedback
    advisor_meetings_frequency VARCHAR(50) DEFAULT 'biweekly',
    committee_feedback JSONB,
    peer_review_feedback JSONB,
    writing_center_support BOOLEAN DEFAULT false,
    
    -- Publication and dissemination plans
    publication_plans JSONB, -- Plan for publishing thesis work
    conference_presentation_plans JSONB,
    potential_impact_assessment JSONB,
    media_and_outreach_plans JSONB,
    
    -- Thesis completion and evaluation
    defense_outcome VARCHAR(50), -- 'pass', 'pass_with_minor_revisions', 'pass_with_major_revisions', 'fail'
    final_grade VARCHAR(10), -- Final thesis grade
    committee_recommendations JSONB,
    post_defense_revisions_required JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_word_counts CHECK (word_count_target > 0 AND word_count_current >= 0),
    CONSTRAINT chk_progress_percentages CHECK (
        literature_review_progress BETWEEN 0 AND 100 AND
        writing_progress BETWEEN 0 AND 100
    ),
    CONSTRAINT chk_quality_ratings CHECK (
        academic_writing_quality BETWEEN 1 AND 10 AND
        research_rigor_level BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 6. GRADUATE LEARNING PROGRESS & ANALYTICS
-- ================================================================

-- Graduate progress tracking optimized for academic development
CREATE TABLE graduate_progress (
    progress_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    unit_id UUID NOT NULL REFERENCES graduate_learning_units(unit_id) ON DELETE CASCADE,
    
    -- Academic progress status
    status academic_progress DEFAULT 'planned',
    completion_percentage DECIMAL(5,2) DEFAULT 0,
    academic_mastery_level INTEGER DEFAULT 1, -- 1-10 scale
    
    -- Graduate study time tracking
    total_study_hours DECIMAL(6,2) DEFAULT 0,
    deep_work_sessions INTEGER DEFAULT 0,
    average_session_duration_hours DECIMAL(4,1) DEFAULT 0,
    optimal_session_duration INTEGER DEFAULT 3, -- Hours for deep academic work
    
    -- Academic engagement quality
    reading_completion_rate DECIMAL(5,2) DEFAULT 0, -- Percentage of readings completed
    note_taking_quality INTEGER DEFAULT 5, -- 1-10 scale
    discussion_participation_level INTEGER DEFAULT 5, -- 1-10 scale
    critical_thinking_demonstration INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Research skill development
    literature_review_skills INTEGER DEFAULT 3, -- 1-10 scale
    methodology_understanding INTEGER DEFAULT 3, -- 1-10 scale
    data_analysis_proficiency INTEGER DEFAULT 3, -- 1-10 scale
    academic_writing_improvement INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Graduate-level learning outcomes
    theoretical_understanding INTEGER DEFAULT 5, -- 1-10 scale
    practical_application_ability INTEGER DEFAULT 4, -- 1-10 scale
    synthesis_and_integration INTEGER DEFAULT 4, -- 1-10 scale
    original_thinking_development INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Academic collaboration and peer learning
    peer_collaboration_engagement INTEGER DEFAULT 5, -- 1-10 scale
    peer_review_participation BOOLEAN DEFAULT false,
    academic_discussions_contributed INTEGER DEFAULT 0,
    knowledge_sharing_instances INTEGER DEFAULT 0,
    
    -- Research application and projects
    research_project_application BOOLEAN DEFAULT false,
    thesis_work_integration BOOLEAN DEFAULT false,
    publication_potential_identified BOOLEAN DEFAULT false,
    conference_presentation_opportunity BOOLEAN DEFAULT false,
    
    -- Academic confidence and development
    subject_matter_confidence INTEGER DEFAULT 4, -- 1-10 scale
    research_confidence INTEGER DEFAULT 3, -- 1-10 scale
    academic_writing_confidence INTEGER DEFAULT 4, -- 1-10 scale
    presentation_confidence INTEGER DEFAULT 4, -- 1-10 scale
    
    -- Time management and study habits
    procrastination_level INTEGER DEFAULT 5, -- 1-10 scale (lower is better)
    time_management_effectiveness INTEGER DEFAULT 5, -- 1-10 scale
    study_schedule_adherence DECIMAL(5,2) DEFAULT 60, -- Percentage
    deadline_management_success INTEGER DEFAULT 6, -- 1-10 scale
    
    -- Academic milestone progress
    reading_goals_met DECIMAL(5,2) DEFAULT 0, -- Percentage of reading goals achieved
    writing_milestones_reached INTEGER DEFAULT 0,
    research_benchmarks_achieved INTEGER DEFAULT 0,
    learning_objectives_mastered INTEGER DEFAULT 0,
    
    -- Session and engagement timestamps
    first_accessed_at TIMESTAMPTZ,
    last_accessed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    research_applied_at TIMESTAMPTZ,
    
    -- Academic reflection and notes
    learning_reflections TEXT,
    key_insights JSONB,
    challenges_encountered JSONB,
    breakthrough_moments JSONB,
    
    -- Future academic planning
    follow_up_research_interests JSONB,
    additional_reading_identified JSONB,
    skill_development_priorities JSONB,
    academic_networking_opportunities JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, unit_id),
    CONSTRAINT chk_completion_percentage CHECK (completion_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_mastery_levels CHECK (
        academic_mastery_level BETWEEN 1 AND 10 AND
        theoretical_understanding BETWEEN 1 AND 10 AND
        subject_matter_confidence BETWEEN 1 AND 10
    )
);

-- Graduate skill development with academic focus
CREATE TABLE graduate_skill_development (
    development_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    skill_id UUID NOT NULL REFERENCES academic_skills(skill_id) ON DELETE CASCADE,
    
    -- Current academic skill status
    current_proficiency INTEGER DEFAULT 3, -- 1-10 scale, starting at graduate entry level
    target_proficiency INTEGER DEFAULT 8, -- Graduate-level expectation
    proficiency_trajectory JSONB, -- Progress over time
    
    -- Academic learning journey
    learning_start_date DATE,
    target_mastery_date DATE,
    thesis_application_date DATE,
    research_application_date DATE,
    teaching_application_date DATE, -- When started teaching this skill
    
    -- Graduate development metrics
    research_projects_applied INTEGER DEFAULT 0,
    academic_papers_utilized INTEGER DEFAULT 0,
    conference_presentations_featured INTEGER DEFAULT 0,
    peer_teaching_instances INTEGER DEFAULT 0,
    
    -- Academic recognition and validation
    advisor_recognition BOOLEAN DEFAULT false,
    peer_acknowledgment BOOLEAN DEFAULT false,
    conference_feedback_positive BOOLEAN DEFAULT false,
    publication_contribution BOOLEAN DEFAULT false,
    
    -- Learning methods and approaches
    formal_coursework_hours DECIMAL(5,2) DEFAULT 0,
    independent_study_hours DECIMAL(5,2) DEFAULT 0,
    research_application_hours DECIMAL(5,2) DEFAULT 0,
    peer_collaboration_hours DECIMAL(5,2) DEFAULT 0,
    
    -- Academic skill validation
    theoretical_understanding INTEGER DEFAULT 4, -- 1-10 scale
    practical_application_ability INTEGER DEFAULT 3, -- 1-10 scale
    research_methodology_connection INTEGER DEFAULT 3, -- 1-10 scale
    teaching_and_explanation_ability INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Professional and academic impact
    thesis_contribution_significance INTEGER DEFAULT 0, -- How much this skill contributes to thesis
    publication_readiness_level INTEGER DEFAULT 3, -- 1-10 readiness for publication
    academic_career_relevance INTEGER DEFAULT 6, -- 1-10 scale for academic career
    industry_transferability INTEGER DEFAULT 5, -- 1-10 scale for industry application
    
    -- Skill development context
    primary_learning_context VARCHAR(100), -- 'coursework', 'research', 'independent_study'
    mentor_guidance_received JSONB, -- Mentorship and guidance information
    peer_learning_contributions JSONB, -- How peers helped develop this skill
    
    -- Academic networking and community
    conferences_attended_for_skill INTEGER DEFAULT 0,
    experts_networked_with INTEGER DEFAULT 0,
    study_groups_participated INTEGER DEFAULT 0,
    academic_communities_joined INTEGER DEFAULT 0,
    
    -- Continuous improvement and advancement
    current_learning_resources JSONB,
    advanced_skill_development_plan JSONB,
    research_application_opportunities JSONB,
    teaching_and_mentoring_plans JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, skill_id),
    CONSTRAINT chk_proficiency_ranges CHECK (
        current_proficiency BETWEEN 1 AND 10 AND
        target_proficiency BETWEEN 1 AND 10 AND
        target_proficiency >= current_proficiency
    )
);

-- Academic study sessions with depth and focus tracking
CREATE TABLE graduate_study_sessions (
    session_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    
    -- Session identification and type
    session_type VARCHAR(50) DEFAULT 'deep_study', -- 'reading', 'writing', 'research', 'analysis'
    academic_focus VARCHAR(100), -- What was the main focus
    
    -- Graduate study session timing
    started_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMPTZ,
    planned_duration_hours INTEGER DEFAULT 3, -- Graduate-level study sessions
    actual_duration_hours DECIMAL(4,1),
    
    -- Academic content and progress
    units_studied UUID[],
    readings_completed JSONB, -- What readings were completed
    notes_taken_pages INTEGER DEFAULT 0,
    concepts_mastered JSONB, -- New concepts learned
    
    -- Session quality and effectiveness
    focus_quality INTEGER DEFAULT 7, -- 1-10 scale
    comprehension_self_rating INTEGER DEFAULT 6, -- 1-10 scale
    productivity_rating INTEGER DEFAULT 6, -- 1-10 scale
    academic_satisfaction INTEGER DEFAULT 6, -- 1-10 scale
    
    -- Graduate-level learning activities
    critical_analysis_performed BOOLEAN DEFAULT false,
    original_insights_developed BOOLEAN DEFAULT false,
    connections_to_research_made BOOLEAN DEFAULT false,
    thesis_work_advanced BOOLEAN DEFAULT false,
    
    -- Academic environment and context
    study_location VARCHAR(100), -- 'library', 'home_office', 'lab', 'coffee_shop'
    collaboration_involved BOOLEAN DEFAULT false,
    peer_discussion_time_minutes INTEGER DEFAULT 0,
    advisor_consultation BOOLEAN DEFAULT false,
    
    -- Session challenges and support
    difficulties_encountered JSONB, -- Academic challenges faced
    support_resources_used JSONB, -- What resources helped
    procrastination_time_minutes INTEGER DEFAULT 0,
    interruption_frequency INTEGER DEFAULT 0,
    
    -- Learning outcomes and achievements
    learning_objectives_met DECIMAL(5,2) DEFAULT 70, -- Percentage
    breakthrough_understanding BOOLEAN DEFAULT false,
    research_questions_generated JSONB, -- New research questions that emerged
    follow_up_actions_identified JSONB,
    
    -- Academic reflection and planning
    session_reflection TEXT,
    key_takeaways JSONB,
    areas_needing_more_work JSONB,
    next_session_planning JSONB,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Graduate academic performance analytics
CREATE TABLE graduate_performance_analytics (
    analytics_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    analysis_date DATE NOT NULL,
    
    -- Academic performance overview
    overall_gpa DECIMAL(3,2), -- Graduate GPA
    courses_completed INTEGER DEFAULT 0,
    courses_in_progress INTEGER DEFAULT 0,
    credit_hours_completed INTEGER DEFAULT 0,
    
    -- Research and thesis progress
    thesis_progress_percentage DECIMAL(5,2) DEFAULT 0,
    research_projects_active INTEGER DEFAULT 1,
    research_milestones_achieved INTEGER DEFAULT 0,
    publications_in_progress INTEGER DEFAULT 0,
    
    -- Academic skill development metrics
    average_skill_proficiency DECIMAL(3,2) DEFAULT 4.0, -- 1-10 scale
    research_skills_mastered INTEGER DEFAULT 0,
    methodology_competencies INTEGER DEFAULT 0,
    academic_writing_improvement DECIMAL(3,2) DEFAULT 0,
    
    -- Study habits and time management
    weekly_study_hours DECIMAL(5,2) DEFAULT 0,
    deep_work_sessions_per_week DECIMAL(4,1) DEFAULT 0,
    average_session_focus_quality DECIMAL(3,2) DEFAULT 6,
    time_management_effectiveness DECIMAL(3,2) DEFAULT 5,
    
    -- Academic engagement and collaboration
    peer_collaboration_frequency INTEGER DEFAULT 0,
    academic_discussion_participation INTEGER DEFAULT 0,
    conference_attendance INTEGER DEFAULT 0,
    networking_events_attended INTEGER DEFAULT 0,
    
    -- Research output and impact
    papers_submitted INTEGER DEFAULT 0,
    presentations_given INTEGER DEFAULT 0,
    citations_received INTEGER DEFAULT 0,
    academic_recognition_events INTEGER DEFAULT 0,
    
    -- Professional development progress
    professional_skills_developed INTEGER DEFAULT 0,
    industry_connections_made INTEGER DEFAULT 0,
    job_market_preparation_progress DECIMAL(5,2) DEFAULT 0,
    career_readiness_score INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Academic confidence and well-being
    academic_confidence_average DECIMAL(3,2) DEFAULT 5,
    research_confidence_level DECIMAL(3,2) DEFAULT 4,
    thesis_confidence_rating DECIMAL(3,2) DEFAULT 4,
    overall_program_satisfaction DECIMAL(3,2) DEFAULT 6,
    
    -- Learning efficiency and productivity
    learning_efficiency_rate DECIMAL(5,4), -- Concepts learned per hour
    research_productivity_score DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    academic_writing_productivity DECIMAL(5,2), -- Pages written per week
    
    -- Future planning and goals
    career_goal_progress DECIMAL(5,2) DEFAULT 0, -- Percentage toward career goals
    skill_development_priorities JSONB,
    research_direction_clarity INTEGER DEFAULT 5, -- 1-10 scale
    post_graduation_preparation_score INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Comparative and contextual metrics
    peer_performance_percentile INTEGER, -- How student ranks among peers
    program_average_comparison DECIMAL(3,2), -- Performance relative to program average
    improvement_rate DECIMAL(5,4), -- Rate of academic improvement
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, analysis_date),
    CONSTRAINT chk_gpa_range CHECK (overall_gpa IS NULL OR overall_gpa BETWEEN 0 AND 4.0),
    CONSTRAINT chk_confidence_ranges CHECK (
        academic_confidence_average BETWEEN 1 AND 10 AND
        research_confidence_level BETWEEN 1 AND 10 AND
        career_readiness_score BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 7. SEMANTIC SEARCH & ACADEMIC INTELLIGENCE
-- ================================================================

-- Academic embedding models optimized for scholarly content
CREATE TABLE academic_embedding_models (
    model_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    model_name VARCHAR(100) NOT NULL UNIQUE,
    provider VARCHAR(50) NOT NULL,
    model_version VARCHAR(20),
    embedding_dimensions INTEGER NOT NULL,
    
    -- Academic specialization
    research_domains_optimized research_domain[],
    academic_levels_supported academic_complexity[],
    scholarly_content_optimized BOOLEAN DEFAULT true,
    
    -- Model characteristics for academic content
    context_window INTEGER,
    accuracy_score DECIMAL(5,4),
    academic_precision_score DECIMAL(5,4), -- Accuracy on academic content
    citation_understanding BOOLEAN DEFAULT false, -- Can parse citations
    
    -- Performance for graduate-level content
    theoretical_content_performance DECIMAL(5,4), -- Performance on theoretical material
    methodology_content_performance DECIMAL(5,4), -- Performance on research methods
    interdisciplinary_capability DECIMAL(5,4), -- Handling cross-domain content
    
    -- Status and usage
    is_active BOOLEAN DEFAULT true,
    is_primary BOOLEAN DEFAULT false,
    computational_requirements JSONB, -- Hardware/software requirements
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_dimensions_positive CHECK (embedding_dimensions > 0)
);

-- Academic content embeddings with scholarly focus
CREATE TABLE academic_content_embeddings (
    embedding_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES graduate_content(content_id) ON DELETE CASCADE,
    model_id UUID NOT NULL REFERENCES academic_embedding_models(model_id),
    
    -- Vector embeddings for academic content
    content_vector vector NOT NULL,
    theoretical_vector vector, -- Theoretical concepts vector
    methodological_vector vector, -- Research methodology vector
    disciplinary_vector vector, -- Research domain vector
    
    -- Academic semantic features
    citation_context_vector vector, -- Citation and reference context
    research_question_vector vector, -- Research questions and problems
    academic_writing_style_vector vector, -- Academic discourse patterns
    
    -- Embedding metadata
    content_hash VARCHAR(64) NOT NULL,
    token_count INTEGER,
    academic_keywords JSONB, -- Key academic terms
    theoretical_frameworks JSONB, -- Theoretical perspectives identified
    methodology_tags JSONB, -- Research methodologies referenced
    
    -- Quality and academic relevance
    embedding_quality_score DECIMAL(5,4),
    academic_relevance_score DECIMAL(5,4), -- Relevance to academic work
    research_applicability_score DECIMAL(5,4), -- Application to research
    theoretical_depth_score DECIMAL(5,4), -- Theoretical sophistication
    
    -- Performance and usage metrics
    search_frequency INTEGER DEFAULT 0,
    academic_match_accuracy DECIMAL(5,4), -- Accuracy for academic searches
    user_relevance_rating DECIMAL(3,2),
    citation_prediction_accuracy DECIMAL(5,4), -- Accuracy predicting citations
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, model_id)
);

-- Academic skill-content mapping with research focus
CREATE TABLE academic_skill_content_mapping (
    mapping_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES graduate_content(content_id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES academic_skills(skill_id) ON DELETE CASCADE,
    
    -- Academic mapping characteristics
    relevance_score DECIMAL(3,2) NOT NULL, -- 1-10 scale
    skill_development_contribution DECIMAL(3,2) DEFAULT 6, -- 1-10 scale for graduate level
    research_application_value DECIMAL(3,2) DEFAULT 6, -- 1-10 scale
    
    -- Graduate learning context
    theoretical_foundation_contribution DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    methodology_skill_development DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    critical_thinking_enhancement DECIMAL(3,2) DEFAULT 6, -- 1-10 scale
    academic_writing_improvement DECIMAL(3,2) DEFAULT 4, -- 1-10 scale
    
    -- Research and thesis relevance
    thesis_applicability DECIMAL(3,2) DEFAULT 4, -- 1-10 scale
    publication_preparation_value DECIMAL(3,2) DEFAULT 3, -- 1-10 scale
    conference_presentation_relevance DECIMAL(3,2) DEFAULT 3, -- 1-10 scale
    
    -- Academic skill progression
    introduces_skill BOOLEAN DEFAULT false,
    develops_skill BOOLEAN DEFAULT true,
    masters_skill BOOLEAN DEFAULT false,
    applies_skill_to_research BOOLEAN DEFAULT false,
    enables_peer_teaching BOOLEAN DEFAULT false,
    
    -- Graduate learning characteristics
    requires_deep_study BOOLEAN DEFAULT true, -- Needs extended focus
    collaborative_learning_value DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    independent_research_applicability DECIMAL(3,2) DEFAULT 6, -- 1-10 scale
    
    -- Academic career preparation
    academic_career_preparation DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    industry_transition_value DECIMAL(3,2) DEFAULT 4, -- 1-10 scale
    thought_leadership_potential DECIMAL(3,2) DEFAULT 3, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(content_id, skill_id),
    CONSTRAINT chk_academic_mapping_scores CHECK (
        relevance_score BETWEEN 1 AND 10 AND
        research_application_value BETWEEN 1 AND 10 AND
        thesis_applicability BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 8. GRADUATE ANALYTICS & ACADEMIC PERFORMANCE
-- ================================================================

-- Graduate learning analytics with academic focus
CREATE TABLE graduate_learning_analytics (
    analytics_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    analysis_date DATE NOT NULL,
    
    -- Academic performance metrics
    daily_study_hours DECIMAL(5,2) DEFAULT 0,
    deep_work_sessions INTEGER DEFAULT 0,
    average_session_duration DECIMAL(4,1) DEFAULT 0,
    academic_focus_quality DECIMAL(3,2) DEFAULT 6, -- 1-10 scale
    
    -- Graduate skill development
    skills_in_development INTEGER DEFAULT 0,
    skills_research_ready INTEGER DEFAULT 0,
    skills_thesis_applied INTEGER DEFAULT 0,
    skills_publication_ready INTEGER DEFAULT 0,
    
    -- Academic engagement indicators
    readings_completed INTEGER DEFAULT 0,
    academic_discussions_participated INTEGER DEFAULT 0,
    peer_collaborations INTEGER DEFAULT 0,
    advisor_consultations INTEGER DEFAULT 0,
    
    -- Research and thesis progress
    research_milestones_achieved INTEGER DEFAULT 0,
    thesis_chapters_progressed INTEGER DEFAULT 0,
    literature_review_papers_added INTEGER DEFAULT 0,
    methodology_development_progress INTEGER DEFAULT 0,
    
    -- Academic output and productivity
    academic_writing_pages INTEGER DEFAULT 0,
    research_notes_created INTEGER DEFAULT 0,
    critical_analyses_completed INTEGER DEFAULT 0,
    presentations_prepared INTEGER DEFAULT 0,
    
    -- Professional development activities
    conferences_attended INTEGER DEFAULT 0,
    networking_contacts_made INTEGER DEFAULT 0,
    publication_submissions INTEGER DEFAULT 0,
    peer_review_activities INTEGER DEFAULT 0,
    
    -- Learning effectiveness measures
    comprehension_rate DECIMAL(5,4) DEFAULT 0.70, -- Understanding rate
    retention_rate DECIMAL(5,4) DEFAULT 0.65, -- Knowledge retention
    application_success_rate DECIMAL(5,4) DEFAULT 0.60, -- Research application success
    
    -- Academic confidence and well-being
    academic_confidence_level DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    research_confidence_rating DECIMAL(3,2) DEFAULT 4, -- 1-10 scale
    thesis_progress_satisfaction DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Time management and productivity
    procrastination_incidents INTEGER DEFAULT 0,
    deadline_adherence_rate DECIMAL(5,4) DEFAULT 0.75, -- Meeting deadlines
    time_allocation_effectiveness DECIMAL(3,2) DEFAULT 5, -- 1-10 scale
    
    -- Academic community engagement
    study_group_participation DECIMAL(5,4) DEFAULT 0, -- Participation rate
    peer_teaching_instances INTEGER DEFAULT 0,
    academic_mentoring_activities INTEGER DEFAULT 0,
    department_event_attendance INTEGER DEFAULT 0,
    
    -- Research impact and recognition
    citation_potential_score INTEGER DEFAULT 0, -- Estimated citation potential
    academic_recognition_received INTEGER DEFAULT 0,
    media_attention_events INTEGER DEFAULT 0,
    industry_collaboration_contacts INTEGER DEFAULT 0,
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, analysis_date)
);

-- Academic credibility building tracking
CREATE TABLE academic_credibility_tracking (
    credibility_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    measurement_date DATE NOT NULL,
    
    -- Current credibility status
    current_credibility_stage credibility_stage DEFAULT 'novice_researcher',
    credibility_score DECIMAL(5,2) DEFAULT 0, -- Composite credibility score
    credibility_trajectory JSONB, -- Progress over time
    
    -- Publication and research output
    publications_count INTEGER DEFAULT 0,
    citations_received INTEGER DEFAULT 0,
    h_index INTEGER DEFAULT 0,
    research_projects_completed INTEGER DEFAULT 0,
    
    -- Academic recognition and awards
    academic_awards_received INTEGER DEFAULT 0,
    fellowships_obtained INTEGER DEFAULT 0,
    grants_awarded INTEGER DEFAULT 0,
    best_paper_awards INTEGER DEFAULT 0,
    
    -- Conference participation and networking
    conferences_presented_at INTEGER DEFAULT 0,
    keynote_invitations INTEGER DEFAULT 0,
    program_committee_memberships INTEGER DEFAULT 0,
    peer_review_contributions INTEGER DEFAULT 0,
    
    -- Academic community engagement
    journal_editorial_roles INTEGER DEFAULT 0,
    conference_organizing_roles INTEGER DEFAULT 0,
    professional_society_memberships INTEGER DEFAULT 0,
    academic_collaborations INTEGER DEFAULT 0,
    
    -- Thought leadership and influence
    invited_talks_given INTEGER DEFAULT 0,
    media_appearances INTEGER DEFAULT 0,
    blog_posts_published INTEGER DEFAULT 0,
    social_media_academic_influence INTEGER DEFAULT 0, -- Follower count, engagement
    
    -- Teaching and mentorship
    students_mentored INTEGER DEFAULT 0,
    courses_taught INTEGER DEFAULT 0,
    curriculum_development_contributions INTEGER DEFAULT 0,
    educational_innovation_projects INTEGER DEFAULT 0,
    
    -- Industry and public engagement
    industry_collaborations INTEGER DEFAULT 0,
    consulting_projects INTEGER DEFAULT 0,
    public_speaking_engagements INTEGER DEFAULT 0,
    policy_contributions INTEGER DEFAULT 0,
    
    -- Digital academic presence
    academic_website_quality INTEGER DEFAULT 3, -- 1-10 scale
    orcid_profile_completeness DECIMAL(5,2) DEFAULT 0.3, -- Percentage complete
    google_scholar_metrics JSONB, -- Citations, h-index, etc.
    researchgate_engagement INTEGER DEFAULT 0,
    
    -- Networking and relationship building
    academic_network_size INTEGER DEFAULT 0,
    international_collaborators INTEGER DEFAULT 0,
    cross_disciplinary_connections INTEGER DEFAULT 0,
    industry_professional_contacts INTEGER DEFAULT 0,
    
    -- Future potential indicators
    research_pipeline_strength INTEGER DEFAULT 3, -- 1-10 scale
    collaboration_opportunities_identified INTEGER DEFAULT 0,
    funding_potential_score INTEGER DEFAULT 3, -- 1-10 scale
    career_advancement_readiness INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Academic impact assessment
    field_contribution_significance INTEGER DEFAULT 3, -- 1-10 scale
    interdisciplinary_impact_potential INTEGER DEFAULT 3, -- 1-10 scale
    societal_impact_score INTEGER DEFAULT 3, -- 1-10 scale
    innovation_and_creativity_rating INTEGER DEFAULT 5, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, measurement_date),
    CONSTRAINT chk_credibility_scores CHECK (
        credibility_score >= 0 AND
        research_pipeline_strength BETWEEN 1 AND 10 AND
        career_advancement_readiness BETWEEN 1 AND 10
    )
);

-- Academic ROI and career development tracking
CREATE TABLE academic_development_roi (
    roi_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    measurement_date DATE NOT NULL,
    
    -- Time and resource investment
    total_study_hours DECIMAL(8,2) NOT NULL,
    research_hours DECIMAL(8,2) DEFAULT 0,
    networking_hours DECIMAL(8,2) DEFAULT 0,
    writing_and_publication_hours DECIMAL(8,2) DEFAULT 0,
    
    -- Academic outcomes and achievements
    degrees_completed INTEGER DEFAULT 0,
    publications_authored INTEGER DEFAULT 0,
    conferences_presented INTEGER DEFAULT 0,
    academic_awards_received INTEGER DEFAULT 0,
    
    -- Career advancement indicators
    academic_job_offers INTEGER DEFAULT 0,
    industry_job_offers INTEGER DEFAULT 0,
    salary_increase_percentage DECIMAL(5,2) DEFAULT 0,
    career_advancement_level INTEGER DEFAULT 0, -- Steps up career ladder
    
    -- Professional network expansion
    academic_network_growth INTEGER DEFAULT 0,
    industry_connections_made INTEGER DEFAULT 0,
    mentorship_relationships_established INTEGER DEFAULT 0,
    collaboration_opportunities_created INTEGER DEFAULT 0,
    
    -- Academic credibility and recognition
    citation_count_growth INTEGER DEFAULT 0,
    h_index_improvement INTEGER DEFAULT 0,
    academic_reputation_score INTEGER DEFAULT 3, -- 1-10 scale
    thought_leadership_recognition INTEGER DEFAULT 0,
    
    -- Research impact and contribution
    research_projects_led INTEGER DEFAULT 0,
    grants_obtained INTEGER DEFAULT 0,
    patents_filed INTEGER DEFAULT 0,
    open_source_contributions INTEGER DEFAULT 0,
    
    -- ROI calculations
    total_financial_investment DECIMAL(12,2) DEFAULT 0, -- Tuition, materials, opportunity cost
    total_financial_return DECIMAL(12,2) DEFAULT 0, -- Salary increases, grants, awards
    net_financial_roi DECIMAL(8,4) DEFAULT 0, -- (Returns - Investment) / Investment
    
    -- Qualitative benefits and development
    critical_thinking_improvement INTEGER DEFAULT 0, -- 1-10 scale improvement
    research_skills_enhancement INTEGER DEFAULT 0, -- 1-10 scale improvement
    academic_writing_development INTEGER DEFAULT 0, -- 1-10 scale improvement
    leadership_skills_growth INTEGER DEFAULT 0, -- 1-10 scale improvement
    
    -- Long-term career potential
    academic_career_readiness INTEGER DEFAULT 3, -- 1-10 scale
    industry_transition_preparedness INTEGER DEFAULT 3, -- 1-10 scale
    entrepreneurial_potential INTEGER DEFAULT 3, -- 1-10 scale
    consulting_and_advisory_readiness INTEGER DEFAULT 3, -- 1-10 scale
    
    -- Academic satisfaction and fulfillment
    intellectual_satisfaction_rating INTEGER DEFAULT 5, -- 1-10 scale
    career_confidence_improvement INTEGER DEFAULT 0, -- Change in confidence
    work_life_integration_success INTEGER DEFAULT 5, -- 1-10 scale
    academic_identity_development INTEGER DEFAULT 5, -- 1-10 scale
    
    -- Future potential indicators
    publication_pipeline_strength INTEGER DEFAULT 3, -- 1-10 scale
    research_funding_potential INTEGER DEFAULT 3, -- 1-10 scale
    academic_leadership_trajectory INTEGER DEFAULT 3, -- 1-10 scale
    field_influence_potential INTEGER DEFAULT 3, -- 1-10 scale
    
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(user_id, measurement_date),
    CONSTRAINT chk_positive_hours CHECK (total_study_hours > 0),
    CONSTRAINT chk_roi_ranges CHECK (
        academic_career_readiness BETWEEN 1 AND 10 AND
        intellectual_satisfaction_rating BETWEEN 1 AND 10 AND
        academic_reputation_score BETWEEN 1 AND 10
    )
);

-- ================================================================
-- 9. MATERIALIZED VIEWS FOR GRADUATE ANALYTICS
-- ================================================================

-- Graduate student comprehensive analytics
CREATE MATERIALIZED VIEW mv_graduate_student_analytics AS
SELECT 
    gp.user_id,
    gp.full_name,
    gp.graduate_program,
    gp.research_domains,
    gp.current_credibility_stage,
    gp.institution_name,
    gp.expected_completion_date,
    
    -- Academic progress metrics
    COUNT(DISTINCT gss.session_id) as total_study_sessions,
    AVG(gss.actual_duration_hours) as avg_session_duration,
    SUM(gss.actual_duration_hours) as total_study_hours,
    AVG(gss.focus_quality) as avg_focus_quality,
    AVG(gss.academic_satisfaction) as avg_satisfaction,
    
    -- Skill development progress
    COUNT(DISTINCT gsd.skill_id) as skills_in_development,
    COUNT(CASE WHEN gsd.current_proficiency >= 8 THEN 1 END) as skills_mastered,
    AVG(gsd.current_proficiency) as avg_skill_proficiency,
    COUNT(CASE WHEN gsd.research_projects_applied > 0 THEN 1 END) as skills_applied_to_research,
    
    -- Research and academic output
    COUNT(DISTINCT rp.project_id) as active_research_projects,
    COUNT(CASE WHEN rp.current_phase IN ('writing', 'revision', 'submission') THEN 1 END) as projects_near_completion,
    AVG(rp.progress_percentage) as avg_project_progress,
    
    -- Publication and conference activity
    COUNT(DISTINCT ap.publication_id) as total_publications,
    COUNT(CASE WHEN ap.publication_status = 'published' THEN 1 END) as published_papers,
    COUNT(DISTINCT cp.participation_id) as conference_participations,
    AVG(ap.citation_count) as avg_citations_per_paper,
    
    -- Academic credibility indicators
    MAX(gp.h_index) as current_h_index,
    MAX(gp.citation_count) as total_citations,
    MAX(gp.publication_count) as total_publications_count,
    MAX(gp.conference_presentations) as conference_presentations,
    
    -- Thesis progress (if applicable)
    MAX(gtw.thesis_progress_percentage) as thesis_progress,
    COUNT(CASE WHEN gtw.chapters_completed > 0 THEN 1 END) as students_with_thesis_progress,
    
    -- Time management and efficiency
    CASE 
        WHEN SUM(gss.planned_duration_hours) > 0 THEN
            AVG(gss.actual_duration_hours::DECIMAL / NULLIF(gss.planned_duration_hours, 0))
        ELSE 1.0
    END as study_time_efficiency,
    
    -- Academic engagement
    COUNT(CASE WHEN gss.peer_discussion_time_minutes > 0 THEN 1 END) as collaborative_sessions,
    COUNT(CASE WHEN gss.thesis_work_advanced THEN 1 END) as thesis_advancement_sessions,
    
    -- Recent activity indicators
    MAX(gss.started_at) as last_study_session,
    COUNT(CASE WHEN gss.started_at > CURRENT_DATE - INTERVAL '7 days' THEN 1 END) as sessions_last_week,
    COUNT(CASE WHEN gss.started_at > CURRENT_DATE - INTERVAL '30 days' THEN 1 END) as sessions_last_month
    
FROM graduate_profiles gp
LEFT JOIN graduate_study_sessions gss ON gp.user_id = gss.user_id
LEFT JOIN graduate_skill_development gsd ON gp.user_id = gsd.user_id
LEFT JOIN research_projects rp ON gp.user_id = rp.user_id
LEFT JOIN academic_publications ap ON gp.user_id = ap.user_id
LEFT JOIN conference_participation cp ON gp.user_id = cp.user_id
LEFT JOIN graduate_thesis_work gtw ON gp.user_id = gtw.user_id
GROUP BY gp.user_id, gp.full_name, gp.graduate_program, gp.research_domains,
         gp.current_credibility_stage, gp.institution_name, gp.expected_completion_date;

-- Academic skill development analysis
CREATE MATERIALIZED VIEW mv_academic_skill_analysis AS
SELECT 
    asv.skill_id,
    asv.skill_name,
    asv.research_domain,
    asv.academic_importance,
    asv.industry_relevance,
    asv.research_applicability,
    
    -- Learning adoption metrics
    COUNT(DISTINCT gsd.user_id) as graduate_students_learning,
    AVG(gsd.current_proficiency) as avg_proficiency_level,
    COUNT(CASE WHEN gsd.current_proficiency >= 8 THEN 1 END) as students_mastered,
    
    -- Research application success
    COUNT(CASE WHEN gsd.research_projects_applied > 0 THEN 1 END) as research_applications,
    AVG(gsd.thesis_contribution_significance) as avg_thesis_contribution,
    COUNT(CASE WHEN gsd.publication_contribution THEN 1 END) as publication_contributions,
    
    -- Academic development effectiveness
    AVG(gsd.theoretical_understanding) as avg_theoretical_understanding,
    AVG(gsd.practical_application_ability) as avg_practical_application,
    AVG(gsd.research_methodology_connection) as avg_methodology_connection,
    
    -- Learning time and efficiency
    AVG(gsd.formal_coursework_hours) as avg_coursework_hours,
    AVG(gsd.independent_study_hours) as avg_independent_study_hours,
    AVG(gsd.research_application_hours) as avg_research_hours,
    
    -- Professional development outcomes
    COUNT(CASE WHEN gsd.advisor_recognition THEN 1 END) as advisor_recognitions,
    COUNT(CASE WHEN gsd.conference_feedback_positive THEN 1 END) as positive_conference_feedback,
    AVG(gsd.academic_career_relevance) as avg_academic_career_relevance,
    
    -- Content effectiveness
    COUNT(DISTINCT ascm.content_id) as learning_content_available,
    AVG(ascm.research_application_value) as avg_research_application_value,
    AVG(ascm.thesis_applicability) as avg_thesis_applicability,
    
    -- Skill development patterns
    AVG(EXTRACT(DAYS FROM (gsd.target_mastery_date - gsd.learning_start_date))) as avg_days_to_mastery,
    COUNT(CASE WHEN gsd.peer_teaching_instances > 0 THEN 1 END) as students_teaching_others
    
FROM academic_skills asv
LEFT JOIN graduate_skill_development gsd ON asv.skill_id = gsd.skill_id
LEFT JOIN academic_skill_content_mapping ascm ON asv.skill_id = ascm.skill_id
GROUP BY asv.skill_id, asv.skill_name, asv.research_domain, asv.academic_importance,
         asv.industry_relevance, asv.research_applicability;

-- Graduate content effectiveness analysis
CREATE MATERIALIZED VIEW mv_graduate_content_effectiveness AS
SELECT 
    gc.content_id,
    gc.title,
    gc.academic_format,
    gc.research_domain,
    gc.academic_level,
    gc.estimated_study_time,
    
    -- Usage and engagement metrics
    COUNT(DISTINCT gp_progress.user_id) as unique_graduate_users,
    AVG(gp_progress.total_study_hours) as avg_study_time,
    AVG(gp_progress.completion_percentage) as avg_completion_rate,
    AVG(gp_progress.academic_mastery_level) as avg_mastery_achieved,
    
    -- Graduate learning effectiveness
    AVG(gp_progress.theoretical_understanding) as avg_theoretical_understanding,
    AVG(gp_progress.practical_application_ability) as avg_practical_application,
    AVG(gp_progress.synthesis_and_integration) as avg_synthesis_ability,
    AVG(gp_progress.original_thinking_development) as avg_original_thinking,
    
    -- Research application and impact
    COUNT(CASE WHEN gp_progress.research_project_application THEN 1 END) as research_applications,
    COUNT(CASE WHEN gp_progress.thesis_work_integration THEN 1 END) as thesis_integrations,
    COUNT(CASE WHEN gp_progress.publication_potential_identified THEN 1 END) as publication_potential_cases,
    
    -- Academic engagement quality
    AVG(gp_progress.discussion_participation_level) as avg_discussion_participation,
    AVG(gp_progress.peer_collaboration_engagement) as avg_peer_collaboration,
    AVG(gp_progress.note_taking_quality) as avg_note_taking_quality,
    
    -- Content quality indicators
    gc.theoretical_depth,
    gc.empirical_support,
    gc.methodological_rigor,
    gc.scholarly_rigor_rating,
    
    -- Academic skill development
    COUNT(DISTINCT ascm.skill_id) as skills_addressed,
    AVG(ascm.research_application_value) as avg_research_application_value,
    AVG(ascm.thesis_applicability) as avg_thesis_applicability,
    AVG(ascm.academic_career_preparation) as avg_career_preparation_value,
    
    -- Academic resource connections
    COUNT(DISTINCT acs.case_study_id) as case_studies_count,
    COUNT(DISTINCT ar.resource_id) as academic_resources_count,
    AVG(ar.academic_reputation) as avg_resource_reputation,
    
    -- Learning efficiency measures
    CASE 
        WHEN AVG(gc.estimated_study_time) > 0 THEN
            AVG(gp_progress.academic_mastery_level) / AVG(gc.estimated_study_time)
        ELSE 0
    END as learning_efficiency_ratio
    
FROM graduate_content gc
LEFT JOIN graduate_progress gp_progress ON gc.unit_id = gp_progress.unit_id
LEFT JOIN academic_skill_content_mapping ascm ON gc.content_id = ascm.content_id
LEFT JOIN academic_case_studies acs ON gc.content_id = acs.content_id
LEFT JOIN academic_resources ar ON gc.content_id = ar.content_id
GROUP BY gc.content_id, gc.title, gc.academic_format, gc.research_domain,
         gc.academic_level, gc.estimated_study_time, gc.theoretical_depth,
         gc.empirical_support, gc.methodological_rigor, gc.scholarly_rigor_rating;

-- ================================================================
-- COMPREHENSIVE INDEXING STRATEGY FOR GRADUATE STUDENTS
-- ================================================================

-- Graduate profile indexes
CREATE INDEX idx_graduate_profiles_user ON graduate_profiles(user_id);
CREATE INDEX idx_graduate_profiles_program ON graduate_profiles(graduate_program);
CREATE INDEX idx_graduate_profiles_domains ON graduate_profiles USING GIN(research_domains);
CREATE INDEX idx_graduate_profiles_stage ON graduate_profiles(current_credibility_stage);
CREATE INDEX idx_graduate_profiles_institution ON graduate_profiles(institution_name);
CREATE INDEX idx_graduate_profiles_completion ON graduate_profiles(expected_completion_date) WHERE expected_completion_date IS NOT NULL;

-- Academic skill indexes
CREATE INDEX idx_academic_skills_domain ON academic_skills(research_domain);
CREATE INDEX idx_academic_skills_importance ON academic_skills(academic_importance DESC, research_applicability DESC);
CREATE INDEX idx_academic_skills_level ON academic_skills(academic_level);
CREATE INDEX idx_academic_skills_focus ON academic_skills(requires_deep_focus, collaborative_learning_suitable);

-- Research project indexes
CREATE INDEX idx_research_projects_user ON research_projects(user_id);
CREATE INDEX idx_research_projects_domain ON research_projects(research_domain);
CREATE INDEX idx_research_projects_phase ON research_projects(current_phase);
CREATE INDEX idx_research_projects_progress ON research_projects(progress_percentage DESC);
CREATE INDEX idx_research_projects_completion ON research_projects(expected_completion_date) WHERE expected_completion_date IS NOT NULL;

-- Publication indexes
CREATE INDEX idx_academic_publications_user ON academic_publications(user_id);
CREATE INDEX idx_academic_publications_type ON academic_publications(publication_type);
CREATE INDEX idx_academic_publications_status ON academic_publications(publication_status);
CREATE INDEX idx_academic_publications_date ON academic_publications(publication_date DESC) WHERE publication_date IS NOT NULL;
CREATE INDEX idx_academic_publications_citations ON academic_publications(citation_count DESC);

-- Curriculum and learning structure indexes
CREATE INDEX idx_graduate_curricula_programs ON graduate_curricula USING GIN(program_types);
CREATE INDEX idx_graduate_curricula_domains ON graduate_curricula USING GIN(target_research_domains);
CREATE INDEX idx_graduate_curricula_level ON graduate_curricula(academic_level);
CREATE INDEX idx_graduate_modules_curriculum ON graduate_modules(curriculum_id, module_number);
CREATE INDEX idx_graduate_components_module ON graduate_components(module_id, order_index);
CREATE INDEX idx_graduate_topics_component ON graduate_topics(component_id, order_index);
CREATE INDEX idx_graduate_learning_units_topic ON graduate_learning_units(topic_id, order_index);

-- Content management indexes
CREATE INDEX idx_graduate_content_unit ON graduate_content(unit_id);
CREATE INDEX idx_graduate_content_domain ON graduate_content(research_domain);
CREATE INDEX idx_graduate_content_level ON graduate_content(academic_level);
CREATE INDEX idx_graduate_content_rigor ON graduate_content(theoretical_depth DESC, methodological_rigor DESC);
CREATE INDEX idx_graduate_content_tags ON graduate_content USING GIN(academic_tags);

-- Full-text search for academic content
CREATE INDEX idx_graduate_content_search ON graduate_content 
    USING GIN(to_tsvector('english', title || ' ' || COALESCE(description, '') || ' ' || 
    array_to_string(keywords, ' ') || ' ' || array_to_string(academic_tags, ' ')));

-- Conference and publication indexes
CREATE INDEX idx_conference_participation_user ON conference_participation(user_id);
CREATE INDEX idx_conference_participation_year ON conference_participation(conference_year DESC);
CREATE INDEX idx_conference_participation_type ON conference_participation(participation_type);

-- AI Avatar indexes
CREATE INDEX idx_graduate_ai_avatars_role ON graduate_ai_avatars(primary_role);
CREATE INDEX idx_graduate_ai_avatars_domains ON graduate_ai_avatars USING GIN(research_domains);
CREATE INDEX idx_graduate_ai_avatars_active ON graduate_ai_avatars(is_active) WHERE is_active = true;

-- Assessment indexes
CREATE INDEX idx_graduate_assessments_unit ON graduate_assessments(unit_id);
CREATE INDEX idx_graduate_assessments_type ON graduate_assessments(assessment_type);
CREATE INDEX idx_graduate_assessments_rigor ON graduate_assessments(academic_rigor_level DESC);
CREATE INDEX idx_graduate_assessment_questions_assessment ON graduate_assessment_questions(assessment_id, order_index);

-- Progress tracking indexes
CREATE INDEX idx_graduate_progress_user ON graduate_progress(user_id);
CREATE INDEX idx_graduate_progress_unit ON graduate_progress(unit_id);
CREATE INDEX idx_graduate_progress_status ON graduate_progress(status);
CREATE INDEX idx_graduate_progress_mastery ON graduate_progress(academic_mastery_level DESC);

-- Skill development indexes
CREATE INDEX idx_graduate_skill_development_user ON graduate_skill_development(user_id);
CREATE INDEX idx_graduate_skill_development_skill ON graduate_skill_development(skill_id);
CREATE INDEX idx_graduate_skill_development_proficiency ON graduate_skill_development(current_proficiency DESC);

-- Study session indexes
CREATE INDEX idx_graduate_study_sessions_user ON graduate_study_sessions(user_id);
CREATE INDEX idx_graduate_study_sessions_date ON graduate_study_sessions(started_at DESC);
CREATE INDEX idx_graduate_study_sessions_type ON graduate_study_sessions(session_type);
CREATE INDEX idx_graduate_study_sessions_quality ON graduate_study_sessions(focus_quality DESC, productivity_rating DESC);

-- Thesis work indexes
CREATE INDEX idx_graduate_thesis_work_user ON graduate_thesis_work(user_id);
CREATE INDEX idx_graduate_thesis_work_progress ON graduate_thesis_work(thesis_progress_percentage DESC);
CREATE INDEX idx_graduate_thesis_work_defense ON graduate_thesis_work(thesis_defense_date) WHERE thesis_defense_date IS NOT NULL;

-- Vector search indexes for academic content
CREATE INDEX idx_academic_content_embeddings_vector ON academic_content_embeddings 
    USING hnsw (content_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64);
CREATE INDEX idx_theoretical_embeddings ON academic_content_embeddings 
    USING hnsw (theoretical_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE theoretical_vector IS NOT NULL;
CREATE INDEX idx_methodological_embeddings ON academic_content_embeddings 
    USING hnsw (methodological_vector vector_cosine_ops) WITH (m = 16, ef_construction = 64) 
    WHERE methodological_vector IS NOT NULL;

-- Analytics and performance indexes
CREATE INDEX idx_graduate_learning_analytics_user ON graduate_learning_analytics(user_id);
CREATE INDEX idx_graduate_learning_analytics_date ON graduate_learning_analytics(analysis_date DESC);
CREATE INDEX idx_academic_credibility_tracking_user ON academic_credibility_tracking(user_id);
CREATE INDEX idx_academic_credibility_tracking_stage ON academic_credibility_tracking(current_credibility_stage);
CREATE INDEX idx_academic_development_roi_user ON academic_development_roi(user_id);
CREATE INDEX idx_academic_development_roi_date ON academic_development_roi(measurement_date DESC);

-- ================================================================
-- ROW LEVEL SECURITY FOR GRADUATE DATA
-- ================================================================

-- Enable RLS on user-specific tables
ALTER TABLE graduate_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE research_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE academic_publications ENABLE ROW LEVEL SECURITY;
ALTER TABLE conference_participation ENABLE ROW LEVEL SECURITY;
ALTER TABLE graduate_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE graduate_skill_development ENABLE ROW LEVEL SECURITY;
ALTER TABLE graduate_study_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE graduate_performance_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE academic_credibility_tracking ENABLE ROW LEVEL SECURITY;
ALTER TABLE academic_development_roi ENABLE ROW LEVEL SECURITY;
ALTER TABLE graduate_thesis_work ENABLE ROW LEVEL SECURITY;

-- Graduate data isolation policies
CREATE POLICY graduate_profile_isolation ON graduate_profiles
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY research_project_isolation ON research_projects
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY publication_isolation ON academic_publications
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY conference_isolation ON conference_participation
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY graduate_progress_isolation ON graduate_progress
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY skill_development_isolation ON graduate_skill_development
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY study_session_isolation ON graduate_study_sessions
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

CREATE POLICY thesis_work_isolation ON graduate_thesis_work
    FOR ALL TO application_users
    USING (user_id = current_setting('app.current_user_id', true)::uuid);

-- Shared academic content access policies
CREATE POLICY graduate_content_read_access ON graduate_content
    FOR SELECT TO application_users
    USING (true);

CREATE POLICY case_studies_read_access ON academic_case_studies
    FOR SELECT TO application_users
    USING (true);

CREATE POLICY academic_resources_read_access ON academic_resources
    FOR SELECT TO application_users
    USING (true);

-- Research advisor access policies (with explicit permission)
CREATE POLICY advisor_research_access ON research_projects
    FOR SELECT TO application_users
    USING (
        user_id = current_setting('app.current_user_id', true)::uuid OR
        (current_setting('app.user_role', true) = 'research_advisor' AND 
         primary_advisor_id = current_setting('app.current_user_id', true)::uuid)
    );

-- Committee member access to thesis work (with permission)
CREATE POLICY committee_thesis_access ON graduate_thesis_work
    FOR SELECT TO application_users
    USING (
        user_id = current_setting('app.current_user_id', true)::uuid OR
        (current_setting('app.user_role', true) IN ('research_advisor', 'committee_member') AND 
         (primary_advisor_id = current_setting('app.current_user_id', true)::uuid OR
          current_setting('app.current_user_id', true)::uuid = ANY(
              SELECT jsonb_array_elements_text(committee_members->'member_ids')::uuid
          )))
    );

-- Admin access policies for graduate platform
CREATE POLICY admin_full_access_graduate_profiles ON graduate_profiles
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_full_access_graduate_content ON graduate_content
    FOR ALL TO admin_users
    USING (true);

CREATE POLICY admin_analytics_access ON graduate_learning_analytics
    FOR SELECT TO admin_users
    USING (true);

-- ================================================================
-- SPECIALIZED FUNCTIONS FOR GRADUATE OPTIMIZATION
-- ================================================================

-- Function to get personalized research recommendations based on academic goals
CREATE OR REPLACE FUNCTION get_graduate_research_recommendations(
    p_user_id UUID,
    p_research_focus research_domain DEFAULT 'computer_science',
    p_academic_level academic_complexity DEFAULT 'graduate',
    p_limit INTEGER DEFAULT 5
) RETURNS TABLE (
    unit_id UUID,
    title VARCHAR,
    estimated_study_time INTEGER,
    theoretical_depth INTEGER,
    research_application_value DECIMAL,
    thesis_applicability DECIMAL
) AS $$
DECLARE
    user_profile RECORD;
    completed_units UUID[];
BEGIN
    -- Get user academic profile information
    SELECT research_domains, current_credibility_stage, dissertation_topic, research_interests
    INTO user_profile
    FROM graduate_profiles 
    WHERE user_id = p_user_id;
    
    -- Get completed units
    SELECT array_agg(unit_id) INTO completed_units
    FROM graduate_progress 
    WHERE user_id = p_user_id AND completion_percentage >= 80;
    
    RETURN QUERY
    WITH research_recommendations AS (
        SELECT 
            glu.unit_id,
            glu.title,
            glu.estimated_study_hours as estimated_study_time,
            gc.theoretical_depth,
            
            -- Calculate research application value
            COALESCE(AVG(ascm.research_application_value), 6.0) as research_application_value,
            
            -- Calculate thesis applicability
            COALESCE(AVG(ascm.thesis_applicability), 4.0) as thesis_applicability
            
        FROM graduate_learning_units glu
        JOIN graduate_topics gt ON glu.topic_id = gt.topic_id
        JOIN graduate_components gcomp ON gt.component_id = gcomp.component_id
        JOIN graduate_modules gmod ON gcomp.module_id = gmod.module_id
        JOIN graduate_curricula gcur ON gmod.curriculum_id = gcur.curriculum_id
        LEFT JOIN graduate_content gc ON glu.unit_id = gc.unit_id
        LEFT JOIN academic_skill_content_mapping ascm ON gc.content_id = ascm.content_id
        WHERE (completed_units IS NULL OR glu.unit_id != ALL(completed_units))
        AND (p_research_focus = ANY(gcur.target_research_domains) OR user_profile.research_domains && gcur.target_research_domains)
        AND (gc.academic_level = p_academic_level OR gc.academic_level IS NULL)
        GROUP BY glu.unit_id, glu.title, glu.estimated_study_hours, gc.theoretical_depth
    )
    SELECT 
        rr.unit_id,
        rr.title,
        rr.estimated_study_time,
        rr.theoretical_depth,
        rr.research_application_value,
        rr.thesis_applicability
    FROM research_recommendations rr
    ORDER BY rr.research_application_value DESC, rr.thesis_applicability DESC, rr.theoretical_depth DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate academic credibility score
CREATE OR REPLACE FUNCTION calculate_academic_credibility(
    p_user_id UUID,
    p_assessment_date DATE DEFAULT CURRENT_DATE
) RETURNS JSONB AS $$
DECLARE
    profile_data RECORD;
    publication_data RECORD;
    conference_data RECORD;
    credibility_score DECIMAL(5,2);
    result JSONB;
BEGIN
    -- Get graduate profile information
    SELECT 
        current_credibility_stage,
        h_index,
        citation_count,
        publication_count,
        conference_presentations
    INTO profile_data
    FROM graduate_profiles 
    WHERE user_id = p_user_id;
    
    -- Get publication metrics
    SELECT 
        COUNT(*) as total_publications,
        COUNT(CASE WHEN publication_status = 'published' THEN 1 END) as published_papers,
        AVG(citation_count) as avg_citations,
        COUNT(CASE WHEN author_position = 1 THEN 1 END) as first_author_papers
    INTO publication_data
    FROM academic_publications 
    WHERE user_id = p_user_id;
    
    -- Get conference activity
    SELECT 
        COUNT(*) as total_conferences,
        COUNT(CASE WHEN participation_type = 'presenter' THEN 1 END) as presentations_given,
        COUNT(CASE WHEN best_paper_nomination THEN 1 END) as awards_received
    INTO conference_data
    FROM conference_participation 
    WHERE user_id = p_user_id;
    
    -- Calculate composite credibility score
    credibility_score := 
        COALESCE(profile_data.h_index, 0) * 10 +  -- H-index weighted highly
        COALESCE(publication_data.published_papers, 0) * 15 + -- Published papers
        COALESCE(conference_data.presentations_given, 0) * 5 + -- Conference presentations
        COALESCE(publication_data.first_author_papers, 0) * 10 + -- First author papers
        COALESCE(conference_data.awards_received, 0) * 20; -- Academic awards
    
    -- Build comprehensive credibility report
    result := jsonb_build_object(
        'assessment_date', p_assessment_date,
        'current_credibility_stage', profile_data.current_credibility_stage,
        'overall_credibility_score', credibility_score,
        'publication_metrics', jsonb_build_object(
            'total_publications', COALESCE(publication_data.total_publications, 0),
            'published_papers', COALESCE(publication_data.published_papers, 0),
            'first_author_papers', COALESCE(publication_data.first_author_papers, 0),
            'average_citations', ROUND(COALESCE(publication_data.avg_citations, 0), 1),
            'h_index', COALESCE(profile_data.h_index, 0)
        ),
        'conference_activity', jsonb_build_object(
            'conferences_attended', COALESCE(conference_data.total_conferences, 0),
            'presentations_given', COALESCE(conference_data.presentations_given, 0),
            'awards_received', COALESCE(conference_data.awards_received, 0)
        ),
        'development_recommendations', jsonb_build_array(
            CASE WHEN COALESCE(publication_data.published_papers, 0) = 0 THEN 
                'Focus on completing and publishing your first academic paper'
            END,
            CASE WHEN COALESCE(conference_data.presentations_given, 0) = 0 THEN 
                'Consider presenting your research at academic conferences'
            END,
            CASE WHEN credibility_score < 50 THEN 
                'Build research output through consistent publication and conference participation'
            END,
            CASE WHEN profile_data.h_index IS NULL OR profile_data.h_index < 3 THEN 
                'Work on increasing citation impact and h-index through quality publications'
            END
        )
    );
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to track thesis progress and milestones
CREATE OR REPLACE FUNCTION update_thesis_progress(
    p_user_id UUID,
    p_chapter_completed BOOLEAN DEFAULT false,
    p_word_count_update INTEGER DEFAULT NULL,
    p_milestone_achieved VARCHAR(100) DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
    thesis_record RECORD;
    progress_update JSONB;
BEGIN
    -- Get current thesis status
    SELECT *
    INTO thesis_record
    FROM graduate_thesis_work 
    WHERE user_id = p_user_id;
    
    IF thesis_record IS NULL THEN
        RAISE EXCEPTION 'No thesis record found for user %', p_user_id;
    END IF;
    
    -- Update thesis progress
    IF p_chapter_completed THEN
        UPDATE graduate_thesis_work 
        SET 
            chapters_completed = chapters_completed + 1,
            current_chapter = current_chapter + 1,
            thesis_progress_percentage = LEAST(100, (chapters_completed + 1) * 100.0 / total_planned_chapters),
            updated_at = CURRENT_TIMESTAMP
        WHERE user_id = p_user_id;
    END IF;
    
    -- Update word count if provided
    IF p_word_count_update IS NOT NULL THEN
        UPDATE graduate_thesis_work 
        SET 
            word_count_current = p_word_count_update,
            writing_progress = LEAST(100, p_word_count_update * 100.0 / word_count_target),
            updated_at = CURRENT_TIMESTAMP
        WHERE user_id = p_user_id;
    END IF;
    
    -- Get updated progress
    SELECT 
        thesis_progress_percentage,
        chapters_completed,
        total_planned_chapters,
        word_count_current,
        word_count_target
    INTO thesis_record
    FROM graduate_thesis_work 
    WHERE user_id = p_user_id;
    
    -- Build progress report
    progress_update := jsonb_build_object(
        'thesis_progress_percentage', thesis_record.thesis_progress_percentage,
        'chapters_completed', thesis_record.chapters_completed,
        'total_planned_chapters', thesis_record.total_planned_chapters,
        'word_count_current', thesis_record.word_count_current,
        'word_count_target', thesis_record.word_count_target,
        'milestone_achieved', p_milestone_achieved,
        'updated_at', CURRENT_TIMESTAMP,
        'next_milestones', jsonb_build_array(
            CASE WHEN thesis_record.chapters_completed < thesis_record.total_planned_chapters THEN
                'Complete Chapter ' || (thesis_record.chapters_completed + 1)::text
            END,
            CASE WHEN thesis_record.word_count_current < thesis_record.word_count_target THEN
                'Reach ' || thesis_record.word_count_target::text || ' words'
            END,
            CASE WHEN thesis_record.thesis_progress_percentage >= 80 AND thesis_record.thesis_progress_percentage < 100 THEN
                'Prepare for thesis defense'
            END
        )
    );
    
    RETURN progress_update;
END;
$$ LANGUAGE plpgsql;

-- Function to recommend academic networking opportunities
CREATE OR REPLACE FUNCTION identify_networking_opportunities(
    p_user_id UUID,
    p_research_domain research_domain DEFAULT NULL,
    p_limit INTEGER DEFAULT 5
) RETURNS JSONB AS $$
DECLARE
    user_profile RECORD;
    networking_opportunities JSONB := '[]';
    opportunity JSONB;
BEGIN
    -- Get user academic profile
    SELECT research_domains, current_credibility_stage, institution_name, research_interests
    INTO user_profile
    FROM graduate_profiles 
    WHERE user_id = p_user_id;
    
    -- Use provided domain or user's primary domain
    IF p_research_domain IS NULL AND array_length(user_profile.research_domains, 1) > 0 THEN
        p_research_domain := user_profile.research_domains[1];
    END IF;
    
    -- Identify upcoming conferences in user's field
    opportunity := jsonb_build_object(
        'type', 'conference_attendance',
        'title', 'Attend conferences in ' || p_research_domain::text,
        'description', 'Identify and attend 2-3 top conferences in your research domain',
        'expected_benefit', 'Network with researchers, present your work, stay current with field',
        'timeline', 'Next 6-12 months',
        'priority', 'high'
    );
    networking_opportunities := networking_opportunities || opportunity;
    
    -- Suggest research collaboration opportunities
    opportunity := jsonb_build_object(
        'type', 'research_collaboration',
        'title', 'Collaborate with peers in your program',
        'description', 'Initiate or join collaborative research projects with fellow graduate students',
        'expected_benefit', 'Share expertise, learn new methods, co-author publications',
        'timeline', 'Next 3-6 months',
        'priority', 'medium'
    );
    networking_opportunities := networking_opportunities || opportunity;
    
    -- Academic social media presence
    opportunity := jsonb_build_object(
        'type', 'digital_presence',
        'title', 'Build academic social media presence',
        'description', 'Create and maintain profiles on ResearchGate, Academic Twitter, LinkedIn',
        'expected_benefit', 'Increase visibility, connect with global researchers, share your work',
        'timeline', 'Next 2-3 months',
        'priority', 'medium'
    );
    networking_opportunities := networking_opportunities || opportunity;
    
    -- Suggest joining professional societies
    opportunity := jsonb_build_object(
        'type', 'professional_membership',
        'title', 'Join professional societies in your field',
        'description', 'Become member of key professional organizations in ' || p_research_domain::text,
        'expected_benefit', 'Access to exclusive events, publications, and networking opportunities',
        'timeline', 'Next 1-2 months',
        'priority', 'high'
    );
    networking_opportunities := networking_opportunities || opportunity;
    
    -- Mentorship opportunities
    opportunity := jsonb_build_object(
        'type', 'mentorship',
        'title', 'Seek additional mentors and mentees',
        'description', 'Find senior researchers to mentor you and junior students to mentor',
        'expected_benefit', 'Gain guidance, build leadership skills, expand network',
        'timeline', 'Ongoing',
        'priority', 'high'
    );
    networking_opportunities := networking_opportunities || opportunity;
    
    RETURN jsonb_build_object(
        'user_id', p_user_id,
        'research_domain', p_research_domain,
        'current_credibility_stage', user_profile.current_credibility_stage,
        'networking_opportunities', networking_opportunities,
        'generated_at', CURRENT_TIMESTAMP
    );
END;
$$ LANGUAGE plpgsql;

-- Function to refresh all graduate analytics materialized views
CREATE OR REPLACE FUNCTION refresh_graduate_analytics_views()
RETURNS JSONB AS $$
DECLARE
    start_time TIMESTAMPTZ;
    result JSONB := '{}';
BEGIN
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh graduate student analytics
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_graduate_student_analytics;
    result := result || jsonb_build_object('student_analytics_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh academic skill analysis
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_academic_skill_analysis;
    result := result || jsonb_build_object('skill_analysis_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    start_time := CURRENT_TIMESTAMP;
    
    -- Refresh graduate content effectiveness
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_graduate_content_effectiveness;
    result := result || jsonb_build_object('content_effectiveness_duration', 
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - start_time)));
    
    result := result || jsonb_build_object('total_refresh_completed_at', CURRENT_TIMESTAMP);
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- TRIGGERS FOR GRADUATE AUTOMATION
-- ================================================================

-- Trigger function to update academic progress and credibility
CREATE OR REPLACE FUNCTION update_graduate_academic_progress()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    
    -- Update publication counts and metrics
    IF TG_TABLE_NAME = 'academic_publications' AND NEW.publication_status = 'published' THEN
        UPDATE graduate_profiles 
        SET 
            publication_count = (
                SELECT COUNT(*) FROM academic_publications 
                WHERE user_id = NEW.user_id AND publication_status = 'published'
            ),
            -- Update citation count
            citation_count = (
                SELECT COALESCE(SUM(citation_count), 0) FROM academic_publications 
                WHERE user_id = NEW.user_id AND publication_status = 'published'
            )
        WHERE user_id = NEW.user_id;
    END IF;
    
    -- Update conference presentation counts
    IF TG_TABLE_NAME = 'conference_participation' AND NEW.participation_type = 'presenter' THEN
        UPDATE graduate_profiles 
        SET 
            conference_presentations = (
                SELECT COUNT(*) FROM conference_participation 
                WHERE user_id = NEW.user_id AND participation_type = 'presenter'
            )
        WHERE user_id = NEW.user_id;
    END IF;
    
    -- Update study time totals
    IF TG_TABLE_NAME = 'graduate_study_sessions' AND NEW.ended_at IS NOT NULL THEN
        UPDATE graduate_profiles 
        SET 
            total_study_hours = total_study_hours + COALESCE(NEW.actual_duration_hours, 0),
            last_login = NEW.ended_at
        WHERE user_id = NEW.user_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply graduate academic progress triggers
CREATE TRIGGER tr_update_publication_metrics
    AFTER INSERT OR UPDATE ON academic_publications
    FOR EACH ROW EXECUTE FUNCTION update_graduate_academic_progress();

CREATE TRIGGER tr_update_conference_metrics
    AFTER INSERT OR UPDATE ON conference_participation
    FOR EACH ROW EXECUTE FUNCTION update_graduate_academic_progress();

CREATE TRIGGER tr_update_study_time_metrics
    AFTER INSERT OR UPDATE ON graduate_study_sessions
    FOR EACH ROW EXECUTE FUNCTION update_graduate_academic_progress();

-- Trigger to update academic skill proficiency based on usage
CREATE OR REPLACE FUNCTION update_academic_skill_proficiency()
RETURNS TRIGGER AS $$
DECLARE
    skill_usage_count INTEGER;
    research_application_count INTEGER;
    thesis_usage_count INTEGER;
BEGIN
    -- Calculate skill usage in academic contexts
    SELECT COUNT(*) INTO skill_usage_count
    FROM graduate_progress gp
    JOIN academic_skill_content_mapping ascm ON gp.unit_id = ascm.content_id
    WHERE gp.user_id = NEW.user_id 
    AND ascm.skill_id = NEW.skill_id
    AND gp.completion_percentage >= 80;
    
    -- Calculate research application frequency
    SELECT COUNT(*) INTO research_application_count
    FROM research_projects rp
    WHERE rp.user_id = NEW.user_id
    AND NEW.skill_id = ANY(rp.required_skills);
    
    -- Calculate thesis application
    SELECT COUNT(*) INTO thesis_usage_count
    FROM graduate_progress gp
    WHERE gp.user_id = NEW.user_id
    AND gp.thesis_work_integration = true
    AND EXISTS (
        SELECT 1 FROM academic_skill_content_mapping ascm 
        WHERE ascm.content_id = gp.unit_id AND ascm.skill_id = NEW.skill_id
    );
    
    -- Update proficiency based on academic usage patterns
    NEW.current_proficiency = LEAST(10, 
        3 + -- Graduate baseline
        (skill_usage_count * 0.8) + -- Academic learning contribution
        (research_application_count * 1.5) + -- Research application contribution
        (thesis_usage_count * 2.0) + -- Thesis integration contribution
        (NEW.formal_coursework_hours / 20.0) + -- Formal learning time
        (NEW.research_application_hours / 15.0) -- Research practice time
    );
    
    -- Update theoretical understanding and practical application
    NEW.theoretical_understanding = LEAST(10, NEW.current_proficiency + 1);
    NEW.practical_application_ability = LEAST(10, NEW.current_proficiency);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_update_academic_skill_proficiency
    BEFORE UPDATE ON graduate_skill_development
    FOR EACH ROW EXECUTE FUNCTION update_academic_skill_proficiency();

-- ================================================================
-- INITIAL SYSTEM DATA FOR GRADUATE PLATFORM
-- ================================================================

-- Insert default academic embedding model
INSERT INTO academic_embedding_models (
    model_name, provider, embedding_dimensions, context_window,
    research_domains_optimized, academic_levels_supported, scholarly_content_optimized,
    theoretical_content_performance, methodology_content_performance, interdisciplinary_capability,
    is_active, is_primary
) VALUES (
    'academic-research-v1', 'sentence-transformers', 768, 1024,
    ARRAY['computer_science', 'data_science', 'machine_learning']::research_domain[],
    ARRAY['graduate', 'research', 'expert']::academic_complexity[],
    true, 0.92, 0.89, 0.86, true, true
);

-- Insert graduate AI avatars for academic mentorship
INSERT INTO graduate_ai_avatars (
    avatar_name, display_name, description, primary_role, research_domains,
    years_of_academic_experience, research_publications, successful_students_mentored,
    can_guide_thesis_writing, can_provide_methodology_advice, can_review_academic_writing,
    can_suggest_research_directions, can_provide_career_guidance,
    academic_formality_level, encouragement_style, feedback_approach
) VALUES 
('dr_research_advisor', 'Dr. Elena Rodriguez - Research Advisor',
 'Experienced research advisor specializing in computer science and data science research',
 'research_advisor', 
 ARRAY['computer_science', 'data_science', 'machine_learning']::research_domain[],
 15, 45, 120,
 true, true, true, true, true, 8, 'scholarly', 'constructive'),

('prof_thesis_supervisor', 'Prof. Michael Chen - Thesis Supervisor',
 'Senior academic with expertise in thesis supervision and academic writing',
 'thesis_supervisor',
 ARRAY['computer_science', 'software_engineering', 'systems_architecture']::research_domain[],
 20, 78, 85,
 true, true, true, false, true, 9, 'scholarly', 'direct'),

('dr_methodology_expert', 'Dr. Sarah Thompson - Methodology Expert',
 'Research methodology specialist focusing on mixed methods and computational approaches',
 'methodology_expert',
 ARRAY['data_science', 'artificial_intelligence', 'computational_biology']::research_domain[],
 12, 32, 95,
 false, true, false, true, false, 7, 'scholarly', 'socratic'),

('prof_career_advisor', 'Prof. David Kim - Academic Career Advisor',
 'Senior academic career advisor with experience in both academic and industry transitions',
 'academic_career_advisor',
 ARRAY['computer_science', 'data_science', 'educational_technology']::research_domain[],
 18, 65, 200,
 false, false, false, true, true, 7, 'supportive', 'constructive');

-- Insert sample high-impact academic skills
INSERT INTO academic_skills (
    skill_code, skill_name, description, research_domain, skill_category,
    academic_importance, industry_relevance, research_applicability, publication_value,
    requires_deep_focus, collaborative_learning_suitable, theoretical_foundation_required
) VALUES 
('research_methodology', 'Research Methodology Design', 'Advanced research design and methodology selection for graduate research',
 'computer_science', 'research_methodology', 10, 6, 10, 9,
 true, true, true),

('academic_writing', 'Scholarly Academic Writing', 'Advanced academic writing for publications, theses, and dissertations',
 'computer_science', 'academic_writing', 9, 7, 8, 10,
 true, false, true),

('literature_review', 'Systematic Literature Review', 'Comprehensive literature review methodologies for academic research',
 'data_science', 'research_methodology', 9, 5, 10, 8,
 true, false, true),

('statistical_analysis', 'Advanced Statistical Analysis', 'Graduate-level statistical analysis and interpretation for research',
 'data_science', 'technical', 8, 9, 9, 8,
 true, true, true),

('thesis_writing', 'Thesis and Dissertation Writing', 'Advanced thesis writing, structure, and academic argumentation',
 'computer_science', 'academic_writing', 10, 4, 8, 9,
 true, false, true),

('peer_review', 'Academic Peer Review Process', 'Understanding and participating in academic peer review',
 'computer_science', 'research_methodology', 7, 6, 9, 10,
 false, true, true);

-- Insert sample graduate curriculum
INSERT INTO graduate_curricula (
    curriculum_code, title, description, program_types, target_research_domains,
    total_duration_weeks, credit_hours, research_component_percentage,
    theoretical_foundation_emphasis, academic_writing_intensity, 
    peer_review_component, original_research_required
) VALUES 
('grad-cs-research-2024', 'Graduate Computer Science Research Methods', 
 'Comprehensive graduate-level curriculum for computer science research methodology and academic development',
 ARRAY['masters_thesis', 'phd_coursework', 'phd_dissertation']::graduate_program_type[],
 ARRAY['computer_science', 'data_science', 'machine_learning']::research_domain[],
 32, 3, 0.70, 0.30, 9, true, true);

-- Final deployment notification
DO $$
BEGIN
    RAISE NOTICE '=== CREDIBILITY-BUILDING GRADUATE EDUCATION PLATFORM DEPLOYED ===';
    RAISE NOTICE 'Total Tables: 35 core tables + 3 materialized views';
    RAISE NOTICE 'Total Estimated Fields: ~680 fields across all academic-focused areas';
    RAISE NOTICE 'Academic Focus: Graduate-level research, thesis, and publication support';
    RAISE NOTICE 'Research Integration: Complete research project and publication tracking';
    RAISE NOTICE 'Academic Credibility: H-index, citations, and thought leadership metrics';
    RAISE NOTICE 'Thesis Support: Comprehensive thesis and dissertation progress tracking';
    RAISE NOTICE 'Conference Integration: Academic conference participation and networking';
    RAISE NOTICE 'Vector Search: Academic context-aware semantic search for scholarly content';
    RAISE NOTICE 'Row-Level Security: Complete graduate data protection and advisor access';
    RAISE NOTICE 'AI Avatars: 4 specialized graduate academic mentors and advisors';
    RAISE NOTICE 'Analytics Views: 3 materialized views for academic performance tracking';
    RAISE NOTICE 'Specialized Functions: 4 graduate-specific optimization functions';
    RAISE NOTICE 'Academic Standards: Publication, citation, and credibility building focus';
    RAISE NOTICE '=== READY FOR GRADUATE ACADEMIC EXCELLENCE ===';
END $$;

-- Refresh materialized views for initial state
SELECT refresh_graduate_analytics_views();

COMMIT;