--
-- PostgreSQL database dump
--

\restrict lIzlRSOjBIvya7MTlWrLknCQ1dACbw4ouL3zBDget9Usqh5rZTDbRTH40MzcGpU

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: public; Owner: postgresuser
--

CREATE TABLE public."__EFMigrationsHistory" (
    migration_id character varying(150) NOT NULL,
    product_version character varying(32) NOT NULL
);


ALTER TABLE public."__EFMigrationsHistory" OWNER TO postgresuser;

--
-- Name: als_drafts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.als_drafts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    study_id uuid,
    name character varying(255) NOT NULL,
    file_name character varying(255) NOT NULL,
    file_content text,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.als_drafts OWNER TO postgres;

--
-- Name: TABLE als_drafts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.als_drafts IS 'ALS draft files uploaded for each study, containing version history';


--
-- Name: COLUMN als_drafts.version; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.als_drafts.version IS 'Version number for ALS draft, incremented with each upload';


--
-- Name: COLUMN als_drafts.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.als_drafts.is_active IS 'Flag indicating if this is the active version of the ALS draft';


--
-- Name: chat_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_messages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    session_id uuid,
    content text NOT NULL,
    message_type character varying(20) NOT NULL,
    editcheck_spec_id uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.chat_messages OWNER TO postgres;

--
-- Name: chat_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_sessions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id character varying(255),
    study_id uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.chat_sessions OWNER TO postgres;

--
-- Name: check_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.check_actions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    check_step_id uuid,
    action_oid character varying(255) NOT NULL,
    action_name character varying(255),
    action_type character varying(100),
    ordinal integer,
    form_oids text,
    field_oids text,
    custom_function character varying(255),
    action_code text,
    message_oid character varying(255),
    gateway_oid character varying(255),
    options text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.check_actions OWNER TO postgres;

