--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.9
-- Dumped by pg_dump version 9.1.9
-- Started on 2013-05-22 23:22:16 BST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 11 (class 2615 OID 42045)
-- Name: IPYME_FINAL; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "IPYME_FINAL";


ALTER SCHEMA "IPYME_FINAL" OWNER TO postgres;

SET search_path = "IPYME_FINAL", pg_catalog;

--
-- TOC entry 751 (class 1247 OID 42645)
-- Dependencies: 11 238
-- Name: attribute_value_related; Type: TYPE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TYPE attribute_value_related AS (
	pca_id bigint,
	pca_product_category bigint,
	pca_attribute text,
	pav_product bigint,
	pav_product_category_attribute bigint,
	pav_value text
);


ALTER TYPE "IPYME_FINAL".attribute_value_related OWNER TO postgres;

--
-- TOC entry 747 (class 1247 OID 42633)
-- Dependencies: 11 236
-- Name: get_product; Type: TYPE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TYPE get_product AS (
	p_id bigint,
	p_ref character varying(45),
	p_description character varying(255),
	p_long_description character varying(255),
	p_category bigint,
	p_image_path text,
	p_category_name text,
	p_price numeric(8,3),
	c_name character varying(100)
);


ALTER TYPE "IPYME_FINAL".get_product OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 42599)
-- Dependencies: 754 11
-- Name: delete_customer(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION delete_customer(p_c_id bigint) RETURNS TABLE(c_id bigint, c_customer_name character varying, c_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
v_customer "IPYME_FINAL"."CUSTOMER"%ROWTYPE;
v_invoice_entity "IPYME_FINAL"."INVOICE_ENTITY"%ROWTYPE;
BEGIN
	--
	SELECT *
	INTO v_customer
	FROM "IPYME_FINAL"."CUSTOMER" C
	WHERE C.c_id = p_c_id;
	--
	IF FOUND THEN
		--
		DELETE FROM "IPYME_FINAL"."CUSTOMER" C
		WHERE C.c_id = v_customer.c_id;
		--
		SELECT *
		INTO v_invoice_entity
		FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
		WHERE IE.ie_id = v_customer.c_invoice_entity;
		--
	ELSE
		RETURN;
	END IF;
	--
	RAISE INFO '% - %',p_c_id,v_customer;
	--
	IF FOUND THEN
		--
		BEGIN
			--
			DELETE FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
			WHERE IE.ie_id = v_invoice_entity.ie_id;
			--
			EXCEPTION
				WHEN OTHERS THEN
					NULL;
			--
		END;
		--
	END IF;
	--
	--
	RETURN QUERY SELECT v_customer.c_id
									, v_customer.c_customer_name
									, v_customer.c_invoice_entity
									, v_invoice_entity.ie_id
									, v_invoice_entity.ie_legal_id
									, v_invoice_entity.ie_invoice_name;
	--
	EXCEPTION 
		WHEN OTHERS THEN
			RETURN;
	--
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".delete_customer(p_c_id bigint) OWNER TO postgres;

SET default_with_oids = false;

--
-- TOC entry 179 (class 1259 OID 42095)
-- Dependencies: 11
-- Name: PRODUCT; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PRODUCT" (
    p_id bigint NOT NULL,
    p_ref character varying(45) NOT NULL,
    p_description character varying(255),
    p_long_description character varying(255),
    p_category bigint,
    p_image_path text
);


ALTER TABLE "IPYME_FINAL"."PRODUCT" OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 42600)
-- Dependencies: 11 754 617
-- Name: delete_product(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION delete_product(p_p_id bigint) RETURNS SETOF "PRODUCT"
    LANGUAGE plpgsql
    AS $$
DECLARE
v_row_product "IPYME_FINAL"."PRODUCT"%ROWTYPE;
BEGIN
	--
	SELECT P.p_id
				,P.p_ref
				,P.p_description
				,P.p_long_description
				,P.p_weight
				,P.p_size
				,P.p_category
				INTO v_row_product
	FROM "IPYME_FINAL"."PRODUCT" P
	WHERE P.p_id = p_p_id;
	--
	IF NOT FOUND THEN
		--
		RETURN;
		--
	ELSE
		--
		DELETE FROM "IPYME_FINAL"."PRODUCT" P
		WHERE P.p_id = p_p_id;
		--
		RETURN QUERY SELECT v_row_product.p_id 
											,v_row_product.p_ref
											,v_row_product.p_description
											,v_row_product.p_long_description
											,v_row_product.p_weight
											,v_row_product.p_size
											,v_row_product.p_category;
		--
	END IF;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".delete_product(p_p_id bigint) OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 42077)
-- Dependencies: 11
-- Name: PRODUCT_CATEGORY_ATTRIBUTE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PRODUCT_CATEGORY_ATTRIBUTE" (
    pca_id bigint NOT NULL,
    pca_product_category bigint NOT NULL,
    pca_attribute text NOT NULL
);


ALTER TABLE "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 42613)
-- Dependencies: 754 11 612
-- Name: delete_product_category_attribute(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION delete_product_category_attribute(p_pca_id bigint) RETURNS SETOF "PRODUCT_CATEGORY_ATTRIBUTE"
    LANGUAGE plpgsql
    AS $$
DECLARE
v_row_product_category_attribute "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE"%ROWTYPE;
BEGIN
	--
	SELECT *
	INTO v_row_product_category_attribute
	FROM "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" PCA
	WHERE PCA.pca_id = p_pca_id;
	--
	IF NOT FOUND THEN
		--
		RETURN;
		--
	ELSE
		--
		DELETE FROM "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" PCA
		WHERE PCA.pca_id = p_pca_id;
		--
		RETURN QUERY SELECT v_row_product_category_attribute.*;
		--
	END IF;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".delete_product_category_attribute(p_pca_id bigint) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 42601)
-- Dependencies: 754 11
-- Name: delete_provider(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION delete_provider(p_p_id bigint) RETURNS TABLE(p_id bigint, p_provider_name character varying, p_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
v_provider "IPYME_FINAL"."PROVIDER"%ROWTYPE;
v_invoice_entity "IPYME_FINAL"."INVOICE_ENTITY"%ROWTYPE;
BEGIN
	--
	SELECT *
	INTO v_provider
	FROM "IPYME_FINAL"."PROVIDER" P
	WHERE P.p_id = p_p_id;
	--
	IF FOUND THEN
		--
		DELETE FROM "IPYME_FINAL"."PROVIDER" P
		WHERE p.p_id = v_provider.p_id;
		--
		SELECT *
		INTO v_invoice_entity
		FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
		WHERE IE.ie_id = v_provider.p_invoice_entity;
		--
	ELSE
		RETURN;
	END IF;
	--
	RAISE INFO '% - %',p_p_id,v_provider;
	--
	IF FOUND THEN
		--
		BEGIN
			--
			DELETE FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
			WHERE IE.ie_id = v_invoice_entity.ie_id;
			--
			EXCEPTION
				WHEN OTHERS THEN
					NULL;
			--
		END;
		--
	END IF;
	--
	--
	RETURN QUERY SELECT v_provider.p_id
									, v_provider.p_provider_name
									, v_provider.p_invoice_entity
									, v_invoice_entity.ie_id
									, v_invoice_entity.ie_legal_id
									, v_invoice_entity.ie_invoice_name;
	--
	EXCEPTION 
		WHEN OTHERS THEN
			RETURN;
	--
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".delete_provider(p_p_id bigint) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 42649)
-- Dependencies: 751 754 11
-- Name: get_all_available_attribute_value_related(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_all_available_attribute_value_related(p_pc_id bigint) RETURNS SETOF attribute_value_related
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	RETURN QUERY 	SELECT * 
								FROM "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" PCA
								INNER JOIN "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE" PAV
								ON PAV.pav_product_category_attribute = PCA.pca_id
								WHERE PCA.pca_product_category in (select PC1.pc_id 
																									from "IPYME_FINAL"."PRODUCT_CATEGORY" PC1
																									,(select pc_path
																									from "IPYME_FINAL"."PRODUCT_CATEGORY" 
																									where pc_id = p_pc_id) PC2
																									where substr(PC1.pc_path,0,length(PC2.pc_path)+1) = PC2.pc_path);
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_all_available_attribute_value_related(p_pc_id bigint) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 42646)
-- Dependencies: 754 11 751
-- Name: get_attribute_value_related(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_attribute_value_related(p_pc_id bigint) RETURNS SETOF attribute_value_related
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	RETURN QUERY select * from "IPYME_FINAL".get_product_attribute_related(p_pc_id)
					left join "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"
					on pav_product_category_attribute = pca_id;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_attribute_value_related(p_pc_id bigint) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 42602)
-- Dependencies: 11 754
-- Name: get_customer(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_customer(p_c_id bigint) RETURNS TABLE(c_id bigint, c_customer_name character varying, c_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
		RETURN QUERY select c.c_id
			, c.c_customer_name
			, c.c_invoice_entity
			, ie.ie_id
			, ie.ie_legal_id
			, ie.ie_invoice_name 
		from "IPYME_FINAL"."CUSTOMER" c
			,"IPYME_FINAL"."INVOICE_ENTITY" ie
		WHERE c.c_invoice_entity=ie.ie_id
		and ((c.c_id=p_c_id) or (p_c_id is null));
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_customer(p_c_id bigint) OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 42180)
-- Dependencies: 11
-- Name: PRICES; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PRICES" (
    p_id bigint NOT NULL,
    p_date timestamp with time zone,
    p_product bigint,
    p_status integer,
    p_currency integer,
    p_price numeric(8,3)
);


ALTER TABLE "IPYME_FINAL"."PRICES" OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 42637)
-- Dependencies: 642 11 754
-- Name: get_price_by_product(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_price_by_product(p_p_id bigint) RETURNS SETOF "PRICES"
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	IF p_p_id IS NULL THEN
		--
		RETURN;
		--
	ELSE
		--
		RETURN QUERY SELECT * 
		FROM "IPYME_FINAL"."PRICES" PR
		WHERE PR.p_product = p_p_id
		AND PR.p_status = 1;
		--
	END IF;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_price_by_product(p_p_id bigint) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 42635)
-- Dependencies: 754 11 747
-- Name: get_product(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product(p_p_id bigint) RETURNS SETOF get_product
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	RETURN QUERY SELECT P.p_id
											,P.p_ref
											,P.p_description
											,P.p_long_description
											,P.p_category
											,P.p_image_path
											,substr(PC.pc_path,length(PC.pc_path)-strpos(reverse(PC.pc_path),' > ')+2) AS p_category_name
											,PR.p_price
											,C.c_name
								FROM "IPYME_FINAL"."PRODUCT" P
								JOIN "IPYME_FINAL"."PRODUCT_CATEGORY" PC
								ON P.p_category = PC.pc_id
								LEFT JOIN "IPYME_FINAL"."PRICES" PR
								ON PR.p_product = P.p_id and PR.p_status = 1
								LEFT JOIN "IPYME_FINAL"."CURRENCY" C
								ON PR.p_currency = C.c_id
								WHERE P.p_id = p_p_id
									OR p_p_id IS NULL
								;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product(p_p_id bigint) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 42615)
-- Dependencies: 754 612 11
-- Name: get_product_attribute_related(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product_attribute_related(p_pc_id bigint) RETURNS SETOF "PRODUCT_CATEGORY_ATTRIBUTE"
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	RETURN QUERY select PCA.* from "IPYME_FINAL".get_product_category_related(p_pc_id) PC
							join "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" PCA
							ON pc_id=pca_product_category
							order by pca_attribute;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product_attribute_related(p_pc_id bigint) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 42656)
-- Dependencies: 754 11 747
-- Name: get_product_by_attribute_value(text); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product_by_attribute_value(p_category_attribute_id_and_value text) RETURNS SETOF get_product
    LANGUAGE plpgsql
    AS $$
DECLARE
v_a_attribute_id_and_attribute_value TEXT[];
v_attributes_count BIGINT;
BEGIN
	--
	SELECT COUNT(*) AS attribute_count
	INTO v_attributes_count
	FROM (SELECT PAV.pav_product_category_attribute
				FROM "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"	PAV
				WHERE PAV.pav_product_category_attribute::TEXT||'%^%'||PAV.pav_value = ANY (string_to_array(p_category_attribute_id_and_value, '~^~')::TEXT[])
				GROUP BY PAV.pav_product_category_attribute) AC;
	--
	-- p_category_attribute_id_and_value FORMAT: ATTR_ID1%^%ATTR_VALUE1~^~ATTR_ID2%^%ATTR_VALUE2~^~ATTR_ID3%^%ATTR_VALUE3...    
	-- EXAMPLE: 20%^%I7~^~15%^%4
	--
	v_a_attribute_id_and_attribute_value := string_to_array(p_category_attribute_id_and_value, '~^~')::TEXT[];
	--
	RETURN QUERY 	SELECT P.p_id
											,P.p_ref
											,P.p_description
											,P.p_long_description
											,P.p_category
											,P.p_image_path
											,substr(PC.pc_path,length(PC.pc_path)-strpos(reverse(PC.pc_path),' > ')+2) AS p_category_name
											,PR.p_price
											,C.c_name 
								FROM "IPYME_FINAL"."PRODUCT" P
								INNER JOIN "IPYME_FINAL"."PRODUCT_CATEGORY" PC
								ON P.p_category = PC.pc_id
								INNER JOIN (SELECT PAV2.pav_product, count(*) AS times_found
														FROM "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"	PAV2
														WHERE PAV2.pav_product_category_attribute::TEXT||'%^%'||PAV2.pav_value = ANY (v_a_attribute_id_and_attribute_value)
														group by PAV2.pav_product) PAV
								ON PAV.pav_product = P.p_id
								LEFT JOIN "IPYME_FINAL"."PRICES" PR
								ON PR.p_product = P.p_id and PR.p_status = 1
								LEFT JOIN "IPYME_FINAL"."CURRENCY" C
								ON PR.p_currency = C.c_id
								WHERE PAV.times_found = v_attributes_count
								;								
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product_by_attribute_value(p_category_attribute_id_and_value text) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 42634)
-- Dependencies: 11 754 747
-- Name: get_product_by_category(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product_by_category(p_p_category bigint) RETURNS SETOF get_product
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	RETURN QUERY SELECT distinct P.p_id
											,P.p_ref
											,P.p_description
											,P.p_long_description
											,P.p_category
											,P.p_image_path
											,PC3.p_category_name
											,PR.p_price
											,C.c_name
								FROM "IPYME_FINAL"."PRODUCT" P
								INNER JOIN (select PC1.pc_id 
														,substr(PC1.pc_path,length(PC1.pc_path)-strpos(reverse(PC1.pc_path),' > ')+2) as p_category_name
														from "IPYME_FINAL"."PRODUCT_CATEGORY" PC1
													,(select length(pc_path) as pc_path_length 
																	,pc_path 
																	from "IPYME_FINAL"."PRODUCT_CATEGORY" 
																	where pc_id=p_p_category
																	OR p_p_category = -1
																	) PC2
													WHERE SUBSTR(PC1.pc_path,0,PC2.pc_path_length+1) = PC2.pc_path) PC3
								ON P.p_category = PC3.pc_id
								LEFT JOIN "IPYME_FINAL"."PRICES" PR
								ON PR.p_product = P.p_id and PR.p_status = 1
								LEFT JOIN "IPYME_FINAL"."CURRENCY" C
								ON PR.p_currency = C.c_id;								
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product_by_category(p_p_category bigint) OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 42064)
-- Dependencies: 11
-- Name: PRODUCT_CATEGORY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PRODUCT_CATEGORY" (
    pc_id bigint NOT NULL,
    pc_tax_rate numeric(8,3),
    pc_description text,
    pc_path text
);


