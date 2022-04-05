--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8
-- Dumped by pg_dump version 13.4

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
-- Name: heimdall; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA heimdall;


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: age_range_high_value_unit_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.age_range_high_value_unit_enum AS ENUM (
    'month',
    'year'
);


--
-- Name: age_range_low_value_unit_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.age_range_low_value_unit_enum AS ENUM (
    'month',
    'year'
);


--
-- Name: age_range_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.age_range_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: attendance_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.attendance_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: branding_image_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.branding_image_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: branding_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.branding_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: category_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.category_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: class_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.class_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: grade_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.grade_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: organization_membership_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.organization_membership_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: organization_ownership_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.organization_ownership_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: organization_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.organization_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: permission_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.permission_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: program_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.program_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: role_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.role_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: school_membership_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.school_membership_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: school_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.school_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: subcategory_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subcategory_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: subject_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.subject_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: user_status_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_status_enum AS ENUM (
    'active',
    'inactive'
);


--
-- Name: getrepdelta(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.getrepdelta() RETURNS integer
    LANGUAGE plpgsql
    AS $$ 

declare
delta bigint :=-1;
last bigint :=-2;
empty varchar;
countdown int :=1000;
begin
   loop
      select round(extract(epoch from clock_timestamp()) * 1000) - time into delta from heimdall.heimdall_lag_detection order by time desc limit 1;
   if ((delta < last and delta >= 0) or (countdown = 0)) then
      exit;
   end if;
   last = delta;
   countdown = countdown - 1;
   select pg_sleep(.001) into empty;
end loop;
return delta;
end $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: heimdall_lag_detection; Type: TABLE; Schema: heimdall; Owner: -
--

CREATE TABLE heimdall.heimdall_lag_detection (
    "time" bigint
);


--
-- Name: age_range; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.age_range (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    high_value integer NOT NULL,
    low_value integer NOT NULL,
    high_value_unit public.age_range_high_value_unit_enum NOT NULL,
    low_value_unit public.age_range_low_value_unit_enum NOT NULL,
    system boolean DEFAULT false NOT NULL,
    status public.age_range_status_enum DEFAULT 'active'::public.age_range_status_enum NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    organization_id uuid,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CHK_40ca83a3cccb2b45b8d379dc20" CHECK (((low_value >= 0) AND (low_value <= 99))),
    CONSTRAINT "CHK_f9addaa54d47ea675848684c38" CHECK (((high_value > 0) AND (high_value <= 99)))
);


--
-- Name: assessment_xapi_answer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_xapi_answer (
    room_id character varying NOT NULL,
    student_id character varying NOT NULL,
    content_id character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    answer character varying,
    score integer,
    minimum_possible_score integer,
    maximum_possible_score integer,
    "userContentScoreRoomId" character varying,
    "userContentScoreStudentId" character varying,
    "userContentScoreContentKey" character varying
);


--
-- Name: assessment_xapi_migration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_xapi_migration (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


--
-- Name: assessment_xapi_migration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assessment_xapi_migration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assessment_xapi_migration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assessment_xapi_migration_id_seq OWNED BY public.assessment_xapi_migration.id;


--
-- Name: assessment_xapi_room; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_xapi_room (
    room_id character varying NOT NULL,
    "startTime" timestamp without time zone,
    "endTime" timestamp without time zone,
    recalculate boolean DEFAULT false NOT NULL
);


--
-- Name: assessment_xapi_teacher_comment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_xapi_teacher_comment (
    room_id character varying NOT NULL,
    teacher_id character varying NOT NULL,
    student_id character varying NOT NULL,
    "roomRoomId" character varying NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    "lastUpdated" timestamp without time zone DEFAULT now() NOT NULL,
    comment character varying NOT NULL
);


--
-- Name: assessment_xapi_teacher_score; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_xapi_teacher_score (
    room_id character varying NOT NULL,
    student_id character varying NOT NULL,
    content_id character varying NOT NULL,
    teacher_id character varying NOT NULL,
    date timestamp without time zone DEFAULT now() NOT NULL,
    "lastUpdated" timestamp without time zone DEFAULT now() NOT NULL,
    score real DEFAULT '0'::real NOT NULL,
    "userContentScoreRoomId" character varying,
    "userContentScoreStudentId" character varying,
    "userContentScoreContentKey" character varying
);


--
-- Name: assessment_xapi_user_content_score; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.assessment_xapi_user_content_score (
    room_id character varying NOT NULL,
    student_id character varying NOT NULL,
    content_id character varying NOT NULL,
    seen boolean DEFAULT false NOT NULL,
    "contentType" character varying,
    "contentName" character varying,
    "contentParentId" character varying,
    "roomRoomId" character varying
);


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.attendance (
    session_id character varying NOT NULL,
    join_timestamp timestamp without time zone NOT NULL,
    leave_timestamp timestamp without time zone NOT NULL,
    room_id character varying NOT NULL,
    user_id character varying NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    status public.attendance_status_enum DEFAULT 'active'::public.attendance_status_enum NOT NULL
);


--
-- Name: branding; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.branding (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    primary_color text,
    status public.branding_status_enum DEFAULT 'active'::public.branding_status_enum NOT NULL,
    organization_id uuid,
    deleted_at timestamp(3) without time zone
);


--
-- Name: branding_image; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.branding_image (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    tag character varying NOT NULL,
    url character varying NOT NULL,
    status public.branding_image_status_enum DEFAULT 'active'::public.branding_image_status_enum NOT NULL,
    branding_id uuid,
    deleted_at timestamp(3) without time zone
);


--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    status public.category_status_enum DEFAULT 'active'::public.category_status_enum NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    organization_id uuid,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: category_subcategories_subcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_subcategories_subcategory (
    "categoryId" uuid NOT NULL,
    "subcategoryId" uuid NOT NULL
);


--
-- Name: class; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class (
    class_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_name character varying NOT NULL,
    status public.class_status_enum DEFAULT 'active'::public.class_status_enum NOT NULL,
    shortcode character varying(10),
    deleted_at timestamp(3) without time zone,
    "organizationOrganizationId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CHK_090129622ea775ac18fa6efb2a" CHECK (((class_name)::text <> ''::text))
);


--
-- Name: class_age_ranges_age_range; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_age_ranges_age_range (
    "classClassId" uuid NOT NULL,
    "ageRangeId" uuid NOT NULL
);


--
-- Name: class_grades_grade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_grades_grade (
    "classClassId" uuid NOT NULL,
    "gradeId" uuid NOT NULL
);


--
-- Name: class_programs_program; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_programs_program (
    "classClassId" uuid NOT NULL,
    "programId" uuid NOT NULL
);


--
-- Name: class_subjects_subject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.class_subjects_subject (
    "classClassId" uuid NOT NULL,
    "subjectId" uuid NOT NULL
);


--
-- Name: grade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grade (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    status public.grade_status_enum DEFAULT 'active'::public.grade_status_enum NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    progress_from_grade_id uuid,
    progress_to_grade_id uuid,
    organization_id uuid,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    "timestamp" bigint NOT NULL,
    name character varying NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization (
    organization_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    organization_name character varying,
    address1 character varying,
    address2 character varying,
    phone character varying,
    "shortCode" character varying(10),
    status public.organization_status_enum DEFAULT 'active'::public.organization_status_enum NOT NULL,
    deleted_at timestamp(3) without time zone,
    "primaryContactUserId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: organization_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_membership (
    user_id character varying NOT NULL,
    organization_id character varying NOT NULL,
    status public.organization_membership_status_enum DEFAULT 'active'::public.organization_membership_status_enum NOT NULL,
    join_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    shortcode character varying(16),
    deleted_at timestamp(3) without time zone,
    "userUserId" uuid,
    "organizationOrganizationId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: organization_ownership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_ownership (
    user_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    status public.organization_ownership_status_enum DEFAULT 'active'::public.organization_ownership_status_enum NOT NULL,
    deleted_at timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: permission; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permission (
    permission_id character varying NOT NULL,
    permission_name character varying,
    allow boolean NOT NULL,
    permission_category character varying,
    permission_group character varying,
    permission_level character varying,
    permission_description character varying,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    status public.permission_status_enum DEFAULT 'active'::public.permission_status_enum NOT NULL
);


--
-- Name: permission_roles_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permission_roles_role (
    "permissionPermissionId" character varying NOT NULL,
    "roleRoleId" uuid NOT NULL
);


--
-- Name: program; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    status public.program_status_enum DEFAULT 'active'::public.program_status_enum NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    organization_id uuid,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: program_age_ranges_age_range; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_age_ranges_age_range (
    "programId" uuid NOT NULL,
    "ageRangeId" uuid NOT NULL
);


--
-- Name: program_grades_grade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_grades_grade (
    "programId" uuid NOT NULL,
    "gradeId" uuid NOT NULL
);


--
-- Name: program_subjects_subject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.program_subjects_subject (
    "programId" uuid NOT NULL,
    "subjectId" uuid NOT NULL
);


--
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role (
    role_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_name character varying,
    status public.role_status_enum DEFAULT 'active'::public.role_status_enum NOT NULL,
    deleted_at timestamp(3) without time zone,
    role_description character varying DEFAULT 'System Default Role'::character varying NOT NULL,
    system_role boolean DEFAULT false NOT NULL,
    "organizationOrganizationId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: role_memberships_organization_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_memberships_organization_membership (
    "roleRoleId" uuid NOT NULL,
    "organizationMembershipUserId" character varying NOT NULL,
    "organizationMembershipOrganizationId" character varying NOT NULL
);


--
-- Name: role_school_memberships_school_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_school_memberships_school_membership (
    "roleRoleId" uuid NOT NULL,
    "schoolMembershipUserId" character varying NOT NULL,
    "schoolMembershipSchoolId" character varying NOT NULL
);


--
-- Name: school; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school (
    school_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school_name character varying NOT NULL,
    shortcode character varying(10),
    status public.school_status_enum DEFAULT 'active'::public.school_status_enum NOT NULL,
    deleted_at timestamp(3) without time zone,
    "organizationOrganizationId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "CHK_96245082715fb7b556049b3793" CHECK (((school_name)::text <> ''::text))
);


--
-- Name: school_classes_class; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school_classes_class (
    "schoolSchoolId" uuid NOT NULL,
    "classClassId" uuid NOT NULL
);


--
-- Name: school_membership; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school_membership (
    user_id character varying NOT NULL,
    school_id character varying NOT NULL,
    status public.school_membership_status_enum DEFAULT 'active'::public.school_membership_status_enum NOT NULL,
    join_timestamp timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    "userUserId" uuid,
    "schoolSchoolId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: school_programs_program; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.school_programs_program (
    "schoolSchoolId" uuid NOT NULL,
    "programId" uuid NOT NULL
);


--
-- Name: subcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcategory (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    status public.subcategory_status_enum DEFAULT 'active'::public.subcategory_status_enum NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    organization_id uuid,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: subject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subject (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying NOT NULL,
    system boolean DEFAULT false NOT NULL,
    status public.subject_status_enum DEFAULT 'active'::public.subject_status_enum NOT NULL,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp(3) without time zone,
    organization_id uuid,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: subject_categories_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subject_categories_category (
    "subjectId" uuid NOT NULL,
    "categoryId" uuid NOT NULL
);


--
-- Name: tmp_import; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tmp_import (
    id integer NOT NULL,
    email character varying(100),
    first_name character varying(100),
    last_name character varying(100),
    organization character varying(100),
    roles text[]
);


--
-- Name: tmp_import_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tmp_import_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tmp_import_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tmp_import_id_seq OWNED BY public.tmp_import.id;


--
-- Name: typeorm_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.typeorm_metadata (
    type character varying NOT NULL,
    database character varying,
    schema character varying,
    "table" character varying,
    name character varying,
    value text
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."user" (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    given_name character varying,
    family_name character varying,
    username character varying,
    email character varying,
    phone character varying,
    date_of_birth character varying,
    gender character varying,
    avatar character varying,
    status public.user_status_enum DEFAULT 'active'::public.user_status_enum NOT NULL,
    deleted_at timestamp(3) without time zone,
    "primary" boolean DEFAULT false NOT NULL,
    alternate_email character varying,
    alternate_phone character varying,
    "myOrganizationOrganizationId" uuid,
    created_at timestamp(3) without time zone DEFAULT now() NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT now() NOT NULL
);


--
-- Name: user_classes_studying_class; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_classes_studying_class (
    "userUserId" uuid NOT NULL,
    "classClassId" uuid NOT NULL
);


--
-- Name: user_classes_teaching_class; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_classes_teaching_class (
    "userUserId" uuid NOT NULL,
    "classClassId" uuid NOT NULL
);


--
-- Name: assessment_xapi_migration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_migration ALTER COLUMN id SET DEFAULT nextval('public.assessment_xapi_migration_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: tmp_import id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmp_import ALTER COLUMN id SET DEFAULT nextval('public.tmp_import_id_seq'::regclass);


--
-- Data for Name: heimdall_lag_detection; Type: TABLE DATA; Schema: heimdall; Owner: -
--

COPY heimdall.heimdall_lag_detection ("time") FROM stdin;
1648558705956
1648558706958
1648558707955
1648558708955
1648558709955
1648558710955
1648558711954
1648558712954
1648558713954
1648558714954
1648558715954
1648558716954
1648558717954
1648558718954
1648558719954
1648558720955
1648558721954
1648558722955
1648558723955
1648558724955
1648558725955
1648558726955
1648558727955
1648558728954
1648558729954
1648558730955
1648558731954
1648558732955
1648558733955
1648558734956
1648558735955
1648558736955
1648558737962
1648558738953
1648558739954
1648558740955
1648558741954
1648558742954
1648558691955
1648558692955
1648558693955
1648558694955
1648558743955
1648558744955
1648558745955
1648558746955
1648558747955
1648558748955
1648558695954
1648558749954
1648558750954
1648558751954
1648558696954
1648558697955
1648558698955
1648558699954
1648558700954
1648558701954
1648558702954
1648558703955
1648558704955
\.


--
-- Data for Name: age_range; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.age_range (id, name, high_value, low_value, high_value_unit, low_value_unit, system, status, created_at, deleted_at, organization_id, updated_at) FROM stdin;
fe359c71-0b43-40be-99da-8d94cff2143d	1-5	5	1	year	year	f	active	2022-01-14 17:32:21.807	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-14 17:32:21.807
023eeeb1-5f72-4fa3-a2a7-63603607ac2b	None Specified	99	0	year	year	t	active	2021-12-21 11:04:35.868	\N	\N	2021-12-21 11:04:35.868
7965d220-619d-400f-8cab-42bd98c7d23c	3 - 4 year(s)	4	3	year	year	t	active	2021-12-21 11:04:35.873	\N	\N	2021-12-21 11:04:35.873
bb7982cd-020f-4e1a-93fc-4a6874917f07	4 - 5 year(s)	5	4	year	year	t	active	2021-12-21 11:04:35.877	\N	\N	2021-12-21 11:04:35.877
fe0b81a4-5b02-4548-8fb0-d49cd4a4604a	5 - 6 year(s)	6	5	year	year	t	active	2021-12-21 11:04:35.882	\N	\N	2021-12-21 11:04:35.882
145edddc-2019-43d9-97e1-c5830e7ed689	6 - 7 year(s)	7	6	year	year	t	active	2021-12-21 11:04:35.886	\N	\N	2021-12-21 11:04:35.886
21f1da64-b6c8-4e74-9fef-09d08cfd8e6c	7 - 8 year(s)	8	7	year	year	t	active	2021-12-21 11:04:35.89	\N	\N	2021-12-21 11:04:35.89
\.


--
-- Data for Name: assessment_xapi_answer; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_xapi_answer (room_id, student_id, content_id, "timestamp", answer, score, minimum_possible_score, maximum_possible_score, "userContentScoreRoomId", "userContentScoreStudentId", "userContentScoreContentKey") FROM stdin;
\.


--
-- Data for Name: assessment_xapi_migration; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_xapi_migration (id, "timestamp", name) FROM stdin;
\.


--
-- Data for Name: assessment_xapi_room; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_xapi_room (room_id, "startTime", "endTime", recalculate) FROM stdin;
\.


--
-- Data for Name: assessment_xapi_teacher_comment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_xapi_teacher_comment (room_id, teacher_id, student_id, "roomRoomId", date, "lastUpdated", comment) FROM stdin;
\.


--
-- Data for Name: assessment_xapi_teacher_score; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_xapi_teacher_score (room_id, student_id, content_id, teacher_id, date, "lastUpdated", score, "userContentScoreRoomId", "userContentScoreStudentId", "userContentScoreContentKey") FROM stdin;
\.


--
-- Data for Name: assessment_xapi_user_content_score; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assessment_xapi_user_content_score (room_id, student_id, content_id, seen, "contentType", "contentName", "contentParentId", "roomRoomId") FROM stdin;
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.attendance (session_id, join_timestamp, leave_timestamp, room_id, user_id, created_at, updated_at, deleted_at, status) FROM stdin;
\.


--
-- Data for Name: branding; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.branding (id, created_at, updated_at, primary_color, status, organization_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: branding_image; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.branding_image (id, created_at, updated_at, tag, url, status, branding_id, deleted_at) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category (id, name, system, status, created_at, deleted_at, organization_id, updated_at) FROM stdin;
f9d82bdd-4ee2-49dd-a707-133407cdef19	Fine Motor Skills	t	active	2021-12-21 11:04:37.008	\N	\N	2021-12-21 11:04:37.008
a1c26321-e3a7-4ff2-9f1c-bb1c5e420fb7	Gross Motor Skills	t	active	2021-12-21 11:04:37.032	\N	\N	2021-12-21 11:04:37.032
bcfd9d76-cf05-4ccd-9a41-6b886da661be	Gross Motor Skills	t	active	2021-12-21 11:04:37.306	\N	\N	2021-12-21 11:04:37.306
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	Speech & Language Skills	t	active	2022-01-10 14:55:29.738	\N	\N	2022-01-10 14:55:29.738
d5995392-11cb-4d28-a96d-8bdcd3f0436b	Fine Motor Skills	t	active	2022-01-10 14:55:29.756	\N	\N	2022-01-10 14:55:29.756
94013867-72d1-44e2-a43d-7336818f35d0	Gross Motor Skills	t	active	2022-01-10 14:55:29.768	\N	\N	2022-01-10 14:55:29.768
2b9d6317-298b-4aa5-9aea-aed56bd07823	Cognitive Skills	t	active	2022-01-10 14:55:29.78	\N	\N	2022-01-10 14:55:29.78
fc447234-af24-4768-b617-ac1b80ebae9b	Social & Emotional Skills	t	active	2022-01-10 14:55:29.79	\N	\N	2022-01-10 14:55:29.79
d68c6c5d-c739-46d8-be70-e70d6c565949	Core Subjects	t	active	2022-01-10 14:55:29.801	\N	\N	2022-01-10 14:55:29.801
c12f363a-633b-4080-bd2b-9ced8d034379	Cognitive Skills	t	active	2021-12-21 11:04:37.058	\N	\N	2021-12-21 11:04:37.058
c68865b4-2ba3-4608-955c-dcc098291159	Literacy	t	active	2021-12-21 11:04:38.043	\N	\N	2021-12-21 11:04:38.043
61f517d8-2c2e-47fd-a2de-6e86465abc59	Whole-Child	t	active	2021-12-21 11:04:38.067	\N	\N	2021-12-21 11:04:38.067
d896bf1a-fb5b-4a57-b833-87b0959ba926	Knowledge	t	active	2021-12-21 11:04:38.45	\N	\N	2021-12-21 11:04:38.45
b0b983e4-bf3c-4315-912e-67c8de4f9e11	Cognitive Skills	t	active	2021-12-21 11:04:38.604	\N	\N	2021-12-21 11:04:38.604
84619bee-0b1f-447f-8208-4a39f32062c9	Personal Development	t	active	2021-12-21 11:04:38.624	\N	\N	2021-12-21 11:04:38.624
26e4aedc-2222-44e1-a375-388b138c695d	Knowledge	t	active	2021-12-21 11:04:38.087	\N	\N	2021-12-21 11:04:38.087
bf1cd84d-da71-4111-82c6-e85224ab85ca	Speech & Language Skills	t	active	2021-12-21 11:04:38.112	\N	\N	2021-12-21 11:04:38.112
ba2db2b5-7f20-4cb7-88ef-cee0fcde7937	Fine Motor Skills	t	active	2021-12-21 11:04:38.166	\N	\N	2021-12-21 11:04:38.166
c909acad-0c52-4fd3-8427-3b1e90a730da	Cognitive Skills	t	active	2021-12-21 11:04:37.457	\N	\N	2021-12-21 11:04:37.457
fa8ff09d-9062-4955-9b20-5fa20757f1d9	Personal Development	t	active	2021-12-21 11:04:37.543	\N	\N	2021-12-21 11:04:37.543
29a0ab9e-6364-47b6-b63a-1388a7861c6c	Oral Language	t	active	2021-12-21 11:04:37.573	\N	\N	2021-12-21 11:04:37.573
49cbbf19-2ad7-4acb-b8c8-66531578116a	Literacy	t	active	2021-12-21 11:04:37.589	\N	\N	2021-12-21 11:04:37.589
fc06f364-98fe-487f-97fd-d2d6358dccc6	Speech & Language Skills	t	active	2021-12-21 11:04:38.474	\N	\N	2021-12-21 11:04:38.474
0e66242a-4733-4970-a055-d0d6486f8674	Fine Motor Skills	t	active	2021-12-21 11:04:38.551	\N	\N	2021-12-21 11:04:38.551
e63956d9-3a36-40b3-a89d-bd45dc8c3181	Gross Motor Skills	t	active	2021-12-21 11:04:38.586	\N	\N	2021-12-21 11:04:38.586
bd55fd6b-73ef-41ed-8a86-d7bbc501e773	Whole-Child	t	active	2021-12-21 11:04:37.604	\N	\N	2021-12-21 11:04:37.604
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	Knowledge	t	active	2021-12-21 11:04:37.62	\N	\N	2021-12-21 11:04:37.62
2a637bea-c529-4868-8269-d0936696da7e	Language and Numeracy Skills	t	active	2021-12-21 11:04:37.657	\N	\N	2021-12-21 11:04:37.657
6933de3e-a568-4d56-8c01-e110bda22926	Fine Motor Skills	t	active	2021-12-21 11:04:37.68	\N	\N	2021-12-21 11:04:37.68
3af9f093-4153-4348-a097-986c15d1f912	Gross Motor Skills 	t	active	2021-12-21 11:04:37.706	\N	\N	2021-12-21 11:04:37.706
a11a6f56-3ae3-4b70-8daa-30cdb63ef5b6	Cognitive	t	active	2021-12-21 11:04:37.782	\N	\N	2021-12-21 11:04:37.782
aebc88cd-0673-487b-a194-06e3958670a4	Personal Development	t	active	2021-12-21 11:04:38.349	\N	\N	2021-12-21 11:04:38.349
22520430-b13e-43ba-930f-fd051bbbc42a	Oral Language	t	active	2021-12-21 11:04:38.371	\N	\N	2021-12-21 11:04:38.371
c3175001-2d1e-4b00-aacf-d188f4ae5cdf	Literacy	t	active	2021-12-21 11:04:38.39	\N	\N	2021-12-21 11:04:38.39
76cc6f90-86ef-48b7-9138-7b2f0bc378e7	Personal Development	t	active	2021-12-21 11:04:36.97	\N	\N	2021-12-21 11:04:36.97
1080d319-8ce7-4378-9c71-a5019d6b9386	Speech & Language Skills	t	active	2021-12-21 11:04:36.987	\N	\N	2021-12-21 11:04:36.987
d1783a8c-6bcd-492a-ad17-37386df80c56	Gross Motor Skills	t	active	2021-12-21 11:04:37.166	\N	\N	2021-12-21 11:04:37.166
1ef6ca6c-fbc4-4422-a5cb-2bcd999e4b2b	Cognitive Skills	t	active	2021-12-21 11:04:37.183	\N	\N	2021-12-21 11:04:37.183
8488eeac-28bd-4f86-8093-9853b19f51db	Personal Development	t	active	2021-12-21 11:04:37.212	\N	\N	2021-12-21 11:04:37.212
b8c76823-150d-4d83-861e-dce7d7bc4f6d	Speech & Language Skills	t	active	2021-12-21 11:04:37.26	\N	\N	2021-12-21 11:04:37.26
b4cd42b8-a09b-4f66-a03a-b9f6b6f69895	Fine Motor Skills	t	active	2021-12-21 11:04:37.278	\N	\N	2021-12-21 11:04:37.278
19ac71c4-04e4-4d1c-8526-1acb292b7137	Whole-Child	t	active	2021-12-21 11:04:38.414	\N	\N	2021-12-21 11:04:38.414
7826ff58-25d0-41f1-b38e-3e3a77ed32f6	Social and Emotional	t	active	2021-12-21 11:04:38.958	\N	\N	2021-12-21 11:04:38.958
5c75ab94-c4c8-43b6-a43b-b439f449a7fb	Personal Development	t	active	2021-12-21 11:04:37.972	\N	\N	2021-12-21 11:04:37.972
ae82bafe-6513-4288-8951-18d93c07e3f1	Oral Language	t	active	2021-12-21 11:04:37.99	\N	\N	2021-12-21 11:04:37.99
4b247e7e-dcf9-46a6-a477-a69635142d14	Oral Language	t	active	2021-12-21 11:04:38.664	\N	\N	2021-12-21 11:04:38.664
880bc0fd-0209-4f72-999d-3103f9577edf	Whole-Child	t	active	2021-12-21 11:04:38.698	\N	\N	2021-12-21 11:04:38.698
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	Knowledge	t	active	2021-12-21 11:04:38.766	\N	\N	2021-12-21 11:04:38.766
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	Speech & Language Skills	t	active	2021-12-21 11:04:38.855	\N	\N	2021-12-21 11:04:38.855
da9fa132-dcf7-4148-9037-b381850ba088	Fine Motor Skills	t	active	2021-12-21 11:04:38.875	\N	\N	2021-12-21 11:04:38.875
585f38e6-f7be-45f2-855a-f2a4bddca125	Gross Motor Skills	t	active	2021-12-21 11:04:38.891	\N	\N	2021-12-21 11:04:38.891
c3ea1b4a-d220-4248-9b3f-07559b415c56	Cognitive Skills	t	active	2021-12-21 11:04:38.912	\N	\N	2021-12-21 11:04:38.912
59565e03-8d8f-4475-a231-cfc551f004b5	Literacy	t	active	2021-12-21 11:04:38.68	\N	\N	2021-12-21 11:04:38.68
1bb26398-3e38-441e-9a8a-460057f2d8c0	Speech & Language Skills	t	active	2021-12-21 11:04:38.981	\N	\N	2021-12-21 11:04:38.981
e65ea6b4-7093-490a-927e-d2235643f6ca	Fine Motor Skills	t	active	2021-12-21 11:04:39	\N	\N	2021-12-21 11:04:39
88fff890-d614-4b88-be57-b7441fa40b66	Gross Motor Skills	t	active	2021-12-21 11:04:39.019	\N	\N	2021-12-21 11:04:39.019
b18d60c6-a545-46ff-8988-cd5d46ab9660	Cognitive Skills	t	active	2021-12-21 11:04:39.044	\N	\N	2021-12-21 11:04:39.044
2d5ea951-836c-471e-996e-76823a992689	None Specified	t	active	2021-12-21 11:04:36.751	\N	\N	2021-12-21 11:04:36.751
84b8f87a-7b61-4580-a190-a9ce3fe90dd3	Speech & Language Skills	t	active	2021-12-21 11:04:36.844	\N	\N	2021-12-21 11:04:36.844
ce9014a4-01a9-49d5-bf10-6b08bc454fc1	Fine Motor Skills	t	active	2021-12-21 11:04:36.866	\N	\N	2021-12-21 11:04:36.866
61996d3d-a37d-4873-bcdc-03b22fc6977e	Gross Motor Skills	t	active	2021-12-21 11:04:36.882	\N	\N	2021-12-21 11:04:36.882
e08f3578-a7d4-4cac-b028-ef7a8c93f53f	Cognitive Skills	t	active	2021-12-21 11:04:36.954	\N	\N	2021-12-21 11:04:36.954
07786ea3-ac7b-43e0-bb91-6cd813318185	Gross Motor Skills	t	active	2021-12-21 11:04:38.262	\N	\N	2021-12-21 11:04:38.262
c3f73955-26f0-49bf-91f7-8c42c81fb9d3	Cognitive Skills	t	active	2021-12-21 11:04:38.283	\N	\N	2021-12-21 11:04:38.283
665616dd-32c2-44c4-91c9-63f7493c9fd3	Social and Emotional	t	active	2021-12-21 11:04:37.798	\N	\N	2021-12-21 11:04:37.798
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	Speech & Language Skills	t	active	2021-12-21 11:04:37.816	\N	\N	2021-12-21 11:04:37.816
59c47920-4d0d-477c-a33b-06e7f13873d7	Fine Motor Skills	t	active	2021-12-21 11:04:37.85	\N	\N	2021-12-21 11:04:37.85
7e887129-1e7d-40dc-8caa-5e1e0197fb4d	Gross Motor Skills	t	active	2021-12-21 11:04:37.872	\N	\N	2021-12-21 11:04:37.872
9e35379a-c333-4471-937e-ac9eeb89cc77	Cognitive Skills	t	active	2021-12-21 11:04:37.95	\N	\N	2021-12-21 11:04:37.95
8d464354-16d9-41af-b887-103f18f4b376	Whole-Child	t	active	2021-12-21 11:04:39.147	\N	\N	2021-12-21 11:04:39.147
dfed32b5-f0bd-42ea-999b-e10b376038d5	Knowledge	t	active	2021-12-21 11:04:39.166	\N	\N	2021-12-21 11:04:39.166
70d1dff5-4b5a-4029-98e8-8d9fd531b509	Science	t	active	2021-12-21 11:04:39.189	\N	\N	2021-12-21 11:04:39.189
17e2dc7e-4911-4a73-9ff0-06baba99900f	Mathematics	t	active	2021-12-21 11:04:39.211	\N	\N	2021-12-21 11:04:39.211
51ae3bca-0e55-465c-8302-6fdf132fa316	Cognitive	t	active	2021-12-21 11:04:39.228	\N	\N	2021-12-21 11:04:39.228
1d3b076f-0968-4a06-bbaa-18cff13f3db8	Oral Language	t	active	2021-12-21 11:04:39.243	\N	\N	2021-12-21 11:04:39.243
dafb0af8-877f-4af4-99b1-79d1a67de059	Whole Child	t	active	2021-12-21 11:04:39.263	\N	\N	2021-12-21 11:04:39.263
e06ad483-085c-4869-bd88-56d17c7810a0	Personal Development	t	active	2021-12-21 11:04:37.094	\N	\N	2021-12-21 11:04:37.094
1cc44ecc-153a-47e9-b6e8-3b1ef94a9dee	Speech & Language Skills	t	active	2021-12-21 11:04:37.114	\N	\N	2021-12-21 11:04:37.114
0523610d-cf11-47b6-b7ab-bdbf8c3e09b6	Fine Motor Skills	t	active	2021-12-21 11:04:37.138	\N	\N	2021-12-21 11:04:37.138
c83fd174-6504-4cc3-9175-2728d023c39d	Personal Development	t	active	2021-12-21 11:04:39.072	\N	\N	2021-12-21 11:04:39.072
d17f1bee-cdef-4759-8c23-3e9b64d08ec1	Oral Language	t	active	2021-12-21 11:04:39.095	\N	\N	2021-12-21 11:04:39.095
dd59f36d-717f-4982-9ae6-df32537faba0	Literacy	t	active	2021-12-21 11:04:39.121	\N	\N	2021-12-21 11:04:39.121
\.


--
-- Data for Name: category_subcategories_subcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category_subcategories_subcategory ("categoryId", "subcategoryId") FROM stdin;
2d5ea951-836c-471e-996e-76823a992689	40a232cd-d6e8-4ec1-97ec-4e4df7d00a78
84b8f87a-7b61-4580-a190-a9ce3fe90dd3	2b6b5d54-0243-4c7e-917a-1627f107f198
84b8f87a-7b61-4580-a190-a9ce3fe90dd3	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
84b8f87a-7b61-4580-a190-a9ce3fe90dd3	2d1152a3-fb03-4c4e-aeba-98856c3241bd
ce9014a4-01a9-49d5-bf10-6b08bc454fc1	963729a4-7853-49d2-b75d-2c61d291afee
61996d3d-a37d-4873-bcdc-03b22fc6977e	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
e08f3578-a7d4-4cac-b028-ef7a8c93f53f	b32321db-3b4a-4b1e-8db9-c485d045bf01
76cc6f90-86ef-48b7-9138-7b2f0bc378e7	ba77f705-9087-4424-bff9-50fcd0b1731e
1080d319-8ce7-4378-9c71-a5019d6b9386	2d1152a3-fb03-4c4e-aeba-98856c3241bd
1080d319-8ce7-4378-9c71-a5019d6b9386	43c9d2c5-7a23-42c9-8ad9-1132fb9c3853
1080d319-8ce7-4378-9c71-a5019d6b9386	8d49bbbb-b230-4d5a-900b-cde6283519a3
1080d319-8ce7-4378-9c71-a5019d6b9386	ed88dcc7-30e4-4ec7-bccd-34aaacb47139
1080d319-8ce7-4378-9c71-a5019d6b9386	1cb17f8a-d516-498c-97ea-8ad4d7a0c018
1080d319-8ce7-4378-9c71-a5019d6b9386	cd06e622-a323-40f3-8409-5384395e00d2
1080d319-8ce7-4378-9c71-a5019d6b9386	81b09f61-4509-4ce0-b099-c208e62870f9
1080d319-8ce7-4378-9c71-a5019d6b9386	39ac1475-4ade-4d0b-b79a-f31256521297
f9d82bdd-4ee2-49dd-a707-133407cdef19	963729a4-7853-49d2-b75d-2c61d291afee
a1c26321-e3a7-4ff2-9f1c-bb1c5e420fb7	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
a1c26321-e3a7-4ff2-9f1c-bb1c5e420fb7	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
a1c26321-e3a7-4ff2-9f1c-bb1c5e420fb7	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
c12f363a-633b-4080-bd2b-9ced8d034379	2d1152a3-fb03-4c4e-aeba-98856c3241bd
c12f363a-633b-4080-bd2b-9ced8d034379	43c9d2c5-7a23-42c9-8ad9-1132fb9c3853
c12f363a-633b-4080-bd2b-9ced8d034379	8d49bbbb-b230-4d5a-900b-cde6283519a3
c12f363a-633b-4080-bd2b-9ced8d034379	ed88dcc7-30e4-4ec7-bccd-34aaacb47139
c12f363a-633b-4080-bd2b-9ced8d034379	1cb17f8a-d516-498c-97ea-8ad4d7a0c018
c12f363a-633b-4080-bd2b-9ced8d034379	cd06e622-a323-40f3-8409-5384395e00d2
c12f363a-633b-4080-bd2b-9ced8d034379	81b09f61-4509-4ce0-b099-c208e62870f9
c12f363a-633b-4080-bd2b-9ced8d034379	39ac1475-4ade-4d0b-b79a-f31256521297
e06ad483-085c-4869-bd88-56d17c7810a0	ba77f705-9087-4424-bff9-50fcd0b1731e
e06ad483-085c-4869-bd88-56d17c7810a0	824bb6cb-0169-4335-b7a5-6ece2b929da3
1cc44ecc-153a-47e9-b6e8-3b1ef94a9dee	cd06e622-a323-40f3-8409-5384395e00d2
1cc44ecc-153a-47e9-b6e8-3b1ef94a9dee	81b09f61-4509-4ce0-b099-c208e62870f9
1cc44ecc-153a-47e9-b6e8-3b1ef94a9dee	39ac1475-4ade-4d0b-b79a-f31256521297
0523610d-cf11-47b6-b7ab-bdbf8c3e09b6	963729a4-7853-49d2-b75d-2c61d291afee
0523610d-cf11-47b6-b7ab-bdbf8c3e09b6	bf89c192-93dd-4192-97ab-f37198548ead
d1783a8c-6bcd-492a-ad17-37386df80c56	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
d1783a8c-6bcd-492a-ad17-37386df80c56	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
d1783a8c-6bcd-492a-ad17-37386df80c56	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
1ef6ca6c-fbc4-4422-a5cb-2bcd999e4b2b	cd06e622-a323-40f3-8409-5384395e00d2
1ef6ca6c-fbc4-4422-a5cb-2bcd999e4b2b	81b09f61-4509-4ce0-b099-c208e62870f9
1ef6ca6c-fbc4-4422-a5cb-2bcd999e4b2b	39ac1475-4ade-4d0b-b79a-f31256521297
1ef6ca6c-fbc4-4422-a5cb-2bcd999e4b2b	19803be1-0503-4232-afc1-e6ef06186523
8488eeac-28bd-4f86-8093-9853b19f51db	ba77f705-9087-4424-bff9-50fcd0b1731e
8488eeac-28bd-4f86-8093-9853b19f51db	824bb6cb-0169-4335-b7a5-6ece2b929da3
b8c76823-150d-4d83-861e-dce7d7bc4f6d	2b6b5d54-0243-4c7e-917a-1627f107f198
b8c76823-150d-4d83-861e-dce7d7bc4f6d	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
b8c76823-150d-4d83-861e-dce7d7bc4f6d	2d1152a3-fb03-4c4e-aeba-98856c3241bd
b8c76823-150d-4d83-861e-dce7d7bc4f6d	3fca3a2b-97b6-4ec9-a5b1-1d0ef5f1b445
b8c76823-150d-4d83-861e-dce7d7bc4f6d	9a9882f1-d890-461c-a710-ca37fb78ddf5
b8c76823-150d-4d83-861e-dce7d7bc4f6d	0fd7d721-df1b-41eb-baa4-08ba4ac2b2e7
b4cd42b8-a09b-4f66-a03a-b9f6b6f69895	963729a4-7853-49d2-b75d-2c61d291afee
b4cd42b8-a09b-4f66-a03a-b9f6b6f69895	bf89c192-93dd-4192-97ab-f37198548ead
bcfd9d76-cf05-4ccd-9a41-6b886da661be	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
bcfd9d76-cf05-4ccd-9a41-6b886da661be	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
bcfd9d76-cf05-4ccd-9a41-6b886da661be	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
c909acad-0c52-4fd3-8427-3b1e90a730da	b32321db-3b4a-4b1e-8db9-c485d045bf01
c909acad-0c52-4fd3-8427-3b1e90a730da	f385c1ec-6cfa-4f49-a219-fd28374cf2a6
fa8ff09d-9062-4955-9b20-5fa20757f1d9	ba77f705-9087-4424-bff9-50fcd0b1731e
fa8ff09d-9062-4955-9b20-5fa20757f1d9	824bb6cb-0169-4335-b7a5-6ece2b929da3
29a0ab9e-6364-47b6-b63a-1388a7861c6c	2d1152a3-fb03-4c4e-aeba-98856c3241bd
29a0ab9e-6364-47b6-b63a-1388a7861c6c	b2cc7a69-4e64-4e97-9587-0078dccd845a
29a0ab9e-6364-47b6-b63a-1388a7861c6c	843e4fea-7f4d-4746-87ff-693f5a44b467
29a0ab9e-6364-47b6-b63a-1388a7861c6c	5bb19c81-9261-428e-95ed-c87cc9f0560b
49cbbf19-2ad7-4acb-b8c8-66531578116a	9b955fb9-8eda-4469-bd31-4e8f91192663
49cbbf19-2ad7-4acb-b8c8-66531578116a	644ba535-904c-4919-8b8c-688df2b6f7ee
bd55fd6b-73ef-41ed-8a86-d7bbc501e773	0e6b1c2b-5e2f-47e1-8422-2a183f3e15c7
bd55fd6b-73ef-41ed-8a86-d7bbc501e773	96f81756-70e3-41e5-9143-740376574e35
bd55fd6b-73ef-41ed-8a86-d7bbc501e773	144a3478-1946-4460-a965-0d7d74e63d65
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	cd06e622-a323-40f3-8409-5384395e00d2
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	81b09f61-4509-4ce0-b099-c208e62870f9
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	6fb79402-2fb6-4415-874c-338c949332ed
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	5b405510-384a-4721-a526-e12b3cbf2092
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	9a52fb0a-6ce8-45df-92a0-f25b5d3d2344
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	4114f381-a7c5-4e88-be84-2bef4eb04ad0
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	f4b07251-1d67-4a84-bcda-86c71cbf9cfd
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	49e73e4f-8ffc-47e3-9b87-0f9686d361d7
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	852c3495-1ced-4580-a584-9d475217f3d5
dd3dbf0c-2872-433b-8b61-9ea78f3c9e97	3b148168-31d0-4bef-9152-63c3ff516180
2a637bea-c529-4868-8269-d0936696da7e	2d1152a3-fb03-4c4e-aeba-98856c3241bd
2a637bea-c529-4868-8269-d0936696da7e	8d49bbbb-b230-4d5a-900b-cde6283519a3
2a637bea-c529-4868-8269-d0936696da7e	ddf87dff-1eb0-4971-9b27-2aaa534f34b1
2a637bea-c529-4868-8269-d0936696da7e	c06b848d-8769-44e9-8dc7-929588cec0bc
2a637bea-c529-4868-8269-d0936696da7e	01191172-b276-449f-ab11-8e66e990941e
2a637bea-c529-4868-8269-d0936696da7e	55cbd434-36ce-4c57-b47e-d7119b578d7e
2a637bea-c529-4868-8269-d0936696da7e	a048cf91-2c96-4306-a7c2-cac2fe1d688a
2a637bea-c529-4868-8269-d0936696da7e	47169b0a-ac39-4e25-bd6e-77eecaf4e051
6933de3e-a568-4d56-8c01-e110bda22926	11351e3f-afc3-476e-b3af-a0c7718269ac
6933de3e-a568-4d56-8c01-e110bda22926	7848bb23-2bb9-4108-938b-51f2f7d1d30f
6933de3e-a568-4d56-8c01-e110bda22926	d50cff7c-b0c7-43be-8ec7-877fa4c9a6fb
6933de3e-a568-4d56-8c01-e110bda22926	e2190c0c-918d-4a05-a045-6696ae31d5c4
6933de3e-a568-4d56-8c01-e110bda22926	a7850bd6-f5fd-4016-b708-7b823784ef0a
6933de3e-a568-4d56-8c01-e110bda22926	bea9244e-ff17-47fc-8e7c-bceadf0f4f6e
3af9f093-4153-4348-a097-986c15d1f912	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
3af9f093-4153-4348-a097-986c15d1f912	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
3af9f093-4153-4348-a097-986c15d1f912	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
3af9f093-4153-4348-a097-986c15d1f912	9c30644b-0e9c-43aa-a19a-442e9f6aa6ae
a11a6f56-3ae3-4b70-8daa-30cdb63ef5b6	4ab80faf-60b9-4cc2-8f51-3d3b7f9fee13
a11a6f56-3ae3-4b70-8daa-30cdb63ef5b6	367c5e70-1487-4b33-96c0-529a37dbc5f2
a11a6f56-3ae3-4b70-8daa-30cdb63ef5b6	e45ff0ff-40a4-4be4-ab26-426aedba7597
a11a6f56-3ae3-4b70-8daa-30cdb63ef5b6	ff838eb9-11b9-4de5-b854-a24d4d526f5e
665616dd-32c2-44c4-91c9-63f7493c9fd3	188c621a-cbc7-42e2-9d01-56f4847682cb
665616dd-32c2-44c4-91c9-63f7493c9fd3	b79735db-91c7-4bcb-860b-fe23902f81ea
665616dd-32c2-44c4-91c9-63f7493c9fd3	6ccc8306-1a9e-42bd-83ff-55bac3449853
665616dd-32c2-44c4-91c9-63f7493c9fd3	c79be603-ccf4-4284-9c8e-61b55ec53067
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	2b6b5d54-0243-4c7e-917a-1627f107f198
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	2d1152a3-fb03-4c4e-aeba-98856c3241bd
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	3fca3a2b-97b6-4ec9-a5b1-1d0ef5f1b445
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	9a9882f1-d890-461c-a710-ca37fb78ddf5
64e000aa-4a2c-4e2e-9d8d-f779e97bdd73	0fd7d721-df1b-41eb-baa4-08ba4ac2b2e7
59c47920-4d0d-477c-a33b-06e7f13873d7	963729a4-7853-49d2-b75d-2c61d291afee
59c47920-4d0d-477c-a33b-06e7f13873d7	bf89c192-93dd-4192-97ab-f37198548ead
7e887129-1e7d-40dc-8caa-5e1e0197fb4d	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
7e887129-1e7d-40dc-8caa-5e1e0197fb4d	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
7e887129-1e7d-40dc-8caa-5e1e0197fb4d	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
9e35379a-c333-4471-937e-ac9eeb89cc77	b32321db-3b4a-4b1e-8db9-c485d045bf01
9e35379a-c333-4471-937e-ac9eeb89cc77	f385c1ec-6cfa-4f49-a219-fd28374cf2a6
5c75ab94-c4c8-43b6-a43b-b439f449a7fb	ba77f705-9087-4424-bff9-50fcd0b1731e
5c75ab94-c4c8-43b6-a43b-b439f449a7fb	824bb6cb-0169-4335-b7a5-6ece2b929da3
ae82bafe-6513-4288-8951-18d93c07e3f1	2d1152a3-fb03-4c4e-aeba-98856c3241bd
ae82bafe-6513-4288-8951-18d93c07e3f1	b2cc7a69-4e64-4e97-9587-0078dccd845a
ae82bafe-6513-4288-8951-18d93c07e3f1	843e4fea-7f4d-4746-87ff-693f5a44b467
c68865b4-2ba3-4608-955c-dcc098291159	01191172-b276-449f-ab11-8e66e990941e
c68865b4-2ba3-4608-955c-dcc098291159	a7850bd6-f5fd-4016-b708-7b823784ef0a
61f517d8-2c2e-47fd-a2de-6e86465abc59	0e6b1c2b-5e2f-47e1-8422-2a183f3e15c7
61f517d8-2c2e-47fd-a2de-6e86465abc59	96f81756-70e3-41e5-9143-740376574e35
61f517d8-2c2e-47fd-a2de-6e86465abc59	144a3478-1946-4460-a965-0d7d74e63d65
26e4aedc-2222-44e1-a375-388b138c695d	cd06e622-a323-40f3-8409-5384395e00d2
26e4aedc-2222-44e1-a375-388b138c695d	81b09f61-4509-4ce0-b099-c208e62870f9
26e4aedc-2222-44e1-a375-388b138c695d	6fb79402-2fb6-4415-874c-338c949332ed
26e4aedc-2222-44e1-a375-388b138c695d	5b405510-384a-4721-a526-e12b3cbf2092
26e4aedc-2222-44e1-a375-388b138c695d	9a52fb0a-6ce8-45df-92a0-f25b5d3d2344
26e4aedc-2222-44e1-a375-388b138c695d	4114f381-a7c5-4e88-be84-2bef4eb04ad0
26e4aedc-2222-44e1-a375-388b138c695d	f4b07251-1d67-4a84-bcda-86c71cbf9cfd
26e4aedc-2222-44e1-a375-388b138c695d	49e73e4f-8ffc-47e3-9b87-0f9686d361d7
26e4aedc-2222-44e1-a375-388b138c695d	852c3495-1ced-4580-a584-9d475217f3d5
26e4aedc-2222-44e1-a375-388b138c695d	3b148168-31d0-4bef-9152-63c3ff516180
bf1cd84d-da71-4111-82c6-e85224ab85ca	2b6b5d54-0243-4c7e-917a-1627f107f198
bf1cd84d-da71-4111-82c6-e85224ab85ca	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
bf1cd84d-da71-4111-82c6-e85224ab85ca	2d1152a3-fb03-4c4e-aeba-98856c3241bd
bf1cd84d-da71-4111-82c6-e85224ab85ca	3fca3a2b-97b6-4ec9-a5b1-1d0ef5f1b445
bf1cd84d-da71-4111-82c6-e85224ab85ca	9a9882f1-d890-461c-a710-ca37fb78ddf5
bf1cd84d-da71-4111-82c6-e85224ab85ca	0fd7d721-df1b-41eb-baa4-08ba4ac2b2e7
ba2db2b5-7f20-4cb7-88ef-cee0fcde7937	963729a4-7853-49d2-b75d-2c61d291afee
ba2db2b5-7f20-4cb7-88ef-cee0fcde7937	bf89c192-93dd-4192-97ab-f37198548ead
07786ea3-ac7b-43e0-bb91-6cd813318185	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
07786ea3-ac7b-43e0-bb91-6cd813318185	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
07786ea3-ac7b-43e0-bb91-6cd813318185	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
c3f73955-26f0-49bf-91f7-8c42c81fb9d3	b32321db-3b4a-4b1e-8db9-c485d045bf01
c3f73955-26f0-49bf-91f7-8c42c81fb9d3	f385c1ec-6cfa-4f49-a219-fd28374cf2a6
aebc88cd-0673-487b-a194-06e3958670a4	ba77f705-9087-4424-bff9-50fcd0b1731e
aebc88cd-0673-487b-a194-06e3958670a4	824bb6cb-0169-4335-b7a5-6ece2b929da3
22520430-b13e-43ba-930f-fd051bbbc42a	2d1152a3-fb03-4c4e-aeba-98856c3241bd
22520430-b13e-43ba-930f-fd051bbbc42a	b2cc7a69-4e64-4e97-9587-0078dccd845a
22520430-b13e-43ba-930f-fd051bbbc42a	843e4fea-7f4d-4746-87ff-693f5a44b467
22520430-b13e-43ba-930f-fd051bbbc42a	5bb19c81-9261-428e-95ed-c87cc9f0560b
c3175001-2d1e-4b00-aacf-d188f4ae5cdf	9b955fb9-8eda-4469-bd31-4e8f91192663
c3175001-2d1e-4b00-aacf-d188f4ae5cdf	644ba535-904c-4919-8b8c-688df2b6f7ee
19ac71c4-04e4-4d1c-8526-1acb292b7137	0e6b1c2b-5e2f-47e1-8422-2a183f3e15c7
19ac71c4-04e4-4d1c-8526-1acb292b7137	96f81756-70e3-41e5-9143-740376574e35
19ac71c4-04e4-4d1c-8526-1acb292b7137	144a3478-1946-4460-a965-0d7d74e63d65
d896bf1a-fb5b-4a57-b833-87b0959ba926	cd06e622-a323-40f3-8409-5384395e00d2
d896bf1a-fb5b-4a57-b833-87b0959ba926	81b09f61-4509-4ce0-b099-c208e62870f9
d896bf1a-fb5b-4a57-b833-87b0959ba926	6fb79402-2fb6-4415-874c-338c949332ed
d896bf1a-fb5b-4a57-b833-87b0959ba926	5b405510-384a-4721-a526-e12b3cbf2092
d896bf1a-fb5b-4a57-b833-87b0959ba926	9a52fb0a-6ce8-45df-92a0-f25b5d3d2344
d896bf1a-fb5b-4a57-b833-87b0959ba926	4114f381-a7c5-4e88-be84-2bef4eb04ad0
d896bf1a-fb5b-4a57-b833-87b0959ba926	f4b07251-1d67-4a84-bcda-86c71cbf9cfd
d896bf1a-fb5b-4a57-b833-87b0959ba926	49e73e4f-8ffc-47e3-9b87-0f9686d361d7
d896bf1a-fb5b-4a57-b833-87b0959ba926	852c3495-1ced-4580-a584-9d475217f3d5
d896bf1a-fb5b-4a57-b833-87b0959ba926	3b148168-31d0-4bef-9152-63c3ff516180
fc06f364-98fe-487f-97fd-d2d6358dccc6	2b6b5d54-0243-4c7e-917a-1627f107f198
fc06f364-98fe-487f-97fd-d2d6358dccc6	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
fc06f364-98fe-487f-97fd-d2d6358dccc6	2d1152a3-fb03-4c4e-aeba-98856c3241bd
fc06f364-98fe-487f-97fd-d2d6358dccc6	3fca3a2b-97b6-4ec9-a5b1-1d0ef5f1b445
fc06f364-98fe-487f-97fd-d2d6358dccc6	9a9882f1-d890-461c-a710-ca37fb78ddf5
fc06f364-98fe-487f-97fd-d2d6358dccc6	0fd7d721-df1b-41eb-baa4-08ba4ac2b2e7
0e66242a-4733-4970-a055-d0d6486f8674	963729a4-7853-49d2-b75d-2c61d291afee
0e66242a-4733-4970-a055-d0d6486f8674	bf89c192-93dd-4192-97ab-f37198548ead
e63956d9-3a36-40b3-a89d-bd45dc8c3181	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
e63956d9-3a36-40b3-a89d-bd45dc8c3181	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
e63956d9-3a36-40b3-a89d-bd45dc8c3181	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
b0b983e4-bf3c-4315-912e-67c8de4f9e11	b32321db-3b4a-4b1e-8db9-c485d045bf01
b0b983e4-bf3c-4315-912e-67c8de4f9e11	f385c1ec-6cfa-4f49-a219-fd28374cf2a6
84619bee-0b1f-447f-8208-4a39f32062c9	ba77f705-9087-4424-bff9-50fcd0b1731e
84619bee-0b1f-447f-8208-4a39f32062c9	824bb6cb-0169-4335-b7a5-6ece2b929da3
4b247e7e-dcf9-46a6-a477-a69635142d14	2d1152a3-fb03-4c4e-aeba-98856c3241bd
4b247e7e-dcf9-46a6-a477-a69635142d14	b2cc7a69-4e64-4e97-9587-0078dccd845a
4b247e7e-dcf9-46a6-a477-a69635142d14	843e4fea-7f4d-4746-87ff-693f5a44b467
59565e03-8d8f-4475-a231-cfc551f004b5	01191172-b276-449f-ab11-8e66e990941e
59565e03-8d8f-4475-a231-cfc551f004b5	a7850bd6-f5fd-4016-b708-7b823784ef0a
59565e03-8d8f-4475-a231-cfc551f004b5	39e96a23-5ac3-47c9-94fc-e71965f75880
880bc0fd-0209-4f72-999d-3103f9577edf	0e6b1c2b-5e2f-47e1-8422-2a183f3e15c7
880bc0fd-0209-4f72-999d-3103f9577edf	96f81756-70e3-41e5-9143-740376574e35
880bc0fd-0209-4f72-999d-3103f9577edf	144a3478-1946-4460-a965-0d7d74e63d65
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	cd06e622-a323-40f3-8409-5384395e00d2
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	81b09f61-4509-4ce0-b099-c208e62870f9
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	6fb79402-2fb6-4415-874c-338c949332ed
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	5b405510-384a-4721-a526-e12b3cbf2092
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	9a52fb0a-6ce8-45df-92a0-f25b5d3d2344
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	4114f381-a7c5-4e88-be84-2bef4eb04ad0
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	f4b07251-1d67-4a84-bcda-86c71cbf9cfd
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	49e73e4f-8ffc-47e3-9b87-0f9686d361d7
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	852c3495-1ced-4580-a584-9d475217f3d5
bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72	3b148168-31d0-4bef-9152-63c3ff516180
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	eb29827a-0053-4eee-83cd-8f4afb1b7cb4
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	ddf87dff-1eb0-4971-9b27-2aaa534f34b1
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	c06b848d-8769-44e9-8dc7-929588cec0bc
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	01191172-b276-449f-ab11-8e66e990941e
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	a7850bd6-f5fd-4016-b708-7b823784ef0a
6090e473-ec19-4bf0-ae5c-2d6a4c793f55	55cbd434-36ce-4c57-b47e-d7119b578d7e
da9fa132-dcf7-4148-9037-b381850ba088	11351e3f-afc3-476e-b3af-a0c7718269ac
da9fa132-dcf7-4148-9037-b381850ba088	7848bb23-2bb9-4108-938b-51f2f7d1d30f
da9fa132-dcf7-4148-9037-b381850ba088	d50cff7c-b0c7-43be-8ec7-877fa4c9a6fb
da9fa132-dcf7-4148-9037-b381850ba088	e2190c0c-918d-4a05-a045-6696ae31d5c4
da9fa132-dcf7-4148-9037-b381850ba088	a7850bd6-f5fd-4016-b708-7b823784ef0a
da9fa132-dcf7-4148-9037-b381850ba088	bea9244e-ff17-47fc-8e7c-bceadf0f4f6e
585f38e6-f7be-45f2-855a-f2a4bddca125	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
585f38e6-f7be-45f2-855a-f2a4bddca125	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
585f38e6-f7be-45f2-855a-f2a4bddca125	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
c3ea1b4a-d220-4248-9b3f-07559b415c56	b9d5a570-5be3-491b-9fdc-d26ea1c13847
c3ea1b4a-d220-4248-9b3f-07559b415c56	9a1e0589-0361-40e1-851c-b95b641e271e
c3ea1b4a-d220-4248-9b3f-07559b415c56	8d3f987a-7f7c-4035-a709-9526060b2177
7826ff58-25d0-41f1-b38e-3e3a77ed32f6	188c621a-cbc7-42e2-9d01-56f4847682cb
7826ff58-25d0-41f1-b38e-3e3a77ed32f6	b79735db-91c7-4bcb-860b-fe23902f81ea
7826ff58-25d0-41f1-b38e-3e3a77ed32f6	6ccc8306-1a9e-42bd-83ff-55bac3449853
7826ff58-25d0-41f1-b38e-3e3a77ed32f6	c79be603-ccf4-4284-9c8e-61b55ec53067
1bb26398-3e38-441e-9a8a-460057f2d8c0	2b6b5d54-0243-4c7e-917a-1627f107f198
1bb26398-3e38-441e-9a8a-460057f2d8c0	8b955cbc-6808-49b2-adc0-5bec8b59f4fe
1bb26398-3e38-441e-9a8a-460057f2d8c0	2d1152a3-fb03-4c4e-aeba-98856c3241bd
1bb26398-3e38-441e-9a8a-460057f2d8c0	3fca3a2b-97b6-4ec9-a5b1-1d0ef5f1b445
1bb26398-3e38-441e-9a8a-460057f2d8c0	9a9882f1-d890-461c-a710-ca37fb78ddf5
1bb26398-3e38-441e-9a8a-460057f2d8c0	0fd7d721-df1b-41eb-baa4-08ba4ac2b2e7
e65ea6b4-7093-490a-927e-d2235643f6ca	963729a4-7853-49d2-b75d-2c61d291afee
e65ea6b4-7093-490a-927e-d2235643f6ca	bf89c192-93dd-4192-97ab-f37198548ead
88fff890-d614-4b88-be57-b7441fa40b66	bd7adbd0-9ce7-4c50-aa8e-85b842683fb5
88fff890-d614-4b88-be57-b7441fa40b66	f78c01f9-4b8a-480c-8c4b-80d1ec1747a7
88fff890-d614-4b88-be57-b7441fa40b66	f5a1e3a6-c0b1-4b2f-991f-9df7897dac67
b18d60c6-a545-46ff-8988-cd5d46ab9660	b32321db-3b4a-4b1e-8db9-c485d045bf01
b18d60c6-a545-46ff-8988-cd5d46ab9660	f385c1ec-6cfa-4f49-a219-fd28374cf2a6
c83fd174-6504-4cc3-9175-2728d023c39d	ba77f705-9087-4424-bff9-50fcd0b1731e
c83fd174-6504-4cc3-9175-2728d023c39d	824bb6cb-0169-4335-b7a5-6ece2b929da3
d17f1bee-cdef-4759-8c23-3e9b64d08ec1	2d1152a3-fb03-4c4e-aeba-98856c3241bd
d17f1bee-cdef-4759-8c23-3e9b64d08ec1	b2cc7a69-4e64-4e97-9587-0078dccd845a
d17f1bee-cdef-4759-8c23-3e9b64d08ec1	843e4fea-7f4d-4746-87ff-693f5a44b467
d17f1bee-cdef-4759-8c23-3e9b64d08ec1	ec1d6481-ab50-42b6-a4b5-1a5fb98796d0
dd59f36d-717f-4982-9ae6-df32537faba0	9b955fb9-8eda-4469-bd31-4e8f91192663
dd59f36d-717f-4982-9ae6-df32537faba0	644ba535-904c-4919-8b8c-688df2b6f7ee
8d464354-16d9-41af-b887-103f18f4b376	0e6b1c2b-5e2f-47e1-8422-2a183f3e15c7
8d464354-16d9-41af-b887-103f18f4b376	96f81756-70e3-41e5-9143-740376574e35
8d464354-16d9-41af-b887-103f18f4b376	144a3478-1946-4460-a965-0d7d74e63d65
dfed32b5-f0bd-42ea-999b-e10b376038d5	cd06e622-a323-40f3-8409-5384395e00d2
dfed32b5-f0bd-42ea-999b-e10b376038d5	81b09f61-4509-4ce0-b099-c208e62870f9
dfed32b5-f0bd-42ea-999b-e10b376038d5	6fb79402-2fb6-4415-874c-338c949332ed
dfed32b5-f0bd-42ea-999b-e10b376038d5	5b405510-384a-4721-a526-e12b3cbf2092
dfed32b5-f0bd-42ea-999b-e10b376038d5	9a52fb0a-6ce8-45df-92a0-f25b5d3d2344
dfed32b5-f0bd-42ea-999b-e10b376038d5	4114f381-a7c5-4e88-be84-2bef4eb04ad0
dfed32b5-f0bd-42ea-999b-e10b376038d5	f4b07251-1d67-4a84-bcda-86c71cbf9cfd
dfed32b5-f0bd-42ea-999b-e10b376038d5	49e73e4f-8ffc-47e3-9b87-0f9686d361d7
dfed32b5-f0bd-42ea-999b-e10b376038d5	852c3495-1ced-4580-a584-9d475217f3d5
dfed32b5-f0bd-42ea-999b-e10b376038d5	3b148168-31d0-4bef-9152-63c3ff516180
70d1dff5-4b5a-4029-98e8-8d9fd531b509	3e7c719b-aa3c-45c3-87ac-08ae0e6138b1
70d1dff5-4b5a-4029-98e8-8d9fd531b509	b60f9fa0-a160-42e2-9cea-9ec39de2692a
70d1dff5-4b5a-4029-98e8-8d9fd531b509	7dfc3b4c-3037-42f6-89be-75839e8ab40d
70d1dff5-4b5a-4029-98e8-8d9fd531b509	60c8428a-98db-445f-9a91-fbddb20eb315
70d1dff5-4b5a-4029-98e8-8d9fd531b509	db49ef2b-e680-488f-a241-dd5c0f0ee727
70d1dff5-4b5a-4029-98e8-8d9fd531b509	eca38066-c702-4ca0-a1e7-420d8becf687
70d1dff5-4b5a-4029-98e8-8d9fd531b509	92055ac9-45a8-4905-b713-e7b6473593f6
70d1dff5-4b5a-4029-98e8-8d9fd531b509	b39b4fe4-2bc1-4d92-a8e3-ce163f6a3306
70d1dff5-4b5a-4029-98e8-8d9fd531b509	00878904-73cc-4fb8-8ef6-9676cf89dd74
70d1dff5-4b5a-4029-98e8-8d9fd531b509	fe0766c7-0c91-4652-b1fe-e949590cb9a2
70d1dff5-4b5a-4029-98e8-8d9fd531b509	e601b3ef-5bcc-4dda-bf37-47244a63d067
70d1dff5-4b5a-4029-98e8-8d9fd531b509	76cc0ed5-c00c-42f3-9e3b-7d1355e2d9c0
17e2dc7e-4911-4a73-9ff0-06baba99900f	26654f67-ddc4-493d-9bc3-f260d8125d20
17e2dc7e-4911-4a73-9ff0-06baba99900f	485eb5a6-73a3-497e-8d19-51cd9c10b323
17e2dc7e-4911-4a73-9ff0-06baba99900f	c9dd0e2a-608c-4833-9bf6-b73d51dfd7eb
17e2dc7e-4911-4a73-9ff0-06baba99900f	4c523f7b-88ca-4e47-b0e3-27b66caf696b
17e2dc7e-4911-4a73-9ff0-06baba99900f	c5e36c28-2d3d-43e1-b35a-2cd9a60a30c9
51ae3bca-0e55-465c-8302-6fdf132fa316	b9d5a570-5be3-491b-9fdc-d26ea1c13847
51ae3bca-0e55-465c-8302-6fdf132fa316	9a1e0589-0361-40e1-851c-b95b641e271e
51ae3bca-0e55-465c-8302-6fdf132fa316	8d3f987a-7f7c-4035-a709-9526060b2177
51ae3bca-0e55-465c-8302-6fdf132fa316	56ec83c8-39c7-462e-bd2b-365f2a7aae72
1d3b076f-0968-4a06-bbaa-18cff13f3db8	2d1152a3-fb03-4c4e-aeba-98856c3241bd
1d3b076f-0968-4a06-bbaa-18cff13f3db8	843e4fea-7f4d-4746-87ff-693f5a44b467
dafb0af8-877f-4af4-99b1-79d1a67de059	144a3478-1946-4460-a965-0d7d74e63d65
dafb0af8-877f-4af4-99b1-79d1a67de059	5fff3596-42e9-416d-a2d2-29bc885fbb76
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	38c17083-2ef7-402b-824a-20c38e3c57f4
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	9b955fb9-8eda-4469-bd31-4e8f91192663
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	ddf87dff-1eb0-4971-9b27-2aaa534f34b1
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	644ba535-904c-4919-8b8c-688df2b6f7ee
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	c06b848d-8769-44e9-8dc7-929588cec0bc
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	b2cc7a69-4e64-4e97-9587-0078dccd845a
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	843e4fea-7f4d-4746-87ff-693f5a44b467
0f4810e7-5ce1-47e1-8aeb-43b73f15b007	2d1152a3-fb03-4c4e-aeba-98856c3241bd
d5995392-11cb-4d28-a96d-8bdcd3f0436b	7d3b5cb0-d9d2-42e8-b1f7-f58743edffdf
d5995392-11cb-4d28-a96d-8bdcd3f0436b	8eb1ba6c-4bac-457c-a798-821ddafcedee
d5995392-11cb-4d28-a96d-8bdcd3f0436b	223f3157-feb2-41ea-8c03-8a355b67343c
d5995392-11cb-4d28-a96d-8bdcd3f0436b	bf89c192-93dd-4192-97ab-f37198548ead
d5995392-11cb-4d28-a96d-8bdcd3f0436b	94a39407-035c-46e0-a039-357a33e9723a
94013867-72d1-44e2-a43d-7336818f35d0	144a3478-1946-4460-a965-0d7d74e63d65
2b9d6317-298b-4aa5-9aea-aed56bd07823	6ff4c1af-252b-4e07-9537-94eaa20e0958
2b9d6317-298b-4aa5-9aea-aed56bd07823	1a99684a-ff8c-44f4-9793-de96cd4ce0a4
2b9d6317-298b-4aa5-9aea-aed56bd07823	f385c1ec-6cfa-4f49-a219-fd28374cf2a6
fc447234-af24-4768-b617-ac1b80ebae9b	e754e22c-fd2a-43f3-a4ec-1904848f9bd6
d68c6c5d-c739-46d8-be70-e70d6c565949	852c3495-1ced-4580-a584-9d475217f3d5
d68c6c5d-c739-46d8-be70-e70d6c565949	3b148168-31d0-4bef-9152-63c3ff516180
d68c6c5d-c739-46d8-be70-e70d6c565949	cd06e622-a323-40f3-8409-5384395e00d2
d68c6c5d-c739-46d8-be70-e70d6c565949	81b09f61-4509-4ce0-b099-c208e62870f9
d68c6c5d-c739-46d8-be70-e70d6c565949	6fb79402-2fb6-4415-874c-338c949332ed
d68c6c5d-c739-46d8-be70-e70d6c565949	5b405510-384a-4721-a526-e12b3cbf2092
d68c6c5d-c739-46d8-be70-e70d6c565949	9a52fb0a-6ce8-45df-92a0-f25b5d3d2344
d68c6c5d-c739-46d8-be70-e70d6c565949	4114f381-a7c5-4e88-be84-2bef4eb04ad0
d68c6c5d-c739-46d8-be70-e70d6c565949	f4b07251-1d67-4a84-bcda-86c71cbf9cfd
d68c6c5d-c739-46d8-be70-e70d6c565949	49e73e4f-8ffc-47e3-9b87-0f9686d361d7
\.


--
-- Data for Name: class; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class (class_id, class_name, status, shortcode, deleted_at, "organizationOrganizationId", created_at, updated_at) FROM stdin;
8b09033d-7db9-46c3-aeb8-138c9e7eff96	OC Tester	active	X0K5KZFBWM	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-10 14:20:21.54	2022-01-10 14:20:21.54
8f4f696a-f935-412d-8134-d53062cea38e	Load test	active	28VYQ1C6D1	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-17 19:41:54.298	2022-01-17 19:41:54.298
930e9e1a-4ca1-482d-a1b3-20599b2e2dac	test-713637570	active	666SE177PB	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-17 20:55:08.29	2022-01-17 20:55:08.29
aa0b2ece-8052-43c9-93c2-2431a86cb198	OC Load Class	inactive	58S7G1M75U	2022-01-19 10:26:11.305	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 10:24:15.185	2022-01-19 10:26:11.307
\.


--
-- Data for Name: class_age_ranges_age_range; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_age_ranges_age_range ("classClassId", "ageRangeId") FROM stdin;
8b09033d-7db9-46c3-aeb8-138c9e7eff96	7965d220-619d-400f-8cab-42bd98c7d23c
8b09033d-7db9-46c3-aeb8-138c9e7eff96	bb7982cd-020f-4e1a-93fc-4a6874917f07
8b09033d-7db9-46c3-aeb8-138c9e7eff96	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
8b09033d-7db9-46c3-aeb8-138c9e7eff96	145edddc-2019-43d9-97e1-c5830e7ed689
8b09033d-7db9-46c3-aeb8-138c9e7eff96	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
8f4f696a-f935-412d-8134-d53062cea38e	7965d220-619d-400f-8cab-42bd98c7d23c
aa0b2ece-8052-43c9-93c2-2431a86cb198	7965d220-619d-400f-8cab-42bd98c7d23c
aa0b2ece-8052-43c9-93c2-2431a86cb198	bb7982cd-020f-4e1a-93fc-4a6874917f07
aa0b2ece-8052-43c9-93c2-2431a86cb198	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
aa0b2ece-8052-43c9-93c2-2431a86cb198	145edddc-2019-43d9-97e1-c5830e7ed689
aa0b2ece-8052-43c9-93c2-2431a86cb198	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
\.


--
-- Data for Name: class_grades_grade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_grades_grade ("classClassId", "gradeId") FROM stdin;
8b09033d-7db9-46c3-aeb8-138c9e7eff96	d7e2e258-d4b3-4e95-b929-49ae702de4be
8b09033d-7db9-46c3-aeb8-138c9e7eff96	3e7979f6-7375-450a-9818-ddb09b250bb2
8b09033d-7db9-46c3-aeb8-138c9e7eff96	0ecb8fa9-d77e-4dd3-b220-7e79704f1b03
8b09033d-7db9-46c3-aeb8-138c9e7eff96	66fcda51-33c8-4162-a8d1-0337e1d6ade3
8b09033d-7db9-46c3-aeb8-138c9e7eff96	a9f0217d-f7ec-4add-950d-4e8986ab2c82
8b09033d-7db9-46c3-aeb8-138c9e7eff96	e4d16af5-5b8f-4051-b065-13acf6c694be
8b09033d-7db9-46c3-aeb8-138c9e7eff96	9d3e591d-06a6-4fc4-9714-cf155a15b415
8b09033d-7db9-46c3-aeb8-138c9e7eff96	81dcbcc6-3d70-4bdf-99bc-14833c57c628
8b09033d-7db9-46c3-aeb8-138c9e7eff96	100f774a-3d7e-4be5-9c2c-ae70f40f0b50
8b09033d-7db9-46c3-aeb8-138c9e7eff96	b20eaf10-3e40-4ef7-9d74-93a13782d38f
8b09033d-7db9-46c3-aeb8-138c9e7eff96	89d71050-186e-4fb2-8cbd-9598ca312be9
8b09033d-7db9-46c3-aeb8-138c9e7eff96	abc900b9-5b8c-4e54-a4a8-54f102b2c1c6
8b09033d-7db9-46c3-aeb8-138c9e7eff96	3ee3fd4c-6208-494f-9551-d48fabc4f42a
8b09033d-7db9-46c3-aeb8-138c9e7eff96	781e8a08-29e8-4171-8392-7e8ac9f183a0
8b09033d-7db9-46c3-aeb8-138c9e7eff96	98461ca1-06a1-432a-97d0-4e1dff33e1a5
8f4f696a-f935-412d-8134-d53062cea38e	98461ca1-06a1-432a-97d0-4e1dff33e1a5
aa0b2ece-8052-43c9-93c2-2431a86cb198	d7e2e258-d4b3-4e95-b929-49ae702de4be
aa0b2ece-8052-43c9-93c2-2431a86cb198	3e7979f6-7375-450a-9818-ddb09b250bb2
aa0b2ece-8052-43c9-93c2-2431a86cb198	0ecb8fa9-d77e-4dd3-b220-7e79704f1b03
aa0b2ece-8052-43c9-93c2-2431a86cb198	66fcda51-33c8-4162-a8d1-0337e1d6ade3
aa0b2ece-8052-43c9-93c2-2431a86cb198	a9f0217d-f7ec-4add-950d-4e8986ab2c82
aa0b2ece-8052-43c9-93c2-2431a86cb198	e4d16af5-5b8f-4051-b065-13acf6c694be
aa0b2ece-8052-43c9-93c2-2431a86cb198	9d3e591d-06a6-4fc4-9714-cf155a15b415
aa0b2ece-8052-43c9-93c2-2431a86cb198	81dcbcc6-3d70-4bdf-99bc-14833c57c628
aa0b2ece-8052-43c9-93c2-2431a86cb198	100f774a-3d7e-4be5-9c2c-ae70f40f0b50
aa0b2ece-8052-43c9-93c2-2431a86cb198	b20eaf10-3e40-4ef7-9d74-93a13782d38f
aa0b2ece-8052-43c9-93c2-2431a86cb198	89d71050-186e-4fb2-8cbd-9598ca312be9
aa0b2ece-8052-43c9-93c2-2431a86cb198	abc900b9-5b8c-4e54-a4a8-54f102b2c1c6
aa0b2ece-8052-43c9-93c2-2431a86cb198	3ee3fd4c-6208-494f-9551-d48fabc4f42a
aa0b2ece-8052-43c9-93c2-2431a86cb198	781e8a08-29e8-4171-8392-7e8ac9f183a0
aa0b2ece-8052-43c9-93c2-2431a86cb198	98461ca1-06a1-432a-97d0-4e1dff33e1a5
\.


--
-- Data for Name: class_programs_program; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_programs_program ("classClassId", "programId") FROM stdin;
8b09033d-7db9-46c3-aeb8-138c9e7eff96	b39edb9a-ab91-4245-94a4-eb2b5007c033
8b09033d-7db9-46c3-aeb8-138c9e7eff96	4591423a-2619-4ef8-a900-f5d924939d02
8b09033d-7db9-46c3-aeb8-138c9e7eff96	7a8c5021-142b-44b1-b60b-275c29d132fe
8b09033d-7db9-46c3-aeb8-138c9e7eff96	93f293e8-2c6a-47ad-bc46-1554caac99e4
8b09033d-7db9-46c3-aeb8-138c9e7eff96	56e24fa0-e139-4c80-b365-61c9bc42cd3f
8b09033d-7db9-46c3-aeb8-138c9e7eff96	d1bbdcc5-0d80-46b0-b98e-162e7439058f
8b09033d-7db9-46c3-aeb8-138c9e7eff96	f6617737-5022-478d-9672-0354667e0338
8b09033d-7db9-46c3-aeb8-138c9e7eff96	cdba0679-5719-47dc-806d-78de42026db6
8b09033d-7db9-46c3-aeb8-138c9e7eff96	75004121-0c0d-486c-ba65-4c57deacb44b
8b09033d-7db9-46c3-aeb8-138c9e7eff96	14d350f1-a7ba-4f46-bef9-dc847f0cbac5
8f4f696a-f935-412d-8134-d53062cea38e	b39edb9a-ab91-4245-94a4-eb2b5007c033
aa0b2ece-8052-43c9-93c2-2431a86cb198	b39edb9a-ab91-4245-94a4-eb2b5007c033
aa0b2ece-8052-43c9-93c2-2431a86cb198	4591423a-2619-4ef8-a900-f5d924939d02
aa0b2ece-8052-43c9-93c2-2431a86cb198	7a8c5021-142b-44b1-b60b-275c29d132fe
aa0b2ece-8052-43c9-93c2-2431a86cb198	93f293e8-2c6a-47ad-bc46-1554caac99e4
aa0b2ece-8052-43c9-93c2-2431a86cb198	56e24fa0-e139-4c80-b365-61c9bc42cd3f
aa0b2ece-8052-43c9-93c2-2431a86cb198	d1bbdcc5-0d80-46b0-b98e-162e7439058f
aa0b2ece-8052-43c9-93c2-2431a86cb198	f6617737-5022-478d-9672-0354667e0338
aa0b2ece-8052-43c9-93c2-2431a86cb198	cdba0679-5719-47dc-806d-78de42026db6
aa0b2ece-8052-43c9-93c2-2431a86cb198	75004121-0c0d-486c-ba65-4c57deacb44b
aa0b2ece-8052-43c9-93c2-2431a86cb198	14d350f1-a7ba-4f46-bef9-dc847f0cbac5
\.


--
-- Data for Name: class_subjects_subject; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.class_subjects_subject ("classClassId", "subjectId") FROM stdin;
8b09033d-7db9-46c3-aeb8-138c9e7eff96	b997e0d1-2dd7-40d8-847a-b8670247e96b
8b09033d-7db9-46c3-aeb8-138c9e7eff96	49c8d5ee-472b-47a6-8c57-58daf863c2e1
8b09033d-7db9-46c3-aeb8-138c9e7eff96	b19f511e-a46b-488d-9212-22c0369c8afd
8b09033d-7db9-46c3-aeb8-138c9e7eff96	29d24801-0089-4b8e-85d3-77688e961efb
8b09033d-7db9-46c3-aeb8-138c9e7eff96	f037ee92-212c-4592-a171-ed32fb892162
8b09033d-7db9-46c3-aeb8-138c9e7eff96	f12276a9-4331-4699-b0fa-68e8df172843
8b09033d-7db9-46c3-aeb8-138c9e7eff96	20d6ca2f-13df-4a7a-8dcb-955908db7baa
8b09033d-7db9-46c3-aeb8-138c9e7eff96	7cf8d3a3-5493-46c9-93eb-12f220d101d0
8b09033d-7db9-46c3-aeb8-138c9e7eff96	66a453b0-d38f-472e-b055-7a94a94d66c4
8b09033d-7db9-46c3-aeb8-138c9e7eff96	36c4f793-9aa3-4fb8-84f0-68a2ab920d5a
8f4f696a-f935-412d-8134-d53062cea38e	66a453b0-d38f-472e-b055-7a94a94d66c4
aa0b2ece-8052-43c9-93c2-2431a86cb198	b997e0d1-2dd7-40d8-847a-b8670247e96b
aa0b2ece-8052-43c9-93c2-2431a86cb198	49c8d5ee-472b-47a6-8c57-58daf863c2e1
aa0b2ece-8052-43c9-93c2-2431a86cb198	b19f511e-a46b-488d-9212-22c0369c8afd
aa0b2ece-8052-43c9-93c2-2431a86cb198	29d24801-0089-4b8e-85d3-77688e961efb
aa0b2ece-8052-43c9-93c2-2431a86cb198	f037ee92-212c-4592-a171-ed32fb892162
aa0b2ece-8052-43c9-93c2-2431a86cb198	f12276a9-4331-4699-b0fa-68e8df172843
aa0b2ece-8052-43c9-93c2-2431a86cb198	20d6ca2f-13df-4a7a-8dcb-955908db7baa
aa0b2ece-8052-43c9-93c2-2431a86cb198	7cf8d3a3-5493-46c9-93eb-12f220d101d0
aa0b2ece-8052-43c9-93c2-2431a86cb198	66a453b0-d38f-472e-b055-7a94a94d66c4
aa0b2ece-8052-43c9-93c2-2431a86cb198	36c4f793-9aa3-4fb8-84f0-68a2ab920d5a
\.


--
-- Data for Name: grade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.grade (id, name, system, status, created_at, deleted_at, progress_from_grade_id, progress_to_grade_id, organization_id, updated_at) FROM stdin;
d7e2e258-d4b3-4e95-b929-49ae702de4be	PreK-1	t	active	2021-12-21 11:04:35.932	\N	98461ca1-06a1-432a-97d0-4e1dff33e1a5	3e7979f6-7375-450a-9818-ddb09b250bb2	\N	2021-12-21 11:04:36.267
3e7979f6-7375-450a-9818-ddb09b250bb2	PreK-2	t	active	2021-12-21 11:04:35.935	\N	d7e2e258-d4b3-4e95-b929-49ae702de4be	81dcbcc6-3d70-4bdf-99bc-14833c57c628	\N	2021-12-21 11:04:36.291
4b9c1e70-0178-4c68-897b-dac052a38a80	Preschool	t	active	2022-01-10 14:55:28.583	\N	98461ca1-06a1-432a-97d0-4e1dff33e1a5	a9f0217d-f7ec-4add-950d-4e8986ab2c82	\N	2022-01-10 14:55:28.706
0ecb8fa9-d77e-4dd3-b220-7e79704f1b03	PreK-1	t	active	2021-12-21 11:04:35.898	\N	98461ca1-06a1-432a-97d0-4e1dff33e1a5	66fcda51-33c8-4162-a8d1-0337e1d6ade3	\N	2021-12-21 11:04:35.983
66fcda51-33c8-4162-a8d1-0337e1d6ade3	PreK-2	t	active	2021-12-21 11:04:35.902	\N	0ecb8fa9-d77e-4dd3-b220-7e79704f1b03	a9f0217d-f7ec-4add-950d-4e8986ab2c82	\N	2021-12-21 11:04:36.001
a9f0217d-f7ec-4add-950d-4e8986ab2c82	Kindergarten	t	active	2021-12-21 11:04:35.906	\N	66fcda51-33c8-4162-a8d1-0337e1d6ade3	e4d16af5-5b8f-4051-b065-13acf6c694be	\N	2021-12-21 11:04:36.048
e4d16af5-5b8f-4051-b065-13acf6c694be	Grade 1	t	active	2021-12-21 11:04:35.91	\N	a9f0217d-f7ec-4add-950d-4e8986ab2c82	98461ca1-06a1-432a-97d0-4e1dff33e1a5	\N	2021-12-21 11:04:36.101
9d3e591d-06a6-4fc4-9714-cf155a15b415	Grade 2	t	active	2021-12-21 11:04:35.952	\N	100f774a-3d7e-4be5-9c2c-ae70f40f0b50	98461ca1-06a1-432a-97d0-4e1dff33e1a5	\N	2021-12-21 11:04:36.376
81dcbcc6-3d70-4bdf-99bc-14833c57c628	K	t	active	2021-12-21 11:04:35.945	\N	3e7979f6-7375-450a-9818-ddb09b250bb2	100f774a-3d7e-4be5-9c2c-ae70f40f0b50	\N	2021-12-21 11:04:36.304
100f774a-3d7e-4be5-9c2c-ae70f40f0b50	Grade 1	t	active	2021-12-21 11:04:35.949	\N	81dcbcc6-3d70-4bdf-99bc-14833c57c628	9d3e591d-06a6-4fc4-9714-cf155a15b415	\N	2021-12-21 11:04:36.362
b20eaf10-3e40-4ef7-9d74-93a13782d38f	PreK-3	t	active	2021-12-21 11:04:35.914	\N	98461ca1-06a1-432a-97d0-4e1dff33e1a5	89d71050-186e-4fb2-8cbd-9598ca312be9	\N	2021-12-21 11:04:36.15
89d71050-186e-4fb2-8cbd-9598ca312be9	PreK-4	t	active	2021-12-21 11:04:35.918	\N	b20eaf10-3e40-4ef7-9d74-93a13782d38f	abc900b9-5b8c-4e54-a4a8-54f102b2c1c6	\N	2021-12-21 11:04:36.169
abc900b9-5b8c-4e54-a4a8-54f102b2c1c6	PreK-5	t	active	2021-12-21 11:04:35.921	\N	89d71050-186e-4fb2-8cbd-9598ca312be9	3ee3fd4c-6208-494f-9551-d48fabc4f42a	\N	2021-12-21 11:04:36.192
3ee3fd4c-6208-494f-9551-d48fabc4f42a	PreK-6	t	active	2021-12-21 11:04:35.925	\N	abc900b9-5b8c-4e54-a4a8-54f102b2c1c6	781e8a08-29e8-4171-8392-7e8ac9f183a0	\N	2021-12-21 11:04:36.209
781e8a08-29e8-4171-8392-7e8ac9f183a0	PreK-7	t	active	2021-12-21 11:04:35.929	\N	3ee3fd4c-6208-494f-9551-d48fabc4f42a	98461ca1-06a1-432a-97d0-4e1dff33e1a5	\N	2021-12-21 11:04:36.251
98461ca1-06a1-432a-97d0-4e1dff33e1a5	None Specified	t	active	2021-12-21 11:04:35.894	\N	\N	\N	\N	2021-12-21 11:04:35.894
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.migrations (id, "timestamp", name) FROM stdin;
1	1627128803380	MigrationLock1627128803380
2	1628677180503	InitialState1628677180503
3	1630420895212	AddTimestampColumns1630420895212
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organization (organization_id, organization_name, address1, address2, phone, "shortCode", status, deleted_at, "primaryContactUserId", created_at, updated_at) FROM stdin;
5956e9e9-d73c-499d-b42c-b88136fbbe56	Open Credo	\N	\N	\N	\N	active	\N	0c6b98f0-1a68-45c8-a949-60711c0b2a50	2021-12-21 11:05:40.443	2021-12-21 11:05:40.443
\.


--
-- Data for Name: organization_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organization_membership (user_id, organization_id, status, join_timestamp, shortcode, deleted_at, "userUserId", "organizationOrganizationId", created_at, updated_at) FROM stdin;
611824fd-8070-45f0-84af-37295203ae17	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2021-12-21 11:05:40.452053	\N	\N	611824fd-8070-45f0-84af-37295203ae17	5956e9e9-d73c-499d-b42c-b88136fbbe56	2021-12-21 11:05:40.452	2021-12-21 11:05:40.452
527c2d4c-2454-4f25-b194-6c6c67fe5026	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2021-12-21 11:05:40.452053	\N	\N	527c2d4c-2454-4f25-b194-6c6c67fe5026	5956e9e9-d73c-499d-b42c-b88136fbbe56	2021-12-21 11:05:40.452	2021-12-21 11:05:40.452
b4479424-a9d7-46a5-8ee6-40db4ed264b1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2021-12-21 11:05:40.452053	TL	\N	b4479424-a9d7-46a5-8ee6-40db4ed264b1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2021-12-21 11:05:40.452	2022-01-10 14:08:47.315
7ccbecd2-5648-492f-a15f-4c8963ca291b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-17 16:32:49.435129	4C45GYRHPT8855UT	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-17 16:32:49.435	2022-01-17 16:32:49.435
0c6b98f0-1a68-45c8-a949-60711c0b2a50	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2021-12-21 11:05:40.452053	MCF	\N	0c6b98f0-1a68-45c8-a949-60711c0b2a50	5956e9e9-d73c-499d-b42c-b88136fbbe56	2021-12-21 11:05:40.452	2022-01-18 14:34:10.814
08541445-56c2-4550-81ff-7559c945192e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:40.291788	5PRJ631S97AQKNH5	\N	08541445-56c2-4550-81ff-7559c945192e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:40.292	2022-01-18 15:57:40.292
41e31ea1-ee63-45dc-8f66-60c5bf338245	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:40.606421	4L6YB9X7RBGK2HYU	\N	41e31ea1-ee63-45dc-8f66-60c5bf338245	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:40.606	2022-01-18 15:57:40.606
2620fd68-8253-40cb-9532-97fdaab65bdc	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:40.922096	2EYHSIDD61208M73	\N	2620fd68-8253-40cb-9532-97fdaab65bdc	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:40.922	2022-01-18 15:57:40.922
8d5e3d77-6813-425f-bfc8-78bc72235210	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:41.23518	5I4XZUI3S60RQBSU	\N	8d5e3d77-6813-425f-bfc8-78bc72235210	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:41.235	2022-01-18 15:57:41.235
29b980ba-43f1-4789-85eb-0681ecd34d50	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:41.554067	4BDCLOXVJAR9NS8V	\N	29b980ba-43f1-4789-85eb-0681ecd34d50	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:41.554	2022-01-18 15:57:41.554
67e3f25a-6d49-4afc-91f5-422648501c22	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:41.876668	19GDW0N4RO8GKX8J	\N	67e3f25a-6d49-4afc-91f5-422648501c22	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:41.877	2022-01-18 15:57:41.877
db087b6f-f44d-4a61-b3ce-4783010eafe1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:42.197227	VY3D91SC6LO8A53F	\N	db087b6f-f44d-4a61-b3ce-4783010eafe1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:42.197	2022-01-18 15:57:42.197
1478d854-31c1-4c7b-8cd5-946db8fb3913	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:42.512014	1ABZS25E67OO3Q47	\N	1478d854-31c1-4c7b-8cd5-946db8fb3913	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:42.512	2022-01-18 15:57:42.512
cdac1f61-3dc9-4b66-af30-98205a2fef13	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:42.820952	7FNKOXFB3QVTXN9F	\N	cdac1f61-3dc9-4b66-af30-98205a2fef13	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:42.821	2022-01-18 15:57:42.821
ba4e15d4-06a4-4d74-a83c-b061508eabd6	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:43.130739	5NI1W2U1CYT1XJHB	\N	ba4e15d4-06a4-4d74-a83c-b061508eabd6	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:43.131	2022-01-18 15:57:43.131
af26e37e-4625-4255-9ccb-bfabe5690b54	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:57:43.616633	5YH4Y0AIDSM1KCF8	\N	af26e37e-4625-4255-9ccb-bfabe5690b54	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:57:43.617	2022-01-18 15:57:43.617
976cd4cf-3276-4a30-95f9-675c670941f3	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:44.179202	5DVEPF5HJQKQ5RWI	\N	976cd4cf-3276-4a30-95f9-675c670941f3	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:44.179	2022-01-18 15:58:44.179
d112f364-50a1-4b07-89d8-ba384bbd2c71	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:44.482947	2N94USB6YHWZT3X5	\N	d112f364-50a1-4b07-89d8-ba384bbd2c71	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:44.483	2022-01-18 15:58:44.483
b13089b9-d832-4907-9240-a6c310763a28	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:44.797175	5A2JMWSC334TWAAA	\N	b13089b9-d832-4907-9240-a6c310763a28	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:44.797	2022-01-18 15:58:44.797
41dee2e5-ffd6-4202-8370-98bf7560374d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:45.100821	2ZJA5X1QJ31ITRDF	\N	41dee2e5-ffd6-4202-8370-98bf7560374d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:45.101	2022-01-18 15:58:45.101
252f5821-cfa2-46b8-87f1-aae3673a573b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:45.392057	4GG525QSGHIITSYK	\N	252f5821-cfa2-46b8-87f1-aae3673a573b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:45.392	2022-01-18 15:58:45.392
60916b31-72ac-4eee-90a0-804746a7a088	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:45.682547	3KKSQP7OYJ4PCQHB	\N	60916b31-72ac-4eee-90a0-804746a7a088	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:45.683	2022-01-18 15:58:45.683
7ea58850-6fdf-4c2b-8c42-56c6a06ef646	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:45.983844	24TQYW83IZU125VQ	\N	7ea58850-6fdf-4c2b-8c42-56c6a06ef646	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:45.984	2022-01-18 15:58:45.984
94f66e07-59b0-49c1-954f-fb30bd95785d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:46.28893	1F54ZEVEZ2728DDQ	\N	94f66e07-59b0-49c1-954f-fb30bd95785d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:46.289	2022-01-18 15:58:46.289
aaf7e8e7-493d-4eb7-a6ff-8d220e93bbf1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:46.588914	3GGP24636MLR4DN2	\N	aaf7e8e7-493d-4eb7-a6ff-8d220e93bbf1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:46.589	2022-01-18 15:58:46.589
b9eea1fc-71f7-4576-984e-a050d4fe4928	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:46.887057	UES9YL5YZQGYZ5MJ	\N	b9eea1fc-71f7-4576-984e-a050d4fe4928	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:46.887	2022-01-18 15:58:46.887
371cbf5d-3273-4209-a9a9-df7696134d9f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:47.185789	1OOPTM8MNO4DT00L	\N	371cbf5d-3273-4209-a9a9-df7696134d9f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:47.186	2022-01-18 15:58:47.186
166e2026-7bee-4446-98fd-f60e6d189337	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:47.469408	PUJZSYZM5HLYBQQR	\N	166e2026-7bee-4446-98fd-f60e6d189337	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:47.469	2022-01-18 15:58:47.469
75da7464-f264-4871-bfee-6a89cd5c61ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:47.753918	2PA6XVCSPVEQHRDA	\N	75da7464-f264-4871-bfee-6a89cd5c61ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:47.754	2022-01-18 15:58:47.754
cc774be4-eee3-4154-955f-2b810cc2c057	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:48.032501	3T561WWM93IWRHF4	\N	cc774be4-eee3-4154-955f-2b810cc2c057	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:48.033	2022-01-18 15:58:48.033
dbe61da1-8e55-4aa1-a773-a246e885d6f8	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:48.312162	Y71X1KQ7Y4J2Q0X1	\N	dbe61da1-8e55-4aa1-a773-a246e885d6f8	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:48.312	2022-01-18 15:58:48.312
47f2b855-1e6a-438e-a92b-50ac460b7dd1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:48.58777	61CAUIMPH91M2FLN	\N	47f2b855-1e6a-438e-a92b-50ac460b7dd1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:48.588	2022-01-18 15:58:48.588
62272ef9-6da6-4297-a5ef-c24f6af31a58	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:48.864357	63JQNSNBHHZ5ZEUU	\N	62272ef9-6da6-4297-a5ef-c24f6af31a58	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:48.864	2022-01-18 15:58:48.864
c687597f-be44-4d0b-ae27-1e03ecfb9906	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:49.150381	3BHKQW2WWQI9270O	\N	c687597f-be44-4d0b-ae27-1e03ecfb9906	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:49.15	2022-01-18 15:58:49.15
52d4cd1f-bd63-4101-976a-f76648cbe9ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:49.429289	4AV1QJ9KL2NDDWN6	\N	52d4cd1f-bd63-4101-976a-f76648cbe9ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:49.429	2022-01-18 15:58:49.429
b0e45a2e-453d-42b5-9dcd-08ffd6212e9d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:49.707071	55HIT8I4QBEE564D	\N	b0e45a2e-453d-42b5-9dcd-08ffd6212e9d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:49.707	2022-01-18 15:58:49.707
d5fe3b89-0526-4c5d-8b51-49d00d83865a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:49.995707	30ZH9XJ5RS8Z3P7Y	\N	d5fe3b89-0526-4c5d-8b51-49d00d83865a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:49.996	2022-01-18 15:58:49.996
8a73ff19-267d-4d8d-83e5-ebe6cbae5b55	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:50.282399	IPDUCT0NIAYTPNM7	\N	8a73ff19-267d-4d8d-83e5-ebe6cbae5b55	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:50.282	2022-01-18 15:58:50.282
1a3704d6-18e0-413b-a155-c106a2224e68	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:50.567693	3D2CIVL40B7TSZZA	\N	1a3704d6-18e0-413b-a155-c106a2224e68	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:50.568	2022-01-18 15:58:50.568
cc537e59-2844-4721-b4c1-1eadddc45bef	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:50.856769	55AF6YTAQ3MPRSPF	\N	cc537e59-2844-4721-b4c1-1eadddc45bef	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:50.857	2022-01-18 15:58:50.857
b2469051-827c-4e1a-862d-208593f71ef4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:51.135554	4K2MQF30W26JQN7A	\N	b2469051-827c-4e1a-862d-208593f71ef4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:51.136	2022-01-18 15:58:51.136
92cf9d0b-5515-4099-94a4-36ca52653a03	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:51.41929	4QI6NHQ5S6QJ4BS4	\N	92cf9d0b-5515-4099-94a4-36ca52653a03	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:51.419	2022-01-18 15:58:51.419
daa456ce-9550-4d7d-802c-235daa3f77db	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:54.247166	4BUWHG4W8SK7DPJV	\N	daa456ce-9550-4d7d-802c-235daa3f77db	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:54.247	2022-01-18 15:58:54.247
dd7f170b-3965-4cfc-8323-2c90d0c466cc	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:57.066887	FR1D799Z0UCTAQTY	\N	dd7f170b-3965-4cfc-8323-2c90d0c466cc	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:57.067	2022-01-18 15:58:57.067
25666e2c-d6c5-4207-9299-24e2829292d7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:51.702699	2WJ6RGOX0BE1JLF3	\N	25666e2c-d6c5-4207-9299-24e2829292d7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:51.703	2022-01-18 15:58:51.703
08b27fae-a3a9-43a7-af39-1d3fa9eaada2	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:54.530524	5SCWHUHIU2TM04AV	\N	08b27fae-a3a9-43a7-af39-1d3fa9eaada2	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:54.531	2022-01-18 15:58:54.531
50769eb7-cd8c-45e6-b42b-8c6dc32a4f91	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:57.346261	Y79G558DDN7I6ABN	\N	50769eb7-cd8c-45e6-b42b-8c6dc32a4f91	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:57.346	2022-01-18 15:58:57.346
80d65593-d8f3-4808-9a58-d35c90ef2cab	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:51.983987	50NUE0LMKOMPCVZ9	\N	80d65593-d8f3-4808-9a58-d35c90ef2cab	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:51.984	2022-01-18 15:58:51.984
00b8a2e2-3796-410c-93bc-e525b13d4fe5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:54.811463	2MXP78RUG78J863X	\N	00b8a2e2-3796-410c-93bc-e525b13d4fe5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:54.811	2022-01-18 15:58:54.811
2ba57ff0-3d3b-4454-9499-c9ed14bc95fc	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:57.629143	C7F6CNZ5YWIU1D0S	\N	2ba57ff0-3d3b-4454-9499-c9ed14bc95fc	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:57.629	2022-01-18 15:58:57.629
66e82261-9198-440d-b3d4-f6fb2eb3ce94	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:52.26701	53B0J0YZG5Z7F7KT	\N	66e82261-9198-440d-b3d4-f6fb2eb3ce94	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:52.267	2022-01-18 15:58:52.267
09afbf1a-1ee9-4103-8ad7-ce99bf81b123	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:55.096592	5NA0VF52UBGHYDFV	\N	09afbf1a-1ee9-4103-8ad7-ce99bf81b123	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:55.097	2022-01-18 15:58:55.097
25326c97-4498-4b86-90f0-3e35c8370b6d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:57.914461	5SEZ8OUC8QQN8HG3	\N	25326c97-4498-4b86-90f0-3e35c8370b6d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:57.914	2022-01-18 15:58:57.914
025d1237-74ca-4fcd-838d-31032ae3ab9e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:52.547431	2C7EI63ZIJ23BMBJ	\N	025d1237-74ca-4fcd-838d-31032ae3ab9e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:52.547	2022-01-18 15:58:52.547
c3c8bba5-e78d-4c3a-8247-fb2485dae884	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:55.373738	2QM0Y44R162NU9RC	\N	c3c8bba5-e78d-4c3a-8247-fb2485dae884	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:55.374	2022-01-18 15:58:55.374
7fbca29b-ed16-45aa-b260-3ed4110c566e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:58.188386	23MEA4N203O6Y2D0	\N	7fbca29b-ed16-45aa-b260-3ed4110c566e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:58.188	2022-01-18 15:58:58.188
4f8c6f58-2028-4278-9687-41183657257e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:52.836403	1FJFSLED0QCQ0CBN	\N	4f8c6f58-2028-4278-9687-41183657257e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:52.836	2022-01-18 15:58:52.836
04503827-0413-44fb-8d5d-049196ae2a86	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:55.657429	51BXB82YQYB7H2HL	\N	04503827-0413-44fb-8d5d-049196ae2a86	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:55.657	2022-01-18 15:58:55.657
d4c47e74-6782-42ee-b58c-ae972585e936	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:58.463192	KNY6YUNMA89ZYA1Z	\N	d4c47e74-6782-42ee-b58c-ae972585e936	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:58.463	2022-01-18 15:58:58.463
cc6932d8-4dbe-46de-8cac-578d7bc0debb	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:53.128076	BFQ9L2ZM8FXBJ1PC	\N	cc6932d8-4dbe-46de-8cac-578d7bc0debb	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:53.128	2022-01-18 15:58:53.128
572d0811-9bbd-469b-870c-cc697953eda6	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:55.938872	4IH0INZPWOLLO1BP	\N	572d0811-9bbd-469b-870c-cc697953eda6	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:55.939	2022-01-18 15:58:55.939
f1d75a44-206a-49bb-a44f-04482624fcd0	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:53.410415	1AYRTS3Q1HX7GJHF	\N	f1d75a44-206a-49bb-a44f-04482624fcd0	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:53.41	2022-01-18 15:58:53.41
8b22f38e-dd2a-4332-85c0-36751fec5dbd	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:56.223419	1PZJ8SIYJIARZ2Q7	\N	8b22f38e-dd2a-4332-85c0-36751fec5dbd	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:56.223	2022-01-18 15:58:56.223
5b567c82-5615-4032-9804-e7f101a45330	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:53.685791	5HZLPRWEDAQQSXN8	\N	5b567c82-5615-4032-9804-e7f101a45330	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:53.686	2022-01-18 15:58:53.686
5292e9fb-cfeb-49f6-9995-9ff6a31d39aa	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:56.518156	3ONQTOACENXRQOZS	\N	5292e9fb-cfeb-49f6-9995-9ff6a31d39aa	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:56.518	2022-01-18 15:58:56.518
21cfab88-8217-44ea-81c8-65ea3319d70e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:53.96722	2O4LRZOMDXVWNOA7	\N	21cfab88-8217-44ea-81c8-65ea3319d70e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:53.967	2022-01-18 15:58:53.967
ba69e699-f355-4091-b729-254fabc1b586	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:56.792807	4HFUJWLVOH8IFXKD	\N	ba69e699-f355-4091-b729-254fabc1b586	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:56.793	2022-01-18 15:58:56.793
9af6a1fd-f6af-4af3-8907-10b46aa0aee9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:58.747382	4YM62ULZ0D22G58Z	\N	9af6a1fd-f6af-4af3-8907-10b46aa0aee9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:58.747	2022-01-18 15:58:58.747
63bb6608-f828-49eb-a26a-d7c204e61c42	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:59.031276	2LY8OYUV4DJGKBM9	\N	63bb6608-f828-49eb-a26a-d7c204e61c42	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:59.031	2022-01-18 15:58:59.031
d0ac968c-e55c-4429-b606-e1c0e9095c0b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:59.318119	2NZNI6UED08TI518	\N	d0ac968c-e55c-4429-b606-e1c0e9095c0b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:59.318	2022-01-18 15:58:59.318
07b3e391-ef75-4ac2-9edd-5c0bef411b2d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:59.590649	695I7MN7TAEWS5V5	\N	07b3e391-ef75-4ac2-9edd-5c0bef411b2d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:59.591	2022-01-18 15:58:59.591
2b3e13d8-7d61-420d-9c07-6cba678c5f71	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:58:59.861864	5NNJLP1QY59EK0QB	\N	2b3e13d8-7d61-420d-9c07-6cba678c5f71	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:58:59.862	2022-01-18 15:58:59.862
860033d5-e361-4d2a-97ef-db3164fb26de	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:00.135843	2HUB6T20MTQ1YS5Q	\N	860033d5-e361-4d2a-97ef-db3164fb26de	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:00.136	2022-01-18 15:59:00.136
d278bab8-b0af-4d40-904d-ee729910a09e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:00.419437	5OKGBEW3GP3TO5I6	\N	d278bab8-b0af-4d40-904d-ee729910a09e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:00.419	2022-01-18 15:59:00.419
0d7ab0b0-8be4-4aea-b2dc-f0050f52ff44	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:00.702038	17O52NMUXVRM6UD0	\N	0d7ab0b0-8be4-4aea-b2dc-f0050f52ff44	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:00.702	2022-01-18 15:59:00.702
66f50333-2dd3-41d5-9fd1-36e44369165d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:00.986531	52J8620EYIGM91L0	\N	66f50333-2dd3-41d5-9fd1-36e44369165d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:00.987	2022-01-18 15:59:00.987
4a1c3644-7145-4702-9ba9-1923764626ec	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:01.269684	54CYTMQBN0N3QTSD	\N	4a1c3644-7145-4702-9ba9-1923764626ec	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:01.27	2022-01-18 15:59:01.27
11865178-5dbb-46ac-ad42-28864a02ace0	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:01.595822	1NCXXSOKI3EA4Y3P	\N	11865178-5dbb-46ac-ad42-28864a02ace0	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:01.596	2022-01-18 15:59:01.596
6783c878-4529-4b63-8c21-89d4a7e941f1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:01.877782	5SDZ1SFWSFQAH6EM	\N	6783c878-4529-4b63-8c21-89d4a7e941f1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:01.878	2022-01-18 15:59:01.878
c9ff80f2-982e-4c53-97fa-8fee003979f4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:02.156638	2RP5983WFA1I8UJM	\N	c9ff80f2-982e-4c53-97fa-8fee003979f4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:02.157	2022-01-18 15:59:02.157
61fa6bf1-a517-4a11-8f65-d33e03bcf1fd	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:02.439946	4S5UJAHRDY34NM07	\N	61fa6bf1-a517-4a11-8f65-d33e03bcf1fd	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:02.44	2022-01-18 15:59:02.44
a1ccdbcd-24ae-4333-9a94-f5d6d60ff008	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:02.717175	3RANE9FX0DGQZX6N	\N	a1ccdbcd-24ae-4333-9a94-f5d6d60ff008	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:02.717	2022-01-18 15:59:02.717
7f26426e-51d3-44f5-b333-7a6c5457ca9b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:02.99463	587OXW5ZIETGE4Y6	\N	7f26426e-51d3-44f5-b333-7a6c5457ca9b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:02.995	2022-01-18 15:59:02.995
b1e0a887-58d5-4b12-894d-4d429e512320	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:03.274075	2DYL3C7LOM3S5U72	\N	b1e0a887-58d5-4b12-894d-4d429e512320	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:03.274	2022-01-18 15:59:03.274
5d90fbc9-fc3d-4626-a8ce-5a434cb0a696	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:03.562915	3FQQOIPTTFU539MR	\N	5d90fbc9-fc3d-4626-a8ce-5a434cb0a696	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:03.563	2022-01-18 15:59:03.563
bdfbe5db-a78f-4322-ba28-6fa56f791d8e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:03.841708	51FWJ5XXB35UOT5X	\N	bdfbe5db-a78f-4322-ba28-6fa56f791d8e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:03.842	2022-01-18 15:59:03.842
e2e2ef6b-82a2-481f-bf92-821051e3f211	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:04.137982	4QZKN9I9FIQUWSFN	\N	e2e2ef6b-82a2-481f-bf92-821051e3f211	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:04.138	2022-01-18 15:59:04.138
814da935-79f4-4d93-91d3-7793faac9be0	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:04.415375	4BGA3I5OT1X7XPAC	\N	814da935-79f4-4d93-91d3-7793faac9be0	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:04.415	2022-01-18 15:59:04.415
a1150aef-ee35-4a27-8098-87ea99ded4d4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:04.700009	4KC390A4U3VU9OPG	\N	a1150aef-ee35-4a27-8098-87ea99ded4d4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:04.7	2022-01-18 15:59:04.7
2d52057d-85a1-42b7-ab5f-0e38fd9cb0c7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:04.985428	4C87LSR17ML9YSHR	\N	2d52057d-85a1-42b7-ab5f-0e38fd9cb0c7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:04.985	2022-01-18 15:59:04.985
c79d9813-fc56-40ae-bf93-d42a3e9fc5e1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:05.265076	2DUKVATQHJF7RB00	\N	c79d9813-fc56-40ae-bf93-d42a3e9fc5e1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:05.265	2022-01-18 15:59:05.265
dfc3adbc-82a4-40c8-88a0-2c28df83d838	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:05.537131	357MKYBO4IH7FIRN	\N	dfc3adbc-82a4-40c8-88a0-2c28df83d838	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:05.537	2022-01-18 15:59:05.537
1f922c03-1ba9-4076-9ec7-e116f662e03f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:05.84725	C060EQYRT5NXVTJB	\N	1f922c03-1ba9-4076-9ec7-e116f662e03f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:05.847	2022-01-18 15:59:05.847
08e5c6f8-6692-45ca-826b-01637aa0ff73	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:06.155716	2HDMNNF33LJ731PI	\N	08e5c6f8-6692-45ca-826b-01637aa0ff73	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:06.156	2022-01-18 15:59:06.156
51405652-8ec7-4d11-ae8e-215ad1ebf139	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:06.43377	36CTVHWBRULO7ZWI	\N	51405652-8ec7-4d11-ae8e-215ad1ebf139	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:06.434	2022-01-18 15:59:06.434
40ec36c6-ab98-4919-81c1-9f2722d0d3fe	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:06.738653	2F3QOE1AJONMSPY7	\N	40ec36c6-ab98-4919-81c1-9f2722d0d3fe	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:06.739	2022-01-18 15:59:06.739
ee0cb774-659b-4640-ae7e-047a66edb247	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:07.028124	12W5PETBKH6VL74C	\N	ee0cb774-659b-4640-ae7e-047a66edb247	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:07.028	2022-01-18 15:59:07.028
bf9a5f81-4da2-412a-9e78-ce159fd75283	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:07.314333	1IS0CHDINQ1QA7HB	\N	bf9a5f81-4da2-412a-9e78-ce159fd75283	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:07.314	2022-01-18 15:59:07.314
366ac80e-68f6-4074-b25a-b0ccfeecf6b8	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:07.598426	62QR6I9IGZ7ITQYY	\N	366ac80e-68f6-4074-b25a-b0ccfeecf6b8	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:07.598	2022-01-18 15:59:07.598
dacc03b6-1534-4612-af6d-e62623897ee9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:07.883208	1O4WXXJUIQP0EUKT	\N	dacc03b6-1534-4612-af6d-e62623897ee9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:07.883	2022-01-18 15:59:07.883
8e8ce815-9d3c-46ff-840f-c618169d8502	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:08.159342	544JQHAHJJNH2YWI	\N	8e8ce815-9d3c-46ff-840f-c618169d8502	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:08.159	2022-01-18 15:59:08.159
12c12b96-302c-4b61-ab90-b85d49072a84	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:08.434486	1LCIWV6G6P9ZXBKZ	\N	12c12b96-302c-4b61-ab90-b85d49072a84	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:08.434	2022-01-18 15:59:08.434
580befe5-ee5e-4b0c-bc60-7e2d1af658be	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:08.706909	1EJO2CSPSMK1TWE7	\N	580befe5-ee5e-4b0c-bc60-7e2d1af658be	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:08.707	2022-01-18 15:59:08.707
c8d70777-7c4a-4373-9d57-3fb93c8a594e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:08.988834	2TZYRCLGJZKP1OLX	\N	c8d70777-7c4a-4373-9d57-3fb93c8a594e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:08.989	2022-01-18 15:59:08.989
a388cdda-4f10-481c-892c-0bc05ae9f150	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:09.268604	3GP48HHECMB0I6SJ	\N	a388cdda-4f10-481c-892c-0bc05ae9f150	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:09.269	2022-01-18 15:59:09.269
1f1c3b33-62cf-407c-9562-fa445acc7dc7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 15:59:09.548956	55TSA7F6VGPORTY1	\N	1f1c3b33-62cf-407c-9562-fa445acc7dc7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 15:59:09.549	2022-01-18 15:59:09.549
b3c4a363-3a59-44c4-9926-9ed48b12f1ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 16:14:07.223035	3V3DUL8UX6FSP001	\N	b3c4a363-3a59-44c4-9926-9ed48b12f1ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:14:07.223	2022-01-18 16:14:07.223
e9a1b937-f6fd-46f1-92fb-df6440dc70e0	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 16:16:11.429499	5OGM7EQQJPRFP5HE	\N	e9a1b937-f6fd-46f1-92fb-df6440dc70e0	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:16:11.429	2022-01-18 16:16:11.429
a8b88118-f977-49ec-b0d6-8c4f8638cc0e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:37.979083	4K81T5ND6SACUQ3U	\N	a8b88118-f977-49ec-b0d6-8c4f8638cc0e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:37.979	2022-01-18 19:38:37.979
bceec891-2417-46c0-a65e-49720cb13b4e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:38.284383	5G02JI34YXJ4EF9I	\N	bceec891-2417-46c0-a65e-49720cb13b4e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:38.284	2022-01-18 19:38:38.284
d33e20b7-1446-4be7-9990-0f28cc36071a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:38.587666	WACXCV6WP7QQCLMJ	\N	d33e20b7-1446-4be7-9990-0f28cc36071a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:38.588	2022-01-18 19:38:38.588
30151184-da43-41b9-a9cb-3649c1727889	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:38.890646	69TACV9PFLW2RPS2	\N	30151184-da43-41b9-a9cb-3649c1727889	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:38.891	2022-01-18 19:38:38.891
8e67bda8-433d-44cb-a6ba-7f7382b7dac9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:39.197608	159SIFGRFZVYO0KP	\N	8e67bda8-433d-44cb-a6ba-7f7382b7dac9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:39.198	2022-01-18 19:38:39.198
8b908fc2-0e18-41a8-a8bf-d404c7bd4673	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:39.491859	7LWBPBBYASW1FYZG	\N	8b908fc2-0e18-41a8-a8bf-d404c7bd4673	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:39.492	2022-01-18 19:38:39.492
d968ef17-e90b-4348-a74d-f5f36f566e69	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:39.799547	2TVCPHDPBIK98QLN	\N	d968ef17-e90b-4348-a74d-f5f36f566e69	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:39.8	2022-01-18 19:38:39.8
ea111673-1ee5-423e-ab8a-44659219aec3	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:40.090861	44EPQ9R6EXNFCDNP	\N	ea111673-1ee5-423e-ab8a-44659219aec3	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:40.091	2022-01-18 19:38:40.091
e8483a10-5c9e-4482-b6c0-87b42890cdc5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:40.394529	5YO21B3WQC67AXWH	\N	e8483a10-5c9e-4482-b6c0-87b42890cdc5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:40.395	2022-01-18 19:38:40.395
f0384321-a9bc-475a-852b-4b4d1d6a2c0c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:40.693369	1DEC0FG2OTZ15WXT	\N	f0384321-a9bc-475a-852b-4b4d1d6a2c0c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:40.693	2022-01-18 19:38:40.693
bc220b61-699a-4e00-9a8f-a543edfc3485	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:40.977185	63S90XP6R6EZRYUN	\N	bc220b61-699a-4e00-9a8f-a543edfc3485	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:40.977	2022-01-18 19:38:40.977
b54aaa9f-3916-42ac-a4a5-5528c5ce8eda	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:41.253614	5AYSLMH975TVNG9G	\N	b54aaa9f-3916-42ac-a4a5-5528c5ce8eda	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:41.254	2022-01-18 19:38:41.254
595010bc-34a9-43f4-bc75-1ce93e8e6f20	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:41.54145	4SX4QPBPP8LDCOLR	\N	595010bc-34a9-43f4-bc75-1ce93e8e6f20	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:41.541	2022-01-18 19:38:41.541
8cd71ec4-a878-497b-a24f-2e23c7f21ff1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:41.821505	1U6MFLFRCMOHUGWP	\N	8cd71ec4-a878-497b-a24f-2e23c7f21ff1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:41.822	2022-01-18 19:38:41.822
72914232-c7b2-4881-bd5d-003e94fd215d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:42.097236	4A3M95TSSPKZDNKX	\N	72914232-c7b2-4881-bd5d-003e94fd215d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:42.097	2022-01-18 19:38:42.097
bb215e23-4d9f-4951-b2f1-6e24a2bcf994	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:42.373442	1O14H3KJY72GL70P	\N	bb215e23-4d9f-4951-b2f1-6e24a2bcf994	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:42.373	2022-01-18 19:38:42.373
e5b0a680-e6f7-45e5-8dab-995b8497eded	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:42.652425	16V394KZY2K75OE9	\N	e5b0a680-e6f7-45e5-8dab-995b8497eded	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:42.652	2022-01-18 19:38:42.652
54b0386e-767e-4a1b-8c93-f6555c9d313a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:42.927079	3PQYQXL1V81TEP46	\N	54b0386e-767e-4a1b-8c93-f6555c9d313a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:42.927	2022-01-18 19:38:42.927
72ce550d-74d7-408e-aefc-445bd6413159	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:43.213095	1PUDAQHL5D5HOBT3	\N	72ce550d-74d7-408e-aefc-445bd6413159	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:43.213	2022-01-18 19:38:43.213
765888ba-7859-49f7-ad76-82a84f32c239	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:43.492119	4GODU4YSZ7B65JU2	\N	765888ba-7859-49f7-ad76-82a84f32c239	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:43.492	2022-01-18 19:38:43.492
7f2b497f-88ca-489c-864d-7db89087b73e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:43.764586	3AK0LCLDIHQ503XK	\N	7f2b497f-88ca-489c-864d-7db89087b73e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:43.765	2022-01-18 19:38:43.765
aaefde3f-7891-4526-813b-fae0fbfaa665	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:44.044914	3C4OG68D1EJFOBY2	\N	aaefde3f-7891-4526-813b-fae0fbfaa665	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:44.045	2022-01-18 19:38:44.045
f28bc03b-51ce-439c-93a8-cee33d04db58	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:44.327055	3G7WW2Z8CUZHP03O	\N	f28bc03b-51ce-439c-93a8-cee33d04db58	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:44.327	2022-01-18 19:38:44.327
e13e0bf9-8c93-413e-a16c-f734f99eb599	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:44.608286	3X0WBCOKFTVIZYI5	\N	e13e0bf9-8c93-413e-a16c-f734f99eb599	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:44.608	2022-01-18 19:38:44.608
6b5d27d1-7043-4fb0-9dd8-dcb0df5641d6	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:44.888413	2NQVGYJR0RBRIOA8	\N	6b5d27d1-7043-4fb0-9dd8-dcb0df5641d6	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:44.888	2022-01-18 19:38:44.888
26003172-4df0-45d3-aa60-58508f576830	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:45.161392	5AYY1N5CIUO8P87R	\N	26003172-4df0-45d3-aa60-58508f576830	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:45.161	2022-01-18 19:38:45.161
8084f068-8462-4d00-9dc8-663015fdd685	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:45.441911	50LDDIGF7I5L9XBN	\N	8084f068-8462-4d00-9dc8-663015fdd685	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:45.442	2022-01-18 19:38:45.442
98c9d975-aadf-45ee-94b9-e17235d0318c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:45.721871	3CDEVZVM9RARUV38	\N	98c9d975-aadf-45ee-94b9-e17235d0318c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:45.722	2022-01-18 19:38:45.722
357ee1ef-2309-4566-b3a3-3ac707c054ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:46.0033	3R64P6AXR6539GW4	\N	357ee1ef-2309-4566-b3a3-3ac707c054ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:46.003	2022-01-18 19:38:46.003
390ff267-7985-4eed-8e1f-63e47e3dc254	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:46.286701	18EX4XZOX7WRAMBI	\N	390ff267-7985-4eed-8e1f-63e47e3dc254	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:46.287	2022-01-18 19:38:46.287
9037a6c8-42a0-46a8-821d-4706e5e1be75	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:46.563594	19438O2HCXEWIJJJ	\N	9037a6c8-42a0-46a8-821d-4706e5e1be75	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:46.564	2022-01-18 19:38:46.564
e8836720-44de-4fcf-b488-7600456f5041	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:46.846187	4TWQEKGJSGAXV8PW	\N	e8836720-44de-4fcf-b488-7600456f5041	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:46.846	2022-01-18 19:38:46.846
7a7c7641-8a23-41c6-936d-aa711d96af8e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:47.131018	4EMMV6JA1LDKWIUF	\N	7a7c7641-8a23-41c6-936d-aa711d96af8e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:47.131	2022-01-18 19:38:47.131
effedda3-bda1-4a4c-9a72-a212f2042886	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:47.418408	L2CTYK88UEF9PITJ	\N	effedda3-bda1-4a4c-9a72-a212f2042886	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:47.418	2022-01-18 19:38:47.418
8a6d9a1b-9bfb-4b4b-9b2b-dc2bfa18e195	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:47.700258	MQ3W2Z4JA0IN68BE	\N	8a6d9a1b-9bfb-4b4b-9b2b-dc2bfa18e195	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:47.7	2022-01-18 19:38:47.7
11c81d21-c6eb-4272-923b-4a68e88ec2d2	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:47.975588	AKH7Q6NGF7U5TPDH	\N	11c81d21-c6eb-4272-923b-4a68e88ec2d2	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:47.976	2022-01-18 19:38:47.976
45f8f5df-833b-41ba-9aea-2ba5bc7204b9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:48.251682	4SB74X0B4X9NNHOQ	\N	45f8f5df-833b-41ba-9aea-2ba5bc7204b9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:48.252	2022-01-18 19:38:48.252
f9dfdc99-6b61-4916-8506-4f59e374bd62	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:48.532034	5EDKM4IBXFBH58E1	\N	f9dfdc99-6b61-4916-8506-4f59e374bd62	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:48.532	2022-01-18 19:38:48.532
b50882f7-09c3-42de-8adc-f51cd7839267	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:48.803901	1471S90055WARQUT	\N	b50882f7-09c3-42de-8adc-f51cd7839267	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:48.804	2022-01-18 19:38:48.804
f52f44fe-37a1-44ec-ac81-00936dc14568	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:49.079957	4GTVYN803WJ3K3V8	\N	f52f44fe-37a1-44ec-ac81-00936dc14568	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:49.08	2022-01-18 19:38:49.08
e2a3cf3f-c14e-4519-b6cd-f6fe4bfdf567	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:51.869551	36JD0NFMHCITAAJS	\N	e2a3cf3f-c14e-4519-b6cd-f6fe4bfdf567	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:51.87	2022-01-18 19:38:51.87
c927eec1-f4f1-452f-a017-2e5dc2dce49b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:54.643493	1YZFQ0G2W7A0PSIN	\N	c927eec1-f4f1-452f-a017-2e5dc2dce49b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:54.643	2022-01-18 19:38:54.643
0f132cc3-3754-4245-9cee-92e7b5f8c00a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:57.486736	2Y3V3VDEBXNXNTG5	\N	0f132cc3-3754-4245-9cee-92e7b5f8c00a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:57.487	2022-01-18 19:38:57.487
7d5d796d-f597-4dc8-a581-e033c2e951f1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:00.295974	14QSB49W67FU7ZJN	\N	7d5d796d-f597-4dc8-a581-e033c2e951f1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:00.296	2022-01-18 19:39:00.296
bd16bf05-c647-4211-bbeb-91abeb573375	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:03.100353	258WRI7CDPBE2FK8	\N	bd16bf05-c647-4211-bbeb-91abeb573375	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:03.1	2022-01-18 19:39:03.1
08456804-5978-40fd-9921-f4ea55cc5cc8	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:49.355497	37LZN5E5HDT27NDI	\N	08456804-5978-40fd-9921-f4ea55cc5cc8	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:49.355	2022-01-18 19:38:49.355
054f8f61-cf9d-49fd-a934-cfb4e96877a5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:52.148317	4PRTM0YHVR9EQLWS	\N	054f8f61-cf9d-49fd-a934-cfb4e96877a5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:52.148	2022-01-18 19:38:52.148
e768f45e-23cf-45a1-98b0-032239d65297	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:54.923064	2R5BBRCMFUVTJ5SO	\N	e768f45e-23cf-45a1-98b0-032239d65297	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:54.923	2022-01-18 19:38:54.923
a59d564e-c43c-405a-82ae-abcc5dff2139	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:57.771656	4L0NYCUTAVSEBSOF	\N	a59d564e-c43c-405a-82ae-abcc5dff2139	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:57.772	2022-01-18 19:38:57.772
ff97e1bf-00f2-4c32-b954-1a08bfddd0e8	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:00.571707	58PVA3Y4W7BUUSB3	\N	ff97e1bf-00f2-4c32-b954-1a08bfddd0e8	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:00.572	2022-01-18 19:39:00.572
bb0ea035-2294-44f1-a25c-7229bf335e1d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:03.382366	63DQK91WHJ1WWXY4	\N	bb0ea035-2294-44f1-a25c-7229bf335e1d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:03.382	2022-01-18 19:39:03.382
040ff3a7-2374-497f-9e49-98415f41da5a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:49.635723	17SHQI27TWL1SKHS	\N	040ff3a7-2374-497f-9e49-98415f41da5a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:49.636	2022-01-18 19:38:49.636
18201392-43f6-46a8-b40c-1fffe23b135a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:52.429731	42VEIL0P9BA9X09I	\N	18201392-43f6-46a8-b40c-1fffe23b135a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:52.43	2022-01-18 19:38:52.43
403204cc-11d1-4fdc-93a4-aba666d3e844	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:55.203192	66HCEN9QT8R7EF27	\N	403204cc-11d1-4fdc-93a4-aba666d3e844	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:55.203	2022-01-18 19:38:55.203
1d38ccf3-24de-420d-9095-b80e22a6c295	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:58.05836	4HN540QV8ZFOOXD7	\N	1d38ccf3-24de-420d-9095-b80e22a6c295	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:58.058	2022-01-18 19:38:58.058
d563a8d7-8b62-4f53-9930-ebbea7f3edad	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:00.850972	59G9E8NC7HHWFEQA	\N	d563a8d7-8b62-4f53-9930-ebbea7f3edad	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:00.851	2022-01-18 19:39:00.851
c638d3ca-c6db-43bc-8ae0-bb1ca9a62423	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:03.661853	3HW5I1BG3RDRGEI7	\N	c638d3ca-c6db-43bc-8ae0-bb1ca9a62423	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:03.662	2022-01-18 19:39:03.662
3c0e1678-f0e9-4f11-be49-83208485acdc	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:49.918889	5L2N3G5TJ4DDGA6J	\N	3c0e1678-f0e9-4f11-be49-83208485acdc	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:49.919	2022-01-18 19:38:49.919
6929d728-543c-4abc-b297-7c4764c48f1b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:52.70803	9HLMJ9DV9TSML4YP	\N	6929d728-543c-4abc-b297-7c4764c48f1b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:52.708	2022-01-18 19:38:52.708
77958711-d91c-4530-b266-6897d9b23c80	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:55.488153	40AC1L5CF332XXH6	\N	77958711-d91c-4530-b266-6897d9b23c80	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:55.488	2022-01-18 19:38:55.488
b678b03c-acf3-4633-b688-f78e2fe006dd	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:58.345455	5A7PTRYFZLMZA0JU	\N	b678b03c-acf3-4633-b688-f78e2fe006dd	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:58.345	2022-01-18 19:38:58.345
33561269-044c-4e6e-a933-0ff06d36459c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:01.141422	P7F01RSCYUMLLJ8H	\N	33561269-044c-4e6e-a933-0ff06d36459c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:01.141	2022-01-18 19:39:01.141
0d7b4204-00f9-42fb-9f49-eadb5dc5b1a3	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:03.946673	64A9MTO7VVGXK81M	\N	0d7b4204-00f9-42fb-9f49-eadb5dc5b1a3	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:03.947	2022-01-18 19:39:03.947
4f67754d-538c-4cf1-bdaf-a9809d67e085	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:50.200195	335EQ4NRKCPO6EM0	\N	4f67754d-538c-4cf1-bdaf-a9809d67e085	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:50.2	2022-01-18 19:38:50.2
e83c5011-e137-423a-9abd-d179ce2154f7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:52.990496	4DM332X9ZW6QQ8IR	\N	e83c5011-e137-423a-9abd-d179ce2154f7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:52.99	2022-01-18 19:38:52.99
ceb5c553-8af6-4d74-bc2c-998b6f810058	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:55.773082	OO0EWET4C8KI2DI8	\N	ceb5c553-8af6-4d74-bc2c-998b6f810058	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:55.773	2022-01-18 19:38:55.773
30cbac52-6a13-4732-92a1-294946bb529b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:58.625216	2AO001M2VWHWHDHP	\N	30cbac52-6a13-4732-92a1-294946bb529b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:58.625	2022-01-18 19:38:58.625
1699a638-1a77-48d3-9c25-656ef29b6eae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:01.436955	2BCZRARREJRIHGLX	\N	1699a638-1a77-48d3-9c25-656ef29b6eae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:01.437	2022-01-18 19:39:01.437
e27608d0-0ae7-49ed-aad1-ec74be537418	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:04.22995	64KGF3IYSBL86GBP	\N	e27608d0-0ae7-49ed-aad1-ec74be537418	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:04.23	2022-01-18 19:39:04.23
cd29d82c-b949-470c-9ffe-54efe72e7ebf	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:50.477424	1230QQZ02BF9772L	\N	cd29d82c-b949-470c-9ffe-54efe72e7ebf	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:50.477	2022-01-18 19:38:50.477
6bebce93-bf43-485d-b10a-33c41a4670f7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:53.268289	2396L4C57Q17PKSS	\N	6bebce93-bf43-485d-b10a-33c41a4670f7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:53.268	2022-01-18 19:38:53.268
a3fb926d-a5a7-4db7-95f9-c37d89a019a8	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:56.054294	3J7907QZONPOCMHX	\N	a3fb926d-a5a7-4db7-95f9-c37d89a019a8	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:56.054	2022-01-18 19:38:56.054
625ef27d-99ff-40dd-977d-727545bf4a4c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:58.907545	3TP348B3YUSF6LU2	\N	625ef27d-99ff-40dd-977d-727545bf4a4c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:58.908	2022-01-18 19:38:58.908
a06a37eb-6436-4913-8f1e-e5c5f28b389b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:01.71261	69550KS8EDRS8GZ2	\N	a06a37eb-6436-4913-8f1e-e5c5f28b389b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:01.713	2022-01-18 19:39:01.713
949dfdfd-0673-4f34-a098-4c722e3198d9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:50.748362	PJ9BZ0PLNKF5KV36	\N	949dfdfd-0673-4f34-a098-4c722e3198d9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:50.748	2022-01-18 19:38:50.748
0e098a43-e600-4d9f-8b9f-f2f8a3dec94b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:53.542446	36CLOHB0K3TNS3Z7	\N	0e098a43-e600-4d9f-8b9f-f2f8a3dec94b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:53.542	2022-01-18 19:38:53.542
9c3bec00-fa01-41c1-8751-d443fc53de84	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:56.342417	4C27S8SZY9HB9DDS	\N	9c3bec00-fa01-41c1-8751-d443fc53de84	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:56.342	2022-01-18 19:38:56.342
727f2f7d-37e6-45b7-9537-0a73da54b5b1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:59.179917	1Z4DAH9SO39QD4C6	\N	727f2f7d-37e6-45b7-9537-0a73da54b5b1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:59.18	2022-01-18 19:38:59.18
e9cb43b7-522b-4878-afa1-609744d0c2d9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:01.988593	5791YVI94IH6RCND	\N	e9cb43b7-522b-4878-afa1-609744d0c2d9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:01.989	2022-01-18 19:39:01.989
fda36f24-a2b2-4b76-a96e-9c3392f8dc76	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:51.027474	3D07TI7ORISDNN5X	\N	fda36f24-a2b2-4b76-a96e-9c3392f8dc76	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:51.027	2022-01-18 19:38:51.027
17ab59d1-6452-4b4f-a69f-48f3da71e462	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:53.813918	E6VDTUXLBVMW6GQY	\N	17ab59d1-6452-4b4f-a69f-48f3da71e462	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:53.814	2022-01-18 19:38:53.814
2f2c9ab6-a96e-4806-b91f-74c1ef11ad3c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:56.617852	17ISNIWHZNG8U3WR	\N	2f2c9ab6-a96e-4806-b91f-74c1ef11ad3c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:56.618	2022-01-18 19:38:56.618
8cbb10d1-8680-4e60-98bb-a677b4f41803	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:59.449404	3EEX5STD1VID96XC	\N	8cbb10d1-8680-4e60-98bb-a677b4f41803	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:59.449	2022-01-18 19:38:59.449
5a2a75ef-7e0e-4ead-bef1-bfe4808b0773	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:02.270862	4G2V4SIDUN7UJ2S2	\N	5a2a75ef-7e0e-4ead-bef1-bfe4808b0773	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:02.271	2022-01-18 19:39:02.271
ff913ae7-96e6-400d-8ebe-402397887c19	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:51.301192	E1FIJ787F8HLXIUP	\N	ff913ae7-96e6-400d-8ebe-402397887c19	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:51.301	2022-01-18 19:38:51.301
becbce79-d5fb-4748-be4b-a605eea216a4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:54.08692	5TC2WY1Z1VZ556SN	\N	becbce79-d5fb-4748-be4b-a605eea216a4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:54.087	2022-01-18 19:38:54.087
79909aa7-124b-4cc0-8af7-43e6f66dca30	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:56.893803	1EATGPHSW9B5ODAG	\N	79909aa7-124b-4cc0-8af7-43e6f66dca30	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:56.894	2022-01-18 19:38:56.894
ffdc8b92-b27a-4737-9033-656adb915cfd	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:59.725338	J8EIM3ORQLBKMNLQ	\N	ffdc8b92-b27a-4737-9033-656adb915cfd	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:59.725	2022-01-18 19:38:59.725
d16b8223-1f14-48f5-bd52-ab0f3390e25c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:02.550104	5KI4XUKK7TKU72BL	\N	d16b8223-1f14-48f5-bd52-ab0f3390e25c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:02.55	2022-01-18 19:39:02.55
f68c8cb7-1f68-46c7-b1ea-c897c4ff0276	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:51.585937	QBF8OQ26HNZ140WV	\N	f68c8cb7-1f68-46c7-b1ea-c897c4ff0276	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:51.586	2022-01-18 19:38:51.586
02084382-cfdd-4474-835c-25c966d4a68a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:54.3654	4EEYYI5V7CPSQ9RW	\N	02084382-cfdd-4474-835c-25c966d4a68a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:54.365	2022-01-18 19:38:54.365
d2289729-9ae3-4a8c-8486-6fd2685172b3	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:38:57.165958	4I8XOJGU6LQNU2QI	\N	d2289729-9ae3-4a8c-8486-6fd2685172b3	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:38:57.166	2022-01-18 19:38:57.166
eca4d17c-e514-45d6-b212-feecf574494a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:00.005943	3672G3DRFX3NT118	\N	eca4d17c-e514-45d6-b212-feecf574494a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:00.006	2022-01-18 19:39:00.006
82fc2987-ab8a-4ddf-8922-2d576d648030	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:02.825702	3J5WWFLVZ2AR9PPI	\N	82fc2987-ab8a-4ddf-8922-2d576d648030	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:02.826	2022-01-18 19:39:02.826
df8279ca-7849-49b1-b18b-d9e70ea83854	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:04.507961	MJ23YX5IADX54WMQ	\N	df8279ca-7849-49b1-b18b-d9e70ea83854	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:04.508	2022-01-18 19:39:04.508
316f9c5e-9e38-49a7-bfc5-3c8fbf8e1055	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:04.785233	36482DAHKOLHQF58	\N	316f9c5e-9e38-49a7-bfc5-3c8fbf8e1055	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:04.785	2022-01-18 19:39:04.785
ae5b0c6f-8384-480a-8780-6093352dd45b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:05.073353	2HP5G52PI2WAT415	\N	ae5b0c6f-8384-480a-8780-6093352dd45b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:05.073	2022-01-18 19:39:05.073
30d41cc0-02a1-4760-a6d2-401f63882d41	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:05.353497	U4XF47OX9JRHGEKD	\N	30d41cc0-02a1-4760-a6d2-401f63882d41	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:05.353	2022-01-18 19:39:05.353
c43f5050-28e6-469a-a092-488d05136c2c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:05.631678	Y26J9H2WCG7FQQXW	\N	c43f5050-28e6-469a-a092-488d05136c2c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:05.632	2022-01-18 19:39:05.632
f8bf32cc-086c-4d5a-aabe-bbf7c563cc21	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:39:05.906756	3Z9UUJLKYLCKC3MM	\N	f8bf32cc-086c-4d5a-aabe-bbf7c563cc21	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:39:05.907	2022-01-18 19:39:05.907
994b5a41-ffaf-4b49-967d-686800cb3221	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:16.803503	12LIHV8A2ZDNERM0	\N	994b5a41-ffaf-4b49-967d-686800cb3221	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:16.804	2022-01-18 19:53:16.804
4b00253d-b27a-45c0-ba75-e973298ac1f9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:17.099651	53EJR5G4JIHYPSTF	\N	4b00253d-b27a-45c0-ba75-e973298ac1f9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:17.1	2022-01-18 19:53:17.1
3f7ac114-2abe-4d5a-8a32-12f01203dbaa	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:17.392452	5MG5QBFF4KFFIR1H	\N	3f7ac114-2abe-4d5a-8a32-12f01203dbaa	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:17.392	2022-01-18 19:53:17.392
2ee9c42d-413a-4a4e-a9ee-6948eaad7125	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:17.683891	2AQU3TUO4JVIEOFM	\N	2ee9c42d-413a-4a4e-a9ee-6948eaad7125	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:17.684	2022-01-18 19:53:17.684
d2714fb7-9117-4514-ad63-1a660bcb3275	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:17.999239	3Z0712LON1YTZBI1	\N	d2714fb7-9117-4514-ad63-1a660bcb3275	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:17.999	2022-01-18 19:53:17.999
69c8123a-31bf-4dc8-b1a1-feadce0b0d6e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:18.302467	6CD1ZQJVEGWEPOXS	\N	69c8123a-31bf-4dc8-b1a1-feadce0b0d6e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:18.302	2022-01-18 19:53:18.302
a8ac1caf-42c9-4a84-811e-1b29514161ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:18.611468	3PBGUYBSLBLO0R23	\N	a8ac1caf-42c9-4a84-811e-1b29514161ae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:18.611	2022-01-18 19:53:18.611
cb84bb1b-6cd4-457d-aa21-fb817321f1f0	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:18.909932	516VA2H7KUCM20V0	\N	cb84bb1b-6cd4-457d-aa21-fb817321f1f0	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:18.91	2022-01-18 19:53:18.91
3110bfe4-8495-4b0e-bfde-564f86c3fbd4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:19.208128	529L67GMPJ6ACG2V	\N	3110bfe4-8495-4b0e-bfde-564f86c3fbd4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:19.208	2022-01-18 19:53:19.208
68598968-5662-4fe3-9b0d-9108f57d63d7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:19.500316	3HI7S6BNZ05TVLIA	\N	68598968-5662-4fe3-9b0d-9108f57d63d7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:19.5	2022-01-18 19:53:19.5
aaed7f00-6212-4dc0-8417-093a70395b1f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:19.777357	4V42ZAWYDGSL7DW7	\N	aaed7f00-6212-4dc0-8417-093a70395b1f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:19.777	2022-01-18 19:53:19.777
3d70ce5a-8030-456f-9177-1a143b654206	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:20.045687	5AGD4HV2LQM81QT3	\N	3d70ce5a-8030-456f-9177-1a143b654206	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:20.046	2022-01-18 19:53:20.046
7cffc00e-cfb2-4464-aa5f-ea0e60757150	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:20.315105	5JKPRPIPDOL9XON8	\N	7cffc00e-cfb2-4464-aa5f-ea0e60757150	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:20.315	2022-01-18 19:53:20.315
07aa8eb7-3ba6-4aff-a010-fc8c22df5f29	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:20.588942	32R878YQ0RC4C5UE	\N	07aa8eb7-3ba6-4aff-a010-fc8c22df5f29	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:20.589	2022-01-18 19:53:20.589
37cc53a0-c129-46a2-b9d1-bf152e3c2cff	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:20.862222	44WHFQVTM9HXXPET	\N	37cc53a0-c129-46a2-b9d1-bf152e3c2cff	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:20.862	2022-01-18 19:53:20.862
e952cec0-4f03-4320-800f-5e7f0307ccda	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:21.144489	1MVJEAN6NQQ4EX4P	\N	e952cec0-4f03-4320-800f-5e7f0307ccda	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:21.144	2022-01-18 19:53:21.144
008a83ca-d1b2-41c9-adf5-33914625c81b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:21.415854	3I1J2JRGJHNE4UCT	\N	008a83ca-d1b2-41c9-adf5-33914625c81b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:21.416	2022-01-18 19:53:21.416
d0e88f1c-868f-4a9e-b9fb-2f3177043a82	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:21.692435	3EUFV90C3GV5POGX	\N	d0e88f1c-868f-4a9e-b9fb-2f3177043a82	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:21.692	2022-01-18 19:53:21.692
2cfd4d5e-47e3-4035-a7e1-614ed27241f2	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:21.967754	487925IDHATZ7AS7	\N	2cfd4d5e-47e3-4035-a7e1-614ed27241f2	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:21.968	2022-01-18 19:53:21.968
403c59bd-7141-4c0f-9931-b595a4ec1fe5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:22.239506	2G6FQVKC0MQ1KD0G	\N	403c59bd-7141-4c0f-9931-b595a4ec1fe5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:22.24	2022-01-18 19:53:22.24
5c7739a8-44b2-4a3d-9821-469c413b7742	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:22.510322	5TSQMC7WCGNYCQ84	\N	5c7739a8-44b2-4a3d-9821-469c413b7742	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:22.51	2022-01-18 19:53:22.51
690088a0-d559-495d-9168-01755ca57219	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:22.779416	1KD3EJZZI44DFSE5	\N	690088a0-d559-495d-9168-01755ca57219	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:22.779	2022-01-18 19:53:22.779
b02d9ed6-4ccf-443e-a486-309e3663a968	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:23.049245	4DDA8U9AVUH3YDUF	\N	b02d9ed6-4ccf-443e-a486-309e3663a968	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:23.049	2022-01-18 19:53:23.049
d83477e6-a3c0-40a7-84d7-e0dfeda130ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:23.322434	59CTIINMYRGL88BF	\N	d83477e6-a3c0-40a7-84d7-e0dfeda130ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:23.322	2022-01-18 19:53:23.322
15f0117f-7104-4ea6-a73a-7cc9e6a88fa1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:23.605093	5V9B02BXDDEPGAUM	\N	15f0117f-7104-4ea6-a73a-7cc9e6a88fa1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:23.605	2022-01-18 19:53:23.605
d186c668-53a7-43c1-937d-ae0ae4b7426d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:23.881743	24YXM5VQLU80J9VC	\N	d186c668-53a7-43c1-937d-ae0ae4b7426d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:23.882	2022-01-18 19:53:23.882
e58e4049-9809-421b-a0f9-aca389849413	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:24.159737	4ZRTGMMAWUS6T3QX	\N	e58e4049-9809-421b-a0f9-aca389849413	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:24.16	2022-01-18 19:53:24.16
211cf55a-ad24-4c48-b014-afd96e948983	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:24.442233	10TEGDLGH3ZOPTHR	\N	211cf55a-ad24-4c48-b014-afd96e948983	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:24.442	2022-01-18 19:53:24.442
e398d6d1-b7df-4406-aefb-21ede4df1978	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:24.725521	4J4LX9CMVSP1QYIX	\N	e398d6d1-b7df-4406-aefb-21ede4df1978	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:24.726	2022-01-18 19:53:24.726
74b39c99-6a86-4a6e-9f12-bfdd079ab3ee	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:24.997722	14HZWRZQHQSC7CPH	\N	74b39c99-6a86-4a6e-9f12-bfdd079ab3ee	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:24.998	2022-01-18 19:53:24.998
2627f264-7af3-49b4-b213-a1e208f11e92	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:25.269218	4OBTD2B54OTQPPRX	\N	2627f264-7af3-49b4-b213-a1e208f11e92	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:25.269	2022-01-18 19:53:25.269
3e7c1471-6cf8-406d-b974-a7a662cf309a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:28.004857	53XF6O1RP2SG27N9	\N	3e7c1471-6cf8-406d-b974-a7a662cf309a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:28.005	2022-01-18 19:53:28.005
a75fbe5e-67fa-40e7-ae9f-441d64a44bad	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:30.738553	4ZFSJRDBI0UENP4L	\N	a75fbe5e-67fa-40e7-ae9f-441d64a44bad	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:30.739	2022-01-18 19:53:30.739
fed965e3-10fc-462b-8454-8740206d8835	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:33.468653	46A63XDQ2U43ZET5	\N	fed965e3-10fc-462b-8454-8740206d8835	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:33.469	2022-01-18 19:53:33.469
64a28fba-ee56-48f3-b600-0371a74a4b05	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:36.184297	IJGBDYV40SYNS23L	\N	64a28fba-ee56-48f3-b600-0371a74a4b05	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:36.184	2022-01-18 19:53:36.184
5032f4fc-b1b1-48a4-912c-f043e19a0bdd	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:25.54509	2FS9RH4Z2HLLVR9B	\N	5032f4fc-b1b1-48a4-912c-f043e19a0bdd	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:25.545	2022-01-18 19:53:25.545
5b268aa4-580a-41a9-80e2-66195fc74bae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:28.271469	3VEKML3J4Q6HMRNQ	\N	5b268aa4-580a-41a9-80e2-66195fc74bae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:28.271	2022-01-18 19:53:28.271
e01353a8-96c4-47b7-84bb-32a03c844957	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:31.006138	8HXD38R4YWS1NPW3	\N	e01353a8-96c4-47b7-84bb-32a03c844957	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:31.006	2022-01-18 19:53:31.006
cdc79885-7f18-40f7-a8ff-c0bcfc50bec4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:33.742817	2F9WY68IXGMFHWUQ	\N	cdc79885-7f18-40f7-a8ff-c0bcfc50bec4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:33.743	2022-01-18 19:53:33.743
ee44ebfd-ff0b-4ffd-950e-1eccf60f0c5f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:36.458947	5Q9NHDVZV76MZV92	\N	ee44ebfd-ff0b-4ffd-950e-1eccf60f0c5f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:36.459	2022-01-18 19:53:36.459
4c4dd570-606e-47b4-b9c0-c8ea19469473	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:25.81566	1CQPXETKW9G51I9S	\N	4c4dd570-606e-47b4-b9c0-c8ea19469473	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:25.816	2022-01-18 19:53:25.816
34ce0003-834d-4e85-bd62-e316a107fb8e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:28.546675	2FXWDS4JYLQ2WI7E	\N	34ce0003-834d-4e85-bd62-e316a107fb8e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:28.547	2022-01-18 19:53:28.547
93911459-f8f7-47b3-b720-0ef75892f249	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:31.27891	29LUN9TR44Y6S7BX	\N	93911459-f8f7-47b3-b720-0ef75892f249	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:31.279	2022-01-18 19:53:31.279
6f2fbdfe-d971-4b7d-b603-faf01968f500	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:34.015938	1IAR88ILIPY8GAB8	\N	6f2fbdfe-d971-4b7d-b603-faf01968f500	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:34.016	2022-01-18 19:53:34.016
41a33d7b-b745-4322-a4f0-aefc5f81858a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:36.736892	416L9T98G00CMFS0	\N	41a33d7b-b745-4322-a4f0-aefc5f81858a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:36.737	2022-01-18 19:53:36.737
2e7c3df3-c357-4c82-a659-1e99621cec3f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:26.08861	2R5U9VX9AURBIH2V	\N	2e7c3df3-c357-4c82-a659-1e99621cec3f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:26.089	2022-01-18 19:53:26.089
a56cec2c-abc7-4f15-beae-de2d85699147	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:28.819753	5S2Y5VDZL2X1HBX2	\N	a56cec2c-abc7-4f15-beae-de2d85699147	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:28.82	2022-01-18 19:53:28.82
edbb1f1a-f1f0-48ea-9cfe-28464633318b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:31.54745	1WH1N2WEYPKGW4DZ	\N	edbb1f1a-f1f0-48ea-9cfe-28464633318b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:31.547	2022-01-18 19:53:31.547
1c8eacc6-c2e0-4caa-aade-0a8d2c04fe0a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:34.284777	5CCH8RL1H9OMBO5X	\N	1c8eacc6-c2e0-4caa-aade-0a8d2c04fe0a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:34.285	2022-01-18 19:53:34.285
49e1e30c-6dc5-48e7-9c4c-1659c64322e5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:37.022536	51K7ZFYUG6BI8HKL	\N	49e1e30c-6dc5-48e7-9c4c-1659c64322e5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:37.023	2022-01-18 19:53:37.023
f7a4270e-5142-4dd3-a3bf-7417e1222729	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:26.360424	1AIYAKKUXQ3DL3JL	\N	f7a4270e-5142-4dd3-a3bf-7417e1222729	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:26.36	2022-01-18 19:53:26.36
92c179dc-237e-46a0-bbf9-50af3183c2af	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:29.08509	3HN1BP3ZWZAVOM8O	\N	92c179dc-237e-46a0-bbf9-50af3183c2af	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:29.085	2022-01-18 19:53:29.085
fbf1e698-0df9-41f4-a5c6-adf077db3f27	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:31.823616	1PN1JH3K4JS17F9J	\N	fbf1e698-0df9-41f4-a5c6-adf077db3f27	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:31.824	2022-01-18 19:53:31.824
1f1b40a2-3978-4207-9734-0fc0ac7f2899	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:34.551227	1U6XMR6IB1XXJQF0	\N	1f1b40a2-3978-4207-9734-0fc0ac7f2899	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:34.551	2022-01-18 19:53:34.551
8f177e8d-2e11-40c4-9cfe-5f88bbeb87ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:26.636708	4XMTRQVLNSU8B9TN	\N	8f177e8d-2e11-40c4-9cfe-5f88bbeb87ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:26.637	2022-01-18 19:53:26.637
5851e71f-a9e4-4460-a662-073975dd11d7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:29.364538	22FP0K40PU3AQE0J	\N	5851e71f-a9e4-4460-a662-073975dd11d7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:29.365	2022-01-18 19:53:29.365
54496b2f-69ef-440a-840b-4d7aeac509ea	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:32.096554	1V1H1PTTVFHZ10Y1	\N	54496b2f-69ef-440a-840b-4d7aeac509ea	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:32.097	2022-01-18 19:53:32.097
d6a2c14a-19d0-4b13-95c1-7affd7a75473	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:34.825192	2QIE4WUCLW7FETER	\N	d6a2c14a-19d0-4b13-95c1-7affd7a75473	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:34.825	2022-01-18 19:53:34.825
43ebacd1-d587-4712-ad25-f7c84a8fcd60	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:26.916468	13UOB8QX21ODWWOK	\N	43ebacd1-d587-4712-ad25-f7c84a8fcd60	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:26.916	2022-01-18 19:53:26.916
be746b9e-b7b9-4748-a730-d1308fe6dff7	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:29.643338	252SJXDLSXWIRDP2	\N	be746b9e-b7b9-4748-a730-d1308fe6dff7	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:29.643	2022-01-18 19:53:29.643
208e364d-e34e-484c-ba7d-de958a216c6a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:32.374813	14OZXP9XTN8XLKJ7	\N	208e364d-e34e-484c-ba7d-de958a216c6a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:32.375	2022-01-18 19:53:32.375
5501d154-86da-48d0-9b50-3f808e7c4c58	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:35.094504	19I6FFESGSXYG78N	\N	5501d154-86da-48d0-9b50-3f808e7c4c58	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:35.095	2022-01-18 19:53:35.095
0add028e-4685-4ebc-87fb-dc2044c2fed5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:27.196387	5UJ2N8Z846K8L9ZW	\N	0add028e-4685-4ebc-87fb-dc2044c2fed5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:27.196	2022-01-18 19:53:27.196
5ccd4c71-2e3a-4a97-a042-da39968b8bdd	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:29.92585	4UU9WE5CA2IEA6CN	\N	5ccd4c71-2e3a-4a97-a042-da39968b8bdd	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:29.926	2022-01-18 19:53:29.926
7153e22a-80c0-4712-b879-a746ace59de8	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:32.651201	30ACJCZVCIB0ACOR	\N	7153e22a-80c0-4712-b879-a746ace59de8	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:32.651	2022-01-18 19:53:32.651
3dd2fb45-0573-4b28-8fcd-e1a1717b5535	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:35.366709	5GHJHYD2EBTUNKHM	\N	3dd2fb45-0573-4b28-8fcd-e1a1717b5535	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:35.367	2022-01-18 19:53:35.367
d3def1a8-3253-4aa2-af58-7182d7343eff	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:27.476738	1UCQ6DSTUP3ZN6BU	\N	d3def1a8-3253-4aa2-af58-7182d7343eff	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:27.477	2022-01-18 19:53:27.477
518b2d4a-d320-428f-ad0e-0f2a8e891ed4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:30.201252	54J1FSIHS1HNJY8Q	\N	518b2d4a-d320-428f-ad0e-0f2a8e891ed4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:30.201	2022-01-18 19:53:30.201
4ae3007e-6d23-45a2-8c23-37916d78e3c0	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:32.930308	303UGI3HK9UJ0RG5	\N	4ae3007e-6d23-45a2-8c23-37916d78e3c0	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:32.93	2022-01-18 19:53:32.93
e5f0f719-49bc-4054-8d78-7dcba47f17fe	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:35.644705	2WLYQ20U9MF8XLI3	\N	e5f0f719-49bc-4054-8d78-7dcba47f17fe	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:35.645	2022-01-18 19:53:35.645
6a8e069d-aaeb-47ca-b43f-30e1d9a6cbd1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:27.741981	3Q05EEUM3XSIWWR0	\N	6a8e069d-aaeb-47ca-b43f-30e1d9a6cbd1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:27.742	2022-01-18 19:53:27.742
0776d95b-570e-4b56-bc6b-2279e93f1a7f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:30.469925	1WR8EBQN211RCJPU	\N	0776d95b-570e-4b56-bc6b-2279e93f1a7f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:30.47	2022-01-18 19:53:30.47
5485e361-25a9-418a-a503-1a55da1d9db3	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:33.197234	28EHTBXF999RFGLB	\N	5485e361-25a9-418a-a503-1a55da1d9db3	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:33.197	2022-01-18 19:53:33.197
ef41ed6b-b334-4b75-ba16-9635c637d58a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:35.910336	6D8YVMNS096OYDTM	\N	ef41ed6b-b334-4b75-ba16-9635c637d58a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:35.91	2022-01-18 19:53:35.91
1553c296-9df5-408d-be4b-6dd0bd6a4e9e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:37.313935	1G29CILWW2QOOYWC	\N	1553c296-9df5-408d-be4b-6dd0bd6a4e9e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:37.314	2022-01-18 19:53:37.314
dc585a36-2faf-4deb-b834-561a5480d880	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:37.588801	3XCZP8HYHRRHB8WO	\N	dc585a36-2faf-4deb-b834-561a5480d880	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:37.589	2022-01-18 19:53:37.589
00fcca0e-fec8-450c-ac6c-e35806aeefe9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:37.864073	4SYQRSFVPD8O295I	\N	00fcca0e-fec8-450c-ac6c-e35806aeefe9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:37.864	2022-01-18 19:53:37.864
87e89a8a-d2ea-404b-ac74-03833aee202d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:38.14757	64A8GWKX6CCR5C2F	\N	87e89a8a-d2ea-404b-ac74-03833aee202d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:38.148	2022-01-18 19:53:38.148
6e1c47a5-dc1d-4e92-8758-03d7e88f4b80	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:38.427222	2NY2LN971A7O2HZ6	\N	6e1c47a5-dc1d-4e92-8758-03d7e88f4b80	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:38.427	2022-01-18 19:53:38.427
6ff78bee-64f8-4415-a5e6-a893deaa63bb	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:38.697724	35RD5Z9O3765ZCU3	\N	6ff78bee-64f8-4415-a5e6-a893deaa63bb	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:38.698	2022-01-18 19:53:38.698
8f4ab0bc-735e-4ce7-8b01-2c5387b7f54a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:38.97881	2K7D3LEIDITV6F6Q	\N	8f4ab0bc-735e-4ce7-8b01-2c5387b7f54a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:38.979	2022-01-18 19:53:38.979
8b3fb58d-6fea-4f2e-934f-0e257c6c1c85	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:39.24785	3V52VZJVTODMBLUS	\N	8b3fb58d-6fea-4f2e-934f-0e257c6c1c85	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:39.248	2022-01-18 19:53:39.248
d9cf57c8-a8f3-45f2-bd95-2178e4b61c97	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:39.517157	XPN7TZMJQVXYYXLV	\N	d9cf57c8-a8f3-45f2-bd95-2178e4b61c97	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:39.517	2022-01-18 19:53:39.517
fac72272-3840-4695-b17a-edd549ccc730	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:39.794455	2SQRRRRMA1NZEKJC	\N	fac72272-3840-4695-b17a-edd549ccc730	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:39.794	2022-01-18 19:53:39.794
b5c729d0-fef2-4850-9f66-d786b7e1a0af	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:40.070295	3HLOK8FEMPX08DHY	\N	b5c729d0-fef2-4850-9f66-d786b7e1a0af	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:40.07	2022-01-18 19:53:40.07
f413da06-210d-4562-96bd-2b61e81d1b1d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:40.353091	38PHW84F6JTUQZPC	\N	f413da06-210d-4562-96bd-2b61e81d1b1d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:40.353	2022-01-18 19:53:40.353
02770cc4-cc04-46bf-af2b-2698f61ee577	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:40.635444	1PMQ0CTPFFQOKSL4	\N	02770cc4-cc04-46bf-af2b-2698f61ee577	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:40.635	2022-01-18 19:53:40.635
d5880231-4816-4268-964b-ee5b190d6962	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:40.91907	35IXE4519K78SBBF	\N	d5880231-4816-4268-964b-ee5b190d6962	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:40.919	2022-01-18 19:53:40.919
e1e64f97-013d-4b66-b189-879d71829e63	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:41.19432	45WR6IJ8T774EAII	\N	e1e64f97-013d-4b66-b189-879d71829e63	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:41.194	2022-01-18 19:53:41.194
a663bb21-0553-40bc-84e5-8aa366f999c9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:41.463445	5KPHPGE8A6CMA9UT	\N	a663bb21-0553-40bc-84e5-8aa366f999c9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:41.463	2022-01-18 19:53:41.463
bbd82119-8f2c-4801-adc1-619232ea4c58	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:41.741002	4JKR9QWWPZSC635W	\N	bbd82119-8f2c-4801-adc1-619232ea4c58	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:41.741	2022-01-18 19:53:41.741
7a3b3e39-d212-4894-a59c-f27726933cce	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:42.012059	1I6YB6BGSVH5EANW	\N	7a3b3e39-d212-4894-a59c-f27726933cce	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:42.012	2022-01-18 19:53:42.012
96814ee0-3f49-4868-b396-a5acefdb1c90	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:42.285132	CW0YX5DJRC7ASACY	\N	96814ee0-3f49-4868-b396-a5acefdb1c90	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:42.285	2022-01-18 19:53:42.285
01a2f078-04d3-47bf-8c5e-84d716caa144	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:42.552582	Z7X81TLBOS4BM0K7	\N	01a2f078-04d3-47bf-8c5e-84d716caa144	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:42.553	2022-01-18 19:53:42.553
d4de3ea1-a166-4782-8865-9a9d50798b5f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:42.8228	5GBU7F43Y87WOISJ	\N	d4de3ea1-a166-4782-8865-9a9d50798b5f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:42.823	2022-01-18 19:53:42.823
9f940121-0e47-424c-a694-48e6846c5b1c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:43.09363	DU0V0R9W9WVIRZ9B	\N	9f940121-0e47-424c-a694-48e6846c5b1c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:43.094	2022-01-18 19:53:43.094
d6832150-1c47-460f-8892-3c41aba513eb	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:43.36529	1MU4TUO86EU1SR7Z	\N	d6832150-1c47-460f-8892-3c41aba513eb	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:43.365	2022-01-18 19:53:43.365
98ea9347-f197-421e-8f55-8775d53ce001	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:43.647045	4PKNCJITOWM12RN5	\N	98ea9347-f197-421e-8f55-8775d53ce001	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:43.647	2022-01-18 19:53:43.647
c197051c-a611-473d-8b79-15c9fca6950a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:43.923587	5V110ZK7OKJCRWVM	\N	c197051c-a611-473d-8b79-15c9fca6950a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:43.924	2022-01-18 19:53:43.924
019a5aba-0536-4661-8799-11616becec9c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-18 19:53:44.192323	1WWBMS605K9GUT8T	\N	019a5aba-0536-4661-8799-11616becec9c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 19:53:44.192	2022-01-18 19:53:44.192
b8d224f1-099f-4fce-9fc0-cc28a2a4b33f	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:08:30.838017	A18MMKK126RYNTIZ	\N	b8d224f1-099f-4fce-9fc0-cc28a2a4b33f	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:08:30.838	2022-01-19 19:08:30.838
610683d7-417e-47d9-a36c-a3fcc0aa914e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:08:35.397811	6B7CHFWVHY20ITRX	\N	610683d7-417e-47d9-a36c-a3fcc0aa914e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:08:35.398	2022-01-19 19:08:35.398
f5ea5c5d-8182-4ce7-af16-b8dbd5b39a5d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:08:39.486105	5Z5JFNDX2UZJ4N22	\N	f5ea5c5d-8182-4ce7-af16-b8dbd5b39a5d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:08:39.486	2022-01-19 19:08:39.486
72c1e522-6543-476f-8b7e-680cbe84dd32	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:08:43.581349	1AEPG76FDCOLTONB	\N	72c1e522-6543-476f-8b7e-680cbe84dd32	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:08:43.581	2022-01-19 19:08:43.581
d9cda8fb-f116-4e41-95f9-65e0adeb9b69	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:08:47.683827	5R93JGXHHPGE1YA2	\N	d9cda8fb-f116-4e41-95f9-65e0adeb9b69	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:08:47.684	2022-01-19 19:08:47.684
ebb42aca-f8c0-4658-af66-458578e6b677	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:10:40.26028	5MRTLU95804O7Y5Z	\N	ebb42aca-f8c0-4658-af66-458578e6b677	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:10:40.26	2022-01-19 19:10:40.26
c4532ab5-b181-4e05-83fa-68cc0505745b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:10:44.772325	4NJXHN774O80P4Z6	\N	c4532ab5-b181-4e05-83fa-68cc0505745b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:10:44.772	2022-01-19 19:10:44.772
baf317ba-e3fd-4d59-9165-8b9be6e7a342	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:10:48.949238	50BUD0ESHXJVQK96	\N	baf317ba-e3fd-4d59-9165-8b9be6e7a342	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:10:48.949	2022-01-19 19:10:48.949
f3f138cb-44e0-40c3-b941-e1c8b0410892	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:10:53.062265	LAV1O8GRYDW1272N	\N	f3f138cb-44e0-40c3-b941-e1c8b0410892	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:10:53.062	2022-01-19 19:10:53.062
4af2b8a3-eef1-428c-b8ba-b701e55ef510	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:10:57.57577	1B7Y4ZW6FOU7KBRE	\N	4af2b8a3-eef1-428c-b8ba-b701e55ef510	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:10:57.576	2022-01-19 19:10:57.576
fc5e80e4-a208-4bef-bd34-9be3162c9b4d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:12:17.162537	4OR8JM5IOZXFD9GW	\N	fc5e80e4-a208-4bef-bd34-9be3162c9b4d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:12:17.163	2022-01-19 19:12:17.163
c530893c-f2e4-43ef-9a0a-3cbfc5627bab	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:12:21.697295	4A05I8PWIRNV6XFJ	\N	c530893c-f2e4-43ef-9a0a-3cbfc5627bab	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:12:21.697	2022-01-19 19:12:21.697
55a87bbd-dfb6-4f29-ab68-24b8bfe1af23	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:12:25.758757	69A8E002UJ7G1RLH	\N	55a87bbd-dfb6-4f29-ab68-24b8bfe1af23	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:12:25.759	2022-01-19 19:12:25.759
6fac4668-cfeb-495c-aab9-17f459b04be9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:12:29.851223	JR2VR2ATM9Q6J6I0	\N	6fac4668-cfeb-495c-aab9-17f459b04be9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:12:29.851	2022-01-19 19:12:29.851
b65f67ee-b22b-43af-a04f-50607a713c78	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:12:33.923592	1FF34W9UCOJ63Z1Z	\N	b65f67ee-b22b-43af-a04f-50607a713c78	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:12:33.924	2022-01-19 19:12:33.924
82677696-9782-4123-b989-80140a6f0ecb	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:08.851785	4K1HRT2X59PWCUXG	\N	82677696-9782-4123-b989-80140a6f0ecb	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:08.852	2022-01-19 19:16:08.852
26865bcd-5635-463c-807b-fd9f46aeb1ea	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:11.886511	41KLDBN9B72IL0TP	\N	26865bcd-5635-463c-807b-fd9f46aeb1ea	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:11.887	2022-01-19 19:16:11.887
40399e9d-5abd-4d59-818b-6d061782124a	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:14.49713	3OZ5FO36CKZ1G9J5	\N	40399e9d-5abd-4d59-818b-6d061782124a	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:14.497	2022-01-19 19:16:14.497
851a13cb-3be7-4d4b-b4bf-353503a6aa2b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:17.077386	SBB4U5MB2EMB41DJ	\N	851a13cb-3be7-4d4b-b4bf-353503a6aa2b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:17.077	2022-01-19 19:16:17.077
6997e817-c8cc-44f4-83a1-e202fe0f8068	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:19.64016	4N1PF9UGDAPOB1GZ	\N	6997e817-c8cc-44f4-83a1-e202fe0f8068	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:19.64	2022-01-19 19:16:19.64
2ae5e47d-e8ee-440a-945b-881e18fc8a02	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:22.198882	4W4T5WV8EV7NYSH6	\N	2ae5e47d-e8ee-440a-945b-881e18fc8a02	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:22.199	2022-01-19 19:16:22.199
bec0e199-4d4a-4b60-b39e-40e72e85e0c4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:24.739776	1Z6SV34BO5Q3N7P7	\N	bec0e199-4d4a-4b60-b39e-40e72e85e0c4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:24.74	2022-01-19 19:16:24.74
6d7b9bc9-24e7-4fec-8fae-13d1fcd62429	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:27.306395	3JWNTHGOQIXPN83B	\N	6d7b9bc9-24e7-4fec-8fae-13d1fcd62429	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:27.306	2022-01-19 19:16:27.306
cfea06a7-1da1-4a32-9ac4-6a4a076ed274	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:29.853984	54HVIMM13RD0WTCO	\N	cfea06a7-1da1-4a32-9ac4-6a4a076ed274	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:29.854	2022-01-19 19:16:29.854
04dcbdd5-837e-42c8-9b95-7dcbeee94886	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:16:32.395693	6C1B7XI39FU64M0J	\N	04dcbdd5-837e-42c8-9b95-7dcbeee94886	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:16:32.396	2022-01-19 19:16:32.396
25495ebb-20c3-40ef-9b4e-cc75c1e04f02	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:19.611459	2NN855QQDJGOSVQ8	\N	25495ebb-20c3-40ef-9b4e-cc75c1e04f02	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:19.611	2022-01-19 19:18:19.611
74cf45de-9e29-41ff-9e40-48a9311d5bf4	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:22.831623	4YLIAPL7P3YZQ1OP	\N	74cf45de-9e29-41ff-9e40-48a9311d5bf4	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:22.832	2022-01-19 19:18:22.832
5894778a-40ef-4d13-943c-8b95a9182f87	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:25.384825	4VOWP4G9ZYHA4S6L	\N	5894778a-40ef-4d13-943c-8b95a9182f87	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:25.385	2022-01-19 19:18:25.385
8d553257-503c-47d6-856c-dc2c64d82a20	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:27.981017	2D4JBGTG7TTKKNPF	\N	8d553257-503c-47d6-856c-dc2c64d82a20	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:27.981	2022-01-19 19:18:27.981
506d0816-867a-4b3a-a2a7-161162faa157	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:30.551331	1RZ0G6HYDDN8LLIQ	\N	506d0816-867a-4b3a-a2a7-161162faa157	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:30.551	2022-01-19 19:18:30.551
b1d80f09-a4ae-4f26-bd26-f5d3170c5a1d	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:33.0715	1NUT22N4TSTV081Q	\N	b1d80f09-a4ae-4f26-bd26-f5d3170c5a1d	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:33.072	2022-01-19 19:18:33.072
436dae7e-6103-4f32-b309-4fd9903b8bad	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:35.602804	JXJW072OUW7U3D1I	\N	436dae7e-6103-4f32-b309-4fd9903b8bad	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:35.603	2022-01-19 19:18:35.603
3855a408-8784-4702-b5eb-5691ed7da656	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:38.148701	3WB42VJU14KO6JX0	\N	3855a408-8784-4702-b5eb-5691ed7da656	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:38.149	2022-01-19 19:18:38.149
5ddf1901-0d11-4464-b73e-a5460c51e558	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:40.692377	3PF3BERFMNDAA0ZM	\N	5ddf1901-0d11-4464-b73e-a5460c51e558	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:40.692	2022-01-19 19:18:40.692
d8a70e2d-596c-4364-9243-bb6586921ca5	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:18:43.253721	222UGZC9H28OC4ZY	\N	d8a70e2d-596c-4364-9243-bb6586921ca5	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:18:43.254	2022-01-19 19:18:43.254
5c86ddc3-9f57-4723-a82c-fc5464b1b67b	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:36:52.607217	5MGIT2HGYVSU1O1X	\N	5c86ddc3-9f57-4723-a82c-fc5464b1b67b	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:36:52.607	2022-01-19 19:36:52.607
32e4d30c-8273-4293-a7fc-bb52da485cd1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:36:52.611384	4HL5SYOTA2VXRGBD	\N	32e4d30c-8273-4293-a7fc-bb52da485cd1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:36:52.611	2022-01-19 19:36:52.611
14e51473-8e5f-4e8d-a783-7599f75beab9	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:36:55.598754	1ZHIFTMKKLBSG5CL	\N	14e51473-8e5f-4e8d-a783-7599f75beab9	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:36:55.599	2022-01-19 19:36:55.599
e6bb6593-07ea-448f-9927-b07f51df3c07	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:36:55.627252	48XB5DP5RV3REY4A	\N	e6bb6593-07ea-448f-9927-b07f51df3c07	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:36:55.627	2022-01-19 19:36:55.627
ebda8550-4025-42a2-aaeb-936c63f86cd3	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:36:58.151689	4CFO3DSMLD5UIWM2	\N	ebda8550-4025-42a2-aaeb-936c63f86cd3	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:36:58.152	2022-01-19 19:36:58.152
10bdb3f0-bd63-4399-8711-1a985bc1cc52	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:36:58.207189	1XWF4J8NHKPWE3AH	\N	10bdb3f0-bd63-4399-8711-1a985bc1cc52	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:36:58.207	2022-01-19 19:36:58.207
ffb7f50c-fdd5-4e7e-8efa-d32530c74f4c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:00.728469	PHEOOMBES2IM0WUD	\N	ffb7f50c-fdd5-4e7e-8efa-d32530c74f4c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:00.728	2022-01-19 19:37:00.728
d69293a9-5d4e-4b8c-8cf7-74033a9b905e	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:00.81306	5OMODGIJFZKT9T49	\N	d69293a9-5d4e-4b8c-8cf7-74033a9b905e	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:00.813	2022-01-19 19:37:00.813
107e2dfa-fdea-43e8-a38c-102684a51ddc	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:03.557648	47JL9RUVNSHMSXGY	\N	107e2dfa-fdea-43e8-a38c-102684a51ddc	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:03.558	2022-01-19 19:37:03.558
d250adec-3b22-4ca2-b2a1-02f2daa75a62	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:03.716564	1RDZNH1XZDE4OXX3	\N	d250adec-3b22-4ca2-b2a1-02f2daa75a62	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:03.717	2022-01-19 19:37:03.717
756c0a16-7fc8-4b44-a1bc-9bdca0e90fae	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:06.078711	1R9MJUIVK88DX074	\N	756c0a16-7fc8-4b44-a1bc-9bdca0e90fae	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:06.079	2022-01-19 19:37:06.079
a9d695ba-f130-47e7-95ca-a603545bba22	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:06.223171	43HZZG8EINP6YMAK	\N	a9d695ba-f130-47e7-95ca-a603545bba22	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:06.223	2022-01-19 19:37:06.223
d1f59360-de10-44d4-9c0c-40721eab1a5c	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:08.590021	5T9HQMMU1UR7C51P	\N	d1f59360-de10-44d4-9c0c-40721eab1a5c	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:08.59	2022-01-19 19:37:08.59
630e5016-708c-4d1b-9be1-1c36f99ba8ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:08.746031	4VDWJKPHQKBV9M9M	\N	630e5016-708c-4d1b-9be1-1c36f99ba8ab	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:08.746	2022-01-19 19:37:08.746
de0aa407-a6b3-464f-a581-8baceac91804	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:11.117879	52H6H485A8E0R77D	\N	de0aa407-a6b3-464f-a581-8baceac91804	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:11.118	2022-01-19 19:37:11.118
de5026df-0bf1-4f55-9f1d-b90470cc94c6	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:11.240068	2274867GMKBDK6B0	\N	de5026df-0bf1-4f55-9f1d-b90470cc94c6	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:11.24	2022-01-19 19:37:11.24
6140c6d5-95b9-4821-9d95-218776d28c36	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:13.640557	46CYZDMOLJK94KZX	\N	6140c6d5-95b9-4821-9d95-218776d28c36	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:13.641	2022-01-19 19:37:13.641
fc7db61f-9f1c-4d5e-8f8f-318ec0f458b6	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:13.745166	387HDXLXYBFL3SWX	\N	fc7db61f-9f1c-4d5e-8f8f-318ec0f458b6	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:13.745	2022-01-19 19:37:13.745
ba03c723-c172-4774-bd89-1bf403d83e16	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:16.141921	2DRMSNIQ8BYUF9JV	\N	ba03c723-c172-4774-bd89-1bf403d83e16	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:16.142	2022-01-19 19:37:16.142
7f9df86c-a11f-46a6-bcbc-b4e87c54ce91	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-19 19:37:16.250312	5EPVR4M7YBQT9I0F	\N	7f9df86c-a11f-46a6-bcbc-b4e87c54ce91	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-19 19:37:16.25	2022-01-19 19:37:16.25
ff51f226-2445-454f-9a08-498d064152d1	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-01-21 11:56:24.958822	5BWTY1UD6QPPGVXY	\N	ff51f226-2445-454f-9a08-498d064152d1	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-21 11:56:24.959	2022-01-21 11:56:24.959
182c6e98-6628-427e-a9ad-c2ed60a2bb83	5956e9e9-d73c-499d-b42c-b88136fbbe56	inactive	2022-01-18 14:34:42.346421	Z4P4OCPVGJJZ9N9S	2022-02-03 09:55:31.209	182c6e98-6628-427e-a9ad-c2ed60a2bb83	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 14:34:42.346	2022-02-03 09:55:31.22
d3fcc303-7151-4c32-b4e2-981b81092175	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	2022-02-03 10:44:31.460721	OSCAR	\N	d3fcc303-7151-4c32-b4e2-981b81092175	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-02-03 10:44:31.461	2022-02-03 10:44:31.461
\.


--
-- Data for Name: organization_ownership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.organization_ownership (user_id, organization_id, status, deleted_at, created_at, updated_at) FROM stdin;
0c6b98f0-1a68-45c8-a949-60711c0b2a50	5956e9e9-d73c-499d-b42c-b88136fbbe56	active	\N	2021-12-21 11:05:40.458	2021-12-21 11:05:40.458
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permission (permission_id, permission_name, allow, permission_category, permission_group, permission_level, permission_description, created_at, updated_at, deleted_at, status) FROM stdin;
create_folder_289	create_folder_289	t	Library	Folders	Org Admin	Gives user access to create folders	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_settings_1020	my_settings_1020	t	Accounts	My Account	Student	Gives users access to edit their settings page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_school_pending_225	view_my_school_pending_225	t	Library	Pending	School Admin	Gives users access to view my school pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_folders_255	view_folders_255	t	Library	Folders	Teacher	Gives user access to view folders and the content within folders	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_event_540	delete_event_540	t	Schedule	Delete Schedule	Teacher	Gives users access to delete events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
personalizations_1030	personalizations_1030	t	Accounts	My Account	Student	Gives users access to view personalizations page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
auto_interface_based_on_age_range_171	auto_interface_based_on_age_range_171	t	Live	Live Interface	Teacher	Gives users access to auto interface based on age range	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
change_owner_10880	change_owner_10880	t	Accounts	Organizational Profile	Org Admin	Gives users access to change owners	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_folders_256	create_folders_256	t	Library	Folders	Teacher	Gives user access to create folders and add content to the folders	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_folders_258	delete_folders_258	t	Library	Folders	Teacher	Gives user access to delete folder (will not affect the content within folders)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_page_1040	my_learners_page_1040	t	Accounts	My Learners Page	Student	Gives users access to view my learners page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
collaboration_show_web_cam_dynamic_174	collaboration_show_web_cam_dynamic_174	t	Live	Live Interface	Teacher	Gives teacher access to webcom speaker focus mode	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
collaboration_show_web_cam_focus_175	collaboration_show_web_cam_focus_175	t	Live	Live Interface	Teacher	Gives teacher access to webcam teacher focus mode	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
collaboration_teacher_present_176	collaboration_teacher_present_176	t	Live	Live Interface	Teacher	Gives teacher access to present mode	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
collaboration_observe_mode_177	collaboration_observe_mode_177	t	Live	Live Interface	Teacher	Gives teacher access to observe mode	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_content_page_201	create_content_page_201	t	Library	Create Content	Teacher	Gives users access to create content pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_school_archived_226	view_my_school_archived_226	t	Library	Archive	School Admin	Gives users access to view my school archived	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_all_schools_published_227	view_all_schools_published_227	t	Library	Operational	Org Admin	Gives users access to view all schools published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_all_schools_pending_228	view_all_schools_pending_228	t	Library	Pending	Org Admin	Gives users access to view all schools pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_all_schools_archived_229	view_all_schools_archived_229	t	Library	Archive	Org Admin	Gives users access to view all schools archived	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_lesson_plan_221	create_lesson_plan_221	t	Library	Create Content	Teacher	Gives users access to create lesson plans	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_my_schools_content_223	create_my_schools_content_223	t	Library	Create Content	School Admin	Gives users access to create my schools content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_all_schools_content_224	create_all_schools_content_224	t	Library	Create Content	Org Admin	Gives users access to create all schools content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_unpublished_content_230	edit_my_unpublished_content_230	t	Library	Unpublished	Teacher	Gives users access to edit my unpublished content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_org_unpublished_content_231	edit_org_unpublished_content_231	t	Library	Unpublished	None	Gives users access to edit my org unpublished ontent	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_org_pending_content_233	edit_org_pending_content_233	t	Library	Pending	Org Admin	Gives users access to edit org pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_published_content_234	edit_my_published_content_234	t	Library	Published	Teacher	Gives users access to edit my published content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_org_published_content_235	edit_org_published_content_235	t	Library	Published	Org Admin	Gives users access to edit org published content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_lesson_material_metadata_and_content_236	edit_lesson_material_metadata_and_content_236	t	Library	Edit Content	Org Admin	Gives users access to edit lesson material metadata and content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_lesson_plan_metadata_237	edit_lesson_plan_metadata_237	t	Library	Edit Content	Org Admin	Gives users access to edit lesson plan metadata	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_lesson_plan_content_238	edit_lesson_plan_content_238	t	Library	Edit Content	Org Admin	Gives users access to edit lesson plan content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_lesson_plan_239	download_lesson_plan_239	t	Library	Operational	Org Admin	Gives users access to download lesson plan	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_schools_published_247	edit_my_schools_published_247	t	Library	Published	School Admin	Gives users access to edit my schools published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_schools_pending_248	edit_my_schools_pending_248	t	Library	Pending	School Admin	Gives users access to my schools pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_all_schools_published_249	edit_all_schools_published_249	t	Library	Published	Org Admin	Gives users access to edit all schools published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_all_schools_pending_250	edit_all_schools_pending_250	t	Library	Pending	Org Admin	Gives users access to edit all schools pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_org_archived_content_253	delete_org_archived_content_253	t	Library	Archive	Org Admin	Gives user access to delete organizations archived content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_dashboards_1041	my_learners_dashboards_1041	t	Accounts	My Learners Page	Student	Gives users access to view my learner's dashboards	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_schedule_1042	my_learners_schedule_1042	t	Accounts	My Learners Page	Student	Gives users access to view my learner's schedule page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_study_plan_1043	my_learners_study_plan_1043	t	Accounts	My Learners Page	Student	Gives users access to view my learner's study plan page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_notifications_1044	my_learners_notifications_1044	t	Accounts	My Learners Page	Student	Gives users access to view my learner's notifications 	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_make_a_payment_1045	my_learners_make_a_payment_1045	t	Accounts	My Learners Page	Student	Gives users access to view my learner's make a payment	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_coupon_management_1046	my_learners_coupon_management_1046	t	Accounts	My Learners Page	Student	Gives users access to view my learner's coupon management	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_view_promotions_1047	my_learners_view_promotions_1047	t	Accounts	My Learners Page	Student	Gives users access to view my learner's view promotions	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_class_recordings_1048	my_learners_class_recordings_1048	t	Accounts	My Learners Page	Student	Gives users access to view my learner's class recordings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_learners_attendance_report_1049	my_learners_attendance_report_1049	t	Accounts	My Learners Page	Student	Gives users access to view my learner's attendance report	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
go_live_101	go_live_101	t	Live	Go Live Interface	Student	Gives users access to Go Live interfaces (via buttons and links)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_organization_live_recordings_110	view_organization_live_recordings_110	t	Live	Recordings	Org Admin	Gives users access to view organization live recordings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
manage_live_classroom_recording_120	manage_live_classroom_recording_120	t	Live	Recordings	Org Admin	Gives users access to manage live classroom recordings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
override_live_classroom_recording_130	override_live_classroom_recording_130	t	Live	Recordings	Org Admin	Gives users access to override live classroom recordings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_live_classroom_recordings_140	delete_live_classroom_recordings_140	t	Live	Recordings	Org Admin	Gives users access to delete live classroom recordings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
live_default_interface_170	live_default_interface_170	t	Live	Live Interface	Teacher	Gives users access to Live's default interface	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_unpublished_content_240	delete_my_unpublished_content_240	t	Library	Unpublished	Teacher	Gives users access to delete my unpublished content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_schools_pending_241	delete_my_schools_pending_241	t	Library	Pending	School Admin	Gives users access to delete my schools pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
remove_my_schools_published_242	remove_my_schools_published_242	t	Library	Published	School Admin	Gives users access to remove my schools published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_schools_archived_243	delete_my_schools_archived_243	t	Library	Archive	School Admin	Gives users access to delete my schools archived	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_all_schools_pending_244	delete_all_schools_pending_244	t	Library	Archive	Org Admin	Gives users access to delete all schools pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
remove_all_schools_published_245	remove_all_schools_published_245	t	Library	Published	Org Admin	Gives users access to remove all schools published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_all_schools_archived_246	delete_all_schools_archived_246	t	Library	Archive	Org Admin	Gives users access to delete all schools archived	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
library_settings_270	library_settings_270	t	Library	Operational	Teacher	Gives users access to library settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
change_an_organizations_visibility_settings_10	change_an_organizations_visibility_settings_10	t	Accounts	Super Admin	Super Admin	Gives users access to change an organizations visbility settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
block_org_users_access_12	block_org_users_access_12	t	Accounts	Super Admin	Super Admin	Gives users access to block organization users access	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_pricing_plan_13	create_pricing_plan_13	t	Accounts	Super Admin	Super Admin	Gives users access to create a pricing plan	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_folder_290	view_folder_290	t	Library	Folders	Org Admin	Gives user access to view folders	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_folder_291	edit_folder_291	t	Library	Folders	Org Admin	Gives user access to edit folders	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_folder_292	delete_folder_292	t	Library	Folders	Org Admin	Gives user access to delete folders	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
bulk_visibility_settings_293	bulk_visibility_settings_293	t	Library	Operational	Org Admin	Gives users access to change the visibility settings in bulk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_account_1010	my_account_1010	t	Accounts	My Account	Student	Gives users access to view my account page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_pending_213	view_org_pending_213	t	Library	Pending	Org Admin	Gives users access to view org pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
approve_pending_content_271	approve_pending_content_271	t	Library	Pending	School Admin	Gives users access to approve pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
reject_pending_content_272	reject_pending_content_272	t	Library	Pending	School Admin	Gives users access to reject pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
archive_published_content_273	archive_published_content_273	t	Library	Published	School Admin	Gives users access to archive published content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
republish_archived_content_274	republish_archived_content_274	t	Library	Archive	School Admin	Gives users access to republish archived content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_archived_content_275	delete_archived_content_275	t	Library	Archive	School Admin	Gives users access to delete archived content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
details_upload_thumbnail_276	details_upload_thumbnail_276	t	Library	Operational	Teacher	Gives users access to upload thumbnail for content types	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
details_manually_add_program_277	details_manually_add_program_277	t	Library	Operational	Teacher	Gives users access to define program	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
details_manually_add_developmental_skill_278	details_manually_add_developmental_skill_278	t	Library	Operational	Teacher	Gives users access to define category	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
details_manually_add_skills_category_279	details_manually_add_skills_category_279	t	Library	Operational	Teacher	Gives users access to define subcategory for each category	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
details_manually_add_suitable_age_280	details_manually_add_suitable_age_280	t	Library	Operational	Teacher	Gives users access to define suitable age for content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
favorite_content_283	favorite_content_283	t	Library	Published	Teacher	Gives users access to favorite content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
associate_learning_outcomes_284	associate_learning_outcomes_284	t	Library	Operational	Teacher	Gives users access to associate learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_featured_content_with_lo_285	publish_featured_content_with_lo_285	t	Library	Operational	School Admin	Gives users access to publish featured content with LO	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_featured_content_no_lo_286	publish_featured_content_no_lo_286	t	Library	Operational	School Admin	Gives users access to publish featured content with no LO	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_free_content_with_lo_287	publish_free_content_with_lo_287	t	Library	Operational	School Admin	Gives users access to publish free content with LO	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_free_content_no_lo_288	publish_free_content_no_lo_288	t	Library	Operational	School Admin	Gives users access to publish free content with no LO	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
full_content_management_294	full_content_management_294	t	Library	Operational	Org Admin	Gives users access to all content management features	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
show_all_folders_295	show_all_folders_295	t	Library	Folders	Org Admin	Gives users access to see folders, even when they are empty	2022-02-16 10:49:56.45	2022-02-16 10:49:56.45	\N	active
asset_db_300	asset_db_300	t	Asset Database	Access Asset DB	Teacher	Gives users access to Media Assets (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_asset_page_301	create_asset_page_301	t	Asset Database	Create Asset	Teacher	Gives users access to create asset pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_asset_310	view_asset_310	t	Asset Database	Operational	Teacher	Gives users access to view asset	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_live_recordings_311	view_live_recordings_311	t	Asset Database	Operational	Teacher	Gives users access to view live recordings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_asset_320	create_asset_320	t	Asset Database	Create Asset	Teacher	Gives users access to create asset pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_asset_321	upload_asset_321	t	Asset Database	Operational	Teacher	Gives users access to upload assets	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_asset_330	edit_asset_330	t	Asset Database	Operational	School Admin	Gives users access to edit assets	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_asset_340	delete_asset_340	t	Asset Database	Operational	Org Admin	Gives users access to delete assets	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
asset_db_settings_380	asset_db_settings_380	t	Asset Database	Operational	Teacher	Gives users access to asset DB settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
assessments_400	assessments_400	t	Assessments	Access Assessments	Teacher	Gives users access to assessments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_learning_outcome_page_401	create_learning_outcome_page_401	t	Assessments	Create Learning Outcome	Teacher	Gives users access to create learning outcome pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
unpublished_page_402	unpublished_page_402	t	Assessments	Unpublished	Teacher	Gives users access to view unpublished pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
pending_page_403	pending_page_403	t	Assessments	Pending	Teacher	Gives users access to view pending pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
learning_outcome_page_404	learning_outcome_page_404	t	Assessments	Published Learning Outcome	Teacher	Gives users access to view learning outcome pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
milestones_page_405	milestones_page_405	t	Assessments	Milestones	Teacher	Gives users access to view milestones pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
assessments_page_406	assessments_page_406	t	Assessments	Assessments	Teacher	Gives users access to view assessments pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
standards_page_407	standards_page_407	t	Assessments	Standards	Teacher	Gives users access to view standards pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_unpublished_learning_outcome_410	view_my_unpublished_learning_outcome_410	t	Assessments	Unpublished	Teacher	Gives users access to view my unpublished learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_unpublished_learning_outcome_411	view_org_unpublished_learning_outcome_411	t	Assessments	Unpublished	Org Admin	Gives users access to view org unpublished learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_pending_learning_outcome_412	view_my_pending_learning_outcome_412	t	Assessments	Pending	Teacher	Gives users access to view my pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_pending_learning_outcome_413	view_org_pending_learning_outcome_413	t	Assessments	Pending	School Admin	Gives users access to view org pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_completed_assessments_414	view_completed_assessments_414	t	Assessments	Assessments	Teacher	Gives users access to view completed assessments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_in_progress_assessments_415	view_in_progress_assessments_415	t	Assessments	Assessments	Teacher	Gives users access to view in progress assessments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_published_learning_outcome_416	view_published_learning_outcome_416	t	Assessments	Published Learning Outcome	Teacher	Gives users access to view published learning outcome	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_unpublished_milestone_417	view_unpublished_milestone_417	t	Assessments	Milestones	School Admin	Gives users access to view unpublished milestone	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_published_milestone_418	view_published_milestone_418	t	Assessments	Milestones	School Admin	Gives users access to view published milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_unpublished_standard_419	view_unpublished_standard_419	t	Assessments	Standards	School Admin	Gives users access to view the unpublished standard	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_published_standard_420	view_published_standard_420	t	Assessments	Standards	School Admin	Gives users access to view the published standard	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_learning_outcome_421	create_learning_outcome_421	t	Assessments	Create Learning Outcome	Teacher	Gives users access to edit org unpublished learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_milestone_422	create_milestone_422	t	Assessments	Milestones	School Admin	Gives users access to remove content from the learning outcomes cart	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_standard_423	create_standard_423	t	Assessments	Standards	School Admin	Gives users access to add content learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_completed_assessments_424	view_org_completed_assessments_424	t	Assessments	Assessments	Org Admin	Gives users access to create learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_in_progress_assessments_425	view_org_in_progress_assessments_425	t	Assessments	Assessments	Org Admin	Gives users access to create milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_school_completed_assessments_426	view_school_completed_assessments_426	t	Assessments	Assessments	School Admin	Gives users access to create standards	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_school_in_progress_assessments_427	view_school_in_progress_assessments_427	t	Assessments	Assessments	School Admin	Gives users access to edit my unpublished learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_unpublished_milestone_428	view_my_unpublished_milestone_428	t	Assessments	Milestones	School Admin	Gives users access to view their unpublished milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_pending_milestone_429	view_my_pending_milestone_429	t	Assessments	Milestones	School Admin	Gives users access to view their pending milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_unpublished_learning_outcome_430	edit_my_unpublished_learning_outcome_430	t	Assessments	Unpublished	Teacher	Gives users access to edit my pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_org_unpublished_learning_outcome_431	edit_org_unpublished_learning_outcome_431	t	Assessments	Unpublished	None	Gives users access to edit org pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
remove_content_learning_outcomes_cart_432	remove_content_learning_outcomes_cart_432	t	Assessments	General	Teacher	Gives users access to remove content learning outcomes from the cart	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
add_content_learning_outcomes_433	add_content_learning_outcomes_433	t	Assessments	General	Teacher	Gives users access to add content learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_pending_learning_outcome_434	edit_my_pending_learning_outcome_434	t	Assessments	Pending	Teacher	Gives users access to edit my pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_org_pending_learning_outcome_435	edit_org_pending_learning_outcome_435	t	Assessments	Pending	School Admin	Gives users access to edit org pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_published_learning_outcome_436	edit_published_learning_outcome_436	t	Assessments	Published Learning Outcome	School Admin	Gives users access to edit published learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_attendance_for_completed_assessment_437	edit_attendance_for_completed_assessment_437	t	Assessments	Assessments	None	Gives users access to edit attendance for completed assessmens	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_attendance_for_in_progress_assessment_438	edit_attendance_for_in_progress_assessment_438	t	Assessments	Assessments	Teacher	Gives users access to edit attendance for in progress assessments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_in_progress_assessment_439	edit_in_progress_assessment_439	t	Assessments	Assessments	Teacher	Gives users access to edit in progress assessments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_unpublished_milestone_440	edit_unpublished_milestone_440	t	Assessments	Milestones	School Admin	Gives users access to edit unpublished milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_published_milestone_441	edit_published_milestone_441	t	Assessments	Milestones	School Admin	Gives users access to edit published milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_unpublished_standard_442	edit_unpublished_standard_442	t	Assessments	Standards	School Admin	Gives users access to edit unpublished standards	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_published_standard_443	edit_published_standard_443	t	Assessments	Standards	School Admin	Gives users access to edit published standards	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_unpublished_learning_outcome_444	delete_my_unpublished_learning_outcome_444	t	Assessments	Unpublished	Teacher	Gives users access to delete my unpublished learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_org_unpublished_learning_outcome_445	delete_org_unpublished_learning_outcome_445	t	Assessments	Unpublished	School Admin	Gives users access to delete org unpublished learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_pending_learning_outcome_446	delete_my_pending_learning_outcome_446	t	Assessments	Pending	Teacher	Gives users access to delete my pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_org_pending_learning_outcome_447	delete_org_pending_learning_outcome_447	t	Assessments	Pending	School Admin	Gives users access to delete org pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_published_learning_outcome_448	delete_published_learning_outcome_448	t	Assessments	Published Learning Outcome	School Admin	Gives users access to delete published learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_unpublished_milestone_449	delete_unpublished_milestone_449	t	Assessments	Milestones	School Admin	Gives users access to delete unpublished milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_published_milestone_450	delete_published_milestone_450	t	Assessments	Milestones	School Admin	Gives users access to delete published milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_unpublished_standard_451	delete_unpublished_standard_451	t	Assessments	Standards	School Admin	Gives users access to delete unpublished standards	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_published_standard_452	delete_published_standard_452	t	Assessments	Standards	School Admin	Gives users access to delete published standards	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_in_progress_assessments_453	delete_in_progress_assessments_453	t	Assessments	Assessments	Org Admin	Gives user access to delete in progress assessment feature	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
approve_pending_learning_outcome_481	approve_pending_learning_outcome_481	t	Assessments	Pending	School Admin	Gives users access to approve pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
reject_pending_learning_outcome_482	reject_pending_learning_outcome_482	t	Assessments	Pending	School Admin	Gives users access to reject pending learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_learning_outcomes_484	download_learning_outcomes_484	t	Assessments	General	Org Admin	Gives users access to download learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
add_learning_outcome_to_content_485	add_learning_outcome_to_content_485	t	Assessments	General	Teacher	Gives users access to add learning outcomes to content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_pending_milestone_486	view_pending_milestone_486	t	Assessments	Milestones	Org Admin	Gives users access to view pending milestones within the organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_unpublished_milestone_487	edit_my_unpublished_milestone_487	t	Assessments	Milestones	Teacher	Gives users access to edit their unpublished milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_unpublished_milestone_488	delete_my_unpublished_milestone_488	t	Assessments	Milestones	Teacher	Gives users access to delete their unpublished milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_org_pending_milestone_489	delete_org_pending_milestone_489	t	Assessments	Milestones	Org Admin	Gives users access to delete pending milestones within the organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_pending_milestone_490	delete_my_pending_milestone_490	t	Assessments	Milestones	Teacher	Gives users access to delete their pending milestones	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
approve_pending_milestone_491	approve_pending_milestone_491	t	Assessments	Milestones	School Admin	Gives users access to approve pending milestones within the organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
reject_pending_milestone_492	reject_pending_milestone_492	t	Assessments	Milestones	School Admin	Gives users access to reject pending milestones within the organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_schedule_page_501	create_schedule_page_501	t	Schedule	Create Schedule	Teacher	Gives users access to the schedule page (i.e. via the icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_calendar_511	view_org_calendar_511	t	Schedule	Operational	Org Admin	Gives users access to view org calendar	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_school_calendar_512	view_school_calendar_512	t	Schedule	Operational	School Admin	Gives users access to view school calendar	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_review_calendar_events_513	view_review_calendar_events_513	t	Schedule	Operational	Teacher	Gives users access to view adaptive learning review events on the calendar	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_event_520	create_event_520	t	Schedule	Create Schedule	Org Admin	Gives users access to create events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_my_schedule_events_521	create_my_schedule_events_521	t	Schedule	Create Schedule	Teacher	Gives user access to create events for themselves	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_live_calendar_events_524	create_live_calendar_events_524	t	Schedule	Create Schedule Class Type	Teacher	Gives user access to create Live class events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_learning_outcomes_483	upload_learning_outcomes_483	t	Assessments	General	Org Admin	Gives users access to upload learning outcomes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_class_calendar_events_525	create_class_calendar_events_525	t	Schedule	Create Schedule Class Type	Teacher	Gives user access to create Class class events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_study_calendar_events_526	create_study_calendar_events_526	t	Schedule	Create Schedule Class Type	Teacher	Gives user access to create Study class events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_home_fun_calendar_events_527	create_home_fun_calendar_events_527	t	Schedule	Create Schedule Class Type	Teacher	Gives user access to create Home Fun class events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
override_live_classroom_recording_setting_531	override_live_classroom_recording_setting_531	t	Schedule	Operational	Org Admin	Gives users access to override live classroom recording settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
schedule_settings_580	schedule_settings_580	t	Schedule	Operational	Teacher	Gives users access to schedule settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
schedule_quick_start_581	schedule_quick_start_581	t	Schedule	Create Schedule	Teacher	Gives users access to schedule quick starts	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
schedule_search_582	schedule_search_582	t	Schedule	Operational	School Admin	Gives users access to schedule searches	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
org_reports_601	org_reports_601	t	Reports	Operational	Org Admin	Gives users access to view org reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
school_reports_602	school_reports_602	t	Reports	Operational	School Admin	Gives users access to view school reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
teacher_reports_603	teacher_reports_603	t	Reports	Operational	Teacher	Gives users access to view teacher reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
class_reports_604	class_reports_604	t	Reports	Operational	Student	Gives users access to vew class reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
student_reports_605	student_reports_605	t	Reports	Operational	Student	Gives users access to vew student reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_reports_610	view_reports_610	t	Reports	Operational	Org Admin	Gives users access to view reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_school_reports_611	view_my_school_reports_611	t	Reports	Operational	School Admin	Gives users access to view my school reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_organizations_reports_612	view_my_organizations_reports_612	t	Reports	Operational	Org Admin	Gives users access to view my organization reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_all_organizations_reports_613	view_all_organizations_reports_613	t	Reports	Operational	Super Admin	Gives users access to view all organization reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_reports_614	view_my_reports_614	t	Reports	Operational	Teacher	Gives users access to view my reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_student_achievement_615	report_student_achievement_615	t	Reports	Operational	Teacher	Gives users access to report student achievement	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_learning_outcomes_in_categories_616	report_learning_outcomes_in_categories_616	t	Reports	Operational	Teacher	Gives users access to report learning outcomes in categories	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_organization_teaching_load_617	report_organization_teaching_load_617	t	Reports	Report - Teaching Load	Org Admin	Give users access to teaching load report for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_school_teaching_load_618	report_school_teaching_load_618	t	Reports	Report - Teaching Load	School Admin	Give users access to teaching load report for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_my_teaching_load_619	report_my_teaching_load_619	t	Reports	Report - Teaching Load	Teacher	Give users access to teaching load report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
teachers_classes_teaching_time_report_620	teachers_classes_teaching_time_report_620	t	Reports	Report - Teaching Load	Teacher	Give users access to class teaching time load report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
class_load_time_report_621	class_load_time_report_621	t	Reports	Report - Teaching Load	Teacher	Give users access to class load report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
time_assessing_load_report_622	time_assessing_load_report_622	t	Reports	Report - Teaching Load	Teacher	Give users access to time assessing report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
a_teachers_detailed_time_load_report_623	a_teachers_detailed_time_load_report_623	t	Reports	Report - Teaching Load	Teacher	Give users access to detailed time assessing report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
a_teachers_schedule_load_report_624	a_teachers_schedule_load_report_624	t	Reports	Report - Teaching Load	Teacher	Give users access to schedule load report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
a_teachers_detailed_schedule_load_report_625	a_teachers_detailed_schedule_load_report_625	t	Reports	Report - Teaching Load	Teacher	Give users access to detailed schedule load report for teacher(s)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
organization_class_achievements_report_626	organization_class_achievements_report_626	t	Reports	Report - Class Achievement	Org Admin	Give users access to class achievement report for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
school_class_achievements_report_627	school_class_achievements_report_627	t	Reports	Report - Class Achievement	School Admin	Give users access to class achievement report for schol admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_class_achievements_report_628	my_class_achievements_report_628	t	Reports	Report - Class Achievement	Teacher	Give users access to class achievement report for teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
my_student_achievements_report_629	my_student_achievements_report_629	t	Reports	Report - Class Achievement	Parent	Give users access to student achievement report for parent	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_report_631	download_report_631	t	Report	Operational	School Admin	Gives users access to download reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_organizations_skills_taught_640	report_organizations_skills_taught_640	t	Reports	Report - Skills Taught	Org Admin	Give users access to skills taught report for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_schools_skills_taught_641	report_schools_skills_taught_641	t	Reports	Report - Skills Taught	School Admin	Give users access to skills taught report for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_my_skills_taught_642	report_my_skills_taught_642	t	Reports	Report - Skills Taught	Teacher	Give users access to skills taught report for teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
schedule_500	schedule_500	t	Schedule	Access Schedule	Student	Gives users access to schedule service	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
reports_600	reports_600	t	Reports	Access Reports	Teacher	Gives users access to Reports (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
skills_taught_by_all_teachers_in_this_org_report_643	skills_taught_by_all_teachers_in_this_org_report_643	t	Reports	Report - Skills Taught	Org Admin	Give users access to skills taught report data for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
skills_taught_by_all_teachers_in_my_school_report_644	skills_taught_by_all_teachers_in_my_school_report_644	t	Reports	Report - Skills Taught	School Admin	Give users access to skills taught report data for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
a_teachers_skills_taught_report_645	a_teachers_skills_taught_report_645	t	Reports	Report - Skills Taught	Teacher	Give users access to skills taught report data for teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_organizations_class_achievements_646	report_organizations_class_achievements_646	t	Reports	Report - Class Achievement	Org Admin	Give users access to class achievement report data for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_schools_class_achievements_647	report_schools_class_achievements_647	t	Reports	Report - Class Achievement	School Admin	Give users access to class achievement report data for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_my_class_achievments_648	report_my_class_achievments_648	t	Reports	Report - Class Achievement	Teacher	Give users access to class achievement report data for teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_learning_summary_student_649	report_learning_summary_student_649	t	Reports	Report - Learning Summary	Student	Gives users access to learning summary report for student	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_learning_summary_teacher_650	report_learning_summary_teacher_650	t	Reports	Report - Learning Summary	Teacher	Gives users access to learning summary report for teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_learning_summary_school_651	report_learning_summary_school_651	t	Reports	Report - Learning Summary	School Admin	Gives users access to learning summary report for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_learning_summary_org_652	report_learning_summary_org_652	t	Reports	Report - Learning Summary	Org Admin	Gives users access to learning summary report for org admins	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
learning_summary_report_653	learning_summary_report_653	t	Reports	Report - Learning Summary	Student	Gives users access to learning summary report within the report list	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_organization_student_usage_654	report_organization_student_usage_654	t	Reports	Report - Student Usage 	Org Admin	Gives users access to student usage report for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_school_student_usage_655	report_school_student_usage_655	t	Reports	Report - Student Usage 	School Admin	Gives users access to student usage report for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_teacher_student_usage_656	report_teacher_student_usage_656	t	Reports	Report - Student Usage 	Teacher	Gives users access to student usage report for teachers	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
student_usage_report_657	student_usage_report_657	t	Reports	Report - Student Usage 	Org Admin	Gives users access to student usage report within the report list	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_student_progress_organization_658	report_student_progress_organization_658	t	Reports	Report - Student Progress 	Org Admin	Gives users access to student progress report within the report list for org admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_student_progress_school_659	report_student_progress_school_659	t	Reports	Report - Student Progress 	School Admin	Gives users access to student progress report within the report list for school admin	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_student_progress_teacher_660	report_student_progress_teacher_660	t	Reports	Report - Student Progress 	Teacher	Gives users access to student progress report within the report list for teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_all_organization_details_page_10101	view_all_organization_details_page_10101	t	Accounts	Organizational Profile	Student	Gives users access to view all organization details page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_this_organization_profile_10110	view_this_organization_profile_10110	t	Accounts	Organizational Profile	School Admin	Gives users access to view this organization profile	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_organization_profile_10111	view_my_organization_profile_10111	t	Accounts	Organizational Profile	Student	Gives users access to view my organization profile	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_organization_details_10112	view_organization_details_10112	t	Accounts	Organizational Profile	Student	Gives users access to view organization details	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_own_organization_10220	create_own_organization_10220	t	Accounts	Organizational Profile	Parent	Gives users access to create their own organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
reactivate_own_organization_10221	reactivate_own_organization_10221	t	Accounts	Organizational Profile	Org Admin	Gives users access to reactivate their closed organization account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_this_organization_10330	edit_this_organization_10330	t	Accounts	Organizational Profile	Org Admin	Gives users access to edit this organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_organization_10331	edit_my_organization_10331	t	Accounts	Organizational Profile	Org Admin	Gives users access to edit my organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_password_10333	edit_password_10333	t	Accounts	Organizational Profile	Org Admin	Gives users access to edit their password	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_organization_10440	delete_organization_10440	t	Accounts	Organizational Profile	Org Admin	Gives users access to delete an organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
join_organization_10881	join_organization_10881	t	Accounts	Organizational Profile	Student	Gives users access to join an organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
leave_organization_10882	leave_organization_10882	t	Accounts	Organizational Profile	Student	Gives users access to leave an organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
academic_profile_20100	academic_profile_20100	t	Academic Profile	Schools --> Deprecate	School Admin	Gives users access to School Resources (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
share_report_630	share_report_630	t	Report	Operational	School Admin	Gives users access to share reports	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
define_school_program_page_20101	define_school_program_page_20101	t	Academic Profile	Schools	School Admin	Gives users access to define school program pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
define_age_ranges_page_20102	define_age_ranges_page_20102	t	Academic Profile	Age Range	School Admin	Gives users access to define age ranges page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
define_grade_page_20103	define_grade_page_20103	t	Academic Profile	Grades	School Admin	Gives users access to define grade page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
define_class_page_20104	define_class_page_20104	t	Academic Profile	Classes	School Admin	Gives users access to define class page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
define_program_page_20105	define_program_page_20105	t	Academic Profile	Program	School Admin	Gives users access to define program page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
define_subject_page_20106	define_subject_page_20106	t	Academic Profile	Subjects	School Admin	Gives users access to define subject page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_school_20110	view_school_20110	t	Academic Profile	Schools	School Admin	Gives users access to view school	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_program_20111	view_program_20111	t	Academic Profile	Programs	School Admin	Gives users access to view program	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_age_range_20112	view_age_range_20112	t	Academic Profile	Age Range	School Admin	Gives users access to view age range	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_grades_20113	view_grades_20113	t	Academic Profile	Grades	School Admin	Gives users access to view grades	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_classes_20114	view_classes_20114	t	Academic Profile	Classes	Org Admin	Gives users access to view all classes within the Organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_subjects_20115	view_subjects_20115	t	Academic Profile	Subjects	School Admin	Gives users access to view subjects	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_class_roster_20116	view_class_roster_20116	t	Academic Profile	Classes	School Admin	Gives users access to view class roster	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_school_classes_20117	view_school_classes_20117	t	Academic Profile	Classes	School Admin	Gives users access to view all classes within the associated School	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_classes_20118	view_my_classes_20118	t	Academic Profile	Clases	Teacher	Gives users access to view all classes they are participating as a Teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_school_20119	view_my_school_20119	t	Academic Profile	Schools	School Admin	Gives users access to view their school details	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_school_20220	create_school_20220	t	Academic Profile	Schools	Org Admin	Gives users access to create schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_program_20221	create_program_20221	t	Academic Profile	Programs	School Admin	Gives users access to create programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_age_range_20222	create_age_range_20222	t	Academic Profile	Age Range	School Admin	Gives users access to create age ranges	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_grade_20223	create_grade_20223	t	Academic Profile	Grades	Org Admin	Gives users access to create grades	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_class_20224	create_class_20224	t	Academic Profile	Classes	Org Admin	Gives users access to create classes within the Organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
add_students_to_class_20225	add_students_to_class_20225	t	Academic Profile	Classes	School Admin	Gives users access to add students to class	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
add_teachers_to_class_20226	add_teachers_to_class_20226	t	Academic Profile	Classes	School Admin	Gives users access to add teachers to class	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_subjects_20227	create_subjects_20227	t	Academic Profile	Subjects	Org Admin	Gives users access to create subjects	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_school_classes_20228	create_school_classes_20228	t	Academic Profile	Classes	School Admin	Gives users access to create classes within the associated School	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_school_20330	edit_school_20330	t	Academic Profile	Schools	School Admin	Gives users access to edit school	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_program_20331	edit_program_20331	t	Academic Profile	Programs	School Admin	Gives users access to edit programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_age_range_20332	edit_age_range_20332	t	Academic Profile	Age Range	School Admin	Gives users access to edit age range	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_class_20334	edit_class_20334	t	Academic Profile	Classes	Org Admin	Gives users access to edit classes within the Organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
move_students_to_another_class_20335	move_students_to_another_class_20335	t	Academic Profile	Classes	School Admin	Gives users access to move students to another class	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_role_with_permissions_30222	create_role_with_permissions_30222	t	Accounts	Roles	Org Admin	Gives users access to create roles with permissions	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_role_priority_levels_30331	edit_role_priority_levels_30331	t	Accounts	Roles	Org Admin	Gives users access to edit role priority levels	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_role_and_permissions_30332	edit_role_and_permissions_30332	t	Accounts	Roles	Org Admin	Gives users access to edit role permissions	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_role_30440	delete_role_30440	t	Accounts	Roles	Org Admin	Gives users access to delete roles	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
users_40100	users_40100	t	Accounts	Users	Org Admin	Gives users access to Users Page (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_user_page_40101	view_user_page_40101	t	Accounts	Users	Org Admin	Gives users access to view user pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_school_users_40111	view_my_school_users_40111	t	Accounts	Users	School Admin	Give users access to view users in specific schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_users_40880	upload_users_40880	t	Accounts	Users	Org Admin	Gives users access to upload users	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_users_40881	download_users_40881	t	Accounts	Users	Org Admin	Gives users access to download users	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
send_invitation_40882	send_invitation_40882	t	Accounts	Users	Org Admin	Gives users access to send invitations	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
deactivate_user_40883	deactivate_user_40883	t	Accounts	Users	Org Admin	Gives users access to deactivate users	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
billing_50100	billing_50100	t	Accounts	Billing	Org Admin	Gives users access to Billing Page (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_payment_details_and_make_payment_50101	view_payment_details_and_make_payment_50101	t	Accounts	Billing	Org Admin	Gives users access to view payment details and make payments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_billing_details_50110	view_billing_details_50110	t	Accounts	Billing	Org Admin	Gives users access to view billing details	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_any_featured_programs_70001	view_any_featured_programs_70001	t	Library	Featured Programs	Teacher	Gives users access to view any featured programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_stem_71006	view_bada_stem_71006	t	Library	Featured Programs	Teacher	Gives users access to view Bada STEM	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_badanamu_esl_71007	view_badanamu_esl_71007	t	Library	Featured Programs	Teacher	Gives users access to view Badanamu ESL	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_talk_75002	create_bada_talk_75002	t	Library	Featured Programs	Super Admin	Gives users access to create Bada Talk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_sound_75003	create_bada_sound_75003	t	Library	Featured Programs	Super Admin	Gives users access to create Bada Sound	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_read_75004	create_bada_read_75004	t	Library	Featured Programs	Super Admin	Gives users access to create Bada Read	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_math_75005	create_bada_math_75005	t	Library	Featured Programs	Super Admin	Gives users access to create Bada Math	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_stem_75006	create_bada_stem_75006	t	Library	Featured Programs	Super Admin	Gives users access to create Bada STEM	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_badanamu_esl_75007	create_badanamu_esl_75007	t	Library	Featured Programs	Super Admin	Gives users access to create Badanamu ESL 	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_75008	undefined_75008	t		Featured Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_75009	undefined_75009	t		Featured Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_rhyme_78000	edit_bada_rhyme_78000	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada Rhyme	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_genius_78001	edit_bada_genius_78001	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada Genius	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_talk_78002	edit_bada_talk_78002	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada Talk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_sound_78003	edit_bada_sound_78003	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada Sound	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_read_78004	edit_bada_read_78004	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada Read	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_math_78005	edit_bada_math_78005	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada Math	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_stem_78006	edit_bada_stem_78006	t	Library	Featured Programs	Super Admin	Gives users access to edit Bada STEM	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_badanamu_esl_78007	edit_badanamu_esl_78007	t	Library	Featured Programs	Super Admin	Gives users access to edit Badanamu ESL	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
copy_featured_content_into_library_78008	copy_featured_content_into_library_78008	t	Library	Featured Programs	Org Admin	Gives user access to Copy Featured Content feature	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_featured_content_78009	download_featured_content_78009	t	Library	Featured Programs	Org Admin	Gives user access to Download Featured Content feture	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_age_range_20442	delete_age_range_20442	t	Academic Profile	Age Range	School Admin	Gives users access to delete age ranges	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_grade_20443	delete_grade_20443	t	Academic Profile	Grades	Org Admin	Gives users access to delete grades	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_class_20444	delete_class_20444	t	Academic Profile	Classes	Org Admin	Gives users access to delete classes within the Organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_student_from_class_roster_20445	delete_student_from_class_roster_20445	t	Academic Profile	Classes	School Admin	Gives users access to delete students from class rosters	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_teacher_from_class_20446	delete_teacher_from_class_20446	t	Academic Profile	Classes	School Admin	Gives users access to delete teachers from class	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_schools_20881	download_schools_20881	t	Academic Profile	Schools	Org Admin	Gives users access to download schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_program_20882	upload_program_20882	t	Academic Profile	Programs	Org Admin	Gives users access to upload programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_program_20883	download_program_20883	t	Academic Profile	Programs	Org Admin	Gives users access to download programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_users_40110	view_users_40110	t	Accounts	Users	Org Admin	Gives users access to view users	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_an_organization_details_5	edit_an_organization_details_5	t	Accounts	Super Admin	Super Admin	Gives users access to edit an organizations details	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
collaboration_screenshare_mode_178	collaboration_screenshare_mode_178	t	Live	Live Interface	Teacher	Gives teacher access to screen share feature	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
unpublished_content_page_202	unpublished_content_page_202	t	Library	Unpublished	Teacher	Gives users access to view unpublished content pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
pending_content_page_203	pending_content_page_203	t	Library	Pending	Teacher	Gives users access to view pending content pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_users_40220	create_users_40220	t	Accounts	Users	Org Admin	Gives users access to create users for the organization	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_my_school_users_40221	create_my_school_users_40221	t	Accounts	Users	School Admin	Gives users access to create users for specific schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_my_class_users_40222	create_my_class_users_40222	t	Accounts	Users	Teacher	Gives users access to create users in taught classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_my_users_40223	create_my_users_40223	t	Accounts	Users	Parent	Gives users access to create users under their account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_school_users_40331	edit_my_school_users_40331	t	Accounts	Users	School Admin	Gives users access to edit users in specific schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_class_users_40332	edit_my_class_users_40332	t	Accounts	Users	Teacher	Gives users access to edit users in taught classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_users_40333	edit_my_users_40333	t	Accounts	Users	Parent	Gives users access to edit users under their account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_users_40440	delete_users_40440	t	Accounts	Users	Org Admin	Gives users access to delete users	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_school_users_40441	delete_my_school_users_40441	t	Accounts	Users	School Admin	Gives users access to delete users in specific schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_class_users_40442	delete_my_class_users_40442	t	Accounts	Users	Teacher	Gives users access to delete users in taught classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_rhyme_71000	view_bada_rhyme_71000	t	Library	Featured Programs	Teacher	Gives users access to view Bada Rhyme	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_talk_71002	view_bada_talk_71002	t	Library	Featured Programs	Teacher	Gives users access to view Bada Talk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_sound_71003	view_bada_sound_71003	t	Library	Featured Programs	Teacher	Gives users access to view Bada Sound	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_read_71004	view_bada_read_71004	t	Library	Featured Programs	Teacher	Gives users access to view Bada Read	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_math_71005	view_bada_math_71005	t	Library	Featured Programs	Teacher	Gives users access to view Bada Math	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
published_content_page_204	published_content_page_204	t	Library	Published	Teacher	Gives users access to view published content pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
archived_content_page_205	archived_content_page_205	t	Library	Archive	Teacher	Gives users access to view archived content pages	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_asset_db_300	view_asset_db_300	t	Library	Asset DB	Org Admin	Gives users access to view asset database	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_unpublished_content_210	view_my_unpublished_content_210	t	Library	Unpublished	Teacher	Gives users access to view my unpublished content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_unpublished_content_211	view_org_unpublished_content_211	t	Library	Unpublished	None	Gives users access to view org unpublished content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_pending_212	view_my_pending_212	t	Library	Pending	Teacher	Gives users access to view my pending	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_published_214	view_my_published_214	t	Library	Published	Teacher	Gives users access to view my published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_published_215	view_org_published_215	t	Library	Operational	Student	Gives users access to view org published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_archived_216	view_my_archived_216	t	Library	Archive	Org Admin	Gives users access to view my archived	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_org_archived_217	view_org_archived_217	t	Library	Archive	Org Admin	Gives users access to view org archived	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_school_published_218	view_my_school_published_218	t	Library	Operational	Teacher	Gives users access to view my school published	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
remove_org_published_content_254	remove_org_published_content_254	t	Library	Archive	Org Admin	Gives user access to remove organization published content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
copy_content_222	copy_content_222	t	Library	Create Content	School Admin	Gives users access to copy content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_calendar_510	view_my_calendar_510	t	Schedule	Operational	Student	Gives users access to view my calendar	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_email_address_10332	edit_email_address_10332	t	Accounts	Organizational Profile	Org Admin	Gives users access to edit their email address	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_grade_20333	edit_grade_20333	t	Academic Profile	Grades	Org Admin	Gives users access to edit grades	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_teacher_in_class_20336	edit_teacher_in_class_20336	t	Academic Profile	Classes	School Admin	Gives users access to edit teacher in class	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_subjects_20337	edit_subjects_20337	t	Academic Profile	Subjects	Org Admin	Gives users access to edit subjects	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_students_in_class_20338	edit_students_in_class_20338	t	Academic Profile	Classes	School Admin	Gives users access to edit students in class	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_school_class_20339	edit_school_class_20339	t	Academic Profile	Classes	School Admin	Gives users access to edit classes within the associated School	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_school_20440	delete_school_20440	t	Academic Profile	Schools	School Admin	Gives users access to delete schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_program_20441	delete_program_20441	t	Academic Profile	Programs	School Admin	Gives users access to delete programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_subjects_20447	delete_subjects_20447	t	Academic Profile	Subjects	Org Admin	Gives users access to delete subjects	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_school_class_20448	delete_school_class_20448	t	Academic Profile	Classes	School Admin	Gives users access to delete classes within the associated School	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_schools_20880	upload_schools_20880	t	Academic Profile	Schools	Org Admin	Gives users access to upload schools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_grades_20888	upload_grades_20888	t	Academic Profile	Grades	Org Admin	Gives users access to upload grades	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_groups_30220	create_groups_30220	t	Accounts	Roles	Org Admin	Gives users access to create groups	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_role_priority_levels_30221	create_role_priority_levels_30221	t	Accounts	Roles	Org Admin	Gives users access to create role priority levels	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_class_users_40112	view_my_class_users_40112	t	Accounts	Users	Teacher	Gives users access to view users in taught classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_my_users_40113	view_my_users_40113	t	Accounts	Users	Parent	Gives users access to view users under their account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_users_40443	delete_my_users_40443	t	Accounts	Users	Parent	Gives users access to delete users under their account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_event_530	edit_event_530	t	Schedule	Edit Schedule	Teacher	Gives users access to edit events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_genius_81001	view_bada_genius_81001	t	Library	Free Programs	Teacher	Gives users access to view Bada Genius	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_talk_81002	view_bada_talk_81002	t	Library	Free Programs	Teacher	Gives users access to view Bada Talk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_sound_81003	view_bada_sound_81003	t	Library	Free Programs	Teacher	Gives users access to view Bada Sound	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_read_81004	view_bada_read_81004	t	Library	Free Programs	Teacher	Gives users access to view Bada Read	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_math_81005	view_bada_math_81005	t	Library	Free Programs	Teacher	Gives users access to view Bada Math	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_stem_81006	view_bada_stem_81006	t	Library	Free Programs	Teacher	Gives users access to view Bada STEM	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
use_free_as_recommended_content_for_study_81008	use_free_as_recommended_content_for_study_81008	t	Library	Free Programs	Teacher	Gives users access to use free as recommended content for study	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefinend_81009	undefinend_81009	t		Free Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_rhyme_85000	create_bada_rhyme_85000	t	Library	Free Programs	Super Admin	Gives users access to create Bada Rhyme	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_genius_85001	create_bada_genius_85001	t	Library	Free Programs	Super Admin	Gives users access to create Bada Genius	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_talk_85002	create_bada_talk_85002	t	Library	Free Programs	Super Admin	Gives users access to create Bada Talk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_sound_85003	create_bada_sound_85003	t	Library	Free Programs	Super Admin	Gives users access to create Bada Sound	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_stem_85006	create_bada_stem_85006	t	Library	Free Programs	Super Admin	Gives users access to create Bada STEM	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_85008	undefined_85008	t		Free Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_85009	undefined_85009	t		Free Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
approve_and_reject_pending_content_8	approve_and_reject_pending_content_8	t	Accounts	Super Admin	Super Admin	Gives users access to approve and reject pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_program_category_9	create_program_category_9	t	Accounts	Super Admin	Super Admin	Gives users access to create a program category	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_organization_bill_details_11	view_organization_bill_details_11	t	Accounts	Super Admin	Super Admin	Gives users access to view organization bill details	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_an_organization_account_1	create_an_organization_account_1	t	Accounts	Super Admin	Super Admin	Gives uers access to create an organization account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_an_organization_account_2	delete_an_organization_account_2	t	Accounts	Super Admin	Super Admin	Gives users access to delete an organization account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
reset_an_organization_account_3	reset_an_organization_account_3	t	Accounts	Super Admin	Super Admin	Gives users access to reset an organizations account	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
setup_an_organizations_academic_profile_4	setup_an_organizations_academic_profile_4	t	Accounts	Super Admin	Super Admin	Gives users access to setup an organizations academic profile	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upgrade_organization_publishing_permissions_7	upgrade_organization_publishing_permissions_7	t	Accounts	Super Admin	Super Admin	Gives users access to upgrade organization publishing permissions	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
live_100	live_100	t	Live	Access Live Service	Student	Gives users access to Live	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
participants_tab_179	participants_tab_179	t	Live	Live Interface	Teacher	Gives teacher access to list of participants	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
lesson_plan_tab_180	lesson_plan_tab_180	t	Live	Live Interface	Teacher	Gives teacher access to list of lesson materials in lesson plan	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
teaches_desk_tab_181	teaches_desk_tab_181	t	Live	Live Interface	Teacher	Gives teacher access to other classroom management tools	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
settings_tab_182	settings_tab_182	t	Live	Live Interface	Teacher	Gives teacher access to Live settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_lesson_attachments_183	view_lesson_attachments_183	t	Live	Live Interface	Teacher	Gives users access to view lesson attachments	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_starred_content_184	view_starred_content_184	t	Live	Live Interface	Teacher	Gives users access to view starred content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
see_recommended_content_based_on_age_range_185	see_recommended_content_based_on_age_range_185	t	Live	Live Interface	Teacher	Gives users access to see recommended content based on age range	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
attend_live_class_as_a_teacher_186	attend_live_class_as_a_teacher_186	t	Live	Live for Teachers	Teacher	Gives users access to attend live class as a teacher	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
attend_live_class_as_a_student_187	attend_live_class_as_a_student_187	t	Live	Live for Students	Student	Gives users access to attend live class as a student	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
library_200	library_200	t	Library	Access Library	Teacher	Gives users access to Library (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_folders_257	edit_folders_257	t	Library	Folders	Teacher	Gives user access to edit folder details	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_my_pending_251	delete_my_pending_251	t	Library	Pending	Teacher	Gives user access to delete their pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
delete_org_pending_content_252	delete_org_pending_content_252	t	Library	Pending	Org Admin	Gives user access to delete organization's pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_asset_331	download_asset_331	t	Asset Database	Operational	Org Admin	Gives users access to download assets	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_my_schools_schedule_events_522	create_my_schools_schedule_events_522	t	Schedule	Create Schedule	School Admin	Gives user access to create events for the school	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_review_calendar_events_523	create_review_calendar_events_523	t	Schedule	Create Schedule Class Type	Teacher	Gives user access to create adaptive learning review events	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_users_40330	edit_users_40330	t	Accounts	Users	Org Admin	Gives users access to edit users	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
purchase_more_minutes_50880	purchase_more_minutes_50880	t	Accounts	Billing	Org Admin	Gives users access to purchase more minutes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
purchase_more_storage_50881	purchase_more_storage_50881	t	Accounts	Billing	Org Admin	Gives users access to purchase more storage	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
purchase_next_plan_50882	purchase_next_plan_50882	t	Accounts	Billing	Org Admin	Gives users access to purchase the next plan	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_billing_50883	download_billing_50883	t	Accounts	Billing	Org Admin	Gives users access to download billing	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
support_60100	support_60100	t	General	Support	Student	Gives users access to Suppoort Page (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
online_support_60101	online_support_60101	t	General	Support	Student	Gives users access to view online support	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
featured_programs_70000	featured_programs_70000	t	Library	Featured Programs	Teacher	Gives users access to Featured Programs Page (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_71009	undefined_71009	t		Featured Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_featured_content_for_all_hub_79000	publish_featured_content_for_all_hub_79000	t	Library	Featured Programs	Super Admin	Gives users access to publish featured content for all hub	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_featured_content_for_specific_orgs_79001	publish_featured_content_for_specific_orgs_79001	t	Library	Featured Programs	Super Admin	Gives users access to publish featured content for specific organizations	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_featured_content_for_all_orgs_79002	publish_featured_content_for_all_orgs_79002	t	Library	Featured Programs	Super Admin	Gives users access to publish featured content for all organizations	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
free_programs_80000	free_programs_80000	t	Library	Free Programs	Teacher	Gives users access to Free Programs Page (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_free_programs_80001	view_free_programs_80001	t	Library	Free Programs	Teacher	Gives users access to view free programs	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_rhyme_81000	view_bada_rhyme_81000	t	Library	Free Programs	Teacher	Gives users access to view Bada Rhyme	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_student_progress_student_661	report_student_progress_student_661	t	Reports	Report - Student Progress 	Student	Gives users access to student progress report within the report list for student	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
student_progress_report_662	student_progress_report_662	t	Reports	Report - Student Progress 	Student	Gives users access to student progress report within the report list 	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_teacher_feedback_670	view_teacher_feedback_670	t	Reports	Report - Teacher Feedback	Student	Gives user visibility of the teacher feedback card	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
report_settings_680	report_settings_680	t	Report	Operational	School Admin	Gives users access to report settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
organizational_profile_10100	organizational_profile_10100	t	Accounts	Organizational Profile	Student	Gives users access to Organizational Profile (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_class_roster_with_teachers_20884	upload_class_roster_with_teachers_20884	t	Academic Profile	Classes	Org Admin	Gives users access to upload class rosters with teachers	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_class_roster_with_teachers_20885	download_class_roster_with_teachers_20885	t	Academic Profile	Classes	Org Admin	Gives users access to download class rosters with teachers	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_age_range_20886	upload_age_range_20886	t	Academic Profile	Age Range	Org Admin	Gives users access to upload age ranges	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_age_range_20887	download_age_range_20887	t	Academic Profile	Age Range	Org Admin	Gives users access to download age ranges	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_grades_20889	download_grades_20889	t	Academic Profile	Grades	Org Admin	Gives users access to download grades	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_classes_20890	upload_classes_20890	t	Academic Profile	Classes	Org Admin	Gives users access to upload classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_classes_20891	download_classes_20891	t	Academic Profile	Classes	Org Admin	Gives users access to download classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
upload_subject_20892	upload_subject_20892	t	Academic Profile	Subjects	Org Admin	Gives users access to upload subjects	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_subject_20893	download_subject_20893	t	Academic Profile	Subjects	Org Admin	Gives users access to download subjects	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
roles_30100	roles_30100	t	Accounts	Roles	Org Admin	Gives users access to Roles Page (i.e. via icons/buttons)	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
role_levels_30101	role_levels_30101	t	Accounts	Roles	Org Admin	Gives users access to view role levels	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
roles_and_permissions_30102	roles_and_permissions_30102	t	Accounts	Roles	Org Admin	Gives users access to view roles and permissions page	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_roles_and_permissions_30110	view_roles_and_permissions_30110	t	Accounts	Roles	Org Admin	Gives users access to view roles and permissions	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_role_priority_levels_30111	view_role_priority_levels_30111	t	Accounts	Roles	Org Admin	Gives users access to view role priority levels	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_role_permissions_30112	view_role_permissions_30112	t	Accounts	Roles	Org Admin	Gives users access to view role permissions	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
copy_free_content_into_library_88008	copy_free_content_into_library_88008	t	Library	Free Programs	Org Admin	Gives user access to Copy Free Content feature	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
download_free_content__88009	download_free_content__88009	t	Library	Free Programs	Org Admin	Gives user access to Download Free Content feture	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_free_content_for_all_hub_89000	publish_free_content_for_all_hub_89000	t	Library	Free Programs	Super Admin	Gives users access to publish free content for all hub	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_free_content_for_specific_orgs_89001	publish_free_content_for_specific_orgs_89001	t	Library	Free Programs	Super Admin	Gives users access to publish free content for specific organizations	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
publish_free_content_for_all_orgs_89002	publish_free_content_for_all_orgs_89002	t	Library	Free Programs	Super Admin	Gives users access to publish frree content for all organizations	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_rhyme_88000	edit_bada_rhyme_88000	t	Library	Free Programs	Super Admin	Gives users access to edit Bada Rhyme	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_genius_88001	edit_bada_genius_88001	t	Library	Free Programs	Super Admin	Gives users access to edit Bada Genius	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_talk_88002	edit_bada_talk_88002	t	Library	Free Programs	Super Admin	Gives users access to edit Bada Talk	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_sound_88003	edit_bada_sound_88003	t	Library	Free Programs	Super Admin	Gives users access to edit Bada Sound	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_read_88004	edit_bada_read_88004	t	Library	Free Programs	Super Admin	Gives users access to edit Bada Read	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_math_88005	edit_bada_math_88005	t	Library	Free Programs	Super Admin	Gives users access to edit Bada Math	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_bada_stem_88006	edit_bada_stem_88006	t	Library	Free Programs	Super Admin	Gives users access to edit Bada STEM	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
logos_1000	logos_1000	t	Accounts	My Account	Student	Gives users access to manage their logos	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_my_pending_content_232	edit_my_pending_content_232	t	Library	Pending	Teacher	Gives users access to edit my pending content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_rhyme_75000	create_bada_rhyme_75000	t	Library	Featured Programs	Super Admin	Gives users access to create Bada Rhyme	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_genius_75001	create_bada_genius_75001	t	Library	Featured Programs	Super Admin	Gives users access to create Bada Genius	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_85007	undefined_85007	t		Free Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
share_content_282	share_content_282	t	Library	Published	Teacher	Gives users access to share content	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_groups_30330	edit_groups_30330	t	Accounts	Roles	Org Admin	Gives users access to edit groups	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_bada_genius_71001	view_bada_genius_71001	t	Library	Featured Programs	Teacher	Gives users access to view Bada Genius	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
record_live_classes_172	record_live_classes_172	t	Live	Live Interface	Teacher	Gives users acces to record live classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_lesson_material_220	create_lesson_material_220	t	Library	Create Content	Teacher	Gives users access to create lesson material	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
details_manually_add_grade_281	details_manually_add_grade_281	t	Library	Operational	Teacher	Gives users access to define the grade	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
undefined_71008	undefined_71008	t		Featured Programs		undefined	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
view_badanamu_esl_81007	view_badanamu_esl_81007	t	Library	Free Programs	Teacher	Gives users access to view Badanamu ESL	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
edit_badanamu_esl_88007	edit_badanamu_esl_88007	t	Library	Free Programs	Super Admin	Gives users access to edit Badanamu ESL	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
update_default_thumbnails_6	update_default_thumbnails_6	t	Accounts	Super Admin	Super Admin	Gives users access to update default thumbnails	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
record_class_classes_173	record_class_classes_173	t	Live	Live Interface	Teacher	Gives users access to record class classes	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_read_85004	create_bada_read_85004	t	Library	Free Programs	Super Admin	Gives users access to create Bada Read	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
create_bada_math_85005	create_bada_math_85005	t	Library	Free Programs	Super Admin	Gives users access to create Bada Math	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
assessment_settings_480	assessment_settings_480	t	Assessments	General	Org Admin	Gives users access to view assessment settings	2021-12-21 11:04:35.446	2021-12-21 11:04:35.446	\N	active
\.


--
-- Data for Name: permission_roles_role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permission_roles_role ("permissionPermissionId", "roleRoleId") FROM stdin;
show_all_folders_295	974b5351-80f6-4964-9879-dddce853b6b3
delete_my_pending_251	974b5351-80f6-4964-9879-dddce853b6b3
delete_org_pending_content_252	974b5351-80f6-4964-9879-dddce853b6b3
delete_org_archived_content_253	974b5351-80f6-4964-9879-dddce853b6b3
create_folder_289	974b5351-80f6-4964-9879-dddce853b6b3
view_folder_290	974b5351-80f6-4964-9879-dddce853b6b3
edit_folder_291	974b5351-80f6-4964-9879-dddce853b6b3
delete_folder_292	974b5351-80f6-4964-9879-dddce853b6b3
bulk_visibility_settings_293	974b5351-80f6-4964-9879-dddce853b6b3
standards_page_407	974b5351-80f6-4964-9879-dddce853b6b3
logos_1000	974b5351-80f6-4964-9879-dddce853b6b3
live_100	974b5351-80f6-4964-9879-dddce853b6b3
go_live_101	974b5351-80f6-4964-9879-dddce853b6b3
live_default_interface_170	974b5351-80f6-4964-9879-dddce853b6b3
collaboration_show_web_cam_dynamic_174	974b5351-80f6-4964-9879-dddce853b6b3
collaboration_show_web_cam_focus_175	974b5351-80f6-4964-9879-dddce853b6b3
collaboration_teacher_present_176	974b5351-80f6-4964-9879-dddce853b6b3
collaboration_observe_mode_177	974b5351-80f6-4964-9879-dddce853b6b3
collaboration_screenshare_mode_178	974b5351-80f6-4964-9879-dddce853b6b3
participants_tab_179	974b5351-80f6-4964-9879-dddce853b6b3
lesson_plan_tab_180	974b5351-80f6-4964-9879-dddce853b6b3
teaches_desk_tab_181	974b5351-80f6-4964-9879-dddce853b6b3
settings_tab_182	974b5351-80f6-4964-9879-dddce853b6b3
view_lesson_attachments_183	974b5351-80f6-4964-9879-dddce853b6b3
attend_live_class_as_a_teacher_186	974b5351-80f6-4964-9879-dddce853b6b3
library_200	974b5351-80f6-4964-9879-dddce853b6b3
create_content_page_201	974b5351-80f6-4964-9879-dddce853b6b3
unpublished_content_page_202	974b5351-80f6-4964-9879-dddce853b6b3
pending_content_page_203	974b5351-80f6-4964-9879-dddce853b6b3
published_content_page_204	974b5351-80f6-4964-9879-dddce853b6b3
archived_content_page_205	974b5351-80f6-4964-9879-dddce853b6b3
view_asset_db_300	974b5351-80f6-4964-9879-dddce853b6b3
view_my_unpublished_content_210	974b5351-80f6-4964-9879-dddce853b6b3
view_my_pending_212	974b5351-80f6-4964-9879-dddce853b6b3
view_org_pending_213	974b5351-80f6-4964-9879-dddce853b6b3
view_my_published_214	974b5351-80f6-4964-9879-dddce853b6b3
view_org_published_215	974b5351-80f6-4964-9879-dddce853b6b3
view_my_archived_216	974b5351-80f6-4964-9879-dddce853b6b3
view_org_archived_217	974b5351-80f6-4964-9879-dddce853b6b3
create_lesson_material_220	974b5351-80f6-4964-9879-dddce853b6b3
create_lesson_plan_221	974b5351-80f6-4964-9879-dddce853b6b3
copy_content_222	974b5351-80f6-4964-9879-dddce853b6b3
create_all_schools_content_224	974b5351-80f6-4964-9879-dddce853b6b3
republish_archived_content_274	974b5351-80f6-4964-9879-dddce853b6b3
delete_archived_content_275	974b5351-80f6-4964-9879-dddce853b6b3
view_all_schools_published_227	974b5351-80f6-4964-9879-dddce853b6b3
view_all_schools_pending_228	974b5351-80f6-4964-9879-dddce853b6b3
view_all_schools_archived_229	974b5351-80f6-4964-9879-dddce853b6b3
edit_my_unpublished_content_230	974b5351-80f6-4964-9879-dddce853b6b3
edit_my_published_content_234	974b5351-80f6-4964-9879-dddce853b6b3
edit_org_published_content_235	974b5351-80f6-4964-9879-dddce853b6b3
edit_lesson_material_metadata_and_content_236	974b5351-80f6-4964-9879-dddce853b6b3
edit_lesson_plan_metadata_237	974b5351-80f6-4964-9879-dddce853b6b3
edit_lesson_plan_content_238	974b5351-80f6-4964-9879-dddce853b6b3
download_lesson_plan_239	974b5351-80f6-4964-9879-dddce853b6b3
delete_my_unpublished_content_240	974b5351-80f6-4964-9879-dddce853b6b3
delete_all_schools_pending_244	974b5351-80f6-4964-9879-dddce853b6b3
remove_all_schools_published_245	974b5351-80f6-4964-9879-dddce853b6b3
delete_all_schools_archived_246	974b5351-80f6-4964-9879-dddce853b6b3
edit_all_schools_published_249	974b5351-80f6-4964-9879-dddce853b6b3
remove_org_published_content_254	974b5351-80f6-4964-9879-dddce853b6b3
library_settings_270	974b5351-80f6-4964-9879-dddce853b6b3
approve_pending_content_271	974b5351-80f6-4964-9879-dddce853b6b3
reject_pending_content_272	974b5351-80f6-4964-9879-dddce853b6b3
archive_published_content_273	974b5351-80f6-4964-9879-dddce853b6b3
details_upload_thumbnail_276	974b5351-80f6-4964-9879-dddce853b6b3
details_manually_add_program_277	974b5351-80f6-4964-9879-dddce853b6b3
details_manually_add_developmental_skill_278	974b5351-80f6-4964-9879-dddce853b6b3
details_manually_add_skills_category_279	974b5351-80f6-4964-9879-dddce853b6b3
details_manually_add_suitable_age_280	974b5351-80f6-4964-9879-dddce853b6b3
details_manually_add_grade_281	974b5351-80f6-4964-9879-dddce853b6b3
share_content_282	974b5351-80f6-4964-9879-dddce853b6b3
favorite_content_283	974b5351-80f6-4964-9879-dddce853b6b3
associate_learning_outcomes_284	974b5351-80f6-4964-9879-dddce853b6b3
publish_featured_content_with_lo_285	974b5351-80f6-4964-9879-dddce853b6b3
publish_featured_content_no_lo_286	974b5351-80f6-4964-9879-dddce853b6b3
publish_free_content_with_lo_287	974b5351-80f6-4964-9879-dddce853b6b3
publish_free_content_no_lo_288	974b5351-80f6-4964-9879-dddce853b6b3
full_content_management_294	974b5351-80f6-4964-9879-dddce853b6b3
asset_db_300	974b5351-80f6-4964-9879-dddce853b6b3
create_asset_page_301	974b5351-80f6-4964-9879-dddce853b6b3
view_asset_310	974b5351-80f6-4964-9879-dddce853b6b3
view_live_recordings_311	974b5351-80f6-4964-9879-dddce853b6b3
create_asset_320	974b5351-80f6-4964-9879-dddce853b6b3
upload_asset_321	974b5351-80f6-4964-9879-dddce853b6b3
edit_asset_330	974b5351-80f6-4964-9879-dddce853b6b3
download_asset_331	974b5351-80f6-4964-9879-dddce853b6b3
delete_asset_340	974b5351-80f6-4964-9879-dddce853b6b3
asset_db_settings_380	974b5351-80f6-4964-9879-dddce853b6b3
assessments_400	974b5351-80f6-4964-9879-dddce853b6b3
create_learning_outcome_page_401	974b5351-80f6-4964-9879-dddce853b6b3
unpublished_page_402	974b5351-80f6-4964-9879-dddce853b6b3
pending_page_403	974b5351-80f6-4964-9879-dddce853b6b3
learning_outcome_page_404	974b5351-80f6-4964-9879-dddce853b6b3
milestones_page_405	974b5351-80f6-4964-9879-dddce853b6b3
assessments_page_406	974b5351-80f6-4964-9879-dddce853b6b3
view_my_unpublished_learning_outcome_410	974b5351-80f6-4964-9879-dddce853b6b3
view_org_unpublished_learning_outcome_411	974b5351-80f6-4964-9879-dddce853b6b3
view_org_pending_learning_outcome_413	974b5351-80f6-4964-9879-dddce853b6b3
view_completed_assessments_414	974b5351-80f6-4964-9879-dddce853b6b3
view_in_progress_assessments_415	974b5351-80f6-4964-9879-dddce853b6b3
view_published_learning_outcome_416	974b5351-80f6-4964-9879-dddce853b6b3
view_unpublished_milestone_417	974b5351-80f6-4964-9879-dddce853b6b3
view_published_milestone_418	974b5351-80f6-4964-9879-dddce853b6b3
view_published_standard_420	974b5351-80f6-4964-9879-dddce853b6b3
create_learning_outcome_421	974b5351-80f6-4964-9879-dddce853b6b3
create_milestone_422	974b5351-80f6-4964-9879-dddce853b6b3
view_org_completed_assessments_424	974b5351-80f6-4964-9879-dddce853b6b3
view_org_in_progress_assessments_425	974b5351-80f6-4964-9879-dddce853b6b3
view_school_completed_assessments_426	974b5351-80f6-4964-9879-dddce853b6b3
view_school_in_progress_assessments_427	974b5351-80f6-4964-9879-dddce853b6b3
view_my_unpublished_milestone_428	974b5351-80f6-4964-9879-dddce853b6b3
view_my_pending_milestone_429	974b5351-80f6-4964-9879-dddce853b6b3
edit_my_unpublished_learning_outcome_430	974b5351-80f6-4964-9879-dddce853b6b3
remove_content_learning_outcomes_cart_432	974b5351-80f6-4964-9879-dddce853b6b3
add_content_learning_outcomes_433	974b5351-80f6-4964-9879-dddce853b6b3
edit_published_learning_outcome_436	974b5351-80f6-4964-9879-dddce853b6b3
edit_attendance_for_in_progress_assessment_438	974b5351-80f6-4964-9879-dddce853b6b3
edit_in_progress_assessment_439	974b5351-80f6-4964-9879-dddce853b6b3
edit_unpublished_milestone_440	974b5351-80f6-4964-9879-dddce853b6b3
edit_published_milestone_441	974b5351-80f6-4964-9879-dddce853b6b3
edit_unpublished_standard_442	974b5351-80f6-4964-9879-dddce853b6b3
edit_published_standard_443	974b5351-80f6-4964-9879-dddce853b6b3
delete_my_unpublished_learning_outcome_444	974b5351-80f6-4964-9879-dddce853b6b3
delete_org_unpublished_learning_outcome_445	974b5351-80f6-4964-9879-dddce853b6b3
delete_my_pending_learning_outcome_446	974b5351-80f6-4964-9879-dddce853b6b3
delete_org_pending_learning_outcome_447	974b5351-80f6-4964-9879-dddce853b6b3
delete_published_learning_outcome_448	974b5351-80f6-4964-9879-dddce853b6b3
delete_unpublished_milestone_449	974b5351-80f6-4964-9879-dddce853b6b3
delete_published_milestone_450	974b5351-80f6-4964-9879-dddce853b6b3
delete_unpublished_standard_451	974b5351-80f6-4964-9879-dddce853b6b3
delete_published_standard_452	974b5351-80f6-4964-9879-dddce853b6b3
delete_in_progress_assessments_453	974b5351-80f6-4964-9879-dddce853b6b3
assessment_settings_480	974b5351-80f6-4964-9879-dddce853b6b3
free_programs_80000	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
approve_pending_learning_outcome_481	974b5351-80f6-4964-9879-dddce853b6b3
reject_pending_learning_outcome_482	974b5351-80f6-4964-9879-dddce853b6b3
upload_learning_outcomes_483	974b5351-80f6-4964-9879-dddce853b6b3
download_learning_outcomes_484	974b5351-80f6-4964-9879-dddce853b6b3
add_learning_outcome_to_content_485	974b5351-80f6-4964-9879-dddce853b6b3
view_pending_milestone_486	974b5351-80f6-4964-9879-dddce853b6b3
edit_my_unpublished_milestone_487	974b5351-80f6-4964-9879-dddce853b6b3
delete_my_unpublished_milestone_488	974b5351-80f6-4964-9879-dddce853b6b3
delete_org_pending_milestone_489	974b5351-80f6-4964-9879-dddce853b6b3
delete_my_pending_milestone_490	974b5351-80f6-4964-9879-dddce853b6b3
approve_pending_milestone_491	974b5351-80f6-4964-9879-dddce853b6b3
reject_pending_milestone_492	974b5351-80f6-4964-9879-dddce853b6b3
schedule_500	974b5351-80f6-4964-9879-dddce853b6b3
create_schedule_page_501	974b5351-80f6-4964-9879-dddce853b6b3
view_my_calendar_510	974b5351-80f6-4964-9879-dddce853b6b3
view_org_calendar_511	974b5351-80f6-4964-9879-dddce853b6b3
view_school_calendar_512	974b5351-80f6-4964-9879-dddce853b6b3
view_review_calendar_events_513	974b5351-80f6-4964-9879-dddce853b6b3
create_event_520	974b5351-80f6-4964-9879-dddce853b6b3
create_review_calendar_events_523	974b5351-80f6-4964-9879-dddce853b6b3
create_live_calendar_events_524	974b5351-80f6-4964-9879-dddce853b6b3
create_class_calendar_events_525	974b5351-80f6-4964-9879-dddce853b6b3
create_study_calendar_events_526	974b5351-80f6-4964-9879-dddce853b6b3
create_home_fun_calendar_events_527	974b5351-80f6-4964-9879-dddce853b6b3
edit_event_530	974b5351-80f6-4964-9879-dddce853b6b3
override_live_classroom_recording_setting_531	974b5351-80f6-4964-9879-dddce853b6b3
delete_event_540	974b5351-80f6-4964-9879-dddce853b6b3
schedule_settings_580	974b5351-80f6-4964-9879-dddce853b6b3
schedule_quick_start_581	974b5351-80f6-4964-9879-dddce853b6b3
schedule_search_582	974b5351-80f6-4964-9879-dddce853b6b3
reports_600	974b5351-80f6-4964-9879-dddce853b6b3
org_reports_601	974b5351-80f6-4964-9879-dddce853b6b3
school_reports_602	974b5351-80f6-4964-9879-dddce853b6b3
teacher_reports_603	974b5351-80f6-4964-9879-dddce853b6b3
class_reports_604	974b5351-80f6-4964-9879-dddce853b6b3
student_reports_605	974b5351-80f6-4964-9879-dddce853b6b3
view_reports_610	974b5351-80f6-4964-9879-dddce853b6b3
view_my_organizations_reports_612	974b5351-80f6-4964-9879-dddce853b6b3
report_student_achievement_615	974b5351-80f6-4964-9879-dddce853b6b3
report_learning_outcomes_in_categories_616	974b5351-80f6-4964-9879-dddce853b6b3
report_organization_teaching_load_617	974b5351-80f6-4964-9879-dddce853b6b3
teachers_classes_teaching_time_report_620	974b5351-80f6-4964-9879-dddce853b6b3
class_load_time_report_621	974b5351-80f6-4964-9879-dddce853b6b3
time_assessing_load_report_622	974b5351-80f6-4964-9879-dddce853b6b3
a_teachers_detailed_time_load_report_623	974b5351-80f6-4964-9879-dddce853b6b3
a_teachers_schedule_load_report_624	974b5351-80f6-4964-9879-dddce853b6b3
a_teachers_detailed_schedule_load_report_625	974b5351-80f6-4964-9879-dddce853b6b3
organization_class_achievements_report_626	974b5351-80f6-4964-9879-dddce853b6b3
my_student_achievements_report_629	974b5351-80f6-4964-9879-dddce853b6b3
share_report_630	974b5351-80f6-4964-9879-dddce853b6b3
download_report_631	974b5351-80f6-4964-9879-dddce853b6b3
report_organizations_skills_taught_640	974b5351-80f6-4964-9879-dddce853b6b3
skills_taught_by_all_teachers_in_this_org_report_643	974b5351-80f6-4964-9879-dddce853b6b3
report_organizations_class_achievements_646	974b5351-80f6-4964-9879-dddce853b6b3
report_learning_summary_org_652	974b5351-80f6-4964-9879-dddce853b6b3
learning_summary_report_653	974b5351-80f6-4964-9879-dddce853b6b3
report_organization_student_usage_654	974b5351-80f6-4964-9879-dddce853b6b3
student_usage_report_657	974b5351-80f6-4964-9879-dddce853b6b3
report_student_progress_organization_658	974b5351-80f6-4964-9879-dddce853b6b3
student_progress_report_662	974b5351-80f6-4964-9879-dddce853b6b3
report_settings_680	974b5351-80f6-4964-9879-dddce853b6b3
organizational_profile_10100	974b5351-80f6-4964-9879-dddce853b6b3
view_this_organization_profile_10110	974b5351-80f6-4964-9879-dddce853b6b3
view_my_organization_profile_10111	974b5351-80f6-4964-9879-dddce853b6b3
reactivate_own_organization_10221	974b5351-80f6-4964-9879-dddce853b6b3
edit_my_organization_10331	974b5351-80f6-4964-9879-dddce853b6b3
edit_email_address_10332	974b5351-80f6-4964-9879-dddce853b6b3
delete_organization_10440	974b5351-80f6-4964-9879-dddce853b6b3
change_owner_10880	974b5351-80f6-4964-9879-dddce853b6b3
join_organization_10881	974b5351-80f6-4964-9879-dddce853b6b3
leave_organization_10882	974b5351-80f6-4964-9879-dddce853b6b3
academic_profile_20100	974b5351-80f6-4964-9879-dddce853b6b3
define_school_program_page_20101	974b5351-80f6-4964-9879-dddce853b6b3
define_age_ranges_page_20102	974b5351-80f6-4964-9879-dddce853b6b3
define_grade_page_20103	974b5351-80f6-4964-9879-dddce853b6b3
define_class_page_20104	974b5351-80f6-4964-9879-dddce853b6b3
define_program_page_20105	974b5351-80f6-4964-9879-dddce853b6b3
define_subject_page_20106	974b5351-80f6-4964-9879-dddce853b6b3
view_school_20110	974b5351-80f6-4964-9879-dddce853b6b3
view_program_20111	974b5351-80f6-4964-9879-dddce853b6b3
view_age_range_20112	974b5351-80f6-4964-9879-dddce853b6b3
view_grades_20113	974b5351-80f6-4964-9879-dddce853b6b3
view_classes_20114	974b5351-80f6-4964-9879-dddce853b6b3
view_subjects_20115	974b5351-80f6-4964-9879-dddce853b6b3
view_class_roster_20116	974b5351-80f6-4964-9879-dddce853b6b3
create_school_20220	974b5351-80f6-4964-9879-dddce853b6b3
create_program_20221	974b5351-80f6-4964-9879-dddce853b6b3
create_age_range_20222	974b5351-80f6-4964-9879-dddce853b6b3
create_grade_20223	974b5351-80f6-4964-9879-dddce853b6b3
create_class_20224	974b5351-80f6-4964-9879-dddce853b6b3
add_students_to_class_20225	974b5351-80f6-4964-9879-dddce853b6b3
add_teachers_to_class_20226	974b5351-80f6-4964-9879-dddce853b6b3
create_subjects_20227	974b5351-80f6-4964-9879-dddce853b6b3
edit_school_20330	974b5351-80f6-4964-9879-dddce853b6b3
edit_program_20331	974b5351-80f6-4964-9879-dddce853b6b3
edit_age_range_20332	974b5351-80f6-4964-9879-dddce853b6b3
edit_grade_20333	974b5351-80f6-4964-9879-dddce853b6b3
edit_class_20334	974b5351-80f6-4964-9879-dddce853b6b3
move_students_to_another_class_20335	974b5351-80f6-4964-9879-dddce853b6b3
edit_teacher_in_class_20336	974b5351-80f6-4964-9879-dddce853b6b3
edit_subjects_20337	974b5351-80f6-4964-9879-dddce853b6b3
edit_students_in_class_20338	974b5351-80f6-4964-9879-dddce853b6b3
delete_school_20440	974b5351-80f6-4964-9879-dddce853b6b3
delete_program_20441	974b5351-80f6-4964-9879-dddce853b6b3
delete_age_range_20442	974b5351-80f6-4964-9879-dddce853b6b3
delete_grade_20443	974b5351-80f6-4964-9879-dddce853b6b3
delete_class_20444	974b5351-80f6-4964-9879-dddce853b6b3
delete_student_from_class_roster_20445	974b5351-80f6-4964-9879-dddce853b6b3
delete_teacher_from_class_20446	974b5351-80f6-4964-9879-dddce853b6b3
delete_subjects_20447	974b5351-80f6-4964-9879-dddce853b6b3
upload_schools_20880	974b5351-80f6-4964-9879-dddce853b6b3
download_schools_20881	974b5351-80f6-4964-9879-dddce853b6b3
upload_program_20882	974b5351-80f6-4964-9879-dddce853b6b3
download_program_20883	974b5351-80f6-4964-9879-dddce853b6b3
upload_class_roster_with_teachers_20884	974b5351-80f6-4964-9879-dddce853b6b3
download_class_roster_with_teachers_20885	974b5351-80f6-4964-9879-dddce853b6b3
upload_age_range_20886	974b5351-80f6-4964-9879-dddce853b6b3
download_age_range_20887	974b5351-80f6-4964-9879-dddce853b6b3
upload_grades_20888	974b5351-80f6-4964-9879-dddce853b6b3
download_grades_20889	974b5351-80f6-4964-9879-dddce853b6b3
upload_classes_20890	974b5351-80f6-4964-9879-dddce853b6b3
download_classes_20891	974b5351-80f6-4964-9879-dddce853b6b3
upload_subject_20892	974b5351-80f6-4964-9879-dddce853b6b3
download_subject_20893	974b5351-80f6-4964-9879-dddce853b6b3
roles_30100	974b5351-80f6-4964-9879-dddce853b6b3
roles_and_permissions_30102	974b5351-80f6-4964-9879-dddce853b6b3
view_roles_and_permissions_30110	974b5351-80f6-4964-9879-dddce853b6b3
create_role_with_permissions_30222	974b5351-80f6-4964-9879-dddce853b6b3
edit_role_and_permissions_30332	974b5351-80f6-4964-9879-dddce853b6b3
delete_role_30440	974b5351-80f6-4964-9879-dddce853b6b3
users_40100	974b5351-80f6-4964-9879-dddce853b6b3
view_user_page_40101	974b5351-80f6-4964-9879-dddce853b6b3
view_users_40110	974b5351-80f6-4964-9879-dddce853b6b3
create_users_40220	974b5351-80f6-4964-9879-dddce853b6b3
edit_users_40330	974b5351-80f6-4964-9879-dddce853b6b3
delete_users_40440	974b5351-80f6-4964-9879-dddce853b6b3
upload_users_40880	974b5351-80f6-4964-9879-dddce853b6b3
download_users_40881	974b5351-80f6-4964-9879-dddce853b6b3
send_invitation_40882	974b5351-80f6-4964-9879-dddce853b6b3
deactivate_user_40883	974b5351-80f6-4964-9879-dddce853b6b3
featured_programs_70000	974b5351-80f6-4964-9879-dddce853b6b3
view_any_featured_programs_70001	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_rhyme_71000	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_genius_71001	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_talk_71002	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_sound_71003	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_read_71004	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_math_71005	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_stem_71006	974b5351-80f6-4964-9879-dddce853b6b3
view_badanamu_esl_71007	974b5351-80f6-4964-9879-dddce853b6b3
copy_featured_content_into_library_78008	974b5351-80f6-4964-9879-dddce853b6b3
download_featured_content_78009	974b5351-80f6-4964-9879-dddce853b6b3
view_badanamu_esl_71007	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
publish_featured_content_for_specific_orgs_79001	974b5351-80f6-4964-9879-dddce853b6b3
free_programs_80000	974b5351-80f6-4964-9879-dddce853b6b3
view_free_programs_80001	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_rhyme_81000	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_genius_81001	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_talk_81002	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_sound_81003	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_read_81004	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_math_81005	974b5351-80f6-4964-9879-dddce853b6b3
view_bada_stem_81006	974b5351-80f6-4964-9879-dddce853b6b3
view_badanamu_esl_81007	974b5351-80f6-4964-9879-dddce853b6b3
use_free_as_recommended_content_for_study_81008	974b5351-80f6-4964-9879-dddce853b6b3
copy_free_content_into_library_88008	974b5351-80f6-4964-9879-dddce853b6b3
download_free_content__88009	974b5351-80f6-4964-9879-dddce853b6b3
live_100	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
go_live_101	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
live_default_interface_170	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
collaboration_show_web_cam_dynamic_174	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
collaboration_show_web_cam_focus_175	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
collaboration_teacher_present_176	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
collaboration_observe_mode_177	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
collaboration_screenshare_mode_178	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
participants_tab_179	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
lesson_plan_tab_180	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
teaches_desk_tab_181	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
settings_tab_182	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_lesson_attachments_183	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
attend_live_class_as_a_teacher_186	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
library_200	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_content_page_201	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
unpublished_content_page_202	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
pending_content_page_203	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
published_content_page_204	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
archived_content_page_205	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_asset_db_300	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_unpublished_content_210	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_pending_212	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_published_214	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_org_published_215	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_archived_216	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_school_published_218	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
copy_content_222	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_my_schools_content_223	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_school_pending_225	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_school_archived_226	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_my_unpublished_content_230	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_my_published_content_234	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_unpublished_content_240	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_schools_pending_241	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
remove_my_schools_published_242	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_schools_archived_243	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_my_schools_published_247	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_pending_251	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
library_settings_270	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
approve_pending_content_271	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
reject_pending_content_272	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
archive_published_content_273	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
details_upload_thumbnail_276	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
details_manually_add_program_277	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
details_manually_add_developmental_skill_278	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
details_manually_add_skills_category_279	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
details_manually_add_suitable_age_280	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
details_manually_add_grade_281	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
share_content_282	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
favorite_content_283	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
associate_learning_outcomes_284	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
publish_featured_content_with_lo_285	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
publish_featured_content_no_lo_286	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
publish_free_content_with_lo_287	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
publish_free_content_no_lo_288	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_folder_290	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
asset_db_300	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_asset_page_301	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_asset_310	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_live_recordings_311	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_asset_320	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
upload_asset_321	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_asset_330	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
asset_db_settings_380	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
assessments_400	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_learning_outcome_page_401	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
unpublished_page_402	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
pending_page_403	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
learning_outcome_page_404	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
milestones_page_405	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
assessments_page_406	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
standards_page_407	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_unpublished_learning_outcome_410	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_pending_learning_outcome_412	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_org_pending_learning_outcome_413	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_completed_assessments_414	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_in_progress_assessments_415	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_published_learning_outcome_416	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_unpublished_milestone_417	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_published_milestone_418	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_published_standard_420	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_learning_outcome_421	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_milestone_422	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_school_completed_assessments_426	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_school_in_progress_assessments_427	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_unpublished_milestone_428	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_pending_milestone_429	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_my_unpublished_learning_outcome_430	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
remove_content_learning_outcomes_cart_432	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
add_content_learning_outcomes_433	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_attendance_for_in_progress_assessment_438	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_in_progress_assessment_439	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_unpublished_learning_outcome_444	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_pending_learning_outcome_446	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
approve_pending_learning_outcome_481	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
reject_pending_learning_outcome_482	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
add_learning_outcome_to_content_485	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_pending_milestone_486	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_my_unpublished_milestone_487	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_unpublished_milestone_488	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_pending_milestone_490	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
approve_pending_milestone_491	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
reject_pending_milestone_492	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
schedule_500	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_schedule_page_501	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_calendar_510	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_school_calendar_512	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_review_calendar_events_513	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_my_schools_schedule_events_522	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_review_calendar_events_523	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_live_calendar_events_524	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_class_calendar_events_525	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_study_calendar_events_526	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_home_fun_calendar_events_527	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_event_530	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_event_540	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
schedule_settings_580	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
schedule_quick_start_581	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
schedule_search_582	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
reports_600	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_school_reports_611	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_student_achievement_615	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_learning_outcomes_in_categories_616	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
school_reports_602	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
teacher_reports_603	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
class_reports_604	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
student_reports_605	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_school_teaching_load_618	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
teachers_classes_teaching_time_report_620	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
class_load_time_report_621	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
time_assessing_load_report_622	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
a_teachers_detailed_time_load_report_623	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
a_teachers_schedule_load_report_624	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
a_teachers_detailed_schedule_load_report_625	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
school_class_achievements_report_627	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
my_student_achievements_report_629	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
share_report_630	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
download_report_631	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_schools_skills_taught_641	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
skills_taught_by_all_teachers_in_my_school_report_644	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_schools_class_achievements_647	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_learning_summary_school_651	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
learning_summary_report_653	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_school_student_usage_655	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
student_usage_report_657	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_student_progress_school_659	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
student_progress_report_662	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
report_settings_680	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_organization_profile_10111	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
join_organization_10881	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
leave_organization_10882	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
academic_profile_20100	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
define_school_program_page_20101	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
define_age_ranges_page_20102	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
define_grade_page_20103	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
define_class_page_20104	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
define_program_page_20105	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
define_subject_page_20106	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_program_20111	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_age_range_20112	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_grades_20113	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_subjects_20115	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_class_roster_20116	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_school_classes_20117	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_school_20119	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_program_20221	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_age_range_20222	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_class_20224	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
add_students_to_class_20225	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
add_teachers_to_class_20226	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_school_classes_20228	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_school_20330	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_program_20331	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_age_range_20332	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_class_20334	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
move_students_to_another_class_20335	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_teacher_in_class_20336	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_students_in_class_20338	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_school_class_20339	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_student_from_class_roster_20445	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_teacher_from_class_20446	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_school_class_20448	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
users_40100	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_user_page_40101	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_my_school_users_40111	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
create_my_school_users_40221	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
edit_my_school_users_40331	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
delete_my_school_users_40441	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
send_invitation_40882	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_any_featured_programs_70001	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_rhyme_71000	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_genius_71001	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_talk_71002	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_sound_71003	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_read_71004	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_math_71005	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_stem_71006	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_free_programs_80001	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_rhyme_81000	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_genius_81001	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_talk_81002	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_sound_81003	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_read_81004	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_math_81005	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_bada_stem_81006	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
view_badanamu_esl_81007	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
use_free_as_recommended_content_for_study_81008	775a53c8-5776-4ceb-b2a5-e0fbbc905ebb
live_100	7754d9b5-fed2-4eb9-9481-2012337052ea
go_live_101	7754d9b5-fed2-4eb9-9481-2012337052ea
attend_live_class_as_a_student_187	7754d9b5-fed2-4eb9-9481-2012337052ea
view_org_published_215	7754d9b5-fed2-4eb9-9481-2012337052ea
view_my_school_published_218	7754d9b5-fed2-4eb9-9481-2012337052ea
my_student_achievements_report_629	7754d9b5-fed2-4eb9-9481-2012337052ea
schedule_500	7754d9b5-fed2-4eb9-9481-2012337052ea
view_my_calendar_510	7754d9b5-fed2-4eb9-9481-2012337052ea
student_reports_605	7754d9b5-fed2-4eb9-9481-2012337052ea
report_learning_summary_student_649	7754d9b5-fed2-4eb9-9481-2012337052ea
learning_summary_report_653	7754d9b5-fed2-4eb9-9481-2012337052ea
report_student_progress_student_661	7754d9b5-fed2-4eb9-9481-2012337052ea
student_progress_report_662	7754d9b5-fed2-4eb9-9481-2012337052ea
view_my_organization_profile_10111	7754d9b5-fed2-4eb9-9481-2012337052ea
create_own_organization_10220	7754d9b5-fed2-4eb9-9481-2012337052ea
join_organization_10881	7754d9b5-fed2-4eb9-9481-2012337052ea
leave_organization_10882	7754d9b5-fed2-4eb9-9481-2012337052ea
view_program_20111	7754d9b5-fed2-4eb9-9481-2012337052ea
view_subjects_20115	7754d9b5-fed2-4eb9-9481-2012337052ea
view_school_classes_20117	7754d9b5-fed2-4eb9-9481-2012337052ea
view_my_classes_20118	7754d9b5-fed2-4eb9-9481-2012337052ea
view_my_school_20119	7754d9b5-fed2-4eb9-9481-2012337052ea
create_my_users_40223	7754d9b5-fed2-4eb9-9481-2012337052ea
edit_my_users_40333	7754d9b5-fed2-4eb9-9481-2012337052ea
delete_my_users_40443	7754d9b5-fed2-4eb9-9481-2012337052ea
use_free_as_recommended_content_for_study_81008	7754d9b5-fed2-4eb9-9481-2012337052ea
live_100	d16c5da5-30cd-42f7-9582-2199be94ab30
go_live_101	d16c5da5-30cd-42f7-9582-2199be94ab30
attend_live_class_as_a_student_187	d16c5da5-30cd-42f7-9582-2199be94ab30
view_org_published_215	d16c5da5-30cd-42f7-9582-2199be94ab30
view_my_school_published_218	d16c5da5-30cd-42f7-9582-2199be94ab30
schedule_500	d16c5da5-30cd-42f7-9582-2199be94ab30
view_my_calendar_510	d16c5da5-30cd-42f7-9582-2199be94ab30
student_reports_605	d16c5da5-30cd-42f7-9582-2199be94ab30
report_learning_summary_student_649	d16c5da5-30cd-42f7-9582-2199be94ab30
learning_summary_report_653	d16c5da5-30cd-42f7-9582-2199be94ab30
report_student_progress_student_661	d16c5da5-30cd-42f7-9582-2199be94ab30
student_progress_report_662	d16c5da5-30cd-42f7-9582-2199be94ab30
view_teacher_feedback_670	d16c5da5-30cd-42f7-9582-2199be94ab30
view_my_organization_profile_10111	d16c5da5-30cd-42f7-9582-2199be94ab30
create_own_organization_10220	d16c5da5-30cd-42f7-9582-2199be94ab30
join_organization_10881	d16c5da5-30cd-42f7-9582-2199be94ab30
leave_organization_10882	d16c5da5-30cd-42f7-9582-2199be94ab30
view_program_20111	d16c5da5-30cd-42f7-9582-2199be94ab30
view_subjects_20115	d16c5da5-30cd-42f7-9582-2199be94ab30
view_school_classes_20117	d16c5da5-30cd-42f7-9582-2199be94ab30
view_my_classes_20118	d16c5da5-30cd-42f7-9582-2199be94ab30
view_my_school_20119	d16c5da5-30cd-42f7-9582-2199be94ab30
use_free_as_recommended_content_for_study_81008	d16c5da5-30cd-42f7-9582-2199be94ab30
live_100	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
go_live_101	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
live_default_interface_170	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
collaboration_show_web_cam_dynamic_174	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
collaboration_show_web_cam_focus_175	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
collaboration_teacher_present_176	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
collaboration_observe_mode_177	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
collaboration_screenshare_mode_178	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
participants_tab_179	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
lesson_plan_tab_180	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
teaches_desk_tab_181	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
settings_tab_182	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_lesson_attachments_183	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
attend_live_class_as_a_teacher_186	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
library_200	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_content_page_201	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
unpublished_content_page_202	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
pending_content_page_203	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
published_content_page_204	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
archived_content_page_205	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_asset_db_300	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_unpublished_content_210	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_pending_212	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_published_214	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_org_published_215	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_archived_216	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_school_published_218	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
copy_content_222	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_my_schools_content_223	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_my_unpublished_content_230	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_my_published_content_234	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_my_unpublished_content_240	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_my_pending_251	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
library_settings_270	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
details_upload_thumbnail_276	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
details_manually_add_program_277	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
details_manually_add_developmental_skill_278	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
details_manually_add_skills_category_279	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
details_manually_add_suitable_age_280	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
details_manually_add_grade_281	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
share_content_282	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
favorite_content_283	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
associate_learning_outcomes_284	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_folder_290	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
asset_db_300	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_asset_page_301	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_asset_310	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_live_recordings_311	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_asset_320	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
upload_asset_321	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
asset_db_settings_380	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
assessments_400	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_learning_outcome_page_401	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
unpublished_page_402	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
pending_page_403	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
learning_outcome_page_404	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
milestones_page_405	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
assessments_page_406	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_unpublished_learning_outcome_410	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_pending_learning_outcome_412	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_completed_assessments_414	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_in_progress_assessments_415	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_published_learning_outcome_416	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_published_milestone_418	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_learning_outcome_421	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_milestone_422	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_unpublished_milestone_428	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_pending_milestone_429	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_my_unpublished_learning_outcome_430	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
remove_content_learning_outcomes_cart_432	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
add_content_learning_outcomes_433	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_attendance_for_in_progress_assessment_438	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_in_progress_assessment_439	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_my_unpublished_learning_outcome_444	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_my_pending_learning_outcome_446	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
add_learning_outcome_to_content_485	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_my_unpublished_milestone_487	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_my_unpublished_milestone_488	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_my_pending_milestone_490	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
schedule_500	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_schedule_page_501	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_calendar_510	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_review_calendar_events_513	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_my_schedule_events_521	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_review_calendar_events_523	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_live_calendar_events_524	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_class_calendar_events_525	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_study_calendar_events_526	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
create_home_fun_calendar_events_527	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
edit_event_530	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
delete_event_540	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
schedule_settings_580	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
schedule_quick_start_581	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
reports_600	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
teacher_reports_603	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
class_reports_604	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
student_reports_605	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_reports_614	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_student_achievement_615	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_learning_outcomes_in_categories_616	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_my_teaching_load_619	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
class_load_time_report_621	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
time_assessing_load_report_622	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
a_teachers_detailed_time_load_report_623	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
a_teachers_schedule_load_report_624	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
a_teachers_detailed_schedule_load_report_625	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
my_class_achievements_report_628	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
my_student_achievements_report_629	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_my_skills_taught_642	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
a_teachers_skills_taught_report_645	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_my_class_achievments_648	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_learning_summary_teacher_650	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
learning_summary_report_653	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_teacher_student_usage_656	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
student_usage_report_657	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
report_student_progress_teacher_660	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
student_progress_report_662	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_organization_profile_10111	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
join_organization_10881	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
leave_organization_10882	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_program_20111	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_age_range_20112	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_grades_20113	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_classes_20114	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_subjects_20115	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_school_classes_20117	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_classes_20118	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_school_20119	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_user_page_40101	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_my_class_users_40112	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_any_featured_programs_70001	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_rhyme_71000	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_genius_71001	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_talk_71002	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_sound_71003	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_read_71004	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_math_71005	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_stem_71006	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_badanamu_esl_71007	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
free_programs_80000	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_free_programs_80001	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_rhyme_81000	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_genius_81001	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_talk_81002	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_sound_81003	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_read_81004	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_math_81005	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_bada_stem_81006	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
view_badanamu_esl_81007	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
use_free_as_recommended_content_for_study_81008	9256d54a-8d3f-4261-b4cc-978bfc4ffc1b
\.


--
-- Data for Name: program; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.program (id, name, system, status, created_at, deleted_at, organization_id, updated_at) FROM stdin;
0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0	Program K6 001	f	active	2022-01-18 16:02:32.547	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:02:32.547
30de77f9-0da3-47d5-84a5-394aac654a07	Tester	f	active	2022-01-21 16:11:25.834	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-21 16:11:25.834
b39edb9a-ab91-4245-94a4-eb2b5007c033	Bada Genius	t	active	2021-12-21 11:04:39.705	\N	\N	2021-12-21 11:04:39.705
4591423a-2619-4ef8-a900-f5d924939d02	Bada Math	t	active	2021-12-21 11:04:39.754	\N	\N	2021-12-21 11:04:39.754
7a8c5021-142b-44b1-b60b-275c29d132fe	Bada Read	t	active	2021-12-21 11:04:39.854	\N	\N	2021-12-21 11:04:39.854
93f293e8-2c6a-47ad-bc46-1554caac99e4	Bada Rhyme	t	active	2021-12-21 11:04:39.896	\N	\N	2021-12-21 11:04:39.896
56e24fa0-e139-4c80-b365-61c9bc42cd3f	Bada Sound	t	active	2021-12-21 11:04:39.949	\N	\N	2021-12-21 11:04:39.949
d1bbdcc5-0d80-46b0-b98e-162e7439058f	Bada STEM	t	active	2021-12-21 11:04:39.982	\N	\N	2021-12-21 11:04:39.982
f6617737-5022-478d-9672-0354667e0338	Bada Talk	t	active	2021-12-21 11:04:40.009	\N	\N	2021-12-21 11:04:40.009
cdba0679-5719-47dc-806d-78de42026db6	Bada STEAM 1	t	active	2021-12-21 11:04:40.065	\N	\N	2021-12-21 11:04:40.065
3f98d4a7-6ceb-4a9a-b13a-4f4307ff64d7	C ECE	t	active	2022-01-10 14:55:30.047	\N	\N	2022-01-10 14:55:30.047
7565ae11-8130-4b7d-ac24-1d9dd6f792f2	None Specified	t	active	2021-12-21 11:04:39.562	\N	\N	2021-12-21 11:04:39.562
75004121-0c0d-486c-ba65-4c57deacb44b	ESL	t	active	2021-12-21 11:04:39.606	\N	\N	2021-12-21 11:04:39.606
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	Math	t	active	2021-12-21 11:04:39.635	\N	\N	2021-12-21 11:04:39.635
04c630cc-fabe-4176-80f2-30a029907a33	Science	t	active	2021-12-21 11:04:39.672	\N	\N	2021-12-21 11:04:39.672
\.


--
-- Data for Name: program_age_ranges_age_range; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.program_age_ranges_age_range ("programId", "ageRangeId") FROM stdin;
7565ae11-8130-4b7d-ac24-1d9dd6f792f2	023eeeb1-5f72-4fa3-a2a7-63603607ac2b
75004121-0c0d-486c-ba65-4c57deacb44b	7965d220-619d-400f-8cab-42bd98c7d23c
75004121-0c0d-486c-ba65-4c57deacb44b	bb7982cd-020f-4e1a-93fc-4a6874917f07
75004121-0c0d-486c-ba65-4c57deacb44b	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
75004121-0c0d-486c-ba65-4c57deacb44b	145edddc-2019-43d9-97e1-c5830e7ed689
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	7965d220-619d-400f-8cab-42bd98c7d23c
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	bb7982cd-020f-4e1a-93fc-4a6874917f07
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	145edddc-2019-43d9-97e1-c5830e7ed689
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
04c630cc-fabe-4176-80f2-30a029907a33	7965d220-619d-400f-8cab-42bd98c7d23c
04c630cc-fabe-4176-80f2-30a029907a33	bb7982cd-020f-4e1a-93fc-4a6874917f07
04c630cc-fabe-4176-80f2-30a029907a33	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
04c630cc-fabe-4176-80f2-30a029907a33	145edddc-2019-43d9-97e1-c5830e7ed689
04c630cc-fabe-4176-80f2-30a029907a33	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
b39edb9a-ab91-4245-94a4-eb2b5007c033	7965d220-619d-400f-8cab-42bd98c7d23c
b39edb9a-ab91-4245-94a4-eb2b5007c033	bb7982cd-020f-4e1a-93fc-4a6874917f07
b39edb9a-ab91-4245-94a4-eb2b5007c033	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
4591423a-2619-4ef8-a900-f5d924939d02	7965d220-619d-400f-8cab-42bd98c7d23c
4591423a-2619-4ef8-a900-f5d924939d02	bb7982cd-020f-4e1a-93fc-4a6874917f07
4591423a-2619-4ef8-a900-f5d924939d02	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
4591423a-2619-4ef8-a900-f5d924939d02	145edddc-2019-43d9-97e1-c5830e7ed689
4591423a-2619-4ef8-a900-f5d924939d02	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
7a8c5021-142b-44b1-b60b-275c29d132fe	7965d220-619d-400f-8cab-42bd98c7d23c
7a8c5021-142b-44b1-b60b-275c29d132fe	bb7982cd-020f-4e1a-93fc-4a6874917f07
7a8c5021-142b-44b1-b60b-275c29d132fe	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
7a8c5021-142b-44b1-b60b-275c29d132fe	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
93f293e8-2c6a-47ad-bc46-1554caac99e4	7965d220-619d-400f-8cab-42bd98c7d23c
93f293e8-2c6a-47ad-bc46-1554caac99e4	bb7982cd-020f-4e1a-93fc-4a6874917f07
93f293e8-2c6a-47ad-bc46-1554caac99e4	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
56e24fa0-e139-4c80-b365-61c9bc42cd3f	7965d220-619d-400f-8cab-42bd98c7d23c
56e24fa0-e139-4c80-b365-61c9bc42cd3f	bb7982cd-020f-4e1a-93fc-4a6874917f07
56e24fa0-e139-4c80-b365-61c9bc42cd3f	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
56e24fa0-e139-4c80-b365-61c9bc42cd3f	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
d1bbdcc5-0d80-46b0-b98e-162e7439058f	7965d220-619d-400f-8cab-42bd98c7d23c
d1bbdcc5-0d80-46b0-b98e-162e7439058f	bb7982cd-020f-4e1a-93fc-4a6874917f07
d1bbdcc5-0d80-46b0-b98e-162e7439058f	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
d1bbdcc5-0d80-46b0-b98e-162e7439058f	145edddc-2019-43d9-97e1-c5830e7ed689
d1bbdcc5-0d80-46b0-b98e-162e7439058f	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
f6617737-5022-478d-9672-0354667e0338	7965d220-619d-400f-8cab-42bd98c7d23c
f6617737-5022-478d-9672-0354667e0338	bb7982cd-020f-4e1a-93fc-4a6874917f07
f6617737-5022-478d-9672-0354667e0338	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
cdba0679-5719-47dc-806d-78de42026db6	7965d220-619d-400f-8cab-42bd98c7d23c
cdba0679-5719-47dc-806d-78de42026db6	bb7982cd-020f-4e1a-93fc-4a6874917f07
cdba0679-5719-47dc-806d-78de42026db6	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
cdba0679-5719-47dc-806d-78de42026db6	145edddc-2019-43d9-97e1-c5830e7ed689
cdba0679-5719-47dc-806d-78de42026db6	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
3f98d4a7-6ceb-4a9a-b13a-4f4307ff64d7	7965d220-619d-400f-8cab-42bd98c7d23c
0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0	7965d220-619d-400f-8cab-42bd98c7d23c
0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0	bb7982cd-020f-4e1a-93fc-4a6874917f07
0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
30de77f9-0da3-47d5-84a5-394aac654a07	fe359c71-0b43-40be-99da-8d94cff2143d
30de77f9-0da3-47d5-84a5-394aac654a07	bb7982cd-020f-4e1a-93fc-4a6874917f07
30de77f9-0da3-47d5-84a5-394aac654a07	fe0b81a4-5b02-4548-8fb0-d49cd4a4604a
30de77f9-0da3-47d5-84a5-394aac654a07	145edddc-2019-43d9-97e1-c5830e7ed689
30de77f9-0da3-47d5-84a5-394aac654a07	21f1da64-b6c8-4e74-9fef-09d08cfd8e6c
\.


--
-- Data for Name: program_grades_grade; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.program_grades_grade ("programId", "gradeId") FROM stdin;
7565ae11-8130-4b7d-ac24-1d9dd6f792f2	98461ca1-06a1-432a-97d0-4e1dff33e1a5
75004121-0c0d-486c-ba65-4c57deacb44b	0ecb8fa9-d77e-4dd3-b220-7e79704f1b03
75004121-0c0d-486c-ba65-4c57deacb44b	66fcda51-33c8-4162-a8d1-0337e1d6ade3
75004121-0c0d-486c-ba65-4c57deacb44b	a9f0217d-f7ec-4add-950d-4e8986ab2c82
75004121-0c0d-486c-ba65-4c57deacb44b	e4d16af5-5b8f-4051-b065-13acf6c694be
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	b20eaf10-3e40-4ef7-9d74-93a13782d38f
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	89d71050-186e-4fb2-8cbd-9598ca312be9
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	abc900b9-5b8c-4e54-a4a8-54f102b2c1c6
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	3ee3fd4c-6208-494f-9551-d48fabc4f42a
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	781e8a08-29e8-4171-8392-7e8ac9f183a0
04c630cc-fabe-4176-80f2-30a029907a33	b20eaf10-3e40-4ef7-9d74-93a13782d38f
04c630cc-fabe-4176-80f2-30a029907a33	89d71050-186e-4fb2-8cbd-9598ca312be9
04c630cc-fabe-4176-80f2-30a029907a33	abc900b9-5b8c-4e54-a4a8-54f102b2c1c6
04c630cc-fabe-4176-80f2-30a029907a33	3ee3fd4c-6208-494f-9551-d48fabc4f42a
04c630cc-fabe-4176-80f2-30a029907a33	781e8a08-29e8-4171-8392-7e8ac9f183a0
b39edb9a-ab91-4245-94a4-eb2b5007c033	98461ca1-06a1-432a-97d0-4e1dff33e1a5
4591423a-2619-4ef8-a900-f5d924939d02	d7e2e258-d4b3-4e95-b929-49ae702de4be
4591423a-2619-4ef8-a900-f5d924939d02	3e7979f6-7375-450a-9818-ddb09b250bb2
4591423a-2619-4ef8-a900-f5d924939d02	81dcbcc6-3d70-4bdf-99bc-14833c57c628
4591423a-2619-4ef8-a900-f5d924939d02	100f774a-3d7e-4be5-9c2c-ae70f40f0b50
4591423a-2619-4ef8-a900-f5d924939d02	9d3e591d-06a6-4fc4-9714-cf155a15b415
7a8c5021-142b-44b1-b60b-275c29d132fe	98461ca1-06a1-432a-97d0-4e1dff33e1a5
93f293e8-2c6a-47ad-bc46-1554caac99e4	98461ca1-06a1-432a-97d0-4e1dff33e1a5
56e24fa0-e139-4c80-b365-61c9bc42cd3f	98461ca1-06a1-432a-97d0-4e1dff33e1a5
d1bbdcc5-0d80-46b0-b98e-162e7439058f	d7e2e258-d4b3-4e95-b929-49ae702de4be
d1bbdcc5-0d80-46b0-b98e-162e7439058f	3e7979f6-7375-450a-9818-ddb09b250bb2
d1bbdcc5-0d80-46b0-b98e-162e7439058f	81dcbcc6-3d70-4bdf-99bc-14833c57c628
d1bbdcc5-0d80-46b0-b98e-162e7439058f	100f774a-3d7e-4be5-9c2c-ae70f40f0b50
d1bbdcc5-0d80-46b0-b98e-162e7439058f	9d3e591d-06a6-4fc4-9714-cf155a15b415
f6617737-5022-478d-9672-0354667e0338	98461ca1-06a1-432a-97d0-4e1dff33e1a5
cdba0679-5719-47dc-806d-78de42026db6	d7e2e258-d4b3-4e95-b929-49ae702de4be
cdba0679-5719-47dc-806d-78de42026db6	3e7979f6-7375-450a-9818-ddb09b250bb2
cdba0679-5719-47dc-806d-78de42026db6	81dcbcc6-3d70-4bdf-99bc-14833c57c628
cdba0679-5719-47dc-806d-78de42026db6	100f774a-3d7e-4be5-9c2c-ae70f40f0b50
cdba0679-5719-47dc-806d-78de42026db6	9d3e591d-06a6-4fc4-9714-cf155a15b415
3f98d4a7-6ceb-4a9a-b13a-4f4307ff64d7	4b9c1e70-0178-4c68-897b-dac052a38a80
0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0	e4d16af5-5b8f-4051-b065-13acf6c694be
30de77f9-0da3-47d5-84a5-394aac654a07	e4d16af5-5b8f-4051-b065-13acf6c694be
\.


--
-- Data for Name: program_subjects_subject; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.program_subjects_subject ("programId", "subjectId") FROM stdin;
7565ae11-8130-4b7d-ac24-1d9dd6f792f2	5e9a201e-9c2f-4a92-bb6f-1ccf8177bb71
75004121-0c0d-486c-ba65-4c57deacb44b	20d6ca2f-13df-4a7a-8dcb-955908db7baa
14d350f1-a7ba-4f46-bef9-dc847f0cbac5	7cf8d3a3-5493-46c9-93eb-12f220d101d0
04c630cc-fabe-4176-80f2-30a029907a33	fab745e8-9e31-4d0c-b780-c40120c98b27
b39edb9a-ab91-4245-94a4-eb2b5007c033	66a453b0-d38f-472e-b055-7a94a94d66c4
4591423a-2619-4ef8-a900-f5d924939d02	36c4f793-9aa3-4fb8-84f0-68a2ab920d5a
7a8c5021-142b-44b1-b60b-275c29d132fe	b997e0d1-2dd7-40d8-847a-b8670247e96b
93f293e8-2c6a-47ad-bc46-1554caac99e4	49c8d5ee-472b-47a6-8c57-58daf863c2e1
56e24fa0-e139-4c80-b365-61c9bc42cd3f	b19f511e-a46b-488d-9212-22c0369c8afd
d1bbdcc5-0d80-46b0-b98e-162e7439058f	29d24801-0089-4b8e-85d3-77688e961efb
f6617737-5022-478d-9672-0354667e0338	f037ee92-212c-4592-a171-ed32fb892162
cdba0679-5719-47dc-806d-78de42026db6	f12276a9-4331-4699-b0fa-68e8df172843
3f98d4a7-6ceb-4a9a-b13a-4f4307ff64d7	51189ac9-f206-469c-941c-3cda28af8788
0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0	36c4f793-9aa3-4fb8-84f0-68a2ab920d5a
30de77f9-0da3-47d5-84a5-394aac654a07	51189ac9-f206-469c-941c-3cda28af8788
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role (role_id, role_name, status, deleted_at, role_description, system_role, "organizationOrganizationId", created_at, updated_at) FROM stdin;
974b5351-80f6-4964-9879-dddce853b6b3	Organization Admin	active	\N	System Default Role	t	\N	2021-12-21 11:04:35.648	2021-12-21 11:04:35.648
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	School Admin	active	\N	System Default Role	t	\N	2021-12-21 11:04:35.648	2021-12-21 11:04:35.648
7754d9b5-fed2-4eb9-9481-2012337052ea	Parent	active	\N	System Default Role	t	\N	2021-12-21 11:04:35.648	2021-12-21 11:04:35.648
d16c5da5-30cd-42f7-9582-2199be94ab30	Student	active	\N	System Default Role	t	\N	2021-12-21 11:04:35.648	2021-12-21 11:04:35.648
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	Teacher	active	\N	System Default Role	t	\N	2021-12-21 11:04:35.648	2021-12-21 11:04:35.648
\.


--
-- Data for Name: role_memberships_organization_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_memberships_organization_membership ("roleRoleId", "organizationMembershipUserId", "organizationMembershipOrganizationId") FROM stdin;
974b5351-80f6-4964-9879-dddce853b6b3	0c6b98f0-1a68-45c8-a949-60711c0b2a50	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b4479424-a9d7-46a5-8ee6-40db4ed264b1	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	611824fd-8070-45f0-84af-37295203ae17	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	527c2d4c-2454-4f25-b194-6c6c67fe5026	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	7ccbecd2-5648-492f-a15f-4c8963ca291b	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	0c6b98f0-1a68-45c8-a949-60711c0b2a50	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	182c6e98-6628-427e-a9ad-c2ed60a2bb83	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	08541445-56c2-4550-81ff-7559c945192e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	41e31ea1-ee63-45dc-8f66-60c5bf338245	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2620fd68-8253-40cb-9532-97fdaab65bdc	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8d5e3d77-6813-425f-bfc8-78bc72235210	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	29b980ba-43f1-4789-85eb-0681ecd34d50	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	67e3f25a-6d49-4afc-91f5-422648501c22	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	db087b6f-f44d-4a61-b3ce-4783010eafe1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1478d854-31c1-4c7b-8cd5-946db8fb3913	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cdac1f61-3dc9-4b66-af30-98205a2fef13	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ba4e15d4-06a4-4d74-a83c-b061508eabd6	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	af26e37e-4625-4255-9ccb-bfabe5690b54	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	976cd4cf-3276-4a30-95f9-675c670941f3	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d112f364-50a1-4b07-89d8-ba384bbd2c71	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b13089b9-d832-4907-9240-a6c310763a28	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	41dee2e5-ffd6-4202-8370-98bf7560374d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	252f5821-cfa2-46b8-87f1-aae3673a573b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	60916b31-72ac-4eee-90a0-804746a7a088	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7ea58850-6fdf-4c2b-8c42-56c6a06ef646	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	94f66e07-59b0-49c1-954f-fb30bd95785d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	aaf7e8e7-493d-4eb7-a6ff-8d220e93bbf1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b9eea1fc-71f7-4576-984e-a050d4fe4928	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	371cbf5d-3273-4209-a9a9-df7696134d9f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	166e2026-7bee-4446-98fd-f60e6d189337	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	75da7464-f264-4871-bfee-6a89cd5c61ae	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cc774be4-eee3-4154-955f-2b810cc2c057	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	dbe61da1-8e55-4aa1-a773-a246e885d6f8	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	47f2b855-1e6a-438e-a92b-50ac460b7dd1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	62272ef9-6da6-4297-a5ef-c24f6af31a58	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c687597f-be44-4d0b-ae27-1e03ecfb9906	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	52d4cd1f-bd63-4101-976a-f76648cbe9ae	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b0e45a2e-453d-42b5-9dcd-08ffd6212e9d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d5fe3b89-0526-4c5d-8b51-49d00d83865a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8a73ff19-267d-4d8d-83e5-ebe6cbae5b55	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1a3704d6-18e0-413b-a155-c106a2224e68	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cc537e59-2844-4721-b4c1-1eadddc45bef	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b2469051-827c-4e1a-862d-208593f71ef4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	92cf9d0b-5515-4099-94a4-36ca52653a03	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	25666e2c-d6c5-4207-9299-24e2829292d7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	80d65593-d8f3-4808-9a58-d35c90ef2cab	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	66e82261-9198-440d-b3d4-f6fb2eb3ce94	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	025d1237-74ca-4fcd-838d-31032ae3ab9e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	4f8c6f58-2028-4278-9687-41183657257e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cc6932d8-4dbe-46de-8cac-578d7bc0debb	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f1d75a44-206a-49bb-a44f-04482624fcd0	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5b567c82-5615-4032-9804-e7f101a45330	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	21cfab88-8217-44ea-81c8-65ea3319d70e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	daa456ce-9550-4d7d-802c-235daa3f77db	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	08b27fae-a3a9-43a7-af39-1d3fa9eaada2	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	00b8a2e2-3796-410c-93bc-e525b13d4fe5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	09afbf1a-1ee9-4103-8ad7-ce99bf81b123	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c3c8bba5-e78d-4c3a-8247-fb2485dae884	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	04503827-0413-44fb-8d5d-049196ae2a86	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	572d0811-9bbd-469b-870c-cc697953eda6	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8b22f38e-dd2a-4332-85c0-36751fec5dbd	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5292e9fb-cfeb-49f6-9995-9ff6a31d39aa	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ba69e699-f355-4091-b729-254fabc1b586	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	dd7f170b-3965-4cfc-8323-2c90d0c466cc	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	50769eb7-cd8c-45e6-b42b-8c6dc32a4f91	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2ba57ff0-3d3b-4454-9499-c9ed14bc95fc	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	25326c97-4498-4b86-90f0-3e35c8370b6d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7fbca29b-ed16-45aa-b260-3ed4110c566e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d4c47e74-6782-42ee-b58c-ae972585e936	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	9af6a1fd-f6af-4af3-8907-10b46aa0aee9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	63bb6608-f828-49eb-a26a-d7c204e61c42	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d0ac968c-e55c-4429-b606-e1c0e9095c0b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	07b3e391-ef75-4ac2-9edd-5c0bef411b2d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2b3e13d8-7d61-420d-9c07-6cba678c5f71	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	860033d5-e361-4d2a-97ef-db3164fb26de	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d278bab8-b0af-4d40-904d-ee729910a09e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	0d7ab0b0-8be4-4aea-b2dc-f0050f52ff44	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	66f50333-2dd3-41d5-9fd1-36e44369165d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	4a1c3644-7145-4702-9ba9-1923764626ec	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	11865178-5dbb-46ac-ad42-28864a02ace0	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6783c878-4529-4b63-8c21-89d4a7e941f1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c9ff80f2-982e-4c53-97fa-8fee003979f4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	61fa6bf1-a517-4a11-8f65-d33e03bcf1fd	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a1ccdbcd-24ae-4333-9a94-f5d6d60ff008	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7f26426e-51d3-44f5-b333-7a6c5457ca9b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b1e0a887-58d5-4b12-894d-4d429e512320	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5d90fbc9-fc3d-4626-a8ce-5a434cb0a696	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bdfbe5db-a78f-4322-ba28-6fa56f791d8e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e2e2ef6b-82a2-481f-bf92-821051e3f211	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	814da935-79f4-4d93-91d3-7793faac9be0	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a1150aef-ee35-4a27-8098-87ea99ded4d4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2d52057d-85a1-42b7-ab5f-0e38fd9cb0c7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c79d9813-fc56-40ae-bf93-d42a3e9fc5e1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	dfc3adbc-82a4-40c8-88a0-2c28df83d838	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1f922c03-1ba9-4076-9ec7-e116f662e03f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	08e5c6f8-6692-45ca-826b-01637aa0ff73	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	51405652-8ec7-4d11-ae8e-215ad1ebf139	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	40ec36c6-ab98-4919-81c1-9f2722d0d3fe	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ee0cb774-659b-4640-ae7e-047a66edb247	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bf9a5f81-4da2-412a-9e78-ce159fd75283	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	366ac80e-68f6-4074-b25a-b0ccfeecf6b8	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	dacc03b6-1534-4612-af6d-e62623897ee9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8e8ce815-9d3c-46ff-840f-c618169d8502	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	12c12b96-302c-4b61-ab90-b85d49072a84	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	580befe5-ee5e-4b0c-bc60-7e2d1af658be	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c8d70777-7c4a-4373-9d57-3fb93c8a594e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a388cdda-4f10-481c-892c-0bc05ae9f150	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1f1c3b33-62cf-407c-9562-fa445acc7dc7	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	b3c4a363-3a59-44c4-9926-9ed48b12f1ae	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	e9a1b937-f6fd-46f1-92fb-df6440dc70e0	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a8b88118-f977-49ec-b0d6-8c4f8638cc0e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bceec891-2417-46c0-a65e-49720cb13b4e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d33e20b7-1446-4be7-9990-0f28cc36071a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	30151184-da43-41b9-a9cb-3649c1727889	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8e67bda8-433d-44cb-a6ba-7f7382b7dac9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8b908fc2-0e18-41a8-a8bf-d404c7bd4673	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d968ef17-e90b-4348-a74d-f5f36f566e69	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ea111673-1ee5-423e-ab8a-44659219aec3	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e8483a10-5c9e-4482-b6c0-87b42890cdc5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f0384321-a9bc-475a-852b-4b4d1d6a2c0c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bc220b61-699a-4e00-9a8f-a543edfc3485	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b54aaa9f-3916-42ac-a4a5-5528c5ce8eda	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	595010bc-34a9-43f4-bc75-1ce93e8e6f20	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8cd71ec4-a878-497b-a24f-2e23c7f21ff1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	72914232-c7b2-4881-bd5d-003e94fd215d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bb215e23-4d9f-4951-b2f1-6e24a2bcf994	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e5b0a680-e6f7-45e5-8dab-995b8497eded	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	54b0386e-767e-4a1b-8c93-f6555c9d313a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	72ce550d-74d7-408e-aefc-445bd6413159	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	765888ba-7859-49f7-ad76-82a84f32c239	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7f2b497f-88ca-489c-864d-7db89087b73e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	aaefde3f-7891-4526-813b-fae0fbfaa665	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f28bc03b-51ce-439c-93a8-cee33d04db58	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e13e0bf9-8c93-413e-a16c-f734f99eb599	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6b5d27d1-7043-4fb0-9dd8-dcb0df5641d6	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	26003172-4df0-45d3-aa60-58508f576830	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8084f068-8462-4d00-9dc8-663015fdd685	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	98c9d975-aadf-45ee-94b9-e17235d0318c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	357ee1ef-2309-4566-b3a3-3ac707c054ab	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	390ff267-7985-4eed-8e1f-63e47e3dc254	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	9037a6c8-42a0-46a8-821d-4706e5e1be75	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e8836720-44de-4fcf-b488-7600456f5041	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7a7c7641-8a23-41c6-936d-aa711d96af8e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	effedda3-bda1-4a4c-9a72-a212f2042886	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8a6d9a1b-9bfb-4b4b-9b2b-dc2bfa18e195	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	11c81d21-c6eb-4272-923b-4a68e88ec2d2	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	45f8f5df-833b-41ba-9aea-2ba5bc7204b9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f9dfdc99-6b61-4916-8506-4f59e374bd62	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b50882f7-09c3-42de-8adc-f51cd7839267	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f52f44fe-37a1-44ec-ac81-00936dc14568	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	08456804-5978-40fd-9921-f4ea55cc5cc8	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	040ff3a7-2374-497f-9e49-98415f41da5a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	3c0e1678-f0e9-4f11-be49-83208485acdc	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	4f67754d-538c-4cf1-bdaf-a9809d67e085	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cd29d82c-b949-470c-9ffe-54efe72e7ebf	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	949dfdfd-0673-4f34-a098-4c722e3198d9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	fda36f24-a2b2-4b76-a96e-9c3392f8dc76	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ff913ae7-96e6-400d-8ebe-402397887c19	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f68c8cb7-1f68-46c7-b1ea-c897c4ff0276	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e2a3cf3f-c14e-4519-b6cd-f6fe4bfdf567	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	054f8f61-cf9d-49fd-a934-cfb4e96877a5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	18201392-43f6-46a8-b40c-1fffe23b135a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6929d728-543c-4abc-b297-7c4764c48f1b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e83c5011-e137-423a-9abd-d179ce2154f7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6bebce93-bf43-485d-b10a-33c41a4670f7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	0e098a43-e600-4d9f-8b9f-f2f8a3dec94b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	17ab59d1-6452-4b4f-a69f-48f3da71e462	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	becbce79-d5fb-4748-be4b-a605eea216a4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	02084382-cfdd-4474-835c-25c966d4a68a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c927eec1-f4f1-452f-a017-2e5dc2dce49b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e768f45e-23cf-45a1-98b0-032239d65297	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	403204cc-11d1-4fdc-93a4-aba666d3e844	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	77958711-d91c-4530-b266-6897d9b23c80	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ceb5c553-8af6-4d74-bc2c-998b6f810058	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a3fb926d-a5a7-4db7-95f9-c37d89a019a8	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	9c3bec00-fa01-41c1-8751-d443fc53de84	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2f2c9ab6-a96e-4806-b91f-74c1ef11ad3c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	79909aa7-124b-4cc0-8af7-43e6f66dca30	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d2289729-9ae3-4a8c-8486-6fd2685172b3	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	0f132cc3-3754-4245-9cee-92e7b5f8c00a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a59d564e-c43c-405a-82ae-abcc5dff2139	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1d38ccf3-24de-420d-9095-b80e22a6c295	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b678b03c-acf3-4633-b688-f78e2fe006dd	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	30cbac52-6a13-4732-92a1-294946bb529b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	625ef27d-99ff-40dd-977d-727545bf4a4c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	727f2f7d-37e6-45b7-9537-0a73da54b5b1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8cbb10d1-8680-4e60-98bb-a677b4f41803	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ffdc8b92-b27a-4737-9033-656adb915cfd	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	eca4d17c-e514-45d6-b212-feecf574494a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7d5d796d-f597-4dc8-a581-e033c2e951f1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ff97e1bf-00f2-4c32-b954-1a08bfddd0e8	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d563a8d7-8b62-4f53-9930-ebbea7f3edad	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	33561269-044c-4e6e-a933-0ff06d36459c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1699a638-1a77-48d3-9c25-656ef29b6eae	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a06a37eb-6436-4913-8f1e-e5c5f28b389b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e9cb43b7-522b-4878-afa1-609744d0c2d9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5a2a75ef-7e0e-4ead-bef1-bfe4808b0773	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d16b8223-1f14-48f5-bd52-ab0f3390e25c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	82fc2987-ab8a-4ddf-8922-2d576d648030	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bd16bf05-c647-4211-bbeb-91abeb573375	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bb0ea035-2294-44f1-a25c-7229bf335e1d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c638d3ca-c6db-43bc-8ae0-bb1ca9a62423	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	0d7b4204-00f9-42fb-9f49-eadb5dc5b1a3	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e27608d0-0ae7-49ed-aad1-ec74be537418	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	df8279ca-7849-49b1-b18b-d9e70ea83854	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	316f9c5e-9e38-49a7-bfc5-3c8fbf8e1055	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ae5b0c6f-8384-480a-8780-6093352dd45b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	30d41cc0-02a1-4760-a6d2-401f63882d41	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c43f5050-28e6-469a-a092-488d05136c2c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f8bf32cc-086c-4d5a-aabe-bbf7c563cc21	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	994b5a41-ffaf-4b49-967d-686800cb3221	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	4b00253d-b27a-45c0-ba75-e973298ac1f9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	3f7ac114-2abe-4d5a-8a32-12f01203dbaa	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2ee9c42d-413a-4a4e-a9ee-6948eaad7125	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d2714fb7-9117-4514-ad63-1a660bcb3275	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	69c8123a-31bf-4dc8-b1a1-feadce0b0d6e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a8ac1caf-42c9-4a84-811e-1b29514161ae	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cb84bb1b-6cd4-457d-aa21-fb817321f1f0	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	3110bfe4-8495-4b0e-bfde-564f86c3fbd4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	68598968-5662-4fe3-9b0d-9108f57d63d7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	aaed7f00-6212-4dc0-8417-093a70395b1f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	3d70ce5a-8030-456f-9177-1a143b654206	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7cffc00e-cfb2-4464-aa5f-ea0e60757150	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	07aa8eb7-3ba6-4aff-a010-fc8c22df5f29	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	37cc53a0-c129-46a2-b9d1-bf152e3c2cff	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e952cec0-4f03-4320-800f-5e7f0307ccda	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	008a83ca-d1b2-41c9-adf5-33914625c81b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d0e88f1c-868f-4a9e-b9fb-2f3177043a82	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2cfd4d5e-47e3-4035-a7e1-614ed27241f2	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	403c59bd-7141-4c0f-9931-b595a4ec1fe5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5c7739a8-44b2-4a3d-9821-469c413b7742	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	690088a0-d559-495d-9168-01755ca57219	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b02d9ed6-4ccf-443e-a486-309e3663a968	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d83477e6-a3c0-40a7-84d7-e0dfeda130ab	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	15f0117f-7104-4ea6-a73a-7cc9e6a88fa1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d186c668-53a7-43c1-937d-ae0ae4b7426d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e58e4049-9809-421b-a0f9-aca389849413	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	211cf55a-ad24-4c48-b014-afd96e948983	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e398d6d1-b7df-4406-aefb-21ede4df1978	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	74b39c99-6a86-4a6e-9f12-bfdd079ab3ee	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2627f264-7af3-49b4-b213-a1e208f11e92	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5032f4fc-b1b1-48a4-912c-f043e19a0bdd	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	4c4dd570-606e-47b4-b9c0-c8ea19469473	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	2e7c3df3-c357-4c82-a659-1e99621cec3f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f7a4270e-5142-4dd3-a3bf-7417e1222729	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8f177e8d-2e11-40c4-9cfe-5f88bbeb87ab	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	43ebacd1-d587-4712-ad25-f7c84a8fcd60	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	0add028e-4685-4ebc-87fb-dc2044c2fed5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d3def1a8-3253-4aa2-af58-7182d7343eff	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6a8e069d-aaeb-47ca-b43f-30e1d9a6cbd1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	3e7c1471-6cf8-406d-b974-a7a662cf309a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5b268aa4-580a-41a9-80e2-66195fc74bae	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	34ce0003-834d-4e85-bd62-e316a107fb8e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a56cec2c-abc7-4f15-beae-de2d85699147	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	92c179dc-237e-46a0-bbf9-50af3183c2af	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5851e71f-a9e4-4460-a662-073975dd11d7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	be746b9e-b7b9-4748-a730-d1308fe6dff7	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5ccd4c71-2e3a-4a97-a042-da39968b8bdd	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	518b2d4a-d320-428f-ad0e-0f2a8e891ed4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	0776d95b-570e-4b56-bc6b-2279e93f1a7f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a75fbe5e-67fa-40e7-ae9f-441d64a44bad	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e01353a8-96c4-47b7-84bb-32a03c844957	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	93911459-f8f7-47b3-b720-0ef75892f249	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	edbb1f1a-f1f0-48ea-9cfe-28464633318b	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	fbf1e698-0df9-41f4-a5c6-adf077db3f27	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	54496b2f-69ef-440a-840b-4d7aeac509ea	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	208e364d-e34e-484c-ba7d-de958a216c6a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7153e22a-80c0-4712-b879-a746ace59de8	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	4ae3007e-6d23-45a2-8c23-37916d78e3c0	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5485e361-25a9-418a-a503-1a55da1d9db3	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	fed965e3-10fc-462b-8454-8740206d8835	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	cdc79885-7f18-40f7-a8ff-c0bcfc50bec4	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6f2fbdfe-d971-4b7d-b603-faf01968f500	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1c8eacc6-c2e0-4caa-aade-0a8d2c04fe0a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1f1b40a2-3978-4207-9734-0fc0ac7f2899	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e5f0f719-49bc-4054-8d78-7dcba47f17fe	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ef41ed6b-b334-4b75-ba16-9635c637d58a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	64a28fba-ee56-48f3-b600-0371a74a4b05	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ee44ebfd-ff0b-4ffd-950e-1eccf60f0c5f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	41a33d7b-b745-4322-a4f0-aefc5f81858a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	49e1e30c-6dc5-48e7-9c4c-1659c64322e5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	1553c296-9df5-408d-be4b-6dd0bd6a4e9e	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6e1c47a5-dc1d-4e92-8758-03d7e88f4b80	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6ff78bee-64f8-4415-a5e6-a893deaa63bb	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8f4ab0bc-735e-4ce7-8b01-2c5387b7f54a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	8b3fb58d-6fea-4f2e-934f-0e257c6c1c85	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d9cf57c8-a8f3-45f2-bd95-2178e4b61c97	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	fac72272-3840-4695-b17a-edd549ccc730	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	b5c729d0-fef2-4850-9f66-d786b7e1a0af	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	e1e64f97-013d-4b66-b189-879d71829e63	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	a663bb21-0553-40bc-84e5-8aa366f999c9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	bbd82119-8f2c-4801-adc1-619232ea4c58	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	7a3b3e39-d212-4894-a59c-f27726933cce	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	96814ee0-3f49-4868-b396-a5acefdb1c90	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	01a2f078-04d3-47bf-8c5e-84d716caa144	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d4de3ea1-a166-4782-8865-9a9d50798b5f	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	c197051c-a611-473d-8b79-15c9fca6950a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	019a5aba-0536-4661-8799-11616becec9c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d6a2c14a-19d0-4b13-95c1-7affd7a75473	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	dc585a36-2faf-4deb-b834-561a5480d880	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f413da06-210d-4562-96bd-2b61e81d1b1d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	9f940121-0e47-424c-a694-48e6846c5b1c	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5501d154-86da-48d0-9b50-3f808e7c4c58	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	00fcca0e-fec8-450c-ac6c-e35806aeefe9	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	02770cc4-cc04-46bf-af2b-2698f61ee577	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d6832150-1c47-460f-8892-3c41aba513eb	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	3dd2fb45-0573-4b28-8fcd-e1a1717b5535	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	87e89a8a-d2ea-404b-ac74-03833aee202d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	d5880231-4816-4268-964b-ee5b190d6962	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	98ea9347-f197-421e-8f55-8775d53ce001	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	b8d224f1-099f-4fce-9fc0-cc28a2a4b33f	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	610683d7-417e-47d9-a36c-a3fcc0aa914e	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	f5ea5c5d-8182-4ce7-af16-b8dbd5b39a5d	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	72c1e522-6543-476f-8b7e-680cbe84dd32	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	d9cda8fb-f116-4e41-95f9-65e0adeb9b69	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	ebb42aca-f8c0-4658-af66-458578e6b677	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	c4532ab5-b181-4e05-83fa-68cc0505745b	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	baf317ba-e3fd-4d59-9165-8b9be6e7a342	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	f3f138cb-44e0-40c3-b941-e1c8b0410892	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	4af2b8a3-eef1-428c-b8ba-b701e55ef510	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	fc5e80e4-a208-4bef-bd34-9be3162c9b4d	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	c530893c-f2e4-43ef-9a0a-3cbfc5627bab	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	55a87bbd-dfb6-4f29-ab68-24b8bfe1af23	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	6fac4668-cfeb-495c-aab9-17f459b04be9	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	b65f67ee-b22b-43af-a04f-50607a713c78	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	82677696-9782-4123-b989-80140a6f0ecb	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	26865bcd-5635-463c-807b-fd9f46aeb1ea	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	40399e9d-5abd-4d59-818b-6d061782124a	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	851a13cb-3be7-4d4b-b4bf-353503a6aa2b	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	6997e817-c8cc-44f4-83a1-e202fe0f8068	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	2ae5e47d-e8ee-440a-945b-881e18fc8a02	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	bec0e199-4d4a-4b60-b39e-40e72e85e0c4	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	6d7b9bc9-24e7-4fec-8fae-13d1fcd62429	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	cfea06a7-1da1-4a32-9ac4-6a4a076ed274	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	04dcbdd5-837e-42c8-9b95-7dcbeee94886	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	25495ebb-20c3-40ef-9b4e-cc75c1e04f02	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	74cf45de-9e29-41ff-9e40-48a9311d5bf4	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	5894778a-40ef-4d13-943c-8b95a9182f87	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	8d553257-503c-47d6-856c-dc2c64d82a20	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	506d0816-867a-4b3a-a2a7-161162faa157	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	b1d80f09-a4ae-4f26-bd26-f5d3170c5a1d	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	436dae7e-6103-4f32-b309-4fd9903b8bad	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	3855a408-8784-4702-b5eb-5691ed7da656	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	5ddf1901-0d11-4464-b73e-a5460c51e558	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	d8a70e2d-596c-4364-9243-bb6586921ca5	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	5c86ddc3-9f57-4723-a82c-fc5464b1b67b	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	32e4d30c-8273-4293-a7fc-bb52da485cd1	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	14e51473-8e5f-4e8d-a783-7599f75beab9	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	e6bb6593-07ea-448f-9927-b07f51df3c07	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ebda8550-4025-42a2-aaeb-936c63f86cd3	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	10bdb3f0-bd63-4399-8711-1a985bc1cc52	5956e9e9-d73c-499d-b42c-b88136fbbe56
d16c5da5-30cd-42f7-9582-2199be94ab30	ffb7f50c-fdd5-4e7e-8efa-d32530c74f4c	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	d69293a9-5d4e-4b8c-8cf7-74033a9b905e	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	107e2dfa-fdea-43e8-a38c-102684a51ddc	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	d250adec-3b22-4ca2-b2a1-02f2daa75a62	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	756c0a16-7fc8-4b44-a1bc-9bdca0e90fae	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	a9d695ba-f130-47e7-95ca-a603545bba22	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	d1f59360-de10-44d4-9c0c-40721eab1a5c	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	630e5016-708c-4d1b-9be1-1c36f99ba8ab	5956e9e9-d73c-499d-b42c-b88136fbbe56
7754d9b5-fed2-4eb9-9481-2012337052ea	de0aa407-a6b3-464f-a581-8baceac91804	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	de5026df-0bf1-4f55-9f1d-b90470cc94c6	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	6140c6d5-95b9-4821-9d95-218776d28c36	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	fc7db61f-9f1c-4d5e-8f8f-318ec0f458b6	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	ba03c723-c172-4774-bd89-1bf403d83e16	5956e9e9-d73c-499d-b42c-b88136fbbe56
775a53c8-5776-4ceb-b2a5-e0fbbc905ebb	7f9df86c-a11f-46a6-bcbc-b4e87c54ce91	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	ff51f226-2445-454f-9a08-498d064152d1	5956e9e9-d73c-499d-b42c-b88136fbbe56
974b5351-80f6-4964-9879-dddce853b6b3	d3fcc303-7151-4c32-b4e2-981b81092175	5956e9e9-d73c-499d-b42c-b88136fbbe56
9256d54a-8d3f-4261-b4cc-978bfc4ffc1b	7ccbecd2-5648-492f-a15f-4c8963ca291b	5956e9e9-d73c-499d-b42c-b88136fbbe56
\.


--
-- Data for Name: role_school_memberships_school_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_school_memberships_school_membership ("roleRoleId", "schoolMembershipUserId", "schoolMembershipSchoolId") FROM stdin;
\.


--
-- Data for Name: school; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.school (school_id, school_name, shortcode, status, deleted_at, "organizationOrganizationId", created_at, updated_at) FROM stdin;
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	Open Credo	5NQ8M8H0VB	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-10 14:08:35.595	2022-01-10 14:08:35.595
7875dd8c-0e3b-41dd-bf17-77d1ac072358	K6-1k-Schools-000	K600000000	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
cb9c2659-abbd-43da-8db5-8e7b36896a44	K6-1k-Schools-001	K600000001	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
2b23ffcd-f2f1-4351-883d-d4623c20cfa5	K6-1k-Schools-002	K600000002	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ffde9914-653f-4444-acec-87351e7ed3bd	K6-1k-Schools-003	K600000003	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
edd08720-e370-4717-80c1-57a4c2dfe73a	K6-1k-Schools-004	K600000004	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c1fc1151-8756-4e41-afce-765ac19cfc4d	K6-1k-Schools-005	K600000005	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
1959951d-9bba-4a6e-8a49-521c7db110a5	K6-1k-Schools-006	K600000006	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
233d66f0-dbbe-4ac8-876b-0d1fdbd2bcce	K6-1k-Schools-007	K600000007	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
45c9d4a6-8f8f-4ecd-93ad-17861b33af12	K6-1k-Schools-008	K600000008	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
636be005-7b26-498b-90f3-c68c1dc25b99	K6-1k-Schools-009	K600000009	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c5105372-158b-44ca-9f13-f442f5b44ed2	K6-1k-Schools-010	K600000010	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ece34b4d-0e04-4f6d-a3ce-ec2931bb1438	K6-1k-Schools-011	K600000011	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
f0bd96ca-f9c7-4dd1-aea7-e68a8f3844aa	K6-1k-Schools-012	K600000012	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
9eda289c-0f1f-41a3-82f2-cc3cb5a594c7	K6-1k-Schools-013	K600000013	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
5c8b3f71-1e1f-45d7-9813-5b0033d4137a	K6-1k-Schools-014	K600000014	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
95baf8ab-bb0f-4d7e-a92a-ab4a897ca104	K6-1k-Schools-015	K600000015	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
d7b6a67f-2f45-4a20-9c70-61a16b3cd934	K6-1k-Schools-016	K600000016	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
22ef5581-0b28-4664-b694-3ed10afba0b6	K6-1k-Schools-017	K600000017	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
0e5e1125-a64b-4381-9def-6077982a1ee2	K6-1k-Schools-018	K600000018	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
7e378595-3751-47fd-af4e-a120e55e824c	K6-1k-Schools-019	K600000019	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
bc9061f6-53da-451e-9948-3a325108765f	K6-1k-Schools-020	K600000020	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
585eabb6-82ca-45f4-8569-b4eeb072f14a	K6-1k-Schools-021	K600000021	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
29491466-12e9-46d5-97c2-cb4671bc6bfa	K6-1k-Schools-022	K600000022	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ffe900ec-18b8-4c04-9a2e-4d654fab4c1f	K6-1k-Schools-023	K600000023	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c8d40997-8b93-4658-9ba7-e4d13f6585d2	K6-1k-Schools-024	K600000024	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
5f7469be-4553-42f1-9f5c-c75901fab2fc	K6-1k-Schools-025	K600000025	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
6a18fdd1-309a-48f7-93d1-6b3c6283dd1b	K6-1k-Schools-026	K600000026	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
7e5fb926-cd79-4c99-9d7c-3bc8734f6e77	K6-1k-Schools-027	K600000027	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
682caff8-efe9-465d-817d-674df3b7c5e4	K6-1k-Schools-028	K600000028	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
7eaa9667-9702-4349-9051-c6488fb88700	K6-1k-Schools-029	K600000029	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
078058e1-23f5-4b6d-acf6-f761b26eb18b	K6-1k-Schools-030	K600000030	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
dca8c289-abb7-4dbb-97e2-98de6e7eb4fb	K6-1k-Schools-031	K600000031	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
368f8926-0245-4912-ad99-542d0c2b5b02	K6-1k-Schools-032	K600000032	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
314414a8-c9fb-4d8b-8cd0-af5cdebc1531	K6-1k-Schools-033	K600000033	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
e4a4cd8b-5c6f-4c01-9d5a-0c417242b3c7	K6-1k-Schools-034	K600000034	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
f8fb6c22-2658-4d56-8a10-faac2fc2fedd	K6-1k-Schools-035	K600000035	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
76fabd6b-eb97-49d0-bd0a-efa00c3964bd	K6-1k-Schools-036	K600000036	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
1bd0971f-3752-4b5a-8ab3-3fa8eb4bc710	K6-1k-Schools-037	K600000037	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ef2cc4db-8e3e-476c-b214-82a099c8baa9	K6-1k-Schools-038	K600000038	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
945f907f-087e-4788-bb4a-2246b51a8d88	K6-1k-Schools-039	K600000039	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
6e5c55ad-9a12-4928-b48a-0e8571d2a38c	K6-1k-Schools-040	K600000040	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
dbb2ed40-31c1-41a4-84d1-cfdd9f7c617d	K6-1k-Schools-041	K600000041	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
7fab541c-8b7b-4f9e-bb8c-6d9a9d0d16d0	K6-1k-Schools-042	K600000042	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
e56bb713-28a3-48c2-9c33-e0521f754f78	K6-1k-Schools-043	K600000043	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
9d6d60c5-76e6-41c9-b377-b9ac73ca7b24	K6-1k-Schools-044	K600000044	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
8e21f8a5-a2f6-4351-a747-4ee1db413374	K6-1k-Schools-045	K600000045	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
4cdd80db-e7ca-49c6-b418-9d01df15f11e	K6-1k-Schools-046	K600000046	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
0cf5b610-edaf-4598-ab20-a1f2a0461b4c	K6-1k-Schools-047	K600000047	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
08505658-4e64-4b46-a665-46c534550fff	K6-1k-Schools-048	K600000048	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c0a093ce-55ac-4157-9fa6-af7c7b5b9515	K6-1k-Schools-049	K600000049	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
6736a23d-178a-4d40-8e3d-26ea3f813289	K6-1k-Schools-050	K600000050	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
8bf0ff96-6e9b-4e56-9431-e5b7c7d5936c	K6-1k-Schools-051	K600000051	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
d383f38a-9059-4762-9053-f4035a3545c1	K6-1k-Schools-052	K600000052	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
d5d7906e-e1cd-477b-9c23-0671d10e4e96	K6-1k-Schools-053	K600000053	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
93b09be0-b916-466a-93a5-0409056702ba	K6-1k-Schools-054	K600000054	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
a48ff736-a3e6-449d-8901-64b91ac575df	K6-1k-Schools-055	K600000055	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
faebeace-0e4e-426b-8580-fe1b6a34797c	K6-1k-Schools-056	K600000056	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
1f82ca16-42d8-45ab-8840-8c1d01bdf88a	K6-1k-Schools-057	K600000057	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
4f1dc87d-2724-4aad-8d78-d2a57bd99946	K6-1k-Schools-058	K600000058	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
0d178b83-7152-4517-aabd-5a7c11961169	K6-1k-Schools-059	K600000059	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
bf872f06-1b19-4f3a-8aa8-beb31a5510d1	K6-1k-Schools-060	K600000060	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
0d3325ba-c095-4cad-ab35-27f9223e8de7	K6-1k-Schools-061	K600000061	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
fb4c9e34-fcac-4393-8a73-05c36c5ee8cd	K6-1k-Schools-062	K600000062	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
fb89e32b-da80-4c72-a826-f545b853707b	K6-1k-Schools-063	K600000063	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
f476a6fe-3bd5-417b-9b1c-367a13df18a2	K6-1k-Schools-064	K600000064	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
99bdd99e-9797-4dd6-9b35-5108671f98aa	K6-1k-Schools-065	K600000065	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
bb830a66-0214-4e65-9d13-7c459ae5cefa	K6-1k-Schools-066	K600000066	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
d4967876-01f0-4c94-8af2-cbcaf6bd0b3f	K6-1k-Schools-067	K600000067	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
2dbd567c-d537-4ce4-a23a-eb07642dae21	K6-1k-Schools-068	K600000068	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
367ae2cf-82cf-4496-bf25-ed27f825e1da	K6-1k-Schools-069	K600000069	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
06ad451f-4666-49be-9846-27b6e659f578	K6-1k-Schools-070	K600000070	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
2b155358-670e-4a20-b857-5990a9ad67bb	K6-1k-Schools-071	K600000071	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
da5e5bca-2370-401b-8a78-344b241d493f	K6-1k-Schools-072	K600000072	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
36355eb9-6114-4d61-800f-d3907574e796	K6-1k-Schools-073	K600000073	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ccea9e85-7987-44c5-9648-0845b69097bd	K6-1k-Schools-074	K600000074	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
da3df8e4-bbec-41dd-b4c1-f4b43be16931	K6-1k-Schools-075	K600000075	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
3d2759c4-b283-44a3-9341-3fc9fd8f658d	K6-1k-Schools-076	K600000076	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
1fdd8dd4-2a61-4c2e-a6ab-bfee05369a8c	K6-1k-Schools-077	K600000077	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
97612c39-64bb-4dd0-b87c-7b76ebdb4fff	K6-1k-Schools-078	K600000078	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
5a72ccff-ba52-495d-9d4d-fc280cd9a683	K6-1k-Schools-079	K600000079	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c251eca3-f75d-4a13-ae6e-b0b2449c19f6	K6-1k-Schools-080	K600000080	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c59bf81f-462c-4dad-b486-f1f5e5cc6cda	K6-1k-Schools-081	K600000081	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
b6698ff4-6c3b-49db-a157-72e2c4f76b0f	K6-1k-Schools-082	K600000082	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
7dde836a-9ddd-4ebf-b5d6-5210d29e0ade	K6-1k-Schools-083	K600000083	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
3dbcfb88-8a39-4b3c-801e-c6470616a41b	K6-1k-Schools-084	K600000084	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
0e275980-a04e-41e8-b8c9-06307859b7b8	K6-1k-Schools-085	K600000085	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
bc213d6a-55bb-4f02-a32d-bbab5fc894c2	K6-1k-Schools-086	K600000086	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ab49ed59-328c-4b56-8515-5d0cfd64143e	K6-1k-Schools-087	K600000087	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ece4a9c8-da32-4cc6-8bcf-b84a21c4c1bf	K6-1k-Schools-088	K600000088	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ae6683b1-29f2-4f5f-91e6-f0d5d693b043	K6-1k-Schools-089	K600000089	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
b5726055-af7b-4dbf-ad83-4d12fd10c754	K6-1k-Schools-090	K600000090	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ba404650-55aa-4bed-8cf3-ac05e828e848	K6-1k-Schools-091	K600000091	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
7cdcee05-b235-4b7c-ab58-1d14a56d27f0	K6-1k-Schools-092	K600000092	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
9ff20edc-31ab-4a40-b816-d4b2723c5ea1	K6-1k-Schools-093	K600000093	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
140fc0d2-7046-456c-985c-90509acffe16	K6-1k-Schools-094	K600000094	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
11ca4664-1c58-4a87-9440-11e68c5a078e	K6-1k-Schools-095	K600000095	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
4770c60b-0044-4350-97eb-1b7e0ce097de	K6-1k-Schools-096	K600000096	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
c4adf24d-86df-473d-bfb2-f6a985fd193e	K6-1k-Schools-097	K600000097	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
d0d84d86-cbf4-4e16-8fce-4d100a711c37	K6-1k-Schools-098	K600000098	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
ad77f948-9476-4b0a-be13-c8ad610a3f52	K6-1k-Schools-099	K600000099	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:05:17.98	2022-01-18 16:05:17.98
0bb8c6c6-8757-48d7-8e15-f04fb393e871	School K6 - 1	7X7M4XHCAQ	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
36b66cd2-4171-43ec-a240-77080a35b70b	School K6 - 2	ZO7N63V8K2	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
1d88e87e-a951-4732-8819-edecc3a23d65	School K6 - 3	44IICBDLA3	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
584e9cc8-d691-4983-a01d-179ad34edcd4	School K6 - 4	N6RPK85EAB	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
38e2316e-5a77-44a0-8649-45cf8f300c9f	School K6 - 5	QSCWEUSBBR	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
e3840210-8b53-4e75-85bd-fa535d03fb8e	School K6 - 6	VE78DZ5730	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
c59a235d-afc5-44cd-8e39-dcc6cc98f09b	School K6 - 7	XG9WUZXULB	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
f75cbc8a-f1f8-42a1-b8e1-e843195d86e1	School K6 - 8	EQOHC3526O	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
6c17d681-db0f-45a4-aca0-61cde360a524	School K6 - 9	524PA7AEW0	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
2966ced5-7cc6-4bac-bc8b-ca5cefefa2d0	School K6 - 10	6HNCUCATFI	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
8694dbcf-50a7-45bf-bb18-5e63213ffe85	School K6 - 11	STTTVHFGKI	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
4225d1cc-6ef1-4c40-b629-e1ca2fe581a0	School K6 - 12	D3L17YMIP6	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
662651de-d7d3-48f0-9ff2-a3fe41b7e479	School K6 - 13	E40O1V3TZR	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
ca558754-c8d1-495e-af72-0ba954a86968	School K6 - 14	PXVLAE7UNE	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
369665c0-e6fe-4f68-98bf-2ae220193137	School K6 - 15	RQD0IG4SPA	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
6fd4e513-00bd-4665-bf3c-b1303500d1a9	School K6 - 16	1Z2E6FU9HE	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
239c2072-1ef1-411c-8b24-11ce94a78e51	School K6 - 17	NC8V2QOROZ	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
83efb603-6aba-4efa-9498-424a074cf385	School K6 - 18	PZA34K8ETY	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
773ab7de-7b86-4295-b313-a95e4359d718	School K6 - 19	RUT4K2XY38	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
fb7b117f-b602-491d-904e-0fe95f26bf35	School K6 - 20	KCL92YF940	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
b49bff62-5bfe-4550-88ba-e0dfaf93dbf0	School K6 - 21	OYXE6FY4O3	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
ec78d574-feae-4e0e-a250-332b909a2f3b	School K6 - 22	AOGP1C1VHD	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
deb7e947-6848-4a62-9124-205cf85857d8	School K6 - 23	LQ4TQ9YU7C	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
48080561-ef14-427c-87cc-a3d929d1274c	School K6 - 24	R34BCTSZV3	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
49c0eaec-6f91-4632-ab4a-e743674dc98c	School K6 - 25	I799Z97TWN	active	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2022-01-18 16:21:13.395	2022-01-18 16:21:13.395
\.


--
-- Data for Name: school_classes_class; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.school_classes_class ("schoolSchoolId", "classClassId") FROM stdin;
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	8b09033d-7db9-46c3-aeb8-138c9e7eff96
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	8f4f696a-f935-412d-8134-d53062cea38e
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	930e9e1a-4ca1-482d-a1b3-20599b2e2dac
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	aa0b2ece-8052-43c9-93c2-2431a86cb198
\.


--
-- Data for Name: school_membership; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.school_membership (user_id, school_id, status, join_timestamp, deleted_at, "userUserId", "schoolSchoolId", created_at, updated_at) FROM stdin;
b4479424-a9d7-46a5-8ee6-40db4ed264b1	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	active	2022-01-10 14:08:47.314607	\N	b4479424-a9d7-46a5-8ee6-40db4ed264b1	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	2022-01-10 14:08:47.315	2022-01-10 14:08:47.315
182c6e98-6628-427e-a9ad-c2ed60a2bb83	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	active	2022-01-18 14:34:42.346421	\N	182c6e98-6628-427e-a9ad-c2ed60a2bb83	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	2022-01-18 14:34:42.346	2022-01-18 14:34:42.346
b3c4a363-3a59-44c4-9926-9ed48b12f1ae	0bb8c6c6-8757-48d7-8e15-f04fb393e871	active	2022-01-18 16:24:55.796791	\N	b3c4a363-3a59-44c4-9926-9ed48b12f1ae	0bb8c6c6-8757-48d7-8e15-f04fb393e871	2022-01-18 16:24:55.797	2022-01-18 16:24:55.797
ff51f226-2445-454f-9a08-498d064152d1	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	active	2022-01-21 11:56:24.958822	\N	ff51f226-2445-454f-9a08-498d064152d1	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	2022-01-21 11:56:24.959	2022-01-21 11:56:24.959
d3fcc303-7151-4c32-b4e2-981b81092175	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	active	2022-02-03 10:44:31.460721	\N	d3fcc303-7151-4c32-b4e2-981b81092175	ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	2022-02-03 10:44:31.461	2022-02-03 10:44:31.461
7ccbecd2-5648-492f-a15f-4c8963ca291b	0bb8c6c6-8757-48d7-8e15-f04fb393e871	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	0bb8c6c6-8757-48d7-8e15-f04fb393e871	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	36b66cd2-4171-43ec-a240-77080a35b70b	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	36b66cd2-4171-43ec-a240-77080a35b70b	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	1d88e87e-a951-4732-8819-edecc3a23d65	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	1d88e87e-a951-4732-8819-edecc3a23d65	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	584e9cc8-d691-4983-a01d-179ad34edcd4	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	584e9cc8-d691-4983-a01d-179ad34edcd4	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	38e2316e-5a77-44a0-8649-45cf8f300c9f	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	38e2316e-5a77-44a0-8649-45cf8f300c9f	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	e3840210-8b53-4e75-85bd-fa535d03fb8e	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	e3840210-8b53-4e75-85bd-fa535d03fb8e	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	c59a235d-afc5-44cd-8e39-dcc6cc98f09b	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	c59a235d-afc5-44cd-8e39-dcc6cc98f09b	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	f75cbc8a-f1f8-42a1-b8e1-e843195d86e1	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	f75cbc8a-f1f8-42a1-b8e1-e843195d86e1	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	6c17d681-db0f-45a4-aca0-61cde360a524	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	6c17d681-db0f-45a4-aca0-61cde360a524	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	2966ced5-7cc6-4bac-bc8b-ca5cefefa2d0	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	2966ced5-7cc6-4bac-bc8b-ca5cefefa2d0	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	8694dbcf-50a7-45bf-bb18-5e63213ffe85	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	8694dbcf-50a7-45bf-bb18-5e63213ffe85	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	4225d1cc-6ef1-4c40-b629-e1ca2fe581a0	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	4225d1cc-6ef1-4c40-b629-e1ca2fe581a0	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	662651de-d7d3-48f0-9ff2-a3fe41b7e479	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	662651de-d7d3-48f0-9ff2-a3fe41b7e479	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	ca558754-c8d1-495e-af72-0ba954a86968	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	ca558754-c8d1-495e-af72-0ba954a86968	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	369665c0-e6fe-4f68-98bf-2ae220193137	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	369665c0-e6fe-4f68-98bf-2ae220193137	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	6fd4e513-00bd-4665-bf3c-b1303500d1a9	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	6fd4e513-00bd-4665-bf3c-b1303500d1a9	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	239c2072-1ef1-411c-8b24-11ce94a78e51	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	239c2072-1ef1-411c-8b24-11ce94a78e51	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	83efb603-6aba-4efa-9498-424a074cf385	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	83efb603-6aba-4efa-9498-424a074cf385	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	773ab7de-7b86-4295-b313-a95e4359d718	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	773ab7de-7b86-4295-b313-a95e4359d718	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	fb7b117f-b602-491d-904e-0fe95f26bf35	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	fb7b117f-b602-491d-904e-0fe95f26bf35	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	b49bff62-5bfe-4550-88ba-e0dfaf93dbf0	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	b49bff62-5bfe-4550-88ba-e0dfaf93dbf0	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	ec78d574-feae-4e0e-a250-332b909a2f3b	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	ec78d574-feae-4e0e-a250-332b909a2f3b	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	deb7e947-6848-4a62-9124-205cf85857d8	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	deb7e947-6848-4a62-9124-205cf85857d8	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	48080561-ef14-427c-87cc-a3d929d1274c	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	48080561-ef14-427c-87cc-a3d929d1274c	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
7ccbecd2-5648-492f-a15f-4c8963ca291b	49c0eaec-6f91-4632-ab4a-e743674dc98c	active	2022-01-18 16:22:33.635	\N	7ccbecd2-5648-492f-a15f-4c8963ca291b	49c0eaec-6f91-4632-ab4a-e743674dc98c	2022-01-18 16:22:33.636	2022-01-18 16:22:33.636
\.


--
-- Data for Name: school_programs_program; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.school_programs_program ("schoolSchoolId", "programId") FROM stdin;
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	b39edb9a-ab91-4245-94a4-eb2b5007c033
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	4591423a-2619-4ef8-a900-f5d924939d02
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	7a8c5021-142b-44b1-b60b-275c29d132fe
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	93f293e8-2c6a-47ad-bc46-1554caac99e4
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	56e24fa0-e139-4c80-b365-61c9bc42cd3f
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	d1bbdcc5-0d80-46b0-b98e-162e7439058f
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	f6617737-5022-478d-9672-0354667e0338
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	cdba0679-5719-47dc-806d-78de42026db6
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	75004121-0c0d-486c-ba65-4c57deacb44b
ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7	14d350f1-a7ba-4f46-bef9-dc847f0cbac5
7875dd8c-0e3b-41dd-bf17-77d1ac072358	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
cb9c2659-abbd-43da-8db5-8e7b36896a44	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
2b23ffcd-f2f1-4351-883d-d4623c20cfa5	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ffde9914-653f-4444-acec-87351e7ed3bd	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
edd08720-e370-4717-80c1-57a4c2dfe73a	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c1fc1151-8756-4e41-afce-765ac19cfc4d	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
1959951d-9bba-4a6e-8a49-521c7db110a5	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
233d66f0-dbbe-4ac8-876b-0d1fdbd2bcce	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
45c9d4a6-8f8f-4ecd-93ad-17861b33af12	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
636be005-7b26-498b-90f3-c68c1dc25b99	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c5105372-158b-44ca-9f13-f442f5b44ed2	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ece34b4d-0e04-4f6d-a3ce-ec2931bb1438	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
f0bd96ca-f9c7-4dd1-aea7-e68a8f3844aa	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
9eda289c-0f1f-41a3-82f2-cc3cb5a594c7	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
5c8b3f71-1e1f-45d7-9813-5b0033d4137a	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
95baf8ab-bb0f-4d7e-a92a-ab4a897ca104	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
d7b6a67f-2f45-4a20-9c70-61a16b3cd934	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
22ef5581-0b28-4664-b694-3ed10afba0b6	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
0e5e1125-a64b-4381-9def-6077982a1ee2	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
7e378595-3751-47fd-af4e-a120e55e824c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
bc9061f6-53da-451e-9948-3a325108765f	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
585eabb6-82ca-45f4-8569-b4eeb072f14a	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
29491466-12e9-46d5-97c2-cb4671bc6bfa	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ffe900ec-18b8-4c04-9a2e-4d654fab4c1f	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c8d40997-8b93-4658-9ba7-e4d13f6585d2	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
5f7469be-4553-42f1-9f5c-c75901fab2fc	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
6a18fdd1-309a-48f7-93d1-6b3c6283dd1b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
7e5fb926-cd79-4c99-9d7c-3bc8734f6e77	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
682caff8-efe9-465d-817d-674df3b7c5e4	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
7eaa9667-9702-4349-9051-c6488fb88700	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
078058e1-23f5-4b6d-acf6-f761b26eb18b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
dca8c289-abb7-4dbb-97e2-98de6e7eb4fb	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
368f8926-0245-4912-ad99-542d0c2b5b02	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
314414a8-c9fb-4d8b-8cd0-af5cdebc1531	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
e4a4cd8b-5c6f-4c01-9d5a-0c417242b3c7	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
f8fb6c22-2658-4d56-8a10-faac2fc2fedd	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
76fabd6b-eb97-49d0-bd0a-efa00c3964bd	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
1bd0971f-3752-4b5a-8ab3-3fa8eb4bc710	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ef2cc4db-8e3e-476c-b214-82a099c8baa9	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
945f907f-087e-4788-bb4a-2246b51a8d88	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
6e5c55ad-9a12-4928-b48a-0e8571d2a38c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
dbb2ed40-31c1-41a4-84d1-cfdd9f7c617d	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
7fab541c-8b7b-4f9e-bb8c-6d9a9d0d16d0	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
e56bb713-28a3-48c2-9c33-e0521f754f78	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
9d6d60c5-76e6-41c9-b377-b9ac73ca7b24	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
8e21f8a5-a2f6-4351-a747-4ee1db413374	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
4cdd80db-e7ca-49c6-b418-9d01df15f11e	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
0cf5b610-edaf-4598-ab20-a1f2a0461b4c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
08505658-4e64-4b46-a665-46c534550fff	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c0a093ce-55ac-4157-9fa6-af7c7b5b9515	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
6736a23d-178a-4d40-8e3d-26ea3f813289	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
8bf0ff96-6e9b-4e56-9431-e5b7c7d5936c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
d383f38a-9059-4762-9053-f4035a3545c1	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
d5d7906e-e1cd-477b-9c23-0671d10e4e96	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
93b09be0-b916-466a-93a5-0409056702ba	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
a48ff736-a3e6-449d-8901-64b91ac575df	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
faebeace-0e4e-426b-8580-fe1b6a34797c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
1f82ca16-42d8-45ab-8840-8c1d01bdf88a	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
4f1dc87d-2724-4aad-8d78-d2a57bd99946	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
0d178b83-7152-4517-aabd-5a7c11961169	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
bf872f06-1b19-4f3a-8aa8-beb31a5510d1	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
0d3325ba-c095-4cad-ab35-27f9223e8de7	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
fb4c9e34-fcac-4393-8a73-05c36c5ee8cd	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
fb89e32b-da80-4c72-a826-f545b853707b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
f476a6fe-3bd5-417b-9b1c-367a13df18a2	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
99bdd99e-9797-4dd6-9b35-5108671f98aa	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
bb830a66-0214-4e65-9d13-7c459ae5cefa	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
d4967876-01f0-4c94-8af2-cbcaf6bd0b3f	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
2dbd567c-d537-4ce4-a23a-eb07642dae21	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
367ae2cf-82cf-4496-bf25-ed27f825e1da	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
06ad451f-4666-49be-9846-27b6e659f578	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
2b155358-670e-4a20-b857-5990a9ad67bb	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
da5e5bca-2370-401b-8a78-344b241d493f	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
36355eb9-6114-4d61-800f-d3907574e796	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ccea9e85-7987-44c5-9648-0845b69097bd	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
da3df8e4-bbec-41dd-b4c1-f4b43be16931	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
3d2759c4-b283-44a3-9341-3fc9fd8f658d	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
1fdd8dd4-2a61-4c2e-a6ab-bfee05369a8c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
97612c39-64bb-4dd0-b87c-7b76ebdb4fff	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
5a72ccff-ba52-495d-9d4d-fc280cd9a683	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c251eca3-f75d-4a13-ae6e-b0b2449c19f6	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c59bf81f-462c-4dad-b486-f1f5e5cc6cda	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
b6698ff4-6c3b-49db-a157-72e2c4f76b0f	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
7dde836a-9ddd-4ebf-b5d6-5210d29e0ade	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
3dbcfb88-8a39-4b3c-801e-c6470616a41b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
0e275980-a04e-41e8-b8c9-06307859b7b8	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
bc213d6a-55bb-4f02-a32d-bbab5fc894c2	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ab49ed59-328c-4b56-8515-5d0cfd64143e	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ece4a9c8-da32-4cc6-8bcf-b84a21c4c1bf	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ae6683b1-29f2-4f5f-91e6-f0d5d693b043	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
b5726055-af7b-4dbf-ad83-4d12fd10c754	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ba404650-55aa-4bed-8cf3-ac05e828e848	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
7cdcee05-b235-4b7c-ab58-1d14a56d27f0	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
9ff20edc-31ab-4a40-b816-d4b2723c5ea1	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
140fc0d2-7046-456c-985c-90509acffe16	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
11ca4664-1c58-4a87-9440-11e68c5a078e	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
4770c60b-0044-4350-97eb-1b7e0ce097de	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c4adf24d-86df-473d-bfb2-f6a985fd193e	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
d0d84d86-cbf4-4e16-8fce-4d100a711c37	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ad77f948-9476-4b0a-be13-c8ad610a3f52	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
0bb8c6c6-8757-48d7-8e15-f04fb393e871	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
36b66cd2-4171-43ec-a240-77080a35b70b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
1d88e87e-a951-4732-8819-edecc3a23d65	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
584e9cc8-d691-4983-a01d-179ad34edcd4	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
38e2316e-5a77-44a0-8649-45cf8f300c9f	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
e3840210-8b53-4e75-85bd-fa535d03fb8e	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
c59a235d-afc5-44cd-8e39-dcc6cc98f09b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
f75cbc8a-f1f8-42a1-b8e1-e843195d86e1	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
6c17d681-db0f-45a4-aca0-61cde360a524	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
2966ced5-7cc6-4bac-bc8b-ca5cefefa2d0	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
8694dbcf-50a7-45bf-bb18-5e63213ffe85	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
4225d1cc-6ef1-4c40-b629-e1ca2fe581a0	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
662651de-d7d3-48f0-9ff2-a3fe41b7e479	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ca558754-c8d1-495e-af72-0ba954a86968	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
369665c0-e6fe-4f68-98bf-2ae220193137	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
6fd4e513-00bd-4665-bf3c-b1303500d1a9	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
239c2072-1ef1-411c-8b24-11ce94a78e51	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
83efb603-6aba-4efa-9498-424a074cf385	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
773ab7de-7b86-4295-b313-a95e4359d718	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
fb7b117f-b602-491d-904e-0fe95f26bf35	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
b49bff62-5bfe-4550-88ba-e0dfaf93dbf0	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
ec78d574-feae-4e0e-a250-332b909a2f3b	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
deb7e947-6848-4a62-9124-205cf85857d8	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
48080561-ef14-427c-87cc-a3d929d1274c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
49c0eaec-6f91-4632-ab4a-e743674dc98c	0d0a3d65-e6e8-44f7-9dc4-173f2b16b8a0
\.


--
-- Data for Name: subcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subcategory (id, name, system, status, created_at, deleted_at, organization_id, updated_at) FROM stdin;
a048cf91-2c96-4306-a7c2-cac2fe1d688a	Reasoning	t	active	2021-12-21 11:04:36.597	\N	\N	2021-12-21 11:04:36.597
367c5e70-1487-4b33-96c0-529a37dbc5f2	Counting and Operations	t	active	2021-12-21 11:04:36.6	\N	\N	2021-12-21 11:04:36.6
5bb19c81-9261-428e-95ed-c87cc9f0560b	Phonological Awareness	t	active	2021-12-21 11:04:36.603	\N	\N	2021-12-21 11:04:36.603
6ccc8306-1a9e-42bd-83ff-55bac3449853	Self-Control	t	active	2021-12-21 11:04:36.607	\N	\N	2021-12-21 11:04:36.607
3b148168-31d0-4bef-9152-63c3ff516180	Miscellaneous	t	active	2021-12-21 11:04:36.61	\N	\N	2021-12-21 11:04:36.61
9a1e0589-0361-40e1-851c-b95b641e271e	Critical Thinking (Interpretation, Analysis, Evaluation, Inference, Explanation, and Self-Regulation)	t	active	2021-12-21 11:04:36.648	\N	\N	2021-12-21 11:04:36.648
9c30644b-0e9c-43aa-a19a-442e9f6aa6ae	Body Coordination	t	active	2021-12-21 11:04:36.653	\N	\N	2021-12-21 11:04:36.653
e45ff0ff-40a4-4be4-ab26-426aedba7597	Spatial Representation	t	active	2021-12-21 11:04:36.657	\N	\N	2021-12-21 11:04:36.657
ff838eb9-11b9-4de5-b854-a24d4d526f5e	Logical Problem-Solving	t	active	2021-12-21 11:04:36.661	\N	\N	2021-12-21 11:04:36.661
0fd7d721-df1b-41eb-baa4-08ba4ac2b2e7	Thematic Concepts	t	active	2021-12-21 11:04:36.665	\N	\N	2021-12-21 11:04:36.665
8eb1ba6c-4bac-457c-a798-821ddafcedee	Self-Care	t	active	2022-01-10 14:55:28.981	\N	\N	2022-01-10 14:55:28.981
bea9244e-ff17-47fc-8e7c-bceadf0f4f6e	Drawing	t	active	2021-12-21 11:04:36.58	\N	\N	2021-12-21 11:04:36.58
55cbd434-36ce-4c57-b47e-d7119b578d7e	Fluency	t	active	2021-12-21 11:04:36.583	\N	\N	2021-12-21 11:04:36.583
b9d5a570-5be3-491b-9fdc-d26ea1c13847	Reasoning Skills	t	active	2021-12-21 11:04:36.587	\N	\N	2021-12-21 11:04:36.587
39e96a23-5ac3-47c9-94fc-e71965f75880	Phonemic Awareness, Phonics, and Word Recognition	t	active	2021-12-21 11:04:36.591	\N	\N	2021-12-21 11:04:36.591
852c3495-1ced-4580-a584-9d475217f3d5	Character Education	t	active	2021-12-21 11:04:36.594	\N	\N	2021-12-21 11:04:36.594
8d3f987a-7f7c-4035-a709-9526060b2177	Science Process (Observing, Classifying, Communicating, Measuring, Predicting)	t	active	2021-12-21 11:04:36.669	\N	\N	2021-12-21 11:04:36.669
ec1d6481-ab50-42b6-a4b5-1a5fb98796d0	Phonemic Awareness	t	active	2021-12-21 11:04:36.672	\N	\N	2021-12-21 11:04:36.672
144a3478-1946-4460-a965-0d7d74e63d65	Physical Coordination	t	active	2021-12-21 11:04:36.676	\N	\N	2021-12-21 11:04:36.676
c79be603-ccf4-4284-9c8e-61b55ec53067	Self-Identity	t	active	2021-12-21 11:04:36.679	\N	\N	2021-12-21 11:04:36.679
47169b0a-ac39-4e25-bd6e-77eecaf4e051	Interpreting	t	active	2021-12-21 11:04:36.683	\N	\N	2021-12-21 11:04:36.683
3e7c719b-aa3c-45c3-87ac-08ae0e6138b1	Animal's Needs	t	active	2021-12-21 11:04:36.687	\N	\N	2021-12-21 11:04:36.687
b60f9fa0-a160-42e2-9cea-9ec39de2692a	Classification	t	active	2021-12-21 11:04:36.69	\N	\N	2021-12-21 11:04:36.69
5fff3596-42e9-416d-a2d2-29bc885fbb76	Social Emotional	t	active	2021-12-21 11:04:36.748	\N	\N	2021-12-21 11:04:36.748
38c17083-2ef7-402b-824a-20c38e3c57f4	Phonological Awareness & Phonics	t	active	2022-01-10 14:55:28.974	\N	\N	2022-01-10 14:55:28.974
7d3b5cb0-d9d2-42e8-b1f7-f58743edffdf	Sensory Play	t	active	2022-01-10 14:55:28.977	\N	\N	2022-01-10 14:55:28.977
223f3157-feb2-41ea-8c03-8a355b67343c	Academic Skills	t	active	2022-01-10 14:55:28.984	\N	\N	2022-01-10 14:55:28.984
94a39407-035c-46e0-a039-357a33e9723a	Learning Tools	t	active	2022-01-10 14:55:28.987	\N	\N	2022-01-10 14:55:28.987
6ff4c1af-252b-4e07-9537-94eaa20e0958	Logic & Reasoning	t	active	2022-01-10 14:55:28.989	\N	\N	2022-01-10 14:55:28.989
1a99684a-ff8c-44f4-9793-de96cd4ce0a4	Memory	t	active	2022-01-10 14:55:28.992	\N	\N	2022-01-10 14:55:28.992
8b955cbc-6808-49b2-adc0-5bec8b59f4fe	Phonics	t	active	2021-12-21 11:04:36.397	\N	\N	2021-12-21 11:04:36.397
2d1152a3-fb03-4c4e-aeba-98856c3241bd	Vocabulary	t	active	2021-12-21 11:04:36.401	\N	\N	2021-12-21 11:04:36.401
3fca3a2b-97b6-4ec9-a5b1-1d0ef5f1b445	Reading Skills and Comprehension	t	active	2021-12-21 11:04:36.473	\N	\N	2021-12-21 11:04:36.473
e754e22c-fd2a-43f3-a4ec-1904848f9bd6	Personal Development	t	active	2022-01-10 14:55:28.995	\N	\N	2022-01-10 14:55:28.995
40a232cd-d6e8-4ec1-97ec-4e4df7d00a78	None Specified	t	active	2021-12-21 11:04:36.387	\N	\N	2021-12-21 11:04:36.387
2b6b5d54-0243-4c7e-917a-1627f107f198	Speaking & Listening	t	active	2021-12-21 11:04:36.392	\N	\N	2021-12-21 11:04:36.392
d50cff7c-b0c7-43be-8ec7-877fa4c9a6fb	Drag	t	active	2021-12-21 11:04:36.548	\N	\N	2021-12-21 11:04:36.548
49e73e4f-8ffc-47e3-9b87-0f9686d361d7	Technology	t	active	2021-12-21 11:04:36.554	\N	\N	2021-12-21 11:04:36.554
e2190c0c-918d-4a05-a045-6696ae31d5c4	Click	t	active	2021-12-21 11:04:36.557	\N	\N	2021-12-21 11:04:36.557
01191172-b276-449f-ab11-8e66e990941e	Reading	t	active	2021-12-21 11:04:36.562	\N	\N	2021-12-21 11:04:36.562
b2cc7a69-4e64-4e97-9587-0078dccd845a	Language Support	t	active	2021-12-21 11:04:36.565	\N	\N	2021-12-21 11:04:36.565
843e4fea-7f4d-4746-87ff-693f5a44b467	Communication	t	active	2021-12-21 11:04:36.569	\N	\N	2021-12-21 11:04:36.569
a7850bd6-f5fd-4016-b708-7b823784ef0a	Writing	t	active	2021-12-21 11:04:36.573	\N	\N	2021-12-21 11:04:36.573
96f81756-70e3-41e5-9143-740376574e35	Social-Emotional Learning	t	active	2021-12-21 11:04:36.576	\N	\N	2021-12-21 11:04:36.576
9b955fb9-8eda-4469-bd31-4e8f91192663	Emergent Writing	t	active	2021-12-21 11:04:36.478	\N	\N	2021-12-21 11:04:36.478
11351e3f-afc3-476e-b3af-a0c7718269ac	Coloring	t	active	2021-12-21 11:04:36.482	\N	\N	2021-12-21 11:04:36.482
4ab80faf-60b9-4cc2-8f51-3d3b7f9fee13	Patterns	t	active	2021-12-21 11:04:36.488	\N	\N	2021-12-21 11:04:36.488
eb29827a-0053-4eee-83cd-8f4afb1b7cb4	Comprehension	t	active	2021-12-21 11:04:36.491	\N	\N	2021-12-21 11:04:36.491
188c621a-cbc7-42e2-9d01-56f4847682cb	Empathy	t	active	2021-12-21 11:04:36.495	\N	\N	2021-12-21 11:04:36.495
ddf87dff-1eb0-4971-9b27-2aaa534f34b1	Listening	t	active	2021-12-21 11:04:36.499	\N	\N	2021-12-21 11:04:36.499
644ba535-904c-4919-8b8c-688df2b6f7ee	Emergent Reading	t	active	2021-12-21 11:04:36.502	\N	\N	2021-12-21 11:04:36.502
7848bb23-2bb9-4108-938b-51f2f7d1d30f	Tracing	t	active	2021-12-21 11:04:36.506	\N	\N	2021-12-21 11:04:36.506
6fb79402-2fb6-4415-874c-338c949332ed	Art	t	active	2021-12-21 11:04:36.513	\N	\N	2021-12-21 11:04:36.513
5b405510-384a-4721-a526-e12b3cbf2092	Engineering	t	active	2021-12-21 11:04:36.516	\N	\N	2021-12-21 11:04:36.516
9a52fb0a-6ce8-45df-92a0-f25b5d3d2344	Music	t	active	2021-12-21 11:04:36.519	\N	\N	2021-12-21 11:04:36.519
4114f381-a7c5-4e88-be84-2bef4eb04ad0	Health	t	active	2021-12-21 11:04:36.523	\N	\N	2021-12-21 11:04:36.523
9a9882f1-d890-461c-a710-ca37fb78ddf5	Sight Words	t	active	2021-12-21 11:04:36.526	\N	\N	2021-12-21 11:04:36.526
f4b07251-1d67-4a84-bcda-86c71cbf9cfd	Social Studies	t	active	2021-12-21 11:04:36.53	\N	\N	2021-12-21 11:04:36.53
b79735db-91c7-4bcb-860b-fe23902f81ea	Social Interactions	t	active	2021-12-21 11:04:36.533	\N	\N	2021-12-21 11:04:36.533
c06b848d-8769-44e9-8dc7-929588cec0bc	Speaking	t	active	2021-12-21 11:04:36.538	\N	\N	2021-12-21 11:04:36.538
f385c1ec-6cfa-4f49-a219-fd28374cf2a6	Visual	t	active	2021-12-21 11:04:36.542	\N	\N	2021-12-21 11:04:36.542
7dfc3b4c-3037-42f6-89be-75839e8ab40d	Food	t	active	2021-12-21 11:04:36.694	\N	\N	2021-12-21 11:04:36.694
60c8428a-98db-445f-9a91-fbddb20eb315	Adaptations	t	active	2021-12-21 11:04:36.698	\N	\N	2021-12-21 11:04:36.698
db49ef2b-e680-488f-a241-dd5c0f0ee727	Environment	t	active	2021-12-21 11:04:36.701	\N	\N	2021-12-21 11:04:36.701
eca38066-c702-4ca0-a1e7-420d8becf687	Senses	t	active	2021-12-21 11:04:36.704	\N	\N	2021-12-21 11:04:36.704
92055ac9-45a8-4905-b713-e7b6473593f6	Growth & Development	t	active	2021-12-21 11:04:36.708	\N	\N	2021-12-21 11:04:36.708
b39b4fe4-2bc1-4d92-a8e3-ce163f6a3306	Habitats	t	active	2021-12-21 11:04:36.712	\N	\N	2021-12-21 11:04:36.712
00878904-73cc-4fb8-8ef6-9676cf89dd74	Plants & Food Chains	t	active	2021-12-21 11:04:36.716	\N	\N	2021-12-21 11:04:36.716
fe0766c7-0c91-4652-b1fe-e949590cb9a2	Movement & Interactions	t	active	2021-12-21 11:04:36.719	\N	\N	2021-12-21 11:04:36.719
e601b3ef-5bcc-4dda-bf37-47244a63d067	Ecosystems	t	active	2021-12-21 11:04:36.723	\N	\N	2021-12-21 11:04:36.723
76cc0ed5-c00c-42f3-9e3b-7d1355e2d9c0	Endangered Species & Extinction	t	active	2021-12-21 11:04:36.726	\N	\N	2021-12-21 11:04:36.726
26654f67-ddc4-493d-9bc3-f260d8125d20	Sets and Sorting	t	active	2021-12-21 11:04:36.729	\N	\N	2021-12-21 11:04:36.729
485eb5a6-73a3-497e-8d19-51cd9c10b323	Uses of Number	t	active	2021-12-21 11:04:36.732	\N	\N	2021-12-21 11:04:36.732
c9dd0e2a-608c-4833-9bf6-b73d51dfd7eb	Numerosity	t	active	2021-12-21 11:04:36.735	\N	\N	2021-12-21 11:04:36.735
4c523f7b-88ca-4e47-b0e3-27b66caf696b	Quantity	t	active	2021-12-21 11:04:36.739	\N	\N	2021-12-21 11:04:36.739
c5e36c28-2d3d-43e1-b35a-2cd9a60a30c9	Counting Rules	t	active	2021-12-21 11:04:36.741	\N	\N	2021-12-21 11:04:36.741
56ec83c8-39c7-462e-bd2b-365f2a7aae72	Creative Thinking Skills	t	active	2021-12-21 11:04:36.745	\N	\N	2021-12-21 11:04:36.745
963729a4-7853-49d2-b75d-2c61d291afee	Sensory	t	active	2021-12-21 11:04:36.404	\N	\N	2021-12-21 11:04:36.404
bd7adbd0-9ce7-4c50-aa8e-85b842683fb5	Simple Movements	t	active	2021-12-21 11:04:36.407	\N	\N	2021-12-21 11:04:36.407
b32321db-3b4a-4b1e-8db9-c485d045bf01	Logic & Memory	t	active	2021-12-21 11:04:36.412	\N	\N	2021-12-21 11:04:36.412
ba77f705-9087-4424-bff9-50fcd0b1731e	Social Skills	t	active	2021-12-21 11:04:36.415	\N	\N	2021-12-21 11:04:36.415
824bb6cb-0169-4335-b7a5-6ece2b929da3	Emotional Skills	t	active	2021-12-21 11:04:36.419	\N	\N	2021-12-21 11:04:36.419
43c9d2c5-7a23-42c9-8ad9-1132fb9c3853	Colors	t	active	2021-12-21 11:04:36.422	\N	\N	2021-12-21 11:04:36.422
8d49bbbb-b230-4d5a-900b-cde6283519a3	Numbers	t	active	2021-12-21 11:04:36.428	\N	\N	2021-12-21 11:04:36.428
ed88dcc7-30e4-4ec7-bccd-34aaacb47139	Shapes	t	active	2021-12-21 11:04:36.432	\N	\N	2021-12-21 11:04:36.432
1cb17f8a-d516-498c-97ea-8ad4d7a0c018	Letters	t	active	2021-12-21 11:04:36.437	\N	\N	2021-12-21 11:04:36.437
cd06e622-a323-40f3-8409-5384395e00d2	Science	t	active	2021-12-21 11:04:36.441	\N	\N	2021-12-21 11:04:36.441
81b09f61-4509-4ce0-b099-c208e62870f9	Math	t	active	2021-12-21 11:04:36.444	\N	\N	2021-12-21 11:04:36.444
39ac1475-4ade-4d0b-b79a-f31256521297	Coding	t	active	2021-12-21 11:04:36.448	\N	\N	2021-12-21 11:04:36.448
f78c01f9-4b8a-480c-8c4b-80d1ec1747a7	Complex Movements	t	active	2021-12-21 11:04:36.451	\N	\N	2021-12-21 11:04:36.451
f5a1e3a6-c0b1-4b2f-991f-9df7897dac67	Physical Skills	t	active	2021-12-21 11:04:36.455	\N	\N	2021-12-21 11:04:36.455
bf89c192-93dd-4192-97ab-f37198548ead	Hand-Eye Coordination	t	active	2021-12-21 11:04:36.46	\N	\N	2021-12-21 11:04:36.46
19803be1-0503-4232-afc1-e6ef06186523	Experimenting & Problem Solving	t	active	2021-12-21 11:04:36.463	\N	\N	2021-12-21 11:04:36.463
0e6b1c2b-5e2f-47e1-8422-2a183f3e15c7	Cognitive Development	t	active	2021-12-21 11:04:36.467	\N	\N	2021-12-21 11:04:36.467
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subject (id, name, system, status, created_at, deleted_at, organization_id, updated_at) FROM stdin;
b997e0d1-2dd7-40d8-847a-b8670247e96b	Language/Literacy	t	active	2021-12-21 11:04:39.412	\N	\N	2021-12-21 11:04:39.412
49c8d5ee-472b-47a6-8c57-58daf863c2e1	Language/Literacy	t	active	2021-12-21 11:04:39.428	\N	\N	2021-12-21 11:04:39.428
b19f511e-a46b-488d-9212-22c0369c8afd	Language/Literacy	t	active	2021-12-21 11:04:39.458	\N	\N	2021-12-21 11:04:39.458
29d24801-0089-4b8e-85d3-77688e961efb	Science	t	active	2021-12-21 11:04:39.479	\N	\N	2021-12-21 11:04:39.479
f037ee92-212c-4592-a171-ed32fb892162	Language/Literacy	t	active	2021-12-21 11:04:39.498	\N	\N	2021-12-21 11:04:39.498
f12276a9-4331-4699-b0fa-68e8df172843	STEAM	t	active	2021-12-21 11:04:39.514	\N	\N	2021-12-21 11:04:39.514
51189ac9-f206-469c-941c-3cda28af8788	ESL/EFL	t	active	2022-01-10 14:55:29.899	\N	\N	2022-01-10 14:55:29.899
5e9a201e-9c2f-4a92-bb6f-1ccf8177bb71	None Specified	t	active	2021-12-21 11:04:39.287	\N	\N	2021-12-21 11:04:39.287
20d6ca2f-13df-4a7a-8dcb-955908db7baa	Language/Literacy	t	active	2021-12-21 11:04:39.307	\N	\N	2021-12-21 11:04:39.307
7cf8d3a3-5493-46c9-93eb-12f220d101d0	Math	t	active	2021-12-21 11:04:39.322	\N	\N	2021-12-21 11:04:39.322
fab745e8-9e31-4d0c-b780-c40120c98b27	Science	t	active	2021-12-21 11:04:39.356	\N	\N	2021-12-21 11:04:39.356
66a453b0-d38f-472e-b055-7a94a94d66c4	Language/Literacy	t	active	2021-12-21 11:04:39.379	\N	\N	2021-12-21 11:04:39.379
36c4f793-9aa3-4fb8-84f0-68a2ab920d5a	Math	t	active	2021-12-21 11:04:39.396	\N	\N	2021-12-21 11:04:39.396
\.


--
-- Data for Name: subject_categories_category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subject_categories_category ("subjectId", "categoryId") FROM stdin;
5e9a201e-9c2f-4a92-bb6f-1ccf8177bb71	2d5ea951-836c-471e-996e-76823a992689
20d6ca2f-13df-4a7a-8dcb-955908db7baa	84b8f87a-7b61-4580-a190-a9ce3fe90dd3
20d6ca2f-13df-4a7a-8dcb-955908db7baa	ce9014a4-01a9-49d5-bf10-6b08bc454fc1
20d6ca2f-13df-4a7a-8dcb-955908db7baa	61996d3d-a37d-4873-bcdc-03b22fc6977e
20d6ca2f-13df-4a7a-8dcb-955908db7baa	e08f3578-a7d4-4cac-b028-ef7a8c93f53f
20d6ca2f-13df-4a7a-8dcb-955908db7baa	76cc6f90-86ef-48b7-9138-7b2f0bc378e7
7cf8d3a3-5493-46c9-93eb-12f220d101d0	1080d319-8ce7-4378-9c71-a5019d6b9386
7cf8d3a3-5493-46c9-93eb-12f220d101d0	f9d82bdd-4ee2-49dd-a707-133407cdef19
7cf8d3a3-5493-46c9-93eb-12f220d101d0	a1c26321-e3a7-4ff2-9f1c-bb1c5e420fb7
7cf8d3a3-5493-46c9-93eb-12f220d101d0	c12f363a-633b-4080-bd2b-9ced8d034379
7cf8d3a3-5493-46c9-93eb-12f220d101d0	e06ad483-085c-4869-bd88-56d17c7810a0
fab745e8-9e31-4d0c-b780-c40120c98b27	1cc44ecc-153a-47e9-b6e8-3b1ef94a9dee
fab745e8-9e31-4d0c-b780-c40120c98b27	0523610d-cf11-47b6-b7ab-bdbf8c3e09b6
fab745e8-9e31-4d0c-b780-c40120c98b27	d1783a8c-6bcd-492a-ad17-37386df80c56
fab745e8-9e31-4d0c-b780-c40120c98b27	1ef6ca6c-fbc4-4422-a5cb-2bcd999e4b2b
fab745e8-9e31-4d0c-b780-c40120c98b27	8488eeac-28bd-4f86-8093-9853b19f51db
66a453b0-d38f-472e-b055-7a94a94d66c4	b8c76823-150d-4d83-861e-dce7d7bc4f6d
66a453b0-d38f-472e-b055-7a94a94d66c4	b4cd42b8-a09b-4f66-a03a-b9f6b6f69895
66a453b0-d38f-472e-b055-7a94a94d66c4	bcfd9d76-cf05-4ccd-9a41-6b886da661be
66a453b0-d38f-472e-b055-7a94a94d66c4	c909acad-0c52-4fd3-8427-3b1e90a730da
66a453b0-d38f-472e-b055-7a94a94d66c4	fa8ff09d-9062-4955-9b20-5fa20757f1d9
66a453b0-d38f-472e-b055-7a94a94d66c4	29a0ab9e-6364-47b6-b63a-1388a7861c6c
66a453b0-d38f-472e-b055-7a94a94d66c4	49cbbf19-2ad7-4acb-b8c8-66531578116a
66a453b0-d38f-472e-b055-7a94a94d66c4	bd55fd6b-73ef-41ed-8a86-d7bbc501e773
66a453b0-d38f-472e-b055-7a94a94d66c4	dd3dbf0c-2872-433b-8b61-9ea78f3c9e97
36c4f793-9aa3-4fb8-84f0-68a2ab920d5a	2a637bea-c529-4868-8269-d0936696da7e
36c4f793-9aa3-4fb8-84f0-68a2ab920d5a	6933de3e-a568-4d56-8c01-e110bda22926
36c4f793-9aa3-4fb8-84f0-68a2ab920d5a	3af9f093-4153-4348-a097-986c15d1f912
36c4f793-9aa3-4fb8-84f0-68a2ab920d5a	a11a6f56-3ae3-4b70-8daa-30cdb63ef5b6
36c4f793-9aa3-4fb8-84f0-68a2ab920d5a	665616dd-32c2-44c4-91c9-63f7493c9fd3
b997e0d1-2dd7-40d8-847a-b8670247e96b	64e000aa-4a2c-4e2e-9d8d-f779e97bdd73
b997e0d1-2dd7-40d8-847a-b8670247e96b	59c47920-4d0d-477c-a33b-06e7f13873d7
b997e0d1-2dd7-40d8-847a-b8670247e96b	7e887129-1e7d-40dc-8caa-5e1e0197fb4d
b997e0d1-2dd7-40d8-847a-b8670247e96b	9e35379a-c333-4471-937e-ac9eeb89cc77
b997e0d1-2dd7-40d8-847a-b8670247e96b	5c75ab94-c4c8-43b6-a43b-b439f449a7fb
b997e0d1-2dd7-40d8-847a-b8670247e96b	ae82bafe-6513-4288-8951-18d93c07e3f1
b997e0d1-2dd7-40d8-847a-b8670247e96b	c68865b4-2ba3-4608-955c-dcc098291159
b997e0d1-2dd7-40d8-847a-b8670247e96b	61f517d8-2c2e-47fd-a2de-6e86465abc59
b997e0d1-2dd7-40d8-847a-b8670247e96b	26e4aedc-2222-44e1-a375-388b138c695d
49c8d5ee-472b-47a6-8c57-58daf863c2e1	bf1cd84d-da71-4111-82c6-e85224ab85ca
49c8d5ee-472b-47a6-8c57-58daf863c2e1	ba2db2b5-7f20-4cb7-88ef-cee0fcde7937
49c8d5ee-472b-47a6-8c57-58daf863c2e1	07786ea3-ac7b-43e0-bb91-6cd813318185
49c8d5ee-472b-47a6-8c57-58daf863c2e1	c3f73955-26f0-49bf-91f7-8c42c81fb9d3
49c8d5ee-472b-47a6-8c57-58daf863c2e1	aebc88cd-0673-487b-a194-06e3958670a4
49c8d5ee-472b-47a6-8c57-58daf863c2e1	22520430-b13e-43ba-930f-fd051bbbc42a
49c8d5ee-472b-47a6-8c57-58daf863c2e1	c3175001-2d1e-4b00-aacf-d188f4ae5cdf
49c8d5ee-472b-47a6-8c57-58daf863c2e1	19ac71c4-04e4-4d1c-8526-1acb292b7137
49c8d5ee-472b-47a6-8c57-58daf863c2e1	d896bf1a-fb5b-4a57-b833-87b0959ba926
b19f511e-a46b-488d-9212-22c0369c8afd	fc06f364-98fe-487f-97fd-d2d6358dccc6
b19f511e-a46b-488d-9212-22c0369c8afd	0e66242a-4733-4970-a055-d0d6486f8674
b19f511e-a46b-488d-9212-22c0369c8afd	e63956d9-3a36-40b3-a89d-bd45dc8c3181
b19f511e-a46b-488d-9212-22c0369c8afd	b0b983e4-bf3c-4315-912e-67c8de4f9e11
b19f511e-a46b-488d-9212-22c0369c8afd	84619bee-0b1f-447f-8208-4a39f32062c9
b19f511e-a46b-488d-9212-22c0369c8afd	4b247e7e-dcf9-46a6-a477-a69635142d14
b19f511e-a46b-488d-9212-22c0369c8afd	59565e03-8d8f-4475-a231-cfc551f004b5
b19f511e-a46b-488d-9212-22c0369c8afd	880bc0fd-0209-4f72-999d-3103f9577edf
b19f511e-a46b-488d-9212-22c0369c8afd	bac3d444-6dcc-4d6c-a4d7-fb6c96fcfc72
29d24801-0089-4b8e-85d3-77688e961efb	6090e473-ec19-4bf0-ae5c-2d6a4c793f55
29d24801-0089-4b8e-85d3-77688e961efb	da9fa132-dcf7-4148-9037-b381850ba088
29d24801-0089-4b8e-85d3-77688e961efb	585f38e6-f7be-45f2-855a-f2a4bddca125
29d24801-0089-4b8e-85d3-77688e961efb	c3ea1b4a-d220-4248-9b3f-07559b415c56
29d24801-0089-4b8e-85d3-77688e961efb	7826ff58-25d0-41f1-b38e-3e3a77ed32f6
f037ee92-212c-4592-a171-ed32fb892162	1bb26398-3e38-441e-9a8a-460057f2d8c0
f037ee92-212c-4592-a171-ed32fb892162	e65ea6b4-7093-490a-927e-d2235643f6ca
f037ee92-212c-4592-a171-ed32fb892162	88fff890-d614-4b88-be57-b7441fa40b66
f037ee92-212c-4592-a171-ed32fb892162	b18d60c6-a545-46ff-8988-cd5d46ab9660
f037ee92-212c-4592-a171-ed32fb892162	c83fd174-6504-4cc3-9175-2728d023c39d
f037ee92-212c-4592-a171-ed32fb892162	d17f1bee-cdef-4759-8c23-3e9b64d08ec1
f037ee92-212c-4592-a171-ed32fb892162	dd59f36d-717f-4982-9ae6-df32537faba0
f037ee92-212c-4592-a171-ed32fb892162	8d464354-16d9-41af-b887-103f18f4b376
f037ee92-212c-4592-a171-ed32fb892162	dfed32b5-f0bd-42ea-999b-e10b376038d5
f12276a9-4331-4699-b0fa-68e8df172843	70d1dff5-4b5a-4029-98e8-8d9fd531b509
f12276a9-4331-4699-b0fa-68e8df172843	17e2dc7e-4911-4a73-9ff0-06baba99900f
f12276a9-4331-4699-b0fa-68e8df172843	51ae3bca-0e55-465c-8302-6fdf132fa316
f12276a9-4331-4699-b0fa-68e8df172843	1d3b076f-0968-4a06-bbaa-18cff13f3db8
f12276a9-4331-4699-b0fa-68e8df172843	dafb0af8-877f-4af4-99b1-79d1a67de059
51189ac9-f206-469c-941c-3cda28af8788	0f4810e7-5ce1-47e1-8aeb-43b73f15b007
51189ac9-f206-469c-941c-3cda28af8788	d5995392-11cb-4d28-a96d-8bdcd3f0436b
51189ac9-f206-469c-941c-3cda28af8788	94013867-72d1-44e2-a43d-7336818f35d0
51189ac9-f206-469c-941c-3cda28af8788	2b9d6317-298b-4aa5-9aea-aed56bd07823
51189ac9-f206-469c-941c-3cda28af8788	fc447234-af24-4768-b617-ac1b80ebae9b
51189ac9-f206-469c-941c-3cda28af8788	d68c6c5d-c739-46d8-be70-e70d6c565949
\.


--
-- Data for Name: tmp_import; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tmp_import (id, email, first_name, last_name, organization, roles) FROM stdin;
1	max.flintoff+testbeta2@opencredo.com	Max	Flintoff	Open Credo	{Owner,"Organization Admin"}
2	guy.richardson@opencredo.com	Guy	Richardson	Open Credo	{"Organization Admin"}
3	matthew.revell@opencredo.com	Matthew	Revell	Open Credo	{"Organization Admin"}
4	max.flintoff+testlogin@opencredo.com	Test	Login	Open Credo	{Student}
\.


--
-- Data for Name: typeorm_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.typeorm_metadata (type, database, schema, "table", name, value) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."user" (user_id, given_name, family_name, username, email, phone, date_of_birth, gender, avatar, status, deleted_at, "primary", alternate_email, alternate_phone, "myOrganizationOrganizationId", created_at, updated_at) FROM stdin;
527c2d4c-2454-4f25-b194-6c6c67fe5026	Guy	Richardson	\N	guy.richardson@opencredo.com	\N	\N	\N	\N	active	\N	f	\N	\N	\N	2021-12-21 11:05:40.447	2021-12-21 11:05:40.447
611824fd-8070-45f0-84af-37295203ae17	Matthew	Revell	\N	matthew.revell@opencredo.com	\N	\N	\N	\N	active	\N	f	\N	\N	\N	2021-12-21 11:05:40.447	2021-12-21 11:05:40.447
b4479424-a9d7-46a5-8ee6-40db4ed264b1	Test	Login	\N	max.flintoff+testlogin@opencredo.com	\N		female	\N	active	\N	f	\N	\N	\N	2021-12-21 11:05:40.447	2022-01-10 14:08:47.315
7ccbecd2-5648-492f-a15f-4c8963ca291b	Load	Test I	\N	edgardom+k6_org_admin@bluetrailsoft.com	\N		not-specified	\N	active	\N	f	\N	\N	\N	2022-01-17 16:32:49.435	2022-01-17 20:01:06.77
0c6b98f0-1a68-45c8-a949-60711c0b2a50	Max	Flintoff	\N	max.flintoff+testbeta2@opencredo.com	\N		female	\N	active	\N	f	\N	\N	5956e9e9-d73c-499d-b42c-b88136fbbe56	2021-12-21 11:05:40.447	2022-01-18 14:34:10.814
182c6e98-6628-427e-a9ad-c2ed60a2bb83	Max	Teacher	\N	max.flintoff+testbeta@opencredo.com	\N		female	\N	active	\N	f	\N	\N	\N	2022-01-18 14:34:42.346	2022-01-18 14:34:42.346
08541445-56c2-4550-81ff-7559c945192e	Test-000	K6-000	\N	ismaelp+user_000@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:40.292	2022-01-18 15:57:40.292
41e31ea1-ee63-45dc-8f66-60c5bf338245	Test-001	K6-001	\N	ismaelp+user_001@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:40.606	2022-01-18 15:57:40.606
2620fd68-8253-40cb-9532-97fdaab65bdc	Test-002	K6-002	\N	ismaelp+user_002@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:40.922	2022-01-18 15:57:40.922
8d5e3d77-6813-425f-bfc8-78bc72235210	Test-003	K6-003	\N	ismaelp+user_003@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:41.235	2022-01-18 15:57:41.235
29b980ba-43f1-4789-85eb-0681ecd34d50	Test-004	K6-004	\N	ismaelp+user_004@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:41.554	2022-01-18 15:57:41.554
67e3f25a-6d49-4afc-91f5-422648501c22	Test-005	K6-005	\N	ismaelp+user_005@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:41.877	2022-01-18 15:57:41.877
db087b6f-f44d-4a61-b3ce-4783010eafe1	Test-006	K6-006	\N	ismaelp+user_006@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:42.197	2022-01-18 15:57:42.197
1478d854-31c1-4c7b-8cd5-946db8fb3913	Test-007	K6-007	\N	ismaelp+user_007@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:42.512	2022-01-18 15:57:42.512
cdac1f61-3dc9-4b66-af30-98205a2fef13	Test-008	K6-008	\N	ismaelp+user_008@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:42.821	2022-01-18 15:57:42.821
ba4e15d4-06a4-4d74-a83c-b061508eabd6	Test-009	K6-009	\N	ismaelp+user_009@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:43.131	2022-01-18 15:57:43.131
af26e37e-4625-4255-9ccb-bfabe5690b54	Test-010	K6-010	\N	ismaelp+user_010@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:57:43.617	2022-01-18 15:57:43.617
976cd4cf-3276-4a30-95f9-675c670941f3	Test-011	K6-011	\N	ismaelp+user_011@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:44.179	2022-01-18 15:58:44.179
d112f364-50a1-4b07-89d8-ba384bbd2c71	Test-012	K6-012	\N	ismaelp+user_012@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:44.483	2022-01-18 15:58:44.483
b13089b9-d832-4907-9240-a6c310763a28	Test-013	K6-013	\N	ismaelp+user_013@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:44.797	2022-01-18 15:58:44.797
41dee2e5-ffd6-4202-8370-98bf7560374d	Test-014	K6-014	\N	ismaelp+user_014@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:45.101	2022-01-18 15:58:45.101
252f5821-cfa2-46b8-87f1-aae3673a573b	Test-015	K6-015	\N	ismaelp+user_015@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:45.392	2022-01-18 15:58:45.392
60916b31-72ac-4eee-90a0-804746a7a088	Test-016	K6-016	\N	ismaelp+user_016@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:45.683	2022-01-18 15:58:45.683
7ea58850-6fdf-4c2b-8c42-56c6a06ef646	Test-017	K6-017	\N	ismaelp+user_017@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:45.984	2022-01-18 15:58:45.984
94f66e07-59b0-49c1-954f-fb30bd95785d	Test-018	K6-018	\N	ismaelp+user_018@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:46.289	2022-01-18 15:58:46.289
aaf7e8e7-493d-4eb7-a6ff-8d220e93bbf1	Test-019	K6-019	\N	ismaelp+user_019@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:46.589	2022-01-18 15:58:46.589
b9eea1fc-71f7-4576-984e-a050d4fe4928	Test-020	K6-020	\N	ismaelp+user_020@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:46.887	2022-01-18 15:58:46.887
371cbf5d-3273-4209-a9a9-df7696134d9f	Test-021	K6-021	\N	ismaelp+user_021@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:47.186	2022-01-18 15:58:47.186
166e2026-7bee-4446-98fd-f60e6d189337	Test-022	K6-022	\N	ismaelp+user_022@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:47.469	2022-01-18 15:58:47.469
75da7464-f264-4871-bfee-6a89cd5c61ae	Test-023	K6-023	\N	ismaelp+user_023@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:47.754	2022-01-18 15:58:47.754
cc774be4-eee3-4154-955f-2b810cc2c057	Test-024	K6-024	\N	ismaelp+user_024@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:48.033	2022-01-18 15:58:48.033
dbe61da1-8e55-4aa1-a773-a246e885d6f8	Test-025	K6-025	\N	ismaelp+user_025@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:48.312	2022-01-18 15:58:48.312
47f2b855-1e6a-438e-a92b-50ac460b7dd1	Test-026	K6-026	\N	ismaelp+user_026@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:48.588	2022-01-18 15:58:48.588
62272ef9-6da6-4297-a5ef-c24f6af31a58	Test-027	K6-027	\N	ismaelp+user_027@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:48.864	2022-01-18 15:58:48.864
c687597f-be44-4d0b-ae27-1e03ecfb9906	Test-028	K6-028	\N	ismaelp+user_028@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:49.15	2022-01-18 15:58:49.15
52d4cd1f-bd63-4101-976a-f76648cbe9ae	Test-029	K6-029	\N	ismaelp+user_029@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:49.429	2022-01-18 15:58:49.429
b0e45a2e-453d-42b5-9dcd-08ffd6212e9d	Test-030	K6-030	\N	ismaelp+user_030@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:49.707	2022-01-18 15:58:49.707
d5fe3b89-0526-4c5d-8b51-49d00d83865a	Test-031	K6-031	\N	ismaelp+user_031@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:49.996	2022-01-18 15:58:49.996
8a73ff19-267d-4d8d-83e5-ebe6cbae5b55	Test-032	K6-032	\N	ismaelp+user_032@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:50.282	2022-01-18 15:58:50.282
1a3704d6-18e0-413b-a155-c106a2224e68	Test-033	K6-033	\N	ismaelp+user_033@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:50.568	2022-01-18 15:58:50.568
cc537e59-2844-4721-b4c1-1eadddc45bef	Test-034	K6-034	\N	ismaelp+user_034@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:50.857	2022-01-18 15:58:50.857
b2469051-827c-4e1a-862d-208593f71ef4	Test-035	K6-035	\N	ismaelp+user_035@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:51.136	2022-01-18 15:58:51.136
92cf9d0b-5515-4099-94a4-36ca52653a03	Test-036	K6-036	\N	ismaelp+user_036@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:51.419	2022-01-18 15:58:51.419
25666e2c-d6c5-4207-9299-24e2829292d7	Test-037	K6-037	\N	ismaelp+user_037@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:51.703	2022-01-18 15:58:51.703
80d65593-d8f3-4808-9a58-d35c90ef2cab	Test-038	K6-038	\N	ismaelp+user_038@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:51.984	2022-01-18 15:58:51.984
66e82261-9198-440d-b3d4-f6fb2eb3ce94	Test-039	K6-039	\N	ismaelp+user_039@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:52.267	2022-01-18 15:58:52.267
025d1237-74ca-4fcd-838d-31032ae3ab9e	Test-040	K6-040	\N	ismaelp+user_040@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:52.547	2022-01-18 15:58:52.547
4f8c6f58-2028-4278-9687-41183657257e	Test-041	K6-041	\N	ismaelp+user_041@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:52.836	2022-01-18 15:58:52.836
cc6932d8-4dbe-46de-8cac-578d7bc0debb	Test-042	K6-042	\N	ismaelp+user_042@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:53.128	2022-01-18 15:58:53.128
f1d75a44-206a-49bb-a44f-04482624fcd0	Test-043	K6-043	\N	ismaelp+user_043@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:53.41	2022-01-18 15:58:53.41
5b567c82-5615-4032-9804-e7f101a45330	Test-044	K6-044	\N	ismaelp+user_044@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:53.686	2022-01-18 15:58:53.686
21cfab88-8217-44ea-81c8-65ea3319d70e	Test-045	K6-045	\N	ismaelp+user_045@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:53.967	2022-01-18 15:58:53.967
daa456ce-9550-4d7d-802c-235daa3f77db	Test-046	K6-046	\N	ismaelp+user_046@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:54.247	2022-01-18 15:58:54.247
08b27fae-a3a9-43a7-af39-1d3fa9eaada2	Test-047	K6-047	\N	ismaelp+user_047@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:54.531	2022-01-18 15:58:54.531
00b8a2e2-3796-410c-93bc-e525b13d4fe5	Test-048	K6-048	\N	ismaelp+user_048@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:54.811	2022-01-18 15:58:54.811
09afbf1a-1ee9-4103-8ad7-ce99bf81b123	Test-049	K6-049	\N	ismaelp+user_049@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:55.097	2022-01-18 15:58:55.097
c3c8bba5-e78d-4c3a-8247-fb2485dae884	Test-050	K6-050	\N	ismaelp+user_050@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:55.374	2022-01-18 15:58:55.374
04503827-0413-44fb-8d5d-049196ae2a86	Test-051	K6-051	\N	ismaelp+user_051@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:55.657	2022-01-18 15:58:55.657
572d0811-9bbd-469b-870c-cc697953eda6	Test-052	K6-052	\N	ismaelp+user_052@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:55.939	2022-01-18 15:58:55.939
8b22f38e-dd2a-4332-85c0-36751fec5dbd	Test-053	K6-053	\N	ismaelp+user_053@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:56.223	2022-01-18 15:58:56.223
5292e9fb-cfeb-49f6-9995-9ff6a31d39aa	Test-054	K6-054	\N	ismaelp+user_054@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:56.518	2022-01-18 15:58:56.518
ba69e699-f355-4091-b729-254fabc1b586	Test-055	K6-055	\N	ismaelp+user_055@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:56.793	2022-01-18 15:58:56.793
dd7f170b-3965-4cfc-8323-2c90d0c466cc	Test-056	K6-056	\N	ismaelp+user_056@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:57.067	2022-01-18 15:58:57.067
50769eb7-cd8c-45e6-b42b-8c6dc32a4f91	Test-057	K6-057	\N	ismaelp+user_057@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:57.346	2022-01-18 15:58:57.346
2ba57ff0-3d3b-4454-9499-c9ed14bc95fc	Test-058	K6-058	\N	ismaelp+user_058@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:57.629	2022-01-18 15:58:57.629
25326c97-4498-4b86-90f0-3e35c8370b6d	Test-059	K6-059	\N	ismaelp+user_059@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:57.914	2022-01-18 15:58:57.914
7fbca29b-ed16-45aa-b260-3ed4110c566e	Test-060	K6-060	\N	ismaelp+user_060@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:58.188	2022-01-18 15:58:58.188
d4c47e74-6782-42ee-b58c-ae972585e936	Test-061	K6-061	\N	ismaelp+user_061@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:58.463	2022-01-18 15:58:58.463
9af6a1fd-f6af-4af3-8907-10b46aa0aee9	Test-062	K6-062	\N	ismaelp+user_062@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:58.747	2022-01-18 15:58:58.747
63bb6608-f828-49eb-a26a-d7c204e61c42	Test-063	K6-063	\N	ismaelp+user_063@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:59.031	2022-01-18 15:58:59.031
d0ac968c-e55c-4429-b606-e1c0e9095c0b	Test-064	K6-064	\N	ismaelp+user_064@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:59.318	2022-01-18 15:58:59.318
07b3e391-ef75-4ac2-9edd-5c0bef411b2d	Test-065	K6-065	\N	ismaelp+user_065@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:59.591	2022-01-18 15:58:59.591
2b3e13d8-7d61-420d-9c07-6cba678c5f71	Test-066	K6-066	\N	ismaelp+user_066@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:58:59.862	2022-01-18 15:58:59.862
860033d5-e361-4d2a-97ef-db3164fb26de	Test-067	K6-067	\N	ismaelp+user_067@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:00.136	2022-01-18 15:59:00.136
d278bab8-b0af-4d40-904d-ee729910a09e	Test-068	K6-068	\N	ismaelp+user_068@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:00.419	2022-01-18 15:59:00.419
0d7ab0b0-8be4-4aea-b2dc-f0050f52ff44	Test-069	K6-069	\N	ismaelp+user_069@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:00.702	2022-01-18 15:59:00.702
66f50333-2dd3-41d5-9fd1-36e44369165d	Test-070	K6-070	\N	ismaelp+user_070@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:00.987	2022-01-18 15:59:00.987
4a1c3644-7145-4702-9ba9-1923764626ec	Test-071	K6-071	\N	ismaelp+user_071@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:01.27	2022-01-18 15:59:01.27
11865178-5dbb-46ac-ad42-28864a02ace0	Test-072	K6-072	\N	ismaelp+user_072@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:01.596	2022-01-18 15:59:01.596
6783c878-4529-4b63-8c21-89d4a7e941f1	Test-073	K6-073	\N	ismaelp+user_073@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:01.878	2022-01-18 15:59:01.878
c9ff80f2-982e-4c53-97fa-8fee003979f4	Test-074	K6-074	\N	ismaelp+user_074@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:02.157	2022-01-18 15:59:02.157
61fa6bf1-a517-4a11-8f65-d33e03bcf1fd	Test-075	K6-075	\N	ismaelp+user_075@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:02.44	2022-01-18 15:59:02.44
a1ccdbcd-24ae-4333-9a94-f5d6d60ff008	Test-076	K6-076	\N	ismaelp+user_076@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:02.717	2022-01-18 15:59:02.717
7f26426e-51d3-44f5-b333-7a6c5457ca9b	Test-077	K6-077	\N	ismaelp+user_077@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:02.995	2022-01-18 15:59:02.995
b1e0a887-58d5-4b12-894d-4d429e512320	Test-078	K6-078	\N	ismaelp+user_078@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:03.274	2022-01-18 15:59:03.274
5d90fbc9-fc3d-4626-a8ce-5a434cb0a696	Test-079	K6-079	\N	ismaelp+user_079@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:03.563	2022-01-18 15:59:03.563
bdfbe5db-a78f-4322-ba28-6fa56f791d8e	Test-080	K6-080	\N	ismaelp+user_080@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:03.842	2022-01-18 15:59:03.842
e2e2ef6b-82a2-481f-bf92-821051e3f211	Test-081	K6-081	\N	ismaelp+user_081@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:04.138	2022-01-18 15:59:04.138
814da935-79f4-4d93-91d3-7793faac9be0	Test-082	K6-082	\N	ismaelp+user_082@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:04.415	2022-01-18 15:59:04.415
a1150aef-ee35-4a27-8098-87ea99ded4d4	Test-083	K6-083	\N	ismaelp+user_083@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:04.7	2022-01-18 15:59:04.7
2d52057d-85a1-42b7-ab5f-0e38fd9cb0c7	Test-084	K6-084	\N	ismaelp+user_084@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:04.985	2022-01-18 15:59:04.985
c79d9813-fc56-40ae-bf93-d42a3e9fc5e1	Test-085	K6-085	\N	ismaelp+user_085@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:05.265	2022-01-18 15:59:05.265
dfc3adbc-82a4-40c8-88a0-2c28df83d838	Test-086	K6-086	\N	ismaelp+user_086@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:05.537	2022-01-18 15:59:05.537
1f922c03-1ba9-4076-9ec7-e116f662e03f	Test-087	K6-087	\N	ismaelp+user_087@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:05.847	2022-01-18 15:59:05.847
08e5c6f8-6692-45ca-826b-01637aa0ff73	Test-088	K6-088	\N	ismaelp+user_088@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:06.156	2022-01-18 15:59:06.156
51405652-8ec7-4d11-ae8e-215ad1ebf139	Test-089	K6-089	\N	ismaelp+user_089@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:06.434	2022-01-18 15:59:06.434
40ec36c6-ab98-4919-81c1-9f2722d0d3fe	Test-090	K6-090	\N	ismaelp+user_090@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:06.739	2022-01-18 15:59:06.739
ee0cb774-659b-4640-ae7e-047a66edb247	Test-091	K6-091	\N	ismaelp+user_091@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:07.028	2022-01-18 15:59:07.028
bf9a5f81-4da2-412a-9e78-ce159fd75283	Test-092	K6-092	\N	ismaelp+user_092@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:07.314	2022-01-18 15:59:07.314
366ac80e-68f6-4074-b25a-b0ccfeecf6b8	Test-093	K6-093	\N	ismaelp+user_093@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:07.598	2022-01-18 15:59:07.598
dacc03b6-1534-4612-af6d-e62623897ee9	Test-094	K6-094	\N	ismaelp+user_094@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:07.883	2022-01-18 15:59:07.883
8e8ce815-9d3c-46ff-840f-c618169d8502	Test-095	K6-095	\N	ismaelp+user_095@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:08.159	2022-01-18 15:59:08.159
12c12b96-302c-4b61-ab90-b85d49072a84	Test-096	K6-096	\N	ismaelp+user_096@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:08.434	2022-01-18 15:59:08.434
580befe5-ee5e-4b0c-bc60-7e2d1af658be	Test-097	K6-097	\N	ismaelp+user_097@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:08.707	2022-01-18 15:59:08.707
c8d70777-7c4a-4373-9d57-3fb93c8a594e	Test-098	K6-098	\N	ismaelp+user_098@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:08.989	2022-01-18 15:59:08.989
a388cdda-4f10-481c-892c-0bc05ae9f150	Test-099	K6-099	\N	ismaelp+user_099@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:09.269	2022-01-18 15:59:09.269
1f1c3b33-62cf-407c-9562-fa445acc7dc7	Test-100	K6-100	\N	ismaelp+user_100@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 15:59:09.549	2022-01-18 15:59:09.549
b3c4a363-3a59-44c4-9926-9ed48b12f1ae	K6 2	Org Admin	\N	edgardom+k6_org_admin_2@bluetrailsoft.com	\N		female	\N	active	\N	f	\N	\N	\N	2022-01-18 16:14:07.223	2022-01-18 16:14:07.223
e9a1b937-f6fd-46f1-92fb-df6440dc70e0	K6	2	\N	edgardom+k6_school_admi_2n@bluetrailsoft.com	\N		female	\N	active	\N	f	\N	\N	\N	2022-01-18 16:16:11.429	2022-01-18 16:16:11.429
a8b88118-f977-49ec-b0d6-8c4f8638cc0e	Test-101	K6-101	\N	ismaelp+user_101@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:37.979	2022-01-18 19:38:37.979
bceec891-2417-46c0-a65e-49720cb13b4e	Test-102	K6-102	\N	ismaelp+user_102@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:38.284	2022-01-18 19:38:38.284
d33e20b7-1446-4be7-9990-0f28cc36071a	Test-103	K6-103	\N	ismaelp+user_103@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:38.588	2022-01-18 19:38:38.588
30151184-da43-41b9-a9cb-3649c1727889	Test-104	K6-104	\N	ismaelp+user_104@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:38.891	2022-01-18 19:38:38.891
8e67bda8-433d-44cb-a6ba-7f7382b7dac9	Test-105	K6-105	\N	ismaelp+user_105@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:39.198	2022-01-18 19:38:39.198
8b908fc2-0e18-41a8-a8bf-d404c7bd4673	Test-106	K6-106	\N	ismaelp+user_106@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:39.492	2022-01-18 19:38:39.492
d968ef17-e90b-4348-a74d-f5f36f566e69	Test-107	K6-107	\N	ismaelp+user_107@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:39.8	2022-01-18 19:38:39.8
ea111673-1ee5-423e-ab8a-44659219aec3	Test-108	K6-108	\N	ismaelp+user_108@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:40.091	2022-01-18 19:38:40.091
e8483a10-5c9e-4482-b6c0-87b42890cdc5	Test-109	K6-109	\N	ismaelp+user_109@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:40.395	2022-01-18 19:38:40.395
f0384321-a9bc-475a-852b-4b4d1d6a2c0c	Test-110	K6-110	\N	ismaelp+user_110@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:40.693	2022-01-18 19:38:40.693
bc220b61-699a-4e00-9a8f-a543edfc3485	Test-111	K6-111	\N	ismaelp+user_111@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:40.977	2022-01-18 19:38:40.977
b54aaa9f-3916-42ac-a4a5-5528c5ce8eda	Test-112	K6-112	\N	ismaelp+user_112@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:41.254	2022-01-18 19:38:41.254
595010bc-34a9-43f4-bc75-1ce93e8e6f20	Test-113	K6-113	\N	ismaelp+user_113@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:41.541	2022-01-18 19:38:41.541
8cd71ec4-a878-497b-a24f-2e23c7f21ff1	Test-114	K6-114	\N	ismaelp+user_114@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:41.822	2022-01-18 19:38:41.822
72914232-c7b2-4881-bd5d-003e94fd215d	Test-115	K6-115	\N	ismaelp+user_115@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:42.097	2022-01-18 19:38:42.097
bb215e23-4d9f-4951-b2f1-6e24a2bcf994	Test-116	K6-116	\N	ismaelp+user_116@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:42.373	2022-01-18 19:38:42.373
e5b0a680-e6f7-45e5-8dab-995b8497eded	Test-117	K6-117	\N	ismaelp+user_117@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:42.652	2022-01-18 19:38:42.652
54b0386e-767e-4a1b-8c93-f6555c9d313a	Test-118	K6-118	\N	ismaelp+user_118@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:42.927	2022-01-18 19:38:42.927
72ce550d-74d7-408e-aefc-445bd6413159	Test-119	K6-119	\N	ismaelp+user_119@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:43.213	2022-01-18 19:38:43.213
765888ba-7859-49f7-ad76-82a84f32c239	Test-120	K6-120	\N	ismaelp+user_120@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:43.492	2022-01-18 19:38:43.492
7f2b497f-88ca-489c-864d-7db89087b73e	Test-121	K6-121	\N	ismaelp+user_121@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:43.765	2022-01-18 19:38:43.765
aaefde3f-7891-4526-813b-fae0fbfaa665	Test-122	K6-122	\N	ismaelp+user_122@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:44.045	2022-01-18 19:38:44.045
f28bc03b-51ce-439c-93a8-cee33d04db58	Test-123	K6-123	\N	ismaelp+user_123@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:44.327	2022-01-18 19:38:44.327
e13e0bf9-8c93-413e-a16c-f734f99eb599	Test-124	K6-124	\N	ismaelp+user_124@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:44.608	2022-01-18 19:38:44.608
6b5d27d1-7043-4fb0-9dd8-dcb0df5641d6	Test-125	K6-125	\N	ismaelp+user_125@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:44.888	2022-01-18 19:38:44.888
26003172-4df0-45d3-aa60-58508f576830	Test-126	K6-126	\N	ismaelp+user_126@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:45.161	2022-01-18 19:38:45.161
8084f068-8462-4d00-9dc8-663015fdd685	Test-127	K6-127	\N	ismaelp+user_127@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:45.442	2022-01-18 19:38:45.442
98c9d975-aadf-45ee-94b9-e17235d0318c	Test-128	K6-128	\N	ismaelp+user_128@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:45.722	2022-01-18 19:38:45.722
357ee1ef-2309-4566-b3a3-3ac707c054ab	Test-129	K6-129	\N	ismaelp+user_129@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:46.003	2022-01-18 19:38:46.003
390ff267-7985-4eed-8e1f-63e47e3dc254	Test-130	K6-130	\N	ismaelp+user_130@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:46.287	2022-01-18 19:38:46.287
9037a6c8-42a0-46a8-821d-4706e5e1be75	Test-131	K6-131	\N	ismaelp+user_131@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:46.564	2022-01-18 19:38:46.564
e8836720-44de-4fcf-b488-7600456f5041	Test-132	K6-132	\N	ismaelp+user_132@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:46.846	2022-01-18 19:38:46.846
7a7c7641-8a23-41c6-936d-aa711d96af8e	Test-133	K6-133	\N	ismaelp+user_133@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:47.131	2022-01-18 19:38:47.131
effedda3-bda1-4a4c-9a72-a212f2042886	Test-134	K6-134	\N	ismaelp+user_134@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:47.418	2022-01-18 19:38:47.418
8a6d9a1b-9bfb-4b4b-9b2b-dc2bfa18e195	Test-135	K6-135	\N	ismaelp+user_135@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:47.7	2022-01-18 19:38:47.7
11c81d21-c6eb-4272-923b-4a68e88ec2d2	Test-136	K6-136	\N	ismaelp+user_136@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:47.976	2022-01-18 19:38:47.976
45f8f5df-833b-41ba-9aea-2ba5bc7204b9	Test-137	K6-137	\N	ismaelp+user_137@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:48.252	2022-01-18 19:38:48.252
f9dfdc99-6b61-4916-8506-4f59e374bd62	Test-138	K6-138	\N	ismaelp+user_138@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:48.532	2022-01-18 19:38:48.532
b50882f7-09c3-42de-8adc-f51cd7839267	Test-139	K6-139	\N	ismaelp+user_139@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:48.804	2022-01-18 19:38:48.804
f52f44fe-37a1-44ec-ac81-00936dc14568	Test-140	K6-140	\N	ismaelp+user_140@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:49.08	2022-01-18 19:38:49.08
08456804-5978-40fd-9921-f4ea55cc5cc8	Test-141	K6-141	\N	ismaelp+user_141@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:49.355	2022-01-18 19:38:49.355
040ff3a7-2374-497f-9e49-98415f41da5a	Test-142	K6-142	\N	ismaelp+user_142@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:49.636	2022-01-18 19:38:49.636
3c0e1678-f0e9-4f11-be49-83208485acdc	Test-143	K6-143	\N	ismaelp+user_143@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:49.919	2022-01-18 19:38:49.919
4f67754d-538c-4cf1-bdaf-a9809d67e085	Test-144	K6-144	\N	ismaelp+user_144@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:50.2	2022-01-18 19:38:50.2
cd29d82c-b949-470c-9ffe-54efe72e7ebf	Test-145	K6-145	\N	ismaelp+user_145@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:50.477	2022-01-18 19:38:50.477
949dfdfd-0673-4f34-a098-4c722e3198d9	Test-146	K6-146	\N	ismaelp+user_146@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:50.748	2022-01-18 19:38:50.748
fda36f24-a2b2-4b76-a96e-9c3392f8dc76	Test-147	K6-147	\N	ismaelp+user_147@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:51.027	2022-01-18 19:38:51.027
ff913ae7-96e6-400d-8ebe-402397887c19	Test-148	K6-148	\N	ismaelp+user_148@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:51.301	2022-01-18 19:38:51.301
f68c8cb7-1f68-46c7-b1ea-c897c4ff0276	Test-149	K6-149	\N	ismaelp+user_149@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:51.586	2022-01-18 19:38:51.586
e2a3cf3f-c14e-4519-b6cd-f6fe4bfdf567	Test-150	K6-150	\N	ismaelp+user_150@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:51.87	2022-01-18 19:38:51.87
054f8f61-cf9d-49fd-a934-cfb4e96877a5	Test-151	K6-151	\N	ismaelp+user_151@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:52.148	2022-01-18 19:38:52.148
18201392-43f6-46a8-b40c-1fffe23b135a	Test-152	K6-152	\N	ismaelp+user_152@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:52.43	2022-01-18 19:38:52.43
6929d728-543c-4abc-b297-7c4764c48f1b	Test-153	K6-153	\N	ismaelp+user_153@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:52.708	2022-01-18 19:38:52.708
e83c5011-e137-423a-9abd-d179ce2154f7	Test-154	K6-154	\N	ismaelp+user_154@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:52.99	2022-01-18 19:38:52.99
6bebce93-bf43-485d-b10a-33c41a4670f7	Test-155	K6-155	\N	ismaelp+user_155@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:53.268	2022-01-18 19:38:53.268
0e098a43-e600-4d9f-8b9f-f2f8a3dec94b	Test-156	K6-156	\N	ismaelp+user_156@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:53.542	2022-01-18 19:38:53.542
17ab59d1-6452-4b4f-a69f-48f3da71e462	Test-157	K6-157	\N	ismaelp+user_157@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:53.814	2022-01-18 19:38:53.814
becbce79-d5fb-4748-be4b-a605eea216a4	Test-158	K6-158	\N	ismaelp+user_158@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:54.087	2022-01-18 19:38:54.087
02084382-cfdd-4474-835c-25c966d4a68a	Test-159	K6-159	\N	ismaelp+user_159@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:54.365	2022-01-18 19:38:54.365
c927eec1-f4f1-452f-a017-2e5dc2dce49b	Test-160	K6-160	\N	ismaelp+user_160@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:54.643	2022-01-18 19:38:54.643
e768f45e-23cf-45a1-98b0-032239d65297	Test-161	K6-161	\N	ismaelp+user_161@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:54.923	2022-01-18 19:38:54.923
403204cc-11d1-4fdc-93a4-aba666d3e844	Test-162	K6-162	\N	ismaelp+user_162@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:55.203	2022-01-18 19:38:55.203
77958711-d91c-4530-b266-6897d9b23c80	Test-163	K6-163	\N	ismaelp+user_163@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:55.488	2022-01-18 19:38:55.488
ceb5c553-8af6-4d74-bc2c-998b6f810058	Test-164	K6-164	\N	ismaelp+user_164@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:55.773	2022-01-18 19:38:55.773
a3fb926d-a5a7-4db7-95f9-c37d89a019a8	Test-165	K6-165	\N	ismaelp+user_165@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:56.054	2022-01-18 19:38:56.054
9c3bec00-fa01-41c1-8751-d443fc53de84	Test-166	K6-166	\N	ismaelp+user_166@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:56.342	2022-01-18 19:38:56.342
2f2c9ab6-a96e-4806-b91f-74c1ef11ad3c	Test-167	K6-167	\N	ismaelp+user_167@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:56.618	2022-01-18 19:38:56.618
79909aa7-124b-4cc0-8af7-43e6f66dca30	Test-168	K6-168	\N	ismaelp+user_168@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:56.894	2022-01-18 19:38:56.894
d2289729-9ae3-4a8c-8486-6fd2685172b3	Test-169	K6-169	\N	ismaelp+user_169@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:57.166	2022-01-18 19:38:57.166
0f132cc3-3754-4245-9cee-92e7b5f8c00a	Test-170	K6-170	\N	ismaelp+user_170@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:57.487	2022-01-18 19:38:57.487
a59d564e-c43c-405a-82ae-abcc5dff2139	Test-171	K6-171	\N	ismaelp+user_171@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:57.772	2022-01-18 19:38:57.772
1d38ccf3-24de-420d-9095-b80e22a6c295	Test-172	K6-172	\N	ismaelp+user_172@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:58.058	2022-01-18 19:38:58.058
b678b03c-acf3-4633-b688-f78e2fe006dd	Test-173	K6-173	\N	ismaelp+user_173@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:58.345	2022-01-18 19:38:58.345
30cbac52-6a13-4732-92a1-294946bb529b	Test-174	K6-174	\N	ismaelp+user_174@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:58.625	2022-01-18 19:38:58.625
625ef27d-99ff-40dd-977d-727545bf4a4c	Test-175	K6-175	\N	ismaelp+user_175@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:58.908	2022-01-18 19:38:58.908
727f2f7d-37e6-45b7-9537-0a73da54b5b1	Test-176	K6-176	\N	ismaelp+user_176@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:59.18	2022-01-18 19:38:59.18
8cbb10d1-8680-4e60-98bb-a677b4f41803	Test-177	K6-177	\N	ismaelp+user_177@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:59.449	2022-01-18 19:38:59.449
ffdc8b92-b27a-4737-9033-656adb915cfd	Test-178	K6-178	\N	ismaelp+user_178@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:38:59.725	2022-01-18 19:38:59.725
eca4d17c-e514-45d6-b212-feecf574494a	Test-179	K6-179	\N	ismaelp+user_179@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:00.006	2022-01-18 19:39:00.006
7d5d796d-f597-4dc8-a581-e033c2e951f1	Test-180	K6-180	\N	ismaelp+user_180@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:00.296	2022-01-18 19:39:00.296
ff97e1bf-00f2-4c32-b954-1a08bfddd0e8	Test-181	K6-181	\N	ismaelp+user_181@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:00.572	2022-01-18 19:39:00.572
bb0ea035-2294-44f1-a25c-7229bf335e1d	Test-191	K6-191	\N	ismaelp+user_191@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:03.382	2022-01-18 19:39:03.382
d563a8d7-8b62-4f53-9930-ebbea7f3edad	Test-182	K6-182	\N	ismaelp+user_182@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:00.851	2022-01-18 19:39:00.851
c638d3ca-c6db-43bc-8ae0-bb1ca9a62423	Test-192	K6-192	\N	ismaelp+user_192@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:03.662	2022-01-18 19:39:03.662
33561269-044c-4e6e-a933-0ff06d36459c	Test-183	K6-183	\N	ismaelp+user_183@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:01.141	2022-01-18 19:39:01.141
0d7b4204-00f9-42fb-9f49-eadb5dc5b1a3	Test-193	K6-193	\N	ismaelp+user_193@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:03.947	2022-01-18 19:39:03.947
1699a638-1a77-48d3-9c25-656ef29b6eae	Test-184	K6-184	\N	ismaelp+user_184@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:01.437	2022-01-18 19:39:01.437
e27608d0-0ae7-49ed-aad1-ec74be537418	Test-194	K6-194	\N	ismaelp+user_194@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:04.23	2022-01-18 19:39:04.23
a06a37eb-6436-4913-8f1e-e5c5f28b389b	Test-185	K6-185	\N	ismaelp+user_185@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:01.713	2022-01-18 19:39:01.713
e9cb43b7-522b-4878-afa1-609744d0c2d9	Test-186	K6-186	\N	ismaelp+user_186@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:01.989	2022-01-18 19:39:01.989
5a2a75ef-7e0e-4ead-bef1-bfe4808b0773	Test-187	K6-187	\N	ismaelp+user_187@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:02.271	2022-01-18 19:39:02.271
d16b8223-1f14-48f5-bd52-ab0f3390e25c	Test-188	K6-188	\N	ismaelp+user_188@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:02.55	2022-01-18 19:39:02.55
82fc2987-ab8a-4ddf-8922-2d576d648030	Test-189	K6-189	\N	ismaelp+user_189@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:02.826	2022-01-18 19:39:02.826
bd16bf05-c647-4211-bbeb-91abeb573375	Test-190	K6-190	\N	ismaelp+user_190@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:03.1	2022-01-18 19:39:03.1
df8279ca-7849-49b1-b18b-d9e70ea83854	Test-195	K6-195	\N	ismaelp+user_195@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:04.508	2022-01-18 19:39:04.508
316f9c5e-9e38-49a7-bfc5-3c8fbf8e1055	Test-196	K6-196	\N	ismaelp+user_196@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:04.785	2022-01-18 19:39:04.785
ae5b0c6f-8384-480a-8780-6093352dd45b	Test-197	K6-197	\N	ismaelp+user_197@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:05.073	2022-01-18 19:39:05.073
30d41cc0-02a1-4760-a6d2-401f63882d41	Test-198	K6-198	\N	ismaelp+user_198@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:05.353	2022-01-18 19:39:05.353
c43f5050-28e6-469a-a092-488d05136c2c	Test-199	K6-199	\N	ismaelp+user_199@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:05.632	2022-01-18 19:39:05.632
f8bf32cc-086c-4d5a-aabe-bbf7c563cc21	Test-200	K6-200	\N	ismaelp+user_200@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:39:05.907	2022-01-18 19:39:05.907
994b5a41-ffaf-4b49-967d-686800cb3221	Test-201	K6-201	\N	ismaelp+user_201@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:16.804	2022-01-18 19:53:16.804
4b00253d-b27a-45c0-ba75-e973298ac1f9	Test-202	K6-202	\N	ismaelp+user_202@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:17.1	2022-01-18 19:53:17.1
3f7ac114-2abe-4d5a-8a32-12f01203dbaa	Test-203	K6-203	\N	ismaelp+user_203@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:17.392	2022-01-18 19:53:17.392
2ee9c42d-413a-4a4e-a9ee-6948eaad7125	Test-204	K6-204	\N	ismaelp+user_204@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:17.684	2022-01-18 19:53:17.684
d2714fb7-9117-4514-ad63-1a660bcb3275	Test-205	K6-205	\N	ismaelp+user_205@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:17.999	2022-01-18 19:53:17.999
69c8123a-31bf-4dc8-b1a1-feadce0b0d6e	Test-206	K6-206	\N	ismaelp+user_206@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:18.302	2022-01-18 19:53:18.302
a8ac1caf-42c9-4a84-811e-1b29514161ae	Test-207	K6-207	\N	ismaelp+user_207@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:18.611	2022-01-18 19:53:18.611
cb84bb1b-6cd4-457d-aa21-fb817321f1f0	Test-208	K6-208	\N	ismaelp+user_208@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:18.91	2022-01-18 19:53:18.91
3110bfe4-8495-4b0e-bfde-564f86c3fbd4	Test-209	K6-209	\N	ismaelp+user_209@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:19.208	2022-01-18 19:53:19.208
68598968-5662-4fe3-9b0d-9108f57d63d7	Test-210	K6-210	\N	ismaelp+user_210@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:19.5	2022-01-18 19:53:19.5
aaed7f00-6212-4dc0-8417-093a70395b1f	Test-211	K6-211	\N	ismaelp+user_211@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:19.777	2022-01-18 19:53:19.777
3d70ce5a-8030-456f-9177-1a143b654206	Test-212	K6-212	\N	ismaelp+user_212@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:20.046	2022-01-18 19:53:20.046
7cffc00e-cfb2-4464-aa5f-ea0e60757150	Test-213	K6-213	\N	ismaelp+user_213@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:20.315	2022-01-18 19:53:20.315
07aa8eb7-3ba6-4aff-a010-fc8c22df5f29	Test-214	K6-214	\N	ismaelp+user_214@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:20.589	2022-01-18 19:53:20.589
37cc53a0-c129-46a2-b9d1-bf152e3c2cff	Test-215	K6-215	\N	ismaelp+user_215@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:20.862	2022-01-18 19:53:20.862
e952cec0-4f03-4320-800f-5e7f0307ccda	Test-216	K6-216	\N	ismaelp+user_216@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:21.144	2022-01-18 19:53:21.144
008a83ca-d1b2-41c9-adf5-33914625c81b	Test-217	K6-217	\N	ismaelp+user_217@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:21.416	2022-01-18 19:53:21.416
d0e88f1c-868f-4a9e-b9fb-2f3177043a82	Test-218	K6-218	\N	ismaelp+user_218@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:21.692	2022-01-18 19:53:21.692
2cfd4d5e-47e3-4035-a7e1-614ed27241f2	Test-219	K6-219	\N	ismaelp+user_219@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:21.968	2022-01-18 19:53:21.968
403c59bd-7141-4c0f-9931-b595a4ec1fe5	Test-220	K6-220	\N	ismaelp+user_220@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:22.24	2022-01-18 19:53:22.24
5c7739a8-44b2-4a3d-9821-469c413b7742	Test-221	K6-221	\N	ismaelp+user_221@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:22.51	2022-01-18 19:53:22.51
690088a0-d559-495d-9168-01755ca57219	Test-222	K6-222	\N	ismaelp+user_222@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:22.779	2022-01-18 19:53:22.779
b02d9ed6-4ccf-443e-a486-309e3663a968	Test-223	K6-223	\N	ismaelp+user_223@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:23.049	2022-01-18 19:53:23.049
d83477e6-a3c0-40a7-84d7-e0dfeda130ab	Test-224	K6-224	\N	ismaelp+user_224@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:23.322	2022-01-18 19:53:23.322
15f0117f-7104-4ea6-a73a-7cc9e6a88fa1	Test-225	K6-225	\N	ismaelp+user_225@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:23.605	2022-01-18 19:53:23.605
d186c668-53a7-43c1-937d-ae0ae4b7426d	Test-226	K6-226	\N	ismaelp+user_226@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:23.882	2022-01-18 19:53:23.882
e58e4049-9809-421b-a0f9-aca389849413	Test-227	K6-227	\N	ismaelp+user_227@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:24.16	2022-01-18 19:53:24.16
211cf55a-ad24-4c48-b014-afd96e948983	Test-228	K6-228	\N	ismaelp+user_228@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:24.442	2022-01-18 19:53:24.442
e398d6d1-b7df-4406-aefb-21ede4df1978	Test-229	K6-229	\N	ismaelp+user_229@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:24.726	2022-01-18 19:53:24.726
74b39c99-6a86-4a6e-9f12-bfdd079ab3ee	Test-230	K6-230	\N	ismaelp+user_230@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:24.998	2022-01-18 19:53:24.998
2627f264-7af3-49b4-b213-a1e208f11e92	Test-231	K6-231	\N	ismaelp+user_231@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:25.269	2022-01-18 19:53:25.269
5032f4fc-b1b1-48a4-912c-f043e19a0bdd	Test-232	K6-232	\N	ismaelp+user_232@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:25.545	2022-01-18 19:53:25.545
4c4dd570-606e-47b4-b9c0-c8ea19469473	Test-233	K6-233	\N	ismaelp+user_233@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:25.816	2022-01-18 19:53:25.816
2e7c3df3-c357-4c82-a659-1e99621cec3f	Test-234	K6-234	\N	ismaelp+user_234@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:26.089	2022-01-18 19:53:26.089
f7a4270e-5142-4dd3-a3bf-7417e1222729	Test-235	K6-235	\N	ismaelp+user_235@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:26.36	2022-01-18 19:53:26.36
8f177e8d-2e11-40c4-9cfe-5f88bbeb87ab	Test-236	K6-236	\N	ismaelp+user_236@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:26.637	2022-01-18 19:53:26.637
43ebacd1-d587-4712-ad25-f7c84a8fcd60	Test-237	K6-237	\N	ismaelp+user_237@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:26.916	2022-01-18 19:53:26.916
0add028e-4685-4ebc-87fb-dc2044c2fed5	Test-238	K6-238	\N	ismaelp+user_238@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:27.196	2022-01-18 19:53:27.196
d3def1a8-3253-4aa2-af58-7182d7343eff	Test-239	K6-239	\N	ismaelp+user_239@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:27.477	2022-01-18 19:53:27.477
6a8e069d-aaeb-47ca-b43f-30e1d9a6cbd1	Test-240	K6-240	\N	ismaelp+user_240@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:27.742	2022-01-18 19:53:27.742
3e7c1471-6cf8-406d-b974-a7a662cf309a	Test-241	K6-241	\N	ismaelp+user_241@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:28.005	2022-01-18 19:53:28.005
5b268aa4-580a-41a9-80e2-66195fc74bae	Test-242	K6-242	\N	ismaelp+user_242@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:28.271	2022-01-18 19:53:28.271
34ce0003-834d-4e85-bd62-e316a107fb8e	Test-243	K6-243	\N	ismaelp+user_243@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:28.547	2022-01-18 19:53:28.547
a56cec2c-abc7-4f15-beae-de2d85699147	Test-244	K6-244	\N	ismaelp+user_244@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:28.82	2022-01-18 19:53:28.82
92c179dc-237e-46a0-bbf9-50af3183c2af	Test-245	K6-245	\N	ismaelp+user_245@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:29.085	2022-01-18 19:53:29.085
5851e71f-a9e4-4460-a662-073975dd11d7	Test-246	K6-246	\N	ismaelp+user_246@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:29.365	2022-01-18 19:53:29.365
be746b9e-b7b9-4748-a730-d1308fe6dff7	Test-247	K6-247	\N	ismaelp+user_247@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:29.643	2022-01-18 19:53:29.643
5ccd4c71-2e3a-4a97-a042-da39968b8bdd	Test-248	K6-248	\N	ismaelp+user_248@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:29.926	2022-01-18 19:53:29.926
518b2d4a-d320-428f-ad0e-0f2a8e891ed4	Test-249	K6-249	\N	ismaelp+user_249@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:30.201	2022-01-18 19:53:30.201
0776d95b-570e-4b56-bc6b-2279e93f1a7f	Test-250	K6-250	\N	ismaelp+user_250@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:30.47	2022-01-18 19:53:30.47
a75fbe5e-67fa-40e7-ae9f-441d64a44bad	Test-251	K6-251	\N	ismaelp+user_251@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:30.739	2022-01-18 19:53:30.739
e01353a8-96c4-47b7-84bb-32a03c844957	Test-252	K6-252	\N	ismaelp+user_252@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:31.006	2022-01-18 19:53:31.006
93911459-f8f7-47b3-b720-0ef75892f249	Test-253	K6-253	\N	ismaelp+user_253@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:31.279	2022-01-18 19:53:31.279
edbb1f1a-f1f0-48ea-9cfe-28464633318b	Test-254	K6-254	\N	ismaelp+user_254@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:31.547	2022-01-18 19:53:31.547
fbf1e698-0df9-41f4-a5c6-adf077db3f27	Test-255	K6-255	\N	ismaelp+user_255@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:31.824	2022-01-18 19:53:31.824
54496b2f-69ef-440a-840b-4d7aeac509ea	Test-256	K6-256	\N	ismaelp+user_256@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:32.097	2022-01-18 19:53:32.097
208e364d-e34e-484c-ba7d-de958a216c6a	Test-257	K6-257	\N	ismaelp+user_257@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:32.375	2022-01-18 19:53:32.375
7153e22a-80c0-4712-b879-a746ace59de8	Test-258	K6-258	\N	ismaelp+user_258@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:32.651	2022-01-18 19:53:32.651
4ae3007e-6d23-45a2-8c23-37916d78e3c0	Test-259	K6-259	\N	ismaelp+user_259@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:32.93	2022-01-18 19:53:32.93
5485e361-25a9-418a-a503-1a55da1d9db3	Test-260	K6-260	\N	ismaelp+user_260@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:33.197	2022-01-18 19:53:33.197
fed965e3-10fc-462b-8454-8740206d8835	Test-261	K6-261	\N	ismaelp+user_261@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:33.469	2022-01-18 19:53:33.469
cdc79885-7f18-40f7-a8ff-c0bcfc50bec4	Test-262	K6-262	\N	ismaelp+user_262@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:33.743	2022-01-18 19:53:33.743
6f2fbdfe-d971-4b7d-b603-faf01968f500	Test-263	K6-263	\N	ismaelp+user_263@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:34.016	2022-01-18 19:53:34.016
1c8eacc6-c2e0-4caa-aade-0a8d2c04fe0a	Test-264	K6-264	\N	ismaelp+user_264@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:34.285	2022-01-18 19:53:34.285
1f1b40a2-3978-4207-9734-0fc0ac7f2899	Test-265	K6-265	\N	ismaelp+user_265@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:34.551	2022-01-18 19:53:34.551
d6a2c14a-19d0-4b13-95c1-7affd7a75473	Test-266	K6-266	\N	ismaelp+user_266@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:34.825	2022-01-18 19:53:34.825
5501d154-86da-48d0-9b50-3f808e7c4c58	Test-267	K6-267	\N	ismaelp+user_267@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:35.095	2022-01-18 19:53:35.095
3dd2fb45-0573-4b28-8fcd-e1a1717b5535	Test-268	K6-268	\N	ismaelp+user_268@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:35.367	2022-01-18 19:53:35.367
e5f0f719-49bc-4054-8d78-7dcba47f17fe	Test-269	K6-269	\N	ismaelp+user_269@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:35.645	2022-01-18 19:53:35.645
ef41ed6b-b334-4b75-ba16-9635c637d58a	Test-270	K6-270	\N	ismaelp+user_270@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:35.91	2022-01-18 19:53:35.91
64a28fba-ee56-48f3-b600-0371a74a4b05	Test-271	K6-271	\N	ismaelp+user_271@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:36.184	2022-01-18 19:53:36.184
ee44ebfd-ff0b-4ffd-950e-1eccf60f0c5f	Test-272	K6-272	\N	ismaelp+user_272@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:36.459	2022-01-18 19:53:36.459
41a33d7b-b745-4322-a4f0-aefc5f81858a	Test-273	K6-273	\N	ismaelp+user_273@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:36.737	2022-01-18 19:53:36.737
49e1e30c-6dc5-48e7-9c4c-1659c64322e5	Test-274	K6-274	\N	ismaelp+user_274@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:37.023	2022-01-18 19:53:37.023
1553c296-9df5-408d-be4b-6dd0bd6a4e9e	Test-275	K6-275	\N	ismaelp+user_275@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:37.314	2022-01-18 19:53:37.314
dc585a36-2faf-4deb-b834-561a5480d880	Test-276	K6-276	\N	ismaelp+user_276@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:37.589	2022-01-18 19:53:37.589
00fcca0e-fec8-450c-ac6c-e35806aeefe9	Test-277	K6-277	\N	ismaelp+user_277@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:37.864	2022-01-18 19:53:37.864
87e89a8a-d2ea-404b-ac74-03833aee202d	Test-278	K6-278	\N	ismaelp+user_278@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:38.148	2022-01-18 19:53:38.148
6e1c47a5-dc1d-4e92-8758-03d7e88f4b80	Test-279	K6-279	\N	ismaelp+user_279@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:38.427	2022-01-18 19:53:38.427
6ff78bee-64f8-4415-a5e6-a893deaa63bb	Test-280	K6-280	\N	ismaelp+user_280@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:38.698	2022-01-18 19:53:38.698
8f4ab0bc-735e-4ce7-8b01-2c5387b7f54a	Test-281	K6-281	\N	ismaelp+user_281@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:38.979	2022-01-18 19:53:38.979
8b3fb58d-6fea-4f2e-934f-0e257c6c1c85	Test-282	K6-282	\N	ismaelp+user_282@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:39.248	2022-01-18 19:53:39.248
d9cf57c8-a8f3-45f2-bd95-2178e4b61c97	Test-283	K6-283	\N	ismaelp+user_283@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:39.517	2022-01-18 19:53:39.517
fac72272-3840-4695-b17a-edd549ccc730	Test-284	K6-284	\N	ismaelp+user_284@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:39.794	2022-01-18 19:53:39.794
b5c729d0-fef2-4850-9f66-d786b7e1a0af	Test-285	K6-285	\N	ismaelp+user_285@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:40.07	2022-01-18 19:53:40.07
f413da06-210d-4562-96bd-2b61e81d1b1d	Test-286	K6-286	\N	ismaelp+user_286@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:40.353	2022-01-18 19:53:40.353
02770cc4-cc04-46bf-af2b-2698f61ee577	Test-287	K6-287	\N	ismaelp+user_287@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:40.635	2022-01-18 19:53:40.635
d5880231-4816-4268-964b-ee5b190d6962	Test-288	K6-288	\N	ismaelp+user_288@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:40.919	2022-01-18 19:53:40.919
e1e64f97-013d-4b66-b189-879d71829e63	Test-289	K6-289	\N	ismaelp+user_289@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:41.194	2022-01-18 19:53:41.194
a663bb21-0553-40bc-84e5-8aa366f999c9	Test-290	K6-290	\N	ismaelp+user_290@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:41.463	2022-01-18 19:53:41.463
bbd82119-8f2c-4801-adc1-619232ea4c58	Test-291	K6-291	\N	ismaelp+user_291@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:41.741	2022-01-18 19:53:41.741
7a3b3e39-d212-4894-a59c-f27726933cce	Test-292	K6-292	\N	ismaelp+user_292@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:42.012	2022-01-18 19:53:42.012
96814ee0-3f49-4868-b396-a5acefdb1c90	Test-293	K6-293	\N	ismaelp+user_293@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:42.285	2022-01-18 19:53:42.285
01a2f078-04d3-47bf-8c5e-84d716caa144	Test-294	K6-294	\N	ismaelp+user_294@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:42.553	2022-01-18 19:53:42.553
d4de3ea1-a166-4782-8865-9a9d50798b5f	Test-295	K6-295	\N	ismaelp+user_295@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:42.823	2022-01-18 19:53:42.823
9f940121-0e47-424c-a694-48e6846c5b1c	Test-296	K6-296	\N	ismaelp+user_296@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:43.094	2022-01-18 19:53:43.094
d6832150-1c47-460f-8892-3c41aba513eb	Test-297	K6-297	\N	ismaelp+user_297@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:43.365	2022-01-18 19:53:43.365
98ea9347-f197-421e-8f55-8775d53ce001	Test-298	K6-298	\N	ismaelp+user_298@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:43.647	2022-01-18 19:53:43.647
c197051c-a611-473d-8b79-15c9fca6950a	Test-299	K6-299	\N	ismaelp+user_299@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:43.924	2022-01-18 19:53:43.924
019a5aba-0536-4661-8799-11616becec9c	Test-300	K6-300	\N	ismaelp+user_300@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-18 19:53:44.192	2022-01-18 19:53:44.192
b8d224f1-099f-4fce-9fc0-cc28a2a4b33f	Test-344180	K6-344180	\N	ismaelp_k6-single_344180@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:08:30.838	2022-01-19 19:08:30.838
610683d7-417e-47d9-a36c-a3fcc0aa914e	Test-292804	K6-292804	\N	ismaelp_k6-single_292804@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:08:35.398	2022-01-19 19:08:35.398
f5ea5c5d-8182-4ce7-af16-b8dbd5b39a5d	Test-322352	K6-322352	\N	ismaelp_k6-single_322352@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:08:39.486	2022-01-19 19:08:39.486
72c1e522-6543-476f-8b7e-680cbe84dd32	Test-114297	K6-114297	\N	ismaelp_k6-single_114297@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:08:43.581	2022-01-19 19:08:43.581
d9cda8fb-f116-4e41-95f9-65e0adeb9b69	Test-558297	K6-558297	\N	ismaelp_k6-single_558297@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:08:47.684	2022-01-19 19:08:47.684
ebb42aca-f8c0-4658-af66-458578e6b677	Test-287127	K6-287127	\N	ismaelp_k6-single_287127@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:10:40.26	2022-01-19 19:10:40.26
c4532ab5-b181-4e05-83fa-68cc0505745b	Test-523880	K6-523880	\N	ismaelp_k6-single_523880@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:10:44.772	2022-01-19 19:10:44.772
baf317ba-e3fd-4d59-9165-8b9be6e7a342	Test-433004	K6-433004	\N	ismaelp_k6-single_433004@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:10:48.949	2022-01-19 19:10:48.949
f3f138cb-44e0-40c3-b941-e1c8b0410892	Test-820069	K6-820069	\N	ismaelp_k6-single_820069@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:10:53.062	2022-01-19 19:10:53.062
4af2b8a3-eef1-428c-b8ba-b701e55ef510	Test-919905	K6-919905	\N	ismaelp_k6-single_919905@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:10:57.576	2022-01-19 19:10:57.576
fc5e80e4-a208-4bef-bd34-9be3162c9b4d	Test-676991	K6-676991	\N	ismaelp_k6-single_676991@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:12:17.163	2022-01-19 19:12:17.163
c530893c-f2e4-43ef-9a0a-3cbfc5627bab	Test-331011	K6-331011	\N	ismaelp_k6-single_331011@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:12:21.697	2022-01-19 19:12:21.697
55a87bbd-dfb6-4f29-ab68-24b8bfe1af23	Test-276576	K6-276576	\N	ismaelp_k6-single_276576@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:12:25.759	2022-01-19 19:12:25.759
6fac4668-cfeb-495c-aab9-17f459b04be9	Test-395003	K6-395003	\N	ismaelp_k6-single_395003@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:12:29.851	2022-01-19 19:12:29.851
b65f67ee-b22b-43af-a04f-50607a713c78	Test-615690	K6-615690	\N	ismaelp_k6-single_615690@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:12:33.924	2022-01-19 19:12:33.924
82677696-9782-4123-b989-80140a6f0ecb	Test-parralel-000	K6-Parallel-000	\N	ismaelp+user_test_parallel-_000@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:08.852	2022-01-19 19:16:08.852
26865bcd-5635-463c-807b-fd9f46aeb1ea	Test-parralel-001	K6-Parallel-001	\N	ismaelp+user_test_parallel-_001@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:11.887	2022-01-19 19:16:11.887
40399e9d-5abd-4d59-818b-6d061782124a	Test-parralel-002	K6-Parallel-002	\N	ismaelp+user_test_parallel-_002@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:14.497	2022-01-19 19:16:14.497
851a13cb-3be7-4d4b-b4bf-353503a6aa2b	Test-parralel-003	K6-Parallel-003	\N	ismaelp+user_test_parallel-_003@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:17.077	2022-01-19 19:16:17.077
6997e817-c8cc-44f4-83a1-e202fe0f8068	Test-parralel-004	K6-Parallel-004	\N	ismaelp+user_test_parallel-_004@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:19.64	2022-01-19 19:16:19.64
2ae5e47d-e8ee-440a-945b-881e18fc8a02	Test-parralel-005	K6-Parallel-005	\N	ismaelp+user_test_parallel-_005@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:22.199	2022-01-19 19:16:22.199
bec0e199-4d4a-4b60-b39e-40e72e85e0c4	Test-parralel-006	K6-Parallel-006	\N	ismaelp+user_test_parallel-_006@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:24.74	2022-01-19 19:16:24.74
6d7b9bc9-24e7-4fec-8fae-13d1fcd62429	Test-parralel-007	K6-Parallel-007	\N	ismaelp+user_test_parallel-_007@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:27.306	2022-01-19 19:16:27.306
cfea06a7-1da1-4a32-9ac4-6a4a076ed274	Test-parralel-008	K6-Parallel-008	\N	ismaelp+user_test_parallel-_008@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:29.854	2022-01-19 19:16:29.854
04dcbdd5-837e-42c8-9b95-7dcbeee94886	Test-parralel-009	K6-Parallel-009	\N	ismaelp+user_test_parallel-_009@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:16:32.396	2022-01-19 19:16:32.396
25495ebb-20c3-40ef-9b4e-cc75c1e04f02	Test-parralel-010	K6-Parallel-010	\N	ismaelp+user_test_parallel-_010@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:19.611	2022-01-19 19:18:19.611
74cf45de-9e29-41ff-9e40-48a9311d5bf4	Test-parralel-011	K6-Parallel-011	\N	ismaelp+user_test_parallel-_011@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:22.832	2022-01-19 19:18:22.832
5894778a-40ef-4d13-943c-8b95a9182f87	Test-parralel-012	K6-Parallel-012	\N	ismaelp+user_test_parallel-_012@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:25.385	2022-01-19 19:18:25.385
8d553257-503c-47d6-856c-dc2c64d82a20	Test-parralel-013	K6-Parallel-013	\N	ismaelp+user_test_parallel-_013@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:27.981	2022-01-19 19:18:27.981
506d0816-867a-4b3a-a2a7-161162faa157	Test-parralel-014	K6-Parallel-014	\N	ismaelp+user_test_parallel-_014@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:30.551	2022-01-19 19:18:30.551
b1d80f09-a4ae-4f26-bd26-f5d3170c5a1d	Test-parralel-015	K6-Parallel-015	\N	ismaelp+user_test_parallel-_015@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:33.072	2022-01-19 19:18:33.072
436dae7e-6103-4f32-b309-4fd9903b8bad	Test-parralel-016	K6-Parallel-016	\N	ismaelp+user_test_parallel-_016@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:35.603	2022-01-19 19:18:35.603
3855a408-8784-4702-b5eb-5691ed7da656	Test-parralel-017	K6-Parallel-017	\N	ismaelp+user_test_parallel-_017@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:38.149	2022-01-19 19:18:38.149
5ddf1901-0d11-4464-b73e-a5460c51e558	Test-parralel-018	K6-Parallel-018	\N	ismaelp+user_test_parallel-_018@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:40.692	2022-01-19 19:18:40.692
d8a70e2d-596c-4364-9243-bb6586921ca5	Test-parralel-019	K6-Parallel-019	\N	ismaelp+user_test_parallel-_019@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:18:43.254	2022-01-19 19:18:43.254
5c86ddc3-9f57-4723-a82c-fc5464b1b67b	Test-parralel-000	K6-Parallel-000	\N	ismaelp+k8+user_test_parallel-_000@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:36:52.607	2022-01-19 19:36:52.607
32e4d30c-8273-4293-a7fc-bb52da485cd1	Test-parralel-010	K6-Parallel-010	\N	ismaelp+k8+user_test_parallel-_010@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:36:52.611	2022-01-19 19:36:52.611
14e51473-8e5f-4e8d-a783-7599f75beab9	Test-parralel-001	K6-Parallel-001	\N	ismaelp+k8+user_test_parallel-_001@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:36:55.599	2022-01-19 19:36:55.599
e6bb6593-07ea-448f-9927-b07f51df3c07	Test-parralel-011	K6-Parallel-011	\N	ismaelp+k8+user_test_parallel-_011@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:36:55.627	2022-01-19 19:36:55.627
ebda8550-4025-42a2-aaeb-936c63f86cd3	Test-parralel-002	K6-Parallel-002	\N	ismaelp+k8+user_test_parallel-_002@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:36:58.152	2022-01-19 19:36:58.152
10bdb3f0-bd63-4399-8711-1a985bc1cc52	Test-parralel-012	K6-Parallel-012	\N	ismaelp+k8+user_test_parallel-_012@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:36:58.207	2022-01-19 19:36:58.207
ffb7f50c-fdd5-4e7e-8efa-d32530c74f4c	Test-parralel-003	K6-Parallel-003	\N	ismaelp+k8+user_test_parallel-_003@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:00.728	2022-01-19 19:37:00.728
d69293a9-5d4e-4b8c-8cf7-74033a9b905e	Test-parralel-013	K6-Parallel-013	\N	ismaelp+k8+user_test_parallel-_013@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:00.813	2022-01-19 19:37:00.813
107e2dfa-fdea-43e8-a38c-102684a51ddc	Test-parralel-004	K6-Parallel-004	\N	ismaelp+k8+user_test_parallel-_004@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:03.558	2022-01-19 19:37:03.558
d250adec-3b22-4ca2-b2a1-02f2daa75a62	Test-parralel-014	K6-Parallel-014	\N	ismaelp+k8+user_test_parallel-_014@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:03.717	2022-01-19 19:37:03.717
756c0a16-7fc8-4b44-a1bc-9bdca0e90fae	Test-parralel-005	K6-Parallel-005	\N	ismaelp+k8+user_test_parallel-_005@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:06.079	2022-01-19 19:37:06.079
a9d695ba-f130-47e7-95ca-a603545bba22	Test-parralel-015	K6-Parallel-015	\N	ismaelp+k8+user_test_parallel-_015@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:06.223	2022-01-19 19:37:06.223
d1f59360-de10-44d4-9c0c-40721eab1a5c	Test-parralel-006	K6-Parallel-006	\N	ismaelp+k8+user_test_parallel-_006@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:08.59	2022-01-19 19:37:08.59
630e5016-708c-4d1b-9be1-1c36f99ba8ab	Test-parralel-016	K6-Parallel-016	\N	ismaelp+k8+user_test_parallel-_016@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:08.746	2022-01-19 19:37:08.746
de0aa407-a6b3-464f-a581-8baceac91804	Test-parralel-007	K6-Parallel-007	\N	ismaelp+k8+user_test_parallel-_007@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:11.118	2022-01-19 19:37:11.118
de5026df-0bf1-4f55-9f1d-b90470cc94c6	Test-parralel-017	K6-Parallel-017	\N	ismaelp+k8+user_test_parallel-_017@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:11.24	2022-01-19 19:37:11.24
6140c6d5-95b9-4821-9d95-218776d28c36	Test-parralel-008	K6-Parallel-008	\N	ismaelp+k8+user_test_parallel-_008@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:13.641	2022-01-19 19:37:13.641
fc7db61f-9f1c-4d5e-8f8f-318ec0f458b6	Test-parralel-018	K6-Parallel-018	\N	ismaelp+k8+user_test_parallel-_018@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:13.745	2022-01-19 19:37:13.745
ba03c723-c172-4774-bd89-1bf403d83e16	Test-parralel-009	K6-Parallel-009	\N	ismaelp+k8+user_test_parallel-_009@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:16.142	2022-01-19 19:37:16.142
7f9df86c-a11f-46a6-bcbc-b4e87c54ce91	Test-parralel-019	K6-Parallel-019	\N	ismaelp+k8+user_test_parallel-_019@bluetrailsoft.com	\N	01-1990	male	\N	active	\N	f	\N	\N	\N	2022-01-19 19:37:16.25	2022-01-19 19:37:16.25
ff51f226-2445-454f-9a08-498d064152d1	Test	Teacher	\N	matthew.revell+testteacher@opencredo.com	\N		not-specified	\N	active	\N	f	\N	\N	\N	2022-01-21 11:56:24.959	2022-01-21 11:56:24.959
d3fcc303-7151-4c32-b4e2-981b81092175	Oscar	Davao	\N	oscar.dovao@opencredo.com	\N		male	\N	active	\N	f	\N	\N	\N	2022-02-03 10:44:31.461	2022-02-03 10:44:31.461
\.


--
-- Data for Name: user_classes_studying_class; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_classes_studying_class ("userUserId", "classClassId") FROM stdin;
b4479424-a9d7-46a5-8ee6-40db4ed264b1	8b09033d-7db9-46c3-aeb8-138c9e7eff96
b4479424-a9d7-46a5-8ee6-40db4ed264b1	8f4f696a-f935-412d-8134-d53062cea38e
\.


--
-- Data for Name: user_classes_teaching_class; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_classes_teaching_class ("userUserId", "classClassId") FROM stdin;
0c6b98f0-1a68-45c8-a949-60711c0b2a50	8b09033d-7db9-46c3-aeb8-138c9e7eff96
611824fd-8070-45f0-84af-37295203ae17	8f4f696a-f935-412d-8134-d53062cea38e
0c6b98f0-1a68-45c8-a949-60711c0b2a50	8f4f696a-f935-412d-8134-d53062cea38e
\.


--
-- Name: assessment_xapi_migration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.assessment_xapi_migration_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 33, true);


--
-- Name: tmp_import_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tmp_import_id_seq', 33, true);


--
-- Name: assessment_xapi_teacher_score PK_0635333ae0b87c23b09cd2b3fb2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_teacher_score
    ADD CONSTRAINT "PK_0635333ae0b87c23b09cd2b3fb2" PRIMARY KEY (room_id, student_id, content_id, teacher_id);


--
-- Name: subject PK_12eee115462e38d62e5455fc054; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT "PK_12eee115462e38d62e5455fc054" PRIMARY KEY (id);


--
-- Name: class_age_ranges_age_range PK_1507a42105236fbad0d1f6b2e88; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_age_ranges_age_range
    ADD CONSTRAINT "PK_1507a42105236fbad0d1f6b2e88" PRIMARY KEY ("classClassId", "ageRangeId");


--
-- Name: role_school_memberships_school_membership PK_1c14964d630a9d9e274b3a78916; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_school_memberships_school_membership
    ADD CONSTRAINT "PK_1c14964d630a9d9e274b3a78916" PRIMARY KEY ("roleRoleId", "schoolMembershipUserId", "schoolMembershipSchoolId");


--
-- Name: class_programs_program PK_25d5b747b7bb35e3fe3b7f9e4a3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_programs_program
    ADD CONSTRAINT "PK_25d5b747b7bb35e3fe3b7f9e4a3" PRIMARY KEY ("classClassId", "programId");


--
-- Name: assessment_xapi_migration PK_26ad815e53656dbca647bba6613; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_migration
    ADD CONSTRAINT "PK_26ad815e53656dbca647bba6613" PRIMARY KEY (id);


--
-- Name: assessment_xapi_user_content_score PK_26ee95476b7f319a923db88853f; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_user_content_score
    ADD CONSTRAINT "PK_26ee95476b7f319a923db88853f" PRIMARY KEY (room_id, student_id, content_id);


--
-- Name: role_memberships_organization_membership PK_2fd508e51b02927a5d0de7669fd; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_memberships_organization_membership
    ADD CONSTRAINT "PK_2fd508e51b02927a5d0de7669fd" PRIMARY KEY ("roleRoleId", "organizationMembershipUserId", "organizationMembershipOrganizationId");


--
-- Name: class_subjects_subject PK_38f031e950c10d63bf7bdbef423; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_subjects_subject
    ADD CONSTRAINT "PK_38f031e950c10d63bf7bdbef423" PRIMARY KEY ("classClassId", "subjectId");


--
-- Name: program PK_3bade5945afbafefdd26a3a29fb; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT "PK_3bade5945afbafefdd26a3a29fb" PRIMARY KEY (id);


--
-- Name: assessment_xapi_answer PK_4152b79edecd2ec1205759c7c32; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_answer
    ADD CONSTRAINT "PK_4152b79edecd2ec1205759c7c32" PRIMARY KEY (room_id, student_id, content_id, "timestamp");


--
-- Name: class PK_4265c685fe8a9043bd8d400ad58; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT "PK_4265c685fe8a9043bd8d400ad58" PRIMARY KEY (class_id);


--
-- Name: organization_membership PK_4c0dd6adaf8fc161026db004550; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_membership
    ADD CONSTRAINT "PK_4c0dd6adaf8fc161026db004550" PRIMARY KEY (user_id, organization_id);


--
-- Name: age_range PK_4c404ea3863e76f5169b5b1c691; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.age_range
    ADD CONSTRAINT "PK_4c404ea3863e76f5169b5b1c691" PRIMARY KEY (id);


--
-- Name: user_classes_teaching_class PK_51286e4c55d45731f544a75caa9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_classes_teaching_class
    ADD CONSTRAINT "PK_51286e4c55d45731f544a75caa9" PRIMARY KEY ("userUserId", "classClassId");


--
-- Name: grade PK_58c2176c3ae96bf57daebdbcb5e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT "PK_58c2176c3ae96bf57daebdbcb5e" PRIMARY KEY (id);


--
-- Name: branding_image PK_59577d335561e2a2a19beb2885e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branding_image
    ADD CONSTRAINT "PK_59577d335561e2a2a19beb2885e" PRIMARY KEY (id);


--
-- Name: subcategory PK_5ad0b82340b411f9463c8e9554d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory
    ADD CONSTRAINT "PK_5ad0b82340b411f9463c8e9554d" PRIMARY KEY (id);


--
-- Name: permission_roles_role PK_6307b540c85d8a7478af4e70349; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission_roles_role
    ADD CONSTRAINT "PK_6307b540c85d8a7478af4e70349" PRIMARY KEY ("permissionPermissionId", "roleRoleId");


--
-- Name: subject_categories_category PK_64396015fc343638326f277d42e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_categories_category
    ADD CONSTRAINT "PK_64396015fc343638326f277d42e" PRIMARY KEY ("subjectId", "categoryId");


--
-- Name: school PK_6af289a297533c116e251f90c08; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT "PK_6af289a297533c116e251f90c08" PRIMARY KEY (school_id);


--
-- Name: attendance PK_6faeaae2bb6960b5ca7728ac6c8; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT "PK_6faeaae2bb6960b5ca7728ac6c8" PRIMARY KEY (session_id, join_timestamp, leave_timestamp);


--
-- Name: assessment_xapi_room PK_70f65692c1c826674104aa6c983; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_room
    ADD CONSTRAINT "PK_70f65692c1c826674104aa6c983" PRIMARY KEY (room_id);


--
-- Name: user PK_758b8ce7c18b9d347461b30228d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "PK_758b8ce7c18b9d347461b30228d" PRIMARY KEY (user_id);


--
-- Name: school_programs_program PK_760837bfc79de77778724a916bf; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_programs_program
    ADD CONSTRAINT "PK_760837bfc79de77778724a916bf" PRIMARY KEY ("schoolSchoolId", "programId");


--
-- Name: assessment_xapi_teacher_comment PK_8420b9eb9ef17399d9677ab2329; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_teacher_comment
    ADD CONSTRAINT "PK_8420b9eb9ef17399d9677ab2329" PRIMARY KEY (room_id, teacher_id, student_id);


--
-- Name: school_membership PK_8460e14e1fbe5cea7ec60a282dc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_membership
    ADD CONSTRAINT "PK_8460e14e1fbe5cea7ec60a282dc" PRIMARY KEY (user_id, school_id);


--
-- Name: migrations PK_8c82d7f526340ab734260ea46be; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT "PK_8c82d7f526340ab734260ea46be" PRIMARY KEY (id);


--
-- Name: category PK_9c4e4a89e3674fc9f382d733f03; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "PK_9c4e4a89e3674fc9f382d733f03" PRIMARY KEY (id);


--
-- Name: organization_ownership PK_9e63a489464140b82179bdf5bec; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_ownership
    ADD CONSTRAINT "PK_9e63a489464140b82179bdf5bec" PRIMARY KEY (user_id, organization_id);


--
-- Name: permission PK_aaa6d61e22fb453965ae6157ce5; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission
    ADD CONSTRAINT "PK_aaa6d61e22fb453965ae6157ce5" PRIMARY KEY (permission_id);


--
-- Name: program_age_ranges_age_range PK_cbce3de8146f323e6868c21a76d; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_age_ranges_age_range
    ADD CONSTRAINT "PK_cbce3de8146f323e6868c21a76d" PRIMARY KEY ("programId", "ageRangeId");


--
-- Name: program_grades_grade PK_d49fc599349f4032da8735319d4; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_grades_grade
    ADD CONSTRAINT "PK_d49fc599349f4032da8735319d4" PRIMARY KEY ("programId", "gradeId");


--
-- Name: class_grades_grade PK_da95358bb7c50bd57a86e957a86; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_grades_grade
    ADD CONSTRAINT "PK_da95358bb7c50bd57a86e957a86" PRIMARY KEY ("classClassId", "gradeId");


--
-- Name: role PK_df46160e6aa79943b83c81e496e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "PK_df46160e6aa79943b83c81e496e" PRIMARY KEY (role_id);


--
-- Name: branding PK_e25f376c40ba766f4008a88bbc9; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branding
    ADD CONSTRAINT "PK_e25f376c40ba766f4008a88bbc9" PRIMARY KEY (id);


--
-- Name: school_classes_class PK_ed0b30678e2e3b3047dc598ccf6; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_classes_class
    ADD CONSTRAINT "PK_ed0b30678e2e3b3047dc598ccf6" PRIMARY KEY ("schoolSchoolId", "classClassId");


--
-- Name: organization PK_ed1251fa3856cd1a6c98d7bcaa3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT "PK_ed1251fa3856cd1a6c98d7bcaa3" PRIMARY KEY (organization_id);


--
-- Name: program_subjects_subject PK_ee45942daf534489df82f446502; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_subjects_subject
    ADD CONSTRAINT "PK_ee45942daf534489df82f446502" PRIMARY KEY ("programId", "subjectId");


--
-- Name: user_classes_studying_class PK_fa86db3cd04029d2cc4a08c9ce2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_classes_studying_class
    ADD CONSTRAINT "PK_fa86db3cd04029d2cc4a08c9ce2" PRIMARY KEY ("userUserId", "classClassId");


--
-- Name: category_subcategories_subcategory PK_fb62a8ad61e9b1c377e20b4d21e; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategories_subcategory
    ADD CONSTRAINT "PK_fb62a8ad61e9b1c377e20b4d21e" PRIMARY KEY ("categoryId", "subcategoryId");


--
-- Name: user REL_2af3e757ddd2c6ae0598b094b0; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "REL_2af3e757ddd2c6ae0598b094b0" UNIQUE ("myOrganizationOrganizationId");


--
-- Name: organization_ownership REL_af092fb11378f417fa5c47f367; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_ownership
    ADD CONSTRAINT "REL_af092fb11378f417fa5c47f367" UNIQUE (user_id);


--
-- Name: organization_ownership REL_f6a339c08dd0262ce0639091b7; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_ownership
    ADD CONSTRAINT "REL_f6a339c08dd0262ce0639091b7" UNIQUE (organization_id);


--
-- Name: branding UQ_76c80b06b6946bc95459a01918c; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branding
    ADD CONSTRAINT "UQ_76c80b06b6946bc95459a01918c" UNIQUE (organization_id);


--
-- Name: class UQ_8492419af3e16a19b030d49546f; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT "UQ_8492419af3e16a19b030d49546f" UNIQUE (class_name, "organizationOrganizationId");


--
-- Name: age_range UQ_afa8f5126d119a7a669752017b3; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.age_range
    ADD CONSTRAINT "UQ_afa8f5126d119a7a669752017b3" UNIQUE (low_value, high_value, low_value_unit, high_value_unit, organization_id);


--
-- Name: tmp_import tmp_import_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tmp_import
    ADD CONSTRAINT tmp_import_pkey PRIMARY KEY (id);


--
-- Name: IDX_02aaae111369b8d399a0c40cf7; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_02aaae111369b8d399a0c40cf7" ON public.class_grades_grade USING btree ("gradeId");


--
-- Name: IDX_051e21c8a1d95f59de130a110e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_051e21c8a1d95f59de130a110e" ON public.program_subjects_subject USING btree ("subjectId");


--
-- Name: IDX_0bedbcc8d5f9b9ec4979f51959; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_0bedbcc8d5f9b9ec4979f51959" ON public.attendance USING btree (user_id);


--
-- Name: IDX_1dcd296a909d0bcc15d86bec5f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_1dcd296a909d0bcc15d86bec5f" ON public.class_subjects_subject USING btree ("subjectId");


--
-- Name: IDX_239d4448a254314c575ebee4b1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_239d4448a254314c575ebee4b1" ON public.permission_roles_role USING btree ("permissionPermissionId");


--
-- Name: IDX_24e438cea0fd95cb8f2e33ea11; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_24e438cea0fd95cb8f2e33ea11" ON public.category_subcategories_subcategory USING btree ("categoryId");


--
-- Name: IDX_2e838cbe8e1ea1529e44545758; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_2e838cbe8e1ea1529e44545758" ON public.user_classes_teaching_class USING btree ("userUserId");


--
-- Name: IDX_3d4870570803ada96985442de1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_3d4870570803ada96985442de1" ON public.program_age_ranges_age_range USING btree ("programId");


--
-- Name: IDX_444600a32c9885b46939d304c1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_444600a32c9885b46939d304c1" ON public.school_classes_class USING btree ("classClassId");


--
-- Name: IDX_62e7f20e2c55a247829318c756; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_62e7f20e2c55a247829318c756" ON public.subject_categories_category USING btree ("categoryId");


--
-- Name: IDX_657918555e113a46de0e2932c1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_657918555e113a46de0e2932c1" ON public.class_subjects_subject USING btree ("classClassId");


--
-- Name: IDX_6bb7ea4e331c11a6a821e383b0; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_6bb7ea4e331c11a6a821e383b0" ON public.role_memberships_organization_membership USING btree ("organizationMembershipUserId", "organizationMembershipOrganizationId");


--
-- Name: IDX_6d02461da423605ef9ccc3512b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_6d02461da423605ef9ccc3512b" ON public.school_programs_program USING btree ("schoolSchoolId");


--
-- Name: IDX_6d31d313b7d9507824f0686a8e; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_6d31d313b7d9507824f0686a8e" ON public.class_age_ranges_age_range USING btree ("classClassId");


--
-- Name: IDX_6e6cf742a4c6845df0a2f866ad; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_6e6cf742a4c6845df0a2f866ad" ON public.class_programs_program USING btree ("classClassId");


--
-- Name: IDX_70b945b4098efe8b24112a4a7b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_70b945b4098efe8b24112a4a7b" ON public.class_grades_grade USING btree ("classClassId");


--
-- Name: IDX_717cd0804a1388fa0efd196903; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_717cd0804a1388fa0efd196903" ON public.role_school_memberships_school_membership USING btree ("roleRoleId");


--
-- Name: IDX_7e820f3d6344144d583e6101d4; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_7e820f3d6344144d583e6101d4" ON public.attendance USING btree (room_id);


--
-- Name: IDX_80d7479d3b77c2b1269bd91bb5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_80d7479d3b77c2b1269bd91bb5" ON public.program_grades_grade USING btree ("gradeId");


--
-- Name: IDX_85f1569ff88406212e23f628db; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_85f1569ff88406212e23f628db" ON public.category_subcategories_subcategory USING btree ("subcategoryId");


--
-- Name: IDX_95dd6c21c5a4818ccbd5549979; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_95dd6c21c5a4818ccbd5549979" ON public.subject_categories_category USING btree ("subjectId");


--
-- Name: IDX_9f897b46976c7c9183231d517b; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_9f897b46976c7c9183231d517b" ON public.school_classes_class USING btree ("schoolSchoolId");


--
-- Name: IDX_a58b3085a8ec33fdeb2162d80a; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_a58b3085a8ec33fdeb2162d80a" ON public.school_programs_program USING btree ("programId");


--
-- Name: IDX_ab989978713e6b069ffaebc3e5; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_ab989978713e6b069ffaebc3e5" ON public.user_classes_studying_class USING btree ("classClassId");


--
-- Name: IDX_aebc225830a42f04f6eb63f378; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_aebc225830a42f04f6eb63f378" ON public.class_age_ranges_age_range USING btree ("ageRangeId");


--
-- Name: IDX_be11f6d4e92b35e388d77a5890; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_be11f6d4e92b35e388d77a5890" ON public.program_grades_grade USING btree ("programId");


--
-- Name: IDX_be85e983b2d960972cf859013d; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_be85e983b2d960972cf859013d" ON public.program_subjects_subject USING btree ("programId");


--
-- Name: IDX_d1ccc2d2e2f6e8632e60bd2f72; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_d1ccc2d2e2f6e8632e60bd2f72" ON public.program_age_ranges_age_range USING btree ("ageRangeId");


--
-- Name: IDX_d64a77ccb60c7223cdb7503af2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_d64a77ccb60c7223cdb7503af2" ON public.role_memberships_organization_membership USING btree ("roleRoleId");


--
-- Name: IDX_d7559cc316aba6912fed713ea9; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_d7559cc316aba6912fed713ea9" ON public.role_school_memberships_school_membership USING btree ("schoolMembershipUserId", "schoolMembershipSchoolId");


--
-- Name: IDX_e5af799b7d51ace3516f741fba; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_e5af799b7d51ace3516f741fba" ON public.user_classes_studying_class USING btree ("userUserId");


--
-- Name: IDX_e885f53dfa5c2d93ce87227c2f; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_e885f53dfa5c2d93ce87227c2f" ON public.user_classes_teaching_class USING btree ("classClassId");


--
-- Name: IDX_ead8ac61d0fb420cde0ff36c82; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_ead8ac61d0fb420cde0ff36c82" ON public.permission_roles_role USING btree ("roleRoleId");


--
-- Name: IDX_f4bcd89eaf5f669193ac33c160; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "IDX_f4bcd89eaf5f669193ac33c160" ON public.class_programs_program USING btree ("programId");


--
-- Name: class_grades_grade FK_02aaae111369b8d399a0c40cf7f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_grades_grade
    ADD CONSTRAINT "FK_02aaae111369b8d399a0c40cf7f" FOREIGN KEY ("gradeId") REFERENCES public.grade(id) ON DELETE CASCADE;


--
-- Name: subject FK_03606bedc87e4c41f2c3e58ae22; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT "FK_03606bedc87e4c41f2c3e58ae22" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: program_subjects_subject FK_051e21c8a1d95f59de130a110e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_subjects_subject
    ADD CONSTRAINT "FK_051e21c8a1d95f59de130a110e1" FOREIGN KEY ("subjectId") REFERENCES public.subject(id) ON DELETE CASCADE;


--
-- Name: organization_membership FK_0577a4312cdcded9c8bd906365f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_membership
    ADD CONSTRAINT "FK_0577a4312cdcded9c8bd906365f" FOREIGN KEY ("organizationOrganizationId") REFERENCES public.organization(organization_id);


--
-- Name: grade FK_132391d477a6df3fa86d3ecbe73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT "FK_132391d477a6df3fa86d3ecbe73" FOREIGN KEY (progress_to_grade_id) REFERENCES public.grade(id);


--
-- Name: class_subjects_subject FK_1dcd296a909d0bcc15d86bec5fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_subjects_subject
    ADD CONSTRAINT "FK_1dcd296a909d0bcc15d86bec5fa" FOREIGN KEY ("subjectId") REFERENCES public.subject(id) ON DELETE CASCADE;


--
-- Name: subcategory FK_1dfd6df5b40adc5e8783fb3ffc9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory
    ADD CONSTRAINT "FK_1dfd6df5b40adc5e8783fb3ffc9" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: permission_roles_role FK_239d4448a254314c575ebee4b16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission_roles_role
    ADD CONSTRAINT "FK_239d4448a254314c575ebee4b16" FOREIGN KEY ("permissionPermissionId") REFERENCES public.permission(permission_id) ON DELETE CASCADE;


--
-- Name: category_subcategories_subcategory FK_24e438cea0fd95cb8f2e33ea118; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategories_subcategory
    ADD CONSTRAINT "FK_24e438cea0fd95cb8f2e33ea118" FOREIGN KEY ("categoryId") REFERENCES public.category(id) ON DELETE CASCADE;


--
-- Name: grade FK_266262b4fb70bc21d0609ab41f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT "FK_266262b4fb70bc21d0609ab41f8" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: assessment_xapi_answer FK_2af34c7a831bccebfd64a536002; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_answer
    ADD CONSTRAINT "FK_2af34c7a831bccebfd64a536002" FOREIGN KEY ("userContentScoreRoomId", "userContentScoreStudentId", "userContentScoreContentKey") REFERENCES public.assessment_xapi_user_content_score(room_id, student_id, content_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user FK_2af3e757ddd2c6ae0598b094b0b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT "FK_2af3e757ddd2c6ae0598b094b0b" FOREIGN KEY ("myOrganizationOrganizationId") REFERENCES public.organization(organization_id);


--
-- Name: assessment_xapi_teacher_comment FK_2da8904c6ddc72e3b8db457816d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_teacher_comment
    ADD CONSTRAINT "FK_2da8904c6ddc72e3b8db457816d" FOREIGN KEY ("roomRoomId") REFERENCES public.assessment_xapi_room(room_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_classes_teaching_class FK_2e838cbe8e1ea1529e44545758f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_classes_teaching_class
    ADD CONSTRAINT "FK_2e838cbe8e1ea1529e44545758f" FOREIGN KEY ("userUserId") REFERENCES public."user"(user_id) ON DELETE CASCADE;


--
-- Name: program FK_2ff4063d818db1c3d9021431636; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program
    ADD CONSTRAINT "FK_2ff4063d818db1c3d9021431636" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: branding_image FK_30cc1cf9f61819c8b229e2ac51f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branding_image
    ADD CONSTRAINT "FK_30cc1cf9f61819c8b229e2ac51f" FOREIGN KEY (branding_id) REFERENCES public.branding(id) ON DELETE CASCADE;


--
-- Name: program_age_ranges_age_range FK_3d4870570803ada96985442de1a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_age_ranges_age_range
    ADD CONSTRAINT "FK_3d4870570803ada96985442de1a" FOREIGN KEY ("programId") REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: school_classes_class FK_444600a32c9885b46939d304c17; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_classes_class
    ADD CONSTRAINT "FK_444600a32c9885b46939d304c17" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: subject_categories_category FK_62e7f20e2c55a247829318c756b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_categories_category
    ADD CONSTRAINT "FK_62e7f20e2c55a247829318c756b" FOREIGN KEY ("categoryId") REFERENCES public.category(id) ON DELETE CASCADE;


--
-- Name: class_subjects_subject FK_657918555e113a46de0e2932c14; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_subjects_subject
    ADD CONSTRAINT "FK_657918555e113a46de0e2932c14" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: role_memberships_organization_membership FK_6bb7ea4e331c11a6a821e383b00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_memberships_organization_membership
    ADD CONSTRAINT "FK_6bb7ea4e331c11a6a821e383b00" FOREIGN KEY ("organizationMembershipUserId", "organizationMembershipOrganizationId") REFERENCES public.organization_membership(user_id, organization_id) ON DELETE CASCADE;


--
-- Name: school_programs_program FK_6d02461da423605ef9ccc3512bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_programs_program
    ADD CONSTRAINT "FK_6d02461da423605ef9ccc3512bd" FOREIGN KEY ("schoolSchoolId") REFERENCES public.school(school_id) ON DELETE CASCADE;


--
-- Name: class_age_ranges_age_range FK_6d31d313b7d9507824f0686a8eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_age_ranges_age_range
    ADD CONSTRAINT "FK_6d31d313b7d9507824f0686a8eb" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: class_programs_program FK_6e6cf742a4c6845df0a2f866ade; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_programs_program
    ADD CONSTRAINT "FK_6e6cf742a4c6845df0a2f866ade" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: class_grades_grade FK_70b945b4098efe8b24112a4a7bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_grades_grade
    ADD CONSTRAINT "FK_70b945b4098efe8b24112a4a7bf" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: role_school_memberships_school_membership FK_717cd0804a1388fa0efd1969036; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_school_memberships_school_membership
    ADD CONSTRAINT "FK_717cd0804a1388fa0efd1969036" FOREIGN KEY ("roleRoleId") REFERENCES public.role(role_id) ON DELETE CASCADE;


--
-- Name: branding FK_76c80b06b6946bc95459a01918c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.branding
    ADD CONSTRAINT "FK_76c80b06b6946bc95459a01918c" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: program_grades_grade FK_80d7479d3b77c2b1269bd91bb56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_grades_grade
    ADD CONSTRAINT "FK_80d7479d3b77c2b1269bd91bb56" FOREIGN KEY ("gradeId") REFERENCES public.grade(id) ON DELETE CASCADE;


--
-- Name: category_subcategories_subcategory FK_85f1569ff88406212e23f628dbf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_subcategories_subcategory
    ADD CONSTRAINT "FK_85f1569ff88406212e23f628dbf" FOREIGN KEY ("subcategoryId") REFERENCES public.subcategory(id) ON DELETE CASCADE;


--
-- Name: subject_categories_category FK_95dd6c21c5a4818ccbd55499794; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subject_categories_category
    ADD CONSTRAINT "FK_95dd6c21c5a4818ccbd55499794" FOREIGN KEY ("subjectId") REFERENCES public.subject(id) ON DELETE CASCADE;


--
-- Name: school_classes_class FK_9f897b46976c7c9183231d517b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_classes_class
    ADD CONSTRAINT "FK_9f897b46976c7c9183231d517b9" FOREIGN KEY ("schoolSchoolId") REFERENCES public.school(school_id) ON DELETE CASCADE;


--
-- Name: school_programs_program FK_a58b3085a8ec33fdeb2162d80a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_programs_program
    ADD CONSTRAINT "FK_a58b3085a8ec33fdeb2162d80a8" FOREIGN KEY ("programId") REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: user_classes_studying_class FK_ab989978713e6b069ffaebc3e54; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_classes_studying_class
    ADD CONSTRAINT "FK_ab989978713e6b069ffaebc3e54" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: role FK_aeb6fd04b2c209ace73f04d6428; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT "FK_aeb6fd04b2c209ace73f04d6428" FOREIGN KEY ("organizationOrganizationId") REFERENCES public.organization(organization_id);


--
-- Name: class_age_ranges_age_range FK_aebc225830a42f04f6eb63f378a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_age_ranges_age_range
    ADD CONSTRAINT "FK_aebc225830a42f04f6eb63f378a" FOREIGN KEY ("ageRangeId") REFERENCES public.age_range(id) ON DELETE CASCADE;


--
-- Name: organization_ownership FK_af092fb11378f417fa5c47f3671; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_ownership
    ADD CONSTRAINT "FK_af092fb11378f417fa5c47f3671" FOREIGN KEY (user_id) REFERENCES public."user"(user_id);


--
-- Name: assessment_xapi_user_content_score FK_b924878d94c06b34ee054c330e1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_user_content_score
    ADD CONSTRAINT "FK_b924878d94c06b34ee054c330e1" FOREIGN KEY ("roomRoomId") REFERENCES public.assessment_xapi_room(room_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: program_grades_grade FK_be11f6d4e92b35e388d77a58906; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_grades_grade
    ADD CONSTRAINT "FK_be11f6d4e92b35e388d77a58906" FOREIGN KEY ("programId") REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: program_subjects_subject FK_be85e983b2d960972cf859013d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_subjects_subject
    ADD CONSTRAINT "FK_be85e983b2d960972cf859013d7" FOREIGN KEY ("programId") REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: assessment_xapi_teacher_score FK_c864a929175036db56436609b26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assessment_xapi_teacher_score
    ADD CONSTRAINT "FK_c864a929175036db56436609b26" FOREIGN KEY ("userContentScoreRoomId", "userContentScoreStudentId", "userContentScoreContentKey") REFERENCES public.assessment_xapi_user_content_score(room_id, student_id, content_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: program_age_ranges_age_range FK_d1ccc2d2e2f6e8632e60bd2f72d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.program_age_ranges_age_range
    ADD CONSTRAINT "FK_d1ccc2d2e2f6e8632e60bd2f72d" FOREIGN KEY ("ageRangeId") REFERENCES public.age_range(id) ON DELETE CASCADE;


--
-- Name: category FK_d5594fcb9d4210bcad13098173a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT "FK_d5594fcb9d4210bcad13098173a" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: role_memberships_organization_membership FK_d64a77ccb60c7223cdb7503af2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_memberships_organization_membership
    ADD CONSTRAINT "FK_d64a77ccb60c7223cdb7503af2a" FOREIGN KEY ("roleRoleId") REFERENCES public.role(role_id) ON DELETE CASCADE;


--
-- Name: role_school_memberships_school_membership FK_d7559cc316aba6912fed713ea90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_school_memberships_school_membership
    ADD CONSTRAINT "FK_d7559cc316aba6912fed713ea90" FOREIGN KEY ("schoolMembershipUserId", "schoolMembershipSchoolId") REFERENCES public.school_membership(user_id, school_id) ON DELETE CASCADE;


--
-- Name: user_classes_studying_class FK_e5af799b7d51ace3516f741fba3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_classes_studying_class
    ADD CONSTRAINT "FK_e5af799b7d51ace3516f741fba3" FOREIGN KEY ("userUserId") REFERENCES public."user"(user_id) ON DELETE CASCADE;


--
-- Name: grade FK_e6757f9fe2318591744b44224e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT "FK_e6757f9fe2318591744b44224e8" FOREIGN KEY (progress_from_grade_id) REFERENCES public.grade(id);


--
-- Name: user_classes_teaching_class FK_e885f53dfa5c2d93ce87227c2fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_classes_teaching_class
    ADD CONSTRAINT "FK_e885f53dfa5c2d93ce87227c2fa" FOREIGN KEY ("classClassId") REFERENCES public.class(class_id) ON DELETE CASCADE;


--
-- Name: permission_roles_role FK_ead8ac61d0fb420cde0ff36c82e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permission_roles_role
    ADD CONSTRAINT "FK_ead8ac61d0fb420cde0ff36c82e" FOREIGN KEY ("roleRoleId") REFERENCES public.role(role_id) ON DELETE CASCADE;


--
-- Name: school_membership FK_eed5395da4e121b5e0d9b06bb01; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_membership
    ADD CONSTRAINT "FK_eed5395da4e121b5e0d9b06bb01" FOREIGN KEY ("schoolSchoolId") REFERENCES public.school(school_id);


--
-- Name: age_range FK_f03452017bb25d2e5481b1c1012; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.age_range
    ADD CONSTRAINT "FK_f03452017bb25d2e5481b1c1012" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: school_membership FK_f0984fa1b551651e47170ff21b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school_membership
    ADD CONSTRAINT "FK_f0984fa1b551651e47170ff21b3" FOREIGN KEY ("userUserId") REFERENCES public."user"(user_id);


--
-- Name: class_programs_program FK_f4bcd89eaf5f669193ac33c160c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class_programs_program
    ADD CONSTRAINT "FK_f4bcd89eaf5f669193ac33c160c" FOREIGN KEY ("programId") REFERENCES public.program(id) ON DELETE CASCADE;


--
-- Name: organization_ownership FK_f6a339c08dd0262ce0639091b75; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_ownership
    ADD CONSTRAINT "FK_f6a339c08dd0262ce0639091b75" FOREIGN KEY (organization_id) REFERENCES public.organization(organization_id);


--
-- Name: class FK_f8ff2ae8e51e3880520d984e81f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT "FK_f8ff2ae8e51e3880520d984e81f" FOREIGN KEY ("organizationOrganizationId") REFERENCES public.organization(organization_id);


--
-- Name: organization FK_f9e1430871bf8b1ca42af4072a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT "FK_f9e1430871bf8b1ca42af4072a6" FOREIGN KEY ("primaryContactUserId") REFERENCES public."user"(user_id);


--
-- Name: school FK_fc66ca5ea58b906c3d8757c7c08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT "FK_fc66ca5ea58b906c3d8757c7c08" FOREIGN KEY ("organizationOrganizationId") REFERENCES public.organization(organization_id);


--
-- Name: organization_membership FK_fecc54a367461fb4fdddcb452ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_membership
    ADD CONSTRAINT "FK_fecc54a367461fb4fdddcb452ce" FOREIGN KEY ("userUserId") REFERENCES public."user"(user_id);


--
-- PostgreSQL database dump complete
--