--
-- Name: check_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.check_steps (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    check_id uuid,
    step_oid character varying(255) NOT NULL,
    step_name character varying(255),
    step_type character varying(100),
    ordinal integer,
    form_oids text,
    field_oids text,
    custom_function character varying(255),
    check_code text,
    message_oid character varying(255),
    flag_type character varying(100),
    flag_target character varying(100),
    gateway_oid character varying(255),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.check_steps OWNER TO postgres;

--
-- Name: checks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.checks (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    check_oid character varying(255) NOT NULL,
    check_name character varying(255),
    check_type character varying(100),
    category text,
    sub_category text,
    is_active boolean DEFAULT true,
    fire_trigger character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.checks OWNER TO postgres;

--
-- Name: coder_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coder_configuration (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    form_oid character varying(255) NOT NULL,
    field_oid character varying(255) NOT NULL,
    coding_level character varying(50),
    priority integer DEFAULT 1,
    locale character varying(10) DEFAULT 'eng'::character varying,
    is_approval_required boolean DEFAULT false,
    is_auto_approval boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.coder_configuration OWNER TO postgres;

--
-- Name: coder_supplemental_terms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coder_supplemental_terms (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    form_oid character varying(255) NOT NULL,
    field_oid character varying(255) NOT NULL,
    supplemental_term character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.coder_supplemental_terms OWNER TO postgres;

--
-- Name: crf_drafts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.crf_drafts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    draft_name character varying(255),
    delete_existing boolean DEFAULT false,
    project_name character varying(255),
    project_type character varying(100),
    primary_form_oid character varying(255),
    default_matrix_oid character varying(255),
    confirmation_message text,
    signature_prompt text,
    lab_standard_group character varying(255),
    reference_labs text,
    alert_labs text,
    sync_oid_project character varying(255),
    sync_oid_draft character varying(255),
    sync_oid_project_type character varying(255),
    sync_oid_originals_version character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    active boolean DEFAULT true
);


ALTER TABLE public.crf_drafts OWNER TO postgres;

--
-- Name: TABLE crf_drafts; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.crf_drafts IS 'CRF draft configuration from ALS CRFDraft sheet containing project-level settings';


--
-- Name: COLUMN crf_drafts.draft_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.crf_drafts.draft_name IS 'Name of CRF draft from ALS CRFDraft sheet';


--
-- Name: COLUMN crf_drafts.project_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.crf_drafts.project_type IS 'Type of project (Clinical, Observational, etc.)';


--
-- Name: COLUMN crf_drafts.primary_form_oid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.crf_drafts.primary_form_oid IS 'Primary form identifier for the study';


--
-- Name: custom_functions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.custom_functions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    function_name character varying(255) NOT NULL,
    source_code text NOT NULL,
    language character varying(50) DEFAULT 'C#'::character varying,
    description text,
    author character varying(255),
    created_date date,
    source_info text,
    calls_info text,
    is_ai_generated boolean DEFAULT false,
    is_validated boolean DEFAULT false,
    created_by character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    edit_check_id uuid
);


ALTER TABLE public.custom_functions OWNER TO postgres;

--
-- Name: TABLE custom_functions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.custom_functions IS 'Custom functions from ALS CustomFunctions sheet for edit checks and derivations';


--
-- Name: data_dictionaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_dictionaries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    dictionary_oid character varying(255) NOT NULL,
    dictionary_name character varying(255),
    data_type character varying(100),
    length integer,
    significant_digits integer,
    sas_field_name character varying(255),
    origin character varying(100),
    comment text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.data_dictionaries OWNER TO postgres;

--
-- Name: data_dictionary_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.data_dictionary_entries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    data_dictionary_id uuid,
    coded_value character varying(255),
    user_data_string character varying(255),
    ordinal integer,
    specify boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.data_dictionary_entries OWNER TO postgres;

--
-- Name: derivation_steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.derivation_steps (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    derivation_id uuid,
    step_oid character varying(255) NOT NULL,
    step_name character varying(255),
    step_type character varying(100),
    ordinal integer,
    form_oids text,
    field_oids text,
    custom_function character varying(255),
    derivation_code text,
    target_form_oid character varying(255),
    target_field_oid character varying(255),
    gateway_oid character varying(255),
    is_active boolean DEFAULT true,
    is_draft_only boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.derivation_steps OWNER TO postgres;

--
-- Name: derivations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.derivations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    derivation_oid character varying(255) NOT NULL,
    derivation_name character varying(255),
    derivation_type character varying(100),
    ordinal integer,
    is_active boolean DEFAULT true,
    all_forms boolean DEFAULT false,
    form_oids text,
    field_oids text,
    custom_function character varying(255),
    fire_trigger character varying(100),
    is_draft_only boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.derivations OWNER TO postgres;

--
-- Name: edit_check_marking_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edit_check_marking_groups (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    edit_check_id uuid,
    marking_group character varying(255),
    notes text,
    internal_comments text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.edit_check_marking_groups OWNER TO postgres;

--
-- Name: TABLE edit_check_marking_groups; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.edit_check_marking_groups IS 'Marking group assignments and notes from edit check specifications';


--
-- Name: edit_check_message_text; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edit_check_message_text (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    edit_check_id uuid,
    message_text text NOT NULL,
    message_type character varying(50) DEFAULT 'Validation'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.edit_check_message_text OWNER TO postgres;

--
-- Name: TABLE edit_check_message_text; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.edit_check_message_text IS 'User-facing messages extracted from edit check Message_Text column';


--
-- Name: edit_check_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edit_check_rules (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    edit_check_id uuid,
    rule_logic text NOT NULL,
    rule_order integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.edit_check_rules OWNER TO postgres;

--
-- Name: TABLE edit_check_rules; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.edit_check_rules IS 'Individual rule logic extracted from edit check Rule column';


--
-- Name: edit_checks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edit_checks (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    study_id uuid,
    spec_id character varying(50),
    node_name character varying(500),
    work_item_type character varying(100) DEFAULT 'Edit Check'::character varying,
    state character varying(100),
    title character varying(255),
    source character varying(255),
    study_check_id character varying(255),
    check_type character varying(100),
    edit_check_domain character varying(255),
    domain character varying(255),
    form_id character varying(255),
    query_field character varying(255),
    complexity character varying(50),
    trial_grid_yn boolean DEFAULT false,
    standard_custom character varying(50) DEFAULT 'Custom'::character varying,
    migrated boolean DEFAULT false,
    origin_id character varying(255),
    related_link_count integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    notes text,
    internal_comments text,
    test_output_comments text,
    assigned_to character varying(255),
    test_failure_root_cause text,
    test_failure_action_taken text,
    rule text,
    message_text text,
    edit_checks_marking_group character varying(255),
    als_draft_id uuid
);


ALTER TABLE public.edit_checks OWNER TO postgres;

--
-- Name: TABLE edit_checks; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.edit_checks IS 'Edit check specifications from EditCheck spec file with complete validation rules';


--
-- Name: COLUMN edit_checks.spec_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.edit_checks.spec_id IS 'ID from EditCheck specification file';


--
-- Name: COLUMN edit_checks.study_check_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.edit_checks.study_check_id IS 'Study-specific check identifier (e.g., EGL_01, EGL_02)';


--
-- Name: COLUMN edit_checks.check_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.edit_checks.check_type IS 'Type of check (Custom Function, Standard, etc.)';


--
-- Name: COLUMN edit_checks.complexity; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.edit_checks.complexity IS 'Complexity rating (1-Low, 2-Medium, 3-High)';


--
-- Name: COLUMN edit_checks.trial_grid_yn; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.edit_checks.trial_grid_yn IS 'Whether check applies to trial grid data';


--
-- Name: editcheck_specs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editcheck_specs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    content text NOT NULL,
    study_id uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.editcheck_specs OWNER TO postgres;

--
-- Name: email_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_alerts (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    unique_id character varying(255),
    email_alert_type character varying(100),
    effective_date date,
    days_to_trigger integer,
    locale character varying(10) DEFAULT 'eng'::character varying,
    subject_string text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.email_alerts OWNER TO postgres;

--
-- Name: folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.folders (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    folder_oid character varying(255) NOT NULL,
    ordinal integer,
    folder_name character varying(255),
    access_days integer,
    is_reusable boolean DEFAULT false,
    is_required boolean DEFAULT false,
    double_data_entry boolean DEFAULT false,
    is_signature_required boolean DEFAULT false,
    review_groups character varying(255),
    entry_restriction character varying(100),
    confirmation_style character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.folders OWNER TO postgres;

--
-- Name: form_fields; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.form_fields (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    form_id uuid,
    field_oid character varying(255) NOT NULL,
    field_name character varying(255),
    data_type character varying(50),
    is_required boolean DEFAULT false,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ordinal integer,
    draft_field_number character varying(50),
    draft_field_name character varying(255),
    draft_field_active boolean DEFAULT true,
    variable_oid character varying(255),
    date_format character varying(50),
    data_dictionary_name character varying(255),
    unit_dictionary_name character varying(255),
    coding_dictionary character varying(255),
    control_type character varying(100),
    acceptable_file_extensions text,
    indent_level integer DEFAULT 0,
    pre_text text,
    fixed_unit character varying(100),
    header_text text,
    help_text text,
    source_document text,
    is_log boolean DEFAULT false,
    default_value text,
    sas_label character varying(255),
    sas_format character varying(100),
    epro_format character varying(100),
    query_future_date boolean DEFAULT false,
    is_visible boolean DEFAULT true,
    is_translation_required boolean DEFAULT false,
    analyte_name character varying(255),
    is_clinical_significance boolean DEFAULT false,
    query_non_conformance boolean DEFAULT false,
    other_visits text,
    can_set_record_date boolean DEFAULT false,
    can_set_data_page_date boolean DEFAULT false,
    can_set_instance_date boolean DEFAULT false,
    can_set_subject_date boolean DEFAULT false,
    does_not_break_signature boolean DEFAULT false,
    lower_range numeric,
    upper_range numeric,
    nc_lower_range numeric,
    nc_upper_range numeric,
    review_groups text,
    is_visual_verify boolean DEFAULT false,
    sas_field_name character varying(255),
    field_type character varying(100),
    unit character varying(100),
    format_string character varying(255),
    range_check_type character varying(100),
    range_check_value character varying(255),
    code_list character varying(255),
    code_list_oid character varying(255),
    length integer,
    significant_digits integer,
    is_readonly boolean DEFAULT false,
    is_review_flag boolean DEFAULT false,
    is_non_null boolean DEFAULT false,
    is_sdv_required boolean DEFAULT false,
    is_source_data_verification boolean DEFAULT false,
    is_key_field boolean DEFAULT false,
    is_clinically_significant boolean DEFAULT false,
    post_text character varying(255),
    translation_required boolean DEFAULT false,
    mask_data boolean DEFAULT false,
    field_number integer,
    page_number integer,
    tab_index integer,
    derivation_flag boolean DEFAULT false,
    origin character varying(100),
    pages character varying(255),
    vendor_name character varying(255),
    viewrestrictions character varying(255),
    editrestrictions character varying(255),
    custom_function character varying(255)
);


ALTER TABLE public.form_fields OWNER TO postgres;

--
-- Name: TABLE form_fields; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.form_fields IS 'Fields extracted from ALS Fields sheet with complete field configuration and validation rules';


--
-- Name: COLUMN form_fields.field_oid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.form_fields.field_oid IS 'Unique field identifier from ALS Fields sheet FildOID column';


--
-- Name: COLUMN form_fields.variable_oid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.form_fields.variable_oid IS 'Variable identifier for CDISC mapping from ALS Fields sheet';


--
-- Name: COLUMN form_fields.data_dictionary_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.form_fields.data_dictionary_name IS 'Reference to data dictionary for coded values';


--
-- Name: COLUMN form_fields.control_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.form_fields.control_type IS 'UI control type (text, dropdown, checkbox, etc.) from ALS Fields sheet';


--
-- Name: COLUMN form_fields.lower_range; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.form_fields.lower_range IS 'Lower acceptable range for numeric fields';


--
-- Name: COLUMN form_fields.upper_range; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.form_fields.upper_range IS 'Upper acceptable range for numeric fields';


--
-- Name: generated_functions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.generated_functions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    code text NOT NULL,
    description text,
    editcheck_spec_id uuid,
    study_id uuid,
    custom_function_id uuid,
    referenced_fields_json text,
    is_validated boolean DEFAULT false,
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.generated_functions OWNER TO postgres;

--
-- Name: lab_variable_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_variable_mappings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    global_variable_oid character varying(255),
    form_oid character varying(255),
    field_oid character varying(255),
    folder_oid character varying(255),
    location_method character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.lab_variable_mappings OWNER TO postgres;

--
-- Name: matrices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matrices (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    matrix_oid character varying(255) NOT NULL,
    matrix_name character varying(255),
    ordinal integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.matrices OWNER TO postgres;

--
-- Name: matrix_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matrix_data (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    matrix_id uuid,
    sheet_name character varying(255),
    row_data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.matrix_data OWNER TO postgres;

--
-- Name: studies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studies (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    protocol_number character varying(100),
    editcheck_spec_file_name character varying(255),
    editcheck_spec_content text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.studies OWNER TO postgres;

--
-- Name: TABLE studies; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.studies IS 'Main studies table containing basic study information and metadata';


--
-- Name: COLUMN studies.protocol_number; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.studies.protocol_number IS 'Study protocol identifier (e.g., MEK1122-01_PPL)';


--
-- Name: COLUMN studies.editcheck_spec_file_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.studies.editcheck_spec_file_name IS 'Name of uploaded EditCheck specification file';


--
-- Name: COLUMN studies.editcheck_spec_content; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.studies.editcheck_spec_content IS 'Raw content of EditCheck specification file';


--
-- Name: study_forms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_forms (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    form_oid character varying(255) NOT NULL,
    form_name character varying(255),
    domain character varying(100),
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ordinal integer,
    draft_form_active boolean DEFAULT true,
    help_text text,
    is_template boolean DEFAULT false,
    is_signature_required boolean DEFAULT false,
    is_epro_form boolean DEFAULT false,
    view_restrictions text,
    entry_restrictions text,
    log_directions text,
    dde_option text,
    confirmation_style text,
    link_folder_oid character varying(255),
    link_form_oid character varying(255),
    draft_form_name character varying(255),
    form_type character varying(100),
    double_data_entry boolean DEFAULT false,
    is_sdv_required boolean DEFAULT false,
    is_source_data_verification boolean DEFAULT false,
    is_key_form boolean DEFAULT false,
    review_groups character varying(255)
);


ALTER TABLE public.study_forms OWNER TO postgres;

--
-- Name: TABLE study_forms; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.study_forms IS 'Forms extracted from ALS Files sheet with complete form configuration';


--
-- Name: COLUMN study_forms.form_oid; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_forms.form_oid IS 'Unique form identifier from ALS Forms sheet OID column';


--
-- Name: COLUMN study_forms.ordinal; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_forms.ordinal IS 'Display order of form from ALS Forms sheet';


--
-- Name: COLUMN study_forms.draft_form_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_forms.draft_form_active IS 'Whether form is active from ALS Forms sheet';


--
-- Name: COLUMN study_forms.is_signature_required; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.study_forms.is_signature_required IS 'Whether electronic signature is required for this form';


--
-- Name: test_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_results (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    edit_check_id uuid,
    test_output_comments text,
    assigned_to character varying(255),
    test_failure_root_cause text,
    test_failure_action_taken text,
    complexity integer DEFAULT 1,
    trial_grid_yn boolean DEFAULT false,
    standard_custom character varying(50) DEFAULT 'Custom'::character varying,
    migrated boolean DEFAULT false,
    origin_id character varying(255),
    related_link_count integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.test_results OWNER TO postgres;

--
-- Name: TABLE test_results; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.test_results IS 'Test results and QA tracking data from edit check specifications';


--
-- Name: unit_dictionaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit_dictionaries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    als_draft_id uuid,
    dictionary_oid character varying(255) NOT NULL,
    dictionary_name character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.unit_dictionaries OWNER TO postgres;

--
-- Name: unit_dictionary_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit_dictionary_entries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    unit_dictionary_id uuid,
    symbol character varying(100),
    unit_name character varying(255),
    ordinal integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.unit_dictionary_entries OWNER TO postgres;

--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: public; Owner: postgresuser
--

COPY public."__EFMigrationsHistory" (migration_id, product_version) FROM stdin;
20251026033130_InitialMigration	9.0.10
\.


--
-- Data for Name: als_drafts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.als_drafts (id, study_id, name, file_name, file_content, version, is_active, created_at) FROM stdin;
cc44866f-e2fd-4308-8287-7c7a45d46196	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	MEK1122-01_PPL	MEK1122-01_PPL.xlsx	\N	1	t	2025-10-26 14:29:28.086732
40ff3ae3-6d90-4a79-9845-fb0c787b1f22	e0462431-57ad-464e-bcc4-1e8a396e6c5f	ALS_File_final	ALS_File_final.xlsx	\N	1	t	2025-10-26 20:05:09.024441
1a3fca64-682d-40c6-95f6-da0f595570c9	8838cdd0-f40a-444a-a9a1-a06987c69c38	ALS_File_final	ALS_File_final.xlsx	\N	1	t	2025-10-27 08:36:03.874968
\.


--
-- Data for Name: chat_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_messages (id, session_id, content, message_type, editcheck_spec_id, created_at) FROM stdin;
dce242ed-2e82-4d74-a84e-4626182f0bc6	dcad0212-b374-4b07-9d9b-d7e2497782e1	hello	User	\N	2025-10-25 17:49:06.572306
9d94739a-7739-4926-8308-fe1582808fad	dcad0212-b374-4b07-9d9b-d7e2497782e1	Hello! How can I assist you today with RAVE architect custom functions? Whether you need help with edit check specifications, generating C# functions, understanding database field relationships, or coding guidance, I'm here to help!	Assistant	\N	2025-10-25 17:49:08.101785
df7ba472-bf36-42bd-a18a-2d0b8cc53a0e	dcad0212-b374-4b07-9d9b-d7e2497782e1	create a functio for overlapping visits	User	\N	2025-10-25 17:49:22.440818
d4e5e82b-199d-453f-bcd3-880872b8fa84	dcad0212-b374-4b07-9d9b-d7e2497782e1	```csharp\n/// <summary>\n/// Checks for overlapping visits based on the provided visit start and end dates.\n/// </summary>\n/// <param name="visitStartDate">The start date of the visit.</param>\n/// <param name="visitEndDate">The end date of the visit.</param>\n/// <param name="existingVisits">A list of existing visits with their start and end dates.</param>\n/// <returns>True if there are overlapping visits; otherwise, false.</returns>\n/// <exception cref="ArgumentException">Thrown when the visit dates are invalid.</exception>\npublic bool CheckForOverlappingVisits(DateTime visitStartDate, DateTime visitEndDate, List<(DateTime Start, DateTime End)> existingVisits)\n{\n    // Validate input parameters\n    if (visitStartDate == default || visitEndDate == default)\n    {\n        throw new ArgumentException("Visit start and end dates must be valid DateTime values.");\n    }\n\n    if (visitStartDate >= visitEndDate)\n    {\n        throw new ArgumentException("Visit start date must be earlier than the end date.");\n    }\n\n    if (existingVisits == null)\n    {\n        throw new ArgumentException("Existing visits list cannot be null.");\n    }\n\n    // Check for overlaps with existing visits\n    foreach (var existingVisit in existingVisits)\n    {\n        if (visitStartDate < existingVisit.End && visitEndDate > existingVisit.Start)\n        {\n            return true; // Overlap found\n        }\n    }\n\n    return false; // No overlaps\n}\n```	Assistant	\N	2025-10-25 17:49:26.680782
6a2f3e4d-e610-42f8-bf61-fbc1584cf349	ad88a156-9ab0-4a51-a60b-4be1573d85b3	hello	User	\N	2025-10-25 19:18:21.44506
4d2ea30d-44b0-4b23-b24e-6e0b9a78039c	ad88a156-9ab0-4a51-a60b-4be1573d85b3	Hello! How can I assist you today with RAVE architect custom functions? Whether you need help understanding edit check specifications, generating C# functions, or anything else related to RAVE, feel free to ask!	Assistant	\N	2025-10-25 19:18:23.142603
29eb66a8-3ffb-4078-819c-df50287537a0	ad88a156-9ab0-4a51-a60b-4be1573d85b3	do u support autocomplete	User	\N	2025-10-25 19:18:31.569861
6dc9bc53-5bc0-49bf-a9a7-6e7633a1f749	ad88a156-9ab0-4a51-a60b-4be1573d85b3	Yes, I can assist you with autocomplete features in your RAVE Architect custom functions. While RAVE itself may not have built-in autocomplete for custom functions, you can implement certain practices to enhance your coding experience. Here are a few tips:\n\n1. **Use IDE Features**: If you're using an Integrated Development Environment (IDE) like Visual Studio, it typically has robust autocomplete features that can help you with C# syntax, method names, and available classes.\n\n2. **Code Snippets**: You can create code snippets for frequently used functions or patterns in your RAVE custom functions. This can speed up your coding process and reduce errors.\n\n3. **Documentation**: Keep the RAVE documentation handy. It provides details on available functions, methods, and their parameters, which can help you while coding.\n\n4. **Commenting**: Use comments in your code to describe what each part does. This not only helps you remember your logic but can also assist others who may read your code later.\n\nIf you have specific questions about implementing autocomplete or need help with a particular function, feel free to ask!	Assistant	\N	2025-10-25 19:18:33.304941
b72139c7-856e-4788-86e8-945308a21cd6	2521bc58-7139-412f-994b-b2be9c71b3ae	hey there	User	\N	2025-10-26 14:52:30.48107
27ecd45d-4a76-42f4-b6df-03c70e7f6fd3	2521bc58-7139-412f-994b-b2be9c71b3ae	Hello! How can I assist you today with RAVE architect custom functions? Whether you need help with edit check specifications, generating C# functions, understanding database field relationships, or coding guidance, I'm here to help!	Assistant	\N	2025-10-26 14:52:33.885589
560211ec-3932-4ded-b9d7-dbf9bfcbaff5	6a557f36-31fb-473a-97d7-f4f4b0378105	hello who are u	User	\N	2025-10-26 15:21:06.003131
1b20978a-5b2a-49a5-8f53-426010043eb5	6a557f36-31fb-473a-97d7-f4f4b0378105	Hello! I’m an AI assistant specialized in helping developers create custom functions for RAVE Architect. I can assist you with understanding edit check specifications, generating C# functions, explaining database field relationships, and providing coding guidance. How can I help you today?	Assistant	\N	2025-10-26 15:21:08.193784
c29f4fcc-6fc8-4d3c-a021-9ce93509b432	90ed5391-2061-420e-a0ad-afbfc4088c67	hello	User	\N	2025-10-26 20:21:10.906942
653ff2db-9d96-4ead-82ad-9e5647a2edc3	90ed5391-2061-420e-a0ad-afbfc4088c67	Hello! How can I assist you today with RAVE architect custom functions? Whether you need help with edit check specifications, generating C# functions, understanding database field relationships, or coding guidance, I'm here to help!	Assistant	\N	2025-10-26 20:21:13.131137
7f82f410-992e-470c-a41d-4301ad80da93	3451025b-807c-455f-9288-82f02d9d3d0b	hey there	User	\N	2025-10-27 06:17:56.760089
0ba4f071-7e03-4585-b484-2b45c4bc0004	3451025b-807c-455f-9288-82f02d9d3d0b	Hello! How can I assist you today with RAVE architect custom functions? Whether you need help with edit check specifications, generating C# functions, understanding database field relationships, or coding guidance, I'm here to help!	Assistant	\N	2025-10-27 06:17:57.462719
ddbdd04c-da9b-4631-8cfb-ebd0ffc9492f	2a4c2960-78c3-454f-8f68-f7417fb891fd	who r u	User	\N	2025-10-27 06:18:06.866029
fe4bf8ab-bfa5-4e07-8acc-fcd956232443	2a4c2960-78c3-454f-8f68-f7417fb891fd	I am an AI assistant specialized in helping developers create custom functions for RAVE Architect. I can assist you with understanding edit check specifications, generating C# functions for RAVE, explaining database field relationships, and providing coding guidance. How can I assist you today?	Assistant	\N	2025-10-27 06:18:07.533089
56a5abf1-6eb6-4c2b-9b8e-8ccf09137d10	99d11ef1-d11a-4dae-8d5b-3082d0f3199f	what is a rave function. show an example	User	\N	2025-10-27 07:11:05.227616
0f31043b-d626-4784-aed1-0d7669d9c478	99d11ef1-d11a-4dae-8d5b-3082d0f3199f	public class ClinicalDataValidation\n{\n    // Rule: Ensure that the 'Age' field is not negative and does not exceed 120.\n    // Message: "Age must be between 0 and 120."\n    // Author: [Your Name]\n\n    public static ValidationResult ValidateAge(int? age)\n    {\n        // Check if the age parameter is null\n        if (!age.HasValue)\n        {\n            return new ValidationResult(false, "Age cannot be null.");\n        }\n\n        // Check if the age is negative\n        if (age < 0)\n        {\n            return new ValidationResult(false, "Age cannot be negative.");\n        }\n\n        // Check if the age exceeds 120\n        if (age > 120)\n        {\n            return new ValidationResult(false, "Age must not exceed 120.");\n        }\n\n        // If all checks pass, return a valid result\n        return new ValidationResult(true, "Age is valid.");\n    }\n}	Assistant	\N	2025-10-27 07:11:08.745475
\.


--
-- Data for Name: chat_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chat_sessions (id, user_id, study_id, created_at) FROM stdin;
dcad0212-b374-4b07-9d9b-d7e2497782e1	\N	\N	2025-10-25 17:49:06.536074
ad88a156-9ab0-4a51-a60b-4be1573d85b3	\N	\N	2025-10-25 19:18:20.878546
2521bc58-7139-412f-994b-b2be9c71b3ae	\N	\N	2025-10-26 14:52:30.322006
6a557f36-31fb-473a-97d7-f4f4b0378105	\N	\N	2025-10-26 15:21:05.022533
90ed5391-2061-420e-a0ad-afbfc4088c67	\N	\N	2025-10-26 20:21:10.873018
3451025b-807c-455f-9288-82f02d9d3d0b	\N	\N	2025-10-27 06:17:56.38244
2a4c2960-78c3-454f-8f68-f7417fb891fd	\N	\N	2025-10-27 06:18:06.860092
99d11ef1-d11a-4dae-8d5b-3082d0f3199f	\N	\N	2025-10-27 07:11:05.156949
\.


--
-- Data for Name: check_actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.check_actions (id, check_step_id, action_oid, action_name, action_type, ordinal, form_oids, field_oids, custom_function, action_code, message_oid, gateway_oid, options, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: check_steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.check_steps (id, check_id, step_oid, step_name, step_type, ordinal, form_oids, field_oids, custom_function, check_code, message_oid, flag_type, flag_target, gateway_oid, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: checks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.checks (id, als_draft_id, check_oid, check_name, check_type, category, sub_category, is_active, fire_trigger, created_at) FROM stdin;
823667eb-24f3-4203-9e3b-cdf17f48a995	cc44866f-e2fd-4308-8287-7c7a45d46196	OPNQRY_SV_VISDAT_Missing	1	1	IF (VISSTAT in Visit Date with record position 0 IsEqualTo 0) and (VISDAT in VisitDate with record position 0 IsEmpty) then…open a query to Site from System on VISDAT in VisitDate with record position 0, displaying "please provide the visit date or dindicate as not done/" (requires response)(requires manual close)	Project versio on XYZ study	f	References the following custom functions: SHFLD_DSTRT_DSTERM_WBS	2025-10-26 14:29:28.758553
2a4550d3-a8f2-45e1-86a0-49639d3ac2a3	cc44866f-e2fd-4308-8287-7c7a45d46196	SHFLD_DSTRT_DSTERM_WBS	0	1	if DSTRT_DSDECOD in End of Treatment - ABCProtocol with record position 0 isPresent then… execute the "SHFLD_DSTRT_DSTERM_WBS" custom function	Project versio on XYZ study	t	References the following custom functions: SHFLD_DSTRT_DSTERM_WBS	2025-10-26 14:29:28.758384
d12eb5cf-805a-470d-98e7-a9524d60c9d7	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	SHFLD_DSTRT_DSTERM_WBS	0	1	if DSTRT_DSDECOD in End of Treatment - ABCProtocol with record position 0 isPresent then… execute the "SHFLD_DSTRT_DSTERM_WBS" custom function	Project versio on XYZ study	t	References the following custom functions: SHFLD_DSTRT_DSTERM_WBS	2025-10-26 20:05:09.58071
c7171cc7-de8e-448d-8b6e-77f36546a917	1a3fca64-682d-40c6-95f6-da0f595570c9	SHFLD_DSTRT_DSTERM_WBS	0	1	if DSTRT_DSDECOD in End of Treatment - ABCProtocol with record position 0 isPresent then… execute the "SHFLD_DSTRT_DSTERM_WBS" custom function	Project versio on XYZ study	t	References the following custom functions: SHFLD_DSTRT_DSTERM_WBS	2025-10-27 08:36:04.524575
\.


--
-- Data for Name: coder_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coder_configuration (id, als_draft_id, form_oid, field_oid, coding_level, priority, locale, is_approval_required, is_auto_approval, created_at) FROM stdin;
\.


--
-- Data for Name: coder_supplemental_terms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coder_supplemental_terms (id, als_draft_id, form_oid, field_oid, supplemental_term, created_at) FROM stdin;
\.


--
-- Data for Name: crf_drafts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.crf_drafts (id, als_draft_id, draft_name, delete_existing, project_name, project_type, primary_form_oid, default_matrix_oid, confirmation_message, signature_prompt, lab_standard_group, reference_labs, alert_labs, sync_oid_project, sync_oid_draft, sync_oid_project_type, sync_oid_originals_version, created_at, active) FROM stdin;
af370813-ac63-4842-a197-f85cc57ecd0b	cc44866f-e2fd-4308-8287-7c7a45d46196	MSD	f	7339-009	Project	SI	PRIMARY	The form has been saved	By my dated signature below I verify that all the data entries on the case report forms are complete and accurate	ICON Standard			\N	\N	\N	\N	2025-10-26 14:29:28.508076	t
7ccda963-e688-4d01-b252-591c705af2d9	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	Pfizer	f	MM32	Project	SI	PRIMARY	The form has been saved	By my dated signature below I verify that all the data entries on the case report forms are complete and accurate	ICON Standard			\N	\N	\N	\N	2025-10-26 20:05:09.325329	t
e3c1e039-5248-4bb1-b659-dcff0337ac00	1a3fca64-682d-40c6-95f6-da0f595570c9	Pfizer	f	MM32	Project	SI	PRIMARY	The form has been saved	By my dated signature below I verify that all the data entries on the case report forms are complete and accurate	ICON Standard			\N	\N	\N	\N	2025-10-27 08:36:04.12761	t
\.


--
-- Data for Name: custom_functions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.custom_functions (id, als_draft_id, function_name, source_code, language, description, author, created_date, source_info, calls_info, is_ai_generated, is_validated, created_by, created_at, updated_at, edit_check_id) FROM stdin;
9a800072-c01b-4de1-8156-68c007cac76b	cc44866f-e2fd-4308-8287-7c7a45d46196	SHFLD_DSTRT_DSTERM_WBS	/*******************************************************************************\n* Developer: John Doe XYZORG * Date: 16 : MAY : 2025 * Custom Function:SHFLD_DSTRT_DSTERM_WBS\n* Edit : SHFLD_DSTRT_DSTERM_WBS,cross\n* Logic: If primary reason for treatment discontinuation [DSTRT_DSDECOD] is ""Withdrawal by Subject"",then display the reason otherwise hide the field.\n* Modification History :\n* *******************************************************************************\n*/\n\nActionFunctionParams afp = (ActionFunctionParams) ThisObject;\nDataPoint Dpt_action = afp.ActionDataPoint;\n//DSTRT_DSDECOD\nSubject ThisSubj = Dpt_action.Record.Subject;\nbool Cond = false;\n\nif (checkvalid(Dpt_action))\n{\n    if (Dpt_action.Data== ""WITHDRAWAL BY SUBJECT"") Cond = true;\n    DataPoint Dpt1 = Dpt_action.Record.DataPoints.FindByFieldOID(""DSTRT_DSTERM_WBS"");\n    \n    if (checkvalid(Dpt1))\n    {\n        SetVisible(Dpt1, Cond);\n    }\n}\nreturn null;\n\nvoid SetVisible(DataPoint Dpt, bool Cond)\n{\n    if (Dpt != null && Dpt.Active)\n    {\n        if (Cond)\n        {\n            if (!Dpt.IsVisible)\n                Dpt.IsVisible = true;\n        }\n    }\n}	C#	\N	\N	\N	\N	\N	f	f	\N	2025-10-26 14:29:28.454612	2025-10-26 14:29:28.454672	\N
21715749-da9f-4f5f-be6d-8c2ce4979b5d	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	SHFLD_DSTRT_DSTERM_WBS	/*******************************************************************************\n* Developer: John Doe XYZORG * Date: 16 : MAY : 2025 * Custom Function:SHFLD_DSTRT_DSTERM_WBS\n* Edit : SHFLD_DSTRT_DSTERM_WBS,cross\n* Logic: If primary reason for treatment discontinuation [DSTRT_DSDECOD] is ""Withdrawal by Subject"",then display the reason otherwise hide the field.\n* Modification History :\n* *******************************************************************************\n*/\n\nActionFunctionParams afp = (ActionFunctionParams) ThisObject;\nDataPoint Dpt_action = afp.ActionDataPoint;\n//DSTRT_DSDECOD\nSubject ThisSubj = Dpt_action.Record.Subject;\nbool Cond = false;\n\nif (checkvalid(Dpt_action))\n{\n    if (Dpt_action.Data== ""WITHDRAWAL BY SUBJECT"") Cond = true;\n    DataPoint Dpt1 = Dpt_action.Record.DataPoints.FindByFieldOID(""DSTRT_DSTERM_WBS"");\n    \n    if (checkvalid(Dpt1))\n    {\n        SetVisible(Dpt1, Cond);\n    }\n}\nreturn null;\n\nvoid SetVisible(DataPoint Dpt, bool Cond)\n{\n    if (Dpt != null && Dpt.Active)\n    {\n        if (Cond)\n        {\n            if (!Dpt.IsVisible)\n                Dpt.IsVisible = true;\n        }\n    }\n}	C#	\N	\N	\N	\N	\N	f	f	\N	2025-10-26 20:05:09.263269	2025-10-26 20:05:09.263348	\N
f328605d-5f90-4274-af57-b321840dab9c	1a3fca64-682d-40c6-95f6-da0f595570c9	SHFLD_DSTRT_DSTERM_WBS	/*******************************************************************************\n* Developer: John Doe XYZORG * Date: 16 : MAY : 2025 * Custom Function:SHFLD_DSTRT_DSTERM_WBS\n* Edit : SHFLD_DSTRT_DSTERM_WBS,cross\n* Logic: If primary reason for treatment discontinuation [DSTRT_DSDECOD] is ""Withdrawal by Subject"",then display the reason otherwise hide the field.\n* Modification History :\n* *******************************************************************************\n*/\n\nActionFunctionParams afp = (ActionFunctionParams) ThisObject;\nDataPoint Dpt_action = afp.ActionDataPoint;\n//DSTRT_DSDECOD\nSubject ThisSubj = Dpt_action.Record.Subject;\nbool Cond = false;\n\nif (checkvalid(Dpt_action))\n{\n    if (Dpt_action.Data== ""WITHDRAWAL BY SUBJECT"") Cond = true;\n    DataPoint Dpt1 = Dpt_action.Record.DataPoints.FindByFieldOID(""DSTRT_DSTERM_WBS"");\n    \n    if (checkvalid(Dpt1))\n    {\n        SetVisible(Dpt1, Cond);\n    }\n}\nreturn null;\n\nvoid SetVisible(DataPoint Dpt, bool Cond)\n{\n    if (Dpt != null && Dpt.Active)\n    {\n        if (Cond)\n        {\n            if (!Dpt.IsVisible)\n                Dpt.IsVisible = true;\n        }\n    }\n}	C#	\N	\N	\N	\N	\N	f	f	\N	2025-10-27 08:36:04.117409	2025-10-27 08:36:04.117409	\N
9296fb36-4717-40d3-9f19-085362d2135c	cc44866f-e2fd-4308-8287-7c7a45d46196	EditCheck_EGL_06	murugaaaaa	C#	Custom function for EditCheck: EGL_06	\N	\N	\N	\N	f	f	Current User	2025-10-27 12:16:47.276847	2025-10-27 12:16:47.276984	\N
951138ec-7c03-4a36-8c60-4688137d60e6	cc44866f-e2fd-4308-8287-7c7a45d46196	EditCheck_EGL_08	Anu	C#	Custom function for EditCheck: EGL_08	\N	\N	\N	\N	f	f	Current User	2025-10-27 17:43:08.610053	2025-10-27 17:43:08.610108	\N
24587373-3af0-4973-8692-9bdc989ab153	cc44866f-e2fd-4308-8287-7c7a45d46196	EditCheck_EGL_02	ganesha	C#	Custom function for EditCheck: EGL_02	\N	\N	\N	\N	f	f	Current User	2025-10-27 23:04:43.066596	2025-10-27 23:04:43.066685	\N
c8b1e7f1-5ae3-4f87-8b9c-640e05e5e000	cc44866f-e2fd-4308-8287-7c7a45d46196	TestFunction_1761590765586	public void TestFunction() { /* Test function */ }	C#	Test function for API connectivity	\N	\N	\N	\N	f	f	Test User	2025-10-28 00:16:05.713292	2025-10-28 00:16:05.71342	\N
\.


--
-- Data for Name: data_dictionaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_dictionaries (id, als_draft_id, dictionary_oid, dictionary_name, data_type, length, significant_digits, sas_field_name, origin, comment, created_at) FROM stdin;
1a0d50bc-62a2-4310-b8d8-ddbafc48583e	cc44866f-e2fd-4308-8287-7c7a45d46196	AEREL	AEREL		\N	\N				2025-10-26 14:29:28.597976
fb08f3df-cbb6-4024-bac8-d419f853b12b	cc44866f-e2fd-4308-8287-7c7a45d46196	EYEVAC	EYEVAC		\N	\N				2025-10-26 14:29:28.597963
4516b324-30df-4c59-93bd-21b5cf01264c	cc44866f-e2fd-4308-8287-7c7a45d46196	ANT_COMPC	ANT_COMPC		\N	\N				2025-10-26 14:29:28.597945
d6baef16-77ce-490d-8ab0-f365d0096e5f	cc44866f-e2fd-4308-8287-7c7a45d46196	SEX	SEX		\N	\N				2025-10-26 14:29:28.597722
52ed4fa7-b471-403e-81df-bc3251924cd3	cc44866f-e2fd-4308-8287-7c7a45d46196	ETHNIC	ETHNIC		\N	\N				2025-10-26 14:29:28.597989
3ba0f2c4-002c-48a4-a69c-a93698ddb781	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	ETHNIC	ETHNIC		\N	\N				2025-10-26 20:05:09.417967
c3026ed9-a6d4-427d-9f24-d848987cc29e	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	ANT_COMPC	ANT_COMPC		\N	\N				2025-10-26 20:05:09.41794
a5b32ace-ea5b-47bb-9796-314d972b46b6	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	SEX	SEX		\N	\N				2025-10-26 20:05:09.417714
4155b4f6-3b4a-4763-abf5-b08457eb43c9	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	EYEVAC	EYEVAC		\N	\N				2025-10-26 20:05:09.417954
cf54de6d-c79b-46bb-be1b-de81b2ee4023	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	AEREL	AEREL		\N	\N				2025-10-26 20:05:09.417961
1eaff433-7580-40ce-8d81-e6bacb32d334	1a3fca64-682d-40c6-95f6-da0f595570c9	ETHNIC	ETHNIC		\N	\N				2025-10-27 08:36:04.210088
b8128e8e-b28a-4634-8644-442338c64172	1a3fca64-682d-40c6-95f6-da0f595570c9	AEREL	AEREL		\N	\N				2025-10-27 08:36:04.210079
2725508c-f588-4f52-8b82-784ad057f8b5	1a3fca64-682d-40c6-95f6-da0f595570c9	ANT_COMPC	ANT_COMPC		\N	\N				2025-10-27 08:36:04.210057
f9ac5bc3-b4aa-4ccb-a079-5c28682623ef	1a3fca64-682d-40c6-95f6-da0f595570c9	SEX	SEX		\N	\N				2025-10-27 08:36:04.209855
ea37b1ae-e756-4906-bec6-4311f2bb45cc	1a3fca64-682d-40c6-95f6-da0f595570c9	EYEVAC	EYEVAC		\N	\N				2025-10-27 08:36:04.210071
\.


--
-- Data for Name: data_dictionary_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.data_dictionary_entries (id, data_dictionary_id, coded_value, user_data_string, ordinal, specify, created_at) FROM stdin;
\.


--
-- Data for Name: derivation_steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.derivation_steps (id, derivation_id, step_oid, step_name, step_type, ordinal, form_oids, field_oids, custom_function, derivation_code, target_form_oid, target_field_oid, gateway_oid, is_active, is_draft_only, created_at) FROM stdin;
\.


--
-- Data for Name: derivations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.derivations (id, als_draft_id, derivation_oid, derivation_name, derivation_type, ordinal, is_active, all_forms, form_oids, field_oids, custom_function, fire_trigger, is_draft_only, created_at) FROM stdin;
\.


--
-- Data for Name: edit_check_marking_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edit_check_marking_groups (id, edit_check_id, marking_group, notes, internal_comments, created_at) FROM stdin;
\.


--
-- Data for Name: edit_check_message_text; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edit_check_message_text (id, edit_check_id, message_text, message_type, created_at) FROM stdin;
\.


--
-- Data for Name: edit_check_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edit_check_rules (id, edit_check_id, rule_logic, rule_order, created_at) FROM stdin;
\.


--
-- Data for Name: edit_checks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edit_checks (id, study_id, spec_id, node_name, work_item_type, state, title, source, study_check_id, check_type, edit_check_domain, domain, form_id, query_field, complexity, trial_grid_yn, standard_custom, migrated, origin_id, related_link_count, created_at, updated_at, notes, internal_comments, test_output_comments, assigned_to, test_failure_root_cause, test_failure_action_taken, rule, message_text, edit_checks_marking_group, als_draft_id) FROM stdin;
ca4aa461-124e-410f-b4da-ce8944d86587	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44415	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_07		EGL_07	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		0	2025-10-26 14:29:29.096927	2025-10-26 14:29:29.096927		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF_EOREASND is Other and EGL_EGPERF_EOREASNDSP is EMPTY	Reason Not Performed is 'Other' however 'If Other, please specify' is empty. Please review and correct	Site	\N
65baf1b5-746d-4b75-81fc-c3b8445bb107	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44413	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_05		EGL_05	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		0	2025-10-26 14:29:29.096901	2025-10-26 14:29:29.096901		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF is Yes and EGL_EGDAT or EGL_EGTIM or EGHMRN_EGORRES or PRAG_EGORRES or QRSAG_EGORRES or QTAG_EGORRES or QTCFAG_EGORRES or RRAG_EGORRES or EGL_INTERP_EGORRES or EGL_INTP_EGORRES is/are not blank	Was the ECG performed? Is  No however 'Reason Not Performed' is empty. Please review and correct	Site	\N
9512919a-21f7-4048-b639-13547c9bd3c0	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44409	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_01		EGL_01	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		1	2025-10-26 14:29:29.093277	2025-10-26 14:29:29.093362		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF is  No and EGL_EGDAT or (EGL_EGTIM OR  EGL_EGTIMUNK) or EGHMRN_EGORRES or QTAG_EGORRES or QTCFAG_EGORRES or RRAG_EGORRES or EGL_INTERP_EGORRES or EGL_INTP_EGORRES is/are not blank	or QTCFAG_EGORRES or EGL_INTERP_EGORRES or EGL_INTP_EGORRES is/are not blank    Was the ECG performed is 'No' however details are provided. Please review and correct	Site	\N
78d468fb-ff28-44ed-b65e-8196730c4968	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44411	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_03		EGL_03	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		1	2025-10-26 14:29:29.096878	2025-10-26 14:29:29.096878		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF is  No and EGL_EGPERF_EOREASND is EMPTY	Was the ECG performed? Is  answered YES  but some details is/are missing. Please check and correct	Site	\N
09c88a1d-f6d9-413f-ba83-4041c0632b46	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44412	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_04		EGL_04	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		0	2025-10-26 14:29:29.096891	2025-10-26 14:29:29.096892		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF is No and EGL_EGPERF_EOREASND is not EMPTY	Was the ECG performed? is answered 'No' but details are provided. Please review and correct	Site	\N
89730213-70aa-4149-8f48-31a89d9f49ef	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44410	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_02		EGL_02	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		1	2025-10-26 14:29:29.096851	2025-10-26 14:29:29.096851		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF is Yes and EGL_EGDAT or (EGL_EGTIM and EGL_EGTIMUNK) or EGHMRN_EGORRES or PRAG_EGORRES or QRSAG_EGORRES or QTAG_EGORRES or QTCFAG_EGORRES or RRAG_EGORRES or EGL_INTERP_EGORRES or EGL_INTP_EGORRES is/are not blank	Was the ECG performed is answered 'Yes' however some details is/are missing. Please check and correct	Site	\N
a9368ddc-6dc9-40f7-a51f-47a5ebc83667	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44414	1234-5678(ABCD-EFGH)	Edit Check	Move to Production	EGL_06		EGL_06	Custom Function	EGL	12-Lead ECG	EGL_EGPERF		1-Low	f	Custom	t		0	2025-10-26 14:29:29.096917	2025-10-26 14:29:29.096917		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF is Not No and EGL_EGPERF_EOREASND is not EMPTY	Was the ECG performed? is not answered 'No' however 'Reason Not Performed' is completed. Please review and correct. Reason Not Performed is 'Other' however 'If Other, please specify' is empty. Please review and correct	Site	\N
e63799f5-1bc1-490a-848d-98393b1bcfc3	7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	44416	1294-6678(ABCD-EFGH)	Edit Check	Deprecated	EGL_08		EGL_08	Custom Function	EGL	12-Lead ECG	EGL_EGPERF_EGREASND		High	f	Custom	t		0	2025-10-26 14:29:29.096937	2025-10-27 23:54:23.132145		Action : Open Query\nReq. Resp. 1\nReq. Man. Close . 1		Ajith Kumar			EGL_EGPERF_EOREASND is not Other and EGL_EGPERF_EOREASNDSP is not EMPTY	Reason Not Performed is not 'Other' however 'If Other, please specify' is completed. Please review and correct	Site	\N
\.


--
-- Data for Name: editcheck_specs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editcheck_specs (id, name, description, content, study_id, created_at) FROM stdin;
\.


--
-- Data for Name: email_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_alerts (id, als_draft_id, unique_id, email_alert_type, effective_date, days_to_trigger, locale, subject_string, created_at) FROM stdin;
\.


--
-- Data for Name: folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.folders (id, als_draft_id, folder_oid, ordinal, folder_name, access_days, is_reusable, is_required, double_data_entry, is_signature_required, review_groups, entry_restriction, confirmation_style, created_at) FROM stdin;
3bf4fd8b-052f-4971-8e3c-9e153d87f2dd	cc44866f-e2fd-4308-8287-7c7a45d46196	SCRN	1	Screening	\N	f	f	f	f			1	2025-10-26 14:29:28.553508
ff1b4ada-f650-4ee8-a8e2-c4d2cd052f7c	cc44866f-e2fd-4308-8287-7c7a45d46196	AE	21	Adverse Events	\N	f	f	f	f			1	2025-10-26 14:29:28.553183
df459118-06df-4c5f-9e9b-7839a134e797	cc44866f-e2fd-4308-8287-7c7a45d46196	PRGRX	39	PregnancyReports	\N	f	f	f	f				2025-10-26 14:29:28.553531
e5ca00c5-812a-4d48-b8cb-3fa34759405d	cc44866f-e2fd-4308-8287-7c7a45d46196	PR	28	Procedures	\N	f	f	f	f			0	2025-10-26 14:29:28.553432
da14bbfa-aa0c-4bac-b8ca-9b3b8280c69d	cc44866f-e2fd-4308-8287-7c7a45d46196	PRGR	40	PregnancyReport	\N	f	f	f	f		PRGRX	0	2025-10-26 14:29:28.553457
fa75caf5-587c-444a-acbb-9823f4e73fd6	cc44866f-e2fd-4308-8287-7c7a45d46196	C1	2	Cycle 1	\N	f	f	f	f			0	2025-10-26 14:29:28.55338
d6f503a8-20d0-4876-8562-de2ff0569d5a	cc44866f-e2fd-4308-8287-7c7a45d46196	SAE	22	Serious Adverse Event	\N	f	f	f	f		AE	1	2025-10-26 14:29:28.553483
9a1d920c-ec02-483b-ad83-44fc04c37670	cc44866f-e2fd-4308-8287-7c7a45d46196	C1D1	3	Day 1 of Cycle 1	\N	f	f	f	f			0	2025-10-26 14:29:28.553408
c8caa838-4b06-4ffd-8d54-3b3d8ee042c7	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	C1D1	3	Day 1 of Cycle 1	\N	f	f	f	f			0	2025-10-26 20:05:09.369805
f3bc5d73-d52b-4554-a848-c1ba6721532d	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	SCRN	1	Screening	\N	f	f	f	f			1	2025-10-26 20:05:09.369882
f8c8dfae-7b40-4f1e-be5e-8eb598196af5	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	AE	21	Adverse Events	\N	f	f	f	f			1	2025-10-26 20:05:09.36961
94109857-1bb8-4351-8383-9cfcd021da80	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	C1	2	Cycle 1	\N	f	f	f	f			0	2025-10-26 20:05:09.369784
ba1944f6-01b6-49e0-9e15-68f1a68302e3	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	PRGRX	39	PregnancyReports	\N	f	f	f	f				2025-10-26 20:05:09.369899
aa755fb9-babf-4b6b-b8c3-c86943efebd0	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	SAE	22	Serious Adverse Event	\N	f	f	f	f		AE	1	2025-10-26 20:05:09.369863
72e6fabe-c847-4fbe-b7b5-ea83ef7bdd4b	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	PRGR	40	PregnancyReport	\N	f	f	f	f		PRGRX	0	2025-10-26 20:05:09.369844
a8fd3f26-3f46-4f83-9dc6-7bd489e1eae7	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	PR	28	Procedures	\N	f	f	f	f			0	2025-10-26 20:05:09.369826
8b3acde2-bf68-4b0e-8c26-cf90a5e6d4e1	1a3fca64-682d-40c6-95f6-da0f595570c9	PRGR	40	PregnancyReport	\N	f	f	f	f		PRGRX	0	2025-10-27 08:36:04.167145
e8bbcab8-3b5e-4d33-a918-2dea955af791	1a3fca64-682d-40c6-95f6-da0f595570c9	C1D1	3	Day 1 of Cycle 1	\N	f	f	f	f			0	2025-10-27 08:36:04.167111
30360828-7d8a-4012-9b11-4ce0d42c13bf	1a3fca64-682d-40c6-95f6-da0f595570c9	SAE	22	Serious Adverse Event	\N	f	f	f	f		AE	1	2025-10-27 08:36:04.167162
42eaa779-3636-42fd-addc-b312965d372f	1a3fca64-682d-40c6-95f6-da0f595570c9	PR	28	Procedures	\N	f	f	f	f			0	2025-10-27 08:36:04.167127
23838ac2-b561-479c-bf9e-8bf2912794e4	1a3fca64-682d-40c6-95f6-da0f595570c9	PRGRX	39	PregnancyReports	\N	f	f	f	f				2025-10-27 08:36:04.167197
df7fc758-9a0a-4edf-b135-219913fca8ca	1a3fca64-682d-40c6-95f6-da0f595570c9	SCRN	1	Screening	\N	f	f	f	f			1	2025-10-27 08:36:04.16718
14245b47-9a65-4410-a434-5aed44521ba2	1a3fca64-682d-40c6-95f6-da0f595570c9	AE	21	Adverse Events	\N	f	f	f	f			1	2025-10-27 08:36:04.166905
91a2290f-9000-49e4-9517-aebf78098156	1a3fca64-682d-40c6-95f6-da0f595570c9	C1	2	Cycle 1	\N	f	f	f	f			0	2025-10-27 08:36:04.167091
\.


--
-- Data for Name: form_fields; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.form_fields (id, form_id, field_oid, field_name, data_type, is_required, description, created_at, ordinal, draft_field_number, draft_field_name, draft_field_active, variable_oid, date_format, data_dictionary_name, unit_dictionary_name, coding_dictionary, control_type, acceptable_file_extensions, indent_level, pre_text, fixed_unit, header_text, help_text, source_document, is_log, default_value, sas_label, sas_format, epro_format, query_future_date, is_visible, is_translation_required, analyte_name, is_clinical_significance, query_non_conformance, other_visits, can_set_record_date, can_set_data_page_date, can_set_instance_date, can_set_subject_date, does_not_break_signature, lower_range, upper_range, nc_lower_range, nc_upper_range, review_groups, is_visual_verify, sas_field_name, field_type, unit, format_string, range_check_type, range_check_value, code_list, code_list_oid, length, significant_digits, is_readonly, is_review_flag, is_non_null, is_sdv_required, is_source_data_verification, is_key_field, is_clinically_significant, post_text, translation_required, mask_data, field_number, page_number, tab_index, derivation_flag, origin, pages, vendor_name, viewrestrictions, editrestrictions, custom_function) FROM stdin;
\.


--
-- Data for Name: generated_functions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.generated_functions (id, name, code, description, editcheck_spec_id, study_id, custom_function_id, referenced_fields_json, is_validated, generated_at) FROM stdin;
abd2cbb3-1d20-4130-9f1e-4dfe7d1d9b8a	CheckForOverlappingVisits	/// <summary>\n/// Checks for overlapping visits based on the provided visit start and end dates.\n/// </summary>\n/// <param name="visitStartDate">The start date of the visit.</param>\n/// <param name="visitEndDate">The end date of the visit.</param>\n/// <param name="existingVisits">A list of existing visits with their start and end dates.</param>\n/// <returns>True if there are overlapping visits; otherwise, false.</returns>\n/// <exception cref="ArgumentException">Thrown when the visit dates are invalid.</exception>\npublic bool CheckForOverlappingVisits(DateTime visitStartDate, DateTime visitEndDate, List<(DateTime Start, DateTime End)> existingVisits)\n{\n    // Validate input parameters\n    if (visitStartDate == default || visitEndDate == default)\n    {\n        throw new ArgumentException("Visit start and end dates must be valid DateTime values.");\n    }\n\n    if (visitStartDate >= visitEndDate)\n    {\n        throw new ArgumentException("Visit start date must be earlier than the end date.");\n    }\n\n    if (existingVisits == null)\n    {\n        throw new ArgumentException("Existing visits list cannot be null.");\n    }\n\n    // Check for overlaps with existing visits\n    foreach (var existingVisit in existingVisits)\n    {\n        if (visitStartDate < existingVisit.End && visitEndDate > existingVisit.Start)\n        {\n            return true; // Overlap found\n        }\n    }\n\n    return false; // No overlaps\n}	/// Checks for overlapping visits based on the provided visit start and end dates.\n///	\N	\N	\N	\N	t	2025-10-25 17:49:26.576236
d58ed0f5-d40d-463b-be92-173cc4a602df	ValidateAge	public static ValidationResult ValidateAge(int? age)\n{\n    // Check if the age parameter is null\n    if (!age.HasValue)\n    {\n        return new ValidationResult(false, "Age cannot be null.");\n    }	Rule: Ensure that the 'Age' field is not negative and does not exceed 120.	\N	\N	\N	\N	f	2025-10-27 07:11:08.545032
\.


--
-- Data for Name: lab_variable_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_variable_mappings (id, als_draft_id, global_variable_oid, form_oid, field_oid, folder_oid, location_method, created_at) FROM stdin;
fa87a3a5-a296-4c02-be81-9f789b363147	cc44866f-e2fd-4308-8287-7c7a45d46196	Sex_Updated3	DM	SEX		EarliestDate	2025-10-26 14:29:28.932678
b26ff03f-9820-424c-af5a-21822b8eec3d	cc44866f-e2fd-4308-8287-7c7a45d46196	Age	SV	SV_AGE		ClosestPriorToDate	2025-10-26 14:29:28.932589
21063d80-8e56-4602-aff9-c33148c423d3	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	Age	SV	SV_AGE		ClosestPriorToDate	2025-10-26 20:05:09.698892
f52b2f5b-0fe8-4a9e-9bba-d11673eabbcb	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	Sex_Updated3	DM	SEX		EarliestDate	2025-10-26 20:05:09.699037
862fbbbf-1fd5-40fc-b19f-b76fabba48a7	1a3fca64-682d-40c6-95f6-da0f595570c9	Sex_Updated3	DM	SEX		EarliestDate	2025-10-27 08:36:04.672642
138b0d4c-cae1-4403-a91c-b379a3a84778	1a3fca64-682d-40c6-95f6-da0f595570c9	Age	SV	SV_AGE		ClosestPriorToDate	2025-10-27 08:36:04.672511
\.


--
-- Data for Name: matrices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matrices (id, als_draft_id, matrix_oid, matrix_name, ordinal, created_at) FROM stdin;
651fdab1-335a-4dcb-ac40-0cd6e57a940f	cc44866f-e2fd-4308-8287-7c7a45d46196	Adverse Events X	AE_X	0	2025-10-26 14:29:28.721272
fe96b11e-ca36-42a0-8653-d15edc6885e3	cc44866f-e2fd-4308-8287-7c7a45d46196	All CRFs	ALLCRFS	0	2025-10-26 14:29:28.72143
05a53a43-b9e4-4e60-9a1e-ebccff8aa542	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	All CRFs	ALLCRFS	0	2025-10-26 20:05:09.552917
887d0196-a005-48ce-a988-e4b7f1bc605a	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	Adverse Events X	AE_X	0	2025-10-26 20:05:09.552744
45ed5939-2fd9-4a97-8885-790c36991834	1a3fca64-682d-40c6-95f6-da0f595570c9	All CRFs	ALLCRFS	0	2025-10-27 08:36:04.457057
fbbff638-1e38-42a2-b607-ef7958e887aa	1a3fca64-682d-40c6-95f6-da0f595570c9	Adverse Events X	AE_X	0	2025-10-27 08:36:04.456828
\.


--
-- Data for Name: matrix_data; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matrix_data (id, matrix_id, sheet_name, row_data, created_at) FROM stdin;
\.


--
-- Data for Name: studies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studies (id, name, description, protocol_number, editcheck_spec_file_name, editcheck_spec_content, created_at, updated_at) FROM stdin;
7e3d2a7d-76f9-439d-b9a8-900a8bf0ca0a	yyyyy	\N	HELLO	Spec_output_new.xlsx	\N	2025-10-26 14:29:27.011245	2025-10-26 14:29:27.011332
e0462431-57ad-464e-bcc4-1e8a396e6c5f	Pfizer MM32	\N	HELLO	Spec.xlsx	\N	2025-10-26 20:05:08.530938	2025-10-26 20:05:08.530999
8838cdd0-f40a-444a-a9a1-a06987c69c38	Eli Lily	\N	HELLO	Spec_File_final.xlsx	\N	2025-10-27 08:36:03.340087	2025-10-27 08:36:03.340177
\.


--
-- Data for Name: study_forms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.study_forms (id, als_draft_id, form_oid, form_name, domain, description, created_at, ordinal, draft_form_active, help_text, is_template, is_signature_required, is_epro_form, view_restrictions, entry_restrictions, log_directions, dde_option, confirmation_style, link_folder_oid, link_form_oid, draft_form_name, form_type, double_data_entry, is_sdv_required, is_source_data_verification, is_key_form, review_groups) FROM stdin;
b7007b85-c2d1-4bee-9d1b-372761cb17a6	cc44866f-e2fd-4308-8287-7c7a45d46196	IC	1			2025-10-26 14:29:28.280961	4	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Informed Consent		f	f	f	f	
d133c5b8-08a2-4b06-9686-6d28efa73515	cc44866f-e2fd-4308-8287-7c7a45d46196	DM	1			2025-10-26 14:29:28.28099	7	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Demographics		f	f	f	f	
224b52f5-a65f-4438-bc34-b59c349db1c3	cc44866f-e2fd-4308-8287-7c7a45d46196	UA	1			2025-10-26 14:29:28.28081	3	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Unscheduled Assessments		f	f	f	f	
0b3b1c16-f69a-4b3e-b3bb-3edfc169c53f	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	DM	1			2025-10-26 20:05:09.15445	7	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Demographics		f	f	f	f	
bb34cef6-fac5-4878-9f18-295f365eaf07	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	UA	1			2025-10-26 20:05:09.154264	3	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Unscheduled Assessments		f	f	f	f	
679e1b0b-8448-477b-bab2-af052f28d3f4	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	IC	1			2025-10-26 20:05:09.154417	4	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Informed Consent		f	f	f	f	
a35ee1d9-ee87-4fa3-947c-5970a14d15ef	1a3fca64-682d-40c6-95f6-da0f595570c9	IC	1			2025-10-27 08:36:04.021194	4	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Informed Consent		f	f	f	f	
bd52d213-aebf-4e7d-870b-5151468c7443	1a3fca64-682d-40c6-95f6-da0f595570c9	UA	1			2025-10-27 08:36:04.021096	3	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Unscheduled Assessments		f	f	f	f	
9acf264a-ce39-4839-be94-1fb0bf95ab69	1a3fca64-682d-40c6-95f6-da0f595570c9	DM	1			2025-10-27 08:36:04.021215	7	t	\N	f	t	f	\N	\N	\N	\N	MustNotDDE	\N	\N	Demographics		f	f	f	f	
\.


--
-- Data for Name: test_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_results (id, edit_check_id, test_output_comments, assigned_to, test_failure_root_cause, test_failure_action_taken, complexity, trial_grid_yn, standard_custom, migrated, origin_id, related_link_count, created_at) FROM stdin;
\.


--
-- Data for Name: unit_dictionaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unit_dictionaries (id, als_draft_id, dictionary_oid, dictionary_name, created_at) FROM stdin;
21a822cd-6902-478b-aefc-e7021de3bf85	cc44866f-e2fd-4308-8287-7c7a45d46196	Temperature Unit	C	2025-10-26 14:29:28.669812
abd10b76-e1cc-425b-93bb-5538e44c07ff	cc44866f-e2fd-4308-8287-7c7a45d46196	HeightUnit	cm	2025-10-26 14:29:28.669551
549f6a3d-e134-4ffd-80c6-9013d4eb5ef8	cc44866f-e2fd-4308-8287-7c7a45d46196	Weight Unit	kg	2025-10-26 14:29:28.669818
e727a1af-b94f-40bf-b471-631542be526a	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	Weight Unit	kg	2025-10-26 20:05:09.490111
01be2698-0301-4468-806f-482161e32347	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	HeightUnit	cm	2025-10-26 20:05:09.489884
89e995fe-b85f-4c89-8edb-58af9350435d	40ff3ae3-6d90-4a79-9845-fb0c787b1f22	Temperature Unit	C	2025-10-26 20:05:09.490108
6962802c-2fdc-4ab4-a678-6d44924d7090	1a3fca64-682d-40c6-95f6-da0f595570c9	Temperature Unit	C	2025-10-27 08:36:04.298818
fd197f5a-374e-4b50-a427-aa5656e1ba17	1a3fca64-682d-40c6-95f6-da0f595570c9	HeightUnit	cm	2025-10-27 08:36:04.298461
f7c9a38c-8369-4f5a-b843-ab76e190ca72	1a3fca64-682d-40c6-95f6-da0f595570c9	Weight Unit	kg	2025-10-27 08:36:04.298823
\.


--
-- Data for Name: unit_dictionary_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unit_dictionary_entries (id, unit_dictionary_id, symbol, unit_name, ordinal, created_at) FROM stdin;
\.


--
-- Name: als_drafts als_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.als_drafts
    ADD CONSTRAINT als_drafts_pkey PRIMARY KEY (id);


--
-- Name: chat_messages chat_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_pkey PRIMARY KEY (id);


--
-- Name: chat_sessions chat_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_sessions
    ADD CONSTRAINT chat_sessions_pkey PRIMARY KEY (id);


--
-- Name: check_actions check_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_actions
    ADD CONSTRAINT check_actions_pkey PRIMARY KEY (id);


--
-- Name: check_steps check_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_steps
    ADD CONSTRAINT check_steps_pkey PRIMARY KEY (id);


--
-- Name: checks checks_als_draft_id_check_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checks
    ADD CONSTRAINT checks_als_draft_id_check_oid_key UNIQUE (als_draft_id, check_oid);


--
-- Name: checks checks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checks
    ADD CONSTRAINT checks_pkey PRIMARY KEY (id);


--
-- Name: coder_configuration coder_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coder_configuration
    ADD CONSTRAINT coder_configuration_pkey PRIMARY KEY (id);


--
-- Name: coder_supplemental_terms coder_supplemental_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coder_supplemental_terms
    ADD CONSTRAINT coder_supplemental_terms_pkey PRIMARY KEY (id);


--
-- Name: crf_drafts crf_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crf_drafts
    ADD CONSTRAINT crf_drafts_pkey PRIMARY KEY (id);


--
-- Name: custom_functions custom_functions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_functions
    ADD CONSTRAINT custom_functions_pkey PRIMARY KEY (id);


--
-- Name: data_dictionaries data_dictionaries_als_draft_id_dictionary_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_dictionaries
    ADD CONSTRAINT data_dictionaries_als_draft_id_dictionary_oid_key UNIQUE (als_draft_id, dictionary_oid);


--
-- Name: data_dictionaries data_dictionaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_dictionaries
    ADD CONSTRAINT data_dictionaries_pkey PRIMARY KEY (id);


--
-- Name: data_dictionary_entries data_dictionary_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_dictionary_entries
    ADD CONSTRAINT data_dictionary_entries_pkey PRIMARY KEY (id);


--
-- Name: derivation_steps derivation_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.derivation_steps
    ADD CONSTRAINT derivation_steps_pkey PRIMARY KEY (id);


--
-- Name: derivations derivations_als_draft_id_derivation_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.derivations
    ADD CONSTRAINT derivations_als_draft_id_derivation_oid_key UNIQUE (als_draft_id, derivation_oid);


--
-- Name: derivations derivations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.derivations
    ADD CONSTRAINT derivations_pkey PRIMARY KEY (id);


--
-- Name: edit_check_marking_groups edit_check_marking_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_check_marking_groups
    ADD CONSTRAINT edit_check_marking_groups_pkey PRIMARY KEY (id);


--
-- Name: edit_check_message_text edit_check_message_text_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_check_message_text
    ADD CONSTRAINT edit_check_message_text_pkey PRIMARY KEY (id);


--
-- Name: edit_check_rules edit_check_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_check_rules
    ADD CONSTRAINT edit_check_rules_pkey PRIMARY KEY (id);


--
-- Name: edit_checks edit_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_checks
    ADD CONSTRAINT edit_checks_pkey PRIMARY KEY (id);


--
-- Name: editcheck_specs editcheck_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editcheck_specs
    ADD CONSTRAINT editcheck_specs_pkey PRIMARY KEY (id);


--
-- Name: email_alerts email_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_alerts
    ADD CONSTRAINT email_alerts_pkey PRIMARY KEY (id);


--
-- Name: folders folders_als_draft_id_folder_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_als_draft_id_folder_oid_key UNIQUE (als_draft_id, folder_oid);


--
-- Name: folders folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- Name: form_fields form_fields_form_id_field_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_fields
    ADD CONSTRAINT form_fields_form_id_field_oid_key UNIQUE (form_id, field_oid);


--
-- Name: form_fields form_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_fields
    ADD CONSTRAINT form_fields_pkey PRIMARY KEY (id);


--
-- Name: generated_functions generated_functions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_functions
    ADD CONSTRAINT generated_functions_pkey PRIMARY KEY (id);


--
-- Name: lab_variable_mappings lab_variable_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_variable_mappings
    ADD CONSTRAINT lab_variable_mappings_pkey PRIMARY KEY (id);


--
-- Name: matrices matrices_als_draft_id_matrix_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matrices
    ADD CONSTRAINT matrices_als_draft_id_matrix_oid_key UNIQUE (als_draft_id, matrix_oid);


--
-- Name: matrices matrices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matrices
    ADD CONSTRAINT matrices_pkey PRIMARY KEY (id);


--
-- Name: matrix_data matrix_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matrix_data
    ADD CONSTRAINT matrix_data_pkey PRIMARY KEY (id);


--
-- Name: __EFMigrationsHistory pk___ef_migrations_history; Type: CONSTRAINT; Schema: public; Owner: postgresuser
--

ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT pk___ef_migrations_history PRIMARY KEY (migration_id);


--
-- Name: studies studies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studies
    ADD CONSTRAINT studies_pkey PRIMARY KEY (id);


--
-- Name: study_forms study_forms_als_draft_id_form_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_forms
    ADD CONSTRAINT study_forms_als_draft_id_form_oid_key UNIQUE (als_draft_id, form_oid);


--
-- Name: study_forms study_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_forms
    ADD CONSTRAINT study_forms_pkey PRIMARY KEY (id);


--
-- Name: test_results test_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_pkey PRIMARY KEY (id);


--
-- Name: unit_dictionaries unit_dictionaries_als_draft_id_dictionary_oid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_dictionaries
    ADD CONSTRAINT unit_dictionaries_als_draft_id_dictionary_oid_key UNIQUE (als_draft_id, dictionary_oid);


--
-- Name: unit_dictionaries unit_dictionaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_dictionaries
    ADD CONSTRAINT unit_dictionaries_pkey PRIMARY KEY (id);


--
-- Name: unit_dictionary_entries unit_dictionary_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_dictionary_entries
    ADD CONSTRAINT unit_dictionary_entries_pkey PRIMARY KEY (id);


--
-- Name: idx_als_drafts_study_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_als_drafts_study_id ON public.als_drafts USING btree (study_id);


--
-- Name: idx_chat_sessions_study_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_sessions_study_id ON public.chat_sessions USING btree (study_id);


--
-- Name: idx_check_actions_check_step_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_check_actions_check_step_id ON public.check_actions USING btree (check_step_id);


--
-- Name: idx_check_steps_check_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_check_steps_check_id ON public.check_steps USING btree (check_id);


--
-- Name: idx_checks_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_checks_als_draft_id ON public.checks USING btree (als_draft_id);


--
-- Name: idx_checks_check_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_checks_check_oid ON public.checks USING btree (check_oid);


--
-- Name: idx_coder_configuration_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coder_configuration_als_draft_id ON public.coder_configuration USING btree (als_draft_id);


--
-- Name: idx_coder_supplemental_terms_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_coder_supplemental_terms_als_draft_id ON public.coder_supplemental_terms USING btree (als_draft_id);


--
-- Name: idx_crf_drafts_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_crf_drafts_als_draft_id ON public.crf_drafts USING btree (als_draft_id);


--
-- Name: idx_custom_functions_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_custom_functions_als_draft_id ON public.custom_functions USING btree (als_draft_id);


--
-- Name: idx_custom_functions_function_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_custom_functions_function_name ON public.custom_functions USING btree (function_name);


--
-- Name: idx_data_dictionaries_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_data_dictionaries_als_draft_id ON public.data_dictionaries USING btree (als_draft_id);


--
-- Name: idx_data_dictionaries_dictionary_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_data_dictionaries_dictionary_oid ON public.data_dictionaries USING btree (dictionary_oid);


--
-- Name: idx_data_dictionary_entries_data_dictionary_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_data_dictionary_entries_data_dictionary_id ON public.data_dictionary_entries USING btree (data_dictionary_id);


--
-- Name: idx_derivation_steps_derivation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_derivation_steps_derivation_id ON public.derivation_steps USING btree (derivation_id);


--
-- Name: idx_derivations_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_derivations_als_draft_id ON public.derivations USING btree (als_draft_id);


--
-- Name: idx_derivations_derivation_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_derivations_derivation_oid ON public.derivations USING btree (derivation_oid);


--
-- Name: idx_edit_check_marking_groups_edit_check_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_check_marking_groups_edit_check_id ON public.edit_check_marking_groups USING btree (edit_check_id);


--
-- Name: idx_edit_check_message_text_edit_check_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_check_message_text_edit_check_id ON public.edit_check_message_text USING btree (edit_check_id);


--
-- Name: idx_edit_check_rules_edit_check_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_check_rules_edit_check_id ON public.edit_check_rules USING btree (edit_check_id);


--
-- Name: idx_edit_checks_domain; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_checks_domain ON public.edit_checks USING btree (edit_check_domain);


--
-- Name: idx_edit_checks_form_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_checks_form_id ON public.edit_checks USING btree (form_id);


--
-- Name: idx_edit_checks_spec_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_checks_spec_id ON public.edit_checks USING btree (spec_id);


--
-- Name: idx_edit_checks_state; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_checks_state ON public.edit_checks USING btree (state);


--
-- Name: idx_edit_checks_study_check_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_checks_study_check_id ON public.edit_checks USING btree (study_check_id);


--
-- Name: idx_edit_checks_study_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_edit_checks_study_id ON public.edit_checks USING btree (study_id);


--
-- Name: idx_folders_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_folders_als_draft_id ON public.folders USING btree (als_draft_id);


--
-- Name: idx_folders_folder_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_folders_folder_oid ON public.folders USING btree (folder_oid);


--
-- Name: idx_form_fields_field_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_form_fields_field_oid ON public.form_fields USING btree (field_oid);


--
-- Name: idx_form_fields_form_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_form_fields_form_id ON public.form_fields USING btree (form_id);


--
-- Name: idx_form_fields_ordinal; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_form_fields_ordinal ON public.form_fields USING btree (ordinal);


--
-- Name: idx_form_fields_variable_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_form_fields_variable_oid ON public.form_fields USING btree (variable_oid);


--
-- Name: idx_generated_functions_study_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_generated_functions_study_id ON public.generated_functions USING btree (study_id);


--
-- Name: idx_lab_variable_mappings_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lab_variable_mappings_als_draft_id ON public.lab_variable_mappings USING btree (als_draft_id);


--
-- Name: idx_matrices_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matrices_als_draft_id ON public.matrices USING btree (als_draft_id);


--
-- Name: idx_matrices_matrix_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matrices_matrix_oid ON public.matrices USING btree (matrix_oid);


--
-- Name: idx_matrix_data_matrix_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_matrix_data_matrix_id ON public.matrix_data USING btree (matrix_id);


--
-- Name: idx_studies_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_studies_name ON public.studies USING btree (name);


--
-- Name: idx_studies_protocol_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_studies_protocol_number ON public.studies USING btree (protocol_number);


--
-- Name: idx_study_forms_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_forms_als_draft_id ON public.study_forms USING btree (als_draft_id);


--
-- Name: idx_study_forms_form_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_forms_form_oid ON public.study_forms USING btree (form_oid);


--
-- Name: idx_study_forms_ordinal; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_study_forms_ordinal ON public.study_forms USING btree (ordinal);


--
-- Name: idx_test_results_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_test_results_assigned_to ON public.test_results USING btree (assigned_to);


--
-- Name: idx_test_results_edit_check_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_test_results_edit_check_id ON public.test_results USING btree (edit_check_id);


--
-- Name: idx_unit_dictionaries_als_draft_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unit_dictionaries_als_draft_id ON public.unit_dictionaries USING btree (als_draft_id);


--
-- Name: idx_unit_dictionaries_dictionary_oid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unit_dictionaries_dictionary_oid ON public.unit_dictionaries USING btree (dictionary_oid);


--
-- Name: idx_unit_dictionary_entries_unit_dictionary_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_unit_dictionary_entries_unit_dictionary_id ON public.unit_dictionary_entries USING btree (unit_dictionary_id);


--
-- Name: als_drafts als_drafts_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.als_drafts
    ADD CONSTRAINT als_drafts_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.studies(id) ON DELETE CASCADE;


--
-- Name: chat_messages chat_messages_editcheck_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_editcheck_spec_id_fkey FOREIGN KEY (editcheck_spec_id) REFERENCES public.editcheck_specs(id);


--
-- Name: chat_messages chat_messages_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_messages
    ADD CONSTRAINT chat_messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.chat_sessions(id);


--
-- Name: chat_sessions chat_sessions_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_sessions
    ADD CONSTRAINT chat_sessions_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.studies(id);


--
-- Name: check_actions check_actions_check_step_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_actions
    ADD CONSTRAINT check_actions_check_step_id_fkey FOREIGN KEY (check_step_id) REFERENCES public.check_steps(id) ON DELETE CASCADE;


--
-- Name: check_steps check_steps_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_steps
    ADD CONSTRAINT check_steps_check_id_fkey FOREIGN KEY (check_id) REFERENCES public.checks(id) ON DELETE CASCADE;


--
-- Name: checks checks_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.checks
    ADD CONSTRAINT checks_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: coder_configuration coder_configuration_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coder_configuration
    ADD CONSTRAINT coder_configuration_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: coder_supplemental_terms coder_supplemental_terms_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coder_supplemental_terms
    ADD CONSTRAINT coder_supplemental_terms_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: crf_drafts crf_drafts_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crf_drafts
    ADD CONSTRAINT crf_drafts_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: data_dictionaries data_dictionaries_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_dictionaries
    ADD CONSTRAINT data_dictionaries_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: data_dictionary_entries data_dictionary_entries_data_dictionary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.data_dictionary_entries
    ADD CONSTRAINT data_dictionary_entries_data_dictionary_id_fkey FOREIGN KEY (data_dictionary_id) REFERENCES public.data_dictionaries(id) ON DELETE CASCADE;


--
-- Name: derivation_steps derivation_steps_derivation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.derivation_steps
    ADD CONSTRAINT derivation_steps_derivation_id_fkey FOREIGN KEY (derivation_id) REFERENCES public.derivations(id) ON DELETE CASCADE;


--
-- Name: derivations derivations_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.derivations
    ADD CONSTRAINT derivations_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: edit_check_marking_groups edit_check_marking_groups_edit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_check_marking_groups
    ADD CONSTRAINT edit_check_marking_groups_edit_check_id_fkey FOREIGN KEY (edit_check_id) REFERENCES public.edit_checks(id) ON DELETE CASCADE;


--
-- Name: edit_check_message_text edit_check_message_text_edit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_check_message_text
    ADD CONSTRAINT edit_check_message_text_edit_check_id_fkey FOREIGN KEY (edit_check_id) REFERENCES public.edit_checks(id) ON DELETE CASCADE;


--
-- Name: edit_check_rules edit_check_rules_edit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_check_rules
    ADD CONSTRAINT edit_check_rules_edit_check_id_fkey FOREIGN KEY (edit_check_id) REFERENCES public.edit_checks(id) ON DELETE CASCADE;


--
-- Name: edit_checks edit_checks_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edit_checks
    ADD CONSTRAINT edit_checks_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.studies(id) ON DELETE CASCADE;


--
-- Name: editcheck_specs editcheck_specs_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editcheck_specs
    ADD CONSTRAINT editcheck_specs_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.studies(id);


--
-- Name: email_alerts email_alerts_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_alerts
    ADD CONSTRAINT email_alerts_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: folders folders_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.folders
    ADD CONSTRAINT folders_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: form_fields form_fields_form_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.form_fields
    ADD CONSTRAINT form_fields_form_id_fkey FOREIGN KEY (form_id) REFERENCES public.study_forms(id) ON DELETE CASCADE;


--
-- Name: generated_functions generated_functions_custom_function_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_functions
    ADD CONSTRAINT generated_functions_custom_function_id_fkey FOREIGN KEY (custom_function_id) REFERENCES public.custom_functions(id);


--
-- Name: generated_functions generated_functions_editcheck_spec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_functions
    ADD CONSTRAINT generated_functions_editcheck_spec_id_fkey FOREIGN KEY (editcheck_spec_id) REFERENCES public.editcheck_specs(id);


--
-- Name: generated_functions generated_functions_study_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.generated_functions
    ADD CONSTRAINT generated_functions_study_id_fkey FOREIGN KEY (study_id) REFERENCES public.studies(id);


--
-- Name: lab_variable_mappings lab_variable_mappings_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_variable_mappings
    ADD CONSTRAINT lab_variable_mappings_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: matrices matrices_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matrices
    ADD CONSTRAINT matrices_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: matrix_data matrix_data_matrix_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matrix_data
    ADD CONSTRAINT matrix_data_matrix_id_fkey FOREIGN KEY (matrix_id) REFERENCES public.matrices(id) ON DELETE CASCADE;


--
-- Name: study_forms study_forms_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_forms
    ADD CONSTRAINT study_forms_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: test_results test_results_edit_check_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_results
    ADD CONSTRAINT test_results_edit_check_id_fkey FOREIGN KEY (edit_check_id) REFERENCES public.edit_checks(id) ON DELETE CASCADE;


--
-- Name: unit_dictionaries unit_dictionaries_als_draft_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_dictionaries
    ADD CONSTRAINT unit_dictionaries_als_draft_id_fkey FOREIGN KEY (als_draft_id) REFERENCES public.als_drafts(id) ON DELETE CASCADE;


--
-- Name: unit_dictionary_entries unit_dictionary_entries_unit_dictionary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_dictionary_entries
    ADD CONSTRAINT unit_dictionary_entries_unit_dictionary_id_fkey FOREIGN KEY (unit_dictionary_id) REFERENCES public.unit_dictionaries(id) ON DELETE CASCADE;


--
-- Name: TABLE als_drafts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.als_drafts TO postgresuser;


--
-- Name: TABLE chat_messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_messages TO postgresuser;


--
-- Name: TABLE chat_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_sessions TO postgresuser;


--
-- Name: TABLE check_actions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.check_actions TO postgresuser;


--
-- Name: TABLE check_steps; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.check_steps TO postgresuser;


--
-- Name: TABLE checks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.checks TO postgresuser;


--
-- Name: TABLE coder_configuration; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coder_configuration TO postgresuser;


--
-- Name: TABLE coder_supplemental_terms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coder_supplemental_terms TO postgresuser;


--
-- Name: TABLE crf_drafts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.crf_drafts TO postgresuser;


--
-- Name: TABLE custom_functions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.custom_functions TO postgresuser;


--
-- Name: TABLE data_dictionaries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.data_dictionaries TO postgresuser;


--
-- Name: TABLE data_dictionary_entries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.data_dictionary_entries TO postgresuser;


--
-- Name: TABLE derivation_steps; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.derivation_steps TO postgresuser;


--
-- Name: TABLE derivations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.derivations TO postgresuser;


--
-- Name: TABLE edit_check_marking_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.edit_check_marking_groups TO postgresuser;


--
-- Name: TABLE edit_check_message_text; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.edit_check_message_text TO postgresuser;


--
-- Name: TABLE edit_check_rules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.edit_check_rules TO postgresuser;


--
-- Name: TABLE edit_checks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.edit_checks TO postgresuser;


--
-- Name: TABLE editcheck_specs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.editcheck_specs TO postgresuser;


--
-- Name: TABLE email_alerts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.email_alerts TO postgresuser;


--
-- Name: TABLE folders; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.folders TO postgresuser;


--
-- Name: TABLE form_fields; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.form_fields TO postgresuser;


--
-- Name: TABLE generated_functions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.generated_functions TO postgresuser;


--
-- Name: TABLE lab_variable_mappings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.lab_variable_mappings TO postgresuser;


--
-- Name: TABLE matrices; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matrices TO postgresuser;


--
-- Name: TABLE matrix_data; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matrix_data TO postgresuser;


--
-- Name: TABLE studies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.studies TO postgresuser;


--
-- Name: TABLE study_forms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.study_forms TO postgresuser;


--
-- Name: TABLE test_results; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.test_results TO postgresuser;


--
-- Name: TABLE unit_dictionaries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.unit_dictionaries TO postgresuser;


--
-- Name: TABLE unit_dictionary_entries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.unit_dictionary_entries TO postgresuser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgresuser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgresuser;


--
-- PostgreSQL database dump complete
--

\unrestrict lIzlRSOjBIvya7MTlWrLknCQ1dACbw4ouL3zBDget9Usqh5rZTDbRTH40MzcGpU