ALTER TABLE "IPYME_FINAL"."PRODUCT_CATEGORY" OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 42609)
-- Dependencies: 607 11 754
-- Name: get_product_category(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product_category(p_pc_id bigint) RETURNS SETOF "PRODUCT_CATEGORY"
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
		RETURN QUERY select PC.pc_id
											, PC.pc_tax_rate
											, PC.pc_description
											, PC.pc_path
		from "IPYME_FINAL"."PRODUCT_CATEGORY" PC
		WHERE ((PC.pc_id = p_pc_id) or (p_pc_id is null))
		ORDER BY PC.pc_path;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product_category(p_pc_id bigint) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 42611)
-- Dependencies: 11 612 754
-- Name: get_product_category_attribute(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product_category_attribute(p_pca_product_category bigint) RETURNS SETOF "PRODUCT_CATEGORY_ATTRIBUTE"
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
	RETURN QUERY 	SELECT *
								FROM "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE"
								WHERE pca_product_category = p_pca_product_category;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product_category_attribute(p_pca_product_category bigint) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 42614)
-- Dependencies: 607 11 754
-- Name: get_product_category_related(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_product_category_related(p_pc_id bigint) RETURNS SETOF "PRODUCT_CATEGORY"
    LANGUAGE plpgsql
    AS $$
DECLARE
a_pc_id BIGINT[];
v_pc_id BIGINT;
v_pc_path text;
BEGIN
	--
	SELECT pc_id, pc_path
	INTO v_pc_id,v_pc_path
	FROM "IPYME_FINAL"."PRODUCT_CATEGORY"
	WHERE pc_id = p_pc_id;
	--
	LOOP		
		--
		IF FOUND THEN
			a_pc_id := a_pc_id || v_pc_id;
		ELSE
			EXIT;
		END IF;
		--
		v_pc_path := substr(v_pc_path, 0,length(v_pc_path)-strpos(reverse(v_pc_path),' > ')-1);
		--
		IF LENGTH(v_pc_path) < 4 THEN
				EXIT;
		END IF;
		--
		SELECT pc_id, pc_path
		INTO v_pc_id, v_pc_path
		FROM "IPYME_FINAL"."PRODUCT_CATEGORY"
		WHERE pc_path = v_pc_path;
		--
	END LOOP;
	--
	RETURN QUERY SELECT *
							FROM "IPYME_FINAL"."PRODUCT_CATEGORY"
							WHERE pc_id = ANY (a_pc_id);
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_product_category_related(p_pc_id bigint) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 42604)
-- Dependencies: 11 754
-- Name: get_provider(bigint); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION get_provider(p_p_id bigint) RETURNS TABLE(p_id bigint, p_provider_name character varying, p_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	--
		RETURN QUERY select p.p_id
			, p.p_provider_name
			, p.p_invoice_entity
			, ie.ie_id
			, ie.ie_legal_id
			, ie.ie_invoice_name 
		from "IPYME_FINAL"."PROVIDER" p
			,"IPYME_FINAL"."INVOICE_ENTITY" ie
		WHERE p.p_invoice_entity=ie.ie_id
		and ((p.p_id=p_p_id) or (p_p_id is null));
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".get_provider(p_p_id bigint) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 42605)
-- Dependencies: 754 11
-- Name: set_customer(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_customer(p_c_id bigint, p_c_customer_name character varying, p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying) RETURNS TABLE(c_id bigint, c_customer_name character varying, c_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
DECLARE
v_c_id BIGINT;
v_ie_id BIGINT;
v_create_customer BOOLEAN;
v_create_invoice_entity BOOLEAN;
BEGIN
	--
	v_create_invoice_entity := TRUE;
	--
	--
	SELECT IE.IE_ID
	INTO v_ie_id
	FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
	WHERE IE.IE_ID = p_ie_id
	OR IE.IE_LEGAL_ID = p_ie_legal_id;
	--
	IF FOUND THEN
		v_create_invoice_entity := FALSE;
	END IF;
	--
	IF (v_create_invoice_entity = TRUE) THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."INVOICE_ENTITY_ie_id_seq"') INTO v_ie_id ;
		INSERT INTO "IPYME_FINAL"."INVOICE_ENTITY" (ie_id
							, ie_legal_id
							, ie_invoice_name)
						VALUES(v_ie_id
							, p_ie_legal_id
							, p_ie_invoice_name);
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."INVOICE_ENTITY" 
		SET 	ie_legal_id = p_ie_legal_id
			, ie_invoice_name = p_ie_invoice_name
		WHERE ie_id = v_ie_id;
		--
	END IF;
	--
	--
	v_create_customer := TRUE;
	--
	SELECT C.C_ID
	INTO v_c_id
	FROM "IPYME_FINAL"."CUSTOMER" C
	WHERE ((C.C_ID = p_c_id) AND (C.c_invoice_entity = v_ie_id)) 
	OR ((C.c_invoice_entity = v_ie_id) AND (C.c_customer_name = p_c_customer_name));
	--
	IF FOUND THEN
		v_create_customer := FALSE;
	END IF;
	--
	IF (v_create_customer = TRUE) THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."CUSTOMER_c_id_seq"') INTO v_c_id ;
		--
		INSERT INTO "IPYME_FINAL"."CUSTOMER" (c_id
						  ,c_customer_name 
						  ,c_invoice_entity)
					VALUES ( v_c_id
						  ,p_c_customer_name 
						  ,v_ie_id);
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."CUSTOMER"
		SET 	c_customer_name = p_c_customer_name
		WHERE c_id = v_c_id
		AND c_invoice_entity = v_ie_id;
		--
	END IF;
	--
	--
	RETURN QUERY select c.c_id as c_id
			, c.c_customer_name as c_customer_name
			, c.c_invoice_entity as c_invoice_entity
			, ie.ie_id as ie_id
			, ie.ie_legal_id as ie_legal_id
			, ie.ie_invoice_name  as ie_invoice_name
		from "IPYME_FINAL"."CUSTOMER" c
			,"IPYME_FINAL"."INVOICE_ENTITY" ie
		WHERE c.c_invoice_entity=ie.ie_id
		and (c.c_id=v_c_id);
	--
	--
	EXCEPTION 
		WHEN OTHERS THEN
			RETURN;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_customer(p_c_id bigint, p_c_customer_name character varying, p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 42608)
-- Dependencies: 754 11
-- Name: set_invoice_entity(bigint, character varying, character varying); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_invoice_entity(p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE
v_ie_id BIGINT;
v_create_invoice_entity BOOLEAN;
v_record RECORD;
BEGIN
	--
	v_create_invoice_entity := TRUE;
	--
	IF (p_ie_id > 0) THEN
		--
		SELECT IE.IE_ID
		INTO v_ie_id
		FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
		WHERE IE.IE_ID = p_ie_id;
		--
		IF FOUND THEN
			v_create_invoice_entity := FALSE;
		END IF;
		--
	END IF;
	--
	IF (v_create_invoice_entity = TRUE) THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."INVOICE_ENTITY_ie_id_seq"') INTO v_ie_id ;
		INSERT INTO "IPYME_FINAL"."INVOICE_ENTITY" (ie_id
							, ie_legal_id
							, ie_invoice_name)
						VALUES(v_ie_id
							, p_ie_legal_id
							, p_ie_invoice_name);
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."INVOICE_ENTITY"
		SET 	ie_legal_id = p_ie_legal_id
			, ie_invoice_name = p_ie_invoice_name
		WHERE ie_id = v_ie_id;
		--
	END IF;
	--
	--
	v_record := (v_ie_id, p_ie_legal_id, p_ie_invoice_name);
	--
	--
	RETURN v_record;
	--
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_invoice_entity(p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 42639)
-- Dependencies: 642 754 11
-- Name: set_price_to_product(bigint, numeric); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_price_to_product(p_p_product bigint, p_p_price numeric) RETURNS SETOF "PRICES"
    LANGUAGE plpgsql
    AS $$
DECLARE
v_p_id BIGINT;
BEGIN
	--
	IF (p_p_product IS NULL) OR (p_p_price IS NULL) THEN
		--
		RETURN;
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."PRICES" 
		SET p_status = 0
		WHERE p_product = p_p_product;
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PRICES_p_id_seq"') INTO v_p_id;
		--
		INSERT INTO "IPYME_FINAL"."PRICES" (p_id
																			, p_date 
																			, p_product
																			, p_status
																			, p_currency
																			, p_price)
																VALUES (v_p_id
																			, CURRENT_TIMESTAMP
																			, p_p_product
																			, 1
																			, NULL	
																			, p_p_price);
		RETURN QUERY SELECT * 
		FROM "IPYME_FINAL"."PRICES" PR
		WHERE PR.p_product = p_p_product
		AND PR.p_status = 1;
		--
	END IF;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_price_to_product(p_p_product bigint, p_p_price numeric) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 42642)
-- Dependencies: 754 11 747
-- Name: set_product(bigint, character varying, character varying, character varying, bigint, numeric, text); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_product(p_p_id bigint, p_p_ref character varying, p_p_description character varying, p_p_long_description character varying, p_p_category bigint, p_p_price numeric, p_p_image_path text) RETURNS SETOF get_product
    LANGUAGE plpgsql
    AS $$
DECLARE
v_p_id "IPYME_FINAL"."PRODUCT"."p_id"%TYPE;
v_prices "IPYME_FINAL"."PRICES"%ROWTYPE;
BEGIN
	--
	IF p_p_id IS NULL THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PRODUCT_p_id_seq"') INTO v_p_id;
		--
		INSERT INTO "IPYME_FINAL"."PRODUCT" (p_id
																				,p_ref 
																				,p_description 
																				,p_long_description 
																				,p_category
																				,p_image_path)
																	VALUES(v_p_id
																			, p_p_ref 
																			, p_p_description
																			, p_p_long_description
																			, p_p_category
																			, p_p_image_path);
		--
	ELSE
		--
		v_p_id := p_p_id;
		--
		UPDATE "IPYME_FINAL"."PRODUCT" 
		SET  p_ref 							= p_p_ref
				,p_description 			= p_p_description
				,p_long_description = p_p_long_description
				,p_image_path				= p_p_image_path
		WHERE p_id = v_p_id;
		--
	END IF;
	--
	PERFORM "IPYME_FINAL".set_price_to_product(v_p_id, p_p_price);
	--
	RETURN  QUERY SELECT * FROM "IPYME_FINAL".get_product(v_p_id); 
	--
	EXCEPTION
		WHEN OTHERS THEN
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_product(p_p_id bigint, p_p_ref character varying, p_p_description character varying, p_p_long_description character varying, p_p_category bigint, p_p_price numeric, p_p_image_path text) OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 42111)
-- Dependencies: 11
-- Name: PRODUCT_ATTRIBUTE_VALUE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PRODUCT_ATTRIBUTE_VALUE" (
    pav_product bigint NOT NULL,
    pav_product_category_attribute bigint NOT NULL,
    pav_value text NOT NULL
);


ALTER TABLE "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE" OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 42620)
-- Dependencies: 754 621 11
-- Name: set_product_attribute_value(bigint, bigint, text); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_product_attribute_value(p_pav_product bigint, p_pav_product_category_attribute bigint, p_pav_value text) RETURNS SETOF "PRODUCT_ATTRIBUTE_VALUE"
    LANGUAGE plpgsql
    AS $$
DECLARE
v_pav_value TEXT;
BEGIN
	--
	IF p_pav_value IS NULL OR LENGTH(p_pav_value)=0 THEN
		RETURN;
	END IF;
	--
	v_pav_value := UPPER(p_pav_value);
	--
	UPDATE "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"
		SET pav_value = v_pav_value
	WHERE pav_product = p_pav_product
	AND pav_product_category_attribute = p_pav_product_category_attribute;
	--
	IF NOT FOUND THEN
		--
		INSERT INTO "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE" (pav_product
																												,pav_product_category_attribute 
																												,pav_value)
																									VALUES(p_pav_product
																												,p_pav_product_category_attribute
																												,v_pav_value);
		--
	END IF;
	--
	RETURN QUERY SELECT p_pav_product
											,p_pav_product_category_attribute
											,v_pav_value;
	--
	EXCEPTION
		WHEN OTHERS THEN
			NULL;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_product_attribute_value(p_pav_product bigint, p_pav_product_category_attribute bigint, p_pav_value text) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 42610)
