--\o /dev/null

DROP SCHEMA "IPYME_AUX" CASCADE;
CREATE SCHEMA "IPYME_AUX";

GRANT ALL ON SCHEMA "IPYME_AUX" TO postgres;

\set ON_ERROR_STOP true;

CREATE TABLE "IPYME_AUX"."LANGUAGE" (
    "L_ID" NUMERIC PRIMARY KEY
    , "L_1" VARCHAR(255)
    , "L_2" VARCHAR(255));

CREATE TABLE "IPYME_AUX"."COMPANY" (
    "C_ID" NUMERIC PRIMARY KEY
    , "C_NAME" VARCHAR(255)
    , "C_DATE" TIMESTAMP WITH TIME ZONE);

CREATE TABLE "IPYME_AUX"."PRODUCT_CATEGORY" (
    PC_ID BIGSERIAL PRIMARY KEY,
    PC_TAX_RATE NUMERIC(8,3),
    PC_DESCRIPTION TEXT,
    PC_PATH TEXT UNIQUE
);

CREATE TABLE "IPYME_AUX"."PRODUCT_CATEGORY_ATTRIBUTE" (
    PCA_ID BIGSERIAL PRIMARY KEY,
    PCA_PRODUCT_CATEGORY BIGINT NOT NULL REFERENCES "IPYME_AUX"."PRODUCT_CATEGORY" ON DELETE CASCADE,
    PCA_ATTRIBUTE TEXT NOT NULL,
    CONSTRAINT unique_product_category_attribute UNIQUE(PCA_PRODUCT_CATEGORY, PCA_ATTRIBUTE)
);

CREATE TABLE "IPYME_AUX"."PRODUCT" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_REF VARCHAR(45) UNIQUE NOT NULL
    , P_DESCRIPTION VARCHAR(255)
    , P_LONG_DESCRIPTION VARCHAR(255)
    , P_IMAGE_PATH TEXT
    , P_CATEGORY BIGINT REFERENCES "IPYME_AUX"."PRODUCT_CATEGORY"
);

CREATE TABLE "IPYME_AUX"."PRODUCT_ATTRIBUTE_VALUE" (
    PAV_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT" ON DELETE CASCADE,
    PAV_PRODUCT_CATEGORY_ATTRIBUTE BIGINT REFERENCES "IPYME_AUX"."PRODUCT_CATEGORY_ATTRIBUTE" ON DELETE CASCADE,
    PAV_VALUE TEXT NOT NULL,
    CONSTRAINT pk_product_attribute_value PRIMARY KEY(PAV_PRODUCT, PAV_PRODUCT_CATEGORY_ATTRIBUTE)
);

CREATE TABLE "IPYME_AUX"."STORE_TYPE" (
    ST_ID INT PRIMARY KEY
    , ST_DESCRIPTION VARCHAR(255)
    , ST_IN_OUT BOOLEAN
);

CREATE TABLE "IPYME_AUX"."STORE" (
    S_ID INT PRIMARY KEY
    , S_STORE_TYPE INT REFERENCES "IPYME_AUX"."STORE_TYPE"
    , S_STORE_NAME VARCHAR(100)
);



CREATE TABLE "IPYME_AUX"."STOCK" (
    S_ID BIGINT PRIMARY KEY
    , S_PRODUCT_ID BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , S_STORE INT REFERENCES "IPYME_AUX"."STORE"
    , S_QUANTITY NUMERIC
);

CREATE TABLE "IPYME_AUX"."ITEM" (
    I_ID BIGINT PRIMARY KEY
    ,I_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , I_COMMERCIAL_ID VARCHAR(50)
);

CREATE TABLE "IPYME_AUX"."CURRENCY" (
    C_ID SERIAL PRIMARY KEY
    , C_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PRICES" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_PRICE NUMERIC(8,3)
    , P_DATE TIMESTAMP WITH TIME ZONE
    , P_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , P_STATUS INT
    , P_CURRENCY INT REFERENCES "IPYME_AUX"."CURRENCY"
);

CREATE TABLE "IPYME_AUX"."BASKET" (
    B_ID BIGINT PRIMARY KEY
);

CREATE TABLE "IPYME_AUX"."BASKET_LIST" (
    BL_ID BIGINT PRIMARY KEY
    , BL_BASKET BIGINT REFERENCES "IPYME_AUX"."BASKET"
    , BL_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , BL_QUANTITY INT
);

