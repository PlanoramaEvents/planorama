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
-- Name: acceptance_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.acceptance_status_enum AS ENUM (
    'unknown',
    'probable',
    'accepted',
    'declined'
);


--
-- Name: assignment_role_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.assignment_role_enum AS ENUM (
    'participant',
    'staff'
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
-- Name: person_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.person_role AS ENUM (
    'admin',
    'planner',
    'member'
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
-- Name: visibility_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.visibility_enum AS ENUM (
    'private',
    'public'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

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
-- Name: available_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.available_dates (
    id integer NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: available_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.available_dates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: available_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.available_dates_id_seq OWNED BY public.available_dates.id;


--
-- Name: bios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bios (
    id integer NOT NULL,
    bio text,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    website text,
    twitterinfo text,
    othersocialmedia text,
    photourl text,
    facebook text,
    linkedin text,
    twitch text,
    youtube text,
    instagram text,
    flickr text,
    reddit text
);


--
-- Name: bios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bios_id_seq OWNED BY public.bios.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(191) NOT NULL,
    description character varying,
    target_class character varying(100),
    active boolean DEFAULT true NOT NULL,
    reserved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


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
    category_id integer NOT NULL
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
    id integer NOT NULL,
    parameter character varying(45) NOT NULL,
    parameter_value character varying(150) NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: conflict_exceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conflict_exceptions (
    id integer NOT NULL,
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
-- Name: conflict_exceptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conflict_exceptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conflict_exceptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conflict_exceptions_id_seq OWNED BY public.conflict_exceptions.id;


--
-- Name: email_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_addresses (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying,
    isdefault boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    label character varying,
    person_id integer,
    is_valid boolean DEFAULT true NOT NULL
);


--
-- Name: email_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_addresses_id_seq OWNED BY public.email_addresses.id;


--
-- Name: excluded_items_survey_maps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.excluded_items_survey_maps (
    id integer NOT NULL,
    programme_item_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    survey_answer_id integer
);


--
-- Name: excluded_items_survey_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.excluded_items_survey_maps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: excluded_items_survey_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.excluded_items_survey_maps_id_seq OWNED BY public.excluded_items_survey_maps.id;


--
-- Name: exclusions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exclusions (
    id integer NOT NULL,
    excludable_id integer,
    excludable_type character varying,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    source text
);


--
-- Name: exclusions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exclusions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exclusions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exclusions_id_seq OWNED BY public.exclusions.id;


--
-- Name: formats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.formats (
    id integer NOT NULL,
    name character varying NOT NULL,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: formats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.formats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.formats_id_seq OWNED BY public.formats.id;


--
-- Name: job_infos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_infos (
    id integer NOT NULL,
    last_run timestamp without time zone,
    job_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: job_infos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_infos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_infos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_infos_id_seq OWNED BY public.job_infos.id;


--
-- Name: label_dimensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.label_dimensions (
    id integer NOT NULL,
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
-- Name: label_dimensions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.label_dimensions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: label_dimensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.label_dimensions_id_seq OWNED BY public.label_dimensions.id;


--
-- Name: mail_histories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_histories (
    id integer NOT NULL,
    person_mailing_assignment_id integer,
    email_status public.mail_status_enum,
    date_sent timestamp without time zone,
    email character varying,
    content text,
    testrun boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    person_id integer,
    mailing_id integer,
    subject character varying
);


--
-- Name: mail_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mail_histories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mail_histories_id_seq OWNED BY public.mail_histories.id;


--
-- Name: mail_templates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mail_templates (
    id integer NOT NULL,
    title character varying DEFAULT ''::character varying,
    subject character varying DEFAULT ''::character varying,
    content text,
    survey_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    transiton_invite_status public.invite_status_enum DEFAULT 'not_set'::public.invite_status_enum,
    mail_use public.mail_use_enum
);


--
-- Name: mail_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mail_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mail_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mail_templates_id_seq OWNED BY public.mail_templates.id;


--
-- Name: mailings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailings (
    id integer NOT NULL,
    mailing_number integer,
    mail_template_id integer,
    scheduled boolean,
    testrun boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    last_person_idx integer DEFAULT '-1'::integer,
    include_email boolean DEFAULT true,
    cc_all boolean DEFAULT false
);


--
-- Name: mailings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailings_id_seq OWNED BY public.mailings.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    originator_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    programme_item_id integer,
    person_id integer
);


--
-- Name: parameter_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parameter_names (
    parameter_name character varying(45) NOT NULL,
    parameter_description character varying(170) NOT NULL
);


--
-- Name: pending_import_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pending_import_people (
    id integer NOT NULL,
    first_name character varying DEFAULT ''::character varying,
    last_name character varying DEFAULT ''::character varying,
    suffix character varying DEFAULT ''::character varying,
    line1 character varying,
    line2 character varying,
    line3 character varying,
    city character varying,
    state character varying,
    postcode character varying,
    country character varying,
    phone character varying,
    email character varying DEFAULT ''::character varying,
    registration_number character varying,
    registration_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    datasource_id integer,
    datasource_dbid character varying,
    pendingtype_id integer,
    alt_email text,
    pub_first_name character varying,
    pub_last_name character varying,
    pub_suffix character varying,
    company character varying,
    job_title character varying,
    prefix character varying DEFAULT ''::character varying,
    pub_prefix character varying DEFAULT ''::character varying,
    bio text,
    invite_status character varying,
    invite_category character varying,
    accept_status character varying
);


--
-- Name: pending_import_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pending_import_people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pending_import_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pending_import_people_id_seq OWNED BY public.pending_import_people.id;


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id integer NOT NULL,
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
    invite_status public.invite_status_enum DEFAULT 'not_set'::public.invite_status_enum,
    acceptance_status public.acceptance_status_enum DEFAULT 'unknown'::public.acceptance_status_enum,
    registered boolean DEFAULT false NOT NULL,
    registration_type character varying,
    can_share boolean DEFAULT false NOT NULL,
    registration_number character varying,
    can_photo boolean DEFAULT false NOT NULL,
    can_record boolean DEFAULT false,
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
END) STORED
);


--
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- Name: person_constraints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_constraints (
    id integer NOT NULL,
    max_items_per_day integer,
    max_items_per_con integer,
    person_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: person_constraints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_constraints_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_constraints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_constraints_id_seq OWNED BY public.person_constraints.id;


--
-- Name: person_mailing_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_mailing_assignments (
    id integer NOT NULL,
    person_id integer,
    mailing_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: person_mailing_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_mailing_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_mailing_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_mailing_assignments_id_seq OWNED BY public.person_mailing_assignments.id;


--
-- Name: person_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_roles (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role public.person_role
);


--
-- Name: person_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_roles_id_seq OWNED BY public.person_roles.id;


--
-- Name: phone_numbers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.phone_numbers (
    id integer NOT NULL,
    number character varying DEFAULT ''::character varying,
    phone_type public.phone_type_enum,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    label character varying,
    isdefault boolean DEFAULT false,
    person_id integer,
    at_con boolean DEFAULT false NOT NULL
);


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.phone_numbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.phone_numbers_id_seq OWNED BY public.phone_numbers.id;


--
-- Name: postal_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.postal_addresses (
    id integer NOT NULL,
    line1 character varying,
    line2 character varying,
    city character varying,
    state character varying,
    postcode character varying,
    country character varying NOT NULL,
    phone character varying,
    isdefault boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    state_code character varying,
    country_code character varying,
    venue_id integer
);


--
-- Name: postal_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.postal_addresses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postal_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.postal_addresses_id_seq OWNED BY public.postal_addresses.id;


--
-- Name: programme_assignment_role_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programme_assignment_role_type (
    id integer NOT NULL,
    lock_version integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying(100) NOT NULL,
    role_type public.assignment_role_enum,
    default_visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
);


--
-- Name: programme_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programme_assignments (
    id integer NOT NULL,
    person_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    programme_assignment_role_type_id integer NOT NULL,
    programme_item_id integer NOT NULL,
    sort_order integer,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
);


--
-- Name: programme_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programme_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programme_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programme_assignments_id_seq OWNED BY public.programme_assignments.id;


--
-- Name: programme_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programme_items (
    id integer NOT NULL,
    duration integer,
    minimum_people integer,
    maximum_people integer,
    item_notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    lock_version integer DEFAULT 0,
    format_id integer,
    setup_type_id integer,
    pub_reference_number integer,
    mobile_card_size integer DEFAULT 1 NOT NULL,
    audience_size integer,
    participant_notes text,
    is_break boolean DEFAULT false,
    description text,
    title character varying(256),
    start_time timestamp without time zone,
    room_id integer,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum,
    publish boolean DEFAULT false NOT NULL
);


--
-- Name: programme_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programme_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programme_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programme_items_id_seq OWNED BY public.programme_items.id;


--
-- Name: publication_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_dates (
    id integer NOT NULL,
    "timestamp" timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    newitems integer DEFAULT 0,
    modifieditems integer DEFAULT 0,
    removeditems integer DEFAULT 0
);


--
-- Name: publication_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publication_dates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publication_dates_id_seq OWNED BY public.publication_dates.id;


--
-- Name: publication_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.publication_statuses (
    id integer NOT NULL,
    status character varying,
    submit_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: publication_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.publication_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publication_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.publication_statuses_id_seq OWNED BY public.publication_statuses.id;


--
-- Name: published_programme_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.published_programme_assignments (
    programme_assignment_id integer NOT NULL,
    programme_item_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    programme_assignment_role_type_id integer NOT NULL,
    person_id integer NOT NULL,
    sort_order integer,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
);


--
-- Name: published_programme_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.published_programme_items (
    programme_item_id integer NOT NULL,
    title character varying,
    duration integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    format_id integer,
    pub_reference_number integer,
    audience_size integer,
    participant_notes text,
    is_break boolean DEFAULT false,
    description text,
    start_time timestamp without time zone,
    room_id integer,
    visibility public.visibility_enum DEFAULT 'public'::public.visibility_enum
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    venue_id integer,
    name character varying(490) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    purpose character varying,
    comment text,
    setup_type_id integer,
    sort_order integer,
    capacity integer
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: setup_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.setup_types (
    id integer NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: setup_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.setup_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: setup_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.setup_types_id_seq OWNED BY public.setup_types.id;


--
-- Name: site_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_configs (
    id integer NOT NULL,
    captcha_pub_key character varying DEFAULT ''::character varying,
    captcha_priv_key character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    name character varying DEFAULT ''::character varying,
    time_zone character varying DEFAULT 'Eastern Time (US & Canada)'::character varying,
    start_date timestamp without time zone,
    public_start_date timestamp without time zone,
    end_date timestamp without time zone,
    public_end_date timestamp without time zone
);


--
-- Name: site_configs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.site_configs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_configs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.site_configs_id_seq OWNED BY public.site_configs.id;


--
-- Name: survey_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_answers (
    id integer NOT NULL,
    answer text,
    "default" boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    survey_question_id integer,
    sort_order integer
);


--
-- Name: survey_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_answers_id_seq OWNED BY public.survey_answers.id;


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
    id bigint NOT NULL,
    title character varying,
    next_page_id bigint,
    sort_order integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    survey_id bigint
);


--
-- Name: survey_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_pages_id_seq OWNED BY public.survey_pages.id;


--
-- Name: survey_queries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_queries (
    id integer NOT NULL,
    name character varying,
    operation character varying,
    survey_id integer,
    shared boolean,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    date_order boolean DEFAULT false,
    show_country boolean DEFAULT false
);


--
-- Name: survey_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_queries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_queries_id_seq OWNED BY public.survey_queries.id;


--
-- Name: survey_query_predicates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_query_predicates (
    id integer NOT NULL,
    survey_question_id integer,
    operation character varying,
    value text,
    survey_query_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: survey_query_predicates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_query_predicates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_query_predicates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_query_predicates_id_seq OWNED BY public.survey_query_predicates.id;


--
-- Name: survey_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_questions (
    id integer NOT NULL,
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
    survey_page_id bigint
);


--
-- Name: survey_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_questions_id_seq OWNED BY public.survey_questions.id;


--
-- Name: survey_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_responses (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    survey_question_id integer NOT NULL,
    response json,
    response_as_text text,
    survey_submission_id bigint NOT NULL
);


--
-- Name: survey_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_responses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_responses_id_seq OWNED BY public.survey_responses.id;


--
-- Name: survey_submissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.survey_submissions (
    id bigint NOT NULL,
    name character varying,
    survey_id bigint NOT NULL,
    person_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lock_version integer DEFAULT 0
);


--
-- Name: survey_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.survey_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: survey_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.survey_submissions_id_seq OWNED BY public.survey_submissions.id;


--
-- Name: surveys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.surveys (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    name character varying,
    welcome text,
    thank_you text,
    alias character varying(191),
    submit_string character varying DEFAULT 'Save'::character varying,
    header_image character varying DEFAULT ''::character varying,
    use_captcha boolean DEFAULT false,
    public boolean,
    authenticate boolean,
    transition_accept_status public.acceptance_status_enum,
    transition_decline_status public.acceptance_status_enum,
    declined_msg text,
    authenticate_msg text,
    anonymous boolean DEFAULT false,
    published_on timestamp without time zone,
    published_by_id integer,
    created_by_id integer,
    updated_by_id integer,
    description text
);


--
-- Name: surveys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.surveys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: surveys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.surveys_id_seq OWNED BY public.surveys.id;


--
-- Name: tag_contexts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_contexts (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    publish boolean DEFAULT true
);


--
-- Name: tag_contexts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_contexts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_contexts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_contexts_id_seq OWNED BY public.tag_contexts.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    tagger_id integer,
    tagger_type character varying(191),
    taggable_type character varying(191),
    context character varying(191),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying(191),
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: ui_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ui_preferences (
    id integer NOT NULL,
    key character varying(191),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    val json
);


--
-- Name: ui_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ui_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ui_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ui_preferences_id_seq OWNED BY public.ui_preferences.id;


--
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venues (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    lock_version integer DEFAULT 0,
    sort_order integer
);


--
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venues_id_seq OWNED BY public.venues.id;


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
-- Name: available_dates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_dates ALTER COLUMN id SET DEFAULT nextval('public.available_dates_id_seq'::regclass);


--
-- Name: bios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bios ALTER COLUMN id SET DEFAULT nextval('public.bios_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: categorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorizations ALTER COLUMN id SET DEFAULT nextval('public.categorizations_id_seq'::regclass);


--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: conflict_exceptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conflict_exceptions ALTER COLUMN id SET DEFAULT nextval('public.conflict_exceptions_id_seq'::regclass);


--
-- Name: email_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses ALTER COLUMN id SET DEFAULT nextval('public.email_addresses_id_seq'::regclass);


--
-- Name: excluded_items_survey_maps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.excluded_items_survey_maps ALTER COLUMN id SET DEFAULT nextval('public.excluded_items_survey_maps_id_seq'::regclass);


--
-- Name: exclusions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exclusions ALTER COLUMN id SET DEFAULT nextval('public.exclusions_id_seq'::regclass);


--
-- Name: formats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.formats ALTER COLUMN id SET DEFAULT nextval('public.formats_id_seq'::regclass);


--
-- Name: job_infos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_infos ALTER COLUMN id SET DEFAULT nextval('public.job_infos_id_seq'::regclass);


--
-- Name: label_dimensions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_dimensions ALTER COLUMN id SET DEFAULT nextval('public.label_dimensions_id_seq'::regclass);


--
-- Name: mail_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_histories ALTER COLUMN id SET DEFAULT nextval('public.mail_histories_id_seq'::regclass);


--
-- Name: mail_templates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_templates ALTER COLUMN id SET DEFAULT nextval('public.mail_templates_id_seq'::regclass);


--
-- Name: mailings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings ALTER COLUMN id SET DEFAULT nextval('public.mailings_id_seq'::regclass);


--
-- Name: pending_import_people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_import_people ALTER COLUMN id SET DEFAULT nextval('public.pending_import_people_id_seq'::regclass);


--
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- Name: person_constraints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_constraints ALTER COLUMN id SET DEFAULT nextval('public.person_constraints_id_seq'::regclass);


--
-- Name: person_mailing_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_mailing_assignments ALTER COLUMN id SET DEFAULT nextval('public.person_mailing_assignments_id_seq'::regclass);


--
-- Name: person_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_roles ALTER COLUMN id SET DEFAULT nextval('public.person_roles_id_seq'::regclass);


--
-- Name: phone_numbers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers ALTER COLUMN id SET DEFAULT nextval('public.phone_numbers_id_seq'::regclass);


--
-- Name: postal_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postal_addresses ALTER COLUMN id SET DEFAULT nextval('public.postal_addresses_id_seq'::regclass);


--
-- Name: programme_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programme_assignments ALTER COLUMN id SET DEFAULT nextval('public.programme_assignments_id_seq'::regclass);


--
-- Name: programme_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programme_items ALTER COLUMN id SET DEFAULT nextval('public.programme_items_id_seq'::regclass);


--
-- Name: publication_dates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_dates ALTER COLUMN id SET DEFAULT nextval('public.publication_dates_id_seq'::regclass);


--
-- Name: publication_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.publication_statuses ALTER COLUMN id SET DEFAULT nextval('public.publication_statuses_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: setup_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setup_types ALTER COLUMN id SET DEFAULT nextval('public.setup_types_id_seq'::regclass);


--
-- Name: site_configs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_configs ALTER COLUMN id SET DEFAULT nextval('public.site_configs_id_seq'::regclass);


--
-- Name: survey_answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_answers ALTER COLUMN id SET DEFAULT nextval('public.survey_answers_id_seq'::regclass);


--
-- Name: survey_formats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_formats ALTER COLUMN id SET DEFAULT nextval('public.survey_formats_id_seq'::regclass);


--
-- Name: survey_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_pages ALTER COLUMN id SET DEFAULT nextval('public.survey_pages_id_seq'::regclass);


--
-- Name: survey_queries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_queries ALTER COLUMN id SET DEFAULT nextval('public.survey_queries_id_seq'::regclass);


--
-- Name: survey_query_predicates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_query_predicates ALTER COLUMN id SET DEFAULT nextval('public.survey_query_predicates_id_seq'::regclass);


--
-- Name: survey_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_questions ALTER COLUMN id SET DEFAULT nextval('public.survey_questions_id_seq'::regclass);


--
-- Name: survey_responses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses ALTER COLUMN id SET DEFAULT nextval('public.survey_responses_id_seq'::regclass);


--
-- Name: survey_submissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_submissions ALTER COLUMN id SET DEFAULT nextval('public.survey_submissions_id_seq'::regclass);


--
-- Name: surveys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.surveys ALTER COLUMN id SET DEFAULT nextval('public.surveys_id_seq'::regclass);


--
-- Name: tag_contexts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_contexts ALTER COLUMN id SET DEFAULT nextval('public.tag_contexts_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: ui_preferences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ui_preferences ALTER COLUMN id SET DEFAULT nextval('public.ui_preferences_id_seq'::regclass);


--
-- Name: venues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues ALTER COLUMN id SET DEFAULT nextval('public.venues_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: available_dates available_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.available_dates
    ADD CONSTRAINT available_dates_pkey PRIMARY KEY (id);


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
-- Name: email_addresses email_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_addresses
    ADD CONSTRAINT email_addresses_pkey PRIMARY KEY (id);


--
-- Name: excluded_items_survey_maps excluded_items_survey_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.excluded_items_survey_maps
    ADD CONSTRAINT excluded_items_survey_maps_pkey PRIMARY KEY (id);


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
-- Name: job_infos job_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_infos
    ADD CONSTRAINT job_infos_pkey PRIMARY KEY (id);


--
-- Name: label_dimensions label_dimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_dimensions
    ADD CONSTRAINT label_dimensions_pkey PRIMARY KEY (id);


--
-- Name: mail_histories mail_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_histories
    ADD CONSTRAINT mail_histories_pkey PRIMARY KEY (id);


--
-- Name: mail_templates mail_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mail_templates
    ADD CONSTRAINT mail_templates_pkey PRIMARY KEY (id);


--
-- Name: mailings mailings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailings
    ADD CONSTRAINT mailings_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: parameter_names parameter_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_names
    ADD CONSTRAINT parameter_names_pkey PRIMARY KEY (parameter_name);


--
-- Name: pending_import_people pending_import_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_import_people
    ADD CONSTRAINT pending_import_people_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


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
-- Name: person_roles person_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_pkey PRIMARY KEY (id);


--
-- Name: phone_numbers phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.phone_numbers
    ADD CONSTRAINT phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: postal_addresses postal_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.postal_addresses
    ADD CONSTRAINT postal_addresses_pkey PRIMARY KEY (id);


--
-- Name: programme_assignment_role_type programme_assignment_role_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programme_assignment_role_type
    ADD CONSTRAINT programme_assignment_role_type_pkey PRIMARY KEY (id);


--
-- Name: programme_assignments programme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programme_assignments
    ADD CONSTRAINT programme_assignments_pkey PRIMARY KEY (id);


--
-- Name: programme_items programme_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programme_items
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
-- Name: published_programme_assignments published_programme_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.published_programme_assignments
    ADD CONSTRAINT published_programme_assignments_pkey PRIMARY KEY (programme_assignment_id);


--
-- Name: published_programme_items published_programme_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.published_programme_items
    ADD CONSTRAINT published_programme_items_pkey PRIMARY KEY (programme_item_id);


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
-- Name: setup_types setup_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.setup_types
    ADD CONSTRAINT setup_types_pkey PRIMARY KEY (id);


--
-- Name: site_configs site_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_configs
    ADD CONSTRAINT site_configs_pkey PRIMARY KEY (id);


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
-- Name: ui_preferences ui_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ui_preferences
    ADD CONSTRAINT ui_preferences_pkey PRIMARY KEY (id);


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
-- Name: index_person_mailing_assignments_on_mailing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_mailing_assignments_on_mailing_id ON public.person_mailing_assignments USING btree (mailing_id);


--
-- Name: index_person_mailing_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_mailing_assignments_on_person_id ON public.person_mailing_assignments USING btree (person_id);


--
-- Name: index_person_roles_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_roles_on_person_id ON public.person_roles USING btree (person_id);


--
-- Name: index_person_roles_on_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_person_roles_on_role ON public.person_roles USING btree (role);


--
-- Name: index_published_programme_item_assignments_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_published_programme_item_assignments_on_person_id ON public.published_programme_assignments USING btree (person_id);


--
-- Name: index_published_programme_items_on_format_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_published_programme_items_on_format_id ON public.published_programme_items USING btree (format_id);


--
-- Name: index_survey_pages_on_survey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_pages_on_survey_id ON public.survey_pages USING btree (survey_id);


--
-- Name: index_survey_questions_on_survey_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_questions_on_survey_page_id ON public.survey_questions USING btree (survey_page_id);


--
-- Name: index_survey_responses_on_survey_submission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_responses_on_survey_submission_id ON public.survey_responses USING btree (survey_submission_id);


--
-- Name: index_survey_submissions_on_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_survey_submissions_on_person_id ON public.survey_submissions USING btree (person_id);


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
-- Name: key_event_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX key_event_index ON public.ui_preferences USING btree (key);


--
-- Name: parameter_description_UNIQUE; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "parameter_description_UNIQUE" ON public.parameter_names USING btree (parameter_description);


--
-- Name: pia_person_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pia_person_index ON public.programme_assignments USING btree (person_id);


--
-- Name: pis_prog_item_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pis_prog_item_id_index ON public.programme_assignments USING btree (programme_item_id);


--
-- Name: pub_progitem_assignment_item_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pub_progitem_assignment_item_index ON public.published_programme_assignments USING btree (programme_item_id);


--
-- Name: pub_progitem_assignment_person_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pub_progitem_assignment_person_index ON public.published_programme_assignments USING btree (person_id);


--
-- Name: survey_alias_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX survey_alias_idx ON public.surveys USING btree (alias);


--
-- Name: survey_resp_question_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX survey_resp_question_idx ON public.survey_responses USING btree (survey_question_id);


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
    ADD CONSTRAINT fk_rails_35518ef583 FOREIGN KEY (survey_page_id) REFERENCES public.survey_pages(id);


--
-- Name: survey_submissions fk_rails_422004fc2f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_submissions
    ADD CONSTRAINT fk_rails_422004fc2f FOREIGN KEY (survey_id) REFERENCES public.surveys(id);


--
-- Name: survey_responses fk_rails_7fc628646e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.survey_responses
    ADD CONSTRAINT fk_rails_7fc628646e FOREIGN KEY (survey_submission_id) REFERENCES public.survey_submissions(id);


--
-- Name: person_roles fk_rails_8139558243; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT fk_rails_8139558243 FOREIGN KEY (person_id) REFERENCES public.people(id);


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
('20210627143358'),
('20210627225348'),
('20210628120942'),
('20210628221900');