-- Dependencies: 754 607 11
-- Name: set_product_category(bigint, numeric, text, text); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_product_category(p_pc_id bigint, p_pc_tax_rate numeric, p_pc_description text, p_pc_path text) RETURNS SETOF "PRODUCT_CATEGORY"
    LANGUAGE plpgsql
    AS $$
DECLARE
v_product_category "IPYME_FINAL"."PRODUCT_CATEGORY";
BEGIN
	--
	v_product_category.pc_tax_rate := p_pc_tax_rate;
	v_product_category.pc_description = p_pc_description;
	v_product_category.pc_path := UPPER(p_pc_path);
	--																						
	IF p_pc_id IS NULL THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PRODUCT_CATEGORY_pc_id_seq"') INTO v_product_category.pc_id;
		--
		INSERT INTO "IPYME_FINAL"."PRODUCT_CATEGORY" (pc_id
																								, pc_tax_rate
																								, pc_description
																								, pc_path)
																				VALUES (v_product_category.pc_id
																								, v_product_category.pc_tax_rate
																								, v_product_category.pc_description
																								, v_product_category.pc_path);
		--
	ELSE
		--
		v_product_category.pc_id := p_pc_id;
		UPDATE "IPYME_FINAL"."PRODUCT_CATEGORY"
		SET pc_tax_rate = v_product_category.pc_tax_rate
			, pc_description = v_product_category.pc_description
			, pc_path = v_product_category.pc_path
		WHERE pc_id = v_product_category.pc_id;												
		--
	END IF;
	--
	RETURN QUERY SELECT v_product_category.pc_id
										, v_product_category.pc_tax_rate
										, v_product_category.pc_description
										, v_product_category.pc_path;
	--
	EXCEPTION
		WHEN OTHERS THEN 
			NULL;
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_product_category(p_pc_id bigint, p_pc_tax_rate numeric, p_pc_description text, p_pc_path text) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 42612)
-- Dependencies: 11 612 754
-- Name: set_product_category_attribute(bigint, bigint, text); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_product_category_attribute(p_pca_id bigint, p_pca_product_category bigint, p_pca_attribute text) RETURNS SETOF "PRODUCT_CATEGORY_ATTRIBUTE"
    LANGUAGE plpgsql
    AS $$
DECLARE
v_product_category_attribute "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE";
BEGIN
	--
	v_product_category_attribute.pca_product_category := p_pca_product_category;
	v_product_category_attribute.pca_attribute := UPPER(p_pca_attribute);
	--
	IF p_pca_id IS NULL THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq"') INTO v_product_category_attribute.pca_id;
		--
		INSERT INTO "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" (pca_id
																											, pca_product_category
																											, pca_attribute )
																								VALUES (v_product_category_attribute.pca_id
																											, v_product_category_attribute.pca_product_category
																											, v_product_category_attribute.pca_attribute );
		--
	ELSE
		--
		v_product_category_attribute.pca_id := p_pca_id;
		--
		UPDATE "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" 
		SET pca_product_category = v_product_category_attribute.pca_product_category
					, pca_attribute = v_product_category_attribute.pca_attribute
		WHERE pca_id = v_product_category_attribute.pca_id;
		--
	END IF;
	--
	RETURN QUERY 	SELECT v_product_category_attribute.*;
	--
	EXCEPTION
			WHEN OTHERS THEN
				NULL;
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_product_category_attribute(p_pca_id bigint, p_pca_product_category bigint, p_pca_attribute text) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 42607)
-- Dependencies: 754 11
-- Name: set_provider(bigint, character varying, bigint, character varying, character varying); Type: FUNCTION; Schema: IPYME_FINAL; Owner: postgres
--

CREATE FUNCTION set_provider(p_p_id bigint, p_p_provider_name character varying, p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying) RETURNS TABLE(p_id bigint, p_provider_name character varying, p_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying)
    LANGUAGE plpgsql
    AS $$
#variable_conflict use_column
DECLARE
v_p_id BIGINT;
v_ie_id BIGINT;
v_create_provider BOOLEAN;
v_create_invoice_entity BOOLEAN;
BEGIN
	--
	v_create_invoice_entity := TRUE;
	--
	--
	SELECT IE.IE_ID
	INTO v_ie_id
	FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
	WHERE IE.IE_ID = p_ie_id
	OR IE.IE_LEGAL_ID = p_ie_legal_id;
	--
	IF FOUND THEN
		v_create_invoice_entity := FALSE;
	END IF;
	--
	IF (v_create_invoice_entity = TRUE) THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."INVOICE_ENTITY_ie_id_seq"') INTO v_ie_id ;
		INSERT INTO "IPYME_FINAL"."INVOICE_ENTITY" (ie_id
							, ie_legal_id
							, ie_invoice_name)
						VALUES(v_ie_id
							, p_ie_legal_id
							, p_ie_invoice_name);
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."INVOICE_ENTITY" 
		SET 	ie_legal_id = p_ie_legal_id
			, ie_invoice_name = p_ie_invoice_name
		WHERE ie_id = v_ie_id;
		--
	END IF;
	--
	--
	v_create_provider := TRUE;
	--
	SELECT P.P_ID
	INTO v_p_id
	FROM "IPYME_FINAL"."PROVIDER" P
	WHERE ((P.P_ID = p_p_id) AND (P.p_invoice_entity = v_ie_id)) 
	OR ((P.p_invoice_entity = v_ie_id) AND (P.p_provider_name = p_p_provider_name));
	--
	IF FOUND THEN
		v_create_provider := FALSE;
	END IF;
	--
	IF (v_create_provider = TRUE) THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PROVIDER_p_id_seq"') INTO v_p_id ;
		--
		INSERT INTO "IPYME_FINAL"."PROVIDER" (p_id
						  ,p_provider_name 
						  ,p_invoice_entity)
					VALUES ( v_p_id
						  ,p_p_provider_name 
						  ,v_ie_id);
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."PROVIDER"
		SET 	p_provider_name = p_p_provider_name
		WHERE p_id = v_p_id
		AND p_invoice_entity = v_ie_id;
		--
	END IF;
	--
	--
	RETURN QUERY select p.p_id as p_id
			, p.p_provider_name as p_provider_name
			, p.p_invoice_entity as p_invoice_entity
			, ie.ie_id as ie_id
			, ie.ie_legal_id as ie_legal_id
			, ie.ie_invoice_name  as ie_invoice_name
		from "IPYME_FINAL"."PROVIDER" p
			,"IPYME_FINAL"."INVOICE_ENTITY" ie
		WHERE p.p_invoice_entity=ie.ie_id
		and (p.p_id=v_p_id);
	--
	--
	EXCEPTION 
		WHEN OTHERS THEN
			RETURN;
	--
END;
$$;


ALTER FUNCTION "IPYME_FINAL".set_provider(p_p_id bigint, p_p_provider_name character varying, p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying) OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 42298)
-- Dependencies: 11
-- Name: ADDRESS_DETAIL; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "ADDRESS_DETAIL" (
    ad_id bigint NOT NULL,
    ad_line1 character varying(100),
    ad_line character varying(100),
    ad_town character varying(100),
    ad_country integer,
    ad_description character varying(100),
    ad_invoice_entity bigint
);


ALTER TABLE "IPYME_FINAL"."ADDRESS_DETAIL" OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 42296)
-- Dependencies: 203 11
-- Name: ADDRESS_DETAIL_ad_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "ADDRESS_DETAIL_ad_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."ADDRESS_DETAIL_ad_id_seq" OWNER TO postgres;

--
-- TOC entry 2391 (class 0 OID 0)
-- Dependencies: 202
-- Name: ADDRESS_DETAIL_ad_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "ADDRESS_DETAIL_ad_id_seq" OWNED BY "ADDRESS_DETAIL".ad_id;


--
-- TOC entry 224 (class 1259 OID 42453)
-- Dependencies: 11
-- Name: BANK_ACCOUNT; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "BANK_ACCOUNT" (
    ba_id bigint NOT NULL,
    ba_invoice_entity bigint,
    ba_numer character varying(100)
);


ALTER TABLE "IPYME_FINAL"."BANK_ACCOUNT" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 42451)
-- Dependencies: 224 11
-- Name: BANK_ACCOUNT_ba_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "BANK_ACCOUNT_ba_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."BANK_ACCOUNT_ba_id_seq" OWNER TO postgres;

--
-- TOC entry 2392 (class 0 OID 0)
-- Dependencies: 223
-- Name: BANK_ACCOUNT_ba_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "BANK_ACCOUNT_ba_id_seq" OWNED BY "BANK_ACCOUNT".ba_id;


--
-- TOC entry 188 (class 1259 OID 42195)
-- Dependencies: 11
-- Name: BASKET; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "BASKET" (
    b_id bigint NOT NULL
);


ALTER TABLE "IPYME_FINAL"."BASKET" OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 42200)
-- Dependencies: 11
-- Name: BASKET_LIST; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "BASKET_LIST" (
    bl_id bigint NOT NULL,
    bl_basket bigint,
    bl_product bigint,
    bl_quantity integer
);


ALTER TABLE "IPYME_FINAL"."BASKET_LIST" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 42435)
-- Dependencies: 11
-- Name: CARD; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "CARD" (
    c_id bigint NOT NULL,
    c_invoice_entity bigint,
    c_description character varying(100),
    c_card_number character varying(20),
    c_name character varying(100),
    c_expire_date character varying(8),
    c_issue_numer character varying(20),
    c_vendor integer
);


ALTER TABLE "IPYME_FINAL"."CARD" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 42427)
-- Dependencies: 11
-- Name: CARD_VENDOR; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "CARD_VENDOR" (
    cv_id integer NOT NULL,
    cv_name character varying(100)
);


ALTER TABLE "IPYME_FINAL"."CARD_VENDOR" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 42425)
-- Dependencies: 220 11
-- Name: CARD_VENDOR_cv_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "CARD_VENDOR_cv_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."CARD_VENDOR_cv_id_seq" OWNER TO postgres;

--
-- TOC entry 2393 (class 0 OID 0)
-- Dependencies: 219
-- Name: CARD_VENDOR_cv_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "CARD_VENDOR_cv_id_seq" OWNED BY "CARD_VENDOR".cv_id;


--
-- TOC entry 221 (class 1259 OID 42433)
-- Dependencies: 222 11
-- Name: CARD_c_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "CARD_c_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."CARD_c_id_seq" OWNER TO postgres;

--
-- TOC entry 2394 (class 0 OID 0)
-- Dependencies: 221
-- Name: CARD_c_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "CARD_c_id_seq" OWNED BY "CARD".c_id;


--
-- TOC entry 216 (class 1259 OID 42391)
-- Dependencies: 11
-- Name: COMMERCIAL_TRANSACTION; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "COMMERCIAL_TRANSACTION" (
    ct_id bigint NOT NULL,
    ct_purchase bigint,
    ct_sale bigint
);


ALTER TABLE "IPYME_FINAL"."COMMERCIAL_TRANSACTION" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 42389)
-- Dependencies: 11 216
-- Name: COMMERCIAL_TRANSACTION_ct_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "COMMERCIAL_TRANSACTION_ct_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."COMMERCIAL_TRANSACTION_ct_id_seq" OWNER TO postgres;

--
-- TOC entry 2395 (class 0 OID 0)
-- Dependencies: 215
-- Name: COMMERCIAL_TRANSACTION_ct_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "COMMERCIAL_TRANSACTION_ct_id_seq" OWNED BY "COMMERCIAL_TRANSACTION".ct_id;


--
-- TOC entry 173 (class 1259 OID 42054)
-- Dependencies: 11
-- Name: COMPANY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "COMPANY" (
    "C_ID" numeric NOT NULL,
    "C_NAME" character varying(255),
    "C_DATE" timestamp with time zone
);


ALTER TABLE "IPYME_FINAL"."COMPANY" OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 42215)
-- Dependencies: 11
-- Name: COUNTRY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "COUNTRY" (
    c_id integer NOT NULL,
    c_name character varying(100)
);


ALTER TABLE "IPYME_FINAL"."COUNTRY" OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 42255)
-- Dependencies: 11
-- Name: COURIER; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "COURIER" (
    c_id bigint NOT NULL,
    c_invoice_entity bigint
);


ALTER TABLE "IPYME_FINAL"."COURIER" OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 42253)
-- Dependencies: 197 11
-- Name: COURIER_c_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "COURIER_c_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."COURIER_c_id_seq" OWNER TO postgres;

--
-- TOC entry 2396 (class 0 OID 0)
-- Dependencies: 196
-- Name: COURIER_c_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "COURIER_c_id_seq" OWNED BY "COURIER".c_id;


--
-- TOC entry 186 (class 1259 OID 42174)
-- Dependencies: 11
-- Name: CURRENCY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "CURRENCY" (
    c_id integer NOT NULL,
    c_name character varying(100)
);


ALTER TABLE "IPYME_FINAL"."CURRENCY" OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 42172)
-- Dependencies: 186 11
-- Name: CURRENCY_c_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "CURRENCY_c_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."CURRENCY_c_id_seq" OWNER TO postgres;

--
-- TOC entry 2397 (class 0 OID 0)
-- Dependencies: 185
-- Name: CURRENCY_c_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "CURRENCY_c_id_seq" OWNED BY "CURRENCY".c_id;


--
-- TOC entry 199 (class 1259 OID 42268)
-- Dependencies: 11
-- Name: CUSTOMER; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "CUSTOMER" (
    c_id bigint NOT NULL,
    c_customer_name character varying(100),
    c_invoice_entity bigint
);


ALTER TABLE "IPYME_FINAL"."CUSTOMER" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 42569)
-- Dependencies: 11
-- Name: CUSTOMER_CATEGORY_DETAILS; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "CUSTOMER_CATEGORY_DETAILS" (
    ccd_id bigint NOT NULL,
    ccd_tax_rate numeric(8,3),
    ccd_description character varying(255)
);


ALTER TABLE "IPYME_FINAL"."CUSTOMER_CATEGORY_DETAILS" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 42567)
-- Dependencies: 234 11
-- Name: CUSTOMER_CATEGORY_DETAILS_ccd_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "CUSTOMER_CATEGORY_DETAILS_ccd_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."CUSTOMER_CATEGORY_DETAILS_ccd_id_seq" OWNER TO postgres;