CREATE TABLE "IPYME_AUX"."COUNTRY" (
    C_ID INT PRIMARY KEY
    , C_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."INVOICE_ENTITY" (
    IE_ID BIGSERIAL PRIMARY KEY
    , IE_LEGAL_ID VARCHAR(100) UNIQUE
    , IE_INVOICE_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PEOPLE" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_NAME VARCHAR(100)
    , P_SURNAME VARCHAR(100)
    , P_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
);

CREATE TABLE "IPYME_AUX"."PEOPLE_REPONSIBILITY" (
    PR_REF VARCHAR(50) PRIMARY KEY
    , PR_DESCRIPTION VARCHAR(100) 
    , PR_PEOPLE BIGINT REFERENCES "IPYME_AUX"."PEOPLE"
);

CREATE TABLE "IPYME_AUX"."COURIER" (
    C_ID BIGSERIAL PRIMARY KEY
    , C_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
);

CREATE TABLE "IPYME_AUX"."CUSTOMER" (
    C_ID BIGSERIAL PRIMARY KEY
    , C_CUSTOMER_NAME VARCHAR(100)
    , C_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
    , CONSTRAINT unique_customer_name_entity UNIQUE(C_CUSTOMER_NAME, C_INVOICE_ENTITY)
);

CREATE TABLE "IPYME_AUX"."PROVIDER" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_PROVIDER_NAME VARCHAR(100)
    , P_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
    , CONSTRAINT unique_provider_name_entity UNIQUE(P_PROVIDER_NAME, P_INVOICE_ENTITY)
);

CREATE TABLE "IPYME_AUX"."ADDRESS_DETAIL" (
    AD_ID BIGSERIAL PRIMARY KEY
    , AD_LINE1 VARCHAR(100)
    , AD_LINE VARCHAR(100)
    , AD_TOWN VARCHAR(100)
    , AD_COUNTRY INT REFERENCES "IPYME_AUX"."COUNTRY"
    , AD_DESCRIPTION VARCHAR(100)
    , AD_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
);

