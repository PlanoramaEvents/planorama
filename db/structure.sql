SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: acceptance_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.acceptance_status_enum AS ENUM (
    'unknown',
    'probable',
    'accepted',
    'declined'
);


--
-- Name: agreement_target; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.agreement_target AS ENUM (
    'none',
    'participant',
    'member',
    'staff',
    'all'
);


--
-- Name: assignment_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.assignment_role_enum AS ENUM (
    'participant',
    'staff'
);


--
-- Name: convention_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.convention_role_enum AS ENUM (
    'admin',
    'staff',
    'participant'
);


--
-- Name: interest_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.interest_role_enum AS ENUM (
    'no_preference',
    'can_moderate',
    'not_moderate'
);


--
-- Name: invite_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.invite_status_enum AS ENUM (
    'not_set',
    'do_not_invite',
    'potential_invite',
    'invite_pending',
    'invited',
    'volunteered'
);


--
-- Name: mail_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mail_status_enum AS ENUM (
    'pending',
    'sent',
    'failed'
);


--
-- Name: mail_use_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mail_use_enum AS ENUM (
    'general',
    'invite',
    'schedule',
    'completed_survey',
    'declined_survey'
);


--
-- Name: mailing_state_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mailing_state_enum AS ENUM (
    'draft',
    'submitted',
    'sent'
);


--
-- Name: next_page_action_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.next_page_action_enum AS ENUM (
    'next_page',
    'submit'
);


--
-- Name: person_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.person_role AS ENUM (
    'admin',
    'planner',
    'member'
);


--
-- Name: person_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.person_status_enum AS ENUM (
    'not_set',
    'applied',
    'vetted',
    'invite_pending',
    'invited',
    'probable',
    'accepted',
    'declined',
    'rejected'
);


--
-- Name: phone_type_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.phone_type_enum AS ENUM (
    'home',
    'mobile',
    'work',
    'fax',
    'other'
);


--
-- Name: submission_state_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.submission_state_enum AS ENUM (
    'draft',
    'submitted'
);


--
-- Name: visibility_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.visibility_enum AS ENUM (
    'private',
    'public'
);


--
-- Name: yesnomaybe_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.yesnomaybe_enum AS ENUM (
    'yes',
    'no',
    'maybe'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.action_permissions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    mdl_name character varying,
    action character varying,
    allowed boolean DEFAULT false,
    person_role_id uuid,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    action_scope character varying
);