--
-- TOC entry 2398 (class 0 OID 0)
-- Dependencies: 233
-- Name: CUSTOMER_CATEGORY_DETAILS_ccd_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "CUSTOMER_CATEGORY_DETAILS_ccd_id_seq" OWNED BY "CUSTOMER_CATEGORY_DETAILS".ccd_id;


--
-- TOC entry 235 (class 1259 OID 42575)
-- Dependencies: 11
-- Name: CUSTOMER_CATEGORY_LINK; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "CUSTOMER_CATEGORY_LINK" (
    ccl_category_details bigint NOT NULL,
    ccl_customer bigint NOT NULL
);


ALTER TABLE "IPYME_FINAL"."CUSTOMER_CATEGORY_LINK" OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 42266)
-- Dependencies: 11 199
-- Name: CUSTOMER_c_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "CUSTOMER_c_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."CUSTOMER_c_id_seq" OWNER TO postgres;

--
-- TOC entry 2399 (class 0 OID 0)
-- Dependencies: 198
-- Name: CUSTOMER_c_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "CUSTOMER_c_id_seq" OWNED BY "CUSTOMER".c_id;


--
-- TOC entry 218 (class 1259 OID 42409)
-- Dependencies: 11
-- Name: DELIVERY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "DELIVERY" (
    d_id bigint NOT NULL,
    d_sale bigint,
    d_tracking character varying(100),
    d_weight numeric(5,3),
    d_parts integer,
    d_courier bigint
);


ALTER TABLE "IPYME_FINAL"."DELIVERY" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 42407)
-- Dependencies: 218 11
-- Name: DELIVERY_d_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "DELIVERY_d_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."DELIVERY_d_id_seq" OWNER TO postgres;

--
-- TOC entry 2400 (class 0 OID 0)
-- Dependencies: 217
-- Name: DELIVERY_d_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "DELIVERY_d_id_seq" OWNED BY "DELIVERY".d_id;


--
-- TOC entry 192 (class 1259 OID 42222)
-- Dependencies: 11
-- Name: INVOICE_ENTITY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "INVOICE_ENTITY" (
    ie_id bigint NOT NULL,
    ie_legal_id character varying(100),
    ie_invoice_name character varying(100)
);


ALTER TABLE "IPYME_FINAL"."INVOICE_ENTITY" OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 42220)
-- Dependencies: 11 192
-- Name: INVOICE_ENTITY_ie_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "INVOICE_ENTITY_ie_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."INVOICE_ENTITY_ie_id_seq" OWNER TO postgres;

--
-- TOC entry 2401 (class 0 OID 0)
-- Dependencies: 191
-- Name: INVOICE_ENTITY_ie_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "INVOICE_ENTITY_ie_id_seq" OWNED BY "INVOICE_ENTITY".ie_id;


--
-- TOC entry 184 (class 1259 OID 42162)
-- Dependencies: 11
-- Name: ITEM; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "ITEM" (
    i_id bigint NOT NULL,
    i_product bigint,
    i_commercial_id character varying(50)
);


ALTER TABLE "IPYME_FINAL"."ITEM" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 42527)
-- Dependencies: 11
-- Name: ITEM_HISTORY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "ITEM_HISTORY" (
    ih_id bigint NOT NULL,
    ih_item bigint,
    ih_product_list bigint,
    ih_date timestamp with time zone
);


ALTER TABLE "IPYME_FINAL"."ITEM_HISTORY" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 42525)
-- Dependencies: 11 230
-- Name: ITEM_HISTORY_ih_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "ITEM_HISTORY_ih_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."ITEM_HISTORY_ih_id_seq" OWNER TO postgres;

--
-- TOC entry 2402 (class 0 OID 0)
-- Dependencies: 229
-- Name: ITEM_HISTORY_ih_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "ITEM_HISTORY_ih_id_seq" OWNED BY "ITEM_HISTORY".ih_id;


--
-- TOC entry 172 (class 1259 OID 42046)
-- Dependencies: 11
-- Name: LANGUAGE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "LANGUAGE" (
    "L_ID" numeric NOT NULL,
    "L_1" character varying(255),
    "L_2" character varying(255)
);


ALTER TABLE "IPYME_FINAL"."LANGUAGE" OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 42339)
-- Dependencies: 11
-- Name: ORDER_CUSTOMER; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "ORDER_CUSTOMER" (
    oc_id bigint NOT NULL,
    od_customer bigint,
    od_date timestamp with time zone
);


ALTER TABLE "IPYME_FINAL"."ORDER_CUSTOMER" OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 42337)
-- Dependencies: 11 208
-- Name: ORDER_CUSTOMER_oc_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "ORDER_CUSTOMER_oc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."ORDER_CUSTOMER_oc_id_seq" OWNER TO postgres;

--
-- TOC entry 2403 (class 0 OID 0)
-- Dependencies: 207
-- Name: ORDER_CUSTOMER_oc_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "ORDER_CUSTOMER_oc_id_seq" OWNED BY "ORDER_CUSTOMER".oc_id;


--
-- TOC entry 212 (class 1259 OID 42365)
-- Dependencies: 11
-- Name: ORDER_PROVIDER; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "ORDER_PROVIDER" (
    op_id bigint NOT NULL,
    op_provider bigint,
    op_date timestamp with time zone
);


ALTER TABLE "IPYME_FINAL"."ORDER_PROVIDER" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 42363)
-- Dependencies: 212 11
-- Name: ORDER_PROVIDER_op_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "ORDER_PROVIDER_op_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."ORDER_PROVIDER_op_id_seq" OWNER TO postgres;

--
-- TOC entry 2404 (class 0 OID 0)
-- Dependencies: 211
-- Name: ORDER_PROVIDER_op_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "ORDER_PROVIDER_op_id_seq" OWNED BY "ORDER_PROVIDER".op_id;


--
-- TOC entry 226 (class 1259 OID 42466)
-- Dependencies: 11
-- Name: PAYMENT; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PAYMENT" (
    p_id bigint NOT NULL,
    p_card bigint,
    p_amount numeric(8,3),
    p_currency integer,
    p_date timestamp with time zone,
    p_commercial_transaction bigint,
    p_bank bigint,
    p_cash boolean
);


ALTER TABLE "IPYME_FINAL"."PAYMENT" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 42464)
-- Dependencies: 11 226
-- Name: PAYMENT_p_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PAYMENT_p_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PAYMENT_p_id_seq" OWNER TO postgres;

--
-- TOC entry 2405 (class 0 OID 0)
-- Dependencies: 225
-- Name: PAYMENT_p_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PAYMENT_p_id_seq" OWNED BY "PAYMENT".p_id;


--
-- TOC entry 194 (class 1259 OID 42232)
-- Dependencies: 11
-- Name: PEOPLE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PEOPLE" (
    p_id bigint NOT NULL,
    p_name character varying(100),
    p_surname character varying(100),
    p_invoice_entity bigint
);


ALTER TABLE "IPYME_FINAL"."PEOPLE" OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 42243)
-- Dependencies: 11
-- Name: PEOPLE_REPONSIBILITY; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PEOPLE_REPONSIBILITY" (
    pr_ref character varying(50) NOT NULL,
    pr_description character varying(100),
    pr_people bigint
);


ALTER TABLE "IPYME_FINAL"."PEOPLE_REPONSIBILITY" OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 42230)
-- Dependencies: 194 11
-- Name: PEOPLE_p_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PEOPLE_p_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PEOPLE_p_id_seq" OWNER TO postgres;

--
-- TOC entry 2406 (class 0 OID 0)
-- Dependencies: 193
-- Name: PEOPLE_p_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PEOPLE_p_id_seq" OWNED BY "PEOPLE".p_id;


--
-- TOC entry 237 (class 1259 OID 42640)
-- Dependencies: 11
-- Name: PRICES_p_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PRICES_p_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PRICES_p_id_seq" OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 42075)
-- Dependencies: 177 11
-- Name: PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq" OWNER TO postgres;

--
-- TOC entry 2407 (class 0 OID 0)
-- Dependencies: 176
-- Name: PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq" OWNED BY "PRODUCT_CATEGORY_ATTRIBUTE".pca_id;


--
-- TOC entry 174 (class 1259 OID 42062)
-- Dependencies: 11 175
-- Name: PRODUCT_CATEGORY_pc_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PRODUCT_CATEGORY_pc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PRODUCT_CATEGORY_pc_id_seq" OWNER TO postgres;

--
-- TOC entry 2408 (class 0 OID 0)
-- Dependencies: 174
-- Name: PRODUCT_CATEGORY_pc_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PRODUCT_CATEGORY_pc_id_seq" OWNED BY "PRODUCT_CATEGORY".pc_id;


--
-- TOC entry 228 (class 1259 OID 42494)
-- Dependencies: 11
-- Name: PRODUCT_LIST; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PRODUCT_LIST" (
    pl_id bigint NOT NULL,
    pl_order_customer bigint,
    pl_order_provider bigint,
    pl_product bigint,
    pl_quantity numeric(5,3),
    pl_price numeric(8,3),
    pl_currency integer,
    pl_store integer,
    pl_quantity_dispatched numeric(5,3)
);


ALTER TABLE "IPYME_FINAL"."PRODUCT_LIST" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 42492)
-- Dependencies: 228 11
-- Name: PRODUCT_LIST_pl_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PRODUCT_LIST_pl_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PRODUCT_LIST_pl_id_seq" OWNER TO postgres;

--
-- TOC entry 2409 (class 0 OID 0)
-- Dependencies: 227
-- Name: PRODUCT_LIST_pl_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PRODUCT_LIST_pl_id_seq" OWNED BY "PRODUCT_LIST".pl_id;


--
-- TOC entry 178 (class 1259 OID 42093)
-- Dependencies: 11 179
-- Name: PRODUCT_p_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PRODUCT_p_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PRODUCT_p_id_seq" OWNER TO postgres;

--
-- TOC entry 2410 (class 0 OID 0)
-- Dependencies: 178
-- Name: PRODUCT_p_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PRODUCT_p_id_seq" OWNED BY "PRODUCT".p_id;


--
-- TOC entry 201 (class 1259 OID 42283)
-- Dependencies: 11
-- Name: PROVIDER; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PROVIDER" (
    p_id bigint NOT NULL,
    p_provider_name character varying(100),
    p_invoice_entity bigint
);


ALTER TABLE "IPYME_FINAL"."PROVIDER" OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 42316)
-- Dependencies: 11
-- Name: PROVIDER_CATEGORY_DETAILS; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PROVIDER_CATEGORY_DETAILS" (
    pcd_id bigint NOT NULL,
    pcd_tax_rate numeric(8,3),
    pcd_description character varying(255)
);


ALTER TABLE "IPYME_FINAL"."PROVIDER_CATEGORY_DETAILS" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 42314)
-- Dependencies: 11 205
-- Name: PROVIDER_CATEGORY_DETAILS_pcd_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PROVIDER_CATEGORY_DETAILS_pcd_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PROVIDER_CATEGORY_DETAILS_pcd_id_seq" OWNER TO postgres;

--
-- TOC entry 2411 (class 0 OID 0)
-- Dependencies: 204
-- Name: PROVIDER_CATEGORY_DETAILS_pcd_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PROVIDER_CATEGORY_DETAILS_pcd_id_seq" OWNED BY "PROVIDER_CATEGORY_DETAILS".pcd_id;


--
-- TOC entry 206 (class 1259 OID 42322)
-- Dependencies: 11
-- Name: PROVIDER_CATEGORY_LINK; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PROVIDER_CATEGORY_LINK" (
    pcl_provider bigint NOT NULL,
    pcl_category_details bigint NOT NULL
);


ALTER TABLE "IPYME_FINAL"."PROVIDER_CATEGORY_LINK" OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 42281)
-- Dependencies: 11 201
-- Name: PROVIDER_p_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PROVIDER_p_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PROVIDER_p_id_seq" OWNER TO postgres;

--
-- TOC entry 2412 (class 0 OID 0)
-- Dependencies: 200
-- Name: PROVIDER_p_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PROVIDER_p_id_seq" OWNED BY "PROVIDER".p_id;


--
-- TOC entry 214 (class 1259 OID 42378)
-- Dependencies: 11
-- Name: PURCHASE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "PURCHASE" (
    p_id bigint NOT NULL,
    p_order_provider bigint
);


ALTER TABLE "IPYME_FINAL"."PURCHASE" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 42376)
-- Dependencies: 214 11
-- Name: PURCHASE_p_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "PURCHASE_p_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."PURCHASE_p_id_seq" OWNER TO postgres;

--
-- TOC entry 2413 (class 0 OID 0)
-- Dependencies: 213
-- Name: PURCHASE_p_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "PURCHASE_p_id_seq" OWNED BY "PURCHASE".p_id;


--
-- TOC entry 210 (class 1259 OID 42352)
-- Dependencies: 11
-- Name: SALE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "SALE" (
    s_id bigint NOT NULL,
    s_order_customer bigint
);


ALTER TABLE "IPYME_FINAL"."SALE" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 42350)
-- Dependencies: 210 11
-- Name: SALE_s_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "SALE_s_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."SALE_s_id_seq" OWNER TO postgres;

--
-- TOC entry 2414 (class 0 OID 0)
-- Dependencies: 209
-- Name: SALE_s_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "SALE_s_id_seq" OWNED BY "SALE".s_id;


--
-- TOC entry 183 (class 1259 OID 42144)
-- Dependencies: 11
-- Name: STOCK; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "STOCK" (
    s_id bigint NOT NULL,
    s_product_id bigint,
    s_store integer,
    s_quantity numeric
);


ALTER TABLE "IPYME_FINAL"."STOCK" OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 42134)
-- Dependencies: 11
-- Name: STORE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "STORE" (
    s_id integer NOT NULL,
    s_store_type integer,
    s_store_name character varying(100)
);


