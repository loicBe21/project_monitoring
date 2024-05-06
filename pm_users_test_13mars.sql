--
-- PostgreSQL database dump
--

-- Dumped from database version 14.11 (Ubuntu 14.11-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.11 (Ubuntu 14.11-0ubuntu0.22.04.1)

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
-- Name: count_child_tasks(integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.count_child_tasks(task_id integer, is_child boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  child_count INT;
BEGIN
  IF is_child THEN
    RETURN 0;
  ELSE
    SELECT COUNT(*) INTO child_count
    FROM tasks
    WHERE parent_id = task_id;

    RETURN child_count;
  END IF;
END;
$$;


ALTER FUNCTION public.count_child_tasks(task_id integer, is_child boolean) OWNER TO postgres;

--
-- Name: get_child_progress(bigint, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_child_progress(task_id bigint, child_no integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  progression_val INT;
BEGIN
  -- Calculer la somme de la progression des tâches filles
  SELECT COALESCE(SUM(progression), 0) INTO progression_val
  FROM tasks
  WHERE parent_id = task_id;

  -- Calculer la progression moyenne par tâche fille
  RETURN CASE WHEN child_no > 0 THEN progression_val / child_no ELSE 0 END;
END;
$$;


ALTER FUNCTION public.get_child_progress(task_id bigint, child_no integer) OWNER TO postgres;

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
    current_record_id integer,
    phone_number character varying(20) DEFAULT NULL::character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: auth; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.auth AS
 SELECT users.username,
    users.id,
    users.profile_picture,
    users.email,
    users.right_id,
    users.phone_number,
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
-- Name: launch_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.launch_types (
    id bigint NOT NULL,
    description text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.launch_types OWNER TO postgres;

--
-- Name: launch_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.launch_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.launch_types_id_seq OWNER TO postgres;

--
-- Name: launch_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.launch_types_id_seq OWNED BY public.launch_types.id;


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
-- Name: saisies_validees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saisies_validees (
    id bigint NOT NULL,
    date date NOT NULL,
    h_abs integer NOT NULL,
    h_work integer NOT NULL,
    user_id bigint,
    user_validator_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.saisies_validees OWNER TO postgres;

--
-- Name: saisies_validees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.saisies_validees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.saisies_validees_id_seq OWNER TO postgres;

--
-- Name: saisies_validees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.saisies_validees_id_seq OWNED BY public.saisies_validees.id;


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
-- Name: task_tracings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_tracings (
    id bigint NOT NULL,
    date date,
    start_time timestamp(0) without time zone,
    end_time timestamp(0) without time zone,
    duration integer,
    is_pause boolean DEFAULT false,
    launch_type_id bigint,
    task_id bigint,
    user_id bigint,
    is_recorded boolean DEFAULT false,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.task_tracings OWNER TO postgres;

--
-- Name: task_tracings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_tracings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_tracings_id_seq OWNER TO postgres;

--
-- Name: task_tracings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_tracings_id_seq OWNED BY public.task_tracings.id;


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
    clients_request_id bigint,
    is_valid boolean DEFAULT true
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
-- Name: time_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_entries (
    id bigint NOT NULL,
    date_entries timestamp(0) without time zone,
    user_id bigint,
    task_id bigint,
    project_id bigint,
    libele character varying(255),
    time_value numeric,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    validation_status integer DEFAULT 0
);


ALTER TABLE public.time_entries OWNER TO postgres;

--
-- Name: time_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_entries_id_seq OWNER TO postgres;

--
-- Name: time_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_entries_id_seq OWNED BY public.time_entries.id;


--
-- Name: time_entries_validee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_entries_validee (
    id bigint NOT NULL,
    date date NOT NULL,
    time_value numeric NOT NULL,
    user_id bigint,
    user_validator_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    validation_status integer DEFAULT 0
);


ALTER TABLE public.time_entries_validee OWNER TO postgres;

--
-- Name: time_entries_validee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_entries_validee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_entries_validee_id_seq OWNER TO postgres;

--
-- Name: time_entries_validee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_entries_validee_id_seq OWNED BY public.time_entries_validee.id;


--
-- Name: time_tracking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_tracking (
    id bigint NOT NULL,
    date date NOT NULL,
    h_work integer DEFAULT 0 NOT NULL,
    h_abs integer DEFAULT 0 NOT NULL,
    task_id bigint,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.time_tracking OWNER TO postgres;

--
-- Name: time_tracking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_tracking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_tracking_id_seq OWNER TO postgres;

--
-- Name: time_tracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_tracking_id_seq OWNED BY public.time_tracking.id;


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
-- Name: v_current_record; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_current_record AS
 SELECT task_tracings.id,
    task_tracings.date,
    task_tracings.start_time,
    task_tracings.end_time,
    task_tracings.duration,
    task_tracings.is_pause,
    task_tracings.launch_type_id,
    task_tracings.task_id,
    task_tracings.user_id,
    task_tracings.is_recorded,
    task_tracings.inserted_at,
    task_tracings.updated_at
   FROM public.task_tracings
  WHERE (task_tracings.is_recorded = false);


ALTER TABLE public.v_current_record OWNER TO postgres;

--
-- Name: v_tasks_details; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_tasks_details AS
 SELECT tasks.id,
    tasks.title,
    tasks.progression,
    tasks.date_start,
    tasks.date_end,
    tasks.estimated_duration,
    tasks.performed_duration,
    tasks.deadline,
    tasks.parent_id,
    tasks.project_id,
    tasks.contributor_id,
    tasks.status_id,
    tasks.priority_id,
    tasks.inserted_at,
    tasks.updated_at,
    tasks.attributor_id,
    tasks.achieved_at,
    tasks.hidden,
    tasks.without_control,
    tasks.description,
    tasks.is_major,
    tasks.clients_request_id,
    tasks.is_valid,
        CASE
            WHEN (tasks.parent_id IS NOT NULL) THEN true
            ELSE false
        END AS is_child,
    public.count_child_tasks((tasks.id)::integer,
        CASE
            WHEN (tasks.parent_id IS NOT NULL) THEN true
            ELSE false
        END) AS child_no
   FROM public.tasks;


ALTER TABLE public.v_tasks_details OWNER TO postgres;

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
-- Name: launch_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.launch_types ALTER COLUMN id SET DEFAULT nextval('public.launch_types_id_seq'::regclass);


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
-- Name: saisies_validees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saisies_validees ALTER COLUMN id SET DEFAULT nextval('public.saisies_validees_id_seq'::regclass);


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
-- Name: task_tracings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tracings ALTER COLUMN id SET DEFAULT nextval('public.task_tracings_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: tasks_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks_history ALTER COLUMN id SET DEFAULT nextval('public.tasks_history_id_seq'::regclass);


--
-- Name: time_entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries ALTER COLUMN id SET DEFAULT nextval('public.time_entries_id_seq'::regclass);


--
-- Name: time_entries_validee id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries_validee ALTER COLUMN id SET DEFAULT nextval('public.time_entries_validee_id_seq'::regclass);


--
-- Name: time_tracking id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_tracking ALTER COLUMN id SET DEFAULT nextval('public.time_tracking_id_seq'::regclass);


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
40	151	11	2024-02-06 13:45:37	2024-02-06 13:45:37	1
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
90	saisie de temps monitoring	2024-02-29 11:01:53	2024-02-29 11:01:53
\.


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cards (id, name, stage_id, "position", inserted_at, updated_at, task_id) FROM stdin;
1377	mon propre tache	436	18	2024-02-23 13:57:00	2024-02-23 13:57:00	1399
1347	teste de la mort 2	438	3	2024-01-25 11:45:47	2024-01-25 13:03:46	1369
1356	teste confirmation par attributeur	438	4	2024-02-01 12:53:43	2024-02-05 14:13:11	1378
1337	Tableau BOn de production	428	0	2023-11-03 11:31:52	2023-11-27 14:09:34	1359
1344	teste sous taches	438	2	2024-01-18 07:31:09	2024-01-25 12:55:50	1366
1341	test task	436	2	2023-11-10 13:04:17	2024-01-12 07:00:47	1363
1342	teste suppression	436	3	2024-01-12 07:07:58	2024-01-12 07:07:58	1364
1376	Ajout de la fonctionnalité	438	0	2024-02-06 13:54:38	2024-03-01 15:04:18	1398
1383	validation des données en entrés 	443	4	2024-02-29 11:08:14	2024-03-05 18:33:39	1405
1378	validation sur les format de donnes entrees dans la saisie de temps	438	24	2024-02-28 13:32:56	2024-03-11 06:45:54	1400
1339	Correction du bug concernant les historiques des tâches 	440	0	2023-11-06 13:31:21	2023-11-10 13:16:40	1361
1338	debug modification d'une tâche 	437	1	2023-11-06 13:27:05	2023-11-29 11:23:23	1360
1348	et encore du teste 	437	0	2024-01-25 12:56:23	2024-01-25 13:04:16	1370
1385	mecanisme de filtre des donnée a afficher	443	1	2024-02-29 11:12:18	2024-03-01 13:34:14	1407
1384	effectuer des tri sur les colone de table	443	2	2024-02-29 11:09:51	2024-03-01 14:27:37	1406
1381	conception affichage de saisie de temp	443	3	2024-02-29 11:05:06	2024-03-01 14:31:25	1403
1352	haha mety amizay	436	0	2024-01-31 13:08:28	2024-01-31 13:08:39	1374
1369	test validation	438	16	2024-02-02 07:10:40	2024-02-06 13:59:49	1391
1370	LOIC SE FAIT BLABLA	438	17	2024-02-02 11:56:23	2024-02-06 14:15:20	1392
1368	doudouuuuuu	438	18	2024-02-01 14:00:44	2024-02-06 14:17:55	1390
1367	Mon sous doudou	438	19	2024-02-01 14:00:18	2024-02-06 14:23:07	1389
1366	Mon sous doudou	438	20	2024-02-01 13:56:01	2024-02-06 14:26:02	1388
1365	Mon sous doudou	438	21	2024-02-01 13:50:01	2024-02-07 13:50:46	1387
1359	teste confirmation par attributeur 2	438	22	2024-02-01 13:01:26	2024-03-01 14:40:49	1381
1372	BOIRE DU CAFE	438	1	2024-02-05 13:03:38	2024-03-01 14:43:11	1394
1379	affichage dynamique pour saisie de temps	438	23	2024-02-28 13:34:45	2024-03-05 18:32:59	1401
1363	boubou	438	26	2024-02-01 13:46:59	2024-03-11 14:42:07	1385
1361	baba	436	4	2024-02-01 13:12:43	2024-02-01 13:12:43	1383
1362	qzazazaz	436	5	2024-02-01 13:26:14	2024-02-01 13:26:14	1384
1364	mon doudou	436	7	2024-02-01 13:49:26	2024-02-01 13:49:26	1386
1371	voici mon sous taches 	436	14	2024-02-05 10:25:51	2024-02-05 10:25:51	1393
1382	ajout des nouveau tables necessaire	443	0	2024-02-29 11:07:23	2024-03-01 13:32:50	1404
1373	DU LAIT	436	15	2024-02-05 13:04:58	2024-02-05 13:04:58	1395
1357	teste  par attributeur	438	5	2024-02-01 12:55:56	2024-02-05 14:14:25	1379
1343	teste de la mort	438	7	2024-01-18 07:30:48	2024-01-19 09:10:41	1365
1340	Correction du bug concernant les historiques des tâches (design) 	438	9	2023-11-06 13:33:58	2024-01-10 11:20:04	1362
1346	sous tache 2	438	8	2024-01-18 07:47:35	2024-01-25 11:39:09	1368
1345	teste sous taches dd	438	10	2024-01-18 07:47:06	2024-01-22 12:53:29	1367
1351	test 5	438	11	2024-01-29 06:38:20	2024-01-29 13:19:38	1373
1374	LAIT MOOGR	436	16	2024-02-05 13:05:44	2024-02-05 13:05:44	1396
1375	LAIT DE CHACHA	436	17	2024-02-05 13:06:09	2024-02-05 13:06:09	1397
1349	teste 3	438	12	2024-01-29 06:14:13	2024-01-29 14:24:45	1371
1350	test 4	438	13	2024-01-29 06:37:24	2024-01-29 14:29:39	1372
1354	test ultime	438	14	2024-01-31 13:24:10	2024-01-31 13:39:35	1376
1355	aa	438	15	2024-02-01 11:44:18	2024-02-01 11:45:41	1377
1360	test changeset	438	6	2024-02-01 13:06:11	2024-02-05 14:48:38	1382
1380	migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps	438	25	2024-02-28 13:35:46	2024-03-11 14:39:18	1402
1353	bababababa	439	1	2024-01-31 13:13:00	2024-01-31 13:25:36	1375
1358	teste sous par attributeur	439	0	2024-02-01 12:57:57	2024-02-05 14:57:00	1380
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
-- Data for Name: launch_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.launch_types (id, description, inserted_at, updated_at) FROM stdin;
1	pause dej	2024-01-29 14:56:03	2024-01-29 14:56:03
2	simple pause	2024-01-29 14:56:03	2024-01-29 14:56:03
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
25939	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24824	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24825	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24826	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24827	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24828	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24829	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24830	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24831	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-08 09:20:49	2023-11-08 09:20:49	1
25940	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24833	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24834	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24835	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24836	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24837	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24838	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	145	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24839	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24840	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2023-11-08 09:22:24	2023-11-08 09:22:24	1
25941	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24842	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24843	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24844	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24845	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24846	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24847	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24848	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24849	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 09:31:48	2023-11-08 09:31:48	1
25942	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24851	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24852	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24853	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24854	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24855	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24856	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24857	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24858	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 09:31:59	2023-11-08 09:31:59	1
25943	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24860	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24861	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24862	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24863	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24864	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24865	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24866	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24867	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 09:32:05	2023-11-08 09:32:05	1
25944	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24869	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24870	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24871	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24872	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24873	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24874	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24875	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24876	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 09:32:14	2023-11-08 09:32:14	1
25945	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:00:29	2023-11-08 17:00:29	1
24878	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24879	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24880	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24881	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24882	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24883	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24884	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24885	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24887	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24888	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24889	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24890	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24891	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24892	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24893	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24894	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24823	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	t	128	127	2023-11-08 09:20:49	2023-11-08 09:20:49	1
24832	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	t	128	127	2023-11-08 09:22:24	2023-11-08 09:22:24	1
24841	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	t	134	127	2023-11-08 09:31:48	2023-11-08 09:31:48	1
24850	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	t	134	127	2023-11-08 09:31:59	2023-11-08 09:31:59	1
24859	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	t	134	127	2023-11-08 09:32:05	2023-11-08 09:32:05	1
24868	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	t	134	127	2023-11-08 09:32:14	2023-11-08 09:32:14	1
24877	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	t	134	127	2023-11-08 09:32:16	2023-11-08 09:32:16	1
24886	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	t	134	127	2023-11-08 09:33:03	2023-11-08 09:33:03	1
24895	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24896	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24897	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24898	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24899	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24900	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24901	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24902	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24903	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 09:39:34	2023-11-08 09:39:34	1
24904	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24905	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24906	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24907	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24908	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24909	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24910	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24911	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 09:49:44	2023-11-08 09:49:44	1
24912	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24913	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24914	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24915	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24916	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24917	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24918	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24919	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 09:51:35	2023-11-08 09:51:35	1
24920	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24921	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24922	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24923	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24924	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24925	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24926	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24927	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 09:52:50	2023-11-08 09:52:50	1
24944	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24945	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24946	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24947	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24948	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24949	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24950	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24951	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 09:55:08	2023-11-08 09:55:08	1
24952	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24953	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24954	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24955	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24956	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24957	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24958	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 09:55:11	2023-11-08 09:55:11	1
24959	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 09:55:11	2023-11-08 09:55:11	1
25946	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:00:29	2023-11-08 17:00:29	1
27134	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2023-11-27 17:21:27	2023-11-27 17:21:27	3
24928	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24929	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24930	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24931	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24932	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24933	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24934	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24935	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 09:54:03	2023-11-08 09:54:03	1
24936	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24937	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24938	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24939	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24940	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24941	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24942	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24943	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 09:54:20	2023-11-08 09:54:20	1
24960	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24961	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24962	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24963	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24964	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24965	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24966	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24967	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 09:55:27	2023-11-08 09:55:27	1
24968	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24969	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24970	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24971	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24972	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24973	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24974	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24975	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 09:57:08	2023-11-08 09:57:08	1
24976	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24977	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24978	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24979	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24980	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24981	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24982	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24983	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 09:57:23	2023-11-08 09:57:23	1
24984	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24985	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24986	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24987	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24988	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24989	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24990	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24991	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 09:57:36	2023-11-08 09:57:36	1
24992	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24993	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24994	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24995	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24996	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24997	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24998	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 09:57:44	2023-11-08 09:57:44	1
24999	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 09:57:44	2023-11-08 09:57:44	1
25032	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25033	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25034	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25035	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25036	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25037	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25038	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25039	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:24:10	2023-11-08 10:24:10	1
25040	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25041	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25042	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25043	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25044	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25045	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25046	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25047	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 10:24:16	2023-11-08 10:24:16	1
25947	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25948	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25949	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25950	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25951	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25952	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25953	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 17:00:37	2023-11-08 17:00:37	1
25954	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 17:00:37	2023-11-08 17:00:37	1
26153	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 08:38:42	2023-11-09 08:38:42	1
27135	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2023-11-27 17:21:27	2023-11-27 17:21:27	3
25000	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25001	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25002	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25003	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25004	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25005	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25006	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25007	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 09:57:49	2023-11-08 09:57:49	1
25008	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25009	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25010	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25011	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25012	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25013	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25014	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25015	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 09:57:59	2023-11-08 09:57:59	1
25016	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25017	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25018	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25019	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25020	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25021	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25022	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25023	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:23:57	2023-11-08 10:23:57	1
25024	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25025	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25026	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25027	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25028	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25029	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25030	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25031	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 10:24:01	2023-11-08 10:24:01	1
25048	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25049	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25050	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25051	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25052	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25053	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 10:31:01	2023-11-08 10:31:01	1
27136	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2023-11-27 17:21:27	2023-11-27 17:21:27	3
25054	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25055	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25056	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 10:31:01	2023-11-08 10:31:01	1
25057	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	130	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25058	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	135	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25059	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	136	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25060	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	138	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25061	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	144	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25062	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	145	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25063	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	132	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25064	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	131	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25065	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " A faire " par Loïc	f	134	127	2023-11-08 10:31:03	2023-11-08 10:31:03	1
25066	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25067	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25068	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25069	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25070	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25071	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25072	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25073	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25074	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 10:31:07	2023-11-08 10:31:07	1
25075	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25076	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25077	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25078	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25079	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25080	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25081	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25082	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25083	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	127	2023-11-08 10:31:11	2023-11-08 10:31:11	1
25084	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25085	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25086	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25087	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25088	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25089	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25090	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25091	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25092	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 10:31:13	2023-11-08 10:31:13	1
25093	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25094	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25095	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25096	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25097	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25098	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25099	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25100	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 10:31:59	2023-11-08 10:31:59	1
25955	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25956	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25957	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25958	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25959	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25960	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25961	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:01:50	2023-11-08 17:01:50	1
25962	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:01:50	2023-11-08 17:01:50	1
26154	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26155	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26156	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26157	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26158	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26159	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26160	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26161	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 08:38:42	2023-11-09 08:38:42	1
26396	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26397	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26398	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26399	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26400	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26401	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26402	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26403	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26404	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:26:53	2023-11-09 10:26:53	1
26477	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26478	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26479	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26480	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26481	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:34:17	2023-11-09 10:34:17	1
27137	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2023-11-27 17:21:27	2023-11-27 17:21:27	3
25101	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25102	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25103	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25104	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25105	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25106	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25107	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25108	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:32:01	2023-11-08 10:32:01	1
25109	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25110	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25111	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25112	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25113	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25114	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25115	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25116	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 10:32:05	2023-11-08 10:32:05	1
25117	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25118	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25119	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25120	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25121	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25122	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25123	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25124	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 10:36:03	2023-11-08 10:36:03	1
25125	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25126	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25127	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25128	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25129	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25130	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25131	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25132	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:36:24	2023-11-08 10:36:24	1
25133	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25134	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25135	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25136	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25137	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25138	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25139	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25140	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 10:37:09	2023-11-08 10:37:09	1
25141	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25142	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25143	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25144	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25145	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25146	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25147	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25148	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 10:37:25	2023-11-08 10:37:25	1
25149	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25150	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25151	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25152	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25153	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25154	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25155	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25156	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:37:27	2023-11-08 10:37:27	1
25157	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25158	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25159	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25160	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25161	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25162	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25163	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25164	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 10:42:41	2023-11-08 10:42:41	1
25165	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25166	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25167	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25168	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25169	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25170	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25171	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25172	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:42:43	2023-11-08 10:42:43	1
25173	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25174	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25175	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25176	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25177	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25178	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25179	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25180	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 10:45:23	2023-11-08 10:45:23	1
25181	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25182	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25183	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25184	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25185	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25186	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25187	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 10:45:28	2023-11-08 10:45:28	1
27138	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2023-11-27 17:21:27	2023-11-27 17:21:27	3
25188	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 10:45:28	2023-11-08 10:45:28	1
25963	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25964	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25965	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25966	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25967	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25968	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25969	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25970	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:07:05	2023-11-08 17:07:05	1
25971	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25972	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25973	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25974	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25975	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25976	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25977	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:07:18	2023-11-08 17:07:18	1
25978	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:07:18	2023-11-08 17:07:18	1
26162	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26163	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26164	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26165	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26166	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26167	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26168	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26169	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26170	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-09 08:43:40	2023-11-09 08:43:40	1
26405	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26406	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26407	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26408	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26409	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26410	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26411	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26412	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26413	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:26:58	2023-11-09 10:26:58	1
26441	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26442	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26443	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26444	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26445	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:32:52	2023-11-09 10:32:52	1
27139	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2023-11-27 17:21:27	2023-11-27 17:21:27	3
25189	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25190	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25191	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25192	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25193	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25194	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25195	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25196	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:07:29	2023-11-08 11:07:29	1
25197	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25198	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25199	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25200	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25201	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25202	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25203	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25204	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:07:32	2023-11-08 11:07:32	1
25979	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25980	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25981	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25982	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25983	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25984	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25985	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 17:07:34	2023-11-08 17:07:34	1
25986	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 17:07:34	2023-11-08 17:07:34	1
26171	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	130	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26172	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	135	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26173	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	136	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26174	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	138	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26175	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	144	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26176	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	145	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26177	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	132	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26178	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	131	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26179	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	127	2023-11-09 08:45:57	2023-11-09 08:45:57	1
26258	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26259	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26260	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26261	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26262	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26263	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26264	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26265	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 09:55:50	2023-11-09 09:55:50	1
26423	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:32:36	2023-11-09 10:32:36	1
27140	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2023-11-27 17:21:27	2023-11-27 17:21:27	3
25205	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25206	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25207	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25208	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25209	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25210	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25211	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25212	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:07:36	2023-11-08 11:07:36	1
25213	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25214	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25215	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25216	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25217	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25218	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25219	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25220	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:07:40	2023-11-08 11:07:40	1
25221	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25222	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25223	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25224	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25225	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25226	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25227	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25228	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:07:48	2023-11-08 11:07:48	1
25229	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25230	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25231	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25232	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25233	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25234	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25235	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25236	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:08:15	2023-11-08 11:08:15	1
25237	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25238	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25239	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25240	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25241	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25242	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25243	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25244	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:09:11	2023-11-08 11:09:11	1
25245	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25246	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25247	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25248	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25249	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25250	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25251	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25252	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:09:14	2023-11-08 11:09:14	1
25253	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25254	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25255	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25256	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25257	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25258	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25259	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25260	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:09:25	2023-11-08 11:09:25	1
25261	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25262	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25263	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25264	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25265	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25266	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25267	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25268	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:11:03	2023-11-08 11:11:03	1
25269	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25270	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25271	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25272	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25273	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25274	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25275	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25276	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:11:30	2023-11-08 11:11:30	1
25277	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25278	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25279	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25280	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25281	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25282	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25283	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25284	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:11:41	2023-11-08 11:11:41	1
25285	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25286	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25287	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25288	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25289	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25290	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25291	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:12:16	2023-11-08 11:12:16	1
27174	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2023-12-18 14:38:15	2023-12-18 14:38:15	3
25292	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:12:16	2023-11-08 11:12:16	1
25301	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25302	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25303	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25304	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25305	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25306	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25307	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25308	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:13:20	2023-11-08 11:13:20	1
25987	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25988	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25989	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25990	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25991	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25992	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25993	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:08:29	2023-11-08 17:08:29	1
25994	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:08:29	2023-11-08 17:08:29	1
26180	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26181	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26182	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26183	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26184	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26185	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26186	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26187	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26188	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 08:46:06	2023-11-09 08:46:06	1
26224	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26225	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26226	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26227	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26228	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26229	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26230	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26231	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26232	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 08:56:59	2023-11-09 08:56:59	1
26424	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26425	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26426	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26427	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26428	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26429	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26430	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:32:36	2023-11-09 10:32:36	1
25293	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25294	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25295	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25296	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25297	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25298	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25299	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25300	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:12:18	2023-11-08 11:12:18	1
25995	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:08:35	2023-11-08 17:08:35	1
25996	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:08:35	2023-11-08 17:08:35	1
25997	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:08:35	2023-11-08 17:08:35	1
25998	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:08:35	2023-11-08 17:08:35	1
25999	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:08:35	2023-11-08 17:08:35	1
26000	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:08:35	2023-11-08 17:08:35	1
26001	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:08:35	2023-11-08 17:08:35	1
26002	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:08:35	2023-11-08 17:08:35	1
26003	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26004	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26005	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26006	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26007	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26008	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26009	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26010	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:08:49	2023-11-08 17:08:49	1
26019	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26020	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26021	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26022	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26023	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26024	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26025	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26026	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:11:43	2023-11-08 17:11:43	1
26189	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26190	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26191	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26192	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26193	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26194	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26195	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26196	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 08:49:02	2023-11-09 08:49:02	1
26266	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	130	2023-11-09 09:55:56	2023-11-09 09:55:56	1
26267	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	135	2023-11-09 09:55:56	2023-11-09 09:55:56	1
25309	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25310	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25311	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25312	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25313	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25314	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25315	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:16:18	2023-11-08 11:16:18	1
25316	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:16:18	2023-11-08 11:16:18	1
26011	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26012	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26013	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26014	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26015	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26016	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26017	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26018	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:09:21	2023-11-08 17:09:21	1
26197	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	130	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26198	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	135	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26199	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	136	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26200	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	138	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26201	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	144	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26202	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	145	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26203	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	132	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26204	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	131	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26205	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par Anja	f	133	127	2023-11-09 08:49:52	2023-11-09 08:49:52	1
26282	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26283	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26284	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26285	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26286	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26287	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26288	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26289	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26290	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 09:57:02	2023-11-09 09:57:02	1
26291	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26292	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26293	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26294	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26295	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26296	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26297	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26298	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 09:57:03	2023-11-09 09:57:03	1
25317	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25318	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25319	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25320	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25321	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25322	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25323	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:17:19	2023-11-08 11:17:19	1
25324	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:17:19	2023-11-08 11:17:19	1
26027	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26028	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26029	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26030	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26031	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26032	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26033	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26034	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:15:00	2023-11-08 17:15:00	1
26206	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26207	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26208	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26209	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26210	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26211	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26212	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26213	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26214	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 08:49:57	2023-11-09 08:49:57	1
26327	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26328	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26329	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26330	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26331	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26332	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26333	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26334	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26335	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:13:20	2023-11-09 10:13:20	1
26352	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26353	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26354	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26355	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26356	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26357	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26358	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26359	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:14:57	2023-11-09 10:14:57	1
25325	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25326	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25327	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25328	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25329	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25330	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25331	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25332	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:17:27	2023-11-08 11:17:27	1
25333	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25334	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25335	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25336	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25337	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25338	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25339	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25340	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:18:04	2023-11-08 11:18:04	1
25341	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25342	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25343	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25344	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25345	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25346	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25347	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25348	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:18:07	2023-11-08 11:18:07	1
25349	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25350	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25351	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25352	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25353	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25354	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25355	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25356	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:18:12	2023-11-08 11:18:12	1
25357	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25358	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25359	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25360	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25361	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25362	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25363	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25364	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:18:21	2023-11-08 11:18:21	1
25365	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25366	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25367	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25368	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25369	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25370	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25371	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25372	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:19:14	2023-11-08 11:19:14	1
25381	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25382	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25383	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25384	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25385	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25386	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25387	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25388	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:20:00	2023-11-08 11:20:00	1
25389	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25390	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25391	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25392	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25393	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25394	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25395	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25396	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:27:13	2023-11-08 11:27:13	1
25437	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25438	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25439	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25440	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25441	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25442	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25443	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:37:04	2023-11-08 11:37:04	1
25444	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:37:04	2023-11-08 11:37:04	1
26035	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26036	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26037	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26038	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26039	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26040	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26041	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26042	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 17:16:41	2023-11-08 17:16:41	1
26215	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-09 08:51:10	2023-11-09 08:51:10	1
25373	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25374	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25375	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25376	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25377	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25378	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25379	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25380	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:19:18	2023-11-08 11:19:18	1
25397	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25398	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25399	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25400	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25401	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25402	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25403	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25404	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:27:36	2023-11-08 11:27:36	1
25405	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25406	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25407	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25408	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25409	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25410	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25411	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25412	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:30:57	2023-11-08 11:30:57	1
25413	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25414	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25415	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25416	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25417	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25418	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25419	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25420	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:30:59	2023-11-08 11:30:59	1
25421	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25422	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25423	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25508	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25424	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25425	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25426	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25427	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:31:01	2023-11-08 11:31:01	1
25428	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:31:01	2023-11-08 11:31:01	1
26043	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26044	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26045	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26046	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26047	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26048	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26049	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26050	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:17:44	2023-11-08 17:17:44	1
26216	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26217	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26218	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26219	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26220	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26221	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26222	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26223	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	127	2023-11-09 08:51:10	2023-11-09 08:51:10	1
26309	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26310	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26311	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26312	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26313	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26314	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26315	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26316	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26317	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:13:13	2023-11-09 10:13:13	1
26318	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26319	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26320	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26321	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26322	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26323	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26324	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26325	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:13:19	2023-11-09 10:13:19	1
26326	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:13:19	2023-11-09 10:13:19	1
27175	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2023-12-18 14:38:15	2023-12-18 14:38:15	3
25429	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25430	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25431	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25432	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25433	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25434	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25435	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25436	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:36:46	2023-11-08 11:36:46	1
25445	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25446	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25447	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25448	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25449	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25450	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25451	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25452	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:39:23	2023-11-08 11:39:23	1
25453	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25454	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25455	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25456	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25457	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25458	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25459	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25460	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:39:45	2023-11-08 11:39:45	1
25461	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25462	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25463	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25464	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25465	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25466	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25467	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25468	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:39:58	2023-11-08 11:39:58	1
25469	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25470	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25471	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25472	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25473	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25474	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25475	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25476	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:40:17	2023-11-08 11:40:17	1
25477	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25478	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25479	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25480	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25481	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25482	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25483	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25484	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:40:24	2023-11-08 11:40:24	1
25485	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25486	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25487	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25488	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25489	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25490	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25491	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25492	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:40:32	2023-11-08 11:40:32	1
25493	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25494	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25495	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25496	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25497	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25498	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25499	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25500	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:42:03	2023-11-08 11:42:03	1
25501	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25502	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25503	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25504	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25505	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25506	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:42:08	2023-11-08 11:42:08	1
25507	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:42:08	2023-11-08 11:42:08	1
27176	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2023-12-18 14:38:15	2023-12-18 14:38:15	3
25509	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25510	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25511	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25512	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25513	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25514	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25515	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25516	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:42:14	2023-11-08 11:42:14	1
25517	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25518	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25519	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25520	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25521	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25522	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25523	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25524	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:42:57	2023-11-08 11:42:57	1
25525	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25526	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25527	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25528	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25529	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25530	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25531	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25532	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:43:19	2023-11-08 11:43:19	1
25533	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25534	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25535	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25536	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25537	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25538	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25539	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25540	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:44:12	2023-11-08 11:44:12	1
25557	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25558	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25559	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25560	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25561	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25562	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25563	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:45:37	2023-11-08 11:45:37	1
25564	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:45:37	2023-11-08 11:45:37	1
26051	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26052	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26053	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26054	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 17:31:54	2023-11-08 17:31:54	1
25541	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25542	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25543	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25544	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25545	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25546	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25547	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25548	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:44:37	2023-11-08 11:44:37	1
25549	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25550	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25551	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25552	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25553	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25554	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25555	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25556	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:44:40	2023-11-08 11:44:40	1
25573	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25574	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25575	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25576	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25577	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25578	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25579	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25580	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:45:43	2023-11-08 11:45:43	1
25581	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25582	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25583	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25584	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25585	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25586	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25587	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25588	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:45:45	2023-11-08 11:45:45	1
25597	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25598	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25599	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25600	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25601	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25602	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25603	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25604	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:48:52	2023-11-08 11:48:52	1
25613	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25614	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25615	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25616	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25565	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25566	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25567	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25568	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25569	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25570	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25571	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:45:41	2023-11-08 11:45:41	1
25572	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:45:41	2023-11-08 11:45:41	1
26055	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26056	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26057	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26058	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 17:31:54	2023-11-08 17:31:54	1
26233	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26234	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26235	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26236	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26237	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26238	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26239	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26240	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26241	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 08:57:04	2023-11-09 08:57:04	1
26344	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26345	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26346	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26347	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26348	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26349	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26350	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26351	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 10:13:46	2023-11-09 10:13:46	1
26361	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26362	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26363	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26364	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26365	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26366	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26367	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26368	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26369	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:15:01	2023-11-09 10:15:01	1
26431	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:32:36	2023-11-09 10:32:36	1
26432	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26433	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26434	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:32:47	2023-11-09 10:32:47	1
25589	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25590	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25591	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25592	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25593	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25594	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25595	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25596	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:48:43	2023-11-08 11:48:43	1
25605	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25606	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25607	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25608	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25609	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25610	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25611	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:48:54	2023-11-08 11:48:54	1
25612	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:48:54	2023-11-08 11:48:54	1
26059	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26060	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26061	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26062	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26063	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26064	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26065	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26066	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:35:16	2023-11-08 17:35:16	1
26242	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26243	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26244	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26245	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26246	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26247	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26248	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26249	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 09:52:57	2023-11-09 09:52:57	1
26435	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26436	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26437	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26438	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26439	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26440	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:32:47	2023-11-09 10:32:47	1
26513	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:40:20	2023-11-09 10:40:20	1
26514	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:40:20	2023-11-09 10:40:20	1
26515	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:40:20	2023-11-09 10:40:20	1
26516	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:40:20	2023-11-09 10:40:20	1
25617	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25618	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25619	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25620	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:48:57	2023-11-08 11:48:57	1
25621	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25622	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25623	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25624	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25625	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25626	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25627	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:49:02	2023-11-08 11:49:02	1
25628	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:49:02	2023-11-08 11:49:02	1
26067	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26068	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26069	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26070	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26071	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26072	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26073	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26074	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 17:36:45	2023-11-08 17:36:45	1
26250	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	130	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26251	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	135	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26252	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	136	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26253	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	138	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26254	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	144	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26255	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	145	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26256	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	132	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26257	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	131	2023-11-09 09:55:48	2023-11-09 09:55:48	1
26446	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26447	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26448	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26449	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:32:52	2023-11-09 10:32:52	1
26468	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26469	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26470	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26471	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26472	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26473	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26474	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26475	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26476	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:34:12	2023-11-09 10:34:12	1
26517	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:40:20	2023-11-09 10:40:20	1
27177	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2023-12-18 14:38:15	2023-12-18 14:38:15	3
25629	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25630	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25631	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25632	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25633	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25634	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25635	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25636	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:49:04	2023-11-08 11:49:04	1
25637	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25638	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25639	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25640	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25641	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25642	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25643	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25644	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:49:16	2023-11-08 11:49:16	1
25645	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25646	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25647	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25648	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25649	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25650	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25651	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25652	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:49:29	2023-11-08 11:49:29	1
25653	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25654	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25655	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25656	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25657	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25658	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25659	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25660	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:49:35	2023-11-08 11:49:35	1
25661	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25662	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25663	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25664	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25665	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25666	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25667	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25668	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:49:50	2023-11-08 11:49:50	1
25669	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25670	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25671	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:50:26	2023-11-08 11:50:26	1
27178	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2023-12-18 14:38:15	2023-12-18 14:38:15	3
25672	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25673	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25674	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25675	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25676	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:50:26	2023-11-08 11:50:26	1
25677	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25678	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25679	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25680	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25681	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25682	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25683	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25684	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:55:34	2023-11-08 11:55:34	1
25693	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25694	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25695	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25696	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25697	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25698	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25699	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:55:51	2023-11-08 11:55:51	1
25700	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:55:51	2023-11-08 11:55:51	1
26075	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26076	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26077	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26078	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26079	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26080	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26081	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26082	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:44:14	2023-11-08 17:44:14	1
26083	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26084	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26085	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26086	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26087	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26088	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26089	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26090	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 17:59:28	2023-11-08 17:59:28	1
26268	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	136	2023-11-09 09:55:56	2023-11-09 09:55:56	1
26269	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	138	2023-11-09 09:55:56	2023-11-09 09:55:56	1
26270	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	144	2023-11-09 09:55:56	2023-11-09 09:55:56	1
26271	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	145	2023-11-09 09:55:56	2023-11-09 09:55:56	1
26272	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	132	2023-11-09 09:55:56	2023-11-09 09:55:56	1
26273	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	131	2023-11-09 09:55:56	2023-11-09 09:55:56	1
25685	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25686	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25687	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25688	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25689	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25690	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25691	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 11:55:39	2023-11-08 11:55:39	1
25692	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 11:55:39	2023-11-08 11:55:39	1
26091	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26092	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26093	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26094	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26095	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26096	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26097	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26098	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 17:59:42	2023-11-08 17:59:42	1
26274	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26275	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26276	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26277	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26278	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26279	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26280	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26281	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 09:56:00	2023-11-09 09:56:00	1
26300	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26301	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26302	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26303	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26304	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26305	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26306	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26307	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26308	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:13:11	2023-11-09 10:13:11	1
26450	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26451	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26452	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26453	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26454	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26455	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26456	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26457	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:33:35	2023-11-09 10:33:35	1
26458	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:33:35	2023-11-09 10:33:35	1
25701	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25702	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25703	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25704	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25705	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25706	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25707	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25708	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:58:48	2023-11-08 11:58:48	1
25709	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25710	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25711	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25712	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25713	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25714	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25715	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 11:58:59	2023-11-08 11:58:59	1
25716	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 11:58:59	2023-11-08 11:58:59	1
26099	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26100	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26101	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26102	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26103	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26104	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26105	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26106	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26107	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 08:36:23	2023-11-09 08:36:23	1
26299	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 09:57:03	2023-11-09 09:57:03	1
26336	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	130	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26337	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	135	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26338	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	136	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26339	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	138	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26340	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	144	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26341	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	145	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26342	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	132	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26343	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	131	2023-11-09 10:13:44	2023-11-09 10:13:44	1
26482	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26483	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26484	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26485	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:34:17	2023-11-09 10:34:17	1
26518	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:40:20	2023-11-09 10:40:20	1
26519	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:40:20	2023-11-09 10:40:20	1
26520	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:40:20	2023-11-09 10:40:20	1
26521	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:40:20	2023-11-09 10:40:20	1
25717	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25718	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25719	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25720	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25721	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25722	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25723	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25724	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 11:59:02	2023-11-08 11:59:02	1
25725	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25726	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25727	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25728	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25729	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25730	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25731	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25732	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 15:00:08	2023-11-08 15:00:08	1
25733	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25734	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25735	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25736	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25737	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25738	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25739	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25740	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25741	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 15:01:37	2023-11-08 15:01:37	1
25742	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25743	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25744	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25745	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25746	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25747	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25748	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25749	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25750	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	127	2023-11-08 15:03:13	2023-11-08 15:03:13	1
25751	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25752	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25753	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25754	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25755	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25756	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25757	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25758	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 15:04:31	2023-11-08 15:04:31	1
25759	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 15:04:31	2023-11-08 15:04:31	1
26108	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26109	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26110	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26111	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26112	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26113	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26114	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26115	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26116	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 08:37:05	2023-11-09 08:37:05	1
26360	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:14:57	2023-11-09 10:14:57	1
26486	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26487	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26488	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26489	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26490	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26491	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26492	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26493	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26494	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:38:55	2023-11-09 10:38:55	1
26522	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26523	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26524	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26525	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26526	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26527	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26528	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26529	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26530	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:40:44	2023-11-09 10:40:44	1
26531	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26532	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26533	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26534	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26535	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26536	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26537	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26538	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:40:49	2023-11-09 10:40:49	1
26539	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:40:49	2023-11-09 10:40:49	1
25760	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25761	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25762	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25763	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25764	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25765	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25766	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25767	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25768	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	127	2023-11-08 15:05:35	2023-11-08 15:05:35	1
25769	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25770	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25771	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25772	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25773	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25774	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25775	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25776	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 15:22:52	2023-11-08 15:22:52	1
25777	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25778	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25779	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25780	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25781	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25782	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25783	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 15:33:30	2023-11-08 15:33:30	1
25784	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 15:33:30	2023-11-08 15:33:30	1
26117	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26118	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26119	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26120	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26121	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26122	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26123	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26124	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26125	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 08:37:17	2023-11-09 08:37:17	1
26135	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26136	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26137	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26138	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26139	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26140	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26141	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 08:38:17	2023-11-09 08:38:17	1
25785	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25786	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25787	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25788	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25789	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25790	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25791	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25792	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 15:33:44	2023-11-08 15:33:44	1
25793	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25794	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25795	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25796	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25797	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25798	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25799	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25800	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:05:07	2023-11-08 16:05:07	1
25801	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25802	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25803	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25804	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25805	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25806	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25807	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25808	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:05:35	2023-11-08 16:05:35	1
25809	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25810	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25811	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25812	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25813	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25814	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25815	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25816	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:07:44	2023-11-08 16:07:44	1
25817	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25818	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25819	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25820	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25821	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25822	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25823	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25824	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:07:57	2023-11-08 16:07:57	1
25825	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25826	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25827	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25828	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25829	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25830	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25831	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25832	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:10:54	2023-11-08 16:10:54	1
25833	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25834	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25835	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25836	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25837	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25838	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25839	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25840	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25841	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-08 16:15:56	2023-11-08 16:15:56	1
25842	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	130	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25843	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	135	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25844	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	136	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25845	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	138	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25846	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	144	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25847	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	145	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25848	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	132	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25849	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	131	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25850	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par Loïc	f	134	127	2023-11-08 16:20:00	2023-11-08 16:20:00	1
25851	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25852	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25853	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25854	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25855	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25856	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25857	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25858	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:31:36	2023-11-08 16:31:36	1
25859	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25860	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25861	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25862	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25863	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25864	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25865	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25866	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:42:38	2023-11-08 16:42:38	1
25867	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25868	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25869	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25870	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25871	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25872	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25873	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25874	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:44:54	2023-11-08 16:44:54	1
25875	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25876	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25877	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25878	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25879	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25880	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25881	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:45:09	2023-11-08 16:45:09	1
25882	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:45:09	2023-11-08 16:45:09	1
26126	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26127	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26128	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26129	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26130	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26131	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26132	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26133	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26134	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 08:37:40	2023-11-09 08:37:40	1
26370	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26371	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26372	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26373	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26374	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26375	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26376	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26377	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 10:22:38	2023-11-09 10:22:38	1
26459	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26460	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26461	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26462	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26463	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26464	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26465	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26466	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26467	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:33:41	2023-11-09 10:33:41	1
26504	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:40:18	2023-11-09 10:40:18	1
25883	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25884	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25885	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25886	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25887	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25888	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25889	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25890	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:48:47	2023-11-08 16:48:47	1
25891	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25892	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25893	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25894	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25895	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25896	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25897	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25898	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:50:32	2023-11-08 16:50:32	1
25899	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25900	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25901	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25902	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25903	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25904	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25905	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25906	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:51:37	2023-11-08 16:51:37	1
25907	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25908	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25909	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25910	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25911	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25912	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25913	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25914	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-08 16:52:21	2023-11-08 16:52:21	1
25923	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25924	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25925	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25926	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25927	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25928	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25929	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25930	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-08 16:56:19	2023-11-08 16:56:19	1
25931	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:56:56	2023-11-08 16:56:56	1
25932	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:56:56	2023-11-08 16:56:56	1
25933	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:56:56	2023-11-08 16:56:56	1
27179	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2023-12-18 14:38:15	2023-12-18 14:38:15	3
25915	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25916	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25917	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25918	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25919	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25920	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25921	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:52:47	2023-11-08 16:52:47	1
25922	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:52:47	2023-11-08 16:52:47	1
26142	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26143	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 08:38:17	2023-11-09 08:38:17	1
26378	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26379	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26380	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26381	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26382	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26383	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26384	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26385	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26386	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:24:38	2023-11-09 10:24:38	1
26505	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26506	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26507	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26508	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26509	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26510	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26511	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26512	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:40:18	2023-11-09 10:40:18	1
26540	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26541	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26542	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26543	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26544	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26545	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26546	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26547	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26548	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:43:19	2023-11-09 10:43:19	1
26549	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26550	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26551	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26552	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26553	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26554	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:43:29	2023-11-09 10:43:29	1
25934	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-08 16:56:56	2023-11-08 16:56:56	1
25935	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-08 16:56:56	2023-11-08 16:56:56	1
25936	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-08 16:56:56	2023-11-08 16:56:56	1
25937	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-08 16:56:56	2023-11-08 16:56:56	1
25938	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-08 16:56:56	2023-11-08 16:56:56	1
26144	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26145	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26146	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26147	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26148	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26149	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26150	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26151	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26152	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 08:38:26	2023-11-09 08:38:26	1
26387	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26388	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26389	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26390	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26391	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26392	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26393	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26394	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26395	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:25:30	2023-11-09 10:25:30	1
26414	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26415	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26416	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26417	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26418	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26419	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26420	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26421	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26422	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:32:32	2023-11-09 10:32:32	1
26495	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26496	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26497	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26498	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26499	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26500	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26501	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26502	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:38:58	2023-11-09 10:38:58	1
26503	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:38:58	2023-11-09 10:38:58	1
27125	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26555	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26556	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26557	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:43:29	2023-11-09 10:43:29	1
26558	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	130	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26559	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	135	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26560	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	136	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26561	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	138	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26562	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	144	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26563	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	145	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26564	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	132	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26565	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	131	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26566	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par Loïc	f	134	127	2023-11-09 10:43:38	2023-11-09 10:43:38	1
26567	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26568	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26569	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26570	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26571	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26572	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26573	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26574	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26575	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 10:44:17	2023-11-09 10:44:17	1
26585	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26586	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26587	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26588	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26589	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26590	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26591	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26592	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-09 10:52:03	2023-11-09 10:52:03	1
26593	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	127	2023-11-09 10:52:03	2023-11-09 10:52:03	1
24791	Loïc a été assigné à la tâche Correction du bug concernant les historiques des tâches  dans le projet Project monitoring  par Hasina	t	131	134	2023-11-06 13:31:21	2023-11-06 13:31:21	6
26576	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26577	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26578	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26579	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26580	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26581	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26582	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26583	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26584	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:51:56	2023-11-09 10:51:56	1
26594	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	130	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26595	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	135	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26596	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	136	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26597	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	138	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26598	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	144	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26599	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	145	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26600	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	132	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26601	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	131	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26602	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par Anja	f	133	127	2023-11-09 10:52:13	2023-11-09 10:52:13	1
26603	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26604	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26605	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26606	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26607	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26608	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26609	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26610	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 11:00:36	2023-11-09 11:00:36	1
26611	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26612	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26613	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26614	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26615	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26616	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26617	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26618	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-09 11:00:48	2023-11-09 11:00:48	1
26619	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26620	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26621	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26622	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-09 11:01:12	2023-11-09 11:01:12	1
27126	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26623	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26624	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26625	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26626	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-09 11:01:12	2023-11-09 11:01:12	1
26627	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	130	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26628	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	135	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26629	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	136	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26630	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	138	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26631	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	144	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26632	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	145	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26633	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	132	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26634	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En contrôle " par PhidiaAdmin	f	127	131	2023-11-09 11:01:34	2023-11-09 11:01:34	1
26635	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26636	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26637	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26638	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26639	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26640	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26641	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26642	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26643	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:05:38	2023-11-09 11:05:38	1
26644	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26645	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26646	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26647	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26648	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26649	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26650	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26651	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26652	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:05:51	2023-11-09 11:05:51	1
26653	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26654	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26655	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26656	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26657	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26658	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26659	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26660	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26661	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:09:23	2023-11-09 11:09:23	1
26662	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26663	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26664	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26665	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26666	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26667	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26668	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26669	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26670	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:10:56	2023-11-09 11:10:56	1
26680	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26681	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26682	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26683	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26684	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26685	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26686	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26687	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26688	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:11:30	2023-11-09 11:11:30	1
26698	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26699	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26700	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26701	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26702	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26703	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26704	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26705	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26706	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:11:44	2023-11-09 11:11:44	1
26770	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26771	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26772	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26773	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:15:55	2023-11-09 11:15:55	1
27127	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26671	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26672	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26673	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26674	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26675	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26676	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	145	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26677	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26678	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26679	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	127	2023-11-09 11:11:23	2023-11-09 11:11:23	1
26689	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26690	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26691	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26692	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26693	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26694	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26695	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26696	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26697	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:11:38	2023-11-09 11:11:38	1
26752	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26753	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26754	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26755	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26756	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26757	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26758	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26759	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26760	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:15:45	2023-11-09 11:15:45	1
26761	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26762	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26763	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26764	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26765	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26766	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26767	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:15:51	2023-11-09 11:15:51	1
27128	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26707	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26708	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26709	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26710	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26711	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26712	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26713	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26714	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26715	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:14:04	2023-11-09 11:14:04	1
26716	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26717	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26718	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26719	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26720	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26721	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26722	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26723	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26724	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:14:12	2023-11-09 11:14:12	1
26779	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	130	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26780	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	135	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26781	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	136	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26782	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	138	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26783	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	144	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26784	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	145	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26785	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	132	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26786	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	131	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26787	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	127	2023-11-09 11:18:15	2023-11-09 11:18:15	1
26815	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26816	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26817	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26818	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26819	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26820	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26821	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:22:04	2023-11-09 11:22:04	1
27129	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26725	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26726	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26727	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26728	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26729	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26730	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26731	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26732	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26733	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:14:51	2023-11-09 11:14:51	1
26734	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26735	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26736	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26737	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26738	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26739	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26740	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26741	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26742	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:14:58	2023-11-09 11:14:58	1
26743	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26744	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26745	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26746	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26747	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26748	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26749	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26750	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26751	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:15:41	2023-11-09 11:15:41	1
26788	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26789	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26790	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26791	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26792	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26793	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26794	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:21:23	2023-11-09 11:21:23	1
27130	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26768	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26769	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:15:51	2023-11-09 11:15:51	1
26842	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26843	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26844	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26845	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26846	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26847	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26848	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26849	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26850	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:26:37	2023-11-09 11:26:37	1
26774	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26775	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26776	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26777	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26778	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:15:55	2023-11-09 11:15:55	1
26806	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26807	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26808	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26809	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26810	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26811	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26812	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26813	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26814	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:21:57	2023-11-09 11:21:57	1
26795	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26796	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:21:23	2023-11-09 11:21:23	1
26797	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26798	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26799	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26800	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26801	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26802	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26803	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26804	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26805	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:21:32	2023-11-09 11:21:32	1
26822	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26823	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:22:04	2023-11-09 11:22:04	1
26824	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26825	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26826	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26827	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26828	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26829	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26830	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26831	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26832	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:25:59	2023-11-09 11:25:59	1
26833	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26834	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26835	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26836	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26837	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26838	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26839	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26840	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26841	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:26:09	2023-11-09 11:26:09	1
26851	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26852	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26853	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26854	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26855	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26856	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26857	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26858	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26859	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:26:45	2023-11-09 11:26:45	1
26860	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26861	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26862	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26863	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26864	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26865	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26866	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:26:48	2023-11-09 11:26:48	1
27131	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26867	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26868	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:26:48	2023-11-09 11:26:48	1
26869	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26870	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26871	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26872	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26873	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26874	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26875	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26876	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26877	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:26:56	2023-11-09 11:26:56	1
26878	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26879	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26880	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26881	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26882	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26883	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26884	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26885	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26886	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:27:05	2023-11-09 11:27:05	1
26905	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26906	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26907	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26908	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26909	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26910	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	145	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26911	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26912	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26913	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	127	2023-11-09 11:33:10	2023-11-09 11:33:10	1
26932	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26933	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26934	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26935	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26936	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2023-11-09 11:40:45	2023-11-09 11:40:45	1
27132	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2023-11-27 17:20:49	2023-11-27 17:20:49	3
26887	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26888	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26889	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26890	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26891	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26892	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26893	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26894	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26895	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:27:15	2023-11-09 11:27:15	1
26896	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26897	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26898	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26899	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26900	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26901	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26902	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26903	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26904	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:27:16	2023-11-09 11:27:16	1
26914	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26915	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26916	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26917	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26918	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26919	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26920	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26921	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26922	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:33:26	2023-11-09 11:33:26	1
26923	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	130	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26924	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	135	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26925	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	136	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26926	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	138	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26927	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	144	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26928	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	145	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26929	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	132	2023-11-09 11:33:46	2023-11-09 11:33:46	1
27133	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2023-11-27 17:21:27	2023-11-27 17:21:27	3
26930	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	131	2023-11-09 11:33:46	2023-11-09 11:33:46	1
26931	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par Antonio	f	128	127	2023-11-09 11:33:46	2023-11-09 11:33:46	1
27085	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27086	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27087	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27088	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27089	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27090	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27091	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-10 16:12:58	2023-11-10 16:12:58	1
27092	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-10 16:12:58	2023-11-10 16:12:58	1
26937	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	145	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26938	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26939	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26940	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	127	2023-11-09 11:40:45	2023-11-09 11:40:45	1
26941	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26942	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26943	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26944	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26945	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26946	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26947	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26948	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26949	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2023-11-09 11:40:53	2023-11-09 11:40:53	1
26950	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26951	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26952	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26953	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26954	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26955	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	145	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26956	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26957	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26958	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	127	2023-11-09 15:04:14	2023-11-09 15:04:14	1
26994	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-10 14:41:33	2023-11-10 14:41:33	1
26995	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-10 14:41:33	2023-11-10 14:41:33	1
26996	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-10 14:41:33	2023-11-10 14:41:33	1
26997	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-10 14:41:33	2023-11-10 14:41:33	1
26998	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-10 14:41:33	2023-11-10 14:41:33	1
26999	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-10 14:41:33	2023-11-10 14:41:33	1
27000	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-10 14:41:33	2023-11-10 14:41:33	1
27001	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-10 14:41:33	2023-11-10 14:41:33	1
27069	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27070	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27071	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27072	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27073	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27074	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-10 16:11:33	2023-11-10 16:11:33	1
26959	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	130	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26960	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	135	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26961	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	136	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26962	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	138	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26963	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	144	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26964	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	145	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26965	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	132	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26966	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	131	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26968	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26969	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26970	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26971	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26972	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26973	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26974	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26975	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26977	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	130	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26978	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	135	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26979	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	136	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26980	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	138	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26981	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	144	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26982	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	145	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26983	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	132	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26984	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	f	133	131	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26967	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	t	128	127	2023-11-10 09:05:22	2023-11-10 09:05:22	1
26976	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	t	128	127	2023-11-10 10:23:18	2023-11-10 10:23:18	1
26985	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En cours " par Anja	t	133	127	2023-11-10 11:12:50	2023-11-10 11:12:50	1
26986	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26987	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26988	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26989	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26990	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26991	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26992	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-10 14:41:17	2023-11-10 14:41:17	1
26993	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-10 14:41:17	2023-11-10 14:41:17	1
27002	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27003	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27004	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27005	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27006	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27007	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27008	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27009	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-10 14:44:54	2023-11-10 14:44:54	1
27010	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27011	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27012	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27013	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27014	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27015	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27016	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27017	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-10 15:15:59	2023-11-10 15:15:59	1
27018	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27019	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27020	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27021	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27022	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27023	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27024	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27025	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-10 15:16:20	2023-11-10 15:16:20	1
27026	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27027	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27028	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27029	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27030	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27031	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27032	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27033	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-10 15:17:15	2023-11-10 15:17:15	1
27077	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27078	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27079	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27080	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27081	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27082	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27083	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27084	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-10 16:12:05	2023-11-10 16:12:05	1
27034	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27035	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27036	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27037	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27038	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27039	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27040	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27041	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-10 15:17:29	2023-11-10 15:17:29	1
27042	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27043	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27044	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27045	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27046	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27047	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27048	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27049	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-10 15:17:38	2023-11-10 15:17:38	1
27050	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	130	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27051	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	135	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27052	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	136	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27053	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	138	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27054	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	144	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27055	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	145	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27056	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	132	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27057	Tâche nouvellement créee du nom de test task par PhidiaAdmin dans le projet Project monitoring .	f	127	131	2023-11-10 16:04:17	2023-11-10 16:04:17	5
27058	Anja a été assigné à la tâche test task dans le projet Project monitoring  par PhidiaAdmin	f	127	133	2023-11-10 13:04:17	2023-11-10 13:04:17	6
27061	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27062	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27063	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27064	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27065	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27066	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27067	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27068	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-10 16:11:01	2023-11-10 16:11:01	1
27059	Anja a été assigné à la tâche test task dans le projet Project monitoring  par PhidiaAdmin	f	127	130	2023-11-10 16:04:17	2023-11-10 16:04:17	6
27060	Anja a été assigné à la tâche test task dans le projet Project monitoring  par PhidiaAdmin	f	127	132	2023-11-10 16:04:17	2023-11-10 16:04:17	6
27093	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27094	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27095	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27096	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27097	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27098	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27099	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27100	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2023-11-10 16:13:25	2023-11-10 16:13:25	1
27075	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27076	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-10 16:11:33	2023-11-10 16:11:33	1
27101	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27102	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27103	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27104	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27105	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27106	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27107	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27108	Tâche "Correction du bug concernant les historiques des tâches "\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-10 16:16:30	2023-11-10 16:16:30	1
27109	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27110	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27111	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27112	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27113	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27114	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27115	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27116	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-27 17:06:07	2023-11-27 17:06:07	1
27117	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27118	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27119	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27120	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27121	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27122	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27123	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27124	Tâche "Tableau Bon de production"\n          du projet MADAPLAST mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-27 17:09:34	2023-11-27 17:09:34	1
27141	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27142	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27143	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27144	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27145	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27146	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27147	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27148	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-29 14:22:39	2023-11-29 14:22:39	1
27157	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27158	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27159	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27160	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27161	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27162	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	145	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27163	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27149	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27150	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27151	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27152	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27153	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27154	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27155	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27156	Tâche "debug modification d'une tâche "\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2023-11-29 14:23:23	2023-11-29 14:23:23	1
27164	Tâche "test task"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2023-11-29 14:29:29	2023-11-29 14:29:29	1
27165	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	130	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27166	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	135	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27167	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	136	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27168	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	138	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27169	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	144	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27170	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	145	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27171	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	132	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27172	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	f	128	131	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27173	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En contrôle " par Antonio	t	128	127	2023-12-04 10:32:03	2023-12-04 10:32:03	1
27180	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2023-12-18 14:38:15	2023-12-18 14:38:15	3
27181	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2023-12-18 14:38:15	2023-12-18 14:38:15	3
27182	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27183	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27184	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27185	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27186	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27187	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27188	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27189	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27190	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2024-01-10 14:17:52	2024-01-10 14:17:52	1
27191	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27192	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27193	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27194	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27195	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27196	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27197	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27198	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27199	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2024-01-10 14:19:25	2024-01-10 14:19:25	1
27200	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27201	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27202	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27203	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27204	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27205	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	145	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27206	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27207	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27208	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	127	2024-01-10 14:19:52	2024-01-10 14:19:52	1
27209	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27210	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27211	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27212	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27213	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27214	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27269	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27215	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27216	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27217	Tâche "Correction du bug concernant les historiques des tâches (design) "\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2024-01-10 14:20:05	2024-01-10 14:20:05	1
27218	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27219	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27220	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27221	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27222	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27223	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27224	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27225	Tâche Correction du bug concernant les historiques des tâches (design)  supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:53:48	2024-01-12 09:53:48	3
27226	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27227	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27228	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27229	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27230	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27231	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27232	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27233	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:55:05	2024-01-12 09:55:05	3
27234	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27235	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27236	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27237	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27238	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27239	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27240	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27241	Tâche debug modification d'une tâche  supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:55:26	2024-01-12 09:55:26	3
27242	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27243	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27244	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27245	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27246	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27247	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27248	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27249	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:55:34	2024-01-12 09:55:34	3
27250	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27251	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27252	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27253	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27254	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27255	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27256	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27257	Tâche Correction du bug concernant les historiques des tâches  supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:55:46	2024-01-12 09:55:46	3
27258	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27259	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27260	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27261	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27262	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27263	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27264	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27265	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:55:53	2024-01-12 09:55:53	3
27266	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27267	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27268	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27270	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27271	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27272	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27273	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:56:08	2024-01-12 09:56:08	3
27274	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27275	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27276	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27277	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27278	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27279	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27280	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27281	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 09:59:39	2024-01-12 09:59:39	3
27282	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27283	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27284	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27285	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27286	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27287	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27288	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27289	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 10:00:06	2024-01-12 10:00:06	3
27290	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	130	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27291	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	135	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27292	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	136	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27293	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	138	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27294	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	144	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27295	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	145	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27296	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	132	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27297	Tâche "test task"\n          du projet Project monitoring  mise dans " En blocage " par PhidiaAdmin	f	127	131	2024-01-12 10:00:13	2024-01-12 10:00:13	1
27298	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27299	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27300	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27301	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27302	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27303	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27304	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27305	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 10:00:22	2024-01-12 10:00:22	3
27338	Antonio a été assigné à la tâche teste suppression dans le projet Project monitoring  par Frederick	f	145	128	2024-01-12 07:07:58	2024-01-12 07:07:58	6
27339	Antonio a été assigné à la tâche teste suppression dans le projet Project monitoring  par Frederick	f	145	130	2024-01-12 10:07:58	2024-01-12 10:07:58	6
27340	Antonio a été assigné à la tâche teste suppression dans le projet Project monitoring  par Frederick	f	145	132	2024-01-12 10:07:58	2024-01-12 10:07:58	6
27341	Antonio a été assigné à la tâche teste suppression dans le projet Project monitoring  par Frederick	f	145	127	2024-01-12 10:07:58	2024-01-12 10:07:58	6
27342	Tâche teste suppression supprimé par Antonio.	f	128	130	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27343	Tâche teste suppression supprimé par Antonio.	f	128	135	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27344	Tâche teste suppression supprimé par Antonio.	f	128	136	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27345	Tâche teste suppression supprimé par Antonio.	f	128	138	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27346	Tâche teste suppression supprimé par Antonio.	f	128	144	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27347	Tâche teste suppression supprimé par Antonio.	f	128	145	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27348	Tâche teste suppression supprimé par Antonio.	f	128	132	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27349	Tâche teste suppression supprimé par Antonio.	f	128	131	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27350	Tâche teste suppression supprimé par Antonio.	f	128	127	2024-01-12 10:10:10	2024-01-12 10:10:10	3
27306	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	130	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27307	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	135	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27308	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	136	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27309	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	138	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27310	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	144	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27311	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	145	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27312	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	132	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27313	Tâche "test task"\n          du projet Project monitoring  mise dans " A faire " par PhidiaAdmin	f	127	131	2024-01-12 10:00:47	2024-01-12 10:00:47	1
27314	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27315	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27316	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27317	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27318	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27319	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27320	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27321	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 10:01:00	2024-01-12 10:01:00	3
27322	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27323	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27324	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27325	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27326	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27327	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27328	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27329	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 10:01:23	2024-01-12 10:01:23	3
27330	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	130	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27331	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	135	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27332	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	136	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27333	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	138	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27334	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	144	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27335	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	132	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27336	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	131	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27337	Tâche nouvellement créee du nom de teste suppression par Frederick dans le projet Project monitoring .	f	145	127	2024-01-12 10:07:58	2024-01-12 10:07:58	5
27351	Tâche test task supprimé par Frederick.	f	145	130	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27352	Tâche test task supprimé par Frederick.	f	145	135	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27353	Tâche test task supprimé par Frederick.	f	145	136	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27354	Tâche test task supprimé par Frederick.	f	145	138	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27355	Tâche test task supprimé par Frederick.	f	145	144	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27356	Tâche test task supprimé par Frederick.	f	145	132	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27357	Tâche test task supprimé par Frederick.	f	145	131	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27358	Tâche test task supprimé par Frederick.	f	145	127	2024-01-12 10:10:50	2024-01-12 10:10:50	3
27367	Tâche test task supprimé par Frederick.	f	145	130	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27368	Tâche test task supprimé par Frederick.	f	145	135	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27369	Tâche test task supprimé par Frederick.	f	145	136	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27370	Tâche test task supprimé par Frederick.	f	145	138	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27371	Tâche test task supprimé par Frederick.	f	145	144	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27372	Tâche test task supprimé par Frederick.	f	145	132	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27373	Tâche test task supprimé par Frederick.	f	145	131	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27374	Tâche test task supprimé par Frederick.	f	145	127	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27375	Tâche test task supprimé par Frederick.	f	145	152	2024-01-12 11:24:31	2024-01-12 11:24:31	3
27359	Tâche test task supprimé par PhidiaAdmin.	f	127	130	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27360	Tâche test task supprimé par PhidiaAdmin.	f	127	135	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27361	Tâche test task supprimé par PhidiaAdmin.	f	127	136	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27362	Tâche test task supprimé par PhidiaAdmin.	f	127	138	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27363	Tâche test task supprimé par PhidiaAdmin.	f	127	144	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27364	Tâche test task supprimé par PhidiaAdmin.	f	127	145	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27365	Tâche test task supprimé par PhidiaAdmin.	f	127	132	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27366	Tâche test task supprimé par PhidiaAdmin.	f	127	131	2024-01-12 10:12:07	2024-01-12 10:12:07	3
27376	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	130	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27377	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	135	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27378	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	136	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27379	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	138	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27380	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	144	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27381	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	145	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27382	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	132	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27383	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	131	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27384	Tâche nouvellement créee du nom de teste de la mort par PhidiaAdmin dans le projet Project monitoring .	f	127	152	2024-01-18 10:30:49	2024-01-18 10:30:49	5
27385	Antonio a été assigné à la tâche teste de la mort dans le projet Project monitoring  par PhidiaAdmin	f	127	128	2024-01-18 07:30:49	2024-01-18 07:30:49	6
27386	Antonio a été assigné à la tâche teste de la mort dans le projet Project monitoring  par PhidiaAdmin	f	127	130	2024-01-18 10:30:49	2024-01-18 10:30:49	6
27387	Antonio a été assigné à la tâche teste de la mort dans le projet Project monitoring  par PhidiaAdmin	f	127	132	2024-01-18 10:30:49	2024-01-18 10:30:49	6
27388	Antonio a été assigné à la tâche teste de la mort dans le projet Project monitoring  par PhidiaAdmin	f	127	152	2024-01-18 10:30:49	2024-01-18 10:30:49	6
27389	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	130	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27390	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	135	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27391	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	136	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27392	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	138	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27393	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	144	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27394	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	145	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27395	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	132	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27396	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	131	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27397	Tâche nouvellement créee du nom de teste sous taches par PhidiaAdmin dans le projet Project monitoring .	f	127	152	2024-01-18 10:31:10	2024-01-18 10:31:10	5
27398	Antonio a été assigné à la tâche teste sous taches dans le projet Project monitoring  par PhidiaAdmin	f	127	128	2024-01-18 07:31:10	2024-01-18 07:31:10	6
27399	Antonio a été assigné à la tâche teste sous taches dans le projet Project monitoring  par PhidiaAdmin	f	127	130	2024-01-18 10:31:10	2024-01-18 10:31:10	6
27400	Antonio a été assigné à la tâche teste sous taches dans le projet Project monitoring  par PhidiaAdmin	f	127	132	2024-01-18 10:31:10	2024-01-18 10:31:10	6
27401	Antonio a été assigné à la tâche teste sous taches dans le projet Project monitoring  par PhidiaAdmin	f	127	152	2024-01-18 10:31:10	2024-01-18 10:31:10	6
27402	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	130	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27403	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	135	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27404	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	136	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27405	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	138	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27406	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	144	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27408	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	132	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27409	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	131	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27410	Tâche teste sous taches supprimé par PhidiaAdmin.	f	127	152	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27411	Antonio a été assigné à la sous-tâche teste sous taches dd du projet Project monitoring  par PhidiaAdmin	f	127	128	2024-01-18 07:47:06	2024-01-18 07:47:06	6
27412	Antonio a été assigné à la sous-tâche teste sous taches dd du projet Project monitoring  par PhidiaAdmin	f	127	130	2024-01-18 10:47:06	2024-01-18 10:47:06	6
27413	Antonio a été assigné à la sous-tâche teste sous taches dd du projet Project monitoring  par PhidiaAdmin	f	127	132	2024-01-18 10:47:06	2024-01-18 10:47:06	6
27414	Antonio a été assigné à la sous-tâche teste sous taches dd du projet Project monitoring  par PhidiaAdmin	f	127	152	2024-01-18 10:47:06	2024-01-18 10:47:06	6
27415	Antonio a été assigné à la sous-tâche sous tache 2 du projet Project monitoring  par PhidiaAdmin	f	127	128	2024-01-18 07:47:35	2024-01-18 07:47:35	6
27469	La tâche teste sous taches a été mise en cours.	f	128	135	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27416	Antonio a été assigné à la sous-tâche sous tache 2 du projet Project monitoring  par PhidiaAdmin	f	127	130	2024-01-18 10:47:35	2024-01-18 10:47:35	6
27417	Antonio a été assigné à la sous-tâche sous tache 2 du projet Project monitoring  par PhidiaAdmin	f	127	132	2024-01-18 10:47:35	2024-01-18 10:47:35	6
27418	Antonio a été assigné à la sous-tâche sous tache 2 du projet Project monitoring  par PhidiaAdmin	f	127	152	2024-01-18 10:47:35	2024-01-18 10:47:35	6
27419	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	130	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27420	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	135	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27421	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	136	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27422	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	138	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27423	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	144	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27425	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	132	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27426	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	131	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27427	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	127	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27428	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	f	128	152	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27429	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	130	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27430	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	135	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27431	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	136	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27432	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	138	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27433	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	144	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27435	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	132	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27436	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	131	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27437	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	f	127	152	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27438	La tâche sous tache 2 a été mise en cours.	f	128	130	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27439	La tâche sous tache 2 a été mise en cours.	f	128	135	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27440	La tâche sous tache 2 a été mise en cours.	f	128	136	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27441	La tâche sous tache 2 a été mise en cours.	f	128	138	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27442	La tâche sous tache 2 a été mise en cours.	f	128	144	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27444	La tâche sous tache 2 a été mise en cours.	f	128	132	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27445	La tâche sous tache 2 a été mise en cours.	f	128	131	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27446	La tâche sous tache 2 a été mise en cours.	f	128	127	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27447	La tâche sous tache 2 a été mise en cours.	f	128	152	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27448	La tâche teste sous taches dd a été mise en cours.	f	128	130	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27449	La tâche teste sous taches dd a été mise en cours.	f	128	135	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27450	La tâche teste sous taches dd a été mise en cours.	f	128	136	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27451	La tâche teste sous taches dd a été mise en cours.	f	128	138	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27452	La tâche teste sous taches dd a été mise en cours.	f	128	144	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27454	La tâche teste sous taches dd a été mise en cours.	f	128	132	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27455	La tâche teste sous taches dd a été mise en cours.	f	128	131	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27456	La tâche teste sous taches dd a été mise en cours.	f	128	127	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27457	La tâche teste sous taches dd a été mise en cours.	f	128	152	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27458	La tâche teste sous taches dd a été mise en cours.	f	128	130	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27459	La tâche teste sous taches dd a été mise en cours.	f	128	135	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27460	La tâche teste sous taches dd a été mise en cours.	f	128	136	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27461	La tâche teste sous taches dd a été mise en cours.	f	128	138	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27462	La tâche teste sous taches dd a été mise en cours.	f	128	144	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27464	La tâche teste sous taches dd a été mise en cours.	f	128	132	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27465	La tâche teste sous taches dd a été mise en cours.	f	128	131	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27466	La tâche teste sous taches dd a été mise en cours.	f	128	127	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27467	La tâche teste sous taches dd a été mise en cours.	f	128	152	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27468	La tâche teste sous taches a été mise en cours.	f	128	130	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27443	La tâche sous tache 2 a été mise en cours.	t	128	145	2024-01-22 10:43:12	2024-01-22 10:43:12	4
27470	La tâche teste sous taches a été mise en cours.	f	128	136	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27471	La tâche teste sous taches a été mise en cours.	f	128	138	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27472	La tâche teste sous taches a été mise en cours.	f	128	144	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27474	La tâche teste sous taches a été mise en cours.	f	128	132	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27475	La tâche teste sous taches a été mise en cours.	f	128	131	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27476	La tâche teste sous taches a été mise en cours.	f	128	127	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27477	La tâche teste sous taches a été mise en cours.	f	128	152	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27478	La tâche teste sous taches dd a été mise en cours.	f	128	130	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27479	La tâche teste sous taches dd a été mise en cours.	f	128	135	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27480	La tâche teste sous taches dd a été mise en cours.	f	128	136	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27481	La tâche teste sous taches dd a été mise en cours.	f	128	138	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27482	La tâche teste sous taches dd a été mise en cours.	f	128	144	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27484	La tâche teste sous taches dd a été mise en cours.	f	128	132	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27485	La tâche teste sous taches dd a été mise en cours.	f	128	131	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27486	La tâche teste sous taches dd a été mise en cours.	f	128	127	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27487	La tâche teste sous taches dd a été mise en cours.	f	128	152	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27488	Tâche teste de la mort supprimé par Frederick.	f	145	130	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27489	Tâche teste de la mort supprimé par Frederick.	f	145	135	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27490	Tâche teste de la mort supprimé par Frederick.	f	145	136	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27491	Tâche teste de la mort supprimé par Frederick.	f	145	138	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27492	Tâche teste de la mort supprimé par Frederick.	f	145	144	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27493	Tâche teste de la mort supprimé par Frederick.	f	145	132	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27494	Tâche teste de la mort supprimé par Frederick.	f	145	131	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27495	Tâche teste de la mort supprimé par Frederick.	f	145	127	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27496	Tâche teste de la mort supprimé par Frederick.	f	145	152	2024-01-25 13:04:02	2024-01-25 13:04:02	3
27497	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	130	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27498	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	135	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27499	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	136	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27500	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	138	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27501	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	144	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27502	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	132	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27503	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	131	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27504	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	127	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27505	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	152	2024-01-25 14:05:33	2024-01-25 14:05:33	1
27506	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	130	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27507	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	135	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27508	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	136	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27509	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	138	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27510	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	144	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27511	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	132	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27512	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	131	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27513	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	127	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27514	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	152	2024-01-25 14:38:18	2024-01-25 14:38:18	1
27515	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	130	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27516	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	135	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27517	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	136	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27518	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	138	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27519	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	144	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27520	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	132	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27521	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	131	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27522	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	127	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27523	Tâche "sous tache 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	152	2024-01-25 14:39:09	2024-01-25 14:39:09	1
27524	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	130	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27525	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	135	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27526	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	136	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27527	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	138	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27528	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	144	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27529	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	132	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27530	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	131	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27531	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	127	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27532	Tâche nouvellement créee du nom de teste de la mort 2 par Frederick dans le projet Project monitoring .	f	145	152	2024-01-25 14:45:47	2024-01-25 14:45:47	5
27556	Antonio a été assigné à la tâche et encore du teste  dans le projet Project monitoring  par Frederick	f	145	128	2024-01-25 12:56:23	2024-01-25 12:56:23	6
27557	Antonio a été assigné à la tâche et encore du teste  dans le projet Project monitoring  par Frederick	f	145	130	2024-01-25 15:56:23	2024-01-25 15:56:23	6
27558	Antonio a été assigné à la tâche et encore du teste  dans le projet Project monitoring  par Frederick	f	145	132	2024-01-25 15:56:23	2024-01-25 15:56:23	6
27559	Antonio a été assigné à la tâche et encore du teste  dans le projet Project monitoring  par Frederick	f	145	127	2024-01-25 15:56:23	2024-01-25 15:56:23	6
27560	Antonio a été assigné à la tâche et encore du teste  dans le projet Project monitoring  par Frederick	f	145	152	2024-01-25 15:56:23	2024-01-25 15:56:23	6
27533	Mickaël a été assigné à la tâche teste de la mort 2 dans le projet Project monitoring  par Frederick	t	145	143	2024-01-25 11:45:47	2024-01-25 11:45:47	6
27534	Mickaël a été assigné à la tâche teste de la mort 2 dans le projet Project monitoring  par Frederick	f	145	130	2024-01-25 14:45:47	2024-01-25 14:45:47	6
27535	Mickaël a été assigné à la tâche teste de la mort 2 dans le projet Project monitoring  par Frederick	f	145	132	2024-01-25 14:45:47	2024-01-25 14:45:47	6
27536	Mickaël a été assigné à la tâche teste de la mort 2 dans le projet Project monitoring  par Frederick	f	145	127	2024-01-25 14:45:47	2024-01-25 14:45:47	6
27537	Mickaël a été assigné à la tâche teste de la mort 2 dans le projet Project monitoring  par Frederick	f	145	152	2024-01-25 14:45:47	2024-01-25 14:45:47	6
27407	Tâche teste sous taches supprimé par PhidiaAdmin.	t	127	145	2024-01-18 10:32:26	2024-01-18 10:32:26	3
27424	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En blocage " par Antonio	t	128	145	2024-01-18 14:56:49	2024-01-18 14:56:49	1
27434	Tâche "teste de la mort"\n          du projet Project monitoring  mise dans " En cours " par PhidiaAdmin	t	127	145	2024-01-19 12:10:41	2024-01-19 12:10:41	1
27453	La tâche teste sous taches dd a été mise en cours.	t	128	145	2024-01-22 15:53:29	2024-01-22 15:53:29	4
27463	La tâche teste sous taches dd a été mise en cours.	t	128	145	2024-01-22 15:53:32	2024-01-22 15:53:32	4
27473	La tâche teste sous taches a été mise en cours.	t	128	145	2024-01-22 15:54:19	2024-01-22 15:54:19	4
27483	La tâche teste sous taches dd a été mise en cours.	t	128	145	2024-01-22 15:55:02	2024-01-22 15:55:02	4
27538	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	130	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27539	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	135	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27540	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	136	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27541	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	138	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27542	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	144	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27543	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	132	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27544	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	131	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27545	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	127	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27546	Tâche "teste sous taches"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	152	2024-01-25 15:55:50	2024-01-25 15:55:50	1
27547	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	130	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27548	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	135	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27549	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	136	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27550	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	138	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27551	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	144	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27552	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	132	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27553	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	131	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27554	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	127	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27555	Tâche nouvellement créee du nom de et encore du teste  par Frederick dans le projet Project monitoring .	f	145	152	2024-01-25 15:56:23	2024-01-25 15:56:23	5
27561	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	130	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27562	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	135	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27563	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	136	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27564	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	138	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27565	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	144	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27566	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	132	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27567	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	131	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27568	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	127	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27569	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	152	2024-01-25 16:01:53	2024-01-25 16:01:53	1
27570	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	130	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27571	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	135	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27572	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	136	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27573	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	138	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27574	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	144	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27575	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	132	2024-01-25 16:03:46	2024-01-25 16:03:46	1
28026	La tâche Mon sous doudou a été mise en cours.	f	128	132	2024-02-07 16:50:46	2024-02-07 16:50:46	4
27576	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	131	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27577	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	127	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27578	Tâche "teste de la mort 2"\n          du projet Project monitoring  mise dans " En cours " par Frederick	f	145	152	2024-01-25 16:03:46	2024-01-25 16:03:46	1
27579	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	130	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27580	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	135	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27581	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	136	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27582	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	138	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27583	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	144	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27584	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	132	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27585	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	131	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27586	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	127	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27587	Tâche "et encore du teste "\n          du projet Project monitoring  mise dans " En blocage " par Frederick	f	145	152	2024-01-25 16:04:16	2024-01-25 16:04:16	1
27588	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	130	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27589	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	135	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27590	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	136	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27591	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	138	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27592	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	144	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27593	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	132	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27594	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	131	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27595	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	127	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27596	Tâche nouvellement créee du nom de teste 3 par Frederick dans le projet Project monitoring .	f	145	152	2024-01-29 09:14:13	2024-01-29 09:14:13	5
27597	Loïc a été assigné à la tâche teste 3 dans le projet Project monitoring  par Frederick	f	145	134	2024-01-29 06:14:13	2024-01-29 06:14:13	6
27598	Loïc a été assigné à la tâche teste 3 dans le projet Project monitoring  par Frederick	f	145	130	2024-01-29 09:14:13	2024-01-29 09:14:13	6
27599	Loïc a été assigné à la tâche teste 3 dans le projet Project monitoring  par Frederick	f	145	132	2024-01-29 09:14:13	2024-01-29 09:14:13	6
27600	Loïc a été assigné à la tâche teste 3 dans le projet Project monitoring  par Frederick	f	145	127	2024-01-29 09:14:13	2024-01-29 09:14:13	6
27601	Loïc a été assigné à la tâche teste 3 dans le projet Project monitoring  par Frederick	f	145	152	2024-01-29 09:14:13	2024-01-29 09:14:13	6
27602	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	130	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27603	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	135	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27604	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	136	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27605	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	138	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27606	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	144	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27607	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	132	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27608	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	131	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27609	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	127	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27610	Tâche nouvellement créee du nom de test 4 par Frederick dans le projet Project monitoring .	f	145	152	2024-01-29 09:37:24	2024-01-29 09:37:24	5
27611	Loïc a été assigné à la tâche test 4 dans le projet Project monitoring  par Frederick	f	145	134	2024-01-29 06:37:24	2024-01-29 06:37:24	6
27612	Loïc a été assigné à la tâche test 4 dans le projet Project monitoring  par Frederick	f	145	130	2024-01-29 09:37:24	2024-01-29 09:37:24	6
27613	Loïc a été assigné à la tâche test 4 dans le projet Project monitoring  par Frederick	f	145	132	2024-01-29 09:37:24	2024-01-29 09:37:24	6
27614	Loïc a été assigné à la tâche test 4 dans le projet Project monitoring  par Frederick	f	145	127	2024-01-29 09:37:24	2024-01-29 09:37:24	6
27615	Loïc a été assigné à la tâche test 4 dans le projet Project monitoring  par Frederick	f	145	152	2024-01-29 09:37:24	2024-01-29 09:37:24	6
27616	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	130	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27617	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	135	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27618	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	136	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27619	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	138	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27620	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	144	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27621	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	132	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27622	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	131	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27623	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	127	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27624	Tâche nouvellement créee du nom de test 5 par Frederick dans le projet Project monitoring .	f	145	152	2024-01-29 09:38:20	2024-01-29 09:38:20	5
27630	La tâche test 5 a été mise en cours.	f	134	130	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27631	La tâche test 5 a été mise en cours.	f	134	135	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27632	La tâche test 5 a été mise en cours.	f	134	136	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27633	La tâche test 5 a été mise en cours.	f	134	138	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27634	La tâche test 5 a été mise en cours.	f	134	144	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27635	La tâche test 5 a été mise en cours.	f	134	145	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27636	La tâche test 5 a été mise en cours.	f	134	132	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27637	La tâche test 5 a été mise en cours.	f	134	131	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27638	La tâche test 5 a été mise en cours.	f	134	127	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27639	La tâche test 5 a été mise en cours.	f	134	152	2024-01-29 16:19:38	2024-01-29 16:19:38	4
27625	Loïc a été assigné à la tâche test 5 dans le projet Project monitoring  par Frederick	f	145	134	2024-01-29 06:38:20	2024-01-29 06:38:20	6
27626	Loïc a été assigné à la tâche test 5 dans le projet Project monitoring  par Frederick	f	145	130	2024-01-29 09:38:20	2024-01-29 09:38:20	6
27627	Loïc a été assigné à la tâche test 5 dans le projet Project monitoring  par Frederick	f	145	132	2024-01-29 09:38:20	2024-01-29 09:38:20	6
27628	Loïc a été assigné à la tâche test 5 dans le projet Project monitoring  par Frederick	f	145	127	2024-01-29 09:38:20	2024-01-29 09:38:20	6
27629	Loïc a été assigné à la tâche test 5 dans le projet Project monitoring  par Frederick	f	145	152	2024-01-29 09:38:20	2024-01-29 09:38:20	6
27640	La tâche teste 3 a été mise en cours.	f	134	130	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27641	La tâche teste 3 a été mise en cours.	f	134	135	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27642	La tâche teste 3 a été mise en cours.	f	134	136	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27643	La tâche teste 3 a été mise en cours.	f	134	138	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27644	La tâche teste 3 a été mise en cours.	f	134	144	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27645	La tâche teste 3 a été mise en cours.	f	134	145	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27646	La tâche teste 3 a été mise en cours.	f	134	132	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27647	La tâche teste 3 a été mise en cours.	f	134	131	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27648	La tâche teste 3 a été mise en cours.	f	134	127	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27649	La tâche teste 3 a été mise en cours.	f	134	152	2024-01-29 17:24:45	2024-01-29 17:24:45	4
27650	La tâche test 4 a été mise en cours.	f	134	130	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27651	La tâche test 4 a été mise en cours.	f	134	135	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27652	La tâche test 4 a été mise en cours.	f	134	136	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27653	La tâche test 4 a été mise en cours.	f	134	138	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27654	La tâche test 4 a été mise en cours.	f	134	144	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27655	La tâche test 4 a été mise en cours.	f	134	145	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27656	La tâche test 4 a été mise en cours.	f	134	132	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27657	La tâche test 4 a été mise en cours.	f	134	131	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27658	La tâche test 4 a été mise en cours.	f	134	127	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27659	La tâche test 4 a été mise en cours.	f	134	152	2024-01-29 17:29:39	2024-01-29 17:29:39	4
27660	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	130	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27661	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	135	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27662	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	136	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27663	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	138	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27664	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	144	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27665	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	132	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27666	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	131	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27667	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	152	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27668	Tâche nouvellement créee du nom de haha mety amizay par Frederick dans le projet Project monitoring .	f	145	127	2024-01-31 16:08:28	2024-01-31 16:08:28	5
27669	Ioly a été assigné à la tâche haha mety amizay dans le projet Project monitoring  par Frederick	f	145	135	2024-01-31 13:08:28	2024-01-31 13:08:28	6
27670	Ioly a été assigné à la tâche haha mety amizay dans le projet Project monitoring  par Frederick	f	145	130	2024-01-31 16:08:28	2024-01-31 16:08:28	6
27671	Ioly a été assigné à la tâche haha mety amizay dans le projet Project monitoring  par Frederick	f	145	132	2024-01-31 16:08:28	2024-01-31 16:08:28	6
27672	Ioly a été assigné à la tâche haha mety amizay dans le projet Project monitoring  par Frederick	f	145	152	2024-01-31 16:08:28	2024-01-31 16:08:28	6
27673	Ioly a été assigné à la tâche haha mety amizay dans le projet Project monitoring  par Frederick	f	145	127	2024-01-31 16:08:28	2024-01-31 16:08:28	6
27674	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	130	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27675	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	135	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27676	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	136	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27677	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	138	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27678	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	144	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27679	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	132	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27680	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	131	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27681	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	152	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27682	Tâche nouvellement créee du nom de bababababa par Frederick dans le projet Project monitoring .	f	145	127	2024-01-31 16:13:00	2024-01-31 16:13:00	5
27683	Antonio a été assigné à la tâche bababababa dans le projet Project monitoring  par Frederick	f	145	128	2024-01-31 13:13:00	2024-01-31 13:13:00	6
27684	Antonio a été assigné à la tâche bababababa dans le projet Project monitoring  par Frederick	f	145	130	2024-01-31 16:13:00	2024-01-31 16:13:00	6
27685	Antonio a été assigné à la tâche bababababa dans le projet Project monitoring  par Frederick	f	145	132	2024-01-31 16:13:00	2024-01-31 16:13:00	6
27686	Antonio a été assigné à la tâche bababababa dans le projet Project monitoring  par Frederick	f	145	152	2024-01-31 16:13:00	2024-01-31 16:13:00	6
27687	Antonio a été assigné à la tâche bababababa dans le projet Project monitoring  par Frederick	f	145	127	2024-01-31 16:13:00	2024-01-31 16:13:00	6
27688	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	130	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27689	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	135	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27690	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	136	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27691	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	138	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27692	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	144	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27693	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	132	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27694	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	131	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27695	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	152	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27696	Tâche nouvellement créee du nom de test ultime par Frederick dans le projet Project monitoring .	f	145	127	2024-01-31 16:24:10	2024-01-31 16:24:10	5
27697	Antonio a été assigné à la tâche test ultime dans le projet Project monitoring  par Frederick	f	145	128	2024-01-31 13:24:10	2024-01-31 13:24:10	6
27698	Antonio a été assigné à la tâche test ultime dans le projet Project monitoring  par Frederick	f	145	130	2024-01-31 16:24:10	2024-01-31 16:24:10	6
27699	Antonio a été assigné à la tâche test ultime dans le projet Project monitoring  par Frederick	f	145	132	2024-01-31 16:24:10	2024-01-31 16:24:10	6
27700	Antonio a été assigné à la tâche test ultime dans le projet Project monitoring  par Frederick	f	145	152	2024-01-31 16:24:10	2024-01-31 16:24:10	6
27701	Antonio a été assigné à la tâche test ultime dans le projet Project monitoring  par Frederick	f	145	127	2024-01-31 16:24:10	2024-01-31 16:24:10	6
27702	La tâche test ultime a été mise en cours.	f	128	130	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27703	La tâche test ultime a été mise en cours.	f	128	135	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27704	La tâche test ultime a été mise en cours.	f	128	136	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27705	La tâche test ultime a été mise en cours.	f	128	138	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27706	La tâche test ultime a été mise en cours.	f	128	144	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27707	La tâche test ultime a été mise en cours.	f	128	145	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27708	La tâche test ultime a été mise en cours.	f	128	132	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27709	La tâche test ultime a été mise en cours.	f	128	131	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27710	La tâche test ultime a été mise en cours.	f	128	152	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27711	La tâche test ultime a été mise en cours.	f	128	127	2024-01-31 16:39:35	2024-01-31 16:39:35	4
27712	Antonio a été assigné à la sous-tâche aa du projet Project monitoring  par Antonio	f	128	128	2024-02-01 11:44:18	2024-02-01 11:44:18	6
27713	Antonio a été assigné à la sous-tâche aa du projet Project monitoring  par Antonio	f	128	130	2024-02-01 14:44:18	2024-02-01 14:44:18	6
27714	Antonio a été assigné à la sous-tâche aa du projet Project monitoring  par Antonio	f	128	132	2024-02-01 14:44:18	2024-02-01 14:44:18	6
27715	Antonio a été assigné à la sous-tâche aa du projet Project monitoring  par Antonio	f	128	152	2024-02-01 14:44:18	2024-02-01 14:44:18	6
27716	Antonio a été assigné à la sous-tâche aa du projet Project monitoring  par Antonio	f	128	127	2024-02-01 14:44:18	2024-02-01 14:44:18	6
27717	La tâche aa a été mise en cours.	f	128	130	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27718	La tâche aa a été mise en cours.	f	128	135	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27719	La tâche aa a été mise en cours.	f	128	136	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27720	La tâche aa a été mise en cours.	f	128	138	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27721	La tâche aa a été mise en cours.	f	128	144	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27722	La tâche aa a été mise en cours.	f	128	145	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27723	La tâche aa a été mise en cours.	f	128	132	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27724	La tâche aa a été mise en cours.	f	128	131	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27725	La tâche aa a été mise en cours.	f	128	152	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27726	La tâche aa a été mise en cours.	f	128	127	2024-02-01 14:45:41	2024-02-01 14:45:41	4
27727	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	130	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27728	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	135	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27729	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	136	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27730	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	138	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27731	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	144	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27732	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	145	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27733	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	132	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27734	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	131	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27735	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	152	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27736	Tâche nouvellement créee du nom de teste confirmation par attributeur par Antonio dans le projet Project monitoring .	f	128	127	2024-02-01 15:53:43	2024-02-01 15:53:43	5
27737	Antonio a été assigné à la tâche teste confirmation par attributeur dans le projet Project monitoring  par Antonio	f	128	128	2024-02-01 12:53:43	2024-02-01 12:53:43	6
27738	Antonio a été assigné à la tâche teste confirmation par attributeur dans le projet Project monitoring  par Antonio	f	128	130	2024-02-01 15:53:43	2024-02-01 15:53:43	6
27739	Antonio a été assigné à la tâche teste confirmation par attributeur dans le projet Project monitoring  par Antonio	f	128	132	2024-02-01 15:53:43	2024-02-01 15:53:43	6
27740	Antonio a été assigné à la tâche teste confirmation par attributeur dans le projet Project monitoring  par Antonio	f	128	152	2024-02-01 15:53:43	2024-02-01 15:53:43	6
27741	Antonio a été assigné à la tâche teste confirmation par attributeur dans le projet Project monitoring  par Antonio	f	128	127	2024-02-01 15:53:43	2024-02-01 15:53:43	6
27742	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	130	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27743	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	135	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27744	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	136	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27745	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	138	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27746	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	144	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27747	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	132	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27748	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	131	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27749	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	152	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27750	Tâche nouvellement créee du nom de teste  par attributeur par Frederick dans le projet Project monitoring .	f	145	127	2024-02-01 15:55:56	2024-02-01 15:55:56	5
27770	Antonio a été assigné à la tâche teste confirmation par attributeur 2 dans le projet Project monitoring  par Frederick	f	145	128	2024-02-01 13:01:26	2024-02-01 13:01:26	6
27751	Antonio a été assigné à la tâche teste  par attributeur dans le projet Project monitoring  par Frederick	f	145	128	2024-02-01 12:55:56	2024-02-01 12:55:56	6
27752	Antonio a été assigné à la tâche teste  par attributeur dans le projet Project monitoring  par Frederick	f	145	130	2024-02-01 15:55:56	2024-02-01 15:55:56	6
27753	Antonio a été assigné à la tâche teste  par attributeur dans le projet Project monitoring  par Frederick	f	145	132	2024-02-01 15:55:56	2024-02-01 15:55:56	6
27754	Antonio a été assigné à la tâche teste  par attributeur dans le projet Project monitoring  par Frederick	f	145	152	2024-02-01 15:55:56	2024-02-01 15:55:56	6
27755	Antonio a été assigné à la tâche teste  par attributeur dans le projet Project monitoring  par Frederick	f	145	127	2024-02-01 15:55:56	2024-02-01 15:55:56	6
27756	Antonio a été assigné à la sous-tâche teste sous par attributeur du projet Project monitoring  par Frederick	f	145	128	2024-02-01 12:57:57	2024-02-01 12:57:57	6
27757	Antonio a été assigné à la sous-tâche teste sous par attributeur du projet Project monitoring  par Frederick	f	145	130	2024-02-01 15:57:57	2024-02-01 15:57:57	6
27758	Antonio a été assigné à la sous-tâche teste sous par attributeur du projet Project monitoring  par Frederick	f	145	132	2024-02-01 15:57:57	2024-02-01 15:57:57	6
27759	Antonio a été assigné à la sous-tâche teste sous par attributeur du projet Project monitoring  par Frederick	f	145	152	2024-02-01 15:57:57	2024-02-01 15:57:57	6
27760	Antonio a été assigné à la sous-tâche teste sous par attributeur du projet Project monitoring  par Frederick	f	145	127	2024-02-01 15:57:57	2024-02-01 15:57:57	6
27761	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	130	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27762	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	135	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27763	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	136	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27764	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	138	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27765	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	144	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27766	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	132	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27767	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	131	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27768	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	152	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27769	Tâche nouvellement créee du nom de teste confirmation par attributeur 2 par Frederick dans le projet Project monitoring .	f	145	127	2024-02-01 16:01:26	2024-02-01 16:01:26	5
27771	Antonio a été assigné à la tâche teste confirmation par attributeur 2 dans le projet Project monitoring  par Frederick	f	145	130	2024-02-01 16:01:26	2024-02-01 16:01:26	6
27772	Antonio a été assigné à la tâche teste confirmation par attributeur 2 dans le projet Project monitoring  par Frederick	f	145	132	2024-02-01 16:01:26	2024-02-01 16:01:26	6
27773	Antonio a été assigné à la tâche teste confirmation par attributeur 2 dans le projet Project monitoring  par Frederick	f	145	152	2024-02-01 16:01:26	2024-02-01 16:01:26	6
27774	Antonio a été assigné à la tâche teste confirmation par attributeur 2 dans le projet Project monitoring  par Frederick	f	145	127	2024-02-01 16:01:26	2024-02-01 16:01:26	6
27775	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	130	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27776	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	135	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27777	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	136	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27778	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	138	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27779	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	144	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27780	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	145	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27781	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	132	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27782	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	131	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27783	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	152	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27784	Tâche nouvellement créee du nom de test changeset par Antonio dans le projet Project monitoring .	f	128	127	2024-02-01 16:06:11	2024-02-01 16:06:11	5
27785	Antonio a été assigné à la tâche test changeset dans le projet Project monitoring  par Antonio	f	128	128	2024-02-01 13:06:11	2024-02-01 13:06:11	6
27786	Antonio a été assigné à la tâche test changeset dans le projet Project monitoring  par Antonio	f	128	130	2024-02-01 16:06:11	2024-02-01 16:06:11	6
27787	Antonio a été assigné à la tâche test changeset dans le projet Project monitoring  par Antonio	f	128	132	2024-02-01 16:06:11	2024-02-01 16:06:11	6
27788	Antonio a été assigné à la tâche test changeset dans le projet Project monitoring  par Antonio	f	128	152	2024-02-01 16:06:11	2024-02-01 16:06:11	6
27789	Antonio a été assigné à la tâche test changeset dans le projet Project monitoring  par Antonio	f	128	127	2024-02-01 16:06:11	2024-02-01 16:06:11	6
27790	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	130	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27791	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	135	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27792	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	136	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27793	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	138	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27794	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	144	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27795	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	145	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27796	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	132	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27797	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	131	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27798	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	152	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27799	Tâche nouvellement créee du nom de baba par Loïc dans le projet Project monitoring .	f	134	127	2024-02-01 16:12:43	2024-02-01 16:12:43	5
27800	Loïc a été assigné à la tâche baba dans le projet Project monitoring  par Loïc	f	134	134	2024-02-01 13:12:43	2024-02-01 13:12:43	6
27801	Loïc a été assigné à la tâche baba dans le projet Project monitoring  par Loïc	f	134	130	2024-02-01 16:12:43	2024-02-01 16:12:43	6
27802	Loïc a été assigné à la tâche baba dans le projet Project monitoring  par Loïc	f	134	132	2024-02-01 16:12:43	2024-02-01 16:12:43	6
27803	Loïc a été assigné à la tâche baba dans le projet Project monitoring  par Loïc	f	134	152	2024-02-01 16:12:43	2024-02-01 16:12:43	6
27804	Loïc a été assigné à la tâche baba dans le projet Project monitoring  par Loïc	f	134	127	2024-02-01 16:12:43	2024-02-01 16:12:43	6
27816	Loïc a été assigné à la tâche qzazazaz dans le projet Project monitoring  par Loïc	f	134	130	2024-02-01 16:26:14	2024-02-01 16:26:14	6
27817	Loïc a été assigné à la tâche qzazazaz dans le projet Project monitoring  par Loïc	f	134	132	2024-02-01 16:26:14	2024-02-01 16:26:14	6
27818	Loïc a été assigné à la tâche qzazazaz dans le projet Project monitoring  par Loïc	f	134	152	2024-02-01 16:26:14	2024-02-01 16:26:14	6
27819	Loïc a été assigné à la tâche qzazazaz dans le projet Project monitoring  par Loïc	f	134	127	2024-02-01 16:26:14	2024-02-01 16:26:14	6
27851	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	130	2024-02-01 16:50:01	2024-02-01 16:50:01	6
27852	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	132	2024-02-01 16:50:01	2024-02-01 16:50:01	6
27853	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	152	2024-02-01 16:50:01	2024-02-01 16:50:01	6
27854	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	127	2024-02-01 16:50:01	2024-02-01 16:50:01	6
27866	Antonio a été assigné à la sous-tâche doudouuuuuu du projet Project monitoring  par Antonio	f	128	130	2024-02-01 17:00:44	2024-02-01 17:00:44	6
27867	Antonio a été assigné à la sous-tâche doudouuuuuu du projet Project monitoring  par Antonio	f	128	132	2024-02-01 17:00:44	2024-02-01 17:00:44	6
27868	Antonio a été assigné à la sous-tâche doudouuuuuu du projet Project monitoring  par Antonio	f	128	152	2024-02-01 17:00:44	2024-02-01 17:00:44	6
27869	Antonio a été assigné à la sous-tâche doudouuuuuu du projet Project monitoring  par Antonio	f	128	127	2024-02-01 17:00:44	2024-02-01 17:00:44	6
27805	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	130	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27806	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	135	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27807	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	136	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27808	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	138	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27809	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	144	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27810	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	145	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27811	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	132	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27812	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	131	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27813	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	152	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27814	Tâche nouvellement créee du nom de qzazazaz par Loïc dans le projet Project monitoring .	f	134	127	2024-02-01 16:26:14	2024-02-01 16:26:14	5
27831	Loïc a été assigné à la tâche boubou dans le projet Project monitoring  par Loïc	f	134	130	2024-02-01 16:46:59	2024-02-01 16:46:59	6
27832	Loïc a été assigné à la tâche boubou dans le projet Project monitoring  par Loïc	f	134	132	2024-02-01 16:46:59	2024-02-01 16:46:59	6
27833	Loïc a été assigné à la tâche boubou dans le projet Project monitoring  par Loïc	f	134	152	2024-02-01 16:46:59	2024-02-01 16:46:59	6
27834	Loïc a été assigné à la tâche boubou dans le projet Project monitoring  par Loïc	f	134	127	2024-02-01 16:46:59	2024-02-01 16:46:59	6
27850	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	128	2024-02-01 13:50:01	2024-02-01 13:50:01	6
27815	Loïc a été assigné à la tâche qzazazaz dans le projet Project monitoring  par Loïc	f	134	134	2024-02-01 13:26:14	2024-02-01 13:26:14	6
27855	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	128	2024-02-01 13:56:01	2024-02-01 13:56:01	6
27820	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	130	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27821	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	135	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27822	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	136	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27823	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	138	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27824	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	144	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27825	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	145	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27826	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	132	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27827	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	131	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27828	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	152	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27829	Tâche nouvellement créee du nom de boubou par Loïc dans le projet Project monitoring .	f	134	127	2024-02-01 16:46:59	2024-02-01 16:46:59	5
27830	Loïc a été assigné à la tâche boubou dans le projet Project monitoring  par Loïc	f	134	134	2024-02-01 13:46:59	2024-02-01 13:46:59	6
27835	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	130	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27836	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	135	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27837	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	136	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27838	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	138	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27839	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	144	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27840	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	145	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27841	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	132	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27842	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	131	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27843	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	152	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27844	Tâche nouvellement créee du nom de mon doudou par Antonio dans le projet Project monitoring .	f	128	127	2024-02-01 16:49:26	2024-02-01 16:49:26	5
27845	Antonio a été assigné à la tâche mon doudou dans le projet Project monitoring  par Antonio	f	128	128	2024-02-01 13:49:26	2024-02-01 13:49:26	6
27846	Antonio a été assigné à la tâche mon doudou dans le projet Project monitoring  par Antonio	f	128	130	2024-02-01 16:49:26	2024-02-01 16:49:26	6
27847	Antonio a été assigné à la tâche mon doudou dans le projet Project monitoring  par Antonio	f	128	132	2024-02-01 16:49:26	2024-02-01 16:49:26	6
27848	Antonio a été assigné à la tâche mon doudou dans le projet Project monitoring  par Antonio	f	128	152	2024-02-01 16:49:26	2024-02-01 16:49:26	6
27849	Antonio a été assigné à la tâche mon doudou dans le projet Project monitoring  par Antonio	f	128	127	2024-02-01 16:49:26	2024-02-01 16:49:26	6
27856	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	130	2024-02-01 16:56:01	2024-02-01 16:56:01	6
27857	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	132	2024-02-01 16:56:01	2024-02-01 16:56:01	6
27858	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	152	2024-02-01 16:56:01	2024-02-01 16:56:01	6
27859	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	127	2024-02-01 16:56:01	2024-02-01 16:56:01	6
27861	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	130	2024-02-01 17:00:18	2024-02-01 17:00:18	6
27862	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	132	2024-02-01 17:00:18	2024-02-01 17:00:18	6
27863	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	152	2024-02-01 17:00:18	2024-02-01 17:00:18	6
27864	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	f	128	127	2024-02-01 17:00:18	2024-02-01 17:00:18	6
27870	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	130	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27871	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	135	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27872	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	136	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27873	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	138	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27874	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	144	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27875	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	145	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27876	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	132	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27877	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	131	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27878	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	152	2024-02-02 10:10:40	2024-02-02 10:10:40	5
28027	La tâche Mon sous doudou a été mise en cours.	f	128	131	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28028	La tâche Mon sous doudou a été mise en cours.	f	128	152	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28029	La tâche Mon sous doudou a été mise en cours.	f	128	127	2024-02-07 16:50:46	2024-02-07 16:50:46	4
27879	Tâche nouvellement créee du nom de test validation par Antonio dans le projet Project monitoring .	f	128	127	2024-02-02 10:10:40	2024-02-02 10:10:40	5
27881	Antonio a été assigné à la tâche test validation dans le projet Project monitoring  par Antonio	f	128	130	2024-02-02 10:10:40	2024-02-02 10:10:40	6
27882	Antonio a été assigné à la tâche test validation dans le projet Project monitoring  par Antonio	f	128	132	2024-02-02 10:10:40	2024-02-02 10:10:40	6
27883	Antonio a été assigné à la tâche test validation dans le projet Project monitoring  par Antonio	f	128	152	2024-02-02 10:10:40	2024-02-02 10:10:40	6
27884	Antonio a été assigné à la tâche test validation dans le projet Project monitoring  par Antonio	f	128	127	2024-02-02 10:10:40	2024-02-02 10:10:40	6
27885	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	130	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27886	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	135	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27887	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	136	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27888	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	138	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27889	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	144	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27890	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	145	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27891	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	132	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27892	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	131	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27893	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	152	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27894	Tâche nouvellement créee du nom de LOIC SE FAIT BLABLA par Antonio dans le projet Project monitoring .	f	128	127	2024-02-02 14:56:23	2024-02-02 14:56:23	5
27896	Antonio a été assigné à la tâche LOIC SE FAIT BLABLA dans le projet Project monitoring  par Antonio	f	128	130	2024-02-02 14:56:23	2024-02-02 14:56:23	6
27897	Antonio a été assigné à la tâche LOIC SE FAIT BLABLA dans le projet Project monitoring  par Antonio	f	128	132	2024-02-02 14:56:23	2024-02-02 14:56:23	6
27898	Antonio a été assigné à la tâche LOIC SE FAIT BLABLA dans le projet Project monitoring  par Antonio	f	128	152	2024-02-02 14:56:23	2024-02-02 14:56:23	6
27899	Antonio a été assigné à la tâche LOIC SE FAIT BLABLA dans le projet Project monitoring  par Antonio	f	128	127	2024-02-02 14:56:23	2024-02-02 14:56:23	6
27900	Loïc a été assigné à la sous-tâche voici mon sous taches  du projet Project monitoring  par PhidiaAdmin	f	127	134	2024-02-05 10:25:51	2024-02-05 10:25:51	6
27901	Loïc a été assigné à la sous-tâche voici mon sous taches  du projet Project monitoring  par PhidiaAdmin	f	127	130	2024-02-05 13:25:51	2024-02-05 13:25:51	6
27902	Loïc a été assigné à la sous-tâche voici mon sous taches  du projet Project monitoring  par PhidiaAdmin	f	127	132	2024-02-05 13:25:51	2024-02-05 13:25:51	6
27903	Loïc a été assigné à la sous-tâche voici mon sous taches  du projet Project monitoring  par PhidiaAdmin	f	127	152	2024-02-05 13:25:51	2024-02-05 13:25:51	6
27904	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	130	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27905	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	135	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27906	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	136	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27907	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	138	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27908	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	144	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27909	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	145	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27910	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	132	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27911	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	131	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27912	Tâche nouvellement créee du nom de BOIRE DU CAFE par PhidiaAdmin dans le projet Project monitoring .	f	127	152	2024-02-05 16:03:38	2024-02-05 16:03:38	5
27913	Loïc a été assigné à la tâche BOIRE DU CAFE dans le projet Project monitoring  par PhidiaAdmin	f	127	134	2024-02-05 13:03:38	2024-02-05 13:03:38	6
27914	Loïc a été assigné à la tâche BOIRE DU CAFE dans le projet Project monitoring  par PhidiaAdmin	f	127	130	2024-02-05 16:03:38	2024-02-05 16:03:38	6
27915	Loïc a été assigné à la tâche BOIRE DU CAFE dans le projet Project monitoring  par PhidiaAdmin	f	127	132	2024-02-05 16:03:38	2024-02-05 16:03:38	6
27916	Loïc a été assigné à la tâche BOIRE DU CAFE dans le projet Project monitoring  par PhidiaAdmin	f	127	152	2024-02-05 16:03:38	2024-02-05 16:03:38	6
27917	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	130	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27918	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	135	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27919	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	136	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27920	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	138	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27921	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	144	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27922	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	145	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27923	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	132	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27924	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	131	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27925	Tâche nouvellement créee du nom de DU LAIT par PhidiaAdmin dans le projet Project monitoring .	f	127	152	2024-02-05 16:04:58	2024-02-05 16:04:58	5
27926	Loïc a été assigné à la tâche DU LAIT dans le projet Project monitoring  par PhidiaAdmin	f	127	134	2024-02-05 13:04:58	2024-02-05 13:04:58	6
27927	Loïc a été assigné à la tâche DU LAIT dans le projet Project monitoring  par PhidiaAdmin	f	127	130	2024-02-05 16:04:58	2024-02-05 16:04:58	6
27928	Loïc a été assigné à la tâche DU LAIT dans le projet Project monitoring  par PhidiaAdmin	f	127	132	2024-02-05 16:04:58	2024-02-05 16:04:58	6
27929	Loïc a été assigné à la tâche DU LAIT dans le projet Project monitoring  par PhidiaAdmin	f	127	152	2024-02-05 16:04:58	2024-02-05 16:04:58	6
27930	Loïc a été assigné à la sous-tâche LAIT MOOGR du projet Project monitoring  par PhidiaAdmin	f	127	134	2024-02-05 13:05:44	2024-02-05 13:05:44	6
27931	Loïc a été assigné à la sous-tâche LAIT MOOGR du projet Project monitoring  par PhidiaAdmin	f	127	130	2024-02-05 16:05:44	2024-02-05 16:05:44	6
27932	Loïc a été assigné à la sous-tâche LAIT MOOGR du projet Project monitoring  par PhidiaAdmin	f	127	132	2024-02-05 16:05:44	2024-02-05 16:05:44	6
27933	Loïc a été assigné à la sous-tâche LAIT MOOGR du projet Project monitoring  par PhidiaAdmin	f	127	152	2024-02-05 16:05:44	2024-02-05 16:05:44	6
27934	Loïc a été assigné à la sous-tâche LAIT DE CHACHA du projet Project monitoring  par PhidiaAdmin	f	127	134	2024-02-05 13:06:09	2024-02-05 13:06:09	6
27935	Loïc a été assigné à la sous-tâche LAIT DE CHACHA du projet Project monitoring  par PhidiaAdmin	f	127	130	2024-02-05 16:06:09	2024-02-05 16:06:09	6
27936	Loïc a été assigné à la sous-tâche LAIT DE CHACHA du projet Project monitoring  par PhidiaAdmin	f	127	132	2024-02-05 16:06:09	2024-02-05 16:06:09	6
27937	Loïc a été assigné à la sous-tâche LAIT DE CHACHA du projet Project monitoring  par PhidiaAdmin	f	127	152	2024-02-05 16:06:09	2024-02-05 16:06:09	6
27860	Antonio a été assigné à la sous-tâche Mon sous doudou du projet Project monitoring  par Antonio	t	128	128	2024-02-01 14:00:18	2024-02-01 14:00:18	6
27865	Antonio a été assigné à la sous-tâche doudouuuuuu du projet Project monitoring  par Antonio	t	128	128	2024-02-01 14:00:44	2024-02-01 14:00:44	6
27880	Antonio a été assigné à la tâche test validation dans le projet Project monitoring  par Antonio	t	128	128	2024-02-02 07:10:40	2024-02-02 07:10:40	6
27895	Antonio a été assigné à la tâche LOIC SE FAIT BLABLA dans le projet Project monitoring  par Antonio	t	128	128	2024-02-02 11:56:23	2024-02-02 11:56:23	6
27938	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	130	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27939	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	135	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27940	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	136	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27941	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	138	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27942	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	144	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27943	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	145	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27944	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	132	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27945	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	131	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27946	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	152	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27947	Tâche "teste sous par attributeur"\n          du projet Project monitoring  mise dans " En cours " par Antonio	f	128	127	2024-02-05 17:56:39	2024-02-05 17:56:39	1
27948	Tâche bababababa supprimé par PhidiaAdmin.	f	127	130	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27949	Tâche bababababa supprimé par PhidiaAdmin.	f	127	135	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27950	Tâche bababababa supprimé par PhidiaAdmin.	f	127	136	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27951	Tâche bababababa supprimé par PhidiaAdmin.	f	127	138	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27952	Tâche bababababa supprimé par PhidiaAdmin.	f	127	144	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27953	Tâche bababababa supprimé par PhidiaAdmin.	f	127	145	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27954	Tâche bababababa supprimé par PhidiaAdmin.	f	127	132	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27955	Tâche bababababa supprimé par PhidiaAdmin.	f	127	131	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27956	Tâche bababababa supprimé par PhidiaAdmin.	f	127	152	2024-02-06 16:42:00	2024-02-06 16:42:00	3
27957	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	130	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27958	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	135	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27959	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	136	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27960	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	138	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27961	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	144	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27962	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	145	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27963	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	132	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27964	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	131	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27965	Tâche nouvellement créee du nom de Ajout de la fonctionnalité par PhidiaAdmin dans le projet Project monitoring .	f	127	152	2024-02-06 16:54:38	2024-02-06 16:54:38	5
27966	Loïc a été assigné à la tâche Ajout de la fonctionnalité dans le projet Project monitoring  par PhidiaAdmin	f	127	134	2024-02-06 13:54:38	2024-02-06 13:54:38	6
27967	Loïc a été assigné à la tâche Ajout de la fonctionnalité dans le projet Project monitoring  par PhidiaAdmin	f	127	130	2024-02-06 16:54:38	2024-02-06 16:54:38	6
27968	Loïc a été assigné à la tâche Ajout de la fonctionnalité dans le projet Project monitoring  par PhidiaAdmin	f	127	132	2024-02-06 16:54:38	2024-02-06 16:54:38	6
27969	Loïc a été assigné à la tâche Ajout de la fonctionnalité dans le projet Project monitoring  par PhidiaAdmin	f	127	152	2024-02-06 16:54:38	2024-02-06 16:54:38	6
27970	La tâche test validation a été mise en cours.	f	128	130	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27971	La tâche test validation a été mise en cours.	f	128	135	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27972	La tâche test validation a été mise en cours.	f	128	136	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27973	La tâche test validation a été mise en cours.	f	128	138	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27974	La tâche test validation a été mise en cours.	f	128	144	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27975	La tâche test validation a été mise en cours.	f	128	145	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27976	La tâche test validation a été mise en cours.	f	128	132	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27977	La tâche test validation a été mise en cours.	f	128	131	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27978	La tâche test validation a été mise en cours.	f	128	152	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27979	La tâche test validation a été mise en cours.	f	128	127	2024-02-06 16:59:49	2024-02-06 16:59:49	4
27980	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	130	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27981	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	135	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27982	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	136	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27983	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	138	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27984	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	144	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27985	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	145	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27986	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	132	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27987	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	131	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27988	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	152	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27989	La tâche LOIC SE FAIT BLABLA a été mise en cours.	f	128	127	2024-02-06 17:15:20	2024-02-06 17:15:20	4
27990	La tâche doudouuuuuu a été mise en cours.	f	128	130	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27991	La tâche doudouuuuuu a été mise en cours.	f	128	135	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27992	La tâche doudouuuuuu a été mise en cours.	f	128	136	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27993	La tâche doudouuuuuu a été mise en cours.	f	128	138	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27994	La tâche doudouuuuuu a été mise en cours.	f	128	144	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27995	La tâche doudouuuuuu a été mise en cours.	f	128	145	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27996	La tâche doudouuuuuu a été mise en cours.	f	128	132	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27997	La tâche doudouuuuuu a été mise en cours.	f	128	131	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27998	La tâche doudouuuuuu a été mise en cours.	f	128	152	2024-02-06 17:17:55	2024-02-06 17:17:55	4
27999	La tâche doudouuuuuu a été mise en cours.	f	128	127	2024-02-06 17:17:55	2024-02-06 17:17:55	4
28000	La tâche Mon sous doudou a été mise en cours.	f	128	130	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28001	La tâche Mon sous doudou a été mise en cours.	f	128	135	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28002	La tâche Mon sous doudou a été mise en cours.	f	128	136	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28003	La tâche Mon sous doudou a été mise en cours.	f	128	138	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28004	La tâche Mon sous doudou a été mise en cours.	f	128	144	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28005	La tâche Mon sous doudou a été mise en cours.	f	128	145	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28006	La tâche Mon sous doudou a été mise en cours.	f	128	132	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28007	La tâche Mon sous doudou a été mise en cours.	f	128	131	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28008	La tâche Mon sous doudou a été mise en cours.	f	128	152	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28009	La tâche Mon sous doudou a été mise en cours.	f	128	127	2024-02-06 17:23:07	2024-02-06 17:23:07	4
28010	La tâche Mon sous doudou a été mise en cours.	f	128	130	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28011	La tâche Mon sous doudou a été mise en cours.	f	128	135	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28012	La tâche Mon sous doudou a été mise en cours.	f	128	136	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28013	La tâche Mon sous doudou a été mise en cours.	f	128	138	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28014	La tâche Mon sous doudou a été mise en cours.	f	128	144	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28015	La tâche Mon sous doudou a été mise en cours.	f	128	145	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28016	La tâche Mon sous doudou a été mise en cours.	f	128	132	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28017	La tâche Mon sous doudou a été mise en cours.	f	128	131	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28018	La tâche Mon sous doudou a été mise en cours.	f	128	152	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28019	La tâche Mon sous doudou a été mise en cours.	f	128	127	2024-02-06 17:26:02	2024-02-06 17:26:02	4
28020	La tâche Mon sous doudou a été mise en cours.	f	128	130	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28021	La tâche Mon sous doudou a été mise en cours.	f	128	135	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28022	La tâche Mon sous doudou a été mise en cours.	f	128	136	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28023	La tâche Mon sous doudou a été mise en cours.	f	128	138	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28024	La tâche Mon sous doudou a été mise en cours.	f	128	144	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28025	La tâche Mon sous doudou a été mise en cours.	f	128	145	2024-02-07 16:50:46	2024-02-07 16:50:46	4
28030	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	130	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28031	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	135	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28032	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	136	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28033	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	138	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28034	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	144	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28035	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	145	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28036	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	132	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28037	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	131	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28038	Tâche teste  par attributeur supprimé par PhidiaAdmin.	f	127	152	2024-02-08 15:22:32	2024-02-08 15:22:32	3
28039	Tâche test ultime supprimé par PhidiaAdmin.	f	127	130	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28040	Tâche test ultime supprimé par PhidiaAdmin.	f	127	135	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28041	Tâche test ultime supprimé par PhidiaAdmin.	f	127	136	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28042	Tâche test ultime supprimé par PhidiaAdmin.	f	127	138	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28043	Tâche test ultime supprimé par PhidiaAdmin.	f	127	144	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28044	Tâche test ultime supprimé par PhidiaAdmin.	f	127	145	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28045	Tâche test ultime supprimé par PhidiaAdmin.	f	127	132	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28046	Tâche test ultime supprimé par PhidiaAdmin.	f	127	131	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28047	Tâche test ultime supprimé par PhidiaAdmin.	f	127	152	2024-02-08 15:22:41	2024-02-08 15:22:41	3
28048	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	130	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28049	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	135	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28050	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	136	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28051	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	138	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28052	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	144	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28053	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	132	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28054	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	131	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28055	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	127	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28056	Tâche nouvellement créee du nom de mon propre tache par Frederick dans le projet Project monitoring .	f	145	152	2024-02-23 16:57:00	2024-02-23 16:57:00	5
28057	Frederick a été assigné à la tâche mon propre tache dans le projet Project monitoring  par Frederick	f	145	145	2024-02-23 13:57:00	2024-02-23 13:57:00	6
28058	Frederick a été assigné à la tâche mon propre tache dans le projet Project monitoring  par Frederick	f	145	130	2024-02-23 16:57:00	2024-02-23 16:57:00	6
28059	Frederick a été assigné à la tâche mon propre tache dans le projet Project monitoring  par Frederick	f	145	132	2024-02-23 16:57:00	2024-02-23 16:57:00	6
28060	Frederick a été assigné à la tâche mon propre tache dans le projet Project monitoring  par Frederick	f	145	127	2024-02-23 16:57:00	2024-02-23 16:57:00	6
28061	Frederick a été assigné à la tâche mon propre tache dans le projet Project monitoring  par Frederick	f	145	152	2024-02-23 16:57:00	2024-02-23 16:57:00	6
28062	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	130	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28063	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	135	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28064	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	136	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28065	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	138	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28066	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	144	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28067	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	145	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28068	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	132	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28069	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	131	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28070	Tâche haha mety amizay supprimé par Loic_Admin.	f	152	127	2024-02-28 16:30:48	2024-02-28 16:30:48	3
28071	Tâche baba supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28072	Tâche baba supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28073	Tâche baba supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28074	Tâche baba supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28075	Tâche baba supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28076	Tâche baba supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28077	Tâche baba supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28078	Tâche baba supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28079	Tâche baba supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:02	2024-02-28 16:31:02	3
28080	Tâche qzazazaz supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28081	Tâche qzazazaz supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28082	Tâche qzazazaz supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28083	Tâche qzazazaz supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28084	Tâche qzazazaz supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28085	Tâche qzazazaz supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28086	Tâche qzazazaz supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28087	Tâche qzazazaz supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28088	Tâche qzazazaz supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:07	2024-02-28 16:31:07	3
28089	Tâche mon doudou supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28090	Tâche mon doudou supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28091	Tâche mon doudou supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28092	Tâche mon doudou supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28093	Tâche mon doudou supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28094	Tâche mon doudou supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28095	Tâche mon doudou supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28096	Tâche mon doudou supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28097	Tâche mon doudou supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:12	2024-02-28 16:31:12	3
28098	Tâche DU LAIT supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28099	Tâche DU LAIT supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28100	Tâche DU LAIT supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28101	Tâche DU LAIT supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28102	Tâche DU LAIT supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28103	Tâche DU LAIT supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28104	Tâche DU LAIT supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28105	Tâche DU LAIT supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28106	Tâche DU LAIT supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:20	2024-02-28 16:31:20	3
28107	Tâche mon propre tache supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28108	Tâche mon propre tache supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28109	Tâche mon propre tache supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28110	Tâche mon propre tache supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28111	Tâche mon propre tache supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28112	Tâche mon propre tache supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28113	Tâche mon propre tache supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28114	Tâche mon propre tache supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28115	Tâche mon propre tache supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:27	2024-02-28 16:31:27	3
28116	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28117	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28118	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28119	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28120	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28121	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28122	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28123	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28124	Tâche teste de la mort 2 supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:37	2024-02-28 16:31:37	3
28125	Tâche test changeset supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28126	Tâche test changeset supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28127	Tâche test changeset supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28128	Tâche test changeset supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28129	Tâche test changeset supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28130	Tâche test changeset supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28131	Tâche test changeset supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28132	Tâche test changeset supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28133	Tâche test changeset supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:44	2024-02-28 16:31:44	3
28134	Tâche test 5 supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28135	Tâche test 5 supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28136	Tâche test 5 supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28137	Tâche test 5 supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28138	Tâche test 5 supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28139	Tâche test 5 supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28140	Tâche test 5 supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28141	Tâche test 5 supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28142	Tâche test 5 supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:49	2024-02-28 16:31:49	3
28143	Tâche teste 3 supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28144	Tâche teste 3 supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28145	Tâche teste 3 supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28146	Tâche teste 3 supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28147	Tâche teste 3 supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28148	Tâche teste 3 supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28149	Tâche teste 3 supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28150	Tâche teste 3 supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28151	Tâche teste 3 supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:54	2024-02-28 16:31:54	3
28183	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	130	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28184	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	135	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28185	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	136	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28186	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	138	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28187	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	144	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28188	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	145	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28189	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	132	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28190	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	131	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28191	Tâche nouvellement créee du nom de affichage dynamique pour saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	127	2024-02-28 16:34:45	2024-02-28 16:34:45	5
28236	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28237	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28238	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28239	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28240	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28241	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28242	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28243	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28244	Tâche teste sous taches dd supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:03	2024-02-28 16:39:03	3
28152	Tâche test 4 supprimé par Loic_Admin.	f	152	130	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28153	Tâche test 4 supprimé par Loic_Admin.	f	152	135	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28154	Tâche test 4 supprimé par Loic_Admin.	f	152	136	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28155	Tâche test 4 supprimé par Loic_Admin.	f	152	138	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28156	Tâche test 4 supprimé par Loic_Admin.	f	152	144	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28157	Tâche test 4 supprimé par Loic_Admin.	f	152	145	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28158	Tâche test 4 supprimé par Loic_Admin.	f	152	132	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28159	Tâche test 4 supprimé par Loic_Admin.	f	152	131	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28160	Tâche test 4 supprimé par Loic_Admin.	f	152	127	2024-02-28 16:31:59	2024-02-28 16:31:59	3
28161	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	130	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28162	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	135	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28163	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	136	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28164	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	138	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28165	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	144	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28166	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	145	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28167	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	132	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28168	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	131	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28169	Tâche LOIC SE FAIT BLABLA supprimé par Loic_Admin.	f	152	127	2024-02-28 16:32:04	2024-02-28 16:32:04	3
28272	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28273	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28274	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28275	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28276	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28277	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28278	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28279	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28280	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:34	2024-02-28 16:39:34	3
28170	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	130	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28171	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	135	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28172	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	136	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28173	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	138	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28174	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	144	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28175	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	145	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28176	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	132	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28177	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	131	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28178	Tâche nouvellement créee du nom de validation sur les format de donnes entrees dans la saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	127	2024-02-28 16:32:56	2024-02-28 16:32:56	5
28192	Loïc a été assigné à la tâche affichage dynamique pour saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	134	2024-02-28 13:34:45	2024-02-28 13:34:45	6
28209	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	130	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28210	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	135	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28211	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	136	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28212	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	138	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28213	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	144	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28214	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	145	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28215	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	132	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28216	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	131	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28217	Tâche voici mon sous taches  supprimé par Loic_Admin.	f	152	127	2024-02-28 16:38:33	2024-02-28 16:38:33	3
28179	Loïc a été assigné à la tâche validation sur les format de donnes entrees dans la saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	134	2024-02-28 13:32:56	2024-02-28 13:32:56	6
28180	Loïc a été assigné à la tâche validation sur les format de donnes entrees dans la saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	130	2024-02-28 16:32:56	2024-02-28 16:32:56	6
28181	Loïc a été assigné à la tâche validation sur les format de donnes entrees dans la saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	132	2024-02-28 16:32:56	2024-02-28 16:32:56	6
28182	Loïc a été assigné à la tâche validation sur les format de donnes entrees dans la saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	127	2024-02-28 16:32:56	2024-02-28 16:32:56	6
28193	Loïc a été assigné à la tâche affichage dynamique pour saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	130	2024-02-28 16:34:45	2024-02-28 16:34:45	6
28194	Loïc a été assigné à la tâche affichage dynamique pour saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	132	2024-02-28 16:34:45	2024-02-28 16:34:45	6
28195	Loïc a été assigné à la tâche affichage dynamique pour saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	127	2024-02-28 16:34:45	2024-02-28 16:34:45	6
28196	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	130	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28197	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	135	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28198	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	136	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28199	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	138	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28200	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	144	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28201	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	145	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28202	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	132	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28203	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	131	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28204	Tâche nouvellement créee du nom de migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps par Loic_Admin dans le projet Project monitoring .	f	152	127	2024-02-28 16:35:46	2024-02-28 16:35:46	5
28205	Loïc a été assigné à la tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	134	2024-02-28 13:35:46	2024-02-28 13:35:46	6
28218	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	130	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28219	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	135	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28220	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	136	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28221	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	138	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28222	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	144	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28223	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	145	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28224	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	132	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28225	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	131	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28226	Tâche LAIT DE CHACHA supprimé par Loic_Admin.	f	152	127	2024-02-28 16:38:46	2024-02-28 16:38:46	3
28227	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	130	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28228	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	135	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28229	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	136	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28230	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	138	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28231	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	144	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28232	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	145	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28233	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	132	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28234	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	131	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28235	Tâche LAIT MOOGR supprimé par Loic_Admin.	f	152	127	2024-02-28 16:38:54	2024-02-28 16:38:54	3
28290	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28291	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28292	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28293	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28294	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28295	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28296	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28297	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28298	Tâche sous tache 2 supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:49	2024-02-28 16:39:49	3
28206	Loïc a été assigné à la tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	130	2024-02-28 16:35:46	2024-02-28 16:35:46	6
28207	Loïc a été assigné à la tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	132	2024-02-28 16:35:46	2024-02-28 16:35:46	6
28208	Loïc a été assigné à la tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps dans le projet Project monitoring  par Loic_Admin	f	152	127	2024-02-28 16:35:46	2024-02-28 16:35:46	6
28245	Tâche aa supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28246	Tâche aa supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28247	Tâche aa supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28248	Tâche aa supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28249	Tâche aa supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28250	Tâche aa supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28251	Tâche aa supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28252	Tâche aa supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28253	Tâche aa supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:10	2024-02-28 16:39:10	3
28254	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28255	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28256	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28257	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28258	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28259	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28260	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28261	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28262	Tâche doudouuuuuu supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:18	2024-02-28 16:39:18	3
28263	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28264	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28265	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28266	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28267	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28268	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28269	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28270	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28271	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:27	2024-02-28 16:39:27	3
28281	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	130	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28282	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	135	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28283	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	136	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28284	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	138	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28285	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	144	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28286	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	145	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28287	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	132	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28288	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	131	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28289	Tâche Mon sous doudou supprimé par Loic_Admin.	f	152	127	2024-02-28 16:39:40	2024-02-28 16:39:40	3
28299	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	130	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28300	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	135	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28301	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	136	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28302	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	138	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28303	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	144	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28304	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	145	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28305	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	132	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28306	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	131	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28307	Un projet du nom de saisie de temps monitoring a été crée par Loic_Admin	f	152	127	2024-02-29 14:01:53	2024-02-29 14:01:53	5
28308	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	130	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28309	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	135	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28310	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	136	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28311	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	138	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28312	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	144	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28313	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	145	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28314	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	132	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28315	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	131	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28316	Tâche nouvellement créee du nom de conception affichage de saisie de temp par Loic_Admin dans le projet saisie de temps monitoring.	f	152	127	2024-02-29 14:05:06	2024-02-29 14:05:06	5
28317	Loïc a été assigné à la tâche conception affichage de saisie de temp dans le projet saisie de temps monitoring par Loic_Admin	f	152	134	2024-02-29 11:05:06	2024-02-29 11:05:06	6
28318	Loïc a été assigné à la tâche conception affichage de saisie de temp dans le projet saisie de temps monitoring par Loic_Admin	f	152	130	2024-02-29 14:05:06	2024-02-29 14:05:06	6
28319	Loïc a été assigné à la tâche conception affichage de saisie de temp dans le projet saisie de temps monitoring par Loic_Admin	f	152	132	2024-02-29 14:05:06	2024-02-29 14:05:06	6
28320	Loïc a été assigné à la tâche conception affichage de saisie de temp dans le projet saisie de temps monitoring par Loic_Admin	f	152	127	2024-02-29 14:05:06	2024-02-29 14:05:06	6
28321	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	130	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28322	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	135	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28323	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	136	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28324	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	138	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28325	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	144	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28326	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	145	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28327	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	132	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28328	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	131	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28329	Tâche nouvellement créee du nom de ajout des nouveau tables necessaire par Loic_Admin dans le projet saisie de temps monitoring.	f	152	127	2024-02-29 14:07:23	2024-02-29 14:07:23	5
28334	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	130	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28335	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	135	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28336	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	136	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28337	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	138	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28338	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	144	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28339	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	145	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28340	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	132	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28341	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	131	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28342	Tâche nouvellement créee du nom de validation des données en entrés  par Loic_Admin dans le projet saisie de temps monitoring.	f	152	127	2024-02-29 14:08:14	2024-02-29 14:08:14	5
28330	Loïc a été assigné à la tâche ajout des nouveau tables necessaire dans le projet saisie de temps monitoring par Loic_Admin	f	152	134	2024-02-29 11:07:24	2024-02-29 11:07:24	6
28331	Loïc a été assigné à la tâche ajout des nouveau tables necessaire dans le projet saisie de temps monitoring par Loic_Admin	f	152	130	2024-02-29 14:07:24	2024-02-29 14:07:24	6
28332	Loïc a été assigné à la tâche ajout des nouveau tables necessaire dans le projet saisie de temps monitoring par Loic_Admin	f	152	132	2024-02-29 14:07:24	2024-02-29 14:07:24	6
28333	Loïc a été assigné à la tâche ajout des nouveau tables necessaire dans le projet saisie de temps monitoring par Loic_Admin	f	152	127	2024-02-29 14:07:24	2024-02-29 14:07:24	6
28343	Loïc a été assigné à la tâche validation des données en entrés  dans le projet saisie de temps monitoring par Loic_Admin	f	152	134	2024-02-29 11:08:14	2024-02-29 11:08:14	6
28344	Loïc a été assigné à la tâche validation des données en entrés  dans le projet saisie de temps monitoring par Loic_Admin	f	152	130	2024-02-29 14:08:14	2024-02-29 14:08:14	6
28345	Loïc a été assigné à la tâche validation des données en entrés  dans le projet saisie de temps monitoring par Loic_Admin	f	152	132	2024-02-29 14:08:14	2024-02-29 14:08:14	6
28346	Loïc a été assigné à la tâche validation des données en entrés  dans le projet saisie de temps monitoring par Loic_Admin	f	152	127	2024-02-29 14:08:14	2024-02-29 14:08:14	6
28347	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	130	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28348	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	135	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28349	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	136	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28350	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	138	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28351	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	144	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28352	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	145	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28353	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	132	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28354	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	131	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28355	Tâche nouvellement créee du nom de effectuer des tri sur les colone de table par Loic_Admin dans le projet saisie de temps monitoring.	f	152	127	2024-02-29 14:09:51	2024-02-29 14:09:51	5
28356	Loïc a été assigné à la tâche effectuer des tri sur les colone de table dans le projet saisie de temps monitoring par Loic_Admin	f	152	134	2024-02-29 11:09:51	2024-02-29 11:09:51	6
28357	Loïc a été assigné à la tâche effectuer des tri sur les colone de table dans le projet saisie de temps monitoring par Loic_Admin	f	152	130	2024-02-29 14:09:51	2024-02-29 14:09:51	6
28358	Loïc a été assigné à la tâche effectuer des tri sur les colone de table dans le projet saisie de temps monitoring par Loic_Admin	f	152	132	2024-02-29 14:09:51	2024-02-29 14:09:51	6
28359	Loïc a été assigné à la tâche effectuer des tri sur les colone de table dans le projet saisie de temps monitoring par Loic_Admin	f	152	127	2024-02-29 14:09:51	2024-02-29 14:09:51	6
28360	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	130	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28361	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	135	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28362	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	136	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28363	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	138	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28364	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	144	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28365	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	145	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28366	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	132	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28367	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	131	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28368	Tâche nouvellement créee du nom de mecanisme de filtre des donnée a afficher par Loic_Admin dans le projet saisie de temps monitoring.	f	152	127	2024-02-29 14:12:18	2024-02-29 14:12:18	5
28370	Loïc a été assigné à la tâche mecanisme de filtre des donnée a afficher dans le projet saisie de temps monitoring par Loic_Admin	f	152	130	2024-02-29 14:12:18	2024-02-29 14:12:18	6
28371	Loïc a été assigné à la tâche mecanisme de filtre des donnée a afficher dans le projet saisie de temps monitoring par Loic_Admin	f	152	132	2024-02-29 14:12:18	2024-02-29 14:12:18	6
28372	Loïc a été assigné à la tâche mecanisme de filtre des donnée a afficher dans le projet saisie de temps monitoring par Loic_Admin	f	152	127	2024-02-29 14:12:18	2024-02-29 14:12:18	6
28369	Loïc a été assigné à la tâche mecanisme de filtre des donnée a afficher dans le projet saisie de temps monitoring par Loic_Admin	f	152	134	2024-02-29 11:12:18	2024-02-29 11:12:18	6
28373	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	130	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28374	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	135	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28375	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	136	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28376	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	138	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28377	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	144	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28378	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	145	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28379	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	132	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28380	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	131	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28381	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	127	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28382	La tâche ajout des nouveau tables necessaire a été mise en cours.	f	134	152	2024-03-01 16:32:50	2024-03-01 16:32:50	4
28383	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	130	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28384	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	135	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28385	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	136	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28386	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	138	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28387	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	144	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28388	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	145	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28389	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	132	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28390	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	131	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28391	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	127	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28392	La tâche mecanisme de filtre des donnée a afficher a été mise en cours.	f	134	152	2024-03-01 16:34:14	2024-03-01 16:34:14	4
28393	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	130	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28394	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	135	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28395	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	136	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28396	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	138	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28397	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	144	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28398	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	145	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28399	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	132	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28400	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	131	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28401	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	127	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28402	La tâche effectuer des tri sur les colone de table a été mise en cours.	f	134	152	2024-03-01 17:27:37	2024-03-01 17:27:37	4
28403	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	130	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28404	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	135	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28405	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	136	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28406	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	138	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28407	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	144	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28408	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	145	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28409	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	132	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28410	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	131	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28411	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	127	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28412	La tâche conception affichage de saisie de temp a été mise en cours.	f	128	152	2024-03-01 17:31:25	2024-03-01 17:31:25	4
28413	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	130	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28414	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	135	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28415	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	136	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28416	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	138	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28417	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	144	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28418	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	145	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28419	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	132	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28420	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	131	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28421	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	127	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28422	La tâche teste confirmation par attributeur 2 a été mise en cours.	f	128	152	2024-03-01 17:40:49	2024-03-01 17:40:49	4
28423	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	130	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28424	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	135	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28425	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	136	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28426	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	138	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28427	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	144	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28428	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	145	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28429	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	132	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28430	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	131	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28431	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	127	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28432	Tâche BOIRE DU CAFE supprimé par Loïc.	f	134	152	2024-03-01 18:04:12	2024-03-01 18:04:12	3
28433	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	130	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28434	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	135	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28435	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	136	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28436	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	138	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28437	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	144	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28438	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	145	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28439	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	132	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28440	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	131	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28441	La tâche affichage dynamique pour saisie de temps a été mise en cours.	f	127	152	2024-03-05 21:32:59	2024-03-05 21:32:59	4
28442	La tâche validation des données en entrés  a été mise en cours.	f	127	130	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28443	La tâche validation des données en entrés  a été mise en cours.	f	127	135	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28444	La tâche validation des données en entrés  a été mise en cours.	f	127	136	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28445	La tâche validation des données en entrés  a été mise en cours.	f	127	138	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28446	La tâche validation des données en entrés  a été mise en cours.	f	127	144	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28447	La tâche validation des données en entrés  a été mise en cours.	f	127	145	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28448	La tâche validation des données en entrés  a été mise en cours.	f	127	132	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28449	La tâche validation des données en entrés  a été mise en cours.	f	127	131	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28450	La tâche validation des données en entrés  a été mise en cours.	f	127	152	2024-03-05 21:33:39	2024-03-05 21:33:39	4
28451	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	130	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28452	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	135	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28453	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	136	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28454	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	138	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28455	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	144	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28456	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	145	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28457	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	132	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28458	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	131	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28459	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	127	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28460	La tâche validation sur les format de donnes entrees dans la saisie de temps a été mise en cours.	f	129	152	2024-03-11 09:45:54	2024-03-11 09:45:54	4
28461	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	130	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28462	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	135	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28463	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	136	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28464	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	138	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28465	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	144	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28466	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	145	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28467	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	132	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28468	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	127	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28469	La tâche migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps a été mise en cours.	f	131	152	2024-03-11 17:39:18	2024-03-11 17:39:18	4
28470	La tâche boubou a été mise en cours.	f	131	130	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28471	La tâche boubou a été mise en cours.	f	131	135	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28472	La tâche boubou a été mise en cours.	f	131	136	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28473	La tâche boubou a été mise en cours.	f	131	138	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28474	La tâche boubou a été mise en cours.	f	131	144	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28475	La tâche boubou a été mise en cours.	f	131	145	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28476	La tâche boubou a été mise en cours.	f	131	132	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28477	La tâche boubou a été mise en cours.	f	131	127	2024-03-11 17:42:07	2024-03-11 17:42:07	4
28478	La tâche boubou a été mise en cours.	f	131	152	2024-03-11 17:42:07	2024-03-11 17:42:07	4
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
71	saisie de temps monitoring	mettre en place une fonctionalité pour pouvoir effectuer une saisie de temps	0	2024-02-29	\N	16	0	2024-03-04	39	3	2024-02-29 11:01:53	2024-02-29 11:12:18	90
70	Project monitoring 	Correction des bugs et refonte des designs 	0	2023-11-06	\N	40	0	2023-11-10	39	3	2023-11-06 13:25:00	2024-02-28 13:35:46	89
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
-- Data for Name: saisies_validees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.saisies_validees (id, date, h_abs, h_work, user_id, user_validator_id, inserted_at, updated_at) FROM stdin;
1	2024-02-23	428	52	134	152	2024-02-23 11:21:23	2024-02-23 11:21:23
2	2024-02-26	335	145	145	152	2024-02-26 06:51:35	2024-02-26 06:51:35
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
20240122075306	2024-01-22 07:54:16
20240129124226	2024-01-29 12:44:01
20240129124415	2024-01-29 12:45:28
20240130071653	2024-01-30 07:18:38
20240213074131	2024-02-13 08:10:40
20240223072258	2024-02-23 07:29:20
20240228080936	2024-02-28 08:10:53
20240229080330	2024-02-29 08:05:28
20240306072752	2024-03-06 07:34:03
20240306073959	2024-03-06 07:42:44
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
441	A faire	90	1	0	2024-02-29 11:01:53	2024-02-29 11:01:53
442	En blocage	90	2	1	2024-02-29 11:01:53	2024-02-29 11:01:53
443	En cours	90	3	2	2024-02-29 11:01:53	2024-02-29 11:01:53
444	En contrôle	90	4	3	2024-02-29 11:01:53	2024-02-29 11:01:53
445	Achevée(s)	90	5	4	2024-02-29 11:01:53	2024-02-29 11:01:53
446	Archivé	90	6	5	2024-02-29 11:01:53	2024-02-29 11:01:53
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
6	Archivé	2021-04-27 18:49:44	2021-04-27 18:49:44
\.


--
-- Data for Name: task_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_records (id, date, task_id, user_id, start, "end", duration, inserted_at, updated_at, record_type) FROM stdin;
1	2024-01-22	1368	128	2024-01-22 10:43:12	\N	\N	2024-01-22 07:43:12	2024-01-22 07:43:12	\N
\.


--
-- Data for Name: task_tracings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.task_tracings (id, date, start_time, end_time, duration, is_pause, launch_type_id, task_id, user_id, is_recorded, inserted_at, updated_at) FROM stdin;
36	2024-02-07	2024-02-07 16:50:40	2024-02-07 16:50:46	0	t	1	1388	128	t	2024-02-07 13:50:40	2024-02-07 13:50:46
8	2024-01-29	2024-01-29 17:29:23	2024-01-29 17:29:27	0	f	\N	1373	134	t	2024-01-29 14:29:23	2024-01-29 14:29:27
9	2024-01-29	2024-01-29 17:29:27	2024-01-29 17:29:39	0	t	2	1373	134	t	2024-01-29 14:29:27	2024-01-29 14:29:39
11	2024-01-31	2024-01-31 16:39:35	2024-01-31 16:39:55	0	f	\N	1376	128	t	2024-01-31 13:39:35	2024-01-31 13:39:55
12	2024-01-31	2024-01-31 16:39:55	2024-01-31 16:40:48	0	t	2	1376	128	t	2024-01-31 13:39:55	2024-01-31 13:40:48
13	2024-01-31	2024-01-31 16:40:48	2024-01-31 16:44:22	3	f	\N	1376	128	t	2024-01-31 13:40:48	2024-01-31 13:44:22
14	2024-01-31	2024-01-31 16:44:22	2024-01-31 16:52:08	7	t	2	1376	128	t	2024-01-31 13:44:22	2024-01-31 13:52:08
15	2024-01-31	2024-01-31 16:52:08	2024-02-01 14:45:41	1313	f	\N	1376	128	t	2024-01-31 13:52:08	2024-02-01 11:45:41
16	2024-02-01	2024-02-01 14:45:41	2024-02-06 16:59:49	7334	f	\N	1377	128	t	2024-02-01 11:45:41	2024-02-06 13:59:49
17	2024-02-06	2024-02-06 16:59:49	2024-02-06 17:10:38	10	f	\N	1391	128	t	2024-02-06 13:59:49	2024-02-06 14:10:38
18	2024-02-06	2024-02-06 17:10:38	2024-02-06 17:10:57	0	t	2	1391	128	t	2024-02-06 14:10:38	2024-02-06 14:10:57
19	2024-02-06	2024-02-06 17:10:57	2024-02-06 17:15:20	4	f	\N	1391	128	t	2024-02-06 14:10:57	2024-02-06 14:15:20
20	2024-02-06	2024-02-06 17:15:20	2024-02-06 17:16:03	0	f	\N	1392	128	t	2024-02-06 14:15:20	2024-02-06 14:16:03
21	2024-02-06	2024-02-06 17:16:03	2024-02-06 17:16:42	0	f	\N	1391	128	t	2024-02-06 14:16:03	2024-02-06 14:16:42
22	2024-02-06	2024-02-06 17:16:42	2024-02-06 17:17:53	1	f	\N	1392	128	t	2024-02-06 14:16:42	2024-02-06 14:17:53
23	2024-02-06	2024-02-06 17:17:53	2024-02-06 17:17:55	0	f	\N	1391	128	t	2024-02-06 14:17:53	2024-02-06 14:17:55
24	2024-02-06	2024-02-06 17:17:55	2024-02-06 17:18:09	0	f	\N	1390	128	t	2024-02-06 14:17:55	2024-02-06 14:18:09
25	2024-02-06	2024-02-06 17:18:09	2024-02-06 17:23:07	4	t	1	1390	128	t	2024-02-06 14:18:09	2024-02-06 14:23:07
26	2024-02-06	2024-02-06 17:23:07	2024-02-06 17:24:48	1	f	\N	1389	128	t	2024-02-06 14:23:07	2024-02-06 14:24:48
27	2024-02-06	2024-02-06 17:24:48	2024-02-06 17:26:01	1	t	2	1389	128	t	2024-02-06 14:24:48	2024-02-06 14:26:02
28	2024-02-06	2024-02-06 17:26:01	2024-02-06 17:26:14	0	f	\N	1388	128	t	2024-02-06 14:26:02	2024-02-06 14:26:14
29	2024-02-06	2024-02-06 17:26:14	2024-02-07 11:08:11	1061	t	2	1388	128	t	2024-02-06 14:26:14	2024-02-07 08:08:11
30	2024-02-07	2024-02-07 11:08:11	2024-02-07 11:10:16	2	f	\N	1388	128	t	2024-02-07 08:08:11	2024-02-07 08:10:16
31	2024-02-07	2024-02-07 11:10:16	2024-02-07 11:22:31	12	t	1	1388	128	t	2024-02-07 08:10:16	2024-02-07 08:22:31
32	2024-02-07	2024-02-07 11:22:31	2024-02-07 14:47:20	204	f	\N	1388	128	t	2024-02-07 08:22:31	2024-02-07 11:47:20
33	2024-02-07	2024-02-07 14:47:20	2024-02-07 14:47:27	0	t	2	1388	128	t	2024-02-07 11:47:20	2024-02-07 11:47:27
10	2024-01-29	2024-01-29 17:29:39	2024-02-07 14:55:07	12805	f	\N	1372	134	t	2024-01-29 14:29:39	2024-02-07 11:55:07
35	2024-02-07	2024-02-07 14:55:07	\N	\N	t	2	1372	134	f	2024-02-07 11:55:07	2024-02-07 11:55:07
34	2024-02-07	2024-02-07 14:47:27	2024-02-07 16:50:40	123	f	\N	1388	128	t	2024-02-07 11:47:27	2024-02-07 13:50:40
37	2024-02-07	2024-02-07 16:50:46	2024-02-07 16:51:08	0	f	\N	1387	128	t	2024-02-07 13:50:46	2024-02-07 13:51:08
38	2024-02-07	2024-02-07 16:51:08	2024-02-07 16:53:05	1	t	1	1387	128	t	2024-02-07 13:51:08	2024-02-07 13:53:05
39	2024-02-07	2024-02-07 16:53:05	2024-02-07 17:00:39	7	f	\N	1387	128	t	2024-02-07 13:53:05	2024-02-07 14:00:39
40	2024-02-07	2024-02-07 17:00:39	\N	\N	t	2	1387	128	f	2024-02-07 14:00:39	2024-02-07 14:00:39
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, title, progression, date_start, date_end, estimated_duration, performed_duration, deadline, parent_id, project_id, contributor_id, status_id, priority_id, inserted_at, updated_at, attributor_id, achieved_at, hidden, without_control, description, is_major, clients_request_id, is_valid) FROM stdin;
1365	teste de la mort	0	2024-01-18	\N	671	0	2024-01-28	\N	70	128	6	2	2024-01-18 10:30:46	2024-01-25 13:04:02	127	\N	f	f	 teste teste 	f	\N	t
1368	sous tache 2	0	2024-01-18	\N	660	0	2024-01-14	1360	70	128	3	2	2024-01-18 10:47:34	2024-01-25 14:39:09	127	\N	f	f	\N	f	\N	t
1361	Correction du bug concernant les historiques des tâches 	100	2023-11-06	\N	900	0	2023-11-09	\N	70	134	6	2	2023-11-06 16:31:21	2024-01-12 09:55:46	131	2023-11-10 16:16:40	f	f	\N	f	\N	t
1364	teste suppression	0	2024-01-12	\N	60	0	2024-01-15	\N	70	128	6	2	2024-01-12 10:07:58	2024-01-12 10:10:10	145	\N	f	f	 	f	\N	t
1363	test task	0	2023-11-10	\N	60	0	2023-11-17	\N	70	133	6	2	2023-11-10 16:04:17	2024-01-12 11:24:31	127	2023-11-10 16:16:15	f	f	 test	f	\N	t
1362	Correction du bug concernant les historiques des tâches (design) 	0	2023-11-06	\N	480	0	2023-11-08	\N	70	128	6	2	2023-11-06 16:33:58	2024-01-18 07:47:05	131	2023-11-10 16:16:19	f	f	 	f	\N	t
1360	debug modification d'une tâche 	0	2023-11-06	\N	300	8	2023-11-07	\N	70	133	6	2	2023-11-06 16:27:05	2024-01-18 07:47:35	131	2023-11-10 16:16:23	f	f	Correction pour la modification d'une tâche (fonctionnalité) 	f	\N	t
1381	teste confirmation par attributeur 2	0	2024-02-01	\N	120	0	2024-02-04	\N	70	128	3	2	2024-02-01 16:01:26	2024-03-01 17:40:49	145	\N	f	f	y en a marre x)	f	\N	t
1366	teste sous taches	0	2024-01-18	\N	1342	0	2024-01-27	\N	70	128	3	2	2024-01-18 10:31:06	2024-01-25 15:55:50	127	\N	f	f	 fff	f	\N	t
1359	Tableau Bon de production	0	2023-11-03	\N	2400	0	2023-11-10	\N	69	139	3	2	2023-11-03 14:31:52	2023-11-27 17:09:34	138	\N	f	f	 	t	\N	t
1379	teste  par attributeur	0	2024-02-01	\N	60	0	2024-02-03	\N	70	128	6	2	2024-02-01 15:55:56	2024-02-08 15:22:32	145	\N	f	f	blablabla	f	\N	t
1376	test ultime	50	2024-01-31	\N	60	0	2024-02-02	\N	70	128	6	2	2024-01-31 16:24:10	2024-02-08 15:22:41	145	\N	f	f	test be	f	\N	t
1394	BOIRE DU CAFE	20	2024-02-05	\N	120	0	2024-02-29	\N	70	134	6	2	2024-02-05 16:03:38	2024-03-01 18:04:12	127	\N	f	f	CAFEE	f	\N	t
1385	boubou	0	2024-02-01	\N	120	0	2024-02-29	\N	70	134	3	2	2024-02-01 16:46:59	2024-03-11 17:42:07	134	\N	f	f	boubou	f	\N	f
1395	DU LAIT	0	2024-02-05	\N	120	0	2024-02-21	\N	70	134	6	2	2024-02-05 16:04:58	2024-02-28 16:31:20	127	\N	f	f	DDDDD	f	\N	t
1370	et encore du teste 	0	2024-01-25	\N	600	0	2024-02-03	\N	70	128	2	2	2024-01-25 15:56:23	2024-02-05 17:10:59	145	\N	f	f	ça en fait beaucoup	f	\N	t
1378	teste confirmation par attributeur	0	2024-02-01	\N	180	0	2024-02-09	\N	70	128	3	2	2024-02-01 15:53:43	2024-02-05 17:13:11	128	\N	f	f	blablabla	f	\N	t
1369	teste de la mort 2	0	2024-01-25	\N	660	0	2024-01-27	\N	70	143	6	2	2024-01-25 14:45:47	2024-02-28 16:31:37	145	\N	f	f	 teste	f	\N	t
1375	bababababa	100	2024-01-26	\N	60	0	2024-01-30	\N	70	128	6	2	2024-01-31 16:13:00	2024-02-06 16:42:00	145	\N	f	f	 haha	f	\N	t
1391	test validation	0	2024-02-01	\N	60	0	2024-02-24	\N	70	128	3	2	2024-02-02 10:10:40	2024-02-06 16:59:49	145	\N	f	f	baba	f	\N	t
1374	haha mety amizay	0	2024-01-23	\N	60	0	2024-01-30	\N	70	135	6	2	2024-01-31 16:08:28	2024-02-28 16:30:48	145	\N	f	f	 bobo	f	\N	t
1383	baba	0	2024-02-01	\N	60	0	2024-02-09	\N	70	134	6	2	2024-02-01 16:12:43	2024-02-28 16:31:02	134	\N	f	f	bobob	f	\N	t
1384	qzazazaz	0	2024-02-01	\N	60	0	2024-02-13	\N	70	134	6	2	2024-02-01 16:26:14	2024-02-28 16:31:07	134	\N	f	f	xasas	f	\N	t
1386	mon doudou	50	2024-01-29	\N	120	0	2024-02-11	\N	70	128	6	2	2024-02-01 16:49:26	2024-02-28 16:31:12	145	\N	f	f	perdu 	f	\N	t
1382	test changeset	0	2024-02-01	\N	600	0	2024-02-07	\N	70	128	6	2	2024-02-01 16:06:11	2024-02-28 16:31:44	128	\N	f	f	mety ve	f	\N	t
1373	test 5	0	2024-01-29	\N	300	0	2024-01-31	\N	70	134	6	2	2024-01-29 09:38:20	2024-02-28 16:31:49	145	\N	f	f	 5	f	\N	t
1371	teste 3	0	2024-01-29	\N	183	0	2024-01-31	\N	70	134	6	2	2024-01-29 09:14:13	2024-02-28 16:31:54	145	\N	f	f	 3	f	\N	t
1372	test 4	0	2024-01-29	\N	240	0	2024-01-31	\N	70	134	6	2	2024-01-29 09:37:24	2024-02-28 16:31:59	145	\N	f	f	4	f	\N	t
1392	LOIC SE FAIT BLABLA	0	2024-02-01	\N	120	0	2024-02-29	\N	70	128	6	2	2024-02-02 14:56:23	2024-02-28 16:32:04	145	\N	f	f	Blabla	f	\N	t
1393	voici mon sous taches 	0	2024-02-05	\N	60	0	2024-02-28	1376	70	134	6	2	2024-02-05 13:25:51	2024-02-28 16:38:33	127	\N	f	f	\N	f	\N	t
1380	teste sous par attributeur	100	2024-02-01	\N	120	0	2024-02-04	1379	70	128	4	2	2024-02-01 15:57:57	2024-02-05 17:57:20	145	\N	f	f	\N	f	\N	t
1399	mon propre tache	0	2024-02-23	\N	60	0	2024-02-28	\N	70	145	6	2	2024-02-23 16:57:00	2024-02-28 16:31:27	145	\N	f	f	tache teste	f	\N	t
1397	LAIT DE CHACHA	20	2024-02-05	\N	180	0	2024-03-01	1395	70	134	6	2	2024-02-05 16:06:09	2024-02-28 16:38:46	127	\N	f	f	\N	f	\N	t
1396	LAIT MOOGR	15	2024-02-05	\N	120	0	2024-02-29	1395	70	134	6	2	2024-02-05 16:05:44	2024-02-28 16:38:54	127	\N	f	f	\N	f	\N	t
1367	teste sous taches dd	0	2024-01-18	\N	660	0	2024-01-27	1362	70	128	6	2	2024-01-18 10:47:05	2024-02-28 16:39:03	127	\N	f	f	\N	f	\N	t
1377	aa	0	2024-01-31	\N	60	0	2024-02-09	1373	70	128	6	2	2024-02-01 14:44:18	2024-02-28 16:39:10	128	\N	f	f	\N	f	\N	t
1390	doudouuuuuu	0	2024-02-01	\N	120	0	2024-03-09	1373	70	128	6	2	2024-02-01 17:00:44	2024-02-28 16:39:18	145	\N	f	f	\N	f	\N	t
1387	Mon sous doudou	0	2024-02-01	\N	120	0	2024-02-17	1386	70	128	6	2	2024-02-01 16:50:01	2024-02-28 16:39:27	128	\N	f	f	\N	f	\N	t
1388	Mon sous doudou	0	2024-02-01	\N	120	0	2024-02-16	1386	70	128	6	2	2024-02-01 16:56:01	2024-02-28 16:39:34	128	\N	f	f	\N	f	\N	t
1389	Mon sous doudou	0	2024-02-01	\N	120	0	2024-02-29	1373	70	128	6	2	2024-02-01 17:00:18	2024-02-28 16:39:40	128	\N	f	f	\N	f	\N	t
1404	ajout des nouveau tables necessaire	0	2024-02-29	\N	120	0	2024-03-04	\N	71	134	3	2	2024-02-29 14:07:23	2024-03-01 16:32:50	152	\N	f	f	travaille cotés base de données	f	\N	t
1407	mecanisme de filtre des donnée a afficher	0	2024-02-29	\N	180	0	2024-03-04	\N	71	134	3	2	2024-02-29 14:12:18	2024-03-01 16:34:14	152	\N	f	f	creation d'une fonction de filtrage de aussi des requete sql	f	\N	t
1406	effectuer des tri sur les colone de table	0	2024-02-29	\N	120	0	2024-03-04	\N	71	134	3	2	2024-02-29 14:09:51	2024-03-01 17:27:37	152	\N	f	f	travaille affichage	f	\N	t
1403	conception affichage de saisie de temp	0	2024-02-29	\N	360	0	2024-03-04	\N	71	134	3	2	2024-02-29 14:05:06	2024-03-01 17:31:25	152	\N	f	f	concevoir les interface necessaire pour la saisie de temps	f	\N	t
1398	Ajout de la fonctionnalité	0	2024-02-06	\N	60	0	2024-02-07	\N	70	134	3	2	2024-02-06 16:54:38	2024-03-01 18:05:04	127	\N	f	f	\N	f	\N	t
1401	affichage dynamique pour saisie de temps	0	2024-02-27	\N	360	0	2024-02-28	\N	70	134	3	2	2024-02-28 16:34:45	2024-03-05 21:32:59	152	\N	f	f	saisie de temps	f	\N	t
1405	validation des données en entrés 	0	2024-02-29	\N	60	0	2024-03-04	\N	71	134	3	2	2024-02-29 14:08:14	2024-03-05 21:33:39	152	\N	f	f	backend	f	\N	t
1400	validation sur les format de donnes entrees dans la saisie de temps	0	2024-02-28	\N	120	0	2024-02-28	\N	70	134	3	2	2024-02-28 16:32:56	2024-03-11 09:45:54	152	\N	f	f	saisie temps	f	\N	t
1402	migration  et travaille cotes base de donnees pou la fonctionalites saisie de temps	0	2024-02-28	\N	60	0	2024-02-28	\N	70	134	3	2	2024-02-28 16:35:46	2024-03-11 17:39:18	152	\N	f	f	saisie de temmps	f	\N	t
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
75	1362	128	\N	1	3	\N	2023-11-08 06:20:49	2023-11-08 06:20:49
76	1362	128	\N	3	2	on arrive pas à trouver le bon code	2023-11-08 06:22:24	2023-11-08 09:23:05
77	1361	134	\N	1	2	\N	2023-11-08 06:31:47	2023-11-08 06:31:47
78	1361	134	\N	2	3	\N	2023-11-08 06:31:59	2023-11-08 06:31:59
79	1361	134	\N	3	2	\N	2023-11-08 06:32:05	2023-11-08 06:32:05
80	1361	134	\N	2	3	\N	2023-11-08 06:32:14	2023-11-08 06:32:14
129	1359	127	\N	2	3	\N	2023-11-08 08:11:30	2023-11-08 08:11:30
81	1361	134	\N	3	2	en cours izy teto	2023-11-08 06:32:16	2023-11-08 09:33:16
82	1361	134	\N	2	3	test en blocage	2023-11-08 06:33:03	2023-11-08 09:39:47
83	1361	134	\N	3	2	test test	2023-11-08 06:39:34	2023-11-08 09:40:07
84	1361	127	\N	2	1	\N	2023-11-08 06:49:44	2023-11-08 06:49:44
85	1361	127	\N	1	3	\N	2023-11-08 06:51:35	2023-11-08 06:51:35
86	1361	127	\N	3	1	\N	2023-11-08 06:52:50	2023-11-08 06:52:50
88	1359	127	\N	3	1	\N	2023-11-08 06:54:20	2023-11-08 06:54:20
89	1359	127	\N	1	2	\N	2023-11-08 06:55:08	2023-11-08 06:55:08
90	1359	127	\N	2	3	\N	2023-11-08 06:55:11	2023-11-08 06:55:11
87	1361	127	\N	1	3	\N	2023-11-08 06:54:03	2023-11-08 09:57:10
92	1361	127	\N	3	1	111	2023-11-08 06:57:08	2023-11-08 09:57:27
93	1360	127	\N	3	2	111	2023-11-08 06:57:23	2023-11-08 09:57:38
95	1361	127	\N	1	3	\N	2023-11-08 06:57:44	2023-11-08 06:57:44
96	1361	127	\N	3	2	\N	2023-11-08 06:57:49	2023-11-08 06:57:49
94	1360	127	\N	2	3	111	2023-11-08 06:57:36	2023-11-08 09:57:51
98	1359	127	\N	1	2	\N	2023-11-08 07:23:57	2023-11-08 07:23:57
99	1359	127	\N	2	3	\N	2023-11-08 07:24:01	2023-11-08 07:24:01
100	1359	127	\N	3	2	\N	2023-11-08 07:24:10	2023-11-08 07:24:10
101	1359	127	\N	2	1	\N	2023-11-08 07:24:16	2023-11-08 07:24:16
102	1361	134	\N	1	2	\N	2023-11-08 07:31:01	2023-11-08 07:31:01
103	1361	134	\N	2	1	\N	2023-11-08 07:31:03	2023-11-08 07:31:03
104	1361	134	\N	1	2	\N	2023-11-08 07:31:07	2023-11-08 07:31:07
105	1361	134	\N	2	3	\N	2023-11-08 07:31:11	2023-11-08 07:31:11
107	1359	127	\N	1	3	\N	2023-11-08 07:31:59	2023-11-08 07:31:59
108	1359	127	\N	3	2	\N	2023-11-08 07:32:01	2023-11-08 07:32:01
109	1359	127	\N	2	1	\N	2023-11-08 07:32:05	2023-11-08 07:32:05
110	1359	127	\N	1	3	\N	2023-11-08 07:36:03	2023-11-08 07:36:03
91	1359	127	\N	3	1	blocage	2023-11-08 06:55:27	2023-11-08 10:36:41
111	1359	127	\N	3	2	111	2023-11-08 07:36:24	2023-11-08 10:37:14
113	1359	127	\N	1	3	\N	2023-11-08 07:37:25	2023-11-08 07:37:25
112	1359	127	\N	2	1	motif1	2023-11-08 07:37:09	2023-11-08 10:37:35
115	1359	127	\N	2	3	\N	2023-11-08 07:42:41	2023-11-08 07:42:41
114	1359	127	\N	3	2	motif1	2023-11-08 07:37:27	2023-11-08 10:42:52
116	1359	127	\N	3	2	motif2	2023-11-08 07:42:43	2023-11-08 10:43:02
117	1359	127	\N	2	1	\N	2023-11-08 07:45:23	2023-11-08 07:45:23
118	1359	127	\N	1	2	\N	2023-11-08 07:45:28	2023-11-08 07:45:28
119	1359	127	\N	2	1	\N	2023-11-08 08:07:29	2023-11-08 08:07:29
120	1359	127	\N	1	3	\N	2023-11-08 08:07:32	2023-11-08 08:07:32
121	1359	127	\N	3	1	\N	2023-11-08 08:07:36	2023-11-08 08:07:36
122	1359	127	\N	1	2	\N	2023-11-08 08:07:40	2023-11-08 08:07:40
123	1359	127	\N	2	3	111	2023-11-08 08:07:48	2023-11-08 11:08:17
128	1359	127	\N	1	2	111	2023-11-08 08:11:03	2023-11-08 11:11:43
141	1359	127	\N	1	2	\N	2023-11-08 08:19:14	2023-11-08 08:19:14
124	1359	127	\N	3	2	\N	2023-11-08 08:08:15	2023-11-08 11:08:30
125	1359	127	\N	2	1	\N	2023-11-08 08:09:11	2023-11-08 08:09:11
126	1359	127	\N	1	3	\N	2023-11-08 08:09:14	2023-11-08 08:09:14
127	1359	127	\N	3	1	\N	2023-11-08 08:09:25	2023-11-08 08:09:25
131	1359	127	\N	2	3	\N	2023-11-08 08:12:16	2023-11-08 08:12:16
132	1359	127	\N	3	2	\N	2023-11-08 08:12:18	2023-11-08 08:12:18
130	1359	127	\N	3	2	111	2023-11-08 08:11:41	2023-11-08 11:12:20
133	1359	127	\N	2	3	\N	2023-11-08 08:13:20	2023-11-08 08:13:20
135	1359	127	\N	2	3	\N	2023-11-08 08:17:19	2023-11-08 08:17:19
134	1359	127	\N	3	2	111	2023-11-08 08:16:18	2023-11-08 11:17:31
137	1359	127	\N	1	2	\N	2023-11-08 08:18:04	2023-11-08 08:18:04
138	1359	127	\N	2	3	\N	2023-11-08 08:18:07	2023-11-08 08:18:07
136	1359	127	\N	3	1	111	2023-11-08 08:17:27	2023-11-08 11:18:15
140	1359	127	\N	2	1	\N	2023-11-08 08:18:21	2023-11-08 08:18:21
139	1359	127	\N	3	2	l;lm:!	2023-11-08 08:18:12	2023-11-08 11:18:24
97	1361	127	\N	2	1	kamo	2023-11-08 06:57:59	2023-11-08 11:20:06
144	1362	127	\N	1	2	\N	2023-11-08 08:27:13	2023-11-08 08:27:13
143	1362	127	\N	2	1	111	2023-11-08 08:20:00	2023-11-08 11:27:40
146	1362	127	\N	1	2	\N	2023-11-08 08:30:57	2023-11-08 08:30:57
147	1362	127	\N	2	3	\N	2023-11-08 08:30:59	2023-11-08 08:30:59
145	1362	127	\N	2	1	111	2023-11-08 08:27:36	2023-11-08 11:31:03
149	1362	127	\N	2	1	\N	2023-11-08 08:36:46	2023-11-08 08:36:46
148	1362	127	\N	3	2	111	2023-11-08 08:31:01	2023-11-08 11:36:56
151	1362	127	\N	1	2	\N	2023-11-08 08:39:23	2023-11-08 08:39:23
150	1361	127	\N	2	3	111	2023-11-08 08:37:04	2023-11-08 11:39:49
153	1362	127	\N	3	2	\N	2023-11-08 08:39:58	2023-11-08 08:39:58
158	1359	127	\N	1	3	\N	2023-11-08 08:42:08	2023-11-08 08:42:08
162	1359	127	\N	1	2	\N	2023-11-08 08:44:12	2023-11-08 08:44:12
152	1362	127	\N	2	3	\N	2023-11-08 08:39:45	2023-11-08 11:40:00
154	1362	127	\N	2	1	\N	2023-11-08 08:40:17	2023-11-08 08:40:17
155	1362	127	\N	1	3	\N	2023-11-08 08:40:24	2023-11-08 08:40:24
156	1362	127	\N	3	2	\N	2023-11-08 08:40:32	2023-11-08 08:40:32
157	1359	127	\N	3	1	\N	2023-11-08 08:42:03	2023-11-08 08:42:03
142	1359	127	\N	2	3	patron olivia nous à pas aider	2023-11-08 08:19:18	2023-11-08 11:42:31
160	1359	127	\N	2	3	\N	2023-11-08 08:42:57	2023-11-08 08:42:57
159	1359	127	\N	3	2	on nous a aider	2023-11-08 08:42:14	2023-11-08 11:43:12
161	1359	127	\N	3	1	\N	2023-11-08 08:43:19	2023-11-08 08:43:19
163	1359	127	\N	2	1	\N	2023-11-08 08:44:37	2023-11-08 08:44:37
164	1359	127	\N	1	2	\N	2023-11-08 08:44:40	2023-11-08 08:44:40
165	1359	127	\N	2	1	\N	2023-11-08 08:45:37	2023-11-08 08:45:37
167	1359	127	\N	3	2	\N	2023-11-08 08:45:43	2023-11-08 08:45:43
169	1359	127	\N	1	2	\N	2023-11-08 08:48:43	2023-11-08 08:48:43
170	1359	127	\N	2	1	\N	2023-11-08 08:48:52	2023-11-08 08:48:52
174	1359	127	\N	1	3	\N	2023-11-08 08:49:04	2023-11-08 08:49:04
178	1359	127	\N	2	3	111	2023-11-08 08:49:50	2023-11-08 11:55:36
181	1359	127	\N	2	3	111	2023-11-08 08:55:39	2023-11-08 11:55:53
183	1359	127	\N	2	1	\N	2023-11-08 08:58:48	2023-11-08 08:58:48
182	1359	127	\N	3	2	111	2023-11-08 08:55:51	2023-11-08 11:58:50
184	1359	127	\N	1	2	\N	2023-11-08 08:58:59	2023-11-08 08:58:59
185	1359	127	\N	2	1	ma raison	2023-11-08 08:59:02	2023-11-08 15:33:35
166	1359	127	\N	1	3	\N	2023-11-08 08:45:41	2023-11-08 08:45:41
177	1359	127	\N	3	2	111	2023-11-08 08:49:35	2023-11-08 11:49:53
168	1359	127	\N	2	1	\N	2023-11-08 08:45:45	2023-11-08 08:45:45
171	1359	127	\N	1	2	\N	2023-11-08 08:48:54	2023-11-08 08:48:54
172	1359	127	\N	2	3	\N	2023-11-08 08:48:57	2023-11-08 08:48:57
173	1359	127	\N	3	1	\N	2023-11-08 08:49:02	2023-11-08 08:49:02
176	1359	127	\N	1	3	\N	2023-11-08 08:49:29	2023-11-08 08:49:29
179	1359	127	\N	3	1	\N	2023-11-08 08:50:26	2023-11-08 08:50:26
175	1359	127	\N	3	1	111	2023-11-08 08:49:16	2023-11-08 11:49:38
180	1359	127	\N	1	2	111	2023-11-08 08:55:34	2023-11-08 11:55:41
186	1359	127	\N	1	3	\N	2023-11-08 12:00:08	2023-11-08 12:00:08
106	1361	134	\N	3	2	motif niverina blocage	2023-11-08 07:31:13	2023-11-08 15:01:47
187	1361	134	\N	3	2	motif vavao	2023-11-08 12:01:37	2023-11-08 15:03:20
188	1361	134	\N	2	3	sarotra be	2023-11-08 12:03:13	2023-11-08 15:04:37
190	1361	134	\N	2	3	\N	2023-11-08 12:05:35	2023-11-08 12:05:35
189	1361	134	\N	3	2	vavao 2.0	2023-11-08 12:04:31	2023-11-08 15:05:40
191	1359	127	\N	3	2	\N	2023-11-08 12:22:52	2023-11-08 12:22:52
193	1359	127	\N	3	2	\N	2023-11-08 12:33:44	2023-11-08 12:33:44
192	1359	127	\N	2	3	111	2023-11-08 12:33:30	2023-11-08 15:33:47
194	1359	127	\N	3	2	farany	2023-11-08 13:51:43	2023-11-08 13:51:43
195	1359	127	\N	2	3	ca marche	2023-11-08 13:52:28	2023-11-08 13:52:28
196	1359	127	\N	3	2	111	2023-11-08 13:52:50	2023-11-08 13:52:50
197	1359	127	\N	2	1	111	2023-11-08 13:56:21	2023-11-08 13:56:21
198	1359	127	\N	1	2	111	2023-11-08 13:56:58	2023-11-08 13:56:58
199	1359	127	\N	2	3	111	2023-11-08 14:00:32	2023-11-08 14:00:32
200	1359	127	\N	3	1	111	2023-11-08 14:00:40	2023-11-08 14:00:40
201	1359	127	\N	3	2	blabla	2023-11-08 14:07:11	2023-11-08 14:07:11
202	1359	127	\N	2	3	bla	2023-11-08 14:07:25	2023-11-08 14:07:25
203	1359	127	\N	3	1	l;lm:!	2023-11-08 14:07:37	2023-11-08 14:07:37
204	1359	127	\N	3	2	ma mofds	2023-11-08 14:08:40	2023-11-08 14:08:40
205	1359	127	\N	2	3	111	2023-11-08 14:08:54	2023-11-08 14:08:54
206	1359	127	\N	3	2	ma motif	2023-11-08 14:09:27	2023-11-08 14:09:27
207	1359	127	\N	2	3	111	2023-11-08 14:11:47	2023-11-08 14:11:47
208	1359	127	\N	3	2	vivre	2023-11-08 14:15:14	2023-11-08 14:15:14
209	1359	127	\N	2	3	111	2023-11-08 14:16:44	2023-11-08 14:16:44
210	1359	127	\N	3	2	111	2023-11-08 14:18:38	2023-11-08 14:18:38
211	1359	127	\N	2	1	\N	2023-11-08 14:31:57	2023-11-08 14:31:57
212	1359	127	\N	1	2	\N	2023-11-08 14:35:19	2023-11-08 14:35:19
213	1359	127	\N	2	1	111	2023-11-08 14:59:38	2023-11-08 14:59:38
214	1361	134	\N	3	2	andarana	2023-11-09 05:50:35	2023-11-09 05:50:35
215	1361	134	\N	2	3	nety amizay	2023-11-09 05:51:16	2023-11-09 05:51:16
216	1361	134	\N	3	2	test blbal lesy leeee	2023-11-09 07:43:48	2023-11-09 07:43:48
217	1362	128	\N	2	3	anja nous à aider	2023-11-09 07:44:29	2023-11-09 07:44:29
218	1360	133	\N	4	3	diso	2023-11-09 07:52:07	2023-11-09 07:52:07
219	1360	127	\N	4	3	test	2023-11-09 08:01:16	2023-11-09 08:01:16
220	1362	128	\N	3	1	averina	2023-11-09 08:05:44	2023-11-09 08:05:44
221	1362	128	\N	3	1	111	2023-11-09 08:09:32	2023-11-09 08:09:32
222	1362	128	\N	1	2	l;lm:!	2023-11-09 08:11:26	2023-11-09 08:11:26
223	1362	128	\N	2	3	111	2023-11-09 08:11:33	2023-11-09 08:11:33
224	1362	128	\N	3	1	111	2023-11-09 08:14:07	2023-11-09 08:14:07
225	1362	128	\N	1	3	Aucune	2023-11-09 08:14:12	2023-11-09 08:14:12
226	1362	128	\N	3	1	111	2023-11-09 08:14:53	2023-11-09 08:14:53
227	1362	128	\N	3	3	Aucune	2023-11-09 08:15:39	2023-11-09 08:15:39
228	1362	128	\N	1	3	Aucune	2023-11-09 08:15:45	2023-11-09 08:15:45
229	1362	128	\N	1	3	Aucune	2023-11-09 08:15:55	2023-11-09 08:15:55
230	1362	128	\N	3	4	Aucun	2023-11-09 08:18:15	2023-11-09 08:18:15
231	1362	128	\N	4	1	111	2023-11-09 08:21:25	2023-11-09 08:21:25
232	1362	128	\N	1	3	Aucun	2023-11-09 08:21:32	2023-11-09 08:21:32
233	1362	128	\N	3	1	111	2023-11-09 08:22:01	2023-11-09 08:22:01
234	1362	128	\N	1	3	Aucun	2023-11-09 08:22:04	2023-11-09 08:22:04
235	1362	128	\N	3	1	111	2023-11-09 08:26:02	2023-11-09 08:26:02
236	1362	128	\N	1	3	Aucun	2023-11-09 08:26:09	2023-11-09 08:26:09
237	1362	128	\N	1	3	Aucun	2023-11-09 08:26:45	2023-11-09 08:26:45
238	1362	128	\N	1	3	Aucun	2023-11-09 08:26:56	2023-11-09 08:26:56
239	1362	128	\N	3	1	111	2023-11-09 08:27:11	2023-11-09 08:27:11
240	1362	128	\N	1	3	Aucun	2023-11-09 08:27:15	2023-11-09 08:27:15
241	1362	128	\N	1	1	Aucun	2023-11-09 08:32:58	2023-11-09 08:32:58
242	1362	128	\N	1	1	Aucun	2023-11-09 08:33:01	2023-11-09 08:33:01
243	1362	128	\N	1	2	111	2023-11-09 08:33:13	2023-11-09 08:33:13
244	1362	128	\N	2	3	ma motif	2023-11-09 08:33:30	2023-11-09 08:33:30
245	1362	128	\N	3	1	tyg	2023-11-09 08:33:49	2023-11-09 08:33:49
246	1362	128	\N	1	3	Aucun	2023-11-09 08:35:58	2023-11-09 08:35:58
247	1362	128	\N	1	4	Aucun	2023-11-09 08:38:49	2023-11-09 08:38:49
248	1362	128	\N	1	1	Aucun	2023-11-09 08:39:46	2023-11-09 08:39:46
249	1362	128	\N	1	3	Aucun	2023-11-09 08:39:52	2023-11-09 08:39:52
250	1362	128	\N	1	2	ma motif	2023-11-09 08:40:48	2023-11-09 08:40:48
251	1362	128	\N	2	3	ma motif	2023-11-09 08:40:59	2023-11-09 08:40:59
252	1362	128	\N	3	4	Aucun	2023-11-09 08:41:25	2023-11-09 08:41:25
253	1362	128	\N	2	4	vita	2023-11-10 06:05:26	2023-11-10 06:05:26
254	1362	128	\N	4	4	Aucun	2023-11-10 06:16:28	2023-11-10 06:16:28
255	1362	128	\N	4	4	Aucun	2023-11-10 06:16:37	2023-11-10 06:16:37
256	1362	128	\N	3	3	Aucun	2023-11-10 07:24:19	2023-11-10 07:24:19
257	1360	133	\N	4	4	Aucun	2023-11-10 08:12:40	2023-11-10 08:12:40
258	1360	133	\N	4	4	Aucun	2023-11-10 08:12:46	2023-11-10 08:12:46
259	1360	133	\N	3	4	Aucun	2023-11-10 08:12:54	2023-11-10 08:12:54
260	1360	127	\N	3	5	Aucun	2023-11-10 11:40:48	2023-11-10 11:40:48
261	1362	127	\N	3	4	Aucun	2023-11-10 11:41:09	2023-11-10 11:41:09
262	1362	127	\N	3	2	Test	2023-11-10 11:41:23	2023-11-10 11:41:23
263	1362	127	\N	2	3	En route	2023-11-10 11:41:59	2023-11-10 11:41:59
289	1360	127	\N	3	5	Aucun	2023-11-10 12:19:35	2023-11-10 12:19:35
298	1362	128	\N	1	4	Aucun	2023-11-10 12:25:31	2023-11-10 12:25:31
315	1363	127	\N	3	3	Aucun	2023-11-10 13:11:43	2023-11-10 13:11:43
321	1363	127	\N	2	1	dzqsc	2023-11-10 13:13:28	2023-11-10 13:13:28
264	1362	127	\N	3	4	Aucun	2023-11-10 11:43:50	2023-11-10 11:43:50
276	1362	127	\N	3	4	Aucun	2023-11-10 12:16:55	2023-11-10 12:16:55
303	1362	127	\N	1	1	Aucun	2023-11-10 12:39:33	2023-11-10 12:39:33
316	1363	127	\N	3	1	er	2023-11-10 13:12:09	2023-11-10 13:12:09
318	1363	127	\N	1	3	Aucun	2023-11-10 13:12:29	2023-11-10 13:12:29
265	1361	127	\N	2	3	test 2	2023-11-10 11:45:03	2023-11-10 11:45:03
266	1362	127	\N	3	5	Aucun	2023-11-10 11:45:25	2023-11-10 11:45:25
267	1361	127	\N	3	4	Aucun	2023-11-10 11:55:16	2023-11-10 11:55:16
269	1362	127	\N	3	4	Aucun	2023-11-10 12:15:37	2023-11-10 12:15:37
271	1362	127	\N	3	2	test	2023-11-10 12:16:13	2023-11-10 12:16:13
272	1362	127	\N	2	3	test	2023-11-10 12:16:23	2023-11-10 12:16:23
273	1362	127	\N	3	4	Aucun	2023-11-10 12:16:27	2023-11-10 12:16:27
275	1362	127	\N	3	4	Aucun	2023-11-10 12:16:50	2023-11-10 12:16:50
279	1362	127	\N	3	3	Aucun	2023-11-10 12:17:11	2023-11-10 12:17:11
285	1360	127	\N	3	4	Aucun	2023-11-10 12:18:16	2023-11-10 12:18:16
286	1360	127	\N	3	5	Aucun	2023-11-10 12:19:09	2023-11-10 12:19:09
292	1361	127	\N	3	3	Aucun	2023-11-10 12:20:05	2023-11-10 12:20:05
294	1362	127	\N	1	4	Aucun	2023-11-10 12:21:21	2023-11-10 12:21:21
297	1362	128	\N	1	4	Aucun	2023-11-10 12:25:26	2023-11-10 12:25:26
301	1362	128	\N	1	3	Aucun	2023-11-10 12:26:31	2023-11-10 12:26:31
302	1362	128	\N	1	4	Aucun	2023-11-10 12:26:37	2023-11-10 12:26:37
308	1362	127	\N	1	3	Aucun	2023-11-10 12:43:14	2023-11-10 12:43:14
310	1363	127	\N	1	3	Aucun	2023-11-10 13:04:35	2023-11-10 13:04:35
312	1363	127	\N	1	2	111	2023-11-10 13:11:04	2023-11-10 13:11:04
313	1363	127	\N	2	2	Aucun	2023-11-10 13:11:16	2023-11-10 13:11:16
317	1363	127	\N	1	3	Aucun	2023-11-10 13:12:25	2023-11-10 13:12:25
320	1363	127	\N	1	2	zrrer	2023-11-10 13:13:01	2023-11-10 13:13:01
268	1361	127	\N	3	5	Aucun	2023-11-10 11:55:33	2023-11-10 11:55:33
277	1362	127	\N	3	3	Aucun	2023-11-10 12:17:01	2023-11-10 12:17:01
288	1360	127	\N	3	3	Aucun	2023-11-10 12:19:30	2023-11-10 12:19:30
307	1362	127	\N	1	4	Aucun	2023-11-10 12:40:23	2023-11-10 12:40:23
270	1362	127	\N	3	3	Aucun	2023-11-10 12:15:44	2023-11-10 12:15:44
274	1362	127	\N	3	3	Aucun	2023-11-10 12:16:31	2023-11-10 12:16:31
281	1362	127	\N	2	3	ge	2023-11-10 12:17:33	2023-11-10 12:17:33
290	1361	127	\N	3	4	Aucun	2023-11-10 12:19:49	2023-11-10 12:19:49
291	1361	127	\N	3	4	Aucun	2023-11-10 12:20:01	2023-11-10 12:20:01
293	1361	127	\N	3	5	Aucun	2023-11-10 12:20:16	2023-11-10 12:20:16
295	1362	127	\N	1	3	Aucun	2023-11-10 12:21:34	2023-11-10 12:21:34
296	1362	127	\N	1	4	Aucun	2023-11-10 12:21:45	2023-11-10 12:21:45
299	1362	128	\N	1	4	Aucun	2023-11-10 12:26:11	2023-11-10 12:26:11
305	1362	127	\N	1	1	Aucun	2023-11-10 12:40:03	2023-11-10 12:40:03
309	1362	127	\N	1	4	Aucun	2023-11-10 12:49:25	2023-11-10 12:49:25
314	1363	127	\N	2	3	111	2023-11-10 13:11:36	2023-11-10 13:11:36
278	1362	127	\N	3	3	Aucun	2023-11-10 12:17:06	2023-11-10 12:17:06
280	1362	127	\N	3	2	test	2023-11-10 12:17:20	2023-11-10 12:17:20
282	1362	127	\N	3	1	tre	2023-11-10 12:17:47	2023-11-10 12:17:47
287	1360	127	\N	3	4	Aucun	2023-11-10 12:19:17	2023-11-10 12:19:17
300	1362	128	\N	1	1	Aucun	2023-11-10 12:26:18	2023-11-10 12:26:18
306	1362	127	\N	1	3	Aucun	2023-11-10 12:40:12	2023-11-10 12:40:12
319	1363	127	\N	1	3	Aucun	2023-11-10 13:12:47	2023-11-10 13:12:47
283	1362	127	\N	1	5	Aucun	2023-11-10 12:17:51	2023-11-10 12:17:51
284	1362	127	\N	1	5	Aucun	2023-11-10 12:18:03	2023-11-10 12:18:03
304	1362	127	\N	1	1	Aucun	2023-11-10 12:39:47	2023-11-10 12:39:47
311	1363	127	\N	1	1	Aucun	2023-11-10 13:08:08	2023-11-10 13:08:08
322	1363	127	\N	1	3	Aucun	2023-11-10 13:13:40	2023-11-10 13:13:40
323	1363	127	\N	1	1	Aucun	2023-11-10 13:14:59	2023-11-10 13:14:59
324	1363	127	\N	1	3	Aucun	2023-11-10 13:15:09	2023-11-10 13:15:09
325	1362	127	\N	1	3	Aucun	2023-11-10 13:15:57	2023-11-10 13:15:57
326	1360	127	\N	3	3	Aucun	2023-11-10 13:16:01	2023-11-10 13:16:01
327	1361	127	\N	3	3	Aucun	2023-11-10 13:16:06	2023-11-10 13:16:06
328	1363	127	\N	3	5	Aucun	2023-11-10 13:16:15	2023-11-10 13:16:15
329	1362	127	\N	3	5	Aucun	2023-11-10 13:16:19	2023-11-10 13:16:19
330	1360	127	\N	3	5	Aucun	2023-11-10 13:16:23	2023-11-10 13:16:23
331	1361	127	\N	3	4	Aucun	2023-11-10 13:16:26	2023-11-10 13:16:26
332	1361	127	\N	4	3	verina	2023-11-10 13:16:34	2023-11-10 13:16:34
333	1361	127	\N	3	5	Aucun	2023-11-10 13:16:40	2023-11-10 13:16:40
334	1359	127	\N	2	2	Aucun	2023-11-27 14:09:18	2023-11-27 14:09:18
335	1362	128	\N	2	4	terminer	2023-12-04 07:32:08	2023-12-04 07:32:08
336	1362	128	\N	4	4	Aucun	2024-01-09 13:29:18	2024-01-09 13:29:18
337	1362	128	\N	4	4	Aucun	2024-01-09 13:58:52	2024-01-09 13:58:52
338	1362	128	\N	3	3	Aucun	2024-01-10 11:18:08	2024-01-10 11:18:08
339	1362	128	\N	3	3	Aucun	2024-01-10 11:18:12	2024-01-10 11:18:12
340	1362	128	\N	3	4	Aucun	2024-01-10 11:18:49	2024-01-10 11:18:49
341	1362	128	\N	3	2	ma motif	2024-01-10 11:19:56	2024-01-10 11:19:56
342	1362	128	\N	3	3	Aucun	2024-01-10 11:28:04	2024-01-10 11:28:04
343	1363	127	\N	3	2	bb	2024-01-12 07:00:17	2024-01-12 07:00:17
344	1363	127	\N	2	1	afaka$	2024-01-12 07:00:51	2024-01-12 07:00:51
345	1365	127	\N	2	3	recommencer	2024-01-19 09:10:49	2024-01-19 09:10:49
346	1366	145	\N	3	2	averina	2024-01-25 11:05:38	2024-01-25 11:05:38
347	1368	145	\N	1	2	111	2024-01-25 11:38:21	2024-01-25 11:38:21
348	1368	145	\N	2	3	vita	2024-01-25 11:39:14	2024-01-25 11:39:14
349	1369	145	\N	1	3	Aucun	2024-01-25 12:55:46	2024-01-25 12:55:46
350	1366	145	\N	2	3	vita	2024-01-25 12:55:54	2024-01-25 12:55:54
351	1370	145	\N	1	3	Aucun	2024-01-25 12:56:25	2024-01-25 12:56:25
352	1372	145	\N	1	1	Aucun	2024-01-29 12:52:57	2024-01-29 12:52:57
353	1374	145	\N	1	1	Aucun	2024-01-31 13:08:39	2024-01-31 13:08:39
354	1375	145	\N	1	3	Aucun	2024-01-31 13:24:19	2024-01-31 13:24:19
355	1375	145	\N	3	3	Aucun	2024-01-31 13:24:37	2024-01-31 13:24:37
356	1375	145	\N	3	4	Aucun	2024-01-31 13:25:36	2024-01-31 13:25:36
357	1370	128	\N	2	2	Aucun	2024-02-05 14:10:59	2024-02-05 14:10:59
358	1378	128	\N	1	3	Aucun	2024-02-05 14:13:11	2024-02-05 14:13:11
359	1379	128	\N	1	3	Aucun	2024-02-05 14:14:25	2024-02-05 14:14:25
360	1379	128	\N	3	3	Aucun	2024-02-05 14:48:34	2024-02-05 14:48:34
361	1382	128	\N	1	3	Aucun	2024-02-05 14:48:38	2024-02-05 14:48:38
362	1380	128	\N	1	1	Aucun	2024-02-05 14:50:08	2024-02-05 14:50:08
363	1380	128	\N	1	3	Aucun	2024-02-05 14:50:28	2024-02-05 14:50:28
364	1380	128	\N	3	4	Aucun	2024-02-05 14:56:03	2024-02-05 14:56:03
365	1380	128	\N	4	3	edrerer	2024-02-05 14:56:47	2024-02-05 14:56:47
366	1380	128	\N	3	4	Aucun	2024-02-05 14:57:00	2024-02-05 14:57:00
367	1380	128	\N	4	4	Aucun	2024-02-05 14:57:12	2024-02-05 14:57:12
368	1380	128	\N	4	4	Aucun	2024-02-05 14:57:20	2024-02-05 14:57:20
369	1381	128	\N	1	1	Aucun	2024-02-26 13:46:59	2024-02-26 13:46:59
370	1394	134	\N	1	3	Aucun	2024-03-01 14:43:11	2024-03-01 14:43:11
371	1398	134	\N	1	3	Aucun	2024-03-01 15:04:18	2024-03-01 15:04:18
\.


--
-- Data for Name: time_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.time_entries (id, date_entries, user_id, task_id, project_id, libele, time_value, inserted_at, updated_at, validation_status) FROM stdin;
1	2024-02-28 00:00:00	128	1366	70	test libele	1	2024-02-28 09:57:56	2024-02-28 09:57:56	0
2	2024-02-28 00:00:00	128	1359	69	madaplast test	0.75	2024-02-28 11:26:31	2024-02-28 11:26:31	0
3	2024-02-28 00:00:00	128	1385	70	boubou	0.75	2024-02-28 11:27:52	2024-02-28 11:27:52	0
4	2024-02-28 00:00:00	128	1384	70	zazaz	0.25	2024-02-28 11:34:14	2024-02-28 11:34:14	0
5	2024-02-28 00:00:00	128	1396	70	zazaz	1.25	2024-02-28 11:36:26	2024-02-28 11:36:26	0
6	2024-02-28 00:00:00	128	1372	70	zaza	1	2024-02-28 11:37:55	2024-02-28 11:37:55	0
7	2024-02-28 00:00:00	128	1368	70	zazaz	0.25	2024-02-28 11:40:26	2024-02-28 11:40:26	0
8	2024-02-28 00:00:00	128	1368	70	zazaz	0.25	2024-02-28 11:40:29	2024-02-28 11:40:29	0
9	2024-02-28 00:00:00	128	1383	70	zazazza	1.25	2024-02-28 11:41:46	2024-02-28 11:41:46	0
10	2024-02-28 00:00:00	128	1386	70	azazazazearez	0.75	2024-02-28 11:43:05	2024-02-28 11:43:05	0
11	2024-02-28 00:00:00	128	1377	70	zaz	1	2024-02-28 11:45:27	2024-02-28 11:45:27	0
12	2024-02-28 00:00:00	128	1377	70	zaz	1	2024-02-28 11:45:43	2024-02-28 11:45:43	0
13	2024-02-28 00:00:00	128	1397	70	zazazzaazaz	1	2024-02-28 11:48:16	2024-02-28 11:48:16	0
14	2024-02-28 00:00:00	128	1359	69	azaz	0.25	2024-02-28 11:50:33	2024-02-28 11:50:33	0
15	2024-02-28 00:00:00	128	1399	70	zazaza	0.25	2024-02-28 11:57:42	2024-02-28 11:57:42	0
16	2024-02-28 00:00:00	128	1359	69	loic test farany be amizay	1.25	2024-02-28 11:58:10	2024-02-28 11:58:10	0
17	2024-02-28 00:00:00	128	1359	69	test madaplast	1.25	2024-02-28 12:00:42	2024-02-28 12:00:42	0
18	2024-02-28 00:00:00	128	1391	70	test de validation	0.5	2024-02-28 12:03:29	2024-02-28 12:03:29	0
19	2024-02-28 00:00:00	128	1359	69	mon test	1.25	2024-02-28 12:18:35	2024-02-28 12:18:35	0
20	2024-02-28 00:00:00	128	1359	69	mon test	0.25	2024-02-28 12:19:07	2024-02-28 12:19:07	0
21	2024-02-28 00:00:00	134	1394	70	mon cafe	0.25	2024-02-28 12:20:29	2024-02-28 12:20:29	0
22	2024-02-28 00:00:00	134	1371	70	test 3 	0.75	2024-02-28 12:22:30	2024-02-28 12:22:30	0
23	2024-02-28 00:00:00	152	1372	70	test par admin	0.75	2024-02-28 12:31:26	2024-02-28 12:31:26	0
24	2024-02-28 00:00:00	152	1369	70	test deconnection	0.25	2024-02-28 12:32:00	2024-02-28 12:32:00	0
25	2024-02-28 00:00:00	152	1359	69	test sur madaplast	0.25	2024-02-28 14:21:36	2024-02-28 14:21:36	0
26	2024-02-28 00:00:00	152	1391	70	validation	0.25	2024-02-28 14:21:50	2024-02-28 14:21:50	0
27	2024-02-29 00:00:00	152	1380	70	mon test ajd	0.25	2024-02-29 06:15:20	2024-02-29 06:15:20	0
28	2024-02-29 00:00:00	152	1359	69	test madaplast	1	2024-02-29 06:15:43	2024-02-29 06:15:43	0
29	2024-02-29 00:00:00	152	1359	69	mon second teste	0.75	2024-02-29 06:16:27	2024-02-29 06:16:27	0
30	2024-02-29 00:00:00	152	1394	70	deja fait	1.25	2024-02-29 06:31:38	2024-02-29 06:31:38	0
31	2024-02-29 00:00:00	152	1359	69	test sort	1	2024-02-29 06:32:15	2024-02-29 06:32:15	0
32	2024-02-29 00:00:00	152	1359	69	mon projet madaplast	0.75	2024-02-29 10:05:53	2024-02-29 10:05:53	0
33	2024-02-29 00:00:00	152	1405	71	mon validation	1.25	2024-02-29 11:21:04	2024-02-29 11:21:04	0
34	2024-02-29 00:00:00	127	1401	70	test farany	1.25	2024-02-29 11:42:24	2024-02-29 11:42:24	0
35	2024-02-29 00:00:00	127	1405	71	\N	1.25	2024-02-29 12:28:50	2024-02-29 12:28:50	0
36	2024-02-29 00:00:00	128	1406	71	Test	0.25	2024-02-29 13:37:28	2024-02-29 13:37:28	0
37	2024-02-29 00:00:00	128	1359	69	Test1	0.75	2024-02-29 14:49:52	2024-02-29 14:49:52	0
38	2024-03-01 00:00:00	134	1407	71	filtrage 	0.25	2024-03-01 07:10:56	2024-03-01 07:10:56	0
39	2024-03-01 00:00:00	134	1407	71	filtrage 	0.25	2024-03-01 07:11:12	2024-03-01 07:11:12	0
40	2024-03-01 00:00:00	128	1403	71	Responsive 'user-info'	0.5	2024-03-01 08:24:24	2024-03-01 08:24:24	0
41	2024-03-01 00:00:00	128	1403	71	Centrage en-tête saisie de temps	0.25	2024-03-01 08:29:30	2024-03-01 08:29:30	0
42	2024-03-01 00:00:00	128	1403	71	Centrage en-tête saisie de temps	0.25	2024-03-01 08:29:31	2024-03-01 08:29:31	0
43	2024-03-01 00:00:00	128	1403	71	Test00	0.25	2024-03-01 08:30:31	2024-03-01 08:30:31	0
44	2024-03-01 00:00:00	128	1403	71	Test00	0.25	2024-03-01 08:30:31	2024-03-01 08:30:31	0
45	2024-03-01 00:00:00	128	1403	71	TEST 1	0.25	2024-03-01 08:32:30	2024-03-01 08:32:30	0
46	2024-03-01 00:00:00	128	1403	71	TEST 1	0.25	2024-03-01 08:32:31	2024-03-01 08:32:31	0
47	2024-03-01 00:00:00	128	1403	71	TEST 2	0.25	2024-03-01 08:32:55	2024-03-01 08:32:55	0
48	2024-03-01 00:00:00	152	1378	70	action	0.25	2024-03-01 08:46:46	2024-03-01 08:46:46	0
49	2024-03-01 00:00:00	152	1407	71	mon test ajax	1	2024-03-01 08:53:03	2024-03-01 08:53:03	0
50	2024-03-01 00:00:00	134	1391	70	validation	1.25	2024-03-01 13:32:13	2024-03-01 13:32:13	0
51	2024-03-01 00:00:00	134	1404	71	bd	0.75	2024-03-01 13:32:50	2024-03-01 13:32:50	0
52	2024-03-01 00:00:00	134	1407	71	test	0.25	2024-03-01 13:34:14	2024-03-01 13:34:14	0
53	2024-03-01 00:00:00	134	1404	71	bd	1.5	2024-03-01 14:27:09	2024-03-01 14:27:09	0
54	2024-03-01 00:00:00	134	1406	71	test	1.75	2024-03-01 14:27:37	2024-03-01 14:27:37	0
55	2024-03-01 00:00:00	134	1359	69	madaplast	0.5	2024-03-01 14:28:46	2024-03-01 14:28:46	0
56	2024-03-01 00:00:00	128	1403	71	Test Temps	5	2024-03-01 14:31:25	2024-03-01 14:31:25	0
57	2024-03-01 00:00:00	128	1381	70	Test A faire	0.5	2024-03-01 14:40:49	2024-03-01 14:40:49	0
59	2024-03-05 00:00:00	127	1359	69	mon second test	0.85	2024-03-05 00:53:02	2024-03-05 00:53:02	0
66	2024-03-06 00:00:00	134	1398	70	mon ajout 	0.25	2024-03-06 06:04:51	2024-03-06 06:04:51	0
58	2024-03-05 00:00:00	127	1380	70	mon test pour edit	0.45	2024-03-05 00:20:49	2024-03-05 04:24:11	0
60	2024-03-05 00:00:00	127	1398	70	aj fonctionalite	0.53	2024-03-05 04:24:37	2024-03-05 04:25:39	0
61	2024-03-05 00:00:00	152	1407	71	mon test	0.5	2024-03-05 07:28:55	2024-03-05 07:28:55	0
62	2024-03-05 00:00:00	152	1391	70	mon validation	0.46	2024-03-05 07:29:19	2024-03-05 08:34:16	0
63	2024-03-05 00:00:00	127	1401	70	affichage test haha	0.76	2024-03-05 18:32:59	2024-03-05 18:33:21	0
64	2024-03-05 00:00:00	127	1359	69	test	0.78	2024-03-05 18:33:39	2024-03-05 18:34:05	0
67	2024-03-06 00:00:00	134	1403	71	mon filtre	0.35	2024-03-06 06:05:09	2024-03-06 06:05:09	0
68	2024-03-07 00:00:00	134	1405	71	mon test ajd	1	2024-03-07 07:57:49	2024-03-07 07:57:49	0
69	2024-03-07 00:00:00	134	1406	71	\N	1.5	2024-03-07 07:58:08	2024-03-07 07:58:08	0
70	2024-03-07 00:00:00	134	1359	69	test admin	0.5	2024-03-07 09:03:15	2024-03-07 09:03:15	0
71	2024-03-07 00:00:00	134	1359	69	\N	0.0	2024-03-07 11:35:31	2024-03-07 11:35:31	0
72	2024-03-07 00:00:00	127	1359	69	test	2.75	2024-03-07 14:13:18	2024-03-07 14:13:18	0
73	2024-03-07 00:00:00	127	1359	69	test blabla	1.5	2024-03-07 14:20:34	2024-03-07 14:20:34	0
74	2024-03-07 00:00:00	127	1359	69	test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla - test bla bla -	2.75	2024-03-07 14:21:28	2024-03-07 14:21:28	0
75	2024-03-08 00:00:00	127	1404	71	aza	0.8	2024-03-08 07:42:33	2024-03-08 07:49:55	0
76	2024-03-08 00:00:00	127	1359	69	azaza	0.9	2024-03-08 07:59:44	2024-03-08 07:59:44	0
77	2024-03-08 00:00:00	127	1404	71	mon teste	0.9	2024-03-08 09:16:09	2024-03-08 09:16:09	0
78	2024-03-08 00:00:00	134	1359	69	aj par admin	0.5	2024-03-08 10:47:17	2024-03-08 10:47:17	0
82	2024-03-08 00:00:00	127	1401	70	test anie	0.9	2024-03-11 13:42:43	2024-03-11 13:42:43	0
81	2024-03-11 00:00:00	127	1359	69	mon libele	0.70	2024-03-11 07:59:11	2024-03-11 14:56:15	0
87	2024-03-12 00:00:00	134	1359	69	mon test sur la nouvelle affichage	0.75	2024-03-12 14:20:55	2024-03-12 14:21:05	0
88	2024-03-11 00:00:00	128	1398	70	test	2	2024-03-12 14:28:39	2024-03-12 14:28:39	0
\.


--
-- Data for Name: time_entries_validee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.time_entries_validee (id, date, time_value, user_id, user_validator_id, inserted_at, updated_at, validation_status) FROM stdin;
16	2024-03-05	1.83	127	152	2024-03-05 05:44:54	2024-03-05 05:44:54	0
17	2024-03-05	0	128	152	2024-03-05 05:45:48	2024-03-05 05:45:48	0
18	2024-03-05	0	129	152	2024-03-05 05:49:08	2024-03-05 05:49:08	0
19	2024-03-05	0	130	152	2024-03-05 05:49:59	2024-03-05 05:49:59	0
20	2024-02-28	15.50	128	152	2024-03-05 05:51:04	2024-03-05 05:51:04	0
21	2024-02-28	1.00	134	152	2024-03-05 05:59:14	2024-03-05 05:59:14	0
22	2024-02-29	2.50	127	152	2024-03-05 08:33:05	2024-03-05 08:33:05	0
23	2024-03-05	0.96	152	127	2024-03-05 18:34:33	2024-03-05 18:34:33	0
24	2024-02-29	0	130	127	2024-03-05 18:35:11	2024-03-05 18:35:11	0
25	2024-03-06	0.60	134	127	2024-03-11 09:10:07	2024-03-11 09:10:07	0
26	2024-03-11	2	128	127	2024-03-12 14:29:21	2024-03-12 14:29:21	0
\.


--
-- Data for Name: time_tracking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.time_tracking (id, date, h_work, h_abs, task_id, user_id, inserted_at, updated_at) FROM stdin;
1	2024-02-16	20	0	1373	134	2024-02-16 06:59:34	2024-02-16 06:59:34
2	2024-02-16	30	0	1383	134	2024-02-16 07:01:23	2024-02-16 07:01:23
3	2024-02-16	60	0	1385	134	2024-02-16 07:14:24	2024-02-16 07:14:24
4	2024-02-16	80	0	1398	134	2024-02-16 07:14:46	2024-02-16 07:14:46
5	2024-02-16	30	0	1368	128	2024-02-16 07:17:22	2024-02-16 07:17:22
6	2024-02-16	0	0	1366	128	2024-02-16 07:17:26	2024-02-16 07:17:26
7	2024-02-16	25	0	1366	128	2024-02-16 07:17:33	2024-02-16 07:17:33
8	2024-02-16	25	0	1380	128	2024-02-16 07:17:49	2024-02-16 07:17:49
9	2024-02-19	25	0	1373	134	2024-02-19 07:10:43	2024-02-19 07:10:43
10	2024-02-22	25	0	1373	134	2024-02-22 07:39:01	2024-02-22 07:39:01
11	2024-02-20	100	0	1373	134	2024-02-22 07:40:37	2024-02-22 07:40:37
12	2024-02-22	150	0	1383	134	2024-02-22 07:44:12	2024-02-22 07:44:12
13	2024-02-21	10	0	1373	134	2024-02-22 07:46:56	2024-02-22 07:46:56
14	2024-02-22	20	0	1373	134	2024-02-22 08:05:02	2024-02-22 08:05:02
15	2024-02-23	52	0	1373	134	2024-02-23 07:01:11	2024-02-23 07:01:11
16	2024-02-23	30	0	1368	128	2024-02-23 12:05:08	2024-02-23 12:05:08
17	2024-02-23	30	0	1381	128	2024-02-23 12:05:35	2024-02-23 12:05:35
18	2024-02-26	120	0	1399	145	2024-02-26 06:10:47	2024-02-26 06:10:47
19	2024-02-26	25	0	1399	145	2024-02-26 06:13:21	2024-02-26 06:13:21
20	2024-02-14	330	0	1373	134	2024-02-26 06:40:02	2024-02-26 06:40:02
21	2024-02-14	185	0	1385	134	2024-02-26 06:40:24	2024-02-26 06:40:24
22	2024-02-27	130	0	1368	128	2024-02-27 11:34:01	2024-02-27 11:34:01
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

COPY public.users (id, username, profile_picture, email, password, right_id, inserted_at, updated_at, function_id, current_record_id, phone_number) FROM stdin;
129	Alain	images/profiles/default_profile_pic.png	alain@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$kmeC/LM0Q4vJThzXhExrvQ$22LXv27pq/gcqbzBtAGYxh6gSX66GDeFrtsROggEnP5S5sMiqK54aILFPLbmXFXkooTGWKemnYQoWlfRHMF39Q	3	2023-11-03 06:12:01	2023-11-03 06:12:55	\N	\N	\N
130	Philippe	images/profiles/default_profile_pic.png	pp@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$0rU6Xiw1KpHw4mz1UW0XKQ$WU6dt9Ci6M/0337DOyxuGwgaj4fQrTrxg2GBDQJhcHJCZRgaIyJNqlvSzuP47R4RkkbH9EG.gf352So1X0I54w	1	2023-11-03 06:13:47	2023-11-03 06:13:56	\N	\N	\N
135	Ioly	images/profiles/default_profile_pic.png	ioly@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$z4FlAop14L2ddUMFTrM83A$baXkm2GHyCHumNPgCFcyA897./pS0u0Rpi3edMt56031yn30vniFzQWlqZHNgTfomF5jpBxUpmWO830ETb4mBQ	2	2023-11-03 06:19:45	2023-11-03 06:20:00	\N	\N	\N
134	Loïc	images/profiles/default_profile_pic.png	loicRavelo05@gmail.com	$pbkdf2-sha512$160000$l5tsXJ5Nh6KlI.wBtw1EcA$55SsZaP9mruiOQQ8Na3oVC.i1/zzg8ruKI1HoW14FXwnGVGE1asjBVU1oNVXVLOsWF0rxBJxVm2y647VLswn8g	3	2023-11-03 06:19:17	2023-11-03 06:20:16	\N	\N	\N
136	Matthieu	images/profiles/default_profile_pic.png	matthieu@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$lU3If.N3XEepbGV3atTj1Q$d9q1CuBONUAHKF1sKPM6sk6LVZiwoj6kLJrLp4PFIYaJr4BuS2HellNvjc4kPwT.TRFXwr84MF2l/EdYWI.0TA	2	2023-11-03 06:20:57	2023-11-03 06:21:10	\N	\N	\N
137	Fanilo	images/profiles/default_profile_pic.png	fanilomampionona@outlook.fr	$pbkdf2-sha512$160000$PG/euuhiSQgtOX8fOZwzvg$rbUsL.DIdjngzAl40VQbQP3S2IeAUMe/wdkgBdZB0oMmWwi4iAwZuJNc2Hac.uX67mD1.BWzxe5tEXSQvwWoeA	3	2023-11-03 06:21:19	2023-11-03 06:21:31	\N	\N	\N
138	Mathieu	images/profiles/default_profile_pic.png	mathieu@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$6TO7SjTTGZi4EexSW/XRKw$ckdwJwgIdr8GQDZywJOpyDCwHxAA7rlMvVJ8mtVwBTaETqDYch2dU7q3aGTgN5ijrkQD5eJ.DRtGEvwWqkw57g	2	2023-11-03 06:22:00	2023-11-03 06:22:13	\N	\N	\N
139	Kevin	images/profiles/default_profile_pic.png	kevinnandrianina@outlook.fr	$pbkdf2-sha512$160000$d6nbG44aFNlBeyA4U.BYVQ$3hjP2OoN4W4nT.15.Qny6JHc6HI4xzjHjTTSCrY8jYvNkmgyY0yGPgEapv6Mq.tAPdPqN7JqTHp4JVyTIX9QqA	3	2023-11-03 06:22:56	2023-11-03 06:23:07	\N	\N	\N
140	Mirindra	images/profiles/default_profile_pic.png	mirindra@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$0NS6huBhte/3hgn2R7R9fg$77DqRSKANd4MNKAokkc5xNTDRKf8WgR6W3NdXBjipVtKFqg3P17nZdF1rJzU29CcwvtREPxIfAkQrPsUYUvwvQ	3	2023-11-03 06:24:15	2023-11-03 06:24:38	\N	\N	\N
141	Adrien	images/profiles/default_profile_pic.png	herilanto.adrien@outlook.com	$pbkdf2-sha512$160000$0ezLe9rJMAkPERHRgdQ9yQ$ub.mwOLVKdFH1ZUYD.XnmbNlBiRZZIY9KKIatQiSIxdC4Wd4am5masYnXrdEchoWc08Y4ZEnfAwzS1J6XRsPIg	3	2023-11-03 06:25:00	2023-11-03 06:25:27	\N	\N	\N
143	Mickaël	images/profiles/default_profile_pic.png	raz.lovatiana@gmail.com	$pbkdf2-sha512$160000$bv7A8fUK56U661M/QtLqHg$ZYgqbTD4Lw9vWeq5R2tkS7ZzSiHwOoU4qR7qAtqF6.LGJsjTKXGJ3JEQjAWj6ulLOPifDj0JTMOe65XeeWv6kQ	3	2023-11-03 06:28:18	2023-11-03 06:28:39	\N	\N	\N
144	Ny Toky	images/profiles/default_profile_pic.png	nytoky@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$c7b5Ivd7i76BGGtS4j.c.Q$ptIeLXAtBE3fqufztkiIi2FPxBhpVjfgTCxhynMjVsYlSwrjrLebY4XONcxLXpukw1knQ8jXzcmSjsYSYhvJqQ	2	2023-11-03 06:28:31	2023-11-03 06:28:46	\N	\N	\N
145	Frederick	images/profiles/default_profile_pic.png	frederick@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$pJEKSSYrDBPLrVgpk.JJcg$JvkGcrkqOioQ059u1L5WIfsCv5SZlQ7fMkNBoV2FYsRVRUUeOgGs1Q4K7IaGyNp0057B9r7akzTDjqBLKlbWjg	2	2023-11-03 06:29:55	2023-11-03 06:30:13	\N	\N	\N
146	Miandrisoa	images/profiles/default_profile_pic.png	miandrisoa@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$8jxXqAn0M7aduipHcE9NdA$r4GZBDuH7MKO11vD57Rs7mUIhhkaapNRm.ChDgDVXFIT4ga74WtiSyRb6d2LgG4gKQVoDTlWruZtfO60amAp8g	3	2023-11-03 06:31:02	2023-11-03 06:31:22	\N	\N	\N
147	Koloina	images/profiles/default_profile_pic.png	koloina@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$h0DRlerGOtQvPrH7Gdr8XQ$U8Wdgzd4drDf0rUBVOC2LPCfIiVN7Wp2c7L1YZh.GGrKNBWqRd4Rks6Bif8ObFIdiongSZCaq7/iJPbsPfIRHA	3	2023-11-03 06:32:09	2023-11-03 06:32:22	\N	\N	\N
148	Mickaella	images/profiles/default_profile_pic.png	bidmicks@outlook.fr	$pbkdf2-sha512$160000$wTbVruYmhAwD4VLYbK5q7g$xiXL1m81SKmLjGNaHg0vCcebTYcPYLN6UQDowwm7jYIbW1jrEPbnrxy6lHAZRJGeQCXlYayqsAYlKkKGfTOJug	3	2023-11-03 06:33:06	2023-11-03 06:33:16	\N	\N	\N
133	Anja	images/profiles/Anja-profile.jpg	anjaranaivo464@gmail.com	$pbkdf2-sha512$160000$C2uPZxk/z4gRi.Dw1/f9tg$NQLRTZ7Z7oQlkWtIp7yThdXfhF3ZdQ1QuQaKDKCo4CRx2xiNGS3QGq96L8xFSz8r3dF5a.ZICz313/B/K3RCyw	3	2023-11-03 06:16:56	2023-11-03 06:35:40	\N	\N	\N
132	Tahina	images/profiles/default_profile_pic.png	tahina@phidia.onmicrosoft.com	$pbkdf2-sha512$160000$h5MSqLTJabD262b/IHHQyg$5WornfQxwZ1Vy3X31eHl81TLUld2kv.aua1JU/YKh8QCYTSsBOCDduQBeJC7oSOeo9vZAXo7Hw9EzayQFshAoQ	1	2023-11-03 06:16:14	2023-11-07 07:20:49	\N	\N	\N
131	Hasina	images/profiles/Hasina-profile.jpeg	olyviahasina.razakamanantsoa@gmail.com	$pbkdf2-sha512$160000$v/vTJg6fPAj7Dfgn1HxkWQ$PmEfbIVojrBFpR29vmdZZTfo6G3rH6t5SstXx0vF/A3.n93BaABIaKWcmQWZaPa4PqtLCID8A.kk9eutYi3Ksw	2	2023-11-03 06:15:03	2023-11-03 06:36:57	\N	\N	\N
149	Madaplast	images/profiles/default_profile_pic.png	madaplast@madaplast.mg	$pbkdf2-sha512$160000$XSnPJiOY/ecRZSsannsOqg$Y2cxBXfrPN1GBiZPCPQTmMWBFQIDCxeV5mFj96VOJcpksY5MRJ7qd//k/QKFDevtOTxVwhZGreOVDnFjZCsOPA	4	2023-11-03 11:10:12	2023-11-03 11:10:30	\N	\N	\N
142	Hassan	images/profiles/Hassan-profile.jpg	razorhassan@outlook.be	$pbkdf2-sha512$160000$577vPwHx9OZW1kcroL70cg$IbQm2Xh/tPS28tERUoU4Fz43ISBHiv9kdiy33Uw0v0yBLiT3pJVvcb0okNrqNtJz2ypCNe8piIB/5Tj590TkLQ	3	2023-11-03 06:26:57	2023-11-06 07:21:52	\N	\N	\N
150	MGBI	images/profiles/default_profile_pic.png	mgbi.adm@gmail.com	$pbkdf2-sha512$160000$4Y11FezPryYhyC1.V4wnag$dLBzY8G3qH43cbRuzEiAIDOW21JpPvtUgyuUkkhvrYY6YLt6gO7RrYtZpXaKz6tQ34TLV4oqsH3hVMYxWikIWw	4	2023-11-06 13:22:15	2023-11-06 13:22:15	\N	\N	\N
127	PhidiaAdmin	PhidiaAdmin-profile.jpg	admin@phidia.fr	$pbkdf2-sha512$160000$BmRdndUq5ZutNwtNqow3gA$wmVrchJMpmnmeLhSlyJ9yELSrYGeufJE1Nh/ZrAp6jkVf4tbxRLNHyf16trCrslYW5B5zq2K3owbIWw2wYwSeA	1	2023-11-02 07:37:53	2024-01-31 06:44:40	\N	\N	0341010010
128	Antonio	Antonio-profile.png	midorimaantonio@gmail.com	$pbkdf2-sha512$160000$zLwxw9uG85asYvPw64J9ig$jb2rTldkWaeYU2HUd5.yJHi15Iv.ofV39Wi44/8DmcPDSQs4Mm22SJa6FDu/SMABm6xyCSkk4DpUasRMgY3gww	3	2023-11-03 05:51:32	2024-02-01 08:07:26	\N	1	0325967397
151	test	images/profiles/default_profile_pic.png	test@test.com	$pbkdf2-sha512$160000$6JIUVQuScUmQV.IQ1YXUaw$qKOkFnk5b1uR6Mj1LJxUGDoRruSK5k2lXZlh.FDK1Z4aXCM5dP04mIom6hxteon0CwxwuMwviEJDCDSUM8cN7w	4	2023-11-07 09:13:50	2024-02-06 13:45:01	\N	\N	\N
153	Loic_Clinent	images/profiles/default_profile_pic.png	lolo@gmail.com	$pbkdf2-sha512$160000$oQTEK1uNmUvJM/IFNFj/tg$XOkUBKPI3kZrIpcZjfJya6qyQJSyYqbmFUWsoQL3WNywHM77s3I/kV5iRnE4kGM82WtANI5i5p.I4SvVEsPRtg	4	2024-02-07 12:41:24	2024-02-07 12:41:37	\N	\N	\N
152	Loic_Admin	images/profiles/default_profile_pic.png	Loic_Admin@phidia.fr	$pbkdf2-sha512$160000$TWz3/P1Mqw.CBGow.0DGjw$l1xYBtkqD7ZT4mTmcqEeMVlpQQxOqvsz.yqK6rFdISPensbkYHu5J2K6LMBKTFV2R619zmOXECq1K5ZMTocT4A	1	2024-01-12 07:14:36	2024-02-08 11:49:13	\N	\N	0342873090
\.


--
-- Name: active_clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.active_clients_id_seq', 40, true);


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

SELECT pg_catalog.setval('public.boards_id_seq', 90, true);


--
-- Name: cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cards_id_seq', 1385, true);


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
-- Name: launch_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.launch_types_id_seq', 2, true);


--
-- Name: licenses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.licenses_id_seq', 6, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 28478, true);


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

SELECT pg_catalog.setval('public.projects_id_seq', 71, true);


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
-- Name: saisies_validees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.saisies_validees_id_seq', 2, true);


--
-- Name: softwares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.softwares_id_seq', 4, true);


--
-- Name: stages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stages_id_seq', 446, true);


--
-- Name: statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.statuses_id_seq', 5, true);


--
-- Name: task_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_records_id_seq', 1, true);


--
-- Name: task_tracings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.task_tracings_id_seq', 40, true);


--
-- Name: tasks_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_history_id_seq', 371, true);


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tasks_id_seq', 1407, true);


--
-- Name: time_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.time_entries_id_seq', 88, true);


--
-- Name: time_entries_validee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.time_entries_validee_id_seq', 26, true);


--
-- Name: time_tracking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.time_tracking_id_seq', 22, true);


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

SELECT pg_catalog.setval('public.users_id_seq', 153, true);


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
-- Name: launch_types launch_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.launch_types
    ADD CONSTRAINT launch_types_pkey PRIMARY KEY (id);


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
-- Name: saisies_validees saisies_validees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saisies_validees
    ADD CONSTRAINT saisies_validees_pkey PRIMARY KEY (id);


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
-- Name: task_tracings task_tracings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tracings
    ADD CONSTRAINT task_tracings_pkey PRIMARY KEY (id);


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
-- Name: time_entries time_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_pkey PRIMARY KEY (id);


--
-- Name: time_entries_validee time_entries_validee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries_validee
    ADD CONSTRAINT time_entries_validee_pkey PRIMARY KEY (id);


--
-- Name: time_tracking time_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_tracking
    ADD CONSTRAINT time_tracking_pkey PRIMARY KEY (id);


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
-- Name: users unq_users_phone_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT unq_users_phone_number UNIQUE (phone_number);


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
-- Name: saisies_validees_user_id_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX saisies_validees_user_id_date_index ON public.saisies_validees USING btree (user_id, date);


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
-- Name: saisies_validees saisies_validees_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saisies_validees
    ADD CONSTRAINT saisies_validees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: saisies_validees saisies_validees_user_validator_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saisies_validees
    ADD CONSTRAINT saisies_validees_user_validator_fkey FOREIGN KEY (user_validator_id) REFERENCES public.users(id);


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
-- Name: task_tracings task_tracings_launch_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tracings
    ADD CONSTRAINT task_tracings_launch_type_id_fkey FOREIGN KEY (launch_type_id) REFERENCES public.launch_types(id);


--
-- Name: task_tracings task_tracings_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tracings
    ADD CONSTRAINT task_tracings_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: task_tracings task_tracings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_tracings
    ADD CONSTRAINT task_tracings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


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
-- Name: time_entries time_entries_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: time_entries time_entries_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: time_entries time_entries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries
    ADD CONSTRAINT time_entries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: time_entries_validee time_entries_validee_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries_validee
    ADD CONSTRAINT time_entries_validee_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: time_entries_validee time_entries_validee_user_validator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_entries_validee
    ADD CONSTRAINT time_entries_validee_user_validator_id_fkey FOREIGN KEY (user_validator_id) REFERENCES public.users(id);


--
-- Name: time_tracking time_tracking_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_tracking
    ADD CONSTRAINT time_tracking_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: time_tracking time_tracking_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_tracking
    ADD CONSTRAINT time_tracking_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


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

