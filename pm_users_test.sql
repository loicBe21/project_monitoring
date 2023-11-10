--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.active_clients (
    id bigint NOT NULL,
    user_id bigint,
    company_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    rights_clients_id bigint
);


ALTER TABLE public.active_clients OWNER TO postgres;

--
-- Name: active_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.active_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_clients_id_seq OWNER TO postgres;

--
-- Name: active_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.active_clients_id_seq OWNED BY public.active_clients.id;


--
-- Name: assist_contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assist_contracts (
    id bigint NOT NULL,
    title character varying(255),
    date_start date,
    date_end date,
    company_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.assist_contracts OWNER TO postgres;

--
-- Name: assist_contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assist_contracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assist_contracts_id_seq OWNER TO postgres;

--
-- Name: assist_contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assist_contracts_id_seq OWNED BY public.assist_contracts.id;


--
-- Name: rights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rights (
    id bigint NOT NULL,
    title character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.rights OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(255),
    profile_picture character varying(255),
    email character varying(255),
    password character varying(255),
    right_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    function_id bigint,
    current_record_id integer
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: auth; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.auth AS
 SELECT users.id,
    users.username,
    users.profile_picture,
    users.email,
    users.right_id,
    rights.title
   FROM (public.users
     JOIN public.rights ON ((users.right_id = rights.id)));


ALTER TABLE public.auth OWNER TO postgres;

--
-- Name: base_cache_signaling; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.base_cache_signaling
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_cache_signaling OWNER TO postgres;

--
-- Name: base_registry_signaling; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.base_registry_signaling
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.base_registry_signaling OWNER TO postgres;

--
-- Name: boards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boards (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.boards OWNER TO postgres;

--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boards_id_seq OWNER TO postgres;

--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boards_id_seq OWNED BY public.boards.id;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cards (
    id bigint NOT NULL,
    name character varying(255),
    stage_id bigint NOT NULL,
    "position" integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    task_id bigint
);


ALTER TABLE public.cards OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cards_id_seq OWNER TO postgres;

--
-- Name: cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cards_id_seq OWNED BY public.cards.id;


--
-- Name: clients_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients_requests (
    id bigint NOT NULL,
    content character varying(255),
    date_post timestamp(0) without time zone,
    active_client_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    title character varying(255),
    seen boolean DEFAULT false,
    ongoing boolean DEFAULT false,
    done boolean DEFAULT false,
    file_urls character varying(255)[] DEFAULT ARRAY[]::character varying[] NOT NULL,
    project_id bigint,
    finished boolean DEFAULT false,
    date_seen timestamp(0) without time zone,
    date_ongoing timestamp(0) without time zone,
    date_done timestamp(0) without time zone,
    date_finished timestamp(0) without time zone,
    uuid character varying(255),
    survey jsonb DEFAULT '{}'::jsonb,
    is_urgent boolean DEFAULT false,
    tool_id bigint,
    deadline date,
    expectation character varying(255),
    request_type_id bigint
);


ALTER TABLE public.clients_requests OWNER TO postgres;

--
-- Name: clients_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_requests_id_seq OWNER TO postgres;

--
-- Name: clients_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_requests_id_seq OWNED BY public.clients_requests.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    content character varying(255),
    task_id bigint,
    poster_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    file_urls character varying(255)[] DEFAULT ARRAY[]::character varying[] NOT NULL
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comments_id_seq OWNER TO postgres;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    logo character varying(255)
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: contributor_functions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contributor_functions (
    id bigint NOT NULL,
    title character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.contributor_functions OWNER TO postgres;

--
-- Name: contributor_functions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contributor_functions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contributor_functions_id_seq OWNER TO postgres;

--
-- Name: contributor_functions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contributor_functions_id_seq OWNED BY public.contributor_functions.id;


--
-- Name: editors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editors (
    id bigint NOT NULL,
    title character varying(255),
    company_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.editors OWNER TO postgres;

--
-- Name: editors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.editors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.editors_id_seq OWNER TO postgres;

--
-- Name: editors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.editors_id_seq OWNED BY public.editors.id;


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.licenses (
    id bigint NOT NULL,
    title character varying(255),
    date_start date,
    date_end date,
    company_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.licenses OWNER TO postgres;

--
-- Name: licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.licenses_id_seq OWNER TO postgres;

--
-- Name: licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.licenses_id_seq OWNED BY public.licenses.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    content character varying(255),
    seen boolean DEFAULT false NOT NULL,
    sender_id bigint,
    receiver_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    notifications_type_id bigint
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: notifications_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications_type (
    id bigint NOT NULL,
    type character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.notifications_type OWNER TO postgres;

--
-- Name: notifications_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notifications_type_id_seq OWNER TO postgres;

--
-- Name: notifications_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_type_id_seq OWNED BY public.notifications_type.id;


--
-- Name: planified; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.planified (
    id bigint NOT NULL,
    description character varying(255),
    dt_start timestamp(0) without time zone,
    period integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    attributor_id integer,
    contributor_id integer,
    project_id integer,
    estimated_duration integer,
    without_control boolean DEFAULT false
);


ALTER TABLE public.planified OWNER TO postgres;

--
-- Name: planified_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.planified_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planified_id_seq OWNER TO postgres;

--
-- Name: planified_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.planified_id_seq OWNED BY public.planified.id;


--
-- Name: priorities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.priorities (
    id bigint NOT NULL,
    title character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.priorities OWNER TO postgres;

--
-- Name: priorities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.priorities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.priorities_id_seq OWNER TO postgres;

--
-- Name: priorities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.priorities_id_seq OWNED BY public.priorities.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    title character varying(255),
    description character varying(255),
    progression integer,
    date_start date,
    date_end date,
    estimated_duration integer,
    performed_duration integer,
    deadline date,
    active_client_id bigint,
    status_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    board_id bigint
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: record_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_types (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.record_types OWNER TO postgres;

--
-- Name: record_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.record_types_id_seq OWNER TO postgres;

--
-- Name: record_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_types_id_seq OWNED BY public.record_types.id;


--
-- Name: request_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.request_type (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.request_type OWNER TO postgres;

--
-- Name: request_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.request_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.request_type_id_seq OWNER TO postgres;

--
-- Name: request_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.request_type_id_seq OWNED BY public.request_type.id;


--
-- Name: rights_clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rights_clients (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.rights_clients OWNER TO postgres;

--
-- Name: rights_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rights_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rights_clients_id_seq OWNER TO postgres;

--
-- Name: rights_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rights_clients_id_seq OWNED BY public.rights_clients.id;


--
-- Name: rights_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rights_id_seq OWNER TO postgres;

--
-- Name: rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rights_id_seq OWNED BY public.rights.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: softwares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.softwares (
    id bigint NOT NULL,
    title character varying(255),
    company_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.softwares OWNER TO postgres;

--
-- Name: softwares_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.softwares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.softwares_id_seq OWNER TO postgres;

--
-- Name: softwares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.softwares_id_seq OWNED BY public.softwares.id;


--
-- Name: stages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stages (
    id bigint NOT NULL,
    name character varying(255),
    board_id bigint NOT NULL,
    status_id bigint,
    "position" integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.stages OWNER TO postgres;

--
-- Name: stages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stages_id_seq OWNER TO postgres;

--
-- Name: stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stages_id_seq OWNED BY public.stages.id;


--
-- Name: statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statuses (
    id bigint NOT NULL,
    title character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.statuses OWNER TO postgres;

--
-- Name: statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.statuses_id_seq OWNER TO postgres;

--
-- Name: statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.statuses_id_seq OWNED BY public.statuses.id;


--
-- Name: task_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_records (
    id bigint NOT NULL,
    date date,
    task_id bigint,
    user_id bigint,
    start timestamp(0) without time zone,
    "end" timestamp(0) without time zone,
    duration integer,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    record_type bigint
);


ALTER TABLE public.task_records OWNER TO postgres;

--
-- Name: task_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_records_id_seq OWNER TO postgres;

--
-- Name: task_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_records_id_seq OWNED BY public.task_records.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    title character varying(255),
    progression integer,
    date_start date,
    date_end date,
    estimated_duration integer,
    performed_duration integer,
    deadline date,
    parent_id bigint,
    project_id bigint,
    contributor_id bigint,
    status_id bigint,
    priority_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    attributor_id bigint,
    achieved_at timestamp(0) without time zone,
    hidden boolean DEFAULT false,
    without_control boolean DEFAULT false,
    description text,
    is_major boolean DEFAULT false,
    clients_request_id bigint
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Name: tasks_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks_history (
    id bigint NOT NULL,
    task_id bigint,
    intervener_id bigint,
    tracing_date timestamp(0) without time zone,
    status_from_id bigint,
    status_to_id bigint,
    reason character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.tasks_history OWNER TO postgres;

--
-- Name: tasks_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_history_id_seq OWNER TO postgres;

--
-- Name: tasks_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_history_id_seq OWNED BY public.tasks_history.id;


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO postgres;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: tool_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tool_groups (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    company_id bigint
);


ALTER TABLE public.tool_groups OWNER TO postgres;

--
-- Name: tool_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tool_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tool_groups_id_seq OWNER TO postgres;

--
-- Name: tool_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tool_groups_id_seq OWNED BY public.tool_groups.id;


--
-- Name: tools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tools (
    id bigint NOT NULL,
    name character varying(255),
    tool_group_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.tools OWNER TO postgres;

--
-- Name: tools_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tools_id_seq OWNER TO postgres;

--
-- Name: tools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tools_id_seq OWNED BY public.tools.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_clients ALTER COLUMN id SET DEFAULT nextval('public.active_clients_id_seq'::regclass);


--
-- Name: assist_contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assist_contracts ALTER COLUMN id SET DEFAULT nextval('public.assist_contracts_id_seq'::regclass);


--
-- Name: boards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boards ALTER COLUMN id SET DEFAULT nextval('public.boards_id_seq'::regclass);


--
-- Name: cards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards ALTER COLUMN id SET DEFAULT nextval('public.cards_id_seq'::regclass);


--
-- Name: clients_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients_requests ALTER COLUMN id SET DEFAULT nextval('public.clients_requests_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: contributor_functions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributor_functions ALTER COLUMN id SET DEFAULT nextval('public.contributor_functions_id_seq'::regclass);


--
-- Name: editors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editors ALTER COLUMN id SET DEFAULT nextval('public.editors_id_seq'::regclass);


--
-- Name: licenses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.licenses ALTER COLUMN id SET DEFAULT nextval('public.licenses_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: notifications_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications_type ALTER COLUMN id SET DEFAULT nextval('public.notifications_type_id_seq'::regclass);


--
-- Name: planified id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planified ALTER COLUMN id SET DEFAULT nextval('public.planified_id_seq'::regclass);


--
-- Name: priorities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priorities ALTER COLUMN id SET DEFAULT nextval('public.priorities_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: record_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types ALTER COLUMN id SET DEFAULT nextval('public.record_types_id_seq'::regclass);


--
-- Name: request_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_type ALTER COLUMN id SET DEFAULT nextval('public.request_type_id_seq'::regclass);


--
-- Name: rights id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rights ALTER COLUMN id SET DEFAULT nextval('public.rights_id_seq'::regclass);


--
-- Name: rights_clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rights_clients ALTER COLUMN id SET DEFAULT nextval('public.rights_clients_id_seq'::regclass);


--
-- Name: softwares id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.softwares ALTER COLUMN id SET DEFAULT nextval('public.softwares_id_seq'::regclass);


--
-- Name: stages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stages ALTER COLUMN id SET DEFAULT nextval('public.stages_id_seq'::regclass);


--
-- Name: statuses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statuses ALTER COLUMN id SET DEFAULT nextval('public.statuses_id_seq'::regclass);


--
-- Name: task_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_records ALTER COLUMN id SET DEFAULT nextval('public.task_records_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: tasks_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history ALTER COLUMN id SET DEFAULT nextval('public.tasks_history_id_seq'::regclass);


--
-- Name: tool_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_groups ALTER COLUMN id SET DEFAULT nextval('public.tool_groups_id_seq'::regclass);


--
-- Name: tools id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools ALTER COLUMN id SET DEFAULT nextval('public.tools_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: active_clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.active_clients (id, user_id, company_id, inserted_at, updated_at, rights_clients_id) FROM stdin;
38	149	10	2023-11-03 11:11:07	2023-11-03 11:11:07	1
39	150	11	2023-11-06 13:22:15	2023-11-06 13:22:15	1
\.


--
-- Data for Name: assist_contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assist_contracts (id, title, date_start, date_end, company_id, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: boards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boards (id, name, inserted_at, updated_at) FROM stdin;
86	ZEOP	2023-11-03 10:38:19	2023-11-03 10:38:19
87	MADAPLAST	2023-11-03 10:39:59	2023-11-03 10:39:59
88	Project monitoring 	2023-11-06 13:24:10	2023-11-06 13:24:10
89	Project monitoring 	2023-11-06 13:25:00	2023-11-06 13:25:00
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, name, stage_id, "position", inserted_at, updated_at, task_id) FROM stdin;
1337	Tableau BOn de production	428	0	2023-11-03 11:31:52	2023-11-06 07:23:58	1359
1339	Correction du bug concernant les historiques des tâches 	436	0	2023-11-06 13:31:21	2023-11-06 13:31:21	1361
1340	Correction du bug concernant les historiques des tâches (design) 	436	1	2023-11-06 13:33:58	2023-11-06 13:33:58	1362
1338	debug modification d'une tâche 	438	0	2023-11-06 13:27:05	2023-11-06 13:37:55	1360
\.


--
-- Data for Name: clients_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients_requests (id, content, date_post, active_client_id, inserted_at, updated_at, title, seen, ongoing, done, file_urls, project_id, finished, date_seen, date_ongoing, date_done, date_finished, uuid, survey, is_urgent, tool_id, deadline, expectation, request_type_id) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, content, task_id, poster_id, inserted_at, updated_at, file_urls) FROM stdin;
\.


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.companies (id, name, inserted_at, updated_at, logo) FROM stdin;
10	Madaplast	2023-11-03 11:10:56	2023-11-03 11:10:56	images/company_logos/company_default_logo.png
11	MGBI	2023-11-06 13:19:24	2023-11-06 13:19:24	images/company_logos/company_default_logo.png
\.


--
-- Data for Name: contributor_functions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contributor_functions (id, title, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: editors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.editors (id, title, company_id, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: licenses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.licenses (id, title, date_start, date_end, company_id, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, content, seen, sender_id, receiver_id, inserted_at, updated_at, notifications_type_id) FROM stdin;
24717	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	127	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24718	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	130	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24719	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	132	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24720	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	135	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24721	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	136	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24722	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	144	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24723	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	145	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24724	Un projet du nom de MADAPLAST a été crée par Mathieu	f	138	131	2023-11-03 13:39:59	2023-11-03 13:39:59	5
24725	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	127	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24726	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	130	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24727	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	132	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24728	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	135	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24729	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	136	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24730	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	144	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24731	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	145	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24732	Tâche nouvellement créee du nom de Tableau BOn de production par Mathieu dans le projet MADAPLAST.	f	138	131	2023-11-03 14:31:52	2023-11-03 14:31:52	5
24734	Kevin a été assigné à la tâche Tableau BOn de production dans le projet MADAPLAST par Mathieu	f	138	127	2023-11-03 14:31:52	2023-11-03 14:31:52	6
24735	Kevin a été assigné à la tâche Tableau BOn de production dans le projet MADAPLAST par Mathieu	f	138	130	2023-11-03 14:31:52	2023-11-03 14:31:52	6
24736	Kevin a été assigné à la tâche Tableau BOn de production dans le projet MADAPLAST par Mathieu	f	138	132	2023-11-03 14:31:52	2023-11-03 14:31:52	6
24737	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	127	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24738	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	130	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24739	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	132	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24740	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	135	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24741	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	136	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24742	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	144	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24743	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	145	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24744	Tâche "Tableau BOn de production"\n          du projet MADAPLAST mise dans " En cours " par Mathieu	f	138	131	2023-11-03 14:32:00	2023-11-03 14:32:00	1
24745	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	127	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24746	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	130	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24747	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	132	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24748	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	135	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24749	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	136	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24750	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	138	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24751	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	144	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24752	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	145	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24753	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par Kevin	f	139	131	2023-11-06 10:21:01	2023-11-06 10:21:01	1
24733	Kevin a été assigné à la tâche Tableau BOn de production dans le projet MADAPLAST par Mathieu	t	138	139	2023-11-03 11:31:52	2023-11-03 11:31:52	6
24754	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	127	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24755	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	130	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24756	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	132	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24757	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	135	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24758	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	136	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24759	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	138	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24760	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	144	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24761	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	145	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24762	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par Kevin	f	139	131	2023-11-06 10:23:58	2023-11-06 10:23:58	1
24763	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	127	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24764	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	130	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24765	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	132	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24766	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	135	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24767	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	136	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24768	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	138	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24769	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	144	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24770	Un projet du nom de Project monitoring  a été crée par Hasina	f	131	145	2023-11-06 16:25:00	2023-11-06 16:25:00	5
24771	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	127	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24772	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	130	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24773	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	132	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24774	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	135	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24775	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	136	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24776	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	138	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24777	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	144	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24778	Tâche nouvellement créee du nom de debug modification d'une tâche  par Hasina dans le projet Project monitoring .	f	131	145	2023-11-06 16:27:05	2023-11-06 16:27:05	5
24779	Anja a été assigné à la tâche debug modification d'une tâche  dans le projet Project monitoring  par Hasina	f	131	133	2023-11-06 13:27:05	2023-11-06 13:27:05	6
24780	Anja a été assigné à la tâche debug modification d'une tâche  dans le projet Project monitoring  par Hasina	f	131	127	2023-11-06 16:27:05	2023-11-06 16:27:05	6
24781	Anja a été assigné à la tâche debug modification d'une tâche  dans le projet Project monitoring  par Hasina	f	131	130	2023-11-06 16:27:05	2023-11-06 16:27:05	6
24782	Anja a été assigné à la tâche debug modification d'une tâche  dans le projet Project monitoring  par Hasina	f	131	132	2023-11-06 16:27:05	2023-11-06 16:27:05	6
24783	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	127	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24784	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	130	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24785	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	132	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24786	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	135	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24787	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	136	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24788	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	138	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24790	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	f	131	145	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24791	Loïc a été assigné à la tâche Correction du bug concernant les historiques des tâches  dans le projet Project monitoring  par Hasina	f	131	134	2023-11-06 13:31:21	2023-11-06 13:31:21	6
24792	Loïc a été assigné à la tâche Correction du bug concernant les historiques des tâches  dans le projet Project monitoring  par Hasina	f	131	127	2023-11-06 16:31:21	2023-11-06 16:31:21	6
24793	Loïc a été assigné à la tâche Correction du bug concernant les historiques des tâches  dans le projet Project monitoring  par Hasina	f	131	130	2023-11-06 16:31:21	2023-11-06 16:31:21	6
24794	Loïc a été assigné à la tâche Correction du bug concernant les historiques des tâches  dans le projet Project monitoring  par Hasina	f	131	132	2023-11-06 16:31:21	2023-11-06 16:31:21	6
24795	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	127	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24796	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	130	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24797	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	132	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24798	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	135	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24799	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	136	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24800	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	138	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24802	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	f	131	145	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24803	Antonio a été assigné à la tâche Correction du bug concernant les historiques des tâches (design)  dans le projet Project monitoring  par Hasina	f	131	128	2023-11-06 13:33:58	2023-11-06 13:33:58	6
24815	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	127	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24816	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	130	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24817	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	132	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24818	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	135	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24819	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	136	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24820	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	138	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24822	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	f	131	145	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24821	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Hasina	t	131	144	2023-11-06 16:37:55	2023-11-06 16:37:55	1
24804	Antonio a été assigné à la tâche Correction du bug concernant les historiques des tâches (design)  dans le projet Project monitoring  par Hasina	f	131	127	2023-11-06 16:33:58	2023-11-06 16:33:58	6
24805	Antonio a été assigné à la tâche Correction du bug concernant les historiques des tâches (design)  dans le projet Project monitoring  par Hasina	f	131	130	2023-11-06 16:33:58	2023-11-06 16:33:58	6
24806	Antonio a été assigné à la tâche Correction du bug concernant les historiques des tâches (design)  dans le projet Project monitoring  par Hasina	f	131	132	2023-11-06 16:33:58	2023-11-06 16:33:58	6
24807	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	127	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24808	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	130	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24809	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	132	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24810	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	135	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24811	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	136	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24812	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	138	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24814	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	f	131	145	2023-11-06 16:37:27	2023-11-06 16:37:27	1
24789	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches  par Hasina dans le projet Project monitoring .	t	131	144	2023-11-06 16:31:21	2023-11-06 16:31:21	5
24801	Tâche nouvellement créee du nom de Correction du bug concernant les historiques des tâches (design)  par Hasina dans le projet Project monitoring .	t	131	144	2023-11-06 16:33:58	2023-11-06 16:33:58	5
24813	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Hasina	t	131	144	2023-11-06 16:37:27	2023-11-06 16:37:27	1
\.


--
-- Data for Name: notifications_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications_type (id, type, inserted_at, updated_at) FROM stdin;
1	moved	2022-07-01 09:25:46	2022-07-01 09:25:46
2	archived	2022-07-01 09:25:46	2022-07-01 09:25:46
3	deleted	2022-07-01 09:25:46	2022-07-01 09:25:46
4	achieved	2022-07-01 09:25:46	2022-07-01 09:25:46
5	created	2022-07-01 09:25:46	2022-07-01 09:25:46
6	assigned	2022-07-01 09:25:46	2022-07-01 09:25:46
7	updated	2022-07-01 09:25:46	2022-07-01 09:25:46
8	requested	2022-07-01 09:25:46	2022-07-01 09:25:46
\.


--
-- Data for Name: planified; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.planified (id, description, dt_start, period, inserted_at, updated_at, attributor_id, contributor_id, project_id, estimated_duration, without_control) FROM stdin;
\.


--
-- Data for Name: priorities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.priorities (id, title, inserted_at, updated_at) FROM stdin;
1	Faible	2021-04-27 18:58:50	2021-04-27 18:58:50
2	Moyenne	2021-04-27 18:59:00	2021-04-27 18:59:09
3	Importante	2021-04-27 18:59:28	2021-04-27 18:59:28
4	Urgente	2021-04-27 18:59:40	2021-04-27 18:59:40
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, title, description, progression, date_start, date_end, estimated_duration, performed_duration, deadline, active_client_id, status_id, inserted_at, updated_at, board_id) FROM stdin;
69	MADAPLAST	Tableau et Reporting	0	2023-11-03	\N	100	0	2024-12-31	38	3	2023-11-03 10:39:59	2023-11-03 11:31:52	87
70	Project monitoring 	Correction des bugs et refonte des designs 	0	2023-11-06	\N	40	0	2023-11-10	39	3	2023-11-06 13:25:00	2023-11-06 13:33:58	89
\.


--
-- Data for Name: record_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.record_types (id, name, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: request_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.request_type (id, name, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: rights; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rights (id, title, inserted_at, updated_at) FROM stdin;
1	Admin	2021-03-24 07:25:41	2021-03-24 07:25:41
3	Contributeur	2021-03-28 20:23:20	2021-03-28 20:23:20
2	Attributeur	2021-04-13 07:55:29	2021-04-13 07:55:29
4	Client	2021-03-28 17:28:09	2021-03-28 17:28:09
5	Non attribué	2021-04-01 20:21:54	2021-04-01 20:21:54
100	Archivé(e)	2021-04-13 08:24:10	2021-04-13 08:24:10
\.


--
-- Data for Name: rights_clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rights_clients (id, name, inserted_at, updated_at) FROM stdin;
1	Administrateur	2023-03-27 15:28:25	2023-03-27 15:28:25
2	Demandeur	2023-03-27 15:28:31	2023-03-27 15:28:31
3	Utilisateur	2023-03-27 15:28:37	2023-03-27 15:28:37
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20210324072043	2021-03-24 07:21:45
20210324143626	2021-03-24 14:36:51
20210326102201	2021-03-26 10:24:36
20210413124124	2021-04-13 12:42:49
20210414120533	2021-04-14 12:06:36
20210414120935	2021-04-14 12:09:54
20210414132353	2021-04-14 13:24:22
20210414132720	2021-04-14 13:27:54
20210415065852	2021-04-15 06:59:48
20210415071440	2021-04-15 07:15:55
20210426095303	2021-04-26 09:54:09
20210426100413	2021-04-26 10:06:28
20210426101246	2021-04-26 10:13:17
20210426101752	2021-04-26 10:20:09
20210426102215	2021-04-26 10:24:28
20210428121839	2021-04-28 12:20:11
20210428122039	2021-04-28 12:21:49
20210428172927	2021-04-28 17:30:21
20210429061512	2021-04-29 06:17:16
20210514105447	2021-05-14 10:56:17
20210518110212	2021-05-18 11:04:23
20210527155705	2021-05-27 16:12:41
20210602180040	2021-06-02 18:03:01
20210602183517	2021-06-02 18:35:57
20210602190601	2021-06-02 19:06:19
20210602213717	2021-06-02 21:37:34
20210603161444	2021-06-03 16:17:57
20210603162215	2021-06-03 16:24:08
20210607111124	2021-06-07 11:16:10
20210608201833	2021-06-08 20:19:53
20210616083854	2021-06-16 08:40:13
20210831074824	2021-08-31 07:48:46
20210930165500	2021-09-30 16:55:29
20211001070528	2021-10-01 08:10:54
20220328070453	2022-04-15 17:06:03
20220602120914	2022-07-01 07:34:08
20220628124706	2022-07-01 07:34:09
20220628125001	2022-07-01 07:34:09
20220912134511	2022-09-15 11:56:05
20220913080825	2022-09-15 11:56:05
20220923075047	2022-09-28 11:37:32
20220923080323	2022-09-28 11:37:32
20220923082200	2022-09-28 11:37:32
20220928075835	2022-09-28 11:37:32
20220928085527	2022-09-28 11:37:32
20221011111947	2022-10-12 12:03:55
20221110085834	2023-06-13 18:00:18
20221110090536	2023-06-13 18:00:18
20221128083552	2023-06-13 18:00:18
20221128084419	2023-06-13 18:00:18
20221130075142	2023-06-13 18:00:18
20221130083336	2023-06-13 18:00:18
20221208122643	2023-06-13 18:00:18
20221208122931	2023-06-13 18:00:18
20230327051127	2023-06-13 18:00:18
20230327051415	2023-06-13 18:00:18
20230327071139	2023-06-13 18:00:18
20230327071301	2023-06-13 18:00:18
20230327074532	2023-06-13 18:00:18
20230327083150	2023-06-13 18:00:18
20230327090518	2023-06-13 18:00:18
20230327103652	2023-06-13 18:00:18
20230328082146	2023-06-13 18:00:18
20230328082752	2023-06-13 18:00:18
20230328083349	2023-06-13 18:00:18
20230330071842	2023-06-13 18:00:18
20230330072448	2023-06-13 18:00:18
20230330073328	2023-06-13 18:00:18
20230330104853	2023-06-13 18:00:18
20230330104932	2023-06-13 18:00:18
20230330105133	2023-06-13 18:00:18
20230330105249	2023-06-13 18:00:18
20230330192045	2023-06-13 18:00:18
\.


--
-- Data for Name: softwares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.softwares (id, title, company_id, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: stages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stages (id, name, board_id, status_id, "position", inserted_at, updated_at) FROM stdin;
421	A faire	86	1	0	2023-11-03 10:38:19	2023-11-03 10:38:19
422	En blocage	86	2	1	2023-11-03 10:38:19	2023-11-03 10:38:19
423	En cours	86	3	2	2023-11-03 10:38:19	2023-11-03 10:38:19
424	En contrôle	86	4	3	2023-11-03 10:38:19	2023-11-03 10:38:19
425	Achevée(s)	86	5	4	2023-11-03 10:38:19	2023-11-03 10:38:19
426	A faire	87	1	0	2023-11-03 10:39:59	2023-11-03 10:39:59
427	En blocage	87	2	1	2023-11-03 10:39:59	2023-11-03 10:39:59
428	En cours	87	3	2	2023-11-03 10:39:59	2023-11-03 10:39:59
429	En contrôle	87	4	3	2023-11-03 10:39:59	2023-11-03 10:39:59
430	Achevée(s)	87	5	4	2023-11-03 10:39:59	2023-11-03 10:39:59
431	A faire	88	1	0	2023-11-06 13:24:10	2023-11-06 13:24:10
432	En blocage	88	2	1	2023-11-06 13:24:10	2023-11-06 13:24:10
433	En cours	88	3	2	2023-11-06 13:24:10	2023-11-06 13:24:10
434	En contrôle	88	4	3	2023-11-06 13:24:10	2023-11-06 13:24:10
435	Achevée(s)	88	5	4	2023-11-06 13:24:10	2023-11-06 13:24:10
436	A faire	89	1	0	2023-11-06 13:25:00	2023-11-06 13:25:00
437	En blocage	89	2	1	2023-11-06 13:25:00	2023-11-06 13:25:00
438	En cours	89	3	2	2023-11-06 13:25:00	2023-11-06 13:25:00
439	En contrôle	89	4	3	2023-11-06 13:25:00	2023-11-06 13:25:00
440	Achevée(s)	89	5	4	2023-11-06 13:25:00	2023-11-06 13:25:00
\.


--
-- Data for Name: statuses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.statuses (id, title, inserted_at, updated_at) FROM stdin;
1	A faire	2021-04-27 18:47:25	2021-04-27 18:47:25
3	En cours	2021-04-27 18:47:50	2021-04-27 18:47:50
4	En contrôle	2021-04-27 18:48:15	2021-04-27 18:48:15
5	Achevée(s)	2021-04-27 18:49:44	2021-04-27 18:49:44
2	En blocage	2021-04-27 18:47:36	2021-04-27 18:47:36
\.


--
-- Data for Name: task_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_records (id, date, task_id, user_id, start, "end", duration, inserted_at, updated_at, record_type) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, title, progression, date_start, date_end, estimated_duration, performed_duration, deadline, parent_id, project_id, contributor_id, status_id, priority_id, inserted_at, updated_at, attributor_id, achieved_at, hidden, without_control, description, is_major, clients_request_id) FROM stdin;
1359	Tableau Bon de production	0	2023-11-03	\N	2400	0	2023-11-10	\N	69	139	3	2	2023-11-03 14:31:52	2023-11-06 10:23:58	138	\N	f	f	 	t	\N
1361	Correction du bug concernant les historiques des tâches 	0	2023-11-06	\N	900	0	2023-11-09	\N	70	134	1	2	2023-11-06 16:31:21	2023-11-06 16:32:51	131	\N	f	f	\N	f	\N
1362	Correction du bug concernant les historiques des tâches (design) 	0	2023-11-06	\N	480	0	2023-11-08	\N	70	128	1	2	2023-11-06 16:33:58	2023-11-06 13:33:58	131	\N	f	f	 	f	\N
1360	debug modification d'une tâche 	9	2023-11-06	\N	300	8	2023-11-07	\N	70	133	3	2	2023-11-06 16:27:05	2023-11-06 16:37:55	131	\N	f	f	Correction pour la modification d'une tâche (fonctionnalité) 	f	\N
\.


--
-- Data for Name: tasks_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks_history (id, task_id, intervener_id, tracing_date, status_from_id, status_to_id, reason, inserted_at, updated_at) FROM stdin;
70	1359	138	\N	1	3	\N	2023-11-03 11:32:00	2023-11-03 11:32:00
72	1359	139	\N	2	3	\N	2023-11-06 07:23:58	2023-11-06 07:23:58
71	1359	139	\N	3	2	\N	2023-11-06 07:21:01	2023-11-06 10:24:09
74	1360	131	\N	2	3	\N	2023-11-06 13:37:55	2023-11-06 13:37:55
73	1360	131	\N	3	2	test	2023-11-06 13:37:27	2023-11-06 16:38:01
\.


--
-- Data for Name: tool_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tool_groups (id, name, inserted_at, updated_at, company_id) FROM stdin;
1	Développement	2023-03-27 08:17:04	2023-03-27 08:17:04	1
2	Comptabilité	2023-03-27 08:17:12	2023-03-27 08:17:12	1
\.


--
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tools (id, name, tool_group_id, inserted_at, updated_at) FROM stdin;
1	Dev1	1	2023-03-27 08:18:30	2023-03-27 08:18:30
2	Cpt1	2	2023-03-27 08:18:45	2023-03-27 08:18:45
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, profile_picture, email, password, right_id, inserted_at, updated_at, function_id, current_record_id) FROM stdin;
127	PhidiaAdmin	images/profiles/default_profile_pic.png	admin@phidia.fr	$pbkdf2-sha512$160000$qYXqo7xGffhtWNDSUvGkzw$HRg2OzQx72prVVNutxWehCZ9zXfGO2q5ihIiYxx8MCEcyi2rNja90Y0Iz.WzRQMn0jW/L8slRXoMbGMce9cT3A	1	2023-11-02 07:37:53	2023-11-02 07:37:53	\N	\N
128	Antonio	images/profiles/default_profile_pic.png	midorimaantonio@gmail.com	$pbkdf2-sha512$160000$zLwxw9uG85asYvPw64J9ig$jb2rTldkWaeYU2HUd5.yJHi15Iv.ofV39Wi44/8DmcPDSQs4Mm22SJa6FDu/SMABm6xyCSkk4DpUasRMgY3gww	3	2023-11-03 05:51:32	2023-11-03 05:52:05	\N	\N
129	Alain	images/profiles/default_profile_pic.png	alain@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$kmeC/LM0Q4vJThzXhExrvQ$22LXv27pq/gcqbzBtAGYxh6gSX66GDeFrtsROggEnP5S5sMiqK54aILFPLbmXFXkooTGWKemnYQoWlfRHMF39Q	3	2023-11-03 06:12:01	2023-11-03 06:12:55	\N	\N
130	Philippe	images/profiles/default_profile_pic.png	pp@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$0rU6Xiw1KpHw4mz1UW0XKQ$WU6dt9Ci6M/0337DOyxuGwgaj4fQrTrxg2GBDQJhcHJCZRgaIyJNqlvSzuP47R4RkkbH9EG.gf352So1X0I54w	1	2023-11-03 06:13:47	2023-11-03 06:13:56	\N	\N
135	Ioly	images/profiles/default_profile_pic.png	ioly@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$z4FlAop14L2ddUMFTrM83A$baXkm2GHyCHumNPgCFcyA897./pS0u0Rpi3edMt56031yn30vniFzQWlqZHNgTfomF5jpBxUpmWO830ETb4mBQ	2	2023-11-03 06:19:45	2023-11-03 06:20:00	\N	\N
134	Loïc	images/profiles/default_profile_pic.png	loicRavelo05@gmail.com	$pbkdf2-sha512$160000$l5tsXJ5Nh6KlI.wBtw1EcA$55SsZaP9mruiOQQ8Na3oVC.i1/zzg8ruKI1HoW14FXwnGVGE1asjBVU1oNVXVLOsWF0rxBJxVm2y647VLswn8g	3	2023-11-03 06:19:17	2023-11-03 06:20:16	\N	\N
136	Matthieu	images/profiles/default_profile_pic.png	matthieu@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$lU3If.N3XEepbGV3atTj1Q$d9q1CuBONUAHKF1sKPM6sk6LVZiwoj6kLJrLp4PFIYaJr4BuS2HellNvjc4kPwT.TRFXwr84MF2l/EdYWI.0TA	2	2023-11-03 06:20:57	2023-11-03 06:21:10	\N	\N
137	Fanilo	images/profiles/default_profile_pic.png	fanilomampionona@outlook.fr	$pbkdf2-sha512$160000$PG/euuhiSQgtOX8fOZwzvg$rbUsL.DIdjngzAl40VQbQP3S2IeAUMe/wdkgBdZB0oMmWwi4iAwZuJNc2Hac.uX67mD1.BWzxe5tEXSQvwWoeA	3	2023-11-03 06:21:19	2023-11-03 06:21:31	\N	\N
138	Mathieu	images/profiles/default_profile_pic.png	mathieu@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$6TO7SjTTGZi4EexSW/XRKw$ckdwJwgIdr8GQDZywJOpyDCwHxAA7rlMvVJ8mtVwBTaETqDYch2dU7q3aGTgN5ijrkQD5eJ.DRtGEvwWqkw57g	2	2023-11-03 06:22:00	2023-11-03 06:22:13	\N	\N
139	Kevin	images/profiles/default_profile_pic.png	kevinnandrianina@outlook.fr	$pbkdf2-sha512$160000$d6nbG44aFNlBeyA4U.BYVQ$3hjP2OoN4W4nT.15.Qny6JHc6HI4xzjHjTTSCrY8jYvNkmgyY0yGPgEapv6Mq.tAPdPqN7JqTHp4JVyTIX9QqA	3	2023-11-03 06:22:56	2023-11-03 06:23:07	\N	\N
140	Mirindra	images/profiles/default_profile_pic.png	mirindra@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$0NS6huBhte/3hgn2R7R9fg$77DqRSKANd4MNKAokkc5xNTDRKf8WgR6W3NdXBjipVtKFqg3P17nZdF1rJzU29CcwvtREPxIfAkQrPsUYUvwvQ	3	2023-11-03 06:24:15	2023-11-03 06:24:38	\N	\N
141	Adrien	images/profiles/default_profile_pic.png	herilanto.adrien@outlook.com	$pbkdf2-sha512$160000$0ezLe9rJMAkPERHRgdQ9yQ$ub.mwOLVKdFH1ZUYD.XnmbNlBiRZZIY9KKIatQiSIxdC4Wd4am5masYnXrdEchoWc08Y4ZEnfAwzS1J6XRsPIg	3	2023-11-03 06:25:00	2023-11-03 06:25:27	\N	\N
143	Mickaël	images/profiles/default_profile_pic.png	raz.lovatiana@gmail.com	$pbkdf2-sha512$160000$bv7A8fUK56U661M/QtLqHg$ZYgqbTD4Lw9vWeq5R2tkS7ZzSiHwOoU4qR7qAtqF6.LGJsjTKXGJ3JEQjAWj6ulLOPifDj0JTMOe65XeeWv6kQ	3	2023-11-03 06:28:18	2023-11-03 06:28:39	\N	\N
144	Ny Toky	images/profiles/default_profile_pic.png	nytoky@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$c7b5Ivd7i76BGGtS4j.c.Q$ptIeLXAtBE3fqufztkiIi2FPxBhpVjfgTCxhynMjVsYlSwrjrLebY4XONcxLXpukw1knQ8jXzcmSjsYSYhvJqQ	2	2023-11-03 06:28:31	2023-11-03 06:28:46	\N	\N
145	Frederick	images/profiles/default_profile_pic.png	frederick@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$pJEKSSYrDBPLrVgpk.JJcg$JvkGcrkqOioQ059u1L5WIfsCv5SZlQ7fMkNBoV2FYsRVRUUeOgGs1Q4K7IaGyNp0057B9r7akzTDjqBLKlbWjg	2	2023-11-03 06:29:55	2023-11-03 06:30:13	\N	\N
146	Miandrisoa	images/profiles/default_profile_pic.png	miandrisoa@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$8jxXqAn0M7aduipHcE9NdA$r4GZBDuH7MKO11vD57Rs7mUIhhkaapNRm.ChDgDVXFIT4ga74WtiSyRb6d2LgG4gKQVoDTlWruZtfO60amAp8g	3	2023-11-03 06:31:02	2023-11-03 06:31:22	\N	\N
147	Koloina	images/profiles/default_profile_pic.png	koloina@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$h0DRlerGOtQvPrH7Gdr8XQ$U8Wdgzd4drDf0rUBVOC2LPCfIiVN7Wp2c7L1YZh.GGrKNBWqRd4Rks6Bif8ObFIdiongSZCaq7/iJPbsPfIRHA	3	2023-11-03 06:32:09	2023-11-03 06:32:22	\N	\N
148	Mickaella	images/profiles/default_profile_pic.png	bidmicks@outlook.fr	$pbkdf2-sha512$160000$wTbVruYmhAwD4VLYbK5q7g$xiXL1m81SKmLjGNaHg0vCcebTYcPYLN6UQDowwm7jYIbW1jrEPbnrxy6lHAZRJGeQCXlYayqsAYlKkKGfTOJug	3	2023-11-03 06:33:06	2023-11-03 06:33:16	\N	\N
133	Anja	images/profiles/Anja-profile.jpg	anjaranaivo464@gmail.com	$pbkdf2-sha512$160000$C2uPZxk/z4gRi.Dw1/f9tg$NQLRTZ7Z7oQlkWtIp7yThdXfhF3ZdQ1QuQaKDKCo4CRx2xiNGS3QGq96L8xFSz8r3dF5a.ZICz313/B/K3RCyw	3	2023-11-03 06:16:56	2023-11-03 06:35:40	\N	\N
132	Tahina	images/profiles/default_profile_pic.png	tahina@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$h5MSqLTJabD262b/IHHQyg$5WornfQxwZ1Vy3X31eHl81TLUld2kv.aua1JU/YKh8QCYTSsBOCDduQBeJC7oSOeo9vZAXo7Hw9EzayQFshAoQ	1	2023-11-03 06:16:14	2023-11-07 07:20:49	\N	\N
131	Hasina	images/profiles/Hasina-profile.jpeg	olyviahasina.razakamanantsoa@gmail.com	$pbkdf2-sha512$160000$v/vTJg6fPAj7Dfgn1HxkWQ$PmEfbIVojrBFpR29vmdZZTfo6G3rH6t5SstXx0vF/A3.n93BaABIaKWcmQWZaPa4PqtLCID8A.kk9eutYi3Ksw	2	2023-11-03 06:15:03	2023-11-03 06:36:57	\N	\N
149	Madaplast	images/profiles/default_profile_pic.png	madaplast@madaplast.mg	$pbkdf2-sha512$160000$XSnPJiOY/ecRZSsannsOqg$Y2cxBXfrPN1GBiZPCPQTmMWBFQIDCxeV5mFj96VOJcpksY5MRJ7qd//k/QKFDevtOTxVwhZGreOVDnFjZCsOPA	4	2023-11-03 11:10:12	2023-11-03 11:10:30	\N	\N
142	Hassan	images/profiles/Hassan-profile.jpg	razorhassan@outlook.be	$pbkdf2-sha512$160000$577vPwHx9OZW1kcroL70cg$IbQm2Xh/tPS28tERUoU4Fz43ISBHiv9kdiy33Uw0v0yBLiT3pJVvcb0okNrqNtJz2ypCNe8piIB/5Tj590TkLQ	3	2023-11-03 06:26:57	2023-11-06 07:21:52	\N	\N
150	MGBI	images/profiles/default_profile_pic.png	mgbi.adm@gmail.com	$pbkdf2-sha512$160000$4Y11FezPryYhyC1.V4wnag$dLBzY8G3qH43cbRuzEiAIDOW21JpPvtUgyuUkkhvrYY6YLt6gO7RrYtZpXaKz6tQ34TLV4oqsH3hVMYxWikIWw	4	2023-11-06 13:22:15	2023-11-06 13:22:15	\N	\N
\.


--
-- Name: active_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_clients_id_seq', 39, true);


--
-- Name: assist_contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assist_contracts_id_seq', 11, true);


--
-- Name: base_cache_signaling; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_cache_signaling', 1, true);


--
-- Name: base_registry_signaling; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.base_registry_signaling', 1, true);


--
-- Name: boards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boards_id_seq', 89, true);


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_id_seq', 1340, true);


--
-- Name: clients_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_requests_id_seq', 29, true);


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comments_id_seq', 151, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.companies_id_seq', 11, true);


--
-- Name: contributor_functions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contributor_functions_id_seq', 1, false);


--
-- Name: editors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.editors_id_seq', 13, true);


--
-- Name: licenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.licenses_id_seq', 6, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 24822, true);


--
-- Name: notifications_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_type_id_seq', 1, false);


--
-- Name: planified_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.planified_id_seq', 17, true);


--
-- Name: priorities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.priorities_id_seq', 4, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 70, true);


--
-- Name: record_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_types_id_seq', 1, false);


--
-- Name: request_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.request_type_id_seq', 1, false);


--
-- Name: rights_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rights_clients_id_seq', 1, false);


--
-- Name: rights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rights_id_seq', 31, true);


--
-- Name: softwares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.softwares_id_seq', 4, true);


--
-- Name: stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stages_id_seq', 440, true);


--
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statuses_id_seq', 5, true);


--
-- Name: task_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_records_id_seq', 1, false);


--
-- Name: tasks_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_history_id_seq', 74, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 1362, true);


--
-- Name: tool_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tool_groups_id_seq', 1, false);


--
-- Name: tools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tools_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 150, true);


--
-- Name: active_clients active_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_clients
    ADD CONSTRAINT active_clients_pkey PRIMARY KEY (id);


--
-- Name: assist_contracts assist_contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assist_contracts
    ADD CONSTRAINT assist_contracts_pkey PRIMARY KEY (id);


--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: clients_requests clients_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients_requests
    ADD CONSTRAINT clients_requests_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: contributor_functions contributor_functions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributor_functions
    ADD CONSTRAINT contributor_functions_pkey PRIMARY KEY (id);


--
-- Name: editors editors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editors
    ADD CONSTRAINT editors_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: notifications_type notifications_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications_type
    ADD CONSTRAINT notifications_type_pkey PRIMARY KEY (id);


--
-- Name: planified planified_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.planified
    ADD CONSTRAINT planified_pkey PRIMARY KEY (id);


--
-- Name: priorities priorities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.priorities
    ADD CONSTRAINT priorities_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: record_types record_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types
    ADD CONSTRAINT record_types_pkey PRIMARY KEY (id);


--
-- Name: request_type request_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_type
    ADD CONSTRAINT request_type_pkey PRIMARY KEY (id);


--
-- Name: rights_clients rights_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rights_clients
    ADD CONSTRAINT rights_clients_pkey PRIMARY KEY (id);


--
-- Name: rights rights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rights
    ADD CONSTRAINT rights_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: softwares softwares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.softwares
    ADD CONSTRAINT softwares_pkey PRIMARY KEY (id);


--
-- Name: stages stages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: statuses statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);


--
-- Name: task_records task_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_records
    ADD CONSTRAINT task_records_pkey PRIMARY KEY (id);


--
-- Name: tasks_history tasks_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: tool_groups tool_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_groups
    ADD CONSTRAINT tool_groups_pkey PRIMARY KEY (id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: active_clients_company_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX active_clients_company_id_index ON public.active_clients USING btree (company_id);


--
-- Name: active_clients_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX active_clients_user_id_index ON public.active_clients USING btree (user_id);


--
-- Name: assist_contracts_company_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assist_contracts_company_id_index ON public.assist_contracts USING btree (company_id);


--
-- Name: assist_contracts_title_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX assist_contracts_title_index ON public.assist_contracts USING btree (title);


--
-- Name: cards_position_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cards_position_index ON public.cards USING btree ("position");


--
-- Name: clients_requests_active_client_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX clients_requests_active_client_id_index ON public.clients_requests USING btree (active_client_id);


--
-- Name: clients_requests_title_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX clients_requests_title_index ON public.clients_requests USING btree (title);


--
-- Name: clients_requests_uuid_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX clients_requests_uuid_index ON public.clients_requests USING btree (uuid);


--
-- Name: comments_poster_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_poster_id_index ON public.comments USING btree (poster_id);


--
-- Name: comments_task_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comments_task_id_index ON public.comments USING btree (task_id);


--
-- Name: editors_company_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX editors_company_id_index ON public.editors USING btree (company_id);


--
-- Name: editors_title_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX editors_title_index ON public.editors USING btree (title);


--
-- Name: licenses_company_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX licenses_company_id_index ON public.licenses USING btree (company_id);


--
-- Name: licenses_title_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX licenses_title_index ON public.licenses USING btree (title);


--
-- Name: notifications_receiver_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_receiver_id_index ON public.notifications USING btree (receiver_id);


--
-- Name: notifications_sender_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX notifications_sender_id_index ON public.notifications USING btree (sender_id);


--
-- Name: projects_active_client_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_active_client_id_index ON public.projects USING btree (active_client_id);


--
-- Name: projects_status_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX projects_status_id_index ON public.projects USING btree (status_id);


--
-- Name: rights_title_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX rights_title_index ON public.rights USING btree (title);


--
-- Name: softwares_company_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX softwares_company_id_index ON public.softwares USING btree (company_id);


--
-- Name: softwares_title_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX softwares_title_index ON public.softwares USING btree (title);


--
-- Name: stages_position_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stages_position_index ON public.stages USING btree ("position");


--
-- Name: tasks_contributor_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_contributor_id_index ON public.tasks USING btree (contributor_id);


--
-- Name: tasks_parent_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_parent_id_index ON public.tasks USING btree (parent_id);


--
-- Name: tasks_priority_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_priority_id_index ON public.tasks USING btree (priority_id);


--
-- Name: tasks_project_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_project_id_index ON public.tasks USING btree (project_id);


--
-- Name: tasks_status_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tasks_status_id_index ON public.tasks USING btree (status_id);


--
-- Name: tools_tool_group_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tools_tool_group_id_index ON public.tools USING btree (tool_group_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_right_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_right_id_index ON public.users USING btree (right_id);


--
-- Name: users_username_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_username_index ON public.users USING btree (username);


--
-- Name: active_clients active_clients_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_clients
    ADD CONSTRAINT active_clients_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: active_clients active_clients_rights_clients_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_clients
    ADD CONSTRAINT active_clients_rights_clients_id_fkey FOREIGN KEY (rights_clients_id) REFERENCES public.rights_clients(id);


--
-- Name: active_clients active_clients_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.active_clients
    ADD CONSTRAINT active_clients_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: assist_contracts assist_contracts_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assist_contracts
    ADD CONSTRAINT assist_contracts_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: cards cards_stage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_stage_id_fkey FOREIGN KEY (stage_id) REFERENCES public.stages(id) ON DELETE CASCADE;


--
-- Name: cards cards_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: clients_requests clients_requests_active_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients_requests
    ADD CONSTRAINT clients_requests_active_client_id_fkey FOREIGN KEY (active_client_id) REFERENCES public.active_clients(id);


--
-- Name: clients_requests clients_requests_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients_requests
    ADD CONSTRAINT clients_requests_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: clients_requests clients_requests_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients_requests
    ADD CONSTRAINT clients_requests_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(id);


--
-- Name: clients_requests clients_requests_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients_requests
    ADD CONSTRAINT clients_requests_type_id_fkey FOREIGN KEY (request_type_id) REFERENCES public.request_type(id);


--
-- Name: comments comments_poster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_poster_id_fkey FOREIGN KEY (poster_id) REFERENCES public.users(id);


--
-- Name: comments comments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: editors editors_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editors
    ADD CONSTRAINT editors_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: licenses licenses_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: notifications notifications_notifications_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_notifications_type_id_fkey FOREIGN KEY (notifications_type_id) REFERENCES public.notifications_type(id);


--
-- Name: notifications notifications_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(id);


--
-- Name: notifications notifications_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: projects projects_active_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_active_client_id_fkey FOREIGN KEY (active_client_id) REFERENCES public.active_clients(id);


--
-- Name: projects projects_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id);


--
-- Name: projects projects_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id);


--
-- Name: softwares softwares_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.softwares
    ADD CONSTRAINT softwares_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: stages stages_board_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: stages stages_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id);


--
-- Name: task_records task_records_record_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_records
    ADD CONSTRAINT task_records_record_type_fkey FOREIGN KEY (record_type) REFERENCES public.record_types(id);


--
-- Name: task_records task_records_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_records
    ADD CONSTRAINT task_records_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: task_records task_records_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_records
    ADD CONSTRAINT task_records_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tasks tasks_attributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_attributor_id_fkey FOREIGN KEY (attributor_id) REFERENCES public.users(id);


--
-- Name: tasks tasks_clients_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_clients_request_id_fkey FOREIGN KEY (clients_request_id) REFERENCES public.clients_requests(id);


--
-- Name: tasks tasks_contributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_contributor_id_fkey FOREIGN KEY (contributor_id) REFERENCES public.users(id);


--
-- Name: tasks_history tasks_history_intervener_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_intervener_id_fkey FOREIGN KEY (intervener_id) REFERENCES public.users(id);


--
-- Name: tasks_history tasks_history_status_from_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_status_from_id_fkey FOREIGN KEY (status_from_id) REFERENCES public.statuses(id);


--
-- Name: tasks_history tasks_history_status_to_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_status_to_id_fkey FOREIGN KEY (status_to_id) REFERENCES public.statuses(id);


--
-- Name: tasks_history tasks_history_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history
    ADD CONSTRAINT tasks_history_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: tasks tasks_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_priority_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_priority_id_fkey FOREIGN KEY (priority_id) REFERENCES public.priorities(id);


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.statuses(id);


--
-- Name: tool_groups tool_groups_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tool_groups
    ADD CONSTRAINT tool_groups_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: tools tools_tool_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_tool_group_id_fkey FOREIGN KEY (tool_group_id) REFERENCES public.tool_groups(id);


--
-- Name: users users_function_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_function_id_fkey FOREIGN KEY (function_id) REFERENCES public.contributor_functions(id);


--
-- Name: users users_right_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_right_id_fkey FOREIGN KEY (right_id) REFERENCES public.rights(id);


--
-- PostgreSQL database dump complete
--