ALTER TABLE "IPYME_FINAL"."STORE" OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 42129)
-- Dependencies: 11
-- Name: STORE_TYPE; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "STORE_TYPE" (
    st_id integer NOT NULL,
    st_description character varying(255),
    st_in_out boolean
);


ALTER TABLE "IPYME_FINAL"."STORE_TYPE" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 42545)
-- Dependencies: 11
-- Name: USER; Type: TABLE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE TABLE "USER" (
    u_id bigint NOT NULL,
    u_session character varying(100),
    u_last_login timestamp with time zone,
    u_email character varying(200),
    u_status integer,
    u_basket bigint,
    u_customer bigint,
    u_name character varying(30) NOT NULL,
    u_password_hash character varying(100) NOT NULL
);


ALTER TABLE "IPYME_FINAL"."USER" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 42543)
-- Dependencies: 232 11
-- Name: USER_u_id_seq; Type: SEQUENCE; Schema: IPYME_FINAL; Owner: postgres
--

CREATE SEQUENCE "USER_u_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "IPYME_FINAL"."USER_u_id_seq" OWNER TO postgres;

--
-- TOC entry 2415 (class 0 OID 0)
-- Dependencies: 231
-- Name: USER_u_id_seq; Type: SEQUENCE OWNED BY; Schema: IPYME_FINAL; Owner: postgres
--

ALTER SEQUENCE "USER_u_id_seq" OWNED BY "USER".u_id;


--
-- TOC entry 2163 (class 2604 OID 42301)
-- Dependencies: 203 202 203
-- Name: ad_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ADDRESS_DETAIL" ALTER COLUMN ad_id SET DEFAULT nextval('"ADDRESS_DETAIL_ad_id_seq"'::regclass);


--
-- TOC entry 2173 (class 2604 OID 42456)
-- Dependencies: 223 224 224
-- Name: ba_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BANK_ACCOUNT" ALTER COLUMN ba_id SET DEFAULT nextval('"BANK_ACCOUNT_ba_id_seq"'::regclass);


--
-- TOC entry 2172 (class 2604 OID 42438)
-- Dependencies: 222 221 222
-- Name: c_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CARD" ALTER COLUMN c_id SET DEFAULT nextval('"CARD_c_id_seq"'::regclass);


--
-- TOC entry 2171 (class 2604 OID 42430)
-- Dependencies: 220 219 220
-- Name: cv_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CARD_VENDOR" ALTER COLUMN cv_id SET DEFAULT nextval('"CARD_VENDOR_cv_id_seq"'::regclass);


--
-- TOC entry 2169 (class 2604 OID 42394)
-- Dependencies: 216 215 216
-- Name: ct_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COMMERCIAL_TRANSACTION" ALTER COLUMN ct_id SET DEFAULT nextval('"COMMERCIAL_TRANSACTION_ct_id_seq"'::regclass);


--
-- TOC entry 2160 (class 2604 OID 42258)
-- Dependencies: 196 197 197
-- Name: c_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COURIER" ALTER COLUMN c_id SET DEFAULT nextval('"COURIER_c_id_seq"'::regclass);


--
-- TOC entry 2157 (class 2604 OID 42177)
-- Dependencies: 185 186 186
-- Name: c_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CURRENCY" ALTER COLUMN c_id SET DEFAULT nextval('"CURRENCY_c_id_seq"'::regclass);


--
-- TOC entry 2161 (class 2604 OID 42271)
-- Dependencies: 199 198 199
-- Name: c_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER" ALTER COLUMN c_id SET DEFAULT nextval('"CUSTOMER_c_id_seq"'::regclass);


--
-- TOC entry 2178 (class 2604 OID 42572)
-- Dependencies: 233 234 234
-- Name: ccd_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER_CATEGORY_DETAILS" ALTER COLUMN ccd_id SET DEFAULT nextval('"CUSTOMER_CATEGORY_DETAILS_ccd_id_seq"'::regclass);


--
-- TOC entry 2170 (class 2604 OID 42412)
-- Dependencies: 217 218 218
-- Name: d_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "DELIVERY" ALTER COLUMN d_id SET DEFAULT nextval('"DELIVERY_d_id_seq"'::regclass);


--
-- TOC entry 2158 (class 2604 OID 42225)
-- Dependencies: 191 192 192
-- Name: ie_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "INVOICE_ENTITY" ALTER COLUMN ie_id SET DEFAULT nextval('"INVOICE_ENTITY_ie_id_seq"'::regclass);


--
-- TOC entry 2176 (class 2604 OID 42530)
-- Dependencies: 229 230 230
-- Name: ih_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ITEM_HISTORY" ALTER COLUMN ih_id SET DEFAULT nextval('"ITEM_HISTORY_ih_id_seq"'::regclass);


--
-- TOC entry 2165 (class 2604 OID 42342)
-- Dependencies: 208 207 208
-- Name: oc_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ORDER_CUSTOMER" ALTER COLUMN oc_id SET DEFAULT nextval('"ORDER_CUSTOMER_oc_id_seq"'::regclass);


--
-- TOC entry 2167 (class 2604 OID 42368)
-- Dependencies: 211 212 212
-- Name: op_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ORDER_PROVIDER" ALTER COLUMN op_id SET DEFAULT nextval('"ORDER_PROVIDER_op_id_seq"'::regclass);


--
-- TOC entry 2174 (class 2604 OID 42469)
-- Dependencies: 226 225 226
-- Name: p_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PAYMENT" ALTER COLUMN p_id SET DEFAULT nextval('"PAYMENT_p_id_seq"'::regclass);


--
-- TOC entry 2159 (class 2604 OID 42235)
-- Dependencies: 194 193 194
-- Name: p_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PEOPLE" ALTER COLUMN p_id SET DEFAULT nextval('"PEOPLE_p_id_seq"'::regclass);


--
-- TOC entry 2156 (class 2604 OID 42098)
-- Dependencies: 178 179 179
-- Name: p_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT" ALTER COLUMN p_id SET DEFAULT nextval('"PRODUCT_p_id_seq"'::regclass);


--
-- TOC entry 2154 (class 2604 OID 42067)
-- Dependencies: 175 174 175
-- Name: pc_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY" ALTER COLUMN pc_id SET DEFAULT nextval('"PRODUCT_CATEGORY_pc_id_seq"'::regclass);


--
-- TOC entry 2155 (class 2604 OID 42080)
-- Dependencies: 176 177 177
-- Name: pca_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY_ATTRIBUTE" ALTER COLUMN pca_id SET DEFAULT nextval('"PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq"'::regclass);


--
-- TOC entry 2175 (class 2604 OID 42497)
-- Dependencies: 228 227 228
-- Name: pl_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST" ALTER COLUMN pl_id SET DEFAULT nextval('"PRODUCT_LIST_pl_id_seq"'::regclass);


--
-- TOC entry 2162 (class 2604 OID 42286)
-- Dependencies: 200 201 201
-- Name: p_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER" ALTER COLUMN p_id SET DEFAULT nextval('"PROVIDER_p_id_seq"'::regclass);


--
-- TOC entry 2164 (class 2604 OID 42319)
-- Dependencies: 204 205 205
-- Name: pcd_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER_CATEGORY_DETAILS" ALTER COLUMN pcd_id SET DEFAULT nextval('"PROVIDER_CATEGORY_DETAILS_pcd_id_seq"'::regclass);


--
-- TOC entry 2168 (class 2604 OID 42381)
-- Dependencies: 214 213 214
-- Name: p_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PURCHASE" ALTER COLUMN p_id SET DEFAULT nextval('"PURCHASE_p_id_seq"'::regclass);


--
-- TOC entry 2166 (class 2604 OID 42355)
-- Dependencies: 210 209 210
-- Name: s_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "SALE" ALTER COLUMN s_id SET DEFAULT nextval('"SALE_s_id_seq"'::regclass);


--
-- TOC entry 2177 (class 2604 OID 42548)
-- Dependencies: 231 232 232
-- Name: u_id; Type: DEFAULT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER" ALTER COLUMN u_id SET DEFAULT nextval('"USER_u_id_seq"'::regclass);


--
-- TOC entry 2353 (class 0 OID 42298)
-- Dependencies: 203 2387
-- Data for Name: ADDRESS_DETAIL; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "ADDRESS_DETAIL" (ad_id, ad_line1, ad_line, ad_town, ad_country, ad_description, ad_invoice_entity) FROM stdin;
\.


--
-- TOC entry 2416 (class 0 OID 0)
-- Dependencies: 202
-- Name: ADDRESS_DETAIL_ad_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"ADDRESS_DETAIL_ad_id_seq"', 1, false);


--
-- TOC entry 2374 (class 0 OID 42453)
-- Dependencies: 224 2387
-- Data for Name: BANK_ACCOUNT; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "BANK_ACCOUNT" (ba_id, ba_invoice_entity, ba_numer) FROM stdin;
\.


--
-- TOC entry 2417 (class 0 OID 0)
-- Dependencies: 223
-- Name: BANK_ACCOUNT_ba_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"BANK_ACCOUNT_ba_id_seq"', 1, false);


--
-- TOC entry 2338 (class 0 OID 42195)
-- Dependencies: 188 2387
-- Data for Name: BASKET; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "BASKET" (b_id) FROM stdin;
\.


--
-- TOC entry 2339 (class 0 OID 42200)
-- Dependencies: 189 2387
-- Data for Name: BASKET_LIST; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "BASKET_LIST" (bl_id, bl_basket, bl_product, bl_quantity) FROM stdin;
\.


--
-- TOC entry 2372 (class 0 OID 42435)
-- Dependencies: 222 2387
-- Data for Name: CARD; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "CARD" (c_id, c_invoice_entity, c_description, c_card_number, c_name, c_expire_date, c_issue_numer, c_vendor) FROM stdin;
\.


--
-- TOC entry 2370 (class 0 OID 42427)
-- Dependencies: 220 2387
-- Data for Name: CARD_VENDOR; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "CARD_VENDOR" (cv_id, cv_name) FROM stdin;
\.


--
-- TOC entry 2418 (class 0 OID 0)
-- Dependencies: 219
-- Name: CARD_VENDOR_cv_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"CARD_VENDOR_cv_id_seq"', 1, false);


--
-- TOC entry 2419 (class 0 OID 0)
-- Dependencies: 221
-- Name: CARD_c_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"CARD_c_id_seq"', 1, false);


--
-- TOC entry 2366 (class 0 OID 42391)
-- Dependencies: 216 2387
-- Data for Name: COMMERCIAL_TRANSACTION; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "COMMERCIAL_TRANSACTION" (ct_id, ct_purchase, ct_sale) FROM stdin;
\.


--
-- TOC entry 2420 (class 0 OID 0)
-- Dependencies: 215
-- Name: COMMERCIAL_TRANSACTION_ct_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"COMMERCIAL_TRANSACTION_ct_id_seq"', 1, false);


--
-- TOC entry 2323 (class 0 OID 42054)
-- Dependencies: 173 2387
-- Data for Name: COMPANY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "COMPANY" ("C_ID", "C_NAME", "C_DATE") FROM stdin;
\.


--
-- TOC entry 2340 (class 0 OID 42215)
-- Dependencies: 190 2387
-- Data for Name: COUNTRY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "COUNTRY" (c_id, c_name) FROM stdin;
\.


--
-- TOC entry 2347 (class 0 OID 42255)
-- Dependencies: 197 2387
-- Data for Name: COURIER; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "COURIER" (c_id, c_invoice_entity) FROM stdin;
\.


--
-- TOC entry 2421 (class 0 OID 0)
-- Dependencies: 196
-- Name: COURIER_c_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"COURIER_c_id_seq"', 1, false);


--
-- TOC entry 2336 (class 0 OID 42174)
-- Dependencies: 186 2387
-- Data for Name: CURRENCY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "CURRENCY" (c_id, c_name) FROM stdin;
1	GBP
2	EUR
3	USD
\.


--
-- TOC entry 2422 (class 0 OID 0)
-- Dependencies: 185
-- Name: CURRENCY_c_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"CURRENCY_c_id_seq"', 3, true);


--
-- TOC entry 2349 (class 0 OID 42268)
-- Dependencies: 199 2387
-- Data for Name: CUSTOMER; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "CUSTOMER" (c_id, c_customer_name, c_invoice_entity) FROM stdin;
\.


--
-- TOC entry 2384 (class 0 OID 42569)
-- Dependencies: 234 2387
-- Data for Name: CUSTOMER_CATEGORY_DETAILS; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "CUSTOMER_CATEGORY_DETAILS" (ccd_id, ccd_tax_rate, ccd_description) FROM stdin;
\.


--
-- TOC entry 2423 (class 0 OID 0)
-- Dependencies: 233
-- Name: CUSTOMER_CATEGORY_DETAILS_ccd_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"CUSTOMER_CATEGORY_DETAILS_ccd_id_seq"', 1, false);


--
-- TOC entry 2385 (class 0 OID 42575)
-- Dependencies: 235 2387
-- Data for Name: CUSTOMER_CATEGORY_LINK; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "CUSTOMER_CATEGORY_LINK" (ccl_category_details, ccl_customer) FROM stdin;
\.


--
-- TOC entry 2424 (class 0 OID 0)
-- Dependencies: 198
-- Name: CUSTOMER_c_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"CUSTOMER_c_id_seq"', 1, false);


--
-- TOC entry 2368 (class 0 OID 42409)
-- Dependencies: 218 2387
-- Data for Name: DELIVERY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "DELIVERY" (d_id, d_sale, d_tracking, d_weight, d_parts, d_courier) FROM stdin;
\.


--
-- TOC entry 2425 (class 0 OID 0)
-- Dependencies: 217
-- Name: DELIVERY_d_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"DELIVERY_d_id_seq"', 1, false);


--
-- TOC entry 2342 (class 0 OID 42222)
-- Dependencies: 192 2387
-- Data for Name: INVOICE_ENTITY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "INVOICE_ENTITY" (ie_id, ie_legal_id, ie_invoice_name) FROM stdin;
\.


--
-- TOC entry 2426 (class 0 OID 0)
-- Dependencies: 191
-- Name: INVOICE_ENTITY_ie_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"INVOICE_ENTITY_ie_id_seq"', 1, false);


