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
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


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
    'wait_list',
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
-- Name: reg_match_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.reg_match_enum AS ENUM (
    'none',
    'automatic',
    'assisted',
    'manual',
    'self'
);


--
-- Name: schedule_approval_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.schedule_approval_enum AS ENUM (
    'not_set',
    'yes',
    'no'
);


--
-- Name: schedule_workflow_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.schedule_workflow_enum AS ENUM (
    'not_set',
    'draft',
    'firm'
);


--
-- Name: session_environments_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.session_environments_enum AS ENUM (
    'unknown',
    'in_person',
    'hybrid',
    'virtual'
);


--
-- Name: session_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.session_status_enum AS ENUM (
    'draft',
    'reviewed',
    'revised',
    'dropped'
);


--
-- Name: snapshot_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.snapshot_status_enum AS ENUM (
    'not_set',
    'in_progress',
    'done',
    'failed'
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
-- Name: age_restrictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.age_restrictions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying(500),
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: application_role_assocs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_role_assocs (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    application_role_id uuid,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: application_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_roles (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL,
    sensitive_access boolean DEFAULT false,
    lock_version integer DEFAULT 0,
    con_roles text[] DEFAULT '{}'::text[]
);


--
-- Name: application_roles_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_roles_people (
    application_role_id uuid,
    person_id uuid
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
-- Name: audit_people_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_people_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    created_at timestamp without time zone,
    object_changes json
);


--
-- Name: audit_people_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_people_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_people_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_people_versions_id_seq OWNED BY public.audit_people_versions.id;


--
-- Name: audit_published_session_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_published_session_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    created_at timestamp without time zone,
    object_changes json
);


--
-- Name: audit_published_session_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_published_session_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_published_session_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_published_session_versions_id_seq OWNED BY public.audit_published_session_versions.id;


--
-- Name: audit_session_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_session_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    created_at timestamp without time zone,
    object_changes json
);


--
-- Name: audit_session_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_session_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_session_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_session_versions_id_seq OWNED BY public.audit_session_versions.id;


--
-- Name: audit_survey_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_survey_versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object json,
    created_at timestamp without time zone,
    object_changes json
);


--
-- Name: audit_survey_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_survey_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_survey_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_survey_versions_id_seq OWNED BY public.audit_survey_versions.id;


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
    pronouns character varying(400),
    year_of_birth integer,
    gender character varying(400),
    ethnicity character varying(400),
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
    con_state public.person_status_enum DEFAULT 'not_set'::public.person_status_enum,
    attendance_type character varying(200) DEFAULT NULL::character varying,
    twelve_hour boolean DEFAULT true,
    timezone character varying(500) DEFAULT NULL::character varying,
    availability_notes character varying,
    integrations jsonb DEFAULT '{}'::jsonb NOT NULL,
    date_reg_synced timestamp without time zone,
    reg_id character varying,
    excluded_demographic_categories character varying,
    global_diaspora character varying,
    non_anglophone character varying,
    fediverse character varying,
    bsky character varying,
    reg_attending_status character varying,
    reg_match public.reg_match_enum DEFAULT 'none'::public.reg_match_enum
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
    default_visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
    sort_order integer
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
    instructions_for_interest text,
    updated_by character varying,
    interest_opened_by character varying,
    interest_opened_at timestamp without time zone,
    proofed boolean DEFAULT false NOT NULL,
    status public.session_status_enum DEFAULT 'draft'::public.session_status_enum,
    environment public.session_environments_enum DEFAULT 'unknown'::public.session_environments_enum,
    tech_notes text,
    age_restriction_id uuid,
    minors_participation jsonb,
    room_set_id uuid,
    room_notes text,
    recorded boolean DEFAULT false NOT NULL,
    streamed boolean DEFAULT false NOT NULL,
    short_title character varying(30) DEFAULT NULL::character varying
);