--
-- Name: agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.agreements (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title character varying,
    terms text,
    agreement_type character varying,
    created_by_id uuid NOT NULL,
    updated_by_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    target public.agreement_target,
    description character varying(10000) DEFAULT NULL::character varying
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.areas (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    sort_order integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: availabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.availabilities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bios (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    bio text,
    person_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    website text,
    twitter text,
    othersocialmedia text,
    photourl text,
    facebook text,
    linkedin text,
    twitch text,
    youtube text,
    instagram text,
    flickr text,
    reddit text,
    tiktok character varying
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying(191) NOT NULL,
    description character varying,
    target_class character varying(100),
    active boolean DEFAULT true NOT NULL,
    reserved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categorizations (
    id integer NOT NULL,
    category_name_id integer,
    categorized_id integer NOT NULL,
    categorized_type character varying(100) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    category_id uuid NOT NULL
);


--
-- Name: categorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorizations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorizations_id_seq OWNED BY public.categorizations.id;


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configurations (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    parameter character varying(45) NOT NULL,
    parameter_value character varying(150) NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: conflict_exceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conflict_exceptions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    conflict_type character varying,
    affected integer,
    src1 integer,
    src2 integer,
    idx bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    note text
);


--
-- Name: convention_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.convention_roles (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role public.convention_role_enum
);


--
-- Name: email_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_addresses (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying,
    isdefault boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    label character varying,
    person_id uuid,
    is_valid boolean DEFAULT true NOT NULL,
    iscontact boolean DEFAULT false
);


--
-- Name: formats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.formats (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: label_dimensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.label_dimensions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    manufacturer character varying,
    page_size character varying,
    unit character varying,
    orientation character varying,
    across integer,
    down integer,
    label_width double precision,
    label_height double precision,
    left_margin double precision,
    right_margin double precision,
    top_margin double precision,
    bottom_margin double precision,
    vertical_spacing double precision,
    horizontal_spacing double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: magic_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.magic_links (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    token character varying NOT NULL,
    url character varying(10000) DEFAULT NULL::character varying,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: mail_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_histories (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_mailing_assignment_id uuid,
    email_status public.mail_status_enum,
    date_sent timestamp without time zone,
    email character varying,
    content text,
    testrun boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    person_id uuid,
    mailing_id uuid,
    subject character varying
);


--
-- Name: mailings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    testrun boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    last_person_idx integer DEFAULT '-1'::integer,
    include_email boolean DEFAULT true,
    cc_all boolean DEFAULT false,
    mailing_state public.mailing_state_enum DEFAULT 'draft'::public.mailing_state_enum,
    title character varying,
    subject character varying,
    content text,
    survey_id uuid,
    date_sent timestamp without time zone,
    description text,
    sent_by_id uuid,
    transiton_person_status public.person_status_enum
);


--
-- Name: parameter_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parameter_names (
    parameter_name character varying(45) NOT NULL,
    parameter_description character varying(170) NOT NULL,
    parameter_type character varying DEFAULT 'String'::character varying
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    language character varying(5) DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    comments text,
    organization character varying,
    job_title character varying,
    pronouns character varying(100),
    year_of_birth integer,
    gender character varying(100),
    ethnicity character varying(100),
    opted_in boolean DEFAULT false NOT NULL,
    registered boolean DEFAULT false NOT NULL,
    registration_type character varying,
    can_share boolean DEFAULT false NOT NULL,
    registration_number character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    name character varying DEFAULT ''::character varying,
    name_sort_by character varying,
    name_sort_by_confirmed boolean DEFAULT false,
    pseudonym character varying,
    pseudonym_sort_by character varying,
    pseudonym_sort_by_confirmed boolean DEFAULT false,
    published_name character varying GENERATED ALWAYS AS (
CASE
    WHEN (pseudonym IS NOT NULL) THEN pseudonym
    ELSE name
END) STORED,
    published_name_sort_by character varying GENERATED ALWAYS AS (
CASE
    WHEN (pseudonym_sort_by IS NOT NULL) THEN pseudonym_sort_by
    ELSE name_sort_by
END) STORED,
    bio text,
    website character varying,
    twitter character varying,
    othersocialmedia character varying,
    facebook character varying,
    linkedin character varying,
    twitch character varying,
    youtube character varying,
    instagram character varying,
    flickr character varying,
    reddit character varying,
    tiktok character varying,
    can_stream public.yesnomaybe_enum DEFAULT 'no'::public.yesnomaybe_enum,
    can_record public.yesnomaybe_enum DEFAULT 'no'::public.yesnomaybe_enum,
    can_photo public.yesnomaybe_enum DEFAULT 'no'::public.yesnomaybe_enum,
    age_at_convention character varying,
    romantic_sexual_orientation character varying,
    needs_accommodations boolean DEFAULT false,
    accommodations character varying(10000) DEFAULT NULL::character varying,
    willing_to_moderate boolean DEFAULT false,
    moderation_experience character varying(10000) DEFAULT NULL::character varying,
    othered character varying(10000) DEFAULT NULL::character varying,
    indigenous character varying(10000) DEFAULT NULL::character varying,
    black_diaspora character varying(10000) DEFAULT NULL::character varying,
    non_us_centric_perspectives character varying(10000) DEFAULT NULL::character varying,
    demographic_categories character varying,
    do_not_assign_with character varying(10000) DEFAULT NULL::character varying,
    can_stream_exceptions character varying(10000) DEFAULT NULL::character varying,
    can_record_exceptions character varying(10000) DEFAULT NULL::character varying,
    can_photo_exceptions character varying(10000) DEFAULT NULL::character varying,
    is_local boolean DEFAULT false,
    languages_fluent_in character varying(10000) DEFAULT NULL::character varying,
    con_state public.person_status_enum DEFAULT 'not_set'::public.person_status_enum
);


--
-- Name: people_surveys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people_surveys (
    survey_id uuid,
    person_id uuid
);


--
-- Name: person_agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_agreements (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    agreement_id uuid NOT NULL,
    signed boolean DEFAULT false,
    agreed_on timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: person_constraints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_constraints (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    max_items_per_day integer,
    max_items_per_con integer,
    person_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: person_mailing_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_mailing_assignments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    mailing_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: person_role_assocs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_role_assocs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    person_role_id uuid,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: person_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_roles (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    can_access_sensitive_data boolean DEFAULT false
);


--
-- Name: publication_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_dates (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "timestamp" timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    newitems integer DEFAULT 0,
    modifieditems integer DEFAULT 0,
    removeditems integer DEFAULT 0
);


--
-- Name: publication_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_statuses (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    status character varying,
    submit_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: published_session_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.published_session_assignments (
    session_assignment_id uuid NOT NULL,
    published_session_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    session_assignment_role_type_id uuid NOT NULL,
    person_id uuid NOT NULL,
    sort_order integer,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
);


--
-- Name: published_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.published_sessions (
    session_id uuid NOT NULL,
    title character varying,
    duration integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    format_id uuid,
    pub_reference_number integer,
    audience_size integer,
    participant_notes text,
    is_break boolean DEFAULT false,
    description text,
    start_time timestamp without time zone,
    room_id uuid,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
    require_signup boolean DEFAULT false,
    waiting_list_size integer DEFAULT 0
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    venue_id uuid,
    name character varying(490) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    purpose character varying,
    comment text,
    sort_order integer,
    capacity integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: session_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_areas (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    session_id uuid,
    area_id uuid,
    "primary" boolean,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: session_assignment_role_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_assignment_role_type (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    lock_version integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(100) NOT NULL,
    role_type public.assignment_role_enum,
    default_visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
);


--
-- Name: session_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_assignments (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    session_assignment_role_type_id uuid,
    session_id uuid NOT NULL,
    sort_order integer,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
    interested boolean DEFAULT false,
    interest_ranking integer,
    interest_notes text,
    state character varying,
    planner_notes text,
    interest_role public.interest_role_enum DEFAULT 'no_preference'::public.interest_role_enum
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    duration integer,
    minimum_people integer,
    maximum_people integer,
    item_notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    lock_version integer DEFAULT 0,
    format_id uuid,
    pub_reference_number integer,
    audience_size integer,
    participant_notes text,
    is_break boolean DEFAULT false,
    description text,
    title character varying(256),
    start_time timestamp without time zone,
    room_id uuid,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
    publish boolean DEFAULT false NOT NULL,
    require_signup boolean DEFAULT false,
    waiting_list_size integer DEFAULT 0,
    open_for_interest boolean DEFAULT false,
    instructions_for_interest text
);


--
-- Name: survey_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_answers (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    answer text,
    "default" boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    question_id uuid,
    sort_order integer,
    next_page_id uuid,
    other boolean DEFAULT false,
    next_page_action public.next_page_action_enum DEFAULT 'next_page'::public.next_page_action_enum,
    value character varying
);


--
-- Name: survey_formats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_formats (
    id integer NOT NULL,
    help text,
    style character varying DEFAULT ''::character varying,
    description_style character varying DEFAULT ''::character varying,
    answer_style character varying DEFAULT ''::character varying,
    question_style character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    formatable_id integer,
    formatable_type character varying
);


--
-- Name: survey_formats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_formats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_formats_id_seq OWNED BY public.survey_formats.id;


--
-- Name: survey_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_pages (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title character varying,
    next_page_id uuid,
    sort_order integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    survey_id uuid,
    next_page_action public.next_page_action_enum DEFAULT 'next_page'::public.next_page_action_enum
);


--
-- Name: survey_queries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_queries (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    operation character varying,
    survey_id uuid,
    shared boolean,
    user_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    date_order boolean DEFAULT false,
    show_country boolean DEFAULT false
);


--
-- Name: survey_query_predicates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_query_predicates (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    survey_question_id uuid,
    operation character varying,
    value text,
    survey_query_id uuid,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: survey_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_questions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    question text,
    question_type character varying DEFAULT 'textfield'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    mandatory boolean DEFAULT false,
    text_size integer,
    sort_order integer,
    horizontal boolean DEFAULT false,
    private boolean DEFAULT false,
    regex character varying,
    page_id uuid,
    randomize boolean DEFAULT false,
    branching boolean DEFAULT false,
    linked_field text,
    deleted_at timestamp without time zone
);


--
-- Name: survey_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_responses (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    question_id uuid NOT NULL,
    response json,
    response_as_text text,
    submission_id uuid NOT NULL
);


--
-- Name: survey_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_submissions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    survey_id uuid NOT NULL,
    person_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    submission_state public.submission_state_enum DEFAULT 'draft'::public.submission_state_enum
);


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.surveys (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    name character varying,
    welcome text,
    thank_you text,
    submit_string character varying DEFAULT 'Save'::character varying,
    use_captcha boolean DEFAULT false,
    public boolean,
    declined_msg text,
    authenticate_msg text,
    anonymous boolean DEFAULT false,
    published_on timestamp without time zone,
    published_by_id uuid,
    created_by_id uuid,
    updated_by_id uuid,
    description text,
    mandatory_star boolean DEFAULT true,
    numbered_questions boolean DEFAULT false,
    branded boolean DEFAULT true,
    allow_submission_edits boolean DEFAULT true,
    transition_accept_status public.person_status_enum,
    transition_decline_status public.person_status_enum
);


--
-- Name: tag_contexts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_contexts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    publish boolean DEFAULT true
);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    tag_id uuid,
    taggable_id uuid,
    tagger_id uuid,
    tagger_type character varying(191),
    taggable_type character varying(191),
    context character varying(191),
    created_at timestamp without time zone
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying(191),
    taggings_count integer DEFAULT 0
);


--
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venues (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    sort_order integer
);


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: categorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations ALTER COLUMN id SET DEFAULT nextval('public.categorizations_id_seq'::regclass);


--
-- Name: survey_formats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_formats ALTER COLUMN id SET DEFAULT nextval('public.survey_formats_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: action_permissions action_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_permissions
    ADD CONSTRAINT action_permissions_pkey PRIMARY KEY (id);


--
-- Name: agreements agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agreements
    ADD CONSTRAINT agreements_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: availabilities availabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.availabilities
    ADD CONSTRAINT availabilities_pkey PRIMARY KEY (id);


--
-- Name: bios bios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bios
    ADD CONSTRAINT bios_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categorizations categorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations
    ADD CONSTRAINT categorizations_pkey PRIMARY KEY (id);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: conflict_exceptions conflict_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conflict_exceptions
    ADD CONSTRAINT conflict_exceptions_pkey PRIMARY KEY (id);


--
-- Name: convention_roles convention_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.convention_roles
    ADD CONSTRAINT convention_roles_pkey PRIMARY KEY (id);


--
-- Name: email_addresses email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses
    ADD CONSTRAINT email_addresses_pkey PRIMARY KEY (id);


--
-- Name: formats formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.formats
    ADD CONSTRAINT formats_pkey PRIMARY KEY (id);


--
-- Name: label_dimensions label_dimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_dimensions
    ADD CONSTRAINT label_dimensions_pkey PRIMARY KEY (id);


--
-- Name: magic_links magic_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magic_links
    ADD CONSTRAINT magic_links_pkey PRIMARY KEY (id);


--
-- Name: mail_histories mail_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_histories
    ADD CONSTRAINT mail_histories_pkey PRIMARY KEY (id);


--
-- Name: mailings mailings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings
    ADD CONSTRAINT mailings_pkey PRIMARY KEY (id);


--
-- Name: parameter_names parameter_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_names
    ADD CONSTRAINT parameter_names_pkey PRIMARY KEY (parameter_name);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: person_agreements person_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_agreements
    ADD CONSTRAINT person_agreements_pkey PRIMARY KEY (id);


--
-- Name: person_constraints person_constraints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_constraints
    ADD CONSTRAINT person_constraints_pkey PRIMARY KEY (id);


--
-- Name: person_mailing_assignments person_mailing_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_mailing_assignments
    ADD CONSTRAINT person_mailing_assignments_pkey PRIMARY KEY (id);


--
-- Name: person_role_assocs person_role_assocs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_role_assocs
    ADD CONSTRAINT person_role_assocs_pkey PRIMARY KEY (id);


--
-- Name: person_roles person_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_pkey PRIMARY KEY (id);


--
-- Name: session_assignment_role_type programme_assignment_role_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_assignment_role_type
    ADD CONSTRAINT programme_assignment_role_type_pkey PRIMARY KEY (id);


--
-- Name: session_assignments programme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_assignments
    ADD CONSTRAINT programme_assignments_pkey PRIMARY KEY (id);


--
-- Name: sessions programme_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT programme_items_pkey PRIMARY KEY (id);


--
-- Name: publication_dates publication_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_dates
    ADD CONSTRAINT publication_dates_pkey PRIMARY KEY (id);


--
-- Name: publication_statuses publication_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_statuses
    ADD CONSTRAINT publication_statuses_pkey PRIMARY KEY (id);


--
-- Name: published_session_assignments published_programme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.published_session_assignments
    ADD CONSTRAINT published_programme_assignments_pkey PRIMARY KEY (session_assignment_id);


--
-- Name: published_sessions published_programme_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.published_sessions
    ADD CONSTRAINT published_programme_items_pkey PRIMARY KEY (session_id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: session_areas session_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_areas
    ADD CONSTRAINT session_areas_pkey PRIMARY KEY (id);


--
-- Name: survey_answers survey_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_answers
    ADD CONSTRAINT survey_answers_pkey PRIMARY KEY (id);


--
-- Name: survey_formats survey_formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_formats
    ADD CONSTRAINT survey_formats_pkey PRIMARY KEY (id);


--
-- Name: survey_pages survey_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_pages
    ADD CONSTRAINT survey_pages_pkey PRIMARY KEY (id);


--
-- Name: survey_queries survey_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_queries
    ADD CONSTRAINT survey_queries_pkey PRIMARY KEY (id);


--
-- Name: survey_query_predicates survey_query_predicates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_query_predicates
    ADD CONSTRAINT survey_query_predicates_pkey PRIMARY KEY (id);


--
-- Name: survey_questions survey_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT survey_questions_pkey PRIMARY KEY (id);


--
-- Name: survey_responses survey_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT survey_responses_pkey PRIMARY KEY (id);


--
-- Name: survey_submissions survey_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_submissions
    ADD CONSTRAINT survey_submissions_pkey PRIMARY KEY (id);


--
-- Name: surveys surveys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);


--
-- Name: tag_contexts tag_contexts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_contexts
    ADD CONSTRAINT tag_contexts_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: venues venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: by_active_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_active_status ON public.categories USING btree (active);


--
-- Name: by_categorized; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_categorized ON public.categorizations USING btree (categorized_id, categorized_type);


--
-- Name: by_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_category ON public.categorizations USING btree (category_id);


--
-- Name: by_conference_categorized_and_category; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX by_conference_categorized_and_category ON public.categorizations USING btree (category_id, categorized_id, categorized_type);


--
-- Name: by_name_and_target_class; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX by_name_and_target_class ON public.categories USING btree (name, target_class);


--
-- Name: by_reserved_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX by_reserved_status ON public.categories USING btree (reserved);


--
-- Name: fk_configurations_parameters_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk_configurations_parameters_idx ON public.configurations USING btree (parameter);


--
-- Name: fl_configurations_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX fl_configurations_unique_index ON public.configurations USING btree (parameter);


--
-- Name: index_action_permissions_on_mdl_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_action_permissions_on_mdl_name ON public.action_permissions USING btree (mdl_name);


--
-- Name: index_agreements_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_created_by_id ON public.agreements USING btree (created_by_id);


--
-- Name: index_agreements_on_target; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_target ON public.agreements USING btree (target);


--
-- Name: index_agreements_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agreements_on_updated_by_id ON public.agreements USING btree (updated_by_id);


--
-- Name: index_areas_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_areas_on_name ON public.areas USING btree (name);


--
-- Name: index_convention_roles_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_convention_roles_on_person_id ON public.convention_roles USING btree (person_id);


--
-- Name: index_magic_links_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_magic_links_on_person_id ON public.magic_links USING btree (person_id);


--
-- Name: index_mailings_on_mailing_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailings_on_mailing_state ON public.mailings USING btree (mailing_state);


--
-- Name: index_people_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_confirmation_token ON public.people USING btree (confirmation_token);


--
-- Name: index_people_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_reset_password_token ON public.people USING btree (reset_password_token);


--
-- Name: index_people_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_unlock_token ON public.people USING btree (unlock_token);


--
-- Name: index_people_surveys_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_surveys_on_person_id ON public.people_surveys USING btree (person_id);


--
-- Name: index_people_surveys_on_survey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_surveys_on_survey_id ON public.people_surveys USING btree (survey_id);


--
-- Name: index_people_surveys_on_survey_id_and_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_surveys_on_survey_id_and_person_id ON public.people_surveys USING btree (survey_id, person_id);


--
-- Name: index_person_agreements_on_agreement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_agreements_on_agreement_id ON public.person_agreements USING btree (agreement_id);


--
-- Name: index_person_agreements_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_agreements_on_person_id ON public.person_agreements USING btree (person_id);


--
-- Name: index_person_agreements_on_person_id_and_agreement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_person_agreements_on_person_id_and_agreement_id ON public.person_agreements USING btree (person_id, agreement_id);


--
-- Name: index_person_mailing_assignments_on_mailing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_mailing_assignments_on_mailing_id ON public.person_mailing_assignments USING btree (mailing_id);


--
-- Name: index_person_mailing_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_mailing_assignments_on_person_id ON public.person_mailing_assignments USING btree (person_id);


--
-- Name: index_person_role_assocs_on_person_id_and_person_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_person_role_assocs_on_person_id_and_person_role_id ON public.person_role_assocs USING btree (person_id, person_role_id);


--
-- Name: index_published_programme_item_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_published_programme_item_assignments_on_person_id ON public.published_session_assignments USING btree (person_id);


--
-- Name: index_published_sessions_on_format_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_published_sessions_on_format_id ON public.published_sessions USING btree (format_id);


--
-- Name: index_session_areas_on_session_id_and_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_session_areas_on_session_id_and_area_id ON public.session_areas USING btree (session_id, area_id);


--
-- Name: index_session_assignments_on_interest_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_assignments_on_interest_role ON public.session_assignments USING btree (interest_role);


--
-- Name: index_survey_answers_on_next_page_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_answers_on_next_page_action ON public.survey_answers USING btree (next_page_action);


--
-- Name: index_survey_pages_on_next_page_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_pages_on_next_page_action ON public.survey_pages USING btree (next_page_action);


--
-- Name: index_survey_pages_on_survey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_pages_on_survey_id ON public.survey_pages USING btree (survey_id);


--
-- Name: index_survey_questions_on_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_questions_on_page_id ON public.survey_questions USING btree (page_id);


--
-- Name: index_survey_responses_on_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_responses_on_submission_id ON public.survey_responses USING btree (submission_id);


--
-- Name: index_survey_submissions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_submissions_on_person_id ON public.survey_submissions USING btree (person_id);


--
-- Name: index_survey_submissions_on_submission_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_submissions_on_submission_state ON public.survey_submissions USING btree (submission_state);


--
-- Name: index_survey_submissions_on_survey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_submissions_on_survey_id ON public.survey_submissions USING btree (survey_id);


--
-- Name: index_taggings_on_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_context ON public.taggings USING btree (context);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id ON public.taggings USING btree (taggable_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type ON public.taggings USING btree (taggable_id, taggable_type);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_taggings_on_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_type ON public.taggings USING btree (taggable_type);


--
-- Name: index_taggings_on_tagger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id ON public.taggings USING btree (tagger_id);


--
-- Name: index_taggings_on_tagger_id_and_tagger_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tagger_id_and_tagger_type ON public.taggings USING btree (tagger_id, tagger_type);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON public.versions USING btree (item_type, item_id);


--
-- Name: pia_person_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pia_person_index ON public.session_assignments USING btree (person_id);


--
-- Name: pis_prog_item_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pis_prog_item_id_index ON public.session_assignments USING btree (session_id);


--
-- Name: pub_progitem_assignment_item_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pub_progitem_assignment_item_index ON public.published_session_assignments USING btree (published_session_id);


--
-- Name: pub_progitem_assignment_person_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pub_progitem_assignment_person_index ON public.published_session_assignments USING btree (person_id);


--
-- Name: survey_resp_question_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX survey_resp_question_idx ON public.survey_responses USING btree (question_id);


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: taggings_idy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_idy ON public.taggings USING btree (taggable_id, taggable_type, tagger_id, context);


--
-- Name: taggings_taggable_context_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX taggings_taggable_context_idx ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: categorizations fk_categorization_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations
    ADD CONSTRAINT fk_categorization_category FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: configurations fk_configurations_parameters; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT fk_configurations_parameters FOREIGN KEY (parameter) REFERENCES public.parameter_names(parameter_name);


--
-- Name: survey_questions fk_rails_35518ef583; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_questions
    ADD CONSTRAINT fk_rails_35518ef583 FOREIGN KEY (page_id) REFERENCES public.survey_pages(id);


--
-- Name: survey_submissions fk_rails_422004fc2f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_submissions
    ADD CONSTRAINT fk_rails_422004fc2f FOREIGN KEY (survey_id) REFERENCES public.surveys(id);


--
-- Name: survey_responses fk_rails_7fc628646e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT fk_rails_7fc628646e FOREIGN KEY (submission_id) REFERENCES public.survey_submissions(id);


--
-- Name: survey_pages fk_rails_c9027d3929; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_pages
    ADD CONSTRAINT fk_rails_c9027d3929 FOREIGN KEY (survey_id) REFERENCES public.surveys(id);


--
-- Name: survey_submissions fk_rails_cca09747da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_submissions
    ADD CONSTRAINT fk_rails_cca09747da FOREIGN KEY (person_id) REFERENCES public.people(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('0'),
('20201226195957'),
('20201226195958'),
('20201226195959'),
('20201229161025'),
('20210123191007'),
('20210320194037'),
('20210321205326'),
('20210321211745'),
('20210522203951'),
('20210606194530'),
('20210606194812'),
('20210607020926'),
('20210611132550'),
('20210613201100'),
('20210613204940'),
('20210615132509'),
('20210619225332'),
('20210620011503'),
('20210620175724'),
('20210620180746'),
('20210626162611'),
('20210627225348'),
('20210628221900'),
('20210629220733'),
('20210702202436'),
('20210702202533'),
('20210703145543'),
('20210703151749'),
('20210703182948'),
('20210704135126'),
('20210704203655'),
('20210704203704'),
('20210707121120'),
('20210711150608'),
('20210712134642'),
('20210716142413'),
('20210717191036'),
('20210819204542'),
('20210925131929'),
('20211101160001'),
('20211101195536'),
('20211103212755'),
('20211105155118'),
('20211114155546'),
('20211114191042'),
('20211207192534'),
('20211207192624'),
('20211213180751'),
('20220109171844'),
('20220119205413'),
('20220120202502'),
('20220123161611'),
('20220123162740'),
('20220124181524'),
('20220127213449'),
('20220131184003'),
('20220201191402'),
('20220202144414'),
('20220208222821'),
('20220209153904'),
('20220213221552'),
('20220217233651'),
('20220301184226'),
('20220301221956'),
('20220303154559'),
('20220303175111'),
('20220303175113'),
('20220303175135'),
('20220309183902'),
('20220312172347'),
('20220316150515'),
('20220317222958'),
('20220320194817'),
('20220320225237'),
('20220321144540'),
('20220326140959');