--
-- TOC entry 2334 (class 0 OID 42162)
-- Dependencies: 184 2387
-- Data for Name: ITEM; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "ITEM" (i_id, i_product, i_commercial_id) FROM stdin;
\.


--
-- TOC entry 2380 (class 0 OID 42527)
-- Dependencies: 230 2387
-- Data for Name: ITEM_HISTORY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "ITEM_HISTORY" (ih_id, ih_item, ih_product_list, ih_date) FROM stdin;
\.


--
-- TOC entry 2427 (class 0 OID 0)
-- Dependencies: 229
-- Name: ITEM_HISTORY_ih_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"ITEM_HISTORY_ih_id_seq"', 1, false);


--
-- TOC entry 2322 (class 0 OID 42046)
-- Dependencies: 172 2387
-- Data for Name: LANGUAGE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "LANGUAGE" ("L_ID", "L_1", "L_2") FROM stdin;
\.


--
-- TOC entry 2358 (class 0 OID 42339)
-- Dependencies: 208 2387
-- Data for Name: ORDER_CUSTOMER; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "ORDER_CUSTOMER" (oc_id, od_customer, od_date) FROM stdin;
\.


--
-- TOC entry 2428 (class 0 OID 0)
-- Dependencies: 207
-- Name: ORDER_CUSTOMER_oc_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"ORDER_CUSTOMER_oc_id_seq"', 1, false);


--
-- TOC entry 2362 (class 0 OID 42365)
-- Dependencies: 212 2387
-- Data for Name: ORDER_PROVIDER; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "ORDER_PROVIDER" (op_id, op_provider, op_date) FROM stdin;
\.


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 211
-- Name: ORDER_PROVIDER_op_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"ORDER_PROVIDER_op_id_seq"', 1, false);


--
-- TOC entry 2376 (class 0 OID 42466)
-- Dependencies: 226 2387
-- Data for Name: PAYMENT; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PAYMENT" (p_id, p_card, p_amount, p_currency, p_date, p_commercial_transaction, p_bank, p_cash) FROM stdin;
\.


--
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 225
-- Name: PAYMENT_p_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PAYMENT_p_id_seq"', 1, false);


--
-- TOC entry 2344 (class 0 OID 42232)
-- Dependencies: 194 2387
-- Data for Name: PEOPLE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PEOPLE" (p_id, p_name, p_surname, p_invoice_entity) FROM stdin;
\.


--
-- TOC entry 2345 (class 0 OID 42243)
-- Dependencies: 195 2387
-- Data for Name: PEOPLE_REPONSIBILITY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PEOPLE_REPONSIBILITY" (pr_ref, pr_description, pr_people) FROM stdin;
\.


--
-- TOC entry 2431 (class 0 OID 0)
-- Dependencies: 193
-- Name: PEOPLE_p_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PEOPLE_p_id_seq"', 1, false);


--
-- TOC entry 2337 (class 0 OID 42180)
-- Dependencies: 187 2387
-- Data for Name: PRICES; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRICES" (p_id, p_date, p_product, p_status, p_currency, p_price) FROM stdin;
1	2013-05-17 22:56:34.990207+01	9	0	\N	222.000
2	2013-05-17 22:57:22.694697+01	9	1	\N	222.000
3	2013-05-17 23:00:06.271232+01	12	0	\N	145.000
5	2013-05-19 13:55:17.944733+01	12	0	\N	145.000
4	2013-05-18 02:38:37.139324+01	10	0	\N	85.000
7	2013-05-19 14:49:14.01915+01	10	1	1	85.000
6	2013-05-19 14:48:30.420584+01	12	1	1	145.000
8	2013-05-21 20:54:16.953122+01	11	1	\N	0.000
\.


--
-- TOC entry 2432 (class 0 OID 0)
-- Dependencies: 237
-- Name: PRICES_p_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PRICES_p_id_seq"', 8, true);


--
-- TOC entry 2329 (class 0 OID 42095)
-- Dependencies: 179 2387
-- Data for Name: PRODUCT; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRODUCT" (p_id, p_ref, p_description, p_long_description, p_category, p_image_path) FROM stdin;
1	P5Ka	Asus P5K Intel P45	Asus P5K Intel P45, AC97 audio, 2 lan 100Gb	\N	\N
2	p6ba	Asus Xeon prepared motherboard	audio 5.1, 2 lang gigabit	\N	\N
3	P8Ba	Asus P8Btt	Asus P8B Intel i3, i5, i7	\N	\N
4	p2baa	oooo77788	bbbbbbbbbb	\N	\N
5	ddr232mb	ddr2 32mb	ddr2	17	\N
8	dorsetmuesli	descript	\N	5	\N
9	intel core2 duo	Intel core2 processor		20	\N
12	i7 940	Intel i7 940	aaaaa	20	http://ipymeback/img/co_flying.gif
10	intel i5 5229	Intel i5 quad core	New inter i5 ivy bridge	20	http://ipymeback/img/37425698.jpg
11	i7 920	Intel i7 920	mmmmm	20	http://ipymeback/img/37425698.jpg
\.


--
-- TOC entry 2330 (class 0 OID 42111)
-- Dependencies: 180 2387
-- Data for Name: PRODUCT_ATTRIBUTE_VALUE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRODUCT_ATTRIBUTE_VALUE" (pav_product, pav_product_category_attribute, pav_value) FROM stdin;
5	12	SIZE
5	13	SPEED
5	16	BRAND
5	7	YES
8	3	OATS
12	15	4
12	16	INTEL
12	20	I7
12	21	3.4G
10	15	4
10	16	INTEL
10	20	I5
9	15	2
9	16	INTEL
9	20	CORE 2
11	15	4
11	16	INTEL
11	20	I7
\.


--
-- TOC entry 2325 (class 0 OID 42064)
-- Dependencies: 175 2387
-- Data for Name: PRODUCT_CATEGORY; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRODUCT_CATEGORY" (pc_id, pc_tax_rate, pc_description, pc_path) FROM stdin;
-1	0.000		 > ALL
1	0.000		 > food
2	0.000		 > food > vegetables
3	0.000		 > food > jars
4	0.000		 > food > frozen
5	0.000		 > food > breakfast
6	0.000		 > food > frozen > meat
7	0.000		 > food > frozen > fish
8	0.000		 > food > cupboard
9	0.000		 > food > cupboard > snacks
10	0.000		 > food > cupboard > snacks > nuts
11	0.000		 > food > cupboard > snacks > nuts > cashews
12	0.000		 > drinks
13	0.000		 > drinks > alcohol
14	0.000		 > PCHARDWARE
15	0.000		 > PCHARDWARE > COMPONENTS
16	0.000		 > PCHARDWARE > COMPONENTS > MEMORY
17	0.000		 > PCHARDWARE > COMPONENTS > MEMORY > DDR2
18	0.000		 > PCHARDWARE > COMPONENTS > MEMORY > DDR3
19	0.000		 > PCHARDWARE > COMPONENTS > MOTHERBOARD
20	0.000		 > PCHARDWARE > COMPONENTS > CPU
21	0.000		 > food > frozen > vegetables
\.


--
-- TOC entry 2327 (class 0 OID 42077)
-- Dependencies: 177 2387
-- Data for Name: PRODUCT_CATEGORY_ATTRIBUTE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRODUCT_CATEGORY_ATTRIBUTE" (pca_id, pca_product_category, pca_attribute) FROM stdin;
1	2	garden peas
2	5	corn
3	5	oats
4	2	carrots
5	2	spinach
6	2	green beans
7	14	RETAIL
16	14	BRAND
17	6	chicken
8	19	CHIPSET
9	19	LAN
10	19	WIFI
11	19	AUDIO
18	19	USB
19	19	FIREWIRE
12	16	SIZE
13	16	SPEED
15	20	CORES
20	20	FAMILY
21	20	SPEED
\.


--
-- TOC entry 2433 (class 0 OID 0)
-- Dependencies: 176
-- Name: PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PRODUCT_CATEGORY_ATTRIBUTE_pca_id_seq"', 21, true);


--
-- TOC entry 2434 (class 0 OID 0)
-- Dependencies: 174
-- Name: PRODUCT_CATEGORY_pc_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PRODUCT_CATEGORY_pc_id_seq"', 21, true);


--
-- TOC entry 2378 (class 0 OID 42494)
-- Dependencies: 228 2387
-- Data for Name: PRODUCT_LIST; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRODUCT_LIST" (pl_id, pl_order_customer, pl_order_provider, pl_product, pl_quantity, pl_price, pl_currency, pl_store, pl_quantity_dispatched) FROM stdin;
\.


--
-- TOC entry 2435 (class 0 OID 0)
-- Dependencies: 227
-- Name: PRODUCT_LIST_pl_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PRODUCT_LIST_pl_id_seq"', 1, false);


--
-- TOC entry 2436 (class 0 OID 0)
-- Dependencies: 178
-- Name: PRODUCT_p_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PRODUCT_p_id_seq"', 19, true);


--
-- TOC entry 2351 (class 0 OID 42283)
-- Dependencies: 201 2387
-- Data for Name: PROVIDER; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PROVIDER" (p_id, p_provider_name, p_invoice_entity) FROM stdin;
\.


--
-- TOC entry 2355 (class 0 OID 42316)
-- Dependencies: 205 2387
-- Data for Name: PROVIDER_CATEGORY_DETAILS; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PROVIDER_CATEGORY_DETAILS" (pcd_id, pcd_tax_rate, pcd_description) FROM stdin;
\.


--
-- TOC entry 2437 (class 0 OID 0)
-- Dependencies: 204
-- Name: PROVIDER_CATEGORY_DETAILS_pcd_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PROVIDER_CATEGORY_DETAILS_pcd_id_seq"', 1, false);


--
-- TOC entry 2356 (class 0 OID 42322)
-- Dependencies: 206 2387
-- Data for Name: PROVIDER_CATEGORY_LINK; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PROVIDER_CATEGORY_LINK" (pcl_provider, pcl_category_details) FROM stdin;
\.


--
-- TOC entry 2438 (class 0 OID 0)
-- Dependencies: 200
-- Name: PROVIDER_p_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PROVIDER_p_id_seq"', 1, false);


--
-- TOC entry 2364 (class 0 OID 42378)
-- Dependencies: 214 2387
-- Data for Name: PURCHASE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PURCHASE" (p_id, p_order_provider) FROM stdin;
\.


--
-- TOC entry 2439 (class 0 OID 0)
-- Dependencies: 213
-- Name: PURCHASE_p_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"PURCHASE_p_id_seq"', 1, false);


--
-- TOC entry 2360 (class 0 OID 42352)
-- Dependencies: 210 2387
-- Data for Name: SALE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "SALE" (s_id, s_order_customer) FROM stdin;
\.


--
-- TOC entry 2440 (class 0 OID 0)
-- Dependencies: 209
-- Name: SALE_s_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"SALE_s_id_seq"', 1, false);


--
-- TOC entry 2333 (class 0 OID 42144)
-- Dependencies: 183 2387
-- Data for Name: STOCK; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "STOCK" (s_id, s_product_id, s_store, s_quantity) FROM stdin;
\.


--
-- TOC entry 2332 (class 0 OID 42134)
-- Dependencies: 182 2387
-- Data for Name: STORE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "STORE" (s_id, s_store_type, s_store_name) FROM stdin;
\.


--
-- TOC entry 2331 (class 0 OID 42129)
-- Dependencies: 181 2387
-- Data for Name: STORE_TYPE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "STORE_TYPE" (st_id, st_description, st_in_out) FROM stdin;
\.


--
-- TOC entry 2382 (class 0 OID 42545)
-- Dependencies: 232 2387
-- Data for Name: USER; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "USER" (u_id, u_session, u_last_login, u_email, u_status, u_basket, u_customer, u_name, u_password_hash) FROM stdin;
222	33	2011-12-31 00:00:00+00	123	456	\N	\N	BBB	4ed61e15c9f84e9fc98ae553ff46010035aac24d
177	bqlup9j5bllktbfqiv2u1k6fa5	\N	ddddd	1	\N	\N	ddd	8e43bec6c9a4aba7dc358247a21ab52d301a2840
223	ge1toisq1veslpmqkb6c7o9ib6	\N	gonzalophp@gmail.com	1	\N	\N	gonzalo	8e43bec6c9a4aba7dc358247a21ab52d301a2840
\.


--
-- TOC entry 2441 (class 0 OID 0)
-- Dependencies: 231
-- Name: USER_u_id_seq; Type: SEQUENCE SET; Schema: IPYME_FINAL; Owner: postgres
--

SELECT pg_catalog.setval('"USER_u_id_seq"', 1, false);


--
-- TOC entry 2234 (class 2606 OID 42303)
-- Dependencies: 203 203 2388
-- Name: ADDRESS_DETAIL_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ADDRESS_DETAIL"
    ADD CONSTRAINT "ADDRESS_DETAIL_pkey" PRIMARY KEY (ad_id);


--
-- TOC entry 2256 (class 2606 OID 42458)
-- Dependencies: 224 224 2388
-- Name: BANK_ACCOUNT_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BANK_ACCOUNT"
    ADD CONSTRAINT "BANK_ACCOUNT_pkey" PRIMARY KEY (ba_id);


--
-- TOC entry 2212 (class 2606 OID 42204)
-- Dependencies: 189 189 2388
-- Name: BASKET_LIST_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BASKET_LIST"
    ADD CONSTRAINT "BASKET_LIST_pkey" PRIMARY KEY (bl_id);


--
-- TOC entry 2210 (class 2606 OID 42199)
-- Dependencies: 188 188 2388
-- Name: BASKET_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BASKET"
    ADD CONSTRAINT "BASKET_pkey" PRIMARY KEY (b_id);


--
-- TOC entry 2252 (class 2606 OID 42432)
-- Dependencies: 220 220 2388
-- Name: CARD_VENDOR_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CARD_VENDOR"
    ADD CONSTRAINT "CARD_VENDOR_pkey" PRIMARY KEY (cv_id);