--
-- Name: availability_conflicts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.availability_conflicts AS
 SELECT DISTINCT concat(session_assignments.id, ':', people.id, ':', sessions.id) AS id,
    session_assignments.id AS session_assignment_id,
    people.id AS person_id,
    people.name AS person_name,
    people.published_name AS person_published_name,
    sessions.id AS session_id,
    sessions.title AS session_title,
    sessions.start_time AS session_start_time,
    sessions.room_id AS session_room_id,
    sessions.duration AS session_duration,
    session_assignments.session_assignment_role_type_id,
    sart.role_type AS session_assignment_role_type,
    sart.name AS session_assignment_name
   FROM ((((public.session_assignments
     JOIN public.sessions ON ((sessions.id = session_assignments.session_id)))
     JOIN public.people ON ((people.id = session_assignments.person_id)))
     JOIN public.availabilities ON ((availabilities.person_id = people.id)))
     JOIN public.session_assignment_role_type sart ON ((sart.id = session_assignments.session_assignment_role_type_id)))
  WHERE ((session_assignments.person_id = availabilities.person_id) AND (session_assignments.session_assignment_role_type_id IS NOT NULL) AND (sessions.start_time IS NOT NULL) AND (sessions.room_id IS NOT NULL) AND (NOT (session_assignments.id IN ( SELECT session_assignments_1.id
           FROM (((public.session_assignments session_assignments_1
             JOIN public.sessions sessions_1 ON ((sessions_1.id = session_assignments_1.session_id)))
             JOIN public.people people_1 ON ((people_1.id = session_assignments_1.person_id)))
             JOIN public.availabilities availabilities_1 ON ((availabilities_1.person_id = people_1.id)))
          WHERE ((session_assignments_1.person_id = availabilities_1.person_id) AND (session_assignments_1.session_assignment_role_type_id IS NOT NULL) AND ((sessions_1.start_time >= availabilities_1.start_time) AND ((sessions_1.start_time + ((sessions_1.duration || ' minute'::text))::interval) <= availabilities_1.end_time)))))));


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
    parameter_value character varying(150),
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    lock_version integer DEFAULT 0,
    parameter_json jsonb,
    CONSTRAINT param_exists CHECK (((parameter_json IS NOT NULL) OR (parameter_value IS NOT NULL)))
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
-- Name: curated_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.curated_tags (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying(190),
    context character varying(190),
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: dismissed_reg_sync_matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dismissed_reg_sync_matches (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    reg_id character varying NOT NULL,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: exclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exclusions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title character varying(800) NOT NULL,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: exclusions_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exclusions_sessions (
    exclusion_id uuid,
    session_id uuid
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
-- Name: ignored_conflicts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ignored_conflicts (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    conflict_id character varying(2048),
    conflict_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: integration_publishes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integration_publishes (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    integration_name character varying,
    data jsonb DEFAULT '{}'::jsonb NOT NULL,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    created_by character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.integrations (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: job_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_statuses (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    status character varying,
    submit_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    type character varying,
    result jsonb
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
-- Name: model_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.model_permissions (
    mdl_name character varying NOT NULL,
    application_role_id uuid NOT NULL,
    actions jsonb,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: oauth_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_identities (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    provider character varying,
    person_id uuid,
    reg_id character varying,
    reg_number character varying,
    email character varying,
    raw_info jsonb DEFAULT '{}'::jsonb NOT NULL,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: old_passwords; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.old_passwords (
    id bigint NOT NULL,
    encrypted_password character varying NOT NULL,
    password_archivable_type character varying NOT NULL,
    password_archivable_id integer NOT NULL,
    password_salt character varying,
    created_at timestamp without time zone
);


--
-- Name: old_passwords_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.old_passwords_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_passwords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.old_passwords_id_seq OWNED BY public.old_passwords.id;


--
-- Name: page_contents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.page_contents (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    html text NOT NULL,
    name character varying NOT NULL,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: person_exclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_exclusions (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    exclusion_id uuid,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: person_and_exclusions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_and_exclusions AS
 SELECT pe.exclusion_id,
    pe.person_id,
    s.id AS session_id,
    s.start_time,
    (s.start_time + ((s.duration || ' minute'::text))::interval) AS end_time,
    s.title
   FROM ((public.person_exclusions pe
     LEFT JOIN public.exclusions_sessions es ON ((es.exclusion_id = pe.exclusion_id)))
     LEFT JOIN public.sessions s ON ((s.id = es.session_id)))
  WHERE (es.session_id IS NOT NULL)
  ORDER BY pe.person_id, s.id;


--
-- Name: person_schedules; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_schedules AS
 SELECT concat(p.id, ':', sa.id) AS id,
    p.id AS person_id,
    p.name,
    p.published_name,
    p.con_state,
    p.can_share,
    p.pronouns,
    sa.id AS session_assignment_id,
    sart.id AS session_assignment_role_type_id,
    sart.name AS session_assignment_name,
    sart.role_type AS session_assignment_role_type,
    sa.sort_order,
    sessions.id AS session_id,
    sessions.title,
    sessions.start_time,
    (sessions.start_time + ((sessions.duration || ' minute'::text))::interval) AS end_time,
    sessions.duration,
    sessions.room_id,
    sessions.format_id,
    sessions.participant_notes,
    sessions.description,
    sessions.environment,
    sessions.status,
    sessions.streamed,
    sessions.recorded,
        CASE
            WHEN (sa.updated_at > sessions.updated_at) THEN sa.updated_at
            ELSE sessions.updated_at
        END AS updated_at
   FROM (((public.session_assignments sa
     JOIN public.session_assignment_role_type sart ON (((sart.id = sa.session_assignment_role_type_id) AND (sart.role_type = 'participant'::public.assignment_role_enum) AND ((sart.name)::text <> 'Reserve'::text))))
     JOIN public.people p ON ((p.id = sa.person_id)))
     LEFT JOIN public.sessions ON ((sessions.id = sa.session_id)))
  WHERE ((sa.session_assignment_role_type_id IS NOT NULL) AND (sessions.room_id IS NOT NULL) AND (sessions.start_time IS NOT NULL) AND ((sa.state)::text <> 'rejected'::text));


--
-- Name: person_back_to_back; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_back_to_back AS
 SELECT concat(ps1.person_id, ':', ps1.session_id, ':', ps2.session_id) AS id,
    ps1.person_id,
    ps1.name,
    ps1.published_name,
    ps1.con_state,
    ps2.start_time AS conflict_start_time,
    ps1.session_id,
    ps1.title,
    ps1.start_time,
    ps1.end_time,
    ps1.duration,
    ps1.session_assignment_id,
    ps1.session_assignment_role_type_id,
    ps1.session_assignment_name,
    ps1.session_assignment_role_type,
    ps1.room_id,
    ps2.session_id AS conflict_session_id,
    ps2.title AS conflict_session_title,
    ps2.end_time AS conflict_end_time,
    ps2.duration AS conflict_duration,
    ps2.session_assignment_role_type_id AS conflict_session_assignment_role_type_id,
    ps2.session_assignment_role_type AS conflict_session_assignment_role_type,
    ps2.session_assignment_name AS conflict_session_assignment_name,
    ps2.room_id AS conflict_room_id
   FROM (public.person_schedules ps1
     JOIN public.person_schedules ps2 ON (((ps2.person_id = ps1.person_id) AND (ps2.session_id <> ps1.session_id))))
  WHERE ((ps2.start_time >= ps1.end_time) AND (ps2.start_time <= (ps1.end_time + ((40 || ' minute'::text))::interval)));


--
-- Name: person_back_to_back_to_back; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_back_to_back_to_back AS
 SELECT concat(psc1.person_id, ':', psc1.session_id, ':', psc2.session_id, ':', psc2.conflict_session_id) AS id,
    psc1.person_id,
    psc1.name,
    psc1.published_name,
    psc1.con_state,
    psc1.session_id,
    psc1.title,
    psc1.start_time,
    psc1.end_time,
    psc1.duration,
    psc1.session_assignment_id,
    psc1.session_assignment_role_type_id,
    psc1.session_assignment_name,
    psc1.session_assignment_role_type,
    psc1.room_id,
    psc1.id AS b2b_id,
    psc2.session_id AS middle_session_id,
    psc2.title AS middle_title,
    psc2.start_time AS middle_start_time,
    psc2.end_time AS middle_end_time,
    psc2.duration AS middle_duration,
    psc2.session_assignment_id AS middle_session_assignment_id,
    psc2.session_assignment_role_type_id AS middle_session_assignment_role_type_id,
    psc2.session_assignment_name AS middle_session_assignment_name,
    psc2.session_assignment_role_type AS middle_session_assignment_role_type,
    psc2.room_id AS middle_room_id,
    psc2.conflict_session_id,
    psc2.conflict_session_title,
    psc2.conflict_start_time,
    psc2.conflict_end_time,
    psc2.conflict_duration,
    psc2.conflict_session_assignment_role_type_id,
    psc2.conflict_session_assignment_role_type,
    psc2.conflict_session_assignment_name,
    psc2.conflict_room_id,
    psc2.id AS conflict_b2b_id
   FROM (public.person_back_to_back psc1
     JOIN public.person_back_to_back psc2 ON (((psc2.session_id = psc1.conflict_session_id) AND (psc2.person_id = psc1.person_id))));


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
-- Name: person_exclusion_conflicts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_exclusion_conflicts AS
 SELECT concat(person_schedules.person_id, ':', es.exclusion_id, ':', person_schedules.session_id) AS id,
    person_schedules.person_id,
    person_schedules.name,
    person_schedules.published_name,
    person_schedules.con_state,
    es.exclusion_id,
    es.session_id AS excluded_session_id,
    s.title AS excluded_session_title,
    person_schedules.session_id,
    person_schedules.title,
    person_schedules.start_time,
    person_schedules.end_time,
    person_schedules.room_id,
    person_schedules.duration,
    person_schedules.session_assignment_role_type_id,
    person_schedules.session_assignment_id,
    person_schedules.session_assignment_name,
    person_schedules.session_assignment_role_type
   FROM (((public.person_schedules
     LEFT JOIN public.person_exclusions pe ON ((pe.person_id = person_schedules.person_id)))
     JOIN public.exclusions_sessions es ON ((es.exclusion_id = pe.exclusion_id)))
     LEFT JOIN public.sessions s ON ((s.id = es.session_id)))
  WHERE ((person_schedules.session_id <> s.id) AND (((person_schedules.start_time >= s.start_time) AND (person_schedules.start_time < (s.start_time + ((s.duration || ' minute'::text))::interval))) OR ((person_schedules.end_time > s.start_time) AND (person_schedules.end_time <= (s.start_time + ((s.duration || ' minute'::text))::interval)))));


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
-- Name: person_schedule_approvals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_schedule_approvals (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    schedule_workflow_id uuid,
    comments text,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    approved public.schedule_approval_enum DEFAULT 'not_set'::public.schedule_approval_enum
);


--
-- Name: person_schedule_conflicts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.person_schedule_conflicts AS
 SELECT concat(ps1.person_id, ':', ps1.session_id, ':', ps2.session_id) AS id,
    ps1.person_id,
    ps1.name,
    ps1.published_name,
    ps1.con_state,
    GREATEST(ps1.start_time, ps2.start_time) AS conflict_start_time,
    ps1.session_id,
    ps1.title,
    ps1.start_time,
    ps1.end_time,
    ps1.duration,
    ps1.session_assignment_id,
    ps1.session_assignment_role_type_id,
    ps1.session_assignment_name,
    ps1.session_assignment_role_type,
    ps1.room_id,
    ps2.session_id AS conflict_session_id,
    ps2.title AS conflict_session_title,
    ps2.end_time AS conflict_end_time,
    ps2.duration AS conflict_duration,
    ps2.session_assignment_role_type_id AS conflict_session_assignment_role_type_id,
    ps2.session_assignment_role_type AS conflict_session_assignment_role_type,
    ps2.session_assignment_name AS conflict_session_assignment_name,
    ps2.room_id AS conflict_room_id
   FROM (public.person_schedules ps1
     JOIN public.person_schedules ps2 ON (((ps2.person_id = ps1.person_id) AND (ps2.session_id <> ps1.session_id) AND (ps2.start_time >= ps1.start_time) AND ((ps2.start_time < ps1.end_time) OR ((ps2.end_time > ps1.start_time) AND (ps2.end_time <= ps1.end_time))))));


--
-- Name: person_schedule_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_schedule_snapshots (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    schedule_snapshot_id uuid,
    snapshot jsonb,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: publication_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_dates (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "timestamp" timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    new_sessions integer DEFAULT 0,
    updated_sessions integer DEFAULT 0,
    dropped_sessions integer DEFAULT 0,
    new_assignments integer DEFAULT 0,
    updated_assignments integer DEFAULT 0,
    dropped_assignments integer DEFAULT 0,
    sent_external boolean DEFAULT false NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: publish_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publish_snapshots (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    publication_date_id uuid,
    label character varying,
    snapshot jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
    integrations jsonb DEFAULT '{}'::jsonb NOT NULL
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
    waiting_list_size integer DEFAULT 0,
    environment public.session_environments_enum DEFAULT 'unknown'::public.session_environments_enum,
    minors_participation jsonb,
    recorded boolean DEFAULT false NOT NULL,
    streamed boolean DEFAULT false NOT NULL,
    integrations jsonb DEFAULT '{}'::jsonb NOT NULL,
    short_title character varying(30) DEFAULT NULL::character varying
);


--
-- Name: registration_sync_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.registration_sync_data (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    reg_id character varying,
    registration_number character varying,
    name character varying,
    email character varying,
    preferred_name character varying,
    alternative_email character varying,
    raw_info jsonb DEFAULT '{}'::jsonb NOT NULL,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    badge_name character varying
);


--
-- Name: registration_sync_matches; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.registration_sync_matches AS
 SELECT p.name,
    NULL::character varying AS email,
    p.id AS pid,
    rsd.reg_id,
    rsd.id AS rid,
    'name'::text AS mtype
   FROM (public.people p
     JOIN public.registration_sync_data rsd ON ((((rsd.name)::text ~~* (p.name)::text) OR ((rsd.preferred_name)::text ~~* (p.name)::text) OR ((rsd.badge_name)::text ~~* (p.name)::text) OR ((rsd.name)::text ~~* (p.pseudonym)::text) OR ((rsd.preferred_name)::text ~~* (p.pseudonym)::text) OR ((rsd.badge_name)::text ~~* (p.pseudonym)::text))))
UNION
 SELECT NULL::character varying AS name,
    e.email,
    e.person_id AS pid,
    rsd.reg_id,
    rsd.id AS rid,
    'email'::text AS mtype
   FROM (public.email_addresses e
     JOIN public.registration_sync_data rsd ON ((((rsd.email)::text ~~* (e.email)::text) OR ((rsd.alternative_email)::text ~~* (e.email)::text))))
  WHERE (e.isdefault = true)
  WITH NO DATA;


--
-- Name: registration_map_counts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.registration_map_counts AS
 SELECT rsm.reg_id,
    rsm.pid,
    count(rsm.pid) AS sub_count
   FROM public.registration_sync_matches rsm
  WHERE ((NOT (rsm.pid IN ( SELECT dismissed_reg_sync_matches.person_id
           FROM public.dismissed_reg_sync_matches))) AND (NOT ((rsm.reg_id)::text IN ( SELECT dismissed_reg_sync_matches.reg_id
           FROM public.dismissed_reg_sync_matches))))
  GROUP BY rsm.reg_id, rsm.pid;


--
-- Name: registration_map_people_counts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.registration_map_people_counts AS
 SELECT registration_map_counts.pid,
    count(registration_map_counts.pid) AS count
   FROM public.registration_map_counts
  GROUP BY registration_map_counts.pid;


--
-- Name: registration_map_reg_counts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.registration_map_reg_counts AS
 SELECT registration_map_counts.reg_id,
    count(registration_map_counts.reg_id) AS count
   FROM public.registration_map_counts
  GROUP BY registration_map_counts.reg_id;


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
    capacity integer,
    floor character varying,
    open_for_schedule boolean DEFAULT true,
    is_virtual boolean DEFAULT false,
    area_of_space numeric,
    room_set_id uuid,
    length numeric,
    width numeric,
    height numeric,
    integrations jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: room_allocations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.room_allocations AS
 SELECT s.room_id,
    s.title AS session_title,
    s.start_time,
    (s.start_time + ((s.duration || ' minute'::text))::interval) AS end_time,
    s.duration,
    s.id AS session_id
   FROM (public.sessions s
     JOIN public.rooms r ON (((r.id = s.room_id) AND (s.start_time IS NOT NULL))));


--
-- Name: room_conflicts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.room_conflicts AS
 SELECT concat(b1.room_id, ':', b1.session_id, ':', b2.session_id) AS id,
    b1.room_id,
    b1.session_title,
    b1.session_id,
    b1.start_time,
    b1.end_time,
    b1.duration,
    b2.session_id AS conflicting_session_id,
    b2.session_title AS conflicting_session_title,
    b2.start_time AS conflicting_session_start_time,
    b2.duration AS conflicting_session_duration,
    b2.end_time AS conflicting_session_end_time,
        CASE
            WHEN ((b1.start_time = b2.end_time) OR (b2.start_time = b1.end_time)) THEN true
            ELSE false
        END AS back_to_back
   FROM (public.room_allocations b1
     JOIN public.room_allocations b2 ON (((b1.room_id = b2.room_id) AND (b1.session_id <> b2.session_id) AND ((b2.start_time >= b1.start_time) AND (b2.start_time <= b1.end_time)))))
  ORDER BY b1.room_id, b1.start_time;


--
-- Name: room_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_services (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying(2000),
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: room_services_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_services_sessions (
    room_service_id uuid,
    session_id uuid
);


--
-- Name: room_sets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_sets (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name character varying,
    description character varying,
    sort_order integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: schedule_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_snapshots (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    label character varying,
    created_by character varying,
    started_at timestamp without time zone,
    completed_at timestamp without time zone,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status public.snapshot_status_enum DEFAULT 'not_set'::public.snapshot_status_enum
);


--
-- Name: schedule_workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedule_workflows (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_by character varying,
    set_at timestamp without time zone,
    schedule_snapshot_id uuid,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state public.schedule_workflow_enum DEFAULT 'not_set'::public.schedule_workflow_enum
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
-- Name: session_conflicts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.session_conflicts AS
 SELECT person_exclusion_conflicts.session_id,
    person_exclusion_conflicts.title AS session_title,
    person_exclusion_conflicts.start_time AS session_start_time,
    person_exclusion_conflicts.duration AS session_duration,
    person_exclusion_conflicts.room_id,
    person_exclusion_conflicts.person_id,
    person_exclusion_conflicts.name AS person_name,
    person_exclusion_conflicts.published_name AS person_published_name,
    person_exclusion_conflicts.session_assignment_id,
    person_exclusion_conflicts.session_assignment_role_type_id,
    person_exclusion_conflicts.session_assignment_name,
    person_exclusion_conflicts.excluded_session_id AS conflict_session_id,
    person_exclusion_conflicts.excluded_session_title AS conflict_session_title,
    NULL::timestamp without time zone AS conflict_session_start_time,
    NULL::integer AS conflict_session_duration,
    NULL::uuid AS conflict_session_assignment_role_type_id,
    NULL::text AS conflict_session_assignment_name,
    person_exclusion_conflicts.id AS conflict_id,
    'person_exclusion_conflict'::text AS conflict_type
   FROM public.person_exclusion_conflicts
UNION
 SELECT availability_conflicts.session_id,
    availability_conflicts.session_title,
    availability_conflicts.session_start_time,
    availability_conflicts.session_duration,
    availability_conflicts.session_room_id AS room_id,
    availability_conflicts.person_id,
    availability_conflicts.person_name,
    availability_conflicts.person_published_name,
    availability_conflicts.session_assignment_id,
    availability_conflicts.session_assignment_role_type_id,
    availability_conflicts.session_assignment_name,
    NULL::uuid AS conflict_session_id,
    NULL::character varying AS conflict_session_title,
    NULL::timestamp without time zone AS conflict_session_start_time,
    NULL::integer AS conflict_session_duration,
    NULL::uuid AS conflict_session_assignment_role_type_id,
    NULL::text AS conflict_session_assignment_name,
    availability_conflicts.id AS conflict_id,
    'availability_conflict'::text AS conflict_type
   FROM public.availability_conflicts
UNION
 SELECT room_conflicts.session_id,
    room_conflicts.session_title,
    room_conflicts.start_time AS session_start_time,
    room_conflicts.duration AS session_duration,
    room_conflicts.room_id,
    NULL::uuid AS person_id,
    NULL::character varying AS person_name,
    NULL::character varying AS person_published_name,
    NULL::uuid AS session_assignment_id,
    NULL::uuid AS session_assignment_role_type_id,
    NULL::character varying AS session_assignment_name,
    room_conflicts.conflicting_session_id AS conflict_session_id,
    room_conflicts.conflicting_session_title AS conflict_session_title,
    room_conflicts.conflicting_session_start_time AS conflict_session_start_time,
    room_conflicts.conflicting_session_duration AS conflict_session_duration,
    NULL::uuid AS conflict_session_assignment_role_type_id,
    NULL::text AS conflict_session_assignment_name,
    room_conflicts.id AS conflict_id,
    'room_conflict'::text AS conflict_type
   FROM public.room_conflicts
  WHERE (room_conflicts.back_to_back = false)
UNION
 SELECT person_schedule_conflicts.session_id,
    person_schedule_conflicts.title AS session_title,
    person_schedule_conflicts.start_time AS session_start_time,
    person_schedule_conflicts.duration AS session_duration,
    person_schedule_conflicts.room_id,
    person_schedule_conflicts.person_id,
    person_schedule_conflicts.name AS person_name,
    person_schedule_conflicts.published_name AS person_published_name,
    person_schedule_conflicts.session_assignment_id,
    person_schedule_conflicts.session_assignment_role_type_id,
    person_schedule_conflicts.session_assignment_name,
    person_schedule_conflicts.conflict_session_id,
    person_schedule_conflicts.conflict_session_title,
    NULL::timestamp without time zone AS conflict_session_start_time,
    NULL::integer AS conflict_session_duration,
    person_schedule_conflicts.conflict_session_assignment_role_type_id,
    person_schedule_conflicts.conflict_session_assignment_name,
    person_schedule_conflicts.id AS conflict_id,
    'person_schedule_conflict'::text AS conflict_type
   FROM public.person_schedule_conflicts
UNION
 SELECT person_back_to_back.session_id,
    person_back_to_back.title AS session_title,
    person_back_to_back.start_time AS session_start_time,
    person_back_to_back.duration AS session_duration,
    person_back_to_back.room_id,
    person_back_to_back.person_id,
    person_back_to_back.name AS person_name,
    person_back_to_back.published_name AS person_published_name,
    person_back_to_back.session_assignment_id,
    person_back_to_back.session_assignment_role_type_id,
    person_back_to_back.session_assignment_name,
    person_back_to_back.conflict_session_id,
    person_back_to_back.conflict_session_title,
    NULL::timestamp without time zone AS conflict_session_start_time,
    NULL::integer AS conflict_session_duration,
    person_back_to_back.conflict_session_assignment_role_type_id,
    person_back_to_back.conflict_session_assignment_name,
    person_back_to_back.id AS conflict_id,
    'person_back_to_back'::text AS conflict_type
   FROM public.person_back_to_back;


--
-- Name: session_limits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_limits (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    person_id uuid,
    day date,
    max_sessions integer,
    lock_version integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
    response jsonb,
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
    unassigned boolean DEFAULT false,
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
    transition_decline_status public.person_status_enum,
    unique_submission boolean DEFAULT true
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
-- Name: tt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tt (
    relkind "char"
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
    sort_order integer,
    address character varying
);


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id uuid NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object_old text,
    created_at timestamp without time zone,
    object_changes json,
    object json
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
-- Name: audit_people_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_people_versions ALTER COLUMN id SET DEFAULT nextval('public.audit_people_versions_id_seq'::regclass);


--
-- Name: audit_published_session_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_published_session_versions ALTER COLUMN id SET DEFAULT nextval('public.audit_published_session_versions_id_seq'::regclass);


--
-- Name: audit_session_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_session_versions ALTER COLUMN id SET DEFAULT nextval('public.audit_session_versions_id_seq'::regclass);


--
-- Name: audit_survey_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_survey_versions ALTER COLUMN id SET DEFAULT nextval('public.audit_survey_versions_id_seq'::regclass);


--
-- Name: categorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations ALTER COLUMN id SET DEFAULT nextval('public.categorizations_id_seq'::regclass);


--
-- Name: old_passwords id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.old_passwords ALTER COLUMN id SET DEFAULT nextval('public.old_passwords_id_seq'::regclass);


--
-- Name: survey_formats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_formats ALTER COLUMN id SET DEFAULT nextval('public.survey_formats_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: age_restrictions age_restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.age_restrictions
    ADD CONSTRAINT age_restrictions_pkey PRIMARY KEY (id);


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
-- Name: audit_people_versions audit_people_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_people_versions
    ADD CONSTRAINT audit_people_versions_pkey PRIMARY KEY (id);


--
-- Name: audit_published_session_versions audit_published_session_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_published_session_versions
    ADD CONSTRAINT audit_published_session_versions_pkey PRIMARY KEY (id);


--
-- Name: audit_session_versions audit_session_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_session_versions
    ADD CONSTRAINT audit_session_versions_pkey PRIMARY KEY (id);


--
-- Name: audit_survey_versions audit_survey_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_survey_versions
    ADD CONSTRAINT audit_survey_versions_pkey PRIMARY KEY (id);


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
-- Name: curated_tags curated_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.curated_tags
    ADD CONSTRAINT curated_tags_pkey PRIMARY KEY (id);


--
-- Name: dismissed_reg_sync_matches dismissed_reg_sync_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dismissed_reg_sync_matches
    ADD CONSTRAINT dismissed_reg_sync_matches_pkey PRIMARY KEY (id);


--
-- Name: email_addresses email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses
    ADD CONSTRAINT email_addresses_pkey PRIMARY KEY (id);


--
-- Name: exclusions exclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exclusions
    ADD CONSTRAINT exclusions_pkey PRIMARY KEY (id);


--
-- Name: formats formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.formats
    ADD CONSTRAINT formats_pkey PRIMARY KEY (id);


--
-- Name: ignored_conflicts ignored_conflicts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ignored_conflicts
    ADD CONSTRAINT ignored_conflicts_pkey PRIMARY KEY (id);


--
-- Name: integration_publishes integration_publishes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integration_publishes
    ADD CONSTRAINT integration_publishes_pkey PRIMARY KEY (id);


--
-- Name: integrations integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.integrations
    ADD CONSTRAINT integrations_pkey PRIMARY KEY (id);


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
-- Name: model_permissions model_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_permissions
    ADD CONSTRAINT model_permissions_pkey PRIMARY KEY (mdl_name, application_role_id);


--
-- Name: oauth_identities oauth_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_identities
    ADD CONSTRAINT oauth_identities_pkey PRIMARY KEY (id);


--
-- Name: old_passwords old_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.old_passwords
    ADD CONSTRAINT old_passwords_pkey PRIMARY KEY (id);


--
-- Name: page_contents page_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.page_contents
    ADD CONSTRAINT page_contents_pkey PRIMARY KEY (id);


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
-- Name: person_exclusions person_exclusions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_exclusions
    ADD CONSTRAINT person_exclusions_pkey PRIMARY KEY (id);


--
-- Name: person_mailing_assignments person_mailing_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_mailing_assignments
    ADD CONSTRAINT person_mailing_assignments_pkey PRIMARY KEY (id);


--
-- Name: application_role_assocs person_role_assocs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_role_assocs
    ADD CONSTRAINT person_role_assocs_pkey PRIMARY KEY (id);


--
-- Name: application_roles person_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_roles
    ADD CONSTRAINT person_roles_pkey PRIMARY KEY (id);


--
-- Name: person_schedule_approvals person_schedule_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_schedule_approvals
    ADD CONSTRAINT person_schedule_approvals_pkey PRIMARY KEY (id);


--
-- Name: person_schedule_snapshots person_schedule_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_schedule_snapshots
    ADD CONSTRAINT person_schedule_snapshots_pkey PRIMARY KEY (id);


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
-- Name: job_statuses publication_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_statuses
    ADD CONSTRAINT publication_statuses_pkey PRIMARY KEY (id);


--
-- Name: publish_snapshots publish_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publish_snapshots
    ADD CONSTRAINT publish_snapshots_pkey PRIMARY KEY (id);


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
-- Name: registration_sync_data registration_sync_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.registration_sync_data
    ADD CONSTRAINT registration_sync_data_pkey PRIMARY KEY (id);


--
-- Name: room_services room_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_services
    ADD CONSTRAINT room_services_pkey PRIMARY KEY (id);


--
-- Name: room_sets room_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_sets
    ADD CONSTRAINT room_sets_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schedule_snapshots schedule_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_snapshots
    ADD CONSTRAINT schedule_snapshots_pkey PRIMARY KEY (id);


--
-- Name: schedule_workflows schedule_workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedule_workflows
    ADD CONSTRAINT schedule_workflows_pkey PRIMARY KEY (id);


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
-- Name: session_limits session_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_limits
    ADD CONSTRAINT session_limits_pkey PRIMARY KEY (id);


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
-- Name: application_role_assocs_app_role_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX application_role_assocs_app_role_idx ON public.application_role_assocs USING btree (application_role_id);


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
-- Name: idx_people_reg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_people_reg_id ON public.people USING btree (reg_id);


--
-- Name: idx_person_reg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_person_reg_id ON public.dismissed_reg_sync_matches USING btree (person_id, reg_id);


--
-- Name: idx_tagname_on_context; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_tagname_on_context ON public.curated_tags USING btree (name, context);


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
-- Name: index_application_roles_on_con_roles; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_roles_on_con_roles ON public.application_roles USING gin (con_roles);


--
-- Name: index_application_roles_people_on_application_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_roles_people_on_application_role_id ON public.application_roles_people USING btree (application_role_id);


--
-- Name: index_application_roles_people_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_roles_people_on_person_id ON public.application_roles_people USING btree (person_id);


--
-- Name: index_areas_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_areas_on_name ON public.areas USING btree (name);


--
-- Name: index_audit_people_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_people_versions_on_item_type_and_item_id ON public.audit_people_versions USING btree (item_type, item_id);


--
-- Name: index_audit_published_session_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_published_session_versions_on_item_type_and_item_id ON public.audit_published_session_versions USING btree (item_type, item_id);


--
-- Name: index_audit_session_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_session_versions_on_item_type_and_item_id ON public.audit_session_versions USING btree (item_type, item_id);


--
-- Name: index_audit_survey_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_survey_versions_on_item_type_and_item_id ON public.audit_survey_versions USING btree (item_type, item_id);


--
-- Name: index_convention_roles_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_convention_roles_on_person_id ON public.convention_roles USING btree (person_id);


--
-- Name: index_dismissed_reg_sync_matches_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dismissed_reg_sync_matches_on_person_id ON public.dismissed_reg_sync_matches USING btree (person_id);


--
-- Name: index_dismissed_reg_sync_matches_on_reg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dismissed_reg_sync_matches_on_reg_id ON public.dismissed_reg_sync_matches USING btree (reg_id);


--
-- Name: index_email_addresses_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_addresses_on_email ON public.email_addresses USING gin (email public.gin_trgm_ops);


--
-- Name: index_exclusions_sessions_on_exclusion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exclusions_sessions_on_exclusion_id ON public.exclusions_sessions USING btree (exclusion_id);


--
-- Name: index_exclusions_sessions_on_exclusion_id_and_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_exclusions_sessions_on_exclusion_id_and_session_id ON public.exclusions_sessions USING btree (exclusion_id, session_id);


--
-- Name: index_exclusions_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exclusions_sessions_on_session_id ON public.exclusions_sessions USING btree (session_id);


--
-- Name: index_ignored_conflicts_on_conflict_id_and_conflict_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ignored_conflicts_on_conflict_id_and_conflict_type ON public.ignored_conflicts USING btree (conflict_id, conflict_type);


--
-- Name: index_magic_links_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_magic_links_on_person_id ON public.magic_links USING btree (person_id);


--
-- Name: index_mailings_on_mailing_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mailings_on_mailing_state ON public.mailings USING btree (mailing_state);


--
-- Name: index_model_permissions_on_application_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_model_permissions_on_application_role_id ON public.model_permissions USING btree (application_role_id);


--
-- Name: index_password_archivable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_password_archivable ON public.old_passwords USING btree (password_archivable_type, password_archivable_id);


--
-- Name: index_people_on_bio; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_bio ON public.people USING gin (bio public.gin_trgm_ops);


--
-- Name: index_people_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_people_on_confirmation_token ON public.people USING btree (confirmation_token);


--
-- Name: index_people_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_name ON public.people USING gin (name public.gin_trgm_ops);


--
-- Name: index_people_on_pseudonym; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_pseudonym ON public.people USING gin (pseudonym public.gin_trgm_ops);


--
-- Name: index_people_on_published_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_people_on_published_name ON public.people USING gin (published_name public.gin_trgm_ops);


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
-- Name: index_person_exclusions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_exclusions_on_person_id ON public.person_exclusions USING btree (person_id);


--
-- Name: index_person_exclusions_on_person_id_and_exclusion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_person_exclusions_on_person_id_and_exclusion_id ON public.person_exclusions USING btree (person_id, exclusion_id);


--
-- Name: index_person_mailing_assignments_on_mailing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_mailing_assignments_on_mailing_id ON public.person_mailing_assignments USING btree (mailing_id);


--
-- Name: index_person_mailing_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_mailing_assignments_on_person_id ON public.person_mailing_assignments USING btree (person_id);


--
-- Name: index_published_programme_item_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_published_programme_item_assignments_on_person_id ON public.published_session_assignments USING btree (person_id);


--
-- Name: index_published_sessions_on_format_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_published_sessions_on_format_id ON public.published_sessions USING btree (format_id);


--
-- Name: index_registration_sync_data_on_alternative_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_alternative_email ON public.registration_sync_data USING gin (alternative_email public.gin_trgm_ops);


--
-- Name: index_registration_sync_data_on_badge_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_badge_name ON public.registration_sync_data USING gin (badge_name public.gin_trgm_ops);


--
-- Name: index_registration_sync_data_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_email ON public.registration_sync_data USING gin (email public.gin_trgm_ops);


--
-- Name: index_registration_sync_data_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_name ON public.registration_sync_data USING gin (name public.gin_trgm_ops);


--
-- Name: index_registration_sync_data_on_preferred_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_preferred_name ON public.registration_sync_data USING gin (preferred_name public.gin_trgm_ops);


--
-- Name: index_registration_sync_data_on_reg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_reg_id ON public.registration_sync_data USING btree (reg_id);


--
-- Name: index_registration_sync_data_on_registration_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_registration_sync_data_on_registration_number ON public.registration_sync_data USING btree (registration_number);


--
-- Name: index_room_services_sessions_on_room_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_room_services_sessions_on_room_service_id ON public.room_services_sessions USING btree (room_service_id);


--
-- Name: index_room_services_sessions_on_room_service_id_and_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_room_services_sessions_on_room_service_id_and_session_id ON public.room_services_sessions USING btree (room_service_id, session_id);


--
-- Name: index_room_services_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_room_services_sessions_on_session_id ON public.room_services_sessions USING btree (session_id);


--
-- Name: index_rooms_on_room_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_on_room_set_id ON public.rooms USING btree (room_set_id);


--
-- Name: index_schedule_snapshots_on_label; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schedule_snapshots_on_label ON public.schedule_snapshots USING btree (label);


--
-- Name: index_schedule_workflows_on_schedule_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schedule_workflows_on_schedule_snapshot_id ON public.schedule_workflows USING btree (schedule_snapshot_id);


--
-- Name: index_session_areas_on_session_id_and_area_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_session_areas_on_session_id_and_area_id ON public.session_areas USING btree (session_id, area_id);


--
-- Name: index_session_assignments_on_interest_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_assignments_on_interest_role ON public.session_assignments USING btree (interest_role);


--
-- Name: index_session_assignments_on_session_assignment_role_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_assignments_on_session_assignment_role_type_id ON public.session_assignments USING btree (session_assignment_role_type_id);


--
-- Name: index_session_limits_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_limits_on_person_id ON public.session_limits USING btree (person_id);


--
-- Name: index_session_limits_on_person_id_and_day; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_session_limits_on_person_id_and_day ON public.session_limits USING btree (person_id, day);


--
-- Name: index_sessions_on_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_description ON public.sessions USING gin (description public.gin_trgm_ops);


--
-- Name: index_sessions_on_instructions_for_interest; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_instructions_for_interest ON public.sessions USING gin (instructions_for_interest public.gin_trgm_ops);


--
-- Name: index_sessions_on_interest_opened_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_interest_opened_by ON public.sessions USING gin (interest_opened_by public.gin_trgm_ops);


--
-- Name: index_sessions_on_item_notes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_item_notes ON public.sessions USING gin (item_notes public.gin_trgm_ops);


--
-- Name: index_sessions_on_participant_notes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_participant_notes ON public.sessions USING gin (participant_notes public.gin_trgm_ops);


--
-- Name: index_sessions_on_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_room_id ON public.sessions USING btree (room_id);


--
-- Name: index_sessions_on_room_notes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_room_notes ON public.sessions USING gin (room_notes public.gin_trgm_ops);


--
-- Name: index_sessions_on_tech_notes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_tech_notes ON public.sessions USING gin (tech_notes public.gin_trgm_ops);


--
-- Name: index_sessions_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_title ON public.sessions USING gin (title public.gin_trgm_ops);


--
-- Name: index_sessions_on_updated_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_by ON public.sessions USING gin (updated_by public.gin_trgm_ops);


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
-- Name: matches_pid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX matches_pid ON public.registration_sync_matches USING btree (pid);


--
-- Name: matches_reg_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX matches_reg_id ON public.registration_sync_matches USING btree (reg_id);


--
-- Name: par_approle_person_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX par_approle_person_idx ON public.application_roles_people USING btree (application_role_id, person_id);


--
-- Name: pia_person_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pia_person_index ON public.session_assignments USING btree (person_id);


--
-- Name: pis_prog_item_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pis_prog_item_id_index ON public.session_assignments USING btree (session_id);


--
-- Name: psa_person_wrkflw_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX psa_person_wrkflw_idx ON public.person_schedule_approvals USING btree (person_id, schedule_workflow_id);


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
-- Name: unique_page_content; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_page_content ON public.page_contents USING btree (name);


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
-- Name: rooms fk_rails_d2498419d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT fk_rails_d2498419d7 FOREIGN KEY (room_set_id) REFERENCES public.room_sets(id);


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
('20220326140959'),
('20220330150651'),
('20220330150751'),
('20220331160250'),
('20220403175009'),
('20220403175609'),
('20220404140435'),
('20220404140458'),
('20220404142002'),
('20220404142017'),
('20220404143150'),
('20220404162324'),
('20220410221341'),
('20220411031007'),
('20220424152922'),
('20220424174950'),
('20220424180453'),
('20220424181346'),
('20220426010537'),
('20220427170202'),
('20220428205309'),
('20220501155733'),
('20220501160504'),
('20220501200956'),
('20220502132016'),
('20220502152603'),
('20220503121253'),
('20220504140508'),
('20220507210839'),
('20220510015131'),
('20220512004401'),
('20220524195624'),
('20220527143522'),
('20220528145537'),
('20220531011606'),
('20220609202747'),
('20220612134513'),
('20220612135253'),
('20220613152827'),
('20220613171929'),
('20220613194424'),
('20220614014103'),
('20220614183042'),
('20220614190928'),
('20220616160624'),
('20220617012940'),
('20220617185031'),
('20220620180030'),
('20220620180039'),
('20220620215358'),
('20220621153128'),
('20220622034153'),
('20220623135745'),
('20220623141950'),
('20220623142741'),
('20220623143613'),
('20220623144036'),
('20220623145514'),
('20220623172955'),
('20220624121252'),
('20220628121934'),
('20220629132145'),
('20220630032544'),
('20220704121816'),
('20220707124302'),
('20220712153111'),
('20220712153128'),
('20220713185329'),
('20220714124643'),
('20220714124706'),
('20220719000644'),
('20220723213605'),
('20220726130346'),
('20220801152151'),
('20220801173704'),
('20220801195644'),
('20220818022629'),
('20220818200500'),
('20220821001724'),
('20230304203222'),
('20230411123748'),
('20230602193356'),
('20230924145027'),
('20231030160649'),
('20231030174246'),
('20231031141050'),
('20231031141060'),
('20231031141408'),
('20231101143131'),
('20231103133301'),
('20240207232239'),
('20240207233122'),
('20240223132105'),
('20240223134703'),
('20240226191153'),
('20240303213410'),
('20240423130325'),
('20240429160250'),
('20240515001411'),
('20240521184252'),
('20240521193119'),
('20240522174506'),
('20240522190737'),
('20240602172220'),
('20240606115218'),
('20240622165823'),
('20240708121706');