CREATE TABLE "IPYME_AUX"."PROVIDER_CATEGORY_DETAILS" (
    PCD_ID BIGSERIAL PRIMARY KEY
    , PCD_TAX_RATE NUMERIC(8,3)
    ,PCD_DESCRIPTION VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."PROVIDER_CATEGORY_LINK" (
    PCL_PROVIDER BIGINT REFERENCES "IPYME_AUX"."PROVIDER"
    , PCL_CATEGORY_DETAILS BIGINT REFERENCES "IPYME_AUX"."PROVIDER_CATEGORY_DETAILS"
    , PRIMARY KEY (PCL_PROVIDER, PCL_CATEGORY_DETAILS)
);

CREATE TABLE "IPYME_AUX"."ORDER_CUSTOMER" (
    OC_ID BIGSERIAL PRIMARY KEY
    , OD_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , OD_DATE TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "IPYME_AUX"."SALE" (
    S_ID BIGSERIAL PRIMARY KEY
    , S_ORDER_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."ORDER_CUSTOMER"
);

CREATE TABLE "IPYME_AUX"."ORDER_PROVIDER" (
    OP_ID BIGSERIAL PRIMARY KEY
    , OP_PROVIDER BIGINT REFERENCES "IPYME_AUX"."PROVIDER"
    , OP_DATE TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "IPYME_AUX"."PURCHASE" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_ORDER_PROVIDER BIGINT REFERENCES "IPYME_AUX"."ORDER_PROVIDER"
);

CREATE TABLE "IPYME_AUX"."COMMERCIAL_TRANSACTION" (
    CT_ID BIGSERIAL PRIMARY KEY
    ,CT_PURCHASE BIGINT REFERENCES "IPYME_AUX"."PURCHASE"
    ,CT_SALE BIGINT REFERENCES "IPYME_AUX"."SALE"
);

CREATE TABLE "IPYME_AUX"."DELIVERY" (
    D_ID BIGSERIAL PRIMARY KEY
    , D_SALE BIGINT REFERENCES "IPYME_AUX"."SALE"
    , D_TRACKING VARCHAR(100)
    , D_WEIGHT NUMERIC(5,3)
    , D_PARTS INT
    , D_COURIER BIGINT REFERENCES "IPYME_AUX"."COURIER"
);

CREATE TABLE "IPYME_AUX"."CARD_VENDOR" (
    CV_ID SERIAL PRIMARY KEY
    , CV_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."CARD" (
    C_ID BIGSERIAL PRIMARY KEY
    , C_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
    , C_DESCRIPTION VARCHAR(100)
    , C_CARD_NUMBER VARCHAR(20)
    , C_NAME VARCHAR(100)
    , C_EXPIRE_DATE VARCHAR(8)
    , C_ISSUE_NUMER VARCHAR(20)
    , C_VENDOR INT REFERENCES "IPYME_AUX"."CARD_VENDOR"
);

CREATE TABLE "IPYME_AUX"."BANK_ACCOUNT" (
    BA_ID BIGSERIAL PRIMARY KEY
    , BA_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
    , BA_NUMER VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PAYMENT" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_CARD BIGINT REFERENCES "IPYME_AUX"."CARD"
    , P_AMOUNT NUMERIC(8,3)
    , P_CURRENCY INT REFERENCES "IPYME_AUX"."CURRENCY"
    , P_DATE TIMESTAMP WITH TIME ZONE
    , P_COMMERCIAL_TRANSACTION BIGINT REFERENCES "IPYME_AUX"."COMMERCIAL_TRANSACTION"
    , P_BANK BIGINT REFERENCES "IPYME_AUX"."BANK_ACCOUNT"
    , P_CASH BOOLEAN
);

CREATE TABLE "IPYME_AUX"."PRODUCT_LIST" (
    PL_ID BIGSERIAL PRIMARY KEY
    , PL_ORDER_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."ORDER_CUSTOMER"
    , PL_ORDER_PROVIDER BIGINT REFERENCES "IPYME_AUX"."ORDER_PROVIDER"
    , PL_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , PL_QUANTITY NUMERIC(5,3)
    , PL_PRICE NUMERIC(8,3)
    , PL_CURRENCY INT REFERENCES "IPYME_AUX"."CURRENCY"
    , PL_STORE INT REFERENCES "IPYME_AUX"."STORE"
    , PL_QUANTITY_DISPATCHED NUMERIC(5,3)
);


CREATE TABLE "IPYME_AUX"."ITEM_HISTORY" (
    IH_ID BIGSERIAL PRIMARY KEY 
    , IH_ITEM BIGINT REFERENCES "IPYME_AUX"."ITEM"
    , IH_PRODUCT_LIST BIGINT REFERENCES "IPYME_AUX"."PRODUCT_LIST"
    , IH_DATE TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "IPYME_AUX"."USER" (
    U_ID BIGSERIAL PRIMARY KEY
    , U_SESSION VARCHAR(100) UNIQUE
    , U_LAST_LOGIN TIMESTAMP WITH TIME ZONE
    , U_EMAIL VARCHAR(200) UNIQUE
    , U_STATUS INT
    , U_BASKET BIGINT REFERENCES "IPYME_AUX"."BASKET"
    , U_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , U_NAME VARCHAR(30) UNIQUE NOT NULL
    , U_PASSWORD_HASH VARCHAR(100) NOT NULL
);

CREATE TABLE "IPYME_AUX"."CUSTOMER_CATEGORY_DETAILS" (
    CCD_ID BIGSERIAL PRIMARY KEY
    , CCD_TAX_RATE NUMERIC(8,3)
    , CCD_DESCRIPTION VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."CUSTOMER_CATEGORY_LINK" (
    CCL_CATEGORY_DETAILS BIGINT REFERENCES "IPYME_AUX"."CUSTOMER_CATEGORY_DETAILS"
    , CCL_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , PRIMARY KEY (CCL_CATEGORY_DETAILS, CCL_CUSTOMER)
);














CREATE OR REPLACE VIEW "IPYME_AUX".attribute_value_related AS 
SELECT "PRODUCT_CATEGORY_ATTRIBUTE".pca_id
    , "PRODUCT_CATEGORY_ATTRIBUTE".pca_product_category
    , "PRODUCT_CATEGORY_ATTRIBUTE".pca_attribute
    , "PRODUCT_ATTRIBUTE_VALUE".pav_product
    , "PRODUCT_ATTRIBUTE_VALUE".pav_product_category_attribute
    , "PRODUCT_ATTRIBUTE_VALUE".pav_value
FROM "IPYME_AUX"."PRODUCT_CATEGORY_ATTRIBUTE"
LEFT JOIN "IPYME_AUX"."PRODUCT_ATTRIBUTE_VALUE" 
ON "PRODUCT_ATTRIBUTE_VALUE".pav_product_category_attribute = "PRODUCT_CATEGORY_ATTRIBUTE".pca_id;






SET search_path = "IPYME_AUX", pg_catalog;

COPY "USER" (u_session, u_last_login, u_email, u_status, u_basket, u_customer, u_name, u_password_hash, u_id) FROM stdin;
33	2011-12-31 00:00:00+00	123	456	\N	\N	BBB	4ed61e15c9f84e9fc98ae553ff46010035aac24d	222
9od4p5ehecs9ne451ea0fgnv60	\N	gonzalophp@gmail.com	1	\N	\N	gonzalo	8e43bec6c9a4aba7dc358247a21ab52d301a2840	223
bqlup9j5bllktbfqiv2u1k6fa5	\N	ddddd	1	\N	\N	ddd	8e43bec6c9a4aba7dc358247a21ab52d301a2840	177
\.

COPY "PRODUCT" (p_ref, p_description, p_long_description) FROM stdin;
P5Ka	Asus P5K Intel P45	Asus P5K Intel P45, AC97 audio, 2 lan 100Gb	
p6ba	Asus Xeon prepared motherboard	audio 5.1, 2 lang gigabit	
P8Ba	Asus P8Btt	Asus P8B Intel i3, i5, i7	
p2baa	oooo77788	bbbbbbbbbb	
\.

COPY "CURRENCY" (C_NAME) FROM stdin;
GBP
EUR
USD
\.

COPY "PRODUCT_CATEGORY" (pc_id, pc_tax_rate, pc_description, pc_path) FROM stdin;
-1	0.000		 > ALL
\.
COPY "PRODUCT_CATEGORY" (pc_tax_rate, pc_description, pc_path) FROM stdin;
0.000		 > food
0.000		 > food > vegetables
0.000		 > food > jars
0.000		 > food > frozen
0.000		 > food > breakfast
0.000		 > food > frozen > meat
0.000		 > food > frozen > fish
0.000		 > food > cupboard
0.000		 > food > cupboard > snacks
0.000		 > food > cupboard > snacks > nuts
0.000		 > food > cupboard > snacks > nuts > cashews
0.000		 > drinks
0.000		 > drinks > alcohol
0.000		 > PCHARDWARE
0.000		 > PCHARDWARE > COMPONENTS
0.000		 > PCHARDWARE > COMPONENTS > MEMORY
0.000		 > PCHARDWARE > COMPONENTS > MEMORY > DDR2
0.000		 > PCHARDWARE > COMPONENTS > MEMORY > DDR3
0.000		 > PCHARDWARE > COMPONENTS > MOTHERBOARD
0.000		 > PCHARDWARE > COMPONENTS > CPU
0.000		 > food > frozen > vegetables
\.


--
-- TOC entry 2114 (class 0 OID 31711)
-- Dependencies: 180 2115
-- Data for Name: PRODUCT_CATEGORY_ATTRIBUTE; Type: TABLE DATA; Schema: IPYME_FINAL; Owner: postgres
--

COPY "PRODUCT_CATEGORY_ATTRIBUTE" (pca_product_category, pca_attribute) FROM stdin;
2	garden peas
5	corn
5	oats
2	carrots
2	spinach
2	green beans
14	RETAIL
19	CHIPSET
19	LAN
19	WIFI
19	AUDIO
16	SIZE
16	SPEED
16	ECC
20	CORES
14	BRAND
6	chicken
\.




DROP SCHEMA "IPYME_FINAL" CASCADE;

ALTER SCHEMA "IPYME_AUX" RENAME TO "IPYME_FINAL";



-- Function: "IPYME_FINAL".delete_customer(bigint)

-- DROP FUNCTION "IPYME_FINAL".delete_customer(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".delete_customer(IN p_c_id bigint)
  RETURNS TABLE(c_id bigint, c_customer_name character varying, c_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".delete_customer(bigint)
  OWNER TO postgres;



-- Function: "IPYME_FINAL".delete_product(bigint)

-- DROP FUNCTION "IPYME_FINAL".delete_product(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".delete_product(p_p_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT" AS
$BODY$
DECLARE
v_row_product "IPYME_FINAL"."PRODUCT"%ROWTYPE;
BEGIN
	--
	SELECT P.p_id
				,P.p_ref
				,P.p_description
				,P.p_long_description
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
											,v_row_product.p_long_description;
		--
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".delete_product(bigint)
  OWNER TO postgres;



-- Function: "IPYME_FINAL".delete_provider(bigint)

-- DROP FUNCTION "IPYME_FINAL".delete_provider(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".delete_provider(IN p_p_id bigint)
  RETURNS TABLE(p_id bigint, p_provider_name character varying, p_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".delete_provider(bigint)
  OWNER TO postgres;


-- Function: "IPYME_FINAL".get_customer(bigint)

-- DROP FUNCTION "IPYME_FINAL".get_customer(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_customer(IN p_c_id bigint)
  RETURNS TABLE(c_id bigint, c_customer_name character varying, c_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".get_customer(bigint)
  OWNER TO postgres;



create type "IPYME_FINAL"."get_product" as ( p_id bigint
                                            ,p_ref character varying(45)
                                            ,p_description character varying(255)
                                            ,p_long_description character varying(255)
                                            ,p_category bigint
                                            ,p_category_name text);

  

CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product(p_p_id bigint)
  RETURNS SETOF "IPYME_FINAL"."get_product" AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY SELECT P.p_id
											,P.p_ref
											,P.p_description
											,P.p_long_description
											,P.p_category
											,substr(PC.pc_path,length(PC.pc_path)-strpos(reverse(PC.pc_path),' > ')+2) AS p_category_name
								FROM "IPYME_FINAL"."PRODUCT" P
								JOIN "IPYME_FINAL"."PRODUCT_CATEGORY" PC
								ON P.p_category = PC.pc_id
								WHERE P.p_id = p_p_id
									OR p_p_id IS NULL;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


-- Function: "IPYME_FINAL".get_provider(bigint)

-- DROP FUNCTION "IPYME_FINAL".get_provider(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_provider(IN p_p_id bigint)
  RETURNS TABLE(p_id bigint, p_provider_name character varying, p_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".get_provider(bigint)
  OWNER TO postgres;


-- Function: "IPYME_FINAL".set_customer(bigint, character varying, bigint, character varying, character varying)

-- DROP FUNCTION "IPYME_FINAL".set_customer(bigint, character varying, bigint, character varying, character varying);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_customer(IN p_c_id bigint, IN p_c_customer_name character varying, IN p_ie_id bigint, IN p_ie_legal_id character varying, IN p_ie_invoice_name character varying)
  RETURNS TABLE(c_id bigint, c_customer_name character varying, c_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".set_customer(bigint, character varying, bigint, character varying, character varying)
  OWNER TO postgres;


-- Function: "IPYME_FINAL".set_product(bigint, character varying, character varying, character varying, numeric, character varying)

-- DROP FUNCTION "IPYME_FINAL".set_product(bigint, character varying, character varying, character varying, numeric, character varying);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_product(p_p_id bigint, p_p_ref character varying, p_p_description character varying, p_p_long_description character varying, p_p_category bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT" AS
$BODY$
DECLARE
v_p_id "IPYME_FINAL"."PRODUCT"."p_id"%TYPE;
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
																				,p_category)
																	VALUES(v_p_id
																			, p_p_ref 
																			, p_p_description
																			, p_p_long_description
																			, p_p_category);
		--
	ELSE
		--
		v_p_id := p_p_id;
		--
		UPDATE "IPYME_FINAL"."PRODUCT" 
		SET  p_ref 							= p_p_ref
				,p_description 			= p_p_description
				,p_long_description = p_p_long_description
		WHERE p_id = v_p_id;
		--
	END IF;
	--
	RETURN  QUERY SELECT * 
	FROM "IPYME_FINAL"."PRODUCT" 
	WHERE p_id = v_p_id;
	--
	EXCEPTION
		WHEN OTHERS THEN
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

-- Function: "IPYME_FINAL".set_provider(bigint, character varying, bigint, character varying, character varying)

-- DROP FUNCTION "IPYME_FINAL".set_provider(bigint, character varying, bigint, character varying, character varying);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_provider(IN p_p_id bigint, IN p_p_provider_name character varying, IN p_ie_id bigint, IN p_ie_legal_id character varying, IN p_ie_invoice_name character varying)
  RETURNS TABLE(p_id bigint, p_provider_name character varying, p_invoice_entity bigint, ie_id bigint, ie_legal_id character varying, ie_invoice_name character varying) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".set_provider(bigint, character varying, bigint, character varying, character varying)
  OWNER TO postgres;


-- Function: "IPYME_FINAL".set_invoice_entity(bigint, character varying, character varying)

-- DROP FUNCTION "IPYME_FINAL".set_invoice_entity(bigint, character varying, character varying);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_invoice_entity(p_ie_id bigint, p_ie_legal_id character varying, p_ie_invoice_name character varying)
  RETURNS record AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "IPYME_FINAL".set_invoice_entity(bigint, character varying, character varying)
  OWNER TO postgres;


/*
-- Function: "IPYME_FINAL".set_category_tree(bigint, character varying, character varying, numeric, bigint)

-- DROP FUNCTION "IPYME_FINAL".set_category_tree(bigint, character varying, character varying, numeric, bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_category_tree(p_c_id bigint, p_c_reference character varying, p_c_description character varying, p_c_tax numeric, p_c_parent bigint)
  RETURNS SETOF "IPYME_FINAL"."CATEGORY" AS
$BODY$
DECLARE
v_category "IPYME_FINAL"."CATEGORY"%ROWTYPE;
v_dummy INT;
BEGIN
	--
	IF (p_c_reference IS NULL) OR (LENGTH(p_c_reference) = 0) THEN
		RETURN;
	END IF;
	--
	v_category.c_reference 		:= p_c_reference;
	v_category.c_description 	:= p_c_description;
	v_category.c_tax 					:= p_c_tax;
	--
	IF p_c_parent IS NULL THEN -- IT IS A ROOT NODE 
		--
		v_category.c_parent 			:= NULL;
		--
		IF p_c_id IS NULL THEN
			--
			SELECT NEXTVAL('"IPYME_FINAL"."CATEGORY_c_id_seq"') INTO v_category.c_id;			
			--
			INSERT INTO "IPYME_FINAL"."CATEGORY" (c_id
																					, c_reference
																					, c_description
																					, c_tax
																					, c_parent)		
																		VALUES (v_category.c_id
																					, v_category.c_reference
																					, v_category.c_description
																					, v_category.c_tax
																					, v_category.c_parent);
			--
		ELSE
			--
			v_category.c_id := p_c_id;
			--
			UPDATE "IPYME_FINAL"."CATEGORY" 
			SET c_reference = v_category.c_reference
				, c_description = v_category.c_description
				, c_tax = v_category.c_tax
				, c_parent = v_category.c_parent
			WHERE c_id = v_category.c_id;
			--
		END IF;
		--
	ELSE
		--
		v_category.c_parent 			:= p_c_parent;
		--
		SELECT c_id
		INTO v_category.c_id
		FROM "IPYME_FINAL"."CATEGORY" 
		WHERE c_reference = v_category.c_reference
		AND c_parent = v_category.c_parent;
		--
		IF FOUND THEN
			--
			IF ((p_c_id IS NULL) OR (p_c_id <> v_category.c_id)) THEN
				RETURN;
			END IF;
			--
			UPDATE "IPYME_FINAL"."CATEGORY" 
				SET c_description = v_category.c_description
					, c_tax = v_category.c_tax
				WHERE c_id = v_category.c_id;
			--
		ELSE
			--
			SELECT NEXTVAL('"IPYME_FINAL"."CATEGORY_c_id_seq"') INTO v_category.c_id;
			--
			INSERT INTO "IPYME_FINAL"."CATEGORY" (c_id
																					, c_reference
																					, c_description
																					, c_tax
																					, c_parent)		
																		VALUES (v_category.c_id
																					, v_category.c_reference
																					, v_category.c_description
																					, v_category.c_tax
																					, v_category.c_parent);
			--
		END IF;
		--
	END IF;
	--
	RETURN QUERY SELECT v_category.c_id
										, v_category.c_reference
										, v_category.c_description
										, v_category.c_tax
										, v_category.c_parent;
	--
	EXCEPTION
		WHEN OTHERS THEN
			RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".set_category_tree(bigint, character varying, character varying, numeric, bigint)
  OWNER TO postgres;



-- Function: "IPYME_FINAL".get_category_tree(bigint)

-- DROP FUNCTION "IPYME_FINAL".get_category_tree(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_category_tree(p_c_id bigint)
  RETURNS SETOF "IPYME_FINAL".t_category AS
$BODY$
DECLARE

--CREATE TYPE "IPYME_FINAL".t_category as (
--c_id bigint
--,c_reference character varying(50)
--,c_description character varying(255)
--,c_tax numeric(8,3)
--,c_parent bigint
--,c_depth int
--);

v_category "IPYME_FINAL".t_category;
v_c_id BIGINT;
a_category "IPYME_FINAL".t_category[];
v_i integer;
BEGIN
	--
	v_c_id := p_c_id;
	--
	LOOP
		--
		SELECT *
		INTO v_category
		FROM "IPYME_FINAL"."CATEGORY" C
		WHERE C.c_id = v_c_id;
		--
		IF NOT FOUND THEN
			EXIT;
		ELSE
			--
			IF a_category @> ARRAY[v_category] THEN
				RETURN; -- CIRCULAR REFERENCES ARE NOT ALLOWED
			ELSE
				--
				a_category := a_category || v_category;
				v_c_id := v_category.c_parent;
				--
			END IF;
			--
		END IF;
		--
	END LOOP;
	--
	IF a_category IS NOT NULL THEN
		--
		FOR v_i IN array_lower(a_category,1)..array_upper(a_category,1) LOOP
			--
			v_category := a_category[v_i];
			v_category.c_depth := array_upper(a_category,1)+1-v_i;
			RETURN NEXT v_category;
			--
		END LOOP;
		RETURN;
		--
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "IPYME_FINAL".get_category_tree(bigint)
  OWNER TO postgres;


*/


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product_category(p_pc_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY" AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


-- Function: "IPYME_FINAL".get_provider(bigint)

-- DROP FUNCTION "IPYME_FINAL".get_provider(bigint);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_product_category(p_pc_id bigint, p_pc_tax_rate numeric, p_pc_description text, p_pc_path text)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY" AS
$BODY$
DECLARE
v_product_category "IPYME_FINAL"."PRODUCT_CATEGORY";
BEGIN
	--
	v_product_category.pc_tax_rate := p_pc_tax_rate;
	v_product_category.pc_description = p_pc_description;
	v_product_category.pc_path := p_pc_path;
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".delete_product(p_p_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT" AS
$BODY$
DECLARE
v_row_product "IPYME_FINAL"."PRODUCT"%ROWTYPE;
BEGIN
	--
	SELECT P.p_id
				,P.p_ref
				,P.p_description
				,P.p_long_description
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
											,v_row_product.p_category;
		--
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product_category_attribute(p_pca_product_category bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY 	SELECT *
								FROM "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE"
								WHERE pca_product_category = p_pca_product_category;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_product_category_attribute(p_pca_id bigint, p_pca_product_category bigint, p_pca_attribute text)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" AS
$BODY$
DECLARE
v_product_category_attribute "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE";
BEGIN
	--
	v_product_category_attribute.pca_product_category := p_pca_product_category;
	v_product_category_attribute.pca_attribute := p_pca_attribute;
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".delete_product_category_attribute(p_pca_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product_category_related(p_pc_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY" AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product_attribute_related(p_pc_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY select PCA.* from "IPYME_FINAL".get_product_category_related(p_pc_id) PC
							join "IPYME_FINAL"."PRODUCT_CATEGORY_ATTRIBUTE" PCA
							ON pc_id=pca_product_category
							order by pca_attribute;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product_by_category(p_p_category bigint)
  RETURNS SETOF "IPYME_FINAL".get_product AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY SELECT distinct P.p_id
											,P.p_ref
											,P.p_description
											,P.p_long_description
											,P.p_category
											,PC3.p_category_name
								FROM "IPYME_FINAL"."PRODUCT" P
								inner join (select PC1.pc_id 
														,substr(PC1.pc_path,length(PC1.pc_path)-strpos(reverse(PC1.pc_path),' > ')+2) as p_category_name
														from "IPYME_FINAL"."PRODUCT_CATEGORY" PC1
								,(select length(pc_path) as pc_path_length 
												,pc_path 
												from "IPYME_FINAL"."PRODUCT_CATEGORY" 
												where pc_id=p_p_category
												OR p_p_category = -1
												) PC2
								WHERE SUBSTR(PC1.pc_path,0,PC2.pc_path_length+1) = PC2.pc_path) PC3
								ON P.p_category = PC3.pc_id;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_attribute_value_related(p_pc_id bigint)
  RETURNS SETOF "IPYME_FINAL".attribute_value_related AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY select * from "IPYME_FINAL".get_product_attribute_related(p_pc_id)
					left join "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"
					on pav_product_category_attribute = pca_id;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;





CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_product_attribute_value(p_p_id bigint, p_pav_product_category_attribute bigint, p_pav_value text)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE" AS
$BODY$
DECLARE
v_product_attribute_value "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE";
v_p_category BIGINT;
v_pav_product_category_attribute BIGINT;
BEGIN
	--
	IF p_pav_value IS NULL OR LENGTH(p_pav_value)=0 THEN
		RETURN;
	END IF;
	--
	SELECT P_CATEGORY 
	INTO v_p_category
	FROM "IPYME_FINAL"."PRODUCT" 
	WHERE P_ID = p_p_id;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	SELECT pca_id
	INTO v_product_attribute_value.pav_product_category_attribute 
	FROM "IPYME_FINAL".get_product_attribute_related(v_p_category) 
	WHERE pca_id = p_pav_product_category_attribute;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	SELECT pav_product, pav_value
	INTO v_product_attribute_value.pav_product, v_product_attribute_value.pav_value
	FROM "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"
	WHERE pav_product_category_attribute = v_product_attribute_value.pav_product_category_attribute 
		AND pav_value = UPPER(p_pav_value);
	--
	IF NOT FOUND THEN
		SELECT NEXTVAL('"IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE_pav_id_seq"') INTO v_product_attribute_value.pav_product;
		v_product_attribute_value.pav_value := UPPER(p_pav_value);
		--
		INSERT INTO "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE"(pav_product
																											, pav_product_category_attribute
																											, pav_value)
																								VALUES( v_product_attribute_value.pav_id
																											, v_product_attribute_value.pav_product_category_attribute
																											,	v_product_attribute_value.pav_value);
	END IF;
	--
	RETURN QUERY SELECT v_product_attribute_value.*;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;




-- 
-- SELECT distinct P.p_id
-- 											,P.p_ref
-- 											,P.p_description
-- 											,P.p_long_description
-- 											,P.p_category
-- 											,PC3.p_category_name
-- 											,PR.p_price
-- 											,C.c_name
-- 								FROM "IPYME_FINAL"."PRODUCT" P
-- 								INNER JOIN (select PC1.pc_id 
-- 														,substr(PC1.pc_path,length(PC1.pc_path)-strpos(reverse(PC1.pc_path),' > ')+2) as p_category_name
-- 														from "IPYME_FINAL"."PRODUCT_CATEGORY" PC1
-- 													,(select length(pc_path) as pc_path_length 
-- 																	,pc_path 
-- 																	from "IPYME_FINAL"."PRODUCT_CATEGORY" 
-- 																	where pc_id=20
-- 																	--OR p_p_category = -1
-- 																	) PC2
-- 													WHERE SUBSTR(PC1.pc_path,0,PC2.pc_path_length+1) = PC2.pc_path) PC3
-- 								ON P.p_category = PC3.pc_id
-- 								LEFT JOIN "IPYME_FINAL"."PRICES" PR
-- 								ON PR.p_product = P.p_id and PR.p_status = 1
-- 								LEFT JOIN "IPYME_FINAL"."CURRENCY" C
-- 								ON PR.p_currency = C.c_id;




\dn




CREATE TYPE "IPYME_FINAL".get_product2 AS
   (p_id bigint,
    p_ref character varying(45),
    p_description character varying(255),
    p_long_description character varying(255),
    p_category bigint,
    p_image_path text,
    p_category_name text,
    p_price numeric(8,3),
		c_name character varying(100));