--
-- TOC entry 2254 (class 2606 OID 42440)
-- Dependencies: 222 222 2388
-- Name: CARD_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CARD"
    ADD CONSTRAINT "CARD_pkey" PRIMARY KEY (c_id);


--
-- TOC entry 2248 (class 2606 OID 42396)
-- Dependencies: 216 216 2388
-- Name: COMMERCIAL_TRANSACTION_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COMMERCIAL_TRANSACTION"
    ADD CONSTRAINT "COMMERCIAL_TRANSACTION_pkey" PRIMARY KEY (ct_id);


--
-- TOC entry 2182 (class 2606 OID 42061)
-- Dependencies: 173 173 2388
-- Name: COMPANY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COMPANY"
    ADD CONSTRAINT "COMPANY_pkey" PRIMARY KEY ("C_ID");


--
-- TOC entry 2214 (class 2606 OID 42219)
-- Dependencies: 190 190 2388
-- Name: COUNTRY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COUNTRY"
    ADD CONSTRAINT "COUNTRY_pkey" PRIMARY KEY (c_id);


--
-- TOC entry 2224 (class 2606 OID 42260)
-- Dependencies: 197 197 2388
-- Name: COURIER_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COURIER"
    ADD CONSTRAINT "COURIER_pkey" PRIMARY KEY (c_id);


--
-- TOC entry 2206 (class 2606 OID 42179)
-- Dependencies: 186 186 2388
-- Name: CURRENCY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CURRENCY"
    ADD CONSTRAINT "CURRENCY_pkey" PRIMARY KEY (c_id);


--
-- TOC entry 2272 (class 2606 OID 42574)
-- Dependencies: 234 234 2388
-- Name: CUSTOMER_CATEGORY_DETAILS_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER_CATEGORY_DETAILS"
    ADD CONSTRAINT "CUSTOMER_CATEGORY_DETAILS_pkey" PRIMARY KEY (ccd_id);


--
-- TOC entry 2274 (class 2606 OID 42579)
-- Dependencies: 235 235 235 2388
-- Name: CUSTOMER_CATEGORY_LINK_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER_CATEGORY_LINK"
    ADD CONSTRAINT "CUSTOMER_CATEGORY_LINK_pkey" PRIMARY KEY (ccl_category_details, ccl_customer);


--
-- TOC entry 2226 (class 2606 OID 42273)
-- Dependencies: 199 199 2388
-- Name: CUSTOMER_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_pkey" PRIMARY KEY (c_id);


--
-- TOC entry 2250 (class 2606 OID 42414)
-- Dependencies: 218 218 2388
-- Name: DELIVERY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "DELIVERY"
    ADD CONSTRAINT "DELIVERY_pkey" PRIMARY KEY (d_id);


--
-- TOC entry 2216 (class 2606 OID 42229)
-- Dependencies: 192 192 2388
-- Name: INVOICE_ENTITY_ie_legal_id_key; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "INVOICE_ENTITY"
    ADD CONSTRAINT "INVOICE_ENTITY_ie_legal_id_key" UNIQUE (ie_legal_id);


--
-- TOC entry 2218 (class 2606 OID 42227)
-- Dependencies: 192 192 2388
-- Name: INVOICE_ENTITY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "INVOICE_ENTITY"
    ADD CONSTRAINT "INVOICE_ENTITY_pkey" PRIMARY KEY (ie_id);


--
-- TOC entry 2262 (class 2606 OID 42532)
-- Dependencies: 230 230 2388
-- Name: ITEM_HISTORY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ITEM_HISTORY"
    ADD CONSTRAINT "ITEM_HISTORY_pkey" PRIMARY KEY (ih_id);


--
-- TOC entry 2204 (class 2606 OID 42166)
-- Dependencies: 184 184 2388
-- Name: ITEM_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ITEM"
    ADD CONSTRAINT "ITEM_pkey" PRIMARY KEY (i_id);


--
-- TOC entry 2180 (class 2606 OID 42053)
-- Dependencies: 172 172 2388
-- Name: LANGUAGE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "LANGUAGE"
    ADD CONSTRAINT "LANGUAGE_pkey" PRIMARY KEY ("L_ID");


--
-- TOC entry 2240 (class 2606 OID 42344)
-- Dependencies: 208 208 2388
-- Name: ORDER_CUSTOMER_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ORDER_CUSTOMER"
    ADD CONSTRAINT "ORDER_CUSTOMER_pkey" PRIMARY KEY (oc_id);


--
-- TOC entry 2244 (class 2606 OID 42370)
-- Dependencies: 212 212 2388
-- Name: ORDER_PROVIDER_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ORDER_PROVIDER"
    ADD CONSTRAINT "ORDER_PROVIDER_pkey" PRIMARY KEY (op_id);


--
-- TOC entry 2258 (class 2606 OID 42471)
-- Dependencies: 226 226 2388
-- Name: PAYMENT_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PAYMENT"
    ADD CONSTRAINT "PAYMENT_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 2222 (class 2606 OID 42247)
-- Dependencies: 195 195 2388
-- Name: PEOPLE_REPONSIBILITY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PEOPLE_REPONSIBILITY"
    ADD CONSTRAINT "PEOPLE_REPONSIBILITY_pkey" PRIMARY KEY (pr_ref);


--
-- TOC entry 2220 (class 2606 OID 42237)
-- Dependencies: 194 194 2388
-- Name: PEOPLE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PEOPLE"
    ADD CONSTRAINT "PEOPLE_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 2208 (class 2606 OID 42184)
-- Dependencies: 187 187 2388
-- Name: PRICES_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRICES"
    ADD CONSTRAINT "PRICES_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 2188 (class 2606 OID 42085)
-- Dependencies: 177 177 2388
-- Name: PRODUCT_CATEGORY_ATTRIBUTE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY_ATTRIBUTE"
    ADD CONSTRAINT "PRODUCT_CATEGORY_ATTRIBUTE_pkey" PRIMARY KEY (pca_id);


--
-- TOC entry 2184 (class 2606 OID 42074)
-- Dependencies: 175 175 2388
-- Name: PRODUCT_CATEGORY_pc_path_key; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY"
    ADD CONSTRAINT "PRODUCT_CATEGORY_pc_path_key" UNIQUE (pc_path);


--
-- TOC entry 2186 (class 2606 OID 42072)
-- Dependencies: 175 175 2388
-- Name: PRODUCT_CATEGORY_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY"
    ADD CONSTRAINT "PRODUCT_CATEGORY_pkey" PRIMARY KEY (pc_id);


--
-- TOC entry 2260 (class 2606 OID 42499)
-- Dependencies: 228 228 2388
-- Name: PRODUCT_LIST_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST"
    ADD CONSTRAINT "PRODUCT_LIST_pkey" PRIMARY KEY (pl_id);


--
-- TOC entry 2192 (class 2606 OID 42105)
-- Dependencies: 179 179 2388
-- Name: PRODUCT_p_ref_key; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT"
    ADD CONSTRAINT "PRODUCT_p_ref_key" UNIQUE (p_ref);


--
-- TOC entry 2194 (class 2606 OID 42103)
-- Dependencies: 179 179 2388
-- Name: PRODUCT_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT"
    ADD CONSTRAINT "PRODUCT_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 2236 (class 2606 OID 42321)
-- Dependencies: 205 205 2388
-- Name: PROVIDER_CATEGORY_DETAILS_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER_CATEGORY_DETAILS"
    ADD CONSTRAINT "PROVIDER_CATEGORY_DETAILS_pkey" PRIMARY KEY (pcd_id);


--
-- TOC entry 2238 (class 2606 OID 42326)
-- Dependencies: 206 206 206 2388
-- Name: PROVIDER_CATEGORY_LINK_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER_CATEGORY_LINK"
    ADD CONSTRAINT "PROVIDER_CATEGORY_LINK_pkey" PRIMARY KEY (pcl_provider, pcl_category_details);


--
-- TOC entry 2230 (class 2606 OID 42288)
-- Dependencies: 201 201 2388
-- Name: PROVIDER_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER"
    ADD CONSTRAINT "PROVIDER_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 2246 (class 2606 OID 42383)
-- Dependencies: 214 214 2388
-- Name: PURCHASE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PURCHASE"
    ADD CONSTRAINT "PURCHASE_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 2242 (class 2606 OID 42357)
-- Dependencies: 210 210 2388
-- Name: SALE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "SALE"
    ADD CONSTRAINT "SALE_pkey" PRIMARY KEY (s_id);


--
-- TOC entry 2202 (class 2606 OID 42151)
-- Dependencies: 183 183 2388
-- Name: STOCK_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "STOCK"
    ADD CONSTRAINT "STOCK_pkey" PRIMARY KEY (s_id);


--
-- TOC entry 2198 (class 2606 OID 42133)
-- Dependencies: 181 181 2388
-- Name: STORE_TYPE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "STORE_TYPE"
    ADD CONSTRAINT "STORE_TYPE_pkey" PRIMARY KEY (st_id);


--
-- TOC entry 2200 (class 2606 OID 42138)
-- Dependencies: 182 182 2388
-- Name: STORE_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "STORE"
    ADD CONSTRAINT "STORE_pkey" PRIMARY KEY (s_id);


--
-- TOC entry 2264 (class 2606 OID 42550)
-- Dependencies: 232 232 2388
-- Name: USER_pkey; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY (u_id);


--
-- TOC entry 2266 (class 2606 OID 42554)
-- Dependencies: 232 232 2388
-- Name: USER_u_email_key; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER"
    ADD CONSTRAINT "USER_u_email_key" UNIQUE (u_email);


--
-- TOC entry 2268 (class 2606 OID 42556)
-- Dependencies: 232 232 2388
-- Name: USER_u_name_key; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER"
    ADD CONSTRAINT "USER_u_name_key" UNIQUE (u_name);


--
-- TOC entry 2270 (class 2606 OID 42552)
-- Dependencies: 232 232 2388
-- Name: USER_u_session_key; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER"
    ADD CONSTRAINT "USER_u_session_key" UNIQUE (u_session);


--
-- TOC entry 2196 (class 2606 OID 42118)
-- Dependencies: 180 180 180 2388
-- Name: pk_product_attribute_value; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_ATTRIBUTE_VALUE"
    ADD CONSTRAINT pk_product_attribute_value PRIMARY KEY (pav_product, pav_product_category_attribute);


--
-- TOC entry 2228 (class 2606 OID 42275)
-- Dependencies: 199 199 199 2388
-- Name: unique_customer_name_entity; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER"
    ADD CONSTRAINT unique_customer_name_entity UNIQUE (c_customer_name, c_invoice_entity);


--
-- TOC entry 2190 (class 2606 OID 42087)
-- Dependencies: 177 177 177 2388
-- Name: unique_product_category_attribute; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY_ATTRIBUTE"
    ADD CONSTRAINT unique_product_category_attribute UNIQUE (pca_product_category, pca_attribute);


--
-- TOC entry 2232 (class 2606 OID 42290)
-- Dependencies: 201 201 201 2388
-- Name: unique_provider_name_entity; Type: CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER"
    ADD CONSTRAINT unique_provider_name_entity UNIQUE (p_provider_name, p_invoice_entity);


--
-- TOC entry 2292 (class 2606 OID 42304)
-- Dependencies: 203 2213 190 2388
-- Name: ADDRESS_DETAIL_ad_country_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ADDRESS_DETAIL"
    ADD CONSTRAINT "ADDRESS_DETAIL_ad_country_fkey" FOREIGN KEY (ad_country) REFERENCES "COUNTRY"(c_id);


