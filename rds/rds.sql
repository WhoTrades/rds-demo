--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0
-- Dumped by pg_dump version 13.0

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
-- Name: rds; Type: SCHEMA; Schema: -; Owner: rds
--

CREATE SCHEMA rds;


ALTER SCHEMA rds OWNER TO rds;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: obj_base; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.obj_base (
    obj_id bigint NOT NULL,
    obj_created timestamp(6) with time zone DEFAULT now() NOT NULL,
    obj_modified timestamp(6) with time zone DEFAULT now() NOT NULL,
    obj_status_did smallint DEFAULT 1 NOT NULL
);


ALTER TABLE rds.obj_base OWNER TO rds;

--
-- Name: TABLE obj_base; Type: COMMENT; Schema: rds; Owner: rds
--

COMMENT ON TABLE rds.obj_base IS 'Abstract base obj';


--
-- Name: build; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.build (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    build_release_request_obj_id bigint,
    build_worker_obj_id bigint NOT NULL,
    build_project_obj_id bigint NOT NULL,
    build_status character varying DEFAULT 'new'::character varying NOT NULL,
    build_attach text DEFAULT ''::text,
    build_version character varying(64) DEFAULT NULL::character varying,
    build_time_log text DEFAULT '[]'::text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.build OWNER TO rds;

--
-- Name: build_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.build_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.build_obj_id_seq OWNER TO rds;

--
-- Name: build_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.build_obj_id_seq OWNED BY rds.build.obj_id;


--
-- Name: hard_migration; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.hard_migration (
    obj_id bigint,
    migration_release_request_obj_id bigint,
    migration_pid bigint,
    migration_type character varying(16) NOT NULL,
    migration_name character varying(255) NOT NULL,
    migration_ticket character varying(16),
    migration_status character varying(16),
    migration_retry_count bigint DEFAULT 0 NOT NULL,
    migration_progress double precision DEFAULT 0,
    migration_progress_action character varying(255) DEFAULT ''::character varying,
    migration_log text,
    migration_result text,
    migration_project_obj_id bigint NOT NULL,
    migration_environment character varying(16) DEFAULT 'main'::character varying
)
INHERITS (rds.obj_base);


ALTER TABLE rds.hard_migration OWNER TO rds;

--
-- Name: hard_migration_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.hard_migration_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.hard_migration_obj_id_seq OWNER TO rds;

--
-- Name: hard_migration_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.hard_migration_obj_id_seq OWNED BY rds.hard_migration.obj_id;


--
-- Name: log; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.log (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 12,
    log_text text,
    log_user_id bigint
)
INHERITS (rds.obj_base);


ALTER TABLE rds.log OWNER TO rds;

--
-- Name: log_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.log_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.log_obj_id_seq OWNER TO rds;

--
-- Name: log_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.log_obj_id_seq OWNED BY rds.log.obj_id;


--
-- Name: migration; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.migration (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 5,
    migration_name character varying NOT NULL,
    migration_type smallint NOT NULL,
    migration_project_obj_id bigint NOT NULL,
    migration_release_request_obj_id bigint NOT NULL,
    migration_ticket character varying(16),
    migration_log text,
    migration_auto_apply boolean DEFAULT true
)
INHERITS (rds.obj_base);


ALTER TABLE rds.migration OWNER TO rds;

--
-- Name: COLUMN migration.obj_status_did; Type: COMMENT; Schema: rds; Owner: rds
--

COMMENT ON COLUMN rds.migration.obj_status_did IS 'ag: @see \\whotrades\\rds\\models\\Migration::STATUS_*';


--
-- Name: COLUMN migration.migration_type; Type: COMMENT; Schema: rds; Owner: rds
--

COMMENT ON COLUMN rds.migration.migration_type IS 'ag: @see \\whotrades\\rds\\models\\Migration::TYPE_*';


--
-- Name: migration_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.migration_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.migration_obj_id_seq OWNER TO rds;

--
-- Name: migration_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.migration_obj_id_seq OWNED BY rds.migration.obj_id;


--
-- Name: migration_rds; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.migration_rds (
    version character varying(180) NOT NULL,
    apply_time integer
);


ALTER TABLE rds.migration_rds OWNER TO rds;

--
-- Name: post_migration; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.post_migration (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    pm_name character varying NOT NULL,
    pm_status smallint DEFAULT 5 NOT NULL,
    pm_project_obj_id bigint NOT NULL,
    pm_release_request_obj_id bigint NOT NULL,
    pm_log text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.post_migration OWNER TO rds;

--
-- Name: COLUMN post_migration.pm_status; Type: COMMENT; Schema: rds; Owner: rds
--

COMMENT ON COLUMN rds.post_migration.pm_status IS 'ag: @see \\whotrades\\rds\\models\\PostMigration::STATUS_*';


--
-- Name: post_migration_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.post_migration_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.post_migration_obj_id_seq OWNER TO rds;

--
-- Name: post_migration_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.post_migration_obj_id_seq OWNED BY rds.post_migration.obj_id;


--
-- Name: profile; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.profile (
    user_id integer NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    public_email character varying(255) DEFAULT NULL::character varying,
    gravatar_email character varying(255) DEFAULT NULL::character varying,
    gravatar_id character varying(32) DEFAULT NULL::character varying,
    location character varying(255) DEFAULT NULL::character varying,
    website character varying(255) DEFAULT NULL::character varying,
    bio text,
    timezone character varying(40) DEFAULT NULL::character varying
);


ALTER TABLE rds.profile OWNER TO rds;

--
-- Name: project; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.project (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    project_name character varying NOT NULL,
    project_build_version bigint DEFAULT 1 NOT NULL,
    project_build_subversion text NOT NULL,
    project_current_version character varying(64),
    project_notification_email character varying(64),
    project_notification_subject character varying(64),
    script_migration_up text,
    script_migration_new text,
    script_config_local text,
    project_servers text,
    script_remove_release text,
    script_cron text,
    script_deploy text,
    script_build text,
    script_use text,
    script_post_deploy text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.project OWNER TO rds;

--
-- Name: project2project; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.project2project (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    parent_project_obj_id bigint NOT NULL,
    child_project_obj_id bigint NOT NULL
)
INHERITS (rds.obj_base);


ALTER TABLE rds.project2project OWNER TO rds;

--
-- Name: project2project_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.project2project_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.project2project_obj_id_seq OWNER TO rds;

--
-- Name: project2project_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.project2project_obj_id_seq OWNED BY rds.project2project.obj_id;


--
-- Name: project2worker; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.project2worker (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    worker_obj_id bigint NOT NULL,
    project_obj_id bigint NOT NULL,
    p2w_current_version character varying(64)
)
INHERITS (rds.obj_base);


ALTER TABLE rds.project2worker OWNER TO rds;

--
-- Name: project2worker_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.project2worker_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.project2worker_obj_id_seq OWNER TO rds;

--
-- Name: project2worker_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.project2worker_obj_id_seq OWNED BY rds.project2worker.obj_id;


--
-- Name: project_config; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.project_config (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    pc_project_obj_id bigint NOT NULL,
    pc_filename character varying(128) NOT NULL,
    pc_content text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.project_config OWNER TO rds;

--
-- Name: project_config_history; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.project_config_history (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    pch_project_obj_id bigint NOT NULL,
    pch_config text,
    pch_filename character varying(128) DEFAULT 'config.local.php'::character varying NOT NULL,
    pch_user_id bigint NOT NULL,
    pch_log text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.project_config_history OWNER TO rds;

--
-- Name: project_config_history_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.project_config_history_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.project_config_history_obj_id_seq OWNER TO rds;

--
-- Name: project_config_history_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.project_config_history_obj_id_seq OWNED BY rds.project_config_history.obj_id;


--
-- Name: project_config_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.project_config_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.project_config_obj_id_seq OWNER TO rds;

--
-- Name: project_config_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.project_config_obj_id_seq OWNED BY rds.project_config.obj_id;


--
-- Name: project_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.project_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.project_obj_id_seq OWNER TO rds;

--
-- Name: project_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.project_obj_id_seq OWNED BY rds.project.obj_id;


--
-- Name: rds_db_config; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.rds_db_config (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    red_lamp_wts_timeout timestamp(6) with time zone,
    preprod_online boolean DEFAULT true NOT NULL,
    cpu_usage_last_truncate timestamp(6) with time zone,
    is_tst_updating_enabled smallint DEFAULT 1,
    red_lamp_team_city_timeout timestamp(6) with time zone,
    red_lamp_wts_dev_timeout timestamp(6) with time zone,
    crm_lamp_timeout timestamp(6) with time zone,
    deployment_enabled boolean DEFAULT true,
    deployment_enabled_reason text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.rds_db_config OWNER TO rds;

--
-- Name: rds_db_config_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.rds_db_config_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.rds_db_config_obj_id_seq OWNER TO rds;

--
-- Name: rds_db_config_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.rds_db_config_obj_id_seq OWNED BY rds.rds_db_config.obj_id;


--
-- Name: release_reject; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.release_reject (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    rr_comment character varying NOT NULL,
    rr_project_obj_id bigint NOT NULL,
    rr_release_version bigint,
    rr_user_id bigint NOT NULL
)
INHERITS (rds.obj_base);


ALTER TABLE rds.release_reject OWNER TO rds;

--
-- Name: release_reject_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.release_reject_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.release_reject_obj_id_seq OWNER TO rds;

--
-- Name: release_reject_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.release_reject_obj_id_seq OWNED BY rds.release_reject.obj_id;


--
-- Name: release_request; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.release_request (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    rr_comment character varying NOT NULL,
    rr_project_obj_id bigint NOT NULL,
    rr_build_version character varying,
    rr_project_owner_code character varying,
    rr_release_engineer_code character varying,
    rr_project_owner_code_entered boolean DEFAULT false,
    rr_release_engineer_code_entered boolean DEFAULT false,
    rr_status character varying DEFAULT 'new'::character varying,
    rr_old_version character varying,
    rr_use_text text,
    rr_last_time_on_prod timestamp(6) with time zone,
    rr_revert_after_time timestamp(6) with time zone,
    rr_release_version bigint,
    rr_new_migration_count bigint DEFAULT 0,
    rr_migration_status character varying DEFAULT 'none'::character varying,
    rr_new_migrations text,
    rr_built_time timestamp(6) with time zone,
    rr_cron_config text,
    rr_migration_error text,
    rr_leading_id bigint,
    rr_build_started timestamp(6) with time zone,
    rr_user_id bigint NOT NULL,
    rr_last_error_text text
)
INHERITS (rds.obj_base);


ALTER TABLE rds.release_request OWNER TO rds;

--
-- Name: release_request_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.release_request_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.release_request_obj_id_seq OWNER TO rds;

--
-- Name: release_request_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.release_request_obj_id_seq OWNED BY rds.release_request.obj_id;


--
-- Name: release_version; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.release_version (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    rv_version character varying NOT NULL,
    rv_name character varying NOT NULL
)
INHERITS (rds.obj_base);


ALTER TABLE rds.release_version OWNER TO rds;

--
-- Name: release_version_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.release_version_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.release_version_obj_id_seq OWNER TO rds;

--
-- Name: release_version_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.release_version_obj_id_seq OWNED BY rds.release_version.obj_id;


--
-- Name: session; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.session (
    id character(128) NOT NULL,
    expire bigint,
    data bytea
);


ALTER TABLE rds.session OWNER TO rds;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.user_id_seq OWNER TO rds;

--
-- Name: user; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds."user" (
    id integer DEFAULT nextval('rds.user_id_seq'::regclass) NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(60) NOT NULL,
    auth_key character varying(32) NOT NULL,
    confirmed_at integer,
    unconfirmed_email character varying(255) DEFAULT NULL::character varying,
    blocked_at integer,
    registration_ip character varying(45),
    created_at integer NOT NULL,
    updated_at integer NOT NULL,
    flags integer DEFAULT 0 NOT NULL,
    last_login_at integer,
    phone character varying(64) DEFAULT NULL::character varying
);


ALTER TABLE rds."user" OWNER TO rds;

--
-- Name: user_rbac_assignment; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.user_rbac_assignment (
    item_name character varying(64) NOT NULL,
    user_id character varying(64) NOT NULL,
    created_at integer
);


ALTER TABLE rds.user_rbac_assignment OWNER TO rds;

--
-- Name: user_rbac_item; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.user_rbac_item (
    name character varying(64) NOT NULL,
    type smallint NOT NULL,
    description text,
    rule_name character varying(64),
    data bytea,
    created_at integer,
    updated_at integer
);


ALTER TABLE rds.user_rbac_item OWNER TO rds;

--
-- Name: user_rbac_item_child; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.user_rbac_item_child (
    parent character varying(64) NOT NULL,
    child character varying(64) NOT NULL
);


ALTER TABLE rds.user_rbac_item_child OWNER TO rds;

--
-- Name: user_rbac_rule; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.user_rbac_rule (
    name character varying(64) NOT NULL,
    data bytea,
    created_at integer,
    updated_at integer
);


ALTER TABLE rds.user_rbac_rule OWNER TO rds;

--
-- Name: worker; Type: TABLE; Schema: rds; Owner: rds
--

CREATE TABLE rds.worker (
    obj_id bigint,
    obj_created timestamp(6) with time zone DEFAULT now(),
    obj_modified timestamp(6) with time zone DEFAULT now(),
    obj_status_did smallint DEFAULT 1,
    worker_name character varying NOT NULL
)
INHERITS (rds.obj_base);


ALTER TABLE rds.worker OWNER TO rds;

--
-- Name: worker_obj_id_seq; Type: SEQUENCE; Schema: rds; Owner: rds
--

CREATE SEQUENCE rds.worker_obj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rds.worker_obj_id_seq OWNER TO rds;

--
-- Name: worker_obj_id_seq; Type: SEQUENCE OWNED BY; Schema: rds; Owner: rds
--

ALTER SEQUENCE rds.worker_obj_id_seq OWNED BY rds.worker.obj_id;


--
-- Name: build obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.build ALTER COLUMN obj_id SET DEFAULT nextval('rds.build_obj_id_seq'::regclass);


--
-- Name: hard_migration obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration ALTER COLUMN obj_id SET DEFAULT nextval('rds.hard_migration_obj_id_seq'::regclass);


--
-- Name: hard_migration obj_created; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration ALTER COLUMN obj_created SET DEFAULT now();


--
-- Name: hard_migration obj_modified; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration ALTER COLUMN obj_modified SET DEFAULT now();


--
-- Name: hard_migration obj_status_did; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration ALTER COLUMN obj_status_did SET DEFAULT 1;


--
-- Name: log obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.log ALTER COLUMN obj_id SET DEFAULT nextval('rds.log_obj_id_seq'::regclass);


--
-- Name: migration obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.migration ALTER COLUMN obj_id SET DEFAULT nextval('rds.migration_obj_id_seq'::regclass);


--
-- Name: post_migration obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.post_migration ALTER COLUMN obj_id SET DEFAULT nextval('rds.post_migration_obj_id_seq'::regclass);


--
-- Name: project obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project ALTER COLUMN obj_id SET DEFAULT nextval('rds.project_obj_id_seq'::regclass);


--
-- Name: project2project obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2project ALTER COLUMN obj_id SET DEFAULT nextval('rds.project2project_obj_id_seq'::regclass);


--
-- Name: project2worker obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2worker ALTER COLUMN obj_id SET DEFAULT nextval('rds.project2worker_obj_id_seq'::regclass);


--
-- Name: project_config obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config ALTER COLUMN obj_id SET DEFAULT nextval('rds.project_config_obj_id_seq'::regclass);


--
-- Name: project_config_history obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config_history ALTER COLUMN obj_id SET DEFAULT nextval('rds.project_config_history_obj_id_seq'::regclass);


--
-- Name: rds_db_config obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.rds_db_config ALTER COLUMN obj_id SET DEFAULT nextval('rds.rds_db_config_obj_id_seq'::regclass);


--
-- Name: release_reject obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_reject ALTER COLUMN obj_id SET DEFAULT nextval('rds.release_reject_obj_id_seq'::regclass);


--
-- Name: release_request obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_request ALTER COLUMN obj_id SET DEFAULT nextval('rds.release_request_obj_id_seq'::regclass);


--
-- Name: release_version obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_version ALTER COLUMN obj_id SET DEFAULT nextval('rds.release_version_obj_id_seq'::regclass);


--
-- Name: worker obj_id; Type: DEFAULT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.worker ALTER COLUMN obj_id SET DEFAULT nextval('rds.worker_obj_id_seq'::regclass);


--
-- Data for Name: build; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.build (obj_id, obj_created, obj_modified, obj_status_did, build_release_request_obj_id, build_worker_obj_id, build_project_obj_id, build_status, build_attach, build_version, build_time_log) FROM stdin;
\.


--
-- Data for Name: hard_migration; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.hard_migration (obj_id, obj_created, obj_modified, obj_status_did, migration_release_request_obj_id, migration_pid, migration_type, migration_name, migration_ticket, migration_status, migration_retry_count, migration_progress, migration_progress_action, migration_log, migration_result, migration_project_obj_id, migration_environment) FROM stdin;
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.log (obj_id, obj_created, obj_modified, obj_status_did, log_text, log_user_id) FROM stdin;
\.


--
-- Data for Name: migration; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.migration (obj_id, obj_created, obj_modified, obj_status_did, migration_name, migration_type, migration_project_obj_id, migration_release_request_obj_id, migration_ticket, migration_log, migration_auto_apply) FROM stdin;
\.


--
-- Data for Name: migration_rds; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.migration_rds (version, apply_time) FROM stdin;
m000000_000000_base	1606989493
m170821_080924_drop_jira_create_version_table_and_queue	1606989732
m170829_115309_add_column_project_script_migration_remove	1606989833
m170908_130001_project_scripts_cron_deploy	1606989894
m170921_143132_project_script_build	1606989938
m171003_124859_fix_destroyed_status	1606989944
m171024_070101_project_script_use	1606990010
m171031_114929_hstore_to_json	1606990068
m180821_121728_add_post_migrations_table	1606990361
m180822_121725_test_migration	1606990388
m180822_121728_fill_post_migrations_table	1606990397
m180927_073202_alter_table_rds_project_config_history	1606990712
m181211_175506_rbac_init	1606991029
m190725_123202_alter_table_rds_release_request	1606991163
m191021_133202_alter_table_rds_hard_migrations	1606995330
m191021_133203_alter_table_rds_post_migrations	1606995336
m200212_033452_add_column_project_script_post_deploy	1606995387
m200402_170636_alter_table_release_request_drop_columns	1606995603
m200402_171742_add_table_migration	1606995755
m200402_181135_fill_migrations_table	1606995917
m200420_142217_alter_table_rds_migration_add_disable_auto_application	1606995972
\.


--
-- Data for Name: obj_base; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.obj_base (obj_id, obj_created, obj_modified, obj_status_did) FROM stdin;
\.


--
-- Data for Name: post_migration; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.post_migration (obj_id, obj_created, obj_modified, obj_status_did, pm_name, pm_status, pm_project_obj_id, pm_release_request_obj_id, pm_log) FROM stdin;
\.


--
-- Data for Name: profile; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.profile (user_id, name, public_email, gravatar_email, gravatar_id, location, website, bio, timezone) FROM stdin;
1	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.project (obj_id, obj_created, obj_modified, obj_status_did, project_name, project_build_version, project_build_subversion, project_current_version, project_notification_email, project_notification_subject, script_migration_up, script_migration_new, script_config_local, project_servers, script_remove_release, script_cron, script_deploy, script_build, script_use, script_post_deploy) FROM stdin;
1	2017-11-23 12:08:01.236368+00	2017-11-23 12:08:01.236368+00	1	test_project	6	{"1":5}	\N			#!/bin/bash -e\r\n\r\nsleep 1\r\n	#!/bin/bash -e\r\n\r\n#echo m170908_130001_project_scripts_cron_deploy\r\n	\N	\N	#!/bin/bash -e\r\n\r\nsleep 0.1	\N	#!/bin/bash -e\r\n\r\nsleep 0.1\r\n	#!/bin/bash -e\r\n\r\nsleep 3\r\n	#!/bin/bash -e\r\n\r\nsleep 0.1\r\n	\N
\.


--
-- Data for Name: project2project; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.project2project (obj_id, obj_created, obj_modified, obj_status_did, parent_project_obj_id, child_project_obj_id) FROM stdin;
\.


--
-- Data for Name: project2worker; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.project2worker (obj_id, obj_created, obj_modified, obj_status_did, worker_obj_id, project_obj_id, p2w_current_version) FROM stdin;
1	2017-11-23 12:08:01.245921+00	2017-11-23 12:08:01.245921+00	1	1	1	\N
\.


--
-- Data for Name: project_config; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.project_config (obj_id, obj_created, obj_modified, obj_status_did, pc_project_obj_id, pc_filename, pc_content) FROM stdin;
\.


--
-- Data for Name: project_config_history; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.project_config_history (obj_id, obj_created, obj_modified, obj_status_did, pch_project_obj_id, pch_config, pch_filename, pch_user_id, pch_log) FROM stdin;
\.


--
-- Data for Name: rds_db_config; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.rds_db_config (obj_id, obj_created, obj_modified, obj_status_did, red_lamp_wts_timeout, preprod_online, cpu_usage_last_truncate, is_tst_updating_enabled, red_lamp_team_city_timeout, red_lamp_wts_dev_timeout, crm_lamp_timeout, deployment_enabled, deployment_enabled_reason) FROM stdin;
1	2020-12-03 09:30:03.048042+00	2020-12-03 09:30:03.048042+00	1	2016-09-22 15:54:28+00	t	2017-06-26 13:48:45+00	1	2016-09-22 15:54:34+00	2016-09-22 15:54:36+00	2016-09-22 15:54:29+00	t	\N
\.


--
-- Data for Name: release_reject; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.release_reject (obj_id, obj_created, obj_modified, obj_status_did, rr_comment, rr_project_obj_id, rr_release_version, rr_user_id) FROM stdin;
\.


--
-- Data for Name: release_request; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.release_request (obj_id, obj_created, obj_modified, obj_status_did, rr_comment, rr_project_obj_id, rr_build_version, rr_project_owner_code, rr_release_engineer_code, rr_project_owner_code_entered, rr_release_engineer_code_entered, rr_status, rr_old_version, rr_use_text, rr_last_time_on_prod, rr_revert_after_time, rr_release_version, rr_new_migration_count, rr_migration_status, rr_new_migrations, rr_built_time, rr_cron_config, rr_migration_error, rr_leading_id, rr_build_started, rr_user_id, rr_last_error_text) FROM stdin;
\.


--
-- Data for Name: release_version; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.release_version (obj_id, obj_created, obj_modified, obj_status_did, rv_version, rv_name) FROM stdin;
1	2017-11-23 12:08:09.051372+00	2017-11-23 12:08:09.051372+00	1	1	First
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.session (id, expire, data) FROM stdin;
b59b9774bab9f237f52eaeb735f315ea                                                                                                	1607039201	\\x613a323a7b693a303b733a37393a225f5f666c6173687c613a303a7b7d5f5f72657475726e55726c7c733a313a222f223b5f5f69647c693a313b616374696f6e732d72656469726563747c733a31313a222f757365722f61646d696e223b223b693a313b4e3b7d
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds."user" (id, username, email, password_hash, auth_key, confirmed_at, unconfirmed_email, blocked_at, registration_ip, created_at, updated_at, flags, last_login_at, phone) FROM stdin;
1	rds	rds@whotrades.org	$2y$10$lt0EyF3ncaolvd2zH7dpLevLf6Y2D1wOxNQmBZaW2U4l0rAWzp9g.	sowjrEIgzpBNcuX7pkvkm7-Et2g2aK_X	1510211975	\N	\N	\N	1510211975	1510211975	0	1606989363	\N
\.


--
-- Data for Name: user_rbac_assignment; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.user_rbac_assignment (item_name, user_id, created_at) FROM stdin;
developer	1	1606991029
\.


--
-- Data for Name: user_rbac_item; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.user_rbac_item (name, type, description, rule_name, data, created_at, updated_at) FROM stdin;
admin	1	\N	\N	\N	1606991029	1606991029
developer	1	\N	\N	\N	1606991029	1606991029
\.


--
-- Data for Name: user_rbac_item_child; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.user_rbac_item_child (parent, child) FROM stdin;
admin	developer
\.


--
-- Data for Name: user_rbac_rule; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.user_rbac_rule (name, data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: worker; Type: TABLE DATA; Schema: rds; Owner: rds
--

COPY rds.worker (obj_id, obj_created, obj_modified, obj_status_did, worker_name) FROM stdin;
1	2017-11-23 12:07:47.205588+00	2017-11-23 12:07:47.205588+00	1	test_worker
\.


--
-- Name: build_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.build_obj_id_seq', 1, false);


--
-- Name: hard_migration_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.hard_migration_obj_id_seq', 1, false);


--
-- Name: log_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.log_obj_id_seq', 1, false);


--
-- Name: migration_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.migration_obj_id_seq', 1, false);


--
-- Name: post_migration_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.post_migration_obj_id_seq', 1, false);


--
-- Name: project2project_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.project2project_obj_id_seq', 1, false);


--
-- Name: project2worker_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.project2worker_obj_id_seq', 1, false);


--
-- Name: project_config_history_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.project_config_history_obj_id_seq', 1, false);


--
-- Name: project_config_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.project_config_obj_id_seq', 1, false);


--
-- Name: project_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.project_obj_id_seq', 1, false);


--
-- Name: rds_db_config_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.rds_db_config_obj_id_seq', 1, false);


--
-- Name: release_reject_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.release_reject_obj_id_seq', 1, false);


--
-- Name: release_request_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.release_request_obj_id_seq', 1, false);


--
-- Name: release_version_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.release_version_obj_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.user_id_seq', 1, false);


--
-- Name: worker_obj_id_seq; Type: SEQUENCE SET; Schema: rds; Owner: rds
--

SELECT pg_catalog.setval('rds.worker_obj_id_seq', 1, false);


--
-- Name: build build_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.build
    ADD CONSTRAINT build_pkey PRIMARY KEY (obj_id);


--
-- Name: log log_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (obj_id);


--
-- Name: migration migration_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.migration
    ADD CONSTRAINT migration_pkey PRIMARY KEY (obj_id);


--
-- Name: migration_rds migration_rds_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.migration_rds
    ADD CONSTRAINT migration_rds_pkey PRIMARY KEY (version);


--
-- Name: obj_base obj_base_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.obj_base
    ADD CONSTRAINT obj_base_pkey PRIMARY KEY (obj_id);


--
-- Name: post_migration post_migration_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.post_migration
    ADD CONSTRAINT post_migration_pkey PRIMARY KEY (obj_id);


--
-- Name: project2project project2project_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2project
    ADD CONSTRAINT project2project_pkey PRIMARY KEY (obj_id);


--
-- Name: project2worker project2worker_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2worker
    ADD CONSTRAINT project2worker_pkey PRIMARY KEY (obj_id);


--
-- Name: project_config_history project_config_history_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config_history
    ADD CONSTRAINT project_config_history_pkey PRIMARY KEY (obj_id);


--
-- Name: project_config project_config_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config
    ADD CONSTRAINT project_config_pkey PRIMARY KEY (obj_id);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (obj_id);


--
-- Name: rds_db_config rds_db_config_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.rds_db_config
    ADD CONSTRAINT rds_db_config_pkey PRIMARY KEY (obj_id);


--
-- Name: hard_migration rds_hard_migration_obj_id; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration
    ADD CONSTRAINT rds_hard_migration_obj_id PRIMARY KEY (obj_id);


--
-- Name: release_reject release_reject_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_reject
    ADD CONSTRAINT release_reject_pkey PRIMARY KEY (obj_id);


--
-- Name: release_request release_request_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_request
    ADD CONSTRAINT release_request_pkey PRIMARY KEY (obj_id);


--
-- Name: release_request release_request_rr_project_obj_id_rr_build_version_key; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_request
    ADD CONSTRAINT release_request_rr_project_obj_id_rr_build_version_key UNIQUE (rr_project_obj_id, rr_build_version);


--
-- Name: release_version release_version_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_version
    ADD CONSTRAINT release_version_pkey PRIMARY KEY (obj_id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_rbac_assignment user_rbac_assignment_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_assignment
    ADD CONSTRAINT user_rbac_assignment_pkey PRIMARY KEY (item_name, user_id);


--
-- Name: user_rbac_item_child user_rbac_item_child_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_item_child
    ADD CONSTRAINT user_rbac_item_child_pkey PRIMARY KEY (parent, child);


--
-- Name: user_rbac_item user_rbac_item_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_item
    ADD CONSTRAINT user_rbac_item_pkey PRIMARY KEY (name);


--
-- Name: user_rbac_rule user_rbac_rule_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_rule
    ADD CONSTRAINT user_rbac_rule_pkey PRIMARY KEY (name);


--
-- Name: worker worker_pkey; Type: CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.worker
    ADD CONSTRAINT worker_pkey PRIMARY KEY (obj_id);


--
-- Name: auth_assignment_user_id_idx; Type: INDEX; Schema: rds; Owner: rds
--

CREATE INDEX auth_assignment_user_id_idx ON rds.user_rbac_assignment USING btree (user_id);


--
-- Name: idx-auth_item-type; Type: INDEX; Schema: rds; Owner: rds
--

CREATE INDEX "idx-auth_item-type" ON rds.user_rbac_item USING btree (type);


--
-- Name: rds_hard_migration_name; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX rds_hard_migration_name ON rds.hard_migration USING btree (migration_name, migration_environment);


--
-- Name: rds_project2project_unique_parent_child; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX rds_project2project_unique_parent_child ON rds.project2project USING btree (parent_project_obj_id, child_project_obj_id);


--
-- Name: rds_project_config_project_id_filename; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX rds_project_config_project_id_filename ON rds.project_config USING btree (pc_project_obj_id, pc_filename);


--
-- Name: rds_user_unique_email; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX rds_user_unique_email ON rds."user" USING btree (email);


--
-- Name: rds_user_unique_username; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX rds_user_unique_username ON rds."user" USING btree (username);


--
-- Name: u_migration_name_and_project; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX u_migration_name_and_project ON rds.migration USING btree (migration_name, migration_project_obj_id);


--
-- Name: u_pm_name_and_project; Type: INDEX; Schema: rds; Owner: rds
--

CREATE UNIQUE INDEX u_pm_name_and_project ON rds.post_migration USING btree (pm_name, pm_project_obj_id);


--
-- Name: build build_build_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.build
    ADD CONSTRAINT build_build_project_obj_id_fkey FOREIGN KEY (build_project_obj_id) REFERENCES rds.project(obj_id);


--
-- Name: build build_build_release_request_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.build
    ADD CONSTRAINT build_build_release_request_obj_id_fkey FOREIGN KEY (build_release_request_obj_id) REFERENCES rds.release_request(obj_id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: build build_build_worker_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.build
    ADD CONSTRAINT build_build_worker_obj_id_fkey FOREIGN KEY (build_worker_obj_id) REFERENCES rds.worker(obj_id);


--
-- Name: log log_log_user_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.log
    ADD CONSTRAINT log_log_user_id_fkey FOREIGN KEY (log_user_id) REFERENCES rds."user"(id);


--
-- Name: project2project project2project_child_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2project
    ADD CONSTRAINT project2project_child_project_obj_id_fkey FOREIGN KEY (child_project_obj_id) REFERENCES rds.project(obj_id) ON DELETE CASCADE;


--
-- Name: project2project project2project_parent_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2project
    ADD CONSTRAINT project2project_parent_project_obj_id_fkey FOREIGN KEY (parent_project_obj_id) REFERENCES rds.project(obj_id) ON DELETE CASCADE;


--
-- Name: project2worker project2worker_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2worker
    ADD CONSTRAINT project2worker_project_obj_id_fkey FOREIGN KEY (project_obj_id) REFERENCES rds.project(obj_id) ON DELETE CASCADE;


--
-- Name: project2worker project2worker_worker_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project2worker
    ADD CONSTRAINT project2worker_worker_obj_id_fkey FOREIGN KEY (worker_obj_id) REFERENCES rds.worker(obj_id) ON DELETE CASCADE;


--
-- Name: project_config_history project_config_history_pch_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config_history
    ADD CONSTRAINT project_config_history_pch_project_obj_id_fkey FOREIGN KEY (pch_project_obj_id) REFERENCES rds.project(obj_id) ON DELETE CASCADE;


--
-- Name: project_config_history project_config_history_pch_user_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config_history
    ADD CONSTRAINT project_config_history_pch_user_id_fkey FOREIGN KEY (pch_user_id) REFERENCES rds."user"(id);


--
-- Name: project_config project_config_pc_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config
    ADD CONSTRAINT project_config_pc_project_obj_id_fkey FOREIGN KEY (pc_project_obj_id) REFERENCES rds.project(obj_id);


--
-- Name: hard_migration rds_hard_migration_project_obj_id; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration
    ADD CONSTRAINT rds_hard_migration_project_obj_id FOREIGN KEY (migration_project_obj_id) REFERENCES rds.project(obj_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: migration rds_migration_project_obj_id; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.migration
    ADD CONSTRAINT rds_migration_project_obj_id FOREIGN KEY (migration_project_obj_id) REFERENCES rds.project(obj_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: hard_migration rds_migration_release_request_obj_id; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.hard_migration
    ADD CONSTRAINT rds_migration_release_request_obj_id FOREIGN KEY (migration_release_request_obj_id) REFERENCES rds.release_request(obj_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: post_migration rds_post_migration_project_obj_id; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.post_migration
    ADD CONSTRAINT rds_post_migration_project_obj_id FOREIGN KEY (pm_project_obj_id) REFERENCES rds.project(obj_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: project_config rds_project_config_project_id_foreigs_idx; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.project_config
    ADD CONSTRAINT rds_project_config_project_id_foreigs_idx FOREIGN KEY (pc_project_obj_id) REFERENCES rds.project(obj_id) ON DELETE CASCADE;


--
-- Name: release_reject release_reject_rr_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_reject
    ADD CONSTRAINT release_reject_rr_project_obj_id_fkey FOREIGN KEY (rr_project_obj_id) REFERENCES rds.project(obj_id);


--
-- Name: release_reject release_reject_rr_user_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_reject
    ADD CONSTRAINT release_reject_rr_user_id_fkey FOREIGN KEY (rr_user_id) REFERENCES rds."user"(id);


--
-- Name: release_request release_request_rr_leading_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_request
    ADD CONSTRAINT release_request_rr_leading_id_fkey FOREIGN KEY (rr_leading_id) REFERENCES rds.release_request(obj_id) ON UPDATE SET NULL ON DELETE SET NULL;


--
-- Name: release_request release_request_rr_project_obj_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_request
    ADD CONSTRAINT release_request_rr_project_obj_id_fkey FOREIGN KEY (rr_project_obj_id) REFERENCES rds.project(obj_id) ON DELETE CASCADE;


--
-- Name: release_request release_request_rr_user_id_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.release_request
    ADD CONSTRAINT release_request_rr_user_id_fkey FOREIGN KEY (rr_user_id) REFERENCES rds."user"(id);


--
-- Name: user_rbac_assignment user_rbac_assignment_item_name_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_assignment
    ADD CONSTRAINT user_rbac_assignment_item_name_fkey FOREIGN KEY (item_name) REFERENCES rds.user_rbac_item(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_rbac_item_child user_rbac_item_child_child_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_item_child
    ADD CONSTRAINT user_rbac_item_child_child_fkey FOREIGN KEY (child) REFERENCES rds.user_rbac_item(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_rbac_item_child user_rbac_item_child_parent_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_item_child
    ADD CONSTRAINT user_rbac_item_child_parent_fkey FOREIGN KEY (parent) REFERENCES rds.user_rbac_item(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_rbac_item user_rbac_item_rule_name_fkey; Type: FK CONSTRAINT; Schema: rds; Owner: rds
--

ALTER TABLE ONLY rds.user_rbac_item
    ADD CONSTRAINT user_rbac_item_rule_name_fkey FOREIGN KEY (rule_name) REFERENCES rds.user_rbac_rule(name) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

