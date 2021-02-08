--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1 (Debian 13.1-1.pgdg100+1)
-- Dumped by pg_dump version 13.1 (Debian 13.1-1.pgdg100+1)

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
-- Name: media_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.media_type AS ENUM (
    'UNKNOWN',
    'BITMAP',
    'DRAWING',
    'AUDIO',
    'VIDEO',
    'MULTIMEDIA',
    'OFFICE',
    'TEXT',
    'EXECUTABLE',
    'ARCHIVE',
    '3D'
);


ALTER TYPE public.media_type OWNER TO postgres;

--
-- Name: add_interwiki(text, integer, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_interwiki(text, integer, smallint) RETURNS integer
    LANGUAGE sql
    AS $_$
 INSERT INTO interwiki (iw_prefix, iw_url, iw_local) VALUES ($1,$2,$3);
 SELECT 1;
 $_$;


ALTER FUNCTION public.add_interwiki(text, integer, smallint) OWNER TO postgres;

--
-- Name: page_deleted(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.page_deleted() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 DELETE FROM recentchanges WHERE rc_namespace = OLD.page_namespace AND rc_title = OLD.page_title;
 RETURN NULL;
 END;
 $$;


ALTER FUNCTION public.page_deleted() OWNER TO postgres;

--
-- Name: ts2_page_text(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ts2_page_text() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 IF TG_OP = 'INSERT' THEN
 NEW.textvector = to_tsvector(NEW.old_text);
 ELSIF NEW.old_text != OLD.old_text THEN
 NEW.textvector := to_tsvector(NEW.old_text);
 END IF;
 RETURN NEW;
 END;
 $$;


ALTER FUNCTION public.ts2_page_text() OWNER TO postgres;

--
-- Name: ts2_page_title(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ts2_page_title() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
 BEGIN
 IF TG_OP = 'INSERT' THEN
 NEW.titlevector = to_tsvector(REPLACE(NEW.page_title,'/',' '));
 ELSIF NEW.page_title != OLD.page_title THEN
 NEW.titlevector := to_tsvector(REPLACE(NEW.page_title,'/',' '));
 END IF;
 RETURN NEW;
 END;
 $$;


ALTER FUNCTION public.ts2_page_title() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actor (
    actor_id bigint NOT NULL,
    actor_user integer,
    actor_name text NOT NULL
);


ALTER TABLE public.actor OWNER TO postgres;

--
-- Name: actor_actor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actor_actor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actor_actor_id_seq OWNER TO postgres;

--
-- Name: actor_actor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actor_actor_id_seq OWNED BY public.actor.actor_id;


--
-- Name: archive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.archive (
    ar_id integer NOT NULL,
    ar_namespace smallint NOT NULL,
    ar_title text NOT NULL,
    ar_page_id integer,
    ar_parent_id integer,
    ar_sha1 text DEFAULT ''::text NOT NULL,
    ar_comment_id integer NOT NULL,
    ar_actor integer NOT NULL,
    ar_timestamp timestamp with time zone NOT NULL,
    ar_minor_edit smallint DEFAULT 0 NOT NULL,
    ar_rev_id integer NOT NULL,
    ar_deleted smallint DEFAULT 0 NOT NULL,
    ar_len integer
);


ALTER TABLE public.archive OWNER TO postgres;

--
-- Name: archive_ar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.archive_ar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.archive_ar_id_seq OWNER TO postgres;

--
-- Name: archive_ar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.archive_ar_id_seq OWNED BY public.archive.ar_id;


--
-- Name: bot_passwords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bot_passwords (
    bp_user integer NOT NULL,
    bp_app_id text NOT NULL,
    bp_password text NOT NULL,
    bp_token text NOT NULL,
    bp_restrictions text NOT NULL,
    bp_grants text NOT NULL
);


ALTER TABLE public.bot_passwords OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    cat_id integer NOT NULL,
    cat_title text NOT NULL,
    cat_pages integer DEFAULT 0 NOT NULL,
    cat_subcats integer DEFAULT 0 NOT NULL,
    cat_files integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_cat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_cat_id_seq OWNER TO postgres;

--
-- Name: category_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_cat_id_seq OWNED BY public.category.cat_id;


--
-- Name: categorylinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorylinks (
    cl_from integer NOT NULL,
    cl_to text NOT NULL,
    cl_sortkey text,
    cl_timestamp timestamp with time zone NOT NULL,
    cl_sortkey_prefix text DEFAULT ''::text NOT NULL,
    cl_collation text DEFAULT 0 NOT NULL,
    cl_type text DEFAULT 'page'::text NOT NULL
);


ALTER TABLE public.categorylinks OWNER TO postgres;

--
-- Name: change_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.change_tag (
    ct_id integer NOT NULL,
    ct_rc_id integer,
    ct_log_id integer,
    ct_rev_id integer,
    ct_params text,
    ct_tag_id integer NOT NULL
);


ALTER TABLE public.change_tag OWNER TO postgres;

--
-- Name: change_tag_ct_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.change_tag_ct_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.change_tag_ct_id_seq OWNER TO postgres;

--
-- Name: change_tag_ct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.change_tag_ct_id_seq OWNED BY public.change_tag.ct_id;


--
-- Name: change_tag_def; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.change_tag_def (
    ctd_id integer NOT NULL,
    ctd_name text NOT NULL,
    ctd_user_defined smallint DEFAULT 0 NOT NULL,
    ctd_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.change_tag_def OWNER TO postgres;

--
-- Name: change_tag_def_ctd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.change_tag_def_ctd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.change_tag_def_ctd_id_seq OWNER TO postgres;

--
-- Name: change_tag_def_ctd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.change_tag_def_ctd_id_seq OWNED BY public.change_tag_def.ctd_id;


--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    comment_id integer NOT NULL,
    comment_hash integer NOT NULL,
    comment_text text NOT NULL,
    comment_data text
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comment_comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comment_comment_id_seq OWNER TO postgres;

--
-- Name: comment_comment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comment_comment_id_seq OWNED BY public.comment.comment_id;


--
-- Name: content; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.content (
    content_id integer NOT NULL,
    content_size integer NOT NULL,
    content_sha1 text NOT NULL,
    content_model smallint NOT NULL,
    content_address text NOT NULL
);


ALTER TABLE public.content OWNER TO postgres;

--
-- Name: content_content_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.content_content_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_content_id_seq OWNER TO postgres;

--
-- Name: content_content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.content_content_id_seq OWNED BY public.content.content_id;


--
-- Name: content_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.content_models (
    model_id smallint NOT NULL,
    model_name text NOT NULL
);


ALTER TABLE public.content_models OWNER TO postgres;

--
-- Name: content_models_model_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.content_models_model_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_models_model_id_seq OWNER TO postgres;

--
-- Name: content_models_model_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.content_models_model_id_seq OWNED BY public.content_models.model_id;


--
-- Name: externallinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.externallinks (
    el_id integer NOT NULL,
    el_from integer NOT NULL,
    el_to text NOT NULL,
    el_index text NOT NULL,
    el_index_60 bytea NOT NULL
);


ALTER TABLE public.externallinks OWNER TO postgres;

--
-- Name: externallinks_el_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.externallinks_el_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.externallinks_el_id_seq OWNER TO postgres;

--
-- Name: externallinks_el_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.externallinks_el_id_seq OWNED BY public.externallinks.el_id;


--
-- Name: filearchive; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filearchive (
    fa_id integer NOT NULL,
    fa_name text NOT NULL,
    fa_archive_name text,
    fa_storage_group text,
    fa_storage_key text,
    fa_deleted_user integer,
    fa_deleted_timestamp timestamp with time zone NOT NULL,
    fa_deleted_reason_id integer NOT NULL,
    fa_size integer NOT NULL,
    fa_width integer NOT NULL,
    fa_height integer NOT NULL,
    fa_metadata bytea DEFAULT '\x'::bytea NOT NULL,
    fa_bits smallint,
    fa_media_type text,
    fa_major_mime text DEFAULT 'unknown'::text,
    fa_minor_mime text DEFAULT 'unknown'::text,
    fa_description_id integer NOT NULL,
    fa_actor integer NOT NULL,
    fa_timestamp timestamp with time zone,
    fa_deleted smallint DEFAULT 0 NOT NULL,
    fa_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.filearchive OWNER TO postgres;

--
-- Name: filearchive_fa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.filearchive_fa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.filearchive_fa_id_seq OWNER TO postgres;

--
-- Name: filearchive_fa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.filearchive_fa_id_seq OWNED BY public.filearchive.fa_id;


--
-- Name: image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.image (
    img_name text NOT NULL,
    img_size integer NOT NULL,
    img_width integer NOT NULL,
    img_height integer NOT NULL,
    img_metadata bytea DEFAULT '\x'::bytea NOT NULL,
    img_bits smallint,
    img_media_type text,
    img_major_mime text DEFAULT 'unknown'::text,
    img_minor_mime text DEFAULT 'unknown'::text,
    img_description_id integer NOT NULL,
    img_actor integer NOT NULL,
    img_timestamp timestamp with time zone,
    img_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.image OWNER TO postgres;

--
-- Name: imagelinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagelinks (
    il_from integer NOT NULL,
    il_from_namespace integer DEFAULT 0 NOT NULL,
    il_to text NOT NULL
);


ALTER TABLE public.imagelinks OWNER TO postgres;

--
-- Name: interwiki; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interwiki (
    iw_prefix text NOT NULL,
    iw_url text NOT NULL,
    iw_local smallint NOT NULL,
    iw_trans smallint DEFAULT 0 NOT NULL,
    iw_api text DEFAULT ''::text NOT NULL,
    iw_wikiid text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.interwiki OWNER TO postgres;

--
-- Name: ip_changes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ip_changes (
    ipc_rev_id integer NOT NULL,
    ipc_rev_timestamp timestamp with time zone NOT NULL,
    ipc_hex bytea DEFAULT '\x'::bytea NOT NULL
);


ALTER TABLE public.ip_changes OWNER TO postgres;

--
-- Name: ip_changes_ipc_rev_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ip_changes_ipc_rev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ip_changes_ipc_rev_id_seq OWNER TO postgres;

--
-- Name: ip_changes_ipc_rev_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ip_changes_ipc_rev_id_seq OWNED BY public.ip_changes.ipc_rev_id;


--
-- Name: ipblocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ipblocks (
    ipb_id integer NOT NULL,
    ipb_address text,
    ipb_user integer,
    ipb_by_actor integer NOT NULL,
    ipb_reason_id integer NOT NULL,
    ipb_timestamp timestamp with time zone NOT NULL,
    ipb_auto smallint DEFAULT 0 NOT NULL,
    ipb_anon_only smallint DEFAULT 0 NOT NULL,
    ipb_create_account smallint DEFAULT 1 NOT NULL,
    ipb_enable_autoblock smallint DEFAULT 1 NOT NULL,
    ipb_expiry timestamp with time zone NOT NULL,
    ipb_range_start text,
    ipb_range_end text,
    ipb_deleted smallint DEFAULT 0 NOT NULL,
    ipb_block_email smallint DEFAULT 0 NOT NULL,
    ipb_allow_usertalk smallint DEFAULT 0 NOT NULL,
    ipb_parent_block_id integer,
    ipb_sitewide smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.ipblocks OWNER TO postgres;

--
-- Name: ipblocks_ipb_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ipblocks_ipb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ipblocks_ipb_id_seq OWNER TO postgres;

--
-- Name: ipblocks_ipb_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ipblocks_ipb_id_seq OWNED BY public.ipblocks.ipb_id;


--
-- Name: ipblocks_restrictions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ipblocks_restrictions (
    ir_ipb_id integer NOT NULL,
    ir_type smallint NOT NULL,
    ir_value integer NOT NULL
);


ALTER TABLE public.ipblocks_restrictions OWNER TO postgres;

--
-- Name: iwlinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.iwlinks (
    iwl_from integer DEFAULT 0 NOT NULL,
    iwl_prefix text DEFAULT ''::text NOT NULL,
    iwl_title text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.iwlinks OWNER TO postgres;

--
-- Name: job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job (
    job_id integer NOT NULL,
    job_cmd text NOT NULL,
    job_namespace smallint NOT NULL,
    job_title text NOT NULL,
    job_timestamp timestamp with time zone,
    job_params text NOT NULL,
    job_random integer DEFAULT 0 NOT NULL,
    job_attempts integer DEFAULT 0 NOT NULL,
    job_token text DEFAULT ''::text NOT NULL,
    job_token_timestamp timestamp with time zone,
    job_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.job OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_job_id_seq OWNER TO postgres;

--
-- Name: job_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_job_id_seq OWNED BY public.job.job_id;


--
-- Name: l10n_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.l10n_cache (
    lc_lang text NOT NULL,
    lc_key text NOT NULL,
    lc_value bytea NOT NULL
);


ALTER TABLE public.l10n_cache OWNER TO postgres;

--
-- Name: langlinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.langlinks (
    ll_from integer NOT NULL,
    ll_lang text,
    ll_title text
);


ALTER TABLE public.langlinks OWNER TO postgres;

--
-- Name: log_search; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_search (
    ls_field text NOT NULL,
    ls_value text NOT NULL,
    ls_log_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.log_search OWNER TO postgres;

--
-- Name: logging; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logging (
    log_id integer NOT NULL,
    log_type text NOT NULL,
    log_action text NOT NULL,
    log_timestamp timestamp with time zone NOT NULL,
    log_actor integer NOT NULL,
    log_namespace smallint NOT NULL,
    log_title text NOT NULL,
    log_comment_id integer NOT NULL,
    log_params text,
    log_deleted smallint DEFAULT 0 NOT NULL,
    log_page integer
);


ALTER TABLE public.logging OWNER TO postgres;

--
-- Name: logging_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logging_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logging_log_id_seq OWNER TO postgres;

--
-- Name: logging_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logging_log_id_seq OWNED BY public.logging.log_id;


--
-- Name: module_deps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.module_deps (
    md_module text NOT NULL,
    md_skin text NOT NULL,
    md_deps text NOT NULL
);


ALTER TABLE public.module_deps OWNER TO postgres;

--
-- Name: mwuser; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mwuser (
    user_id integer NOT NULL,
    user_name text NOT NULL,
    user_real_name text,
    user_password text,
    user_newpassword text,
    user_newpass_time timestamp with time zone,
    user_token text,
    user_email text,
    user_email_token text,
    user_email_token_expires timestamp with time zone,
    user_email_authenticated timestamp with time zone,
    user_touched timestamp with time zone,
    user_registration timestamp with time zone,
    user_editcount integer,
    user_password_expires timestamp with time zone
);


ALTER TABLE public.mwuser OWNER TO postgres;

--
-- Name: oathauth_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.oathauth_users_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oathauth_users_id_seq OWNER TO postgres;

--
-- Name: oathauth_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oathauth_users (
    id integer DEFAULT nextval('public.oathauth_users_id_seq'::regclass) NOT NULL,
    module text,
    data bytea
);


ALTER TABLE public.oathauth_users OWNER TO postgres;

--
-- Name: objectcache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objectcache (
    keyname text,
    value bytea DEFAULT '\x'::bytea NOT NULL,
    exptime timestamp with time zone NOT NULL
);


ALTER TABLE public.objectcache OWNER TO postgres;

--
-- Name: oldimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.oldimage (
    oi_name text NOT NULL,
    oi_archive_name text NOT NULL,
    oi_size integer NOT NULL,
    oi_width integer NOT NULL,
    oi_height integer NOT NULL,
    oi_bits smallint,
    oi_description_id integer NOT NULL,
    oi_actor integer NOT NULL,
    oi_timestamp timestamp with time zone,
    oi_metadata bytea DEFAULT '\x'::bytea NOT NULL,
    oi_media_type text,
    oi_major_mime text DEFAULT 'unknown'::text,
    oi_minor_mime text DEFAULT 'unknown'::text,
    oi_deleted smallint DEFAULT 0 NOT NULL,
    oi_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.oldimage OWNER TO postgres;

--
-- Name: page; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page (
    page_id integer NOT NULL,
    page_namespace smallint NOT NULL,
    page_title text NOT NULL,
    page_restrictions text,
    page_is_redirect smallint DEFAULT 0 NOT NULL,
    page_is_new smallint DEFAULT 0 NOT NULL,
    page_random numeric(15,14) DEFAULT random() NOT NULL,
    page_touched timestamp with time zone,
    page_links_updated timestamp with time zone,
    page_latest integer NOT NULL,
    page_len integer NOT NULL,
    page_content_model text,
    page_lang text,
    titlevector tsvector
);


ALTER TABLE public.page OWNER TO postgres;

--
-- Name: page_page_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.page_page_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_page_id_seq OWNER TO postgres;

--
-- Name: page_page_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.page_page_id_seq OWNED BY public.page.page_id;


--
-- Name: page_props; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_props (
    pp_page integer NOT NULL,
    pp_propname text NOT NULL,
    pp_value text NOT NULL,
    pp_sortkey double precision
);


ALTER TABLE public.page_props OWNER TO postgres;

--
-- Name: page_restrictions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_restrictions (
    pr_id integer NOT NULL,
    pr_page integer NOT NULL,
    pr_type text NOT NULL,
    pr_level text NOT NULL,
    pr_cascade smallint NOT NULL,
    pr_user integer,
    pr_expiry timestamp with time zone
);


ALTER TABLE public.page_restrictions OWNER TO postgres;

--
-- Name: page_restrictions_pr_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.page_restrictions_pr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_restrictions_pr_id_seq OWNER TO postgres;

--
-- Name: page_restrictions_pr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.page_restrictions_pr_id_seq OWNED BY public.page_restrictions.pr_id;


--
-- Name: pagecontent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pagecontent (
    old_id integer NOT NULL,
    old_text text,
    old_flags text,
    textvector tsvector
);


ALTER TABLE public.pagecontent OWNER TO postgres;

--
-- Name: pagelinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pagelinks (
    pl_from integer NOT NULL,
    pl_from_namespace integer DEFAULT 0 NOT NULL,
    pl_namespace smallint NOT NULL,
    pl_title text NOT NULL
);


ALTER TABLE public.pagelinks OWNER TO postgres;

--
-- Name: protected_titles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.protected_titles (
    pt_namespace smallint NOT NULL,
    pt_title text NOT NULL,
    pt_user integer,
    pt_reason_id integer NOT NULL,
    pt_timestamp timestamp with time zone NOT NULL,
    pt_expiry timestamp with time zone,
    pt_create_perm text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.protected_titles OWNER TO postgres;

--
-- Name: querycache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.querycache (
    qc_type text NOT NULL,
    qc_value integer NOT NULL,
    qc_namespace smallint NOT NULL,
    qc_title text NOT NULL
);


ALTER TABLE public.querycache OWNER TO postgres;

--
-- Name: querycache_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.querycache_info (
    qci_type text,
    qci_timestamp timestamp with time zone
);


ALTER TABLE public.querycache_info OWNER TO postgres;

--
-- Name: querycachetwo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.querycachetwo (
    qcc_type text NOT NULL,
    qcc_value integer DEFAULT 0 NOT NULL,
    qcc_namespace integer DEFAULT 0 NOT NULL,
    qcc_title text DEFAULT ''::text NOT NULL,
    qcc_namespacetwo integer DEFAULT 0 NOT NULL,
    qcc_titletwo text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.querycachetwo OWNER TO postgres;

--
-- Name: recentchanges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recentchanges (
    rc_id integer NOT NULL,
    rc_timestamp timestamp with time zone NOT NULL,
    rc_actor integer NOT NULL,
    rc_namespace smallint NOT NULL,
    rc_title text NOT NULL,
    rc_comment_id integer NOT NULL,
    rc_minor smallint DEFAULT 0 NOT NULL,
    rc_bot smallint DEFAULT 0 NOT NULL,
    rc_new smallint DEFAULT 0 NOT NULL,
    rc_cur_id integer,
    rc_this_oldid integer NOT NULL,
    rc_last_oldid integer NOT NULL,
    rc_type smallint DEFAULT 0 NOT NULL,
    rc_source text NOT NULL,
    rc_patrolled smallint DEFAULT 0 NOT NULL,
    rc_ip cidr,
    rc_old_len integer,
    rc_new_len integer,
    rc_deleted smallint DEFAULT 0 NOT NULL,
    rc_logid integer DEFAULT 0 NOT NULL,
    rc_log_type text,
    rc_log_action text,
    rc_params text
);


ALTER TABLE public.recentchanges OWNER TO postgres;

--
-- Name: recentchanges_rc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recentchanges_rc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recentchanges_rc_id_seq OWNER TO postgres;

--
-- Name: recentchanges_rc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recentchanges_rc_id_seq OWNED BY public.recentchanges.rc_id;


--
-- Name: redirect; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.redirect (
    rd_from integer NOT NULL,
    rd_namespace smallint NOT NULL,
    rd_title text NOT NULL,
    rd_interwiki text,
    rd_fragment text
);


ALTER TABLE public.redirect OWNER TO postgres;

--
-- Name: revision; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision (
    rev_id integer NOT NULL,
    rev_page integer,
    rev_comment_id integer DEFAULT 0 NOT NULL,
    rev_actor integer DEFAULT 0 NOT NULL,
    rev_timestamp timestamp with time zone NOT NULL,
    rev_minor_edit smallint DEFAULT 0 NOT NULL,
    rev_deleted smallint DEFAULT 0 NOT NULL,
    rev_len integer,
    rev_parent_id integer,
    rev_sha1 text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.revision OWNER TO postgres;

--
-- Name: revision_actor_temp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision_actor_temp (
    revactor_rev integer NOT NULL,
    revactor_actor integer NOT NULL,
    revactor_timestamp timestamp with time zone NOT NULL,
    revactor_page integer
);


ALTER TABLE public.revision_actor_temp OWNER TO postgres;

--
-- Name: revision_comment_temp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.revision_comment_temp (
    revcomment_rev integer NOT NULL,
    revcomment_comment_id integer NOT NULL
);


ALTER TABLE public.revision_comment_temp OWNER TO postgres;

--
-- Name: revision_rev_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.revision_rev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revision_rev_id_seq OWNER TO postgres;

--
-- Name: revision_rev_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.revision_rev_id_seq OWNED BY public.revision.rev_id;


--
-- Name: site_identifiers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_identifiers (
    si_type text NOT NULL,
    si_key text NOT NULL,
    si_site integer NOT NULL
);


ALTER TABLE public.site_identifiers OWNER TO postgres;

--
-- Name: site_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.site_stats (
    ss_row_id integer DEFAULT 0 NOT NULL,
    ss_total_edits integer,
    ss_good_articles integer,
    ss_total_pages integer,
    ss_users integer,
    ss_active_users integer,
    ss_images integer
);


ALTER TABLE public.site_stats OWNER TO postgres;

--
-- Name: sites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sites (
    site_id integer NOT NULL,
    site_global_key text NOT NULL,
    site_type text NOT NULL,
    site_group text NOT NULL,
    site_source text NOT NULL,
    site_language text NOT NULL,
    site_protocol text NOT NULL,
    site_domain text NOT NULL,
    site_data text NOT NULL,
    site_forward smallint NOT NULL,
    site_config text NOT NULL
);


ALTER TABLE public.sites OWNER TO postgres;

--
-- Name: sites_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sites_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sites_site_id_seq OWNER TO postgres;

--
-- Name: sites_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sites_site_id_seq OWNED BY public.sites.site_id;


--
-- Name: slot_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.slot_roles (
    role_id smallint NOT NULL,
    role_name text NOT NULL
);


ALTER TABLE public.slot_roles OWNER TO postgres;

--
-- Name: slot_roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.slot_roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.slot_roles_role_id_seq OWNER TO postgres;

--
-- Name: slot_roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.slot_roles_role_id_seq OWNED BY public.slot_roles.role_id;


--
-- Name: slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.slots (
    slot_revision_id integer NOT NULL,
    slot_role_id smallint NOT NULL,
    slot_content_id integer NOT NULL,
    slot_origin integer NOT NULL
);


ALTER TABLE public.slots OWNER TO postgres;

--
-- Name: templatelinks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.templatelinks (
    tl_from integer NOT NULL,
    tl_from_namespace integer DEFAULT 0 NOT NULL,
    tl_namespace smallint NOT NULL,
    tl_title text NOT NULL
);


ALTER TABLE public.templatelinks OWNER TO postgres;

--
-- Name: text_old_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.text_old_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.text_old_id_seq OWNER TO postgres;

--
-- Name: text_old_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.text_old_id_seq OWNED BY public.pagecontent.old_id;


--
-- Name: updatelog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.updatelog (
    ul_key character varying(255) NOT NULL,
    ul_value text
);


ALTER TABLE public.updatelog OWNER TO postgres;

--
-- Name: uploadstash; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uploadstash (
    us_id integer NOT NULL,
    us_user integer,
    us_key text,
    us_orig_path text,
    us_path text,
    us_props bytea,
    us_source_type text,
    us_timestamp timestamp with time zone,
    us_status text,
    us_chunk_inx integer,
    us_size integer,
    us_sha1 text,
    us_mime text,
    us_media_type public.media_type,
    us_image_width integer,
    us_image_height integer,
    us_image_bits smallint
);


ALTER TABLE public.uploadstash OWNER TO postgres;

--
-- Name: uploadstash_us_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uploadstash_us_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uploadstash_us_id_seq OWNER TO postgres;

--
-- Name: uploadstash_us_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uploadstash_us_id_seq OWNED BY public.uploadstash.us_id;


--
-- Name: user_former_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_former_groups (
    ufg_user integer DEFAULT 0 NOT NULL,
    ufg_group text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.user_former_groups OWNER TO postgres;

--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_groups (
    ug_user integer NOT NULL,
    ug_group text NOT NULL,
    ug_expiry timestamp with time zone
);


ALTER TABLE public.user_groups OWNER TO postgres;

--
-- Name: user_newtalk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_newtalk (
    user_id integer DEFAULT 0 NOT NULL,
    user_ip text DEFAULT ''::text NOT NULL,
    user_last_timestamp timestamp with time zone
);


ALTER TABLE public.user_newtalk OWNER TO postgres;

--
-- Name: user_properties; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_properties (
    up_user integer,
    up_property text NOT NULL,
    up_value text
);


ALTER TABLE public.user_properties OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_id_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_user_id_seq OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public.mwuser.user_id;


--
-- Name: watchlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watchlist (
    wl_id integer NOT NULL,
    wl_user integer NOT NULL,
    wl_namespace smallint DEFAULT 0 NOT NULL,
    wl_title text NOT NULL,
    wl_notificationtimestamp timestamp with time zone
);


ALTER TABLE public.watchlist OWNER TO postgres;

--
-- Name: watchlist_expiry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.watchlist_expiry (
    we_item integer NOT NULL,
    we_expiry timestamp with time zone NOT NULL
);


ALTER TABLE public.watchlist_expiry OWNER TO postgres;

--
-- Name: watchlist_expiry_we_item_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.watchlist_expiry_we_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.watchlist_expiry_we_item_seq OWNER TO postgres;

--
-- Name: watchlist_expiry_we_item_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.watchlist_expiry_we_item_seq OWNED BY public.watchlist_expiry.we_item;


--
-- Name: watchlist_wl_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.watchlist_wl_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.watchlist_wl_id_seq OWNER TO postgres;

--
-- Name: watchlist_wl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.watchlist_wl_id_seq OWNED BY public.watchlist.wl_id;


--
-- Name: actor actor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor ALTER COLUMN actor_id SET DEFAULT nextval('public.actor_actor_id_seq'::regclass);


--
-- Name: archive ar_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive ALTER COLUMN ar_id SET DEFAULT nextval('public.archive_ar_id_seq'::regclass);


--
-- Name: category cat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN cat_id SET DEFAULT nextval('public.category_cat_id_seq'::regclass);


--
-- Name: change_tag ct_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.change_tag ALTER COLUMN ct_id SET DEFAULT nextval('public.change_tag_ct_id_seq'::regclass);


--
-- Name: change_tag_def ctd_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.change_tag_def ALTER COLUMN ctd_id SET DEFAULT nextval('public.change_tag_def_ctd_id_seq'::regclass);


--
-- Name: comment comment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment ALTER COLUMN comment_id SET DEFAULT nextval('public.comment_comment_id_seq'::regclass);


--
-- Name: content content_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content ALTER COLUMN content_id SET DEFAULT nextval('public.content_content_id_seq'::regclass);


--
-- Name: content_models model_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_models ALTER COLUMN model_id SET DEFAULT nextval('public.content_models_model_id_seq'::regclass);


--
-- Name: externallinks el_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externallinks ALTER COLUMN el_id SET DEFAULT nextval('public.externallinks_el_id_seq'::regclass);


--
-- Name: filearchive fa_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filearchive ALTER COLUMN fa_id SET DEFAULT nextval('public.filearchive_fa_id_seq'::regclass);


--
-- Name: ip_changes ipc_rev_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_changes ALTER COLUMN ipc_rev_id SET DEFAULT nextval('public.ip_changes_ipc_rev_id_seq'::regclass);


--
-- Name: ipblocks ipb_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ipblocks ALTER COLUMN ipb_id SET DEFAULT nextval('public.ipblocks_ipb_id_seq'::regclass);


--
-- Name: job job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job ALTER COLUMN job_id SET DEFAULT nextval('public.job_job_id_seq'::regclass);


--
-- Name: logging log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logging ALTER COLUMN log_id SET DEFAULT nextval('public.logging_log_id_seq'::regclass);


--
-- Name: mwuser user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mwuser ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);


--
-- Name: page page_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page ALTER COLUMN page_id SET DEFAULT nextval('public.page_page_id_seq'::regclass);


--
-- Name: page_restrictions pr_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_restrictions ALTER COLUMN pr_id SET DEFAULT nextval('public.page_restrictions_pr_id_seq'::regclass);


--
-- Name: pagecontent old_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagecontent ALTER COLUMN old_id SET DEFAULT nextval('public.text_old_id_seq'::regclass);


--
-- Name: recentchanges rc_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recentchanges ALTER COLUMN rc_id SET DEFAULT nextval('public.recentchanges_rc_id_seq'::regclass);


--
-- Name: revision rev_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision ALTER COLUMN rev_id SET DEFAULT nextval('public.revision_rev_id_seq'::regclass);


--
-- Name: sites site_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites ALTER COLUMN site_id SET DEFAULT nextval('public.sites_site_id_seq'::regclass);


--
-- Name: slot_roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_roles ALTER COLUMN role_id SET DEFAULT nextval('public.slot_roles_role_id_seq'::regclass);


--
-- Name: uploadstash us_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploadstash ALTER COLUMN us_id SET DEFAULT nextval('public.uploadstash_us_id_seq'::regclass);


--
-- Name: watchlist wl_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchlist ALTER COLUMN wl_id SET DEFAULT nextval('public.watchlist_wl_id_seq'::regclass);


--
-- Name: watchlist_expiry we_item; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchlist_expiry ALTER COLUMN we_item SET DEFAULT nextval('public.watchlist_expiry_we_item_seq'::regclass);


--
-- Data for Name: actor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actor (actor_id, actor_user, actor_name) FROM stdin;
1	1	Kabir
2	2	MediaWiki default
\.


--
-- Data for Name: archive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.archive (ar_id, ar_namespace, ar_title, ar_page_id, ar_parent_id, ar_sha1, ar_comment_id, ar_actor, ar_timestamp, ar_minor_edit, ar_rev_id, ar_deleted, ar_len) FROM stdin;
\.


--
-- Data for Name: bot_passwords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bot_passwords (bp_user, bp_app_id, bp_password, bp_token, bp_restrictions, bp_grants) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (cat_id, cat_title, cat_pages, cat_subcats, cat_files) FROM stdin;
\.


--
-- Data for Name: categorylinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorylinks (cl_from, cl_to, cl_sortkey, cl_timestamp, cl_sortkey_prefix, cl_collation, cl_type) FROM stdin;
\.


--
-- Data for Name: change_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.change_tag (ct_id, ct_rc_id, ct_log_id, ct_rev_id, ct_params, ct_tag_id) FROM stdin;
\.


--
-- Data for Name: change_tag_def; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.change_tag_def (ctd_id, ctd_name, ctd_user_defined, ctd_count) FROM stdin;
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment (comment_id, comment_hash, comment_text, comment_data) FROM stdin;
1	0		\N
\.


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.content (content_id, content_size, content_sha1, content_model, content_address) FROM stdin;
1	735	a5wehuldd0go2uniagwvx66n6c80irq	1	tt:1
\.


--
-- Data for Name: content_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.content_models (model_id, model_name) FROM stdin;
1	wikitext
\.


--
-- Data for Name: externallinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.externallinks (el_id, el_from, el_to, el_index, el_index_60) FROM stdin;
\.


--
-- Data for Name: filearchive; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.filearchive (fa_id, fa_name, fa_archive_name, fa_storage_group, fa_storage_key, fa_deleted_user, fa_deleted_timestamp, fa_deleted_reason_id, fa_size, fa_width, fa_height, fa_metadata, fa_bits, fa_media_type, fa_major_mime, fa_minor_mime, fa_description_id, fa_actor, fa_timestamp, fa_deleted, fa_sha1) FROM stdin;
\.


--
-- Data for Name: image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.image (img_name, img_size, img_width, img_height, img_metadata, img_bits, img_media_type, img_major_mime, img_minor_mime, img_description_id, img_actor, img_timestamp, img_sha1) FROM stdin;
\.


--
-- Data for Name: imagelinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.imagelinks (il_from, il_from_namespace, il_to) FROM stdin;
\.


--
-- Data for Name: interwiki; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interwiki (iw_prefix, iw_url, iw_local, iw_trans, iw_api, iw_wikiid) FROM stdin;
acronym	https://www.acronymfinder.com/~/search/af.aspx?string=exact&Acronym=$1	0	0		
advogato	http://www.advogato.org/$1	0	0		
arxiv	https://www.arxiv.org/abs/$1	0	0		
c2find	http://c2.com/cgi/wiki?FindPage&value=$1	0	0		
cache	https://www.google.com/search?q=cache:$1	0	0		
commons	https://commons.wikimedia.org/wiki/$1	0	0	https://commons.wikimedia.org/w/api.php	
dictionary	http://www.dict.org/bin/Dict?Database=*&Form=Dict1&Strategy=*&Query=$1	0	0		
doi	https://dx.doi.org/$1	0	0		
drumcorpswiki	http://www.drumcorpswiki.com/$1	0	0	http://drumcorpswiki.com/api.php	
dwjwiki	http://www.suberic.net/cgi-bin/dwj/wiki.cgi?$1	0	0		
elibre	http://enciclopedia.us.es/index.php/$1	0	0	http://enciclopedia.us.es/api.php	
emacswiki	https://www.emacswiki.org/emacs/$1	0	0		
foldoc	https://foldoc.org/?$1	0	0		
foxwiki	https://fox.wikis.com/wc.dll?Wiki~$1	0	0		
freebsdman	https://www.FreeBSD.org/cgi/man.cgi?apropos=1&query=$1	0	0		
gentoo-wiki	http://gentoo-wiki.com/$1	0	0		
google	https://www.google.com/search?q=$1	0	0		
googlegroups	https://groups.google.com/groups?q=$1	0	0		
hammondwiki	http://www.dairiki.org/HammondWiki/$1	0	0		
hrwiki	http://www.hrwiki.org/wiki/$1	0	0	http://www.hrwiki.org/w/api.php	
imdb	http://www.imdb.com/find?q=$1&tt=on	0	0		
kmwiki	https://kmwiki.wikispaces.com/$1	0	0		
linuxwiki	http://linuxwiki.de/$1	0	0		
lojban	https://mw.lojban.org/papri/$1	0	0		
lqwiki	http://wiki.linuxquestions.org/wiki/$1	0	0		
meatball	http://www.usemod.com/cgi-bin/mb.pl?$1	0	0		
mediawikiwiki	https://www.mediawiki.org/wiki/$1	0	0	https://www.mediawiki.org/w/api.php	
memoryalpha	http://en.memory-alpha.org/wiki/$1	0	0	http://en.memory-alpha.org/api.php	
metawiki	http://sunir.org/apps/meta.pl?$1	0	0		
metawikimedia	https://meta.wikimedia.org/wiki/$1	0	0	https://meta.wikimedia.org/w/api.php	
mozillawiki	https://wiki.mozilla.org/$1	0	0	https://wiki.mozilla.org/api.php	
mw	https://www.mediawiki.org/wiki/$1	0	0	https://www.mediawiki.org/w/api.php	
oeis	https://oeis.org/$1	0	0		
openwiki	http://openwiki.com/ow.asp?$1	0	0		
pmid	https://www.ncbi.nlm.nih.gov/pubmed/$1?dopt=Abstract	0	0		
pythoninfo	https://wiki.python.org/moin/$1	0	0		
rfc	https://tools.ietf.org/html/rfc$1	0	0		
s23wiki	http://s23.org/wiki/$1	0	0	http://s23.org/w/api.php	
seattlewireless	http://seattlewireless.net/$1	0	0		
senseislibrary	https://senseis.xmp.net/?$1	0	0		
shoutwiki	http://www.shoutwiki.com/wiki/$1	0	0	http://www.shoutwiki.com/w/api.php	
squeak	http://wiki.squeak.org/squeak/$1	0	0		
tmbw	http://www.tmbw.net/wiki/$1	0	0	http://tmbw.net/wiki/api.php	
tmnet	http://www.technomanifestos.net/?$1	0	0		
theopedia	https://www.theopedia.com/$1	0	0		
twiki	http://twiki.org/cgi-bin/view/$1	0	0		
uncyclopedia	https://en.uncyclopedia.co/wiki/$1	0	0	https://en.uncyclopedia.co/w/api.php	
unreal	https://wiki.beyondunreal.com/$1	0	0	https://wiki.beyondunreal.com/w/api.php	
usemod	http://www.usemod.com/cgi-bin/wiki.pl?$1	0	0		
wiki	http://c2.com/cgi/wiki?$1	0	0		
wikia	http://www.wikia.com/wiki/$1	0	0		
wikibooks	https://en.wikibooks.org/wiki/$1	0	0	https://en.wikibooks.org/w/api.php	
wikidata	https://www.wikidata.org/wiki/$1	0	0	https://www.wikidata.org/w/api.php	
wikif1	http://www.wikif1.org/$1	0	0		
wikihow	https://www.wikihow.com/$1	0	0	https://www.wikihow.com/api.php	
wikinfo	http://wikinfo.co/English/index.php/$1	0	0		
wikimedia	https://foundation.wikimedia.org/wiki/$1	0	0	https://foundation.wikimedia.org/w/api.php	
wikinews	https://en.wikinews.org/wiki/$1	0	0	https://en.wikinews.org/w/api.php	
wikipedia	https://en.wikipedia.org/wiki/$1	0	0	https://en.wikipedia.org/w/api.php	
wikiquote	https://en.wikiquote.org/wiki/$1	0	0	https://en.wikiquote.org/w/api.php	
wikisource	https://wikisource.org/wiki/$1	0	0	https://wikisource.org/w/api.php	
wikispecies	https://species.wikimedia.org/wiki/$1	0	0	https://species.wikimedia.org/w/api.php	
wikiversity	https://en.wikiversity.org/wiki/$1	0	0	https://en.wikiversity.org/w/api.php	
wikivoyage	https://en.wikivoyage.org/wiki/$1	0	0	https://en.wikivoyage.org/w/api.php	
wikt	https://en.wiktionary.org/wiki/$1	0	0	https://en.wiktionary.org/w/api.php	
wiktionary	https://en.wiktionary.org/wiki/$1	0	0	https://en.wiktionary.org/w/api.php	
\.


--
-- Data for Name: ip_changes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ip_changes (ipc_rev_id, ipc_rev_timestamp, ipc_hex) FROM stdin;
\.


--
-- Data for Name: ipblocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ipblocks (ipb_id, ipb_address, ipb_user, ipb_by_actor, ipb_reason_id, ipb_timestamp, ipb_auto, ipb_anon_only, ipb_create_account, ipb_enable_autoblock, ipb_expiry, ipb_range_start, ipb_range_end, ipb_deleted, ipb_block_email, ipb_allow_usertalk, ipb_parent_block_id, ipb_sitewide) FROM stdin;
\.


--
-- Data for Name: ipblocks_restrictions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ipblocks_restrictions (ir_ipb_id, ir_type, ir_value) FROM stdin;
\.


--
-- Data for Name: iwlinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.iwlinks (iwl_from, iwl_prefix, iwl_title) FROM stdin;
\.


--
-- Data for Name: job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job (job_id, job_cmd, job_namespace, job_title, job_timestamp, job_params, job_random, job_attempts, job_token, job_token_timestamp, job_sha1) FROM stdin;
\.


--
-- Data for Name: l10n_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.l10n_cache (lc_lang, lc_key, lc_value) FROM stdin;
\.


--
-- Data for Name: langlinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.langlinks (ll_from, ll_lang, ll_title) FROM stdin;
\.


--
-- Data for Name: log_search; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_search (ls_field, ls_value, ls_log_id) FROM stdin;
associated_rev_id	1	1
\.


--
-- Data for Name: logging; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logging (log_id, log_type, log_action, log_timestamp, log_actor, log_namespace, log_title, log_comment_id, log_params, log_deleted, log_page) FROM stdin;
1	create	create	2021-02-08 08:24:42+00	2	0	Main_Page	1	a:1:{s:17:"associated_rev_id";i:1;}	0	1
\.


--
-- Data for Name: module_deps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.module_deps (md_module, md_skin, md_deps) FROM stdin;
\.


--
-- Data for Name: mwuser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mwuser (user_id, user_name, user_real_name, user_password, user_newpassword, user_newpass_time, user_token, user_email, user_email_token, user_email_token_expires, user_email_authenticated, user_touched, user_registration, user_editcount, user_password_expires) FROM stdin;
0	Anonymous		\N	\N	\N	\N	\N	\N	\N	\N	2021-02-08 08:24:41.259665+00	2021-02-08 08:24:41.259665+00	\N	\N
1	Kabir		:pbkdf2:sha512:30000:64:4b3QcVrs9sn9u2spXqwRBQ==:LTHQOyIpFmAPezXUcycV0H9ggSgDU9lHR6U6vdh5Kp9WJ1Szy/JgmdltrpagUvqg6HolN5t+C/U8O/1BwvHWWw==		\N	1349608d2c04d9695ff9349d8182e18e	kabir.naim@gmail.com	\N	\N	\N	2021-02-08 08:24:42+00	2021-02-08 08:24:41+00	0	\N
2	MediaWiki default				\N	*** INVALID ***		\N	\N	\N	2021-02-08 08:24:42+00	2021-02-08 08:24:42+00	0	\N
\.


--
-- Data for Name: oathauth_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oathauth_users (id, module, data) FROM stdin;
\.


--
-- Data for Name: objectcache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.objectcache (keyname, value, exptime) FROM stdin;
\.


--
-- Data for Name: oldimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.oldimage (oi_name, oi_archive_name, oi_size, oi_width, oi_height, oi_bits, oi_description_id, oi_actor, oi_timestamp, oi_metadata, oi_media_type, oi_major_mime, oi_minor_mime, oi_deleted, oi_sha1) FROM stdin;
\.


--
-- Data for Name: page; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page (page_id, page_namespace, page_title, page_restrictions, page_is_redirect, page_is_new, page_random, page_touched, page_links_updated, page_latest, page_len, page_content_model, page_lang, titlevector) FROM stdin;
1	0	Main_Page		0	1	0.31151006067300	2021-02-08 08:24:42+00	\N	1	735	wikitext	\N	'main':1 'page':2
\.


--
-- Data for Name: page_props; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_props (pp_page, pp_propname, pp_value, pp_sortkey) FROM stdin;
\.


--
-- Data for Name: page_restrictions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_restrictions (pr_id, pr_page, pr_type, pr_level, pr_cascade, pr_user, pr_expiry) FROM stdin;
\.


--
-- Data for Name: pagecontent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pagecontent (old_id, old_text, old_flags, textvector) FROM stdin;
1	<strong>MediaWiki has been installed.</strong>\n\nConsult the [https://www.mediawiki.org/wiki/Special:MyLanguage/Help:Contents User's Guide] for information on using the wiki software.\n\n== Getting started ==\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:Configuration_settings Configuration settings list]\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:FAQ MediaWiki FAQ]\n* [https://lists.wikimedia.org/mailman/listinfo/mediawiki-announce MediaWiki release mailing list]\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Localisation#Translation_resources Localise MediaWiki for your language]\n* [https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:Combating_spam Learn how to combat spam on your wiki]	utf-8	'/mailman/listinfo/mediawiki-announce':35 '/wiki/special:mylanguage/help:contents':9 '/wiki/special:mylanguage/localisation#translation_resources':42 '/wiki/special:mylanguage/manual:combating_spam':50 '/wiki/special:mylanguage/manual:configuration_settings':24 '/wiki/special:mylanguage/manual:faq':30 'combat':54 'configur':25 'consult':5 'faq':32 'get':20 'guid':12 'inform':14 'instal':4 'languag':47 'learn':51 'list':27,39 'lists.wikimedia.org':34 'lists.wikimedia.org/mailman/listinfo/mediawiki-announce':33 'localis':43 'mail':38 'mediawiki':1,31,36,44 'releas':37 'set':26 'softwar':19 'spam':55 'start':21 'use':16 'user':10 'wiki':18,58 'www.mediawiki.org':8,23,29,41,49 'www.mediawiki.org/wiki/special:mylanguage/help:contents':7 'www.mediawiki.org/wiki/special:mylanguage/localisation#translation_resources':40 'www.mediawiki.org/wiki/special:mylanguage/manual:combating_spam':48 'www.mediawiki.org/wiki/special:mylanguage/manual:configuration_settings':22 'www.mediawiki.org/wiki/special:mylanguage/manual:faq':28
\.


--
-- Data for Name: pagelinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pagelinks (pl_from, pl_from_namespace, pl_namespace, pl_title) FROM stdin;
\.


--
-- Data for Name: protected_titles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.protected_titles (pt_namespace, pt_title, pt_user, pt_reason_id, pt_timestamp, pt_expiry, pt_create_perm) FROM stdin;
\.


--
-- Data for Name: querycache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.querycache (qc_type, qc_value, qc_namespace, qc_title) FROM stdin;
\.


--
-- Data for Name: querycache_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.querycache_info (qci_type, qci_timestamp) FROM stdin;
\.


--
-- Data for Name: querycachetwo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.querycachetwo (qcc_type, qcc_value, qcc_namespace, qcc_title, qcc_namespacetwo, qcc_titletwo) FROM stdin;
\.


--
-- Data for Name: recentchanges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recentchanges (rc_id, rc_timestamp, rc_actor, rc_namespace, rc_title, rc_comment_id, rc_minor, rc_bot, rc_new, rc_cur_id, rc_this_oldid, rc_last_oldid, rc_type, rc_source, rc_patrolled, rc_ip, rc_old_len, rc_new_len, rc_deleted, rc_logid, rc_log_type, rc_log_action, rc_params) FROM stdin;
\.


--
-- Data for Name: redirect; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.redirect (rd_from, rd_namespace, rd_title, rd_interwiki, rd_fragment) FROM stdin;
\.


--
-- Data for Name: revision; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision (rev_id, rev_page, rev_comment_id, rev_actor, rev_timestamp, rev_minor_edit, rev_deleted, rev_len, rev_parent_id, rev_sha1) FROM stdin;
1	1	0	0	2021-02-08 08:24:42+00	0	0	735	0	a5wehuldd0go2uniagwvx66n6c80irq
\.


--
-- Data for Name: revision_actor_temp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision_actor_temp (revactor_rev, revactor_actor, revactor_timestamp, revactor_page) FROM stdin;
1	2	2021-02-08 08:24:42+00	1
\.


--
-- Data for Name: revision_comment_temp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.revision_comment_temp (revcomment_rev, revcomment_comment_id) FROM stdin;
1	1
\.


--
-- Data for Name: site_identifiers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site_identifiers (si_type, si_key, si_site) FROM stdin;
\.


--
-- Data for Name: site_stats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.site_stats (ss_row_id, ss_total_edits, ss_good_articles, ss_total_pages, ss_users, ss_active_users, ss_images) FROM stdin;
1	0	0	0	1	0	0
\.


--
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sites (site_id, site_global_key, site_type, site_group, site_source, site_language, site_protocol, site_domain, site_data, site_forward, site_config) FROM stdin;
\.


--
-- Data for Name: slot_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.slot_roles (role_id, role_name) FROM stdin;
1	main
\.


--
-- Data for Name: slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.slots (slot_revision_id, slot_role_id, slot_content_id, slot_origin) FROM stdin;
1	1	1	1
\.


--
-- Data for Name: templatelinks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.templatelinks (tl_from, tl_from_namespace, tl_namespace, tl_title) FROM stdin;
\.


--
-- Data for Name: updatelog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.updatelog (ul_key, ul_value) FROM stdin;
filearchive-fa_major_mime-patch-fa_major_mime-chemical.sql	\N
image-img_major_mime-patch-img_major_mime-chemical.sql	\N
oldimage-oi_major_mime-patch-oi_major_mime-chemical.sql	\N
user_groups-ug_group-patch-ug_group-length-increase-255.sql	\N
user_former_groups-ufg_group-patch-ufg_group-length-increase-255.sql	\N
user_properties-up_property-patch-up_property.sql	\N
patch-textsearch_bug66650.sql	\N
\.


--
-- Data for Name: uploadstash; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uploadstash (us_id, us_user, us_key, us_orig_path, us_path, us_props, us_source_type, us_timestamp, us_status, us_chunk_inx, us_size, us_sha1, us_mime, us_media_type, us_image_width, us_image_height, us_image_bits) FROM stdin;
\.


--
-- Data for Name: user_former_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_former_groups (ufg_user, ufg_group) FROM stdin;
\.


--
-- Data for Name: user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_groups (ug_user, ug_group, ug_expiry) FROM stdin;
1	sysop	\N
1	bureaucrat	\N
1	interface-admin	\N
\.


--
-- Data for Name: user_newtalk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_newtalk (user_id, user_ip, user_last_timestamp) FROM stdin;
\.


--
-- Data for Name: user_properties; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_properties (up_user, up_property, up_value) FROM stdin;
\.


--
-- Data for Name: watchlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watchlist (wl_id, wl_user, wl_namespace, wl_title, wl_notificationtimestamp) FROM stdin;
\.


--
-- Data for Name: watchlist_expiry; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.watchlist_expiry (we_item, we_expiry) FROM stdin;
\.


--
-- Name: actor_actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actor_actor_id_seq', 2, true);


--
-- Name: archive_ar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.archive_ar_id_seq', 1, false);


--
-- Name: category_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_cat_id_seq', 1, false);


--
-- Name: change_tag_ct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.change_tag_ct_id_seq', 1, false);


--
-- Name: change_tag_def_ctd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.change_tag_def_ctd_id_seq', 1, false);


--
-- Name: comment_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comment_comment_id_seq', 1, true);


--
-- Name: content_content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.content_content_id_seq', 1, true);


--
-- Name: content_models_model_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.content_models_model_id_seq', 1, true);


--
-- Name: externallinks_el_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.externallinks_el_id_seq', 1, false);


--
-- Name: filearchive_fa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.filearchive_fa_id_seq', 1, false);


--
-- Name: ip_changes_ipc_rev_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ip_changes_ipc_rev_id_seq', 1, false);


--
-- Name: ipblocks_ipb_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ipblocks_ipb_id_seq', 1, false);


--
-- Name: job_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_job_id_seq', 1, false);


--
-- Name: logging_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logging_log_id_seq', 1, true);


--
-- Name: oathauth_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.oathauth_users_id_seq', 0, false);


--
-- Name: page_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_page_id_seq', 1, true);


--
-- Name: page_restrictions_pr_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_restrictions_pr_id_seq', 1, false);


--
-- Name: recentchanges_rc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recentchanges_rc_id_seq', 1, false);


--
-- Name: revision_rev_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.revision_rev_id_seq', 1, true);


--
-- Name: sites_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sites_site_id_seq', 1, false);


--
-- Name: slot_roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.slot_roles_role_id_seq', 1, true);


--
-- Name: text_old_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.text_old_id_seq', 1, true);


--
-- Name: uploadstash_us_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uploadstash_us_id_seq', 1, false);


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_id_seq', 2, true);


--
-- Name: watchlist_expiry_we_item_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.watchlist_expiry_we_item_seq', 1, false);


--
-- Name: watchlist_wl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.watchlist_wl_id_seq', 1, false);


--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (actor_id);


--
-- Name: archive archive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.archive
    ADD CONSTRAINT archive_pkey PRIMARY KEY (ar_id);


--
-- Name: bot_passwords bot_passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bot_passwords
    ADD CONSTRAINT bot_passwords_pkey PRIMARY KEY (bp_user, bp_app_id);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (cat_id);


--
-- Name: change_tag_def change_tag_def_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.change_tag_def
    ADD CONSTRAINT change_tag_def_pkey PRIMARY KEY (ctd_id);


--
-- Name: change_tag change_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.change_tag
    ADD CONSTRAINT change_tag_pkey PRIMARY KEY (ct_id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (comment_id);


--
-- Name: content_models content_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content_models
    ADD CONSTRAINT content_models_pkey PRIMARY KEY (model_id);


--
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (content_id);


--
-- Name: externallinks externallinks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externallinks
    ADD CONSTRAINT externallinks_pkey PRIMARY KEY (el_id);


--
-- Name: filearchive filearchive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filearchive
    ADD CONSTRAINT filearchive_pkey PRIMARY KEY (fa_id);


--
-- Name: image image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.image
    ADD CONSTRAINT image_pkey PRIMARY KEY (img_name);


--
-- Name: interwiki interwiki_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interwiki
    ADD CONSTRAINT interwiki_pkey PRIMARY KEY (iw_prefix);


--
-- Name: ip_changes ip_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_changes
    ADD CONSTRAINT ip_changes_pkey PRIMARY KEY (ipc_rev_id);


--
-- Name: ipblocks ipblocks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ipblocks
    ADD CONSTRAINT ipblocks_pkey PRIMARY KEY (ipb_id);


--
-- Name: ipblocks_restrictions ipblocks_restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ipblocks_restrictions
    ADD CONSTRAINT ipblocks_restrictions_pkey PRIMARY KEY (ir_ipb_id, ir_type, ir_value);


--
-- Name: job job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job
    ADD CONSTRAINT job_pkey PRIMARY KEY (job_id);


--
-- Name: log_search log_search_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_search
    ADD CONSTRAINT log_search_pkey PRIMARY KEY (ls_field, ls_value, ls_log_id);


--
-- Name: logging logging_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logging
    ADD CONSTRAINT logging_pkey PRIMARY KEY (log_id);


--
-- Name: mwuser mwuser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mwuser
    ADD CONSTRAINT mwuser_pkey PRIMARY KEY (user_id);


--
-- Name: mwuser mwuser_user_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mwuser
    ADD CONSTRAINT mwuser_user_name_key UNIQUE (user_name);


--
-- Name: oathauth_users oathauth_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oathauth_users
    ADD CONSTRAINT oathauth_users_pkey PRIMARY KEY (id);


--
-- Name: objectcache objectcache_keyname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objectcache
    ADD CONSTRAINT objectcache_keyname_key UNIQUE (keyname);


--
-- Name: page page_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page
    ADD CONSTRAINT page_pkey PRIMARY KEY (page_id);


--
-- Name: page_props page_props_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_props
    ADD CONSTRAINT page_props_pk PRIMARY KEY (pp_page, pp_propname);


--
-- Name: page_restrictions page_restrictions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_restrictions
    ADD CONSTRAINT page_restrictions_pk PRIMARY KEY (pr_page, pr_type);


--
-- Name: page_restrictions page_restrictions_pr_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_restrictions
    ADD CONSTRAINT page_restrictions_pr_id_key UNIQUE (pr_id);


--
-- Name: pagecontent pagecontent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagecontent
    ADD CONSTRAINT pagecontent_pkey PRIMARY KEY (old_id);


--
-- Name: protected_titles protected_titles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protected_titles
    ADD CONSTRAINT protected_titles_pkey PRIMARY KEY (pt_namespace, pt_title);


--
-- Name: querycache_info querycache_info_qci_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.querycache_info
    ADD CONSTRAINT querycache_info_qci_type_key UNIQUE (qci_type);


--
-- Name: recentchanges recentchanges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recentchanges
    ADD CONSTRAINT recentchanges_pkey PRIMARY KEY (rc_id);


--
-- Name: redirect redirect_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redirect
    ADD CONSTRAINT redirect_pkey PRIMARY KEY (rd_from);


--
-- Name: revision_actor_temp revision_actor_temp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_actor_temp
    ADD CONSTRAINT revision_actor_temp_pkey PRIMARY KEY (revactor_rev, revactor_actor);


--
-- Name: revision_comment_temp revision_comment_temp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_comment_temp
    ADD CONSTRAINT revision_comment_temp_pkey PRIMARY KEY (revcomment_rev, revcomment_comment_id);


--
-- Name: revision revision_rev_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_rev_id_key UNIQUE (rev_id);


--
-- Name: site_identifiers site_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_identifiers
    ADD CONSTRAINT site_identifiers_pkey PRIMARY KEY (si_type, si_key);


--
-- Name: site_stats site_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.site_stats
    ADD CONSTRAINT site_stats_pkey PRIMARY KEY (ss_row_id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (site_id);


--
-- Name: slot_roles slot_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_roles
    ADD CONSTRAINT slot_roles_pkey PRIMARY KEY (role_id);


--
-- Name: slots slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slots
    ADD CONSTRAINT slots_pkey PRIMARY KEY (slot_revision_id, slot_role_id);


--
-- Name: updatelog updatelog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updatelog
    ADD CONSTRAINT updatelog_pkey PRIMARY KEY (ul_key);


--
-- Name: uploadstash uploadstash_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploadstash
    ADD CONSTRAINT uploadstash_pkey PRIMARY KEY (us_id);


--
-- Name: user_former_groups user_former_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_former_groups
    ADD CONSTRAINT user_former_groups_pkey PRIMARY KEY (ufg_user, ufg_group);


--
-- Name: user_groups user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (ug_user, ug_group);


--
-- Name: watchlist_expiry watchlist_expiry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchlist_expiry
    ADD CONSTRAINT watchlist_expiry_pkey PRIMARY KEY (we_item);


--
-- Name: watchlist watchlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchlist
    ADD CONSTRAINT watchlist_pkey PRIMARY KEY (wl_id);


--
-- Name: actor_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX actor_name ON public.actor USING btree (actor_name);


--
-- Name: actor_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX actor_user ON public.actor USING btree (actor_user);


--
-- Name: ar_revid_uniq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ar_revid_uniq ON public.archive USING btree (ar_rev_id);


--
-- Name: archive_actor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX archive_actor ON public.archive USING btree (ar_actor);


--
-- Name: archive_name_title_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX archive_name_title_timestamp ON public.archive USING btree (ar_namespace, ar_title, ar_timestamp);


--
-- Name: category_pages; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX category_pages ON public.category USING btree (cat_pages);


--
-- Name: category_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX category_title ON public.category USING btree (cat_title);


--
-- Name: change_tag_log_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX change_tag_log_tag_id ON public.change_tag USING btree (ct_log_id, ct_tag_id);


--
-- Name: change_tag_rc_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX change_tag_rc_tag_id ON public.change_tag USING btree (ct_rc_id, ct_tag_id);


--
-- Name: change_tag_rev_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX change_tag_rev_tag_id ON public.change_tag USING btree (ct_rev_id, ct_tag_id);


--
-- Name: change_tag_tag_id_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX change_tag_tag_id_id ON public.change_tag USING btree (ct_tag_id, ct_rc_id, ct_rev_id, ct_log_id);


--
-- Name: cl_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX cl_from ON public.categorylinks USING btree (cl_from, cl_to);


--
-- Name: cl_sortkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cl_sortkey ON public.categorylinks USING btree (cl_to, cl_sortkey, cl_from);


--
-- Name: comment_hash; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comment_hash ON public.comment USING btree (comment_hash);


--
-- Name: ctd_count; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ctd_count ON public.change_tag_def USING btree (ctd_count);


--
-- Name: ctd_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ctd_name ON public.change_tag_def USING btree (ctd_name);


--
-- Name: ctd_user_defined; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ctd_user_defined ON public.change_tag_def USING btree (ctd_user_defined);


--
-- Name: el_from_index_60; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX el_from_index_60 ON public.externallinks USING btree (el_from, el_index_60, el_id);


--
-- Name: el_index_60; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX el_index_60 ON public.externallinks USING btree (el_index_60, el_id);


--
-- Name: externallinks_from_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX externallinks_from_to ON public.externallinks USING btree (el_from, el_to);


--
-- Name: externallinks_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX externallinks_index ON public.externallinks USING btree (el_index);


--
-- Name: fa_dupe; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fa_dupe ON public.filearchive USING btree (fa_storage_group, fa_storage_key);


--
-- Name: fa_name_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fa_name_time ON public.filearchive USING btree (fa_name, fa_timestamp);


--
-- Name: fa_notime; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fa_notime ON public.filearchive USING btree (fa_deleted_timestamp);


--
-- Name: fa_nouser; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fa_nouser ON public.filearchive USING btree (fa_deleted_user);


--
-- Name: fa_sha1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fa_sha1 ON public.filearchive USING btree (fa_sha1);


--
-- Name: il_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX il_from ON public.imagelinks USING btree (il_to, il_from);


--
-- Name: img_sha1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX img_sha1 ON public.image USING btree (img_sha1);


--
-- Name: img_size_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX img_size_idx ON public.image USING btree (img_size);


--
-- Name: img_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX img_timestamp_idx ON public.image USING btree (img_timestamp);


--
-- Name: ipb_address_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ipb_address_unique ON public.ipblocks USING btree (ipb_address, ipb_user, ipb_auto);


--
-- Name: ipb_parent_block_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ipb_parent_block_id ON public.ipblocks USING btree (ipb_parent_block_id);


--
-- Name: ipb_range; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ipb_range ON public.ipblocks USING btree (ipb_range_start, ipb_range_end);


--
-- Name: ipb_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ipb_user ON public.ipblocks USING btree (ipb_user);


--
-- Name: ipc_hex_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ipc_hex_time ON public.ip_changes USING btree (ipc_hex, ipc_rev_timestamp);


--
-- Name: ipc_rev_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ipc_rev_timestamp ON public.ip_changes USING btree (ipc_rev_timestamp);


--
-- Name: ir_type_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ir_type_value ON public.ipblocks_restrictions USING btree (ir_type, ir_value);


--
-- Name: iwl_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX iwl_from ON public.iwlinks USING btree (iwl_from, iwl_prefix, iwl_title);


--
-- Name: iwl_prefix_from_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX iwl_prefix_from_title ON public.iwlinks USING btree (iwl_prefix, iwl_from, iwl_title);


--
-- Name: iwl_prefix_title_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX iwl_prefix_title_from ON public.iwlinks USING btree (iwl_prefix, iwl_title, iwl_from);


--
-- Name: job_cmd_namespace_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX job_cmd_namespace_title ON public.job USING btree (job_cmd, job_namespace, job_title);


--
-- Name: job_cmd_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX job_cmd_token ON public.job USING btree (job_cmd, job_token, job_random);


--
-- Name: job_cmd_token_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX job_cmd_token_id ON public.job USING btree (job_cmd, job_token, job_id);


--
-- Name: job_sha1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX job_sha1 ON public.job USING btree (job_sha1);


--
-- Name: job_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX job_timestamp_idx ON public.job USING btree (job_timestamp);


--
-- Name: l10n_cache_lc_lang_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX l10n_cache_lc_lang_key ON public.l10n_cache USING btree (lc_lang, lc_key);


--
-- Name: langlinks_lang_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX langlinks_lang_title ON public.langlinks USING btree (ll_lang, ll_title);


--
-- Name: langlinks_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX langlinks_unique ON public.langlinks USING btree (ll_from, ll_lang);


--
-- Name: logging_actor_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_actor_time ON public.logging USING btree (log_actor, log_timestamp);


--
-- Name: logging_actor_time_backwards; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_actor_time_backwards ON public.logging USING btree (log_timestamp, log_actor);


--
-- Name: logging_actor_type_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_actor_type_time ON public.logging USING btree (log_actor, log_type, log_timestamp);


--
-- Name: logging_page_id_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_page_id_time ON public.logging USING btree (log_page, log_timestamp);


--
-- Name: logging_page_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_page_time ON public.logging USING btree (log_namespace, log_title, log_timestamp);


--
-- Name: logging_times; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_times ON public.logging USING btree (log_timestamp);


--
-- Name: logging_type_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_type_action ON public.logging USING btree (log_type, log_action, log_timestamp);


--
-- Name: logging_type_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX logging_type_name ON public.logging USING btree (log_type, log_timestamp);


--
-- Name: ls_log_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ls_log_id ON public.log_search USING btree (ls_log_id);


--
-- Name: md_module_skin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX md_module_skin ON public.module_deps USING btree (md_module, md_skin);


--
-- Name: model_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX model_name ON public.content_models USING btree (model_name);


--
-- Name: new_name_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX new_name_timestamp ON public.recentchanges USING btree (rc_new, rc_namespace, rc_timestamp);


--
-- Name: objectcacache_exptime; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX objectcacache_exptime ON public.objectcache USING btree (exptime);


--
-- Name: oi_name_archive_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oi_name_archive_name ON public.oldimage USING btree (oi_name, oi_archive_name);


--
-- Name: oi_name_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oi_name_timestamp ON public.oldimage USING btree (oi_name, oi_timestamp);


--
-- Name: oi_sha1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX oi_sha1 ON public.oldimage USING btree (oi_sha1);


--
-- Name: page_len_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_len_idx ON public.page USING btree (page_len);


--
-- Name: page_main_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_main_title ON public.page USING btree (page_title text_pattern_ops) WHERE (page_namespace = 0);


--
-- Name: page_mediawiki_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_mediawiki_title ON public.page USING btree (page_title text_pattern_ops) WHERE (page_namespace = 8);


--
-- Name: page_project_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_project_title ON public.page USING btree (page_title text_pattern_ops) WHERE (page_namespace = 4);


--
-- Name: page_random_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_random_idx ON public.page USING btree (page_random);


--
-- Name: page_talk_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_talk_title ON public.page USING btree (page_title text_pattern_ops) WHERE (page_namespace = 1);


--
-- Name: page_unique_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX page_unique_name ON public.page USING btree (page_namespace, page_title);


--
-- Name: page_user_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_user_title ON public.page USING btree (page_title text_pattern_ops) WHERE (page_namespace = 2);


--
-- Name: page_utalk_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX page_utalk_title ON public.page USING btree (page_title text_pattern_ops) WHERE (page_namespace = 3);


--
-- Name: pagelink_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pagelink_unique ON public.pagelinks USING btree (pl_from, pl_namespace, pl_title);


--
-- Name: pagelinks_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pagelinks_title ON public.pagelinks USING btree (pl_title);


--
-- Name: pp_propname_page; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX pp_propname_page ON public.page_props USING btree (pp_propname, pp_page);


--
-- Name: pp_propname_sortkey_page; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pp_propname_sortkey_page ON public.page_props USING btree (pp_propname, pp_sortkey, pp_page) WHERE (pp_sortkey IS NOT NULL);


--
-- Name: querycache_type_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX querycache_type_value ON public.querycache USING btree (qc_type, qc_value);


--
-- Name: querycachetwo_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX querycachetwo_title ON public.querycachetwo USING btree (qcc_type, qcc_namespace, qcc_title);


--
-- Name: querycachetwo_titletwo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX querycachetwo_titletwo ON public.querycachetwo USING btree (qcc_type, qcc_namespacetwo, qcc_titletwo);


--
-- Name: querycachetwo_type_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX querycachetwo_type_value ON public.querycachetwo USING btree (qcc_type, qcc_value);


--
-- Name: rc_cur_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_cur_id ON public.recentchanges USING btree (rc_cur_id);


--
-- Name: rc_ip; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_ip ON public.recentchanges USING btree (rc_ip);


--
-- Name: rc_name_type_patrolled_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_name_type_patrolled_timestamp ON public.recentchanges USING btree (rc_namespace, rc_type, rc_patrolled, rc_timestamp);


--
-- Name: rc_namespace_title_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_namespace_title_timestamp ON public.recentchanges USING btree (rc_namespace, rc_title, rc_timestamp);


--
-- Name: rc_this_oldid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_this_oldid ON public.recentchanges USING btree (rc_this_oldid);


--
-- Name: rc_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_timestamp ON public.recentchanges USING btree (rc_timestamp);


--
-- Name: rc_timestamp_bot; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rc_timestamp_bot ON public.recentchanges USING btree (rc_timestamp) WHERE (rc_bot = 0);


--
-- Name: redirect_ns_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX redirect_ns_title ON public.redirect USING btree (rd_namespace, rd_title, rd_from);


--
-- Name: rev_actor_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rev_actor_timestamp ON public.revision USING btree (rev_actor, rev_timestamp, rev_id);


--
-- Name: rev_page_actor_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rev_page_actor_timestamp ON public.revision USING btree (rev_page, rev_actor, rev_timestamp);


--
-- Name: rev_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX rev_timestamp_idx ON public.revision USING btree (rev_timestamp);


--
-- Name: revactor_actor_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX revactor_actor_timestamp ON public.revision_actor_temp USING btree (revactor_actor, revactor_timestamp);


--
-- Name: revactor_page_actor_timestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX revactor_page_actor_timestamp ON public.revision_actor_temp USING btree (revactor_page, revactor_actor, revactor_timestamp);


--
-- Name: revactor_rev; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX revactor_rev ON public.revision_actor_temp USING btree (revactor_rev);


--
-- Name: revcomment_rev; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX revcomment_rev ON public.revision_comment_temp USING btree (revcomment_rev);


--
-- Name: revision_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX revision_unique ON public.revision USING btree (rev_page, rev_id);


--
-- Name: role_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX role_name ON public.slot_roles USING btree (role_name);


--
-- Name: site_domain; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_domain ON public.sites USING btree (site_domain);


--
-- Name: site_forward; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_forward ON public.sites USING btree (site_forward);


--
-- Name: site_global_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX site_global_key ON public.sites USING btree (site_global_key);


--
-- Name: site_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_group ON public.sites USING btree (site_group);


--
-- Name: site_ids_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_ids_key ON public.site_identifiers USING btree (si_key);


--
-- Name: site_ids_site; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_ids_site ON public.site_identifiers USING btree (si_site);


--
-- Name: site_language; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_language ON public.sites USING btree (site_language);


--
-- Name: site_protocol; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_protocol ON public.sites USING btree (site_protocol);


--
-- Name: site_source; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_source ON public.sites USING btree (site_source);


--
-- Name: site_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX site_type ON public.sites USING btree (site_type);


--
-- Name: slot_revision_origin_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX slot_revision_origin_role ON public.slots USING btree (slot_revision_id, slot_origin, slot_role_id);


--
-- Name: templatelinks_from; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX templatelinks_from ON public.templatelinks USING btree (tl_from);


--
-- Name: templatelinks_unique; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX templatelinks_unique ON public.templatelinks USING btree (tl_namespace, tl_title, tl_from);


--
-- Name: ts2_page_text; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ts2_page_text ON public.pagecontent USING gin (textvector);


--
-- Name: ts2_page_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ts2_page_title ON public.page USING gin (titlevector);


--
-- Name: us_key_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX us_key_idx ON public.uploadstash USING btree (us_key);


--
-- Name: us_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX us_timestamp_idx ON public.uploadstash USING btree (us_timestamp);


--
-- Name: us_user_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX us_user_idx ON public.uploadstash USING btree (us_user);


--
-- Name: user_email_token_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_email_token_idx ON public.mwuser USING btree (user_email_token);


--
-- Name: user_groups_expiry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_expiry ON public.user_groups USING btree (ug_expiry);


--
-- Name: user_groups_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_groups_group ON public.user_groups USING btree (ug_group);


--
-- Name: user_newtalk_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_newtalk_id_idx ON public.user_newtalk USING btree (user_id);


--
-- Name: user_newtalk_ip_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_newtalk_ip_idx ON public.user_newtalk USING btree (user_ip);


--
-- Name: user_properties_property; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_properties_property ON public.user_properties USING btree (up_property);


--
-- Name: user_properties_user_property; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_properties_user_property ON public.user_properties USING btree (up_user, up_property);


--
-- Name: we_expiry; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX we_expiry ON public.watchlist_expiry USING btree (we_expiry);


--
-- Name: wl_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wl_user ON public.watchlist USING btree (wl_user);


--
-- Name: wl_user_namespace_title; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX wl_user_namespace_title ON public.watchlist USING btree (wl_namespace, wl_title, wl_user);


--
-- Name: wl_user_notificationtimestamp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX wl_user_notificationtimestamp ON public.watchlist USING btree (wl_user, wl_notificationtimestamp);


--
-- Name: page page_deleted; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER page_deleted AFTER DELETE ON public.page FOR EACH ROW EXECUTE FUNCTION public.page_deleted();


--
-- Name: pagecontent ts2_page_text; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ts2_page_text BEFORE INSERT OR UPDATE ON public.pagecontent FOR EACH ROW EXECUTE FUNCTION public.ts2_page_text();


--
-- Name: page ts2_page_title; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER ts2_page_title BEFORE INSERT OR UPDATE ON public.page FOR EACH ROW EXECUTE FUNCTION public.ts2_page_title();


--
-- Name: categorylinks categorylinks_cl_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorylinks
    ADD CONSTRAINT categorylinks_cl_from_fkey FOREIGN KEY (cl_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: externallinks externallinks_el_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.externallinks
    ADD CONSTRAINT externallinks_el_from_fkey FOREIGN KEY (el_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: filearchive filearchive_fa_deleted_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.filearchive
    ADD CONSTRAINT filearchive_fa_deleted_user_fkey FOREIGN KEY (fa_deleted_user) REFERENCES public.mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: imagelinks imagelinks_il_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagelinks
    ADD CONSTRAINT imagelinks_il_from_fkey FOREIGN KEY (il_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ipblocks ipblocks_ipb_parent_block_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ipblocks
    ADD CONSTRAINT ipblocks_ipb_parent_block_id_fkey FOREIGN KEY (ipb_parent_block_id) REFERENCES public.ipblocks(ipb_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ipblocks ipblocks_ipb_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ipblocks
    ADD CONSTRAINT ipblocks_ipb_user_fkey FOREIGN KEY (ipb_user) REFERENCES public.mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ipblocks_restrictions ipblocks_restrictions_ir_ipb_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ipblocks_restrictions
    ADD CONSTRAINT ipblocks_restrictions_ir_ipb_id_fkey FOREIGN KEY (ir_ipb_id) REFERENCES public.ipblocks(ipb_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: langlinks langlinks_ll_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.langlinks
    ADD CONSTRAINT langlinks_ll_from_fkey FOREIGN KEY (ll_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oldimage oldimage_oi_name_fkey_cascaded; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.oldimage
    ADD CONSTRAINT oldimage_oi_name_fkey_cascaded FOREIGN KEY (oi_name) REFERENCES public.image(img_name) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_props page_props_pp_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_props
    ADD CONSTRAINT page_props_pp_page_fkey FOREIGN KEY (pp_page) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: page_restrictions page_restrictions_pr_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_restrictions
    ADD CONSTRAINT page_restrictions_pr_page_fkey FOREIGN KEY (pr_page) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: pagelinks pagelinks_pl_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagelinks
    ADD CONSTRAINT pagelinks_pl_from_fkey FOREIGN KEY (pl_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: protected_titles protected_titles_pt_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.protected_titles
    ADD CONSTRAINT protected_titles_pt_user_fkey FOREIGN KEY (pt_user) REFERENCES public.mwuser(user_id) ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: redirect redirect_rd_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.redirect
    ADD CONSTRAINT redirect_rd_from_fkey FOREIGN KEY (rd_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: revision_actor_temp revision_actor_temp_revactor_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision_actor_temp
    ADD CONSTRAINT revision_actor_temp_revactor_page_fkey FOREIGN KEY (revactor_page) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: revision revision_rev_page_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.revision
    ADD CONSTRAINT revision_rev_page_fkey FOREIGN KEY (rev_page) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: templatelinks templatelinks_tl_from_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.templatelinks
    ADD CONSTRAINT templatelinks_tl_from_fkey FOREIGN KEY (tl_from) REFERENCES public.page(page_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_groups user_groups_ug_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_groups
    ADD CONSTRAINT user_groups_ug_user_fkey FOREIGN KEY (ug_user) REFERENCES public.mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_newtalk user_newtalk_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_newtalk
    ADD CONSTRAINT user_newtalk_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_properties user_properties_up_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_properties
    ADD CONSTRAINT user_properties_up_user_fkey FOREIGN KEY (up_user) REFERENCES public.mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: watchlist watchlist_wl_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.watchlist
    ADD CONSTRAINT watchlist_wl_user_fkey FOREIGN KEY (wl_user) REFERENCES public.mwuser(user_id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