--
-- TOC entry 2293 (class 2606 OID 42309)
-- Dependencies: 203 2217 192 2388
-- Name: ADDRESS_DETAIL_ad_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ADDRESS_DETAIL"
    ADD CONSTRAINT "ADDRESS_DETAIL_ad_invoice_entity_fkey" FOREIGN KEY (ad_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2306 (class 2606 OID 42459)
-- Dependencies: 224 2217 192 2388
-- Name: BANK_ACCOUNT_ba_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BANK_ACCOUNT"
    ADD CONSTRAINT "BANK_ACCOUNT_ba_invoice_entity_fkey" FOREIGN KEY (ba_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2285 (class 2606 OID 42205)
-- Dependencies: 188 2209 189 2388
-- Name: BASKET_LIST_bl_basket_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BASKET_LIST"
    ADD CONSTRAINT "BASKET_LIST_bl_basket_fkey" FOREIGN KEY (bl_basket) REFERENCES "BASKET"(b_id);


--
-- TOC entry 2286 (class 2606 OID 42210)
-- Dependencies: 2193 179 189 2388
-- Name: BASKET_LIST_bl_product_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "BASKET_LIST"
    ADD CONSTRAINT "BASKET_LIST_bl_product_fkey" FOREIGN KEY (bl_product) REFERENCES "PRODUCT"(p_id);


--
-- TOC entry 2304 (class 2606 OID 42441)
-- Dependencies: 2217 222 192 2388
-- Name: CARD_c_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CARD"
    ADD CONSTRAINT "CARD_c_invoice_entity_fkey" FOREIGN KEY (c_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2305 (class 2606 OID 42446)
-- Dependencies: 2251 220 222 2388
-- Name: CARD_c_vendor_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CARD"
    ADD CONSTRAINT "CARD_c_vendor_fkey" FOREIGN KEY (c_vendor) REFERENCES "CARD_VENDOR"(cv_id);


--
-- TOC entry 2300 (class 2606 OID 42397)
-- Dependencies: 216 214 2245 2388
-- Name: COMMERCIAL_TRANSACTION_ct_purchase_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COMMERCIAL_TRANSACTION"
    ADD CONSTRAINT "COMMERCIAL_TRANSACTION_ct_purchase_fkey" FOREIGN KEY (ct_purchase) REFERENCES "PURCHASE"(p_id);


--
-- TOC entry 2301 (class 2606 OID 42402)
-- Dependencies: 2241 210 216 2388
-- Name: COMMERCIAL_TRANSACTION_ct_sale_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COMMERCIAL_TRANSACTION"
    ADD CONSTRAINT "COMMERCIAL_TRANSACTION_ct_sale_fkey" FOREIGN KEY (ct_sale) REFERENCES "SALE"(s_id);


--
-- TOC entry 2289 (class 2606 OID 42261)
-- Dependencies: 192 197 2217 2388
-- Name: COURIER_c_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "COURIER"
    ADD CONSTRAINT "COURIER_c_invoice_entity_fkey" FOREIGN KEY (c_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2320 (class 2606 OID 42580)
-- Dependencies: 2271 234 235 2388
-- Name: CUSTOMER_CATEGORY_LINK_ccl_category_details_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER_CATEGORY_LINK"
    ADD CONSTRAINT "CUSTOMER_CATEGORY_LINK_ccl_category_details_fkey" FOREIGN KEY (ccl_category_details) REFERENCES "CUSTOMER_CATEGORY_DETAILS"(ccd_id);


--
-- TOC entry 2321 (class 2606 OID 42585)
-- Dependencies: 199 2225 235 2388
-- Name: CUSTOMER_CATEGORY_LINK_ccl_customer_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER_CATEGORY_LINK"
    ADD CONSTRAINT "CUSTOMER_CATEGORY_LINK_ccl_customer_fkey" FOREIGN KEY (ccl_customer) REFERENCES "CUSTOMER"(c_id);


--
-- TOC entry 2290 (class 2606 OID 42276)
-- Dependencies: 2217 192 199 2388
-- Name: CUSTOMER_c_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "CUSTOMER"
    ADD CONSTRAINT "CUSTOMER_c_invoice_entity_fkey" FOREIGN KEY (c_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2303 (class 2606 OID 42420)
-- Dependencies: 218 2223 197 2388
-- Name: DELIVERY_d_courier_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "DELIVERY"
    ADD CONSTRAINT "DELIVERY_d_courier_fkey" FOREIGN KEY (d_courier) REFERENCES "COURIER"(c_id);


--
-- TOC entry 2302 (class 2606 OID 42415)
-- Dependencies: 218 210 2241 2388
-- Name: DELIVERY_d_sale_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "DELIVERY"
    ADD CONSTRAINT "DELIVERY_d_sale_fkey" FOREIGN KEY (d_sale) REFERENCES "SALE"(s_id);


--
-- TOC entry 2316 (class 2606 OID 42533)
-- Dependencies: 184 2203 230 2388
-- Name: ITEM_HISTORY_ih_item_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ITEM_HISTORY"
    ADD CONSTRAINT "ITEM_HISTORY_ih_item_fkey" FOREIGN KEY (ih_item) REFERENCES "ITEM"(i_id);


--
-- TOC entry 2317 (class 2606 OID 42538)
-- Dependencies: 2259 230 228 2388
-- Name: ITEM_HISTORY_ih_product_list_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ITEM_HISTORY"
    ADD CONSTRAINT "ITEM_HISTORY_ih_product_list_fkey" FOREIGN KEY (ih_product_list) REFERENCES "PRODUCT_LIST"(pl_id);


--
-- TOC entry 2282 (class 2606 OID 42167)
-- Dependencies: 179 184 2193 2388
-- Name: ITEM_i_product_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ITEM"
    ADD CONSTRAINT "ITEM_i_product_fkey" FOREIGN KEY (i_product) REFERENCES "PRODUCT"(p_id);


--
-- TOC entry 2296 (class 2606 OID 42345)
-- Dependencies: 2225 208 199 2388
-- Name: ORDER_CUSTOMER_od_customer_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ORDER_CUSTOMER"
    ADD CONSTRAINT "ORDER_CUSTOMER_od_customer_fkey" FOREIGN KEY (od_customer) REFERENCES "CUSTOMER"(c_id);


--
-- TOC entry 2298 (class 2606 OID 42371)
-- Dependencies: 2229 212 201 2388
-- Name: ORDER_PROVIDER_op_provider_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "ORDER_PROVIDER"
    ADD CONSTRAINT "ORDER_PROVIDER_op_provider_fkey" FOREIGN KEY (op_provider) REFERENCES "PROVIDER"(p_id);


--
-- TOC entry 2310 (class 2606 OID 42487)
-- Dependencies: 2255 224 226 2388
-- Name: PAYMENT_p_bank_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PAYMENT"
    ADD CONSTRAINT "PAYMENT_p_bank_fkey" FOREIGN KEY (p_bank) REFERENCES "BANK_ACCOUNT"(ba_id);


--
-- TOC entry 2307 (class 2606 OID 42472)
-- Dependencies: 222 226 2253 2388
-- Name: PAYMENT_p_card_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PAYMENT"
    ADD CONSTRAINT "PAYMENT_p_card_fkey" FOREIGN KEY (p_card) REFERENCES "CARD"(c_id);


--
-- TOC entry 2309 (class 2606 OID 42482)
-- Dependencies: 2247 226 216 2388
-- Name: PAYMENT_p_commercial_transaction_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PAYMENT"
    ADD CONSTRAINT "PAYMENT_p_commercial_transaction_fkey" FOREIGN KEY (p_commercial_transaction) REFERENCES "COMMERCIAL_TRANSACTION"(ct_id);


--
-- TOC entry 2308 (class 2606 OID 42477)
-- Dependencies: 226 2205 186 2388
-- Name: PAYMENT_p_currency_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PAYMENT"
    ADD CONSTRAINT "PAYMENT_p_currency_fkey" FOREIGN KEY (p_currency) REFERENCES "CURRENCY"(c_id);


--
-- TOC entry 2288 (class 2606 OID 42248)
-- Dependencies: 194 195 2219 2388
-- Name: PEOPLE_REPONSIBILITY_pr_people_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PEOPLE_REPONSIBILITY"
    ADD CONSTRAINT "PEOPLE_REPONSIBILITY_pr_people_fkey" FOREIGN KEY (pr_people) REFERENCES "PEOPLE"(p_id);


--
-- TOC entry 2287 (class 2606 OID 42238)
-- Dependencies: 2217 192 194 2388
-- Name: PEOPLE_p_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PEOPLE"
    ADD CONSTRAINT "PEOPLE_p_invoice_entity_fkey" FOREIGN KEY (p_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2284 (class 2606 OID 42190)
-- Dependencies: 186 187 2205 2388
-- Name: PRICES_p_currency_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRICES"
    ADD CONSTRAINT "PRICES_p_currency_fkey" FOREIGN KEY (p_currency) REFERENCES "CURRENCY"(c_id);


--
-- TOC entry 2283 (class 2606 OID 42185)
-- Dependencies: 2193 187 179 2388
-- Name: PRICES_p_product_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRICES"
    ADD CONSTRAINT "PRICES_p_product_fkey" FOREIGN KEY (p_product) REFERENCES "PRODUCT"(p_id);


--
-- TOC entry 2278 (class 2606 OID 42124)
-- Dependencies: 177 180 2187 2388
-- Name: PRODUCT_ATTRIBUTE_VALUE_pav_product_category_attribute_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_ATTRIBUTE_VALUE"
    ADD CONSTRAINT "PRODUCT_ATTRIBUTE_VALUE_pav_product_category_attribute_fkey" FOREIGN KEY (pav_product_category_attribute) REFERENCES "PRODUCT_CATEGORY_ATTRIBUTE"(pca_id) ON DELETE CASCADE;


--
-- TOC entry 2277 (class 2606 OID 42119)
-- Dependencies: 2193 179 180 2388
-- Name: PRODUCT_ATTRIBUTE_VALUE_pav_product_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_ATTRIBUTE_VALUE"
    ADD CONSTRAINT "PRODUCT_ATTRIBUTE_VALUE_pav_product_fkey" FOREIGN KEY (pav_product) REFERENCES "PRODUCT"(p_id) ON DELETE CASCADE;


--
-- TOC entry 2275 (class 2606 OID 42088)
-- Dependencies: 175 177 2185 2388
-- Name: PRODUCT_CATEGORY_ATTRIBUTE_pca_product_category_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_CATEGORY_ATTRIBUTE"
    ADD CONSTRAINT "PRODUCT_CATEGORY_ATTRIBUTE_pca_product_category_fkey" FOREIGN KEY (pca_product_category) REFERENCES "PRODUCT_CATEGORY"(pc_id) ON DELETE CASCADE;


--
-- TOC entry 2314 (class 2606 OID 42515)
-- Dependencies: 186 228 2205 2388
-- Name: PRODUCT_LIST_pl_currency_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST"
    ADD CONSTRAINT "PRODUCT_LIST_pl_currency_fkey" FOREIGN KEY (pl_currency) REFERENCES "CURRENCY"(c_id);


--
-- TOC entry 2311 (class 2606 OID 42500)
-- Dependencies: 208 228 2239 2388
-- Name: PRODUCT_LIST_pl_order_customer_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST"
    ADD CONSTRAINT "PRODUCT_LIST_pl_order_customer_fkey" FOREIGN KEY (pl_order_customer) REFERENCES "ORDER_CUSTOMER"(oc_id);


--
-- TOC entry 2312 (class 2606 OID 42505)
-- Dependencies: 212 2243 228 2388
-- Name: PRODUCT_LIST_pl_order_provider_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST"
    ADD CONSTRAINT "PRODUCT_LIST_pl_order_provider_fkey" FOREIGN KEY (pl_order_provider) REFERENCES "ORDER_PROVIDER"(op_id);


--
-- TOC entry 2313 (class 2606 OID 42510)
-- Dependencies: 179 2193 228 2388
-- Name: PRODUCT_LIST_pl_product_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST"
    ADD CONSTRAINT "PRODUCT_LIST_pl_product_fkey" FOREIGN KEY (pl_product) REFERENCES "PRODUCT"(p_id);


--
-- TOC entry 2315 (class 2606 OID 42520)
-- Dependencies: 2199 182 228 2388
-- Name: PRODUCT_LIST_pl_store_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT_LIST"
    ADD CONSTRAINT "PRODUCT_LIST_pl_store_fkey" FOREIGN KEY (pl_store) REFERENCES "STORE"(s_id);


--
-- TOC entry 2276 (class 2606 OID 42106)
-- Dependencies: 179 175 2185 2388
-- Name: PRODUCT_p_category_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PRODUCT"
    ADD CONSTRAINT "PRODUCT_p_category_fkey" FOREIGN KEY (p_category) REFERENCES "PRODUCT_CATEGORY"(pc_id);


--
-- TOC entry 2295 (class 2606 OID 42332)
-- Dependencies: 2235 206 205 2388
-- Name: PROVIDER_CATEGORY_LINK_pcl_category_details_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER_CATEGORY_LINK"
    ADD CONSTRAINT "PROVIDER_CATEGORY_LINK_pcl_category_details_fkey" FOREIGN KEY (pcl_category_details) REFERENCES "PROVIDER_CATEGORY_DETAILS"(pcd_id);


--
-- TOC entry 2294 (class 2606 OID 42327)
-- Dependencies: 201 2229 206 2388
-- Name: PROVIDER_CATEGORY_LINK_pcl_provider_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER_CATEGORY_LINK"
    ADD CONSTRAINT "PROVIDER_CATEGORY_LINK_pcl_provider_fkey" FOREIGN KEY (pcl_provider) REFERENCES "PROVIDER"(p_id);


--
-- TOC entry 2291 (class 2606 OID 42291)
-- Dependencies: 192 2217 201 2388
-- Name: PROVIDER_p_invoice_entity_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PROVIDER"
    ADD CONSTRAINT "PROVIDER_p_invoice_entity_fkey" FOREIGN KEY (p_invoice_entity) REFERENCES "INVOICE_ENTITY"(ie_id);


--
-- TOC entry 2299 (class 2606 OID 42384)
-- Dependencies: 214 212 2243 2388
-- Name: PURCHASE_p_order_provider_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "PURCHASE"
    ADD CONSTRAINT "PURCHASE_p_order_provider_fkey" FOREIGN KEY (p_order_provider) REFERENCES "ORDER_PROVIDER"(op_id);


--
-- TOC entry 2297 (class 2606 OID 42358)
-- Dependencies: 2239 208 210 2388
-- Name: SALE_s_order_customer_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "SALE"
    ADD CONSTRAINT "SALE_s_order_customer_fkey" FOREIGN KEY (s_order_customer) REFERENCES "ORDER_CUSTOMER"(oc_id);


--
-- TOC entry 2280 (class 2606 OID 42152)
-- Dependencies: 2193 183 179 2388
-- Name: STOCK_s_product_id_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "STOCK"
    ADD CONSTRAINT "STOCK_s_product_id_fkey" FOREIGN KEY (s_product_id) REFERENCES "PRODUCT"(p_id);


--
-- TOC entry 2281 (class 2606 OID 42157)
-- Dependencies: 2199 183 182 2388
-- Name: STOCK_s_store_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "STOCK"
    ADD CONSTRAINT "STOCK_s_store_fkey" FOREIGN KEY (s_store) REFERENCES "STORE"(s_id);


--
-- TOC entry 2279 (class 2606 OID 42139)
-- Dependencies: 2197 181 182 2388
-- Name: STORE_s_store_type_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "STORE"
    ADD CONSTRAINT "STORE_s_store_type_fkey" FOREIGN KEY (s_store_type) REFERENCES "STORE_TYPE"(st_id);


--
-- TOC entry 2318 (class 2606 OID 42557)
-- Dependencies: 2209 188 232 2388
-- Name: USER_u_basket_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER"
    ADD CONSTRAINT "USER_u_basket_fkey" FOREIGN KEY (u_basket) REFERENCES "BASKET"(b_id);


--
-- TOC entry 2319 (class 2606 OID 42562)
-- Dependencies: 199 2225 232 2388
-- Name: USER_u_customer_fkey; Type: FK CONSTRAINT; Schema: IPYME_FINAL; Owner: postgres
--

ALTER TABLE ONLY "USER"
    ADD CONSTRAINT "USER_u_customer_fkey" FOREIGN KEY (u_customer) REFERENCES "CUSTOMER"(c_id);


-- Completed on 2013-05-22 23:22:16 BST

--
-- PostgreSQL database dump complete
--

