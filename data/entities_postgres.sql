--\o /dev/null

DROP SCHEMA "IPYME_AUX" CASCADE;
CREATE SCHEMA "IPYME_AUX";


\set ON_ERROR_STOP on;

CREATE TABLE "IPYME_AUX"."LANGUAGE" (
    "MSG_ID" NUMERIC PRIMARY KEY
    , "LANG1" VARCHAR(255)
    , "LANG2" VARCHAR(255));

CREATE TABLE "IPYME_AUX"."COMPANY" (
    "C_ID" NUMERIC PRIMARY KEY
    , "C_NAME" VARCHAR(255)
    , "C_DATE" TIMESTAMP WITH TIME ZONE);

CREATE TABLE "IPYME_AUX"."TAX_TYPE" (
    "TT_ID" INT PRIMARY KEY,
    "TT_NAME" VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."CATEGORY_PRODUCT" (
    "CP_ID" NUMERIC PRIMARY KEY,
    "CP_NAME" VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."TAX_PRODUCT" (
    "TP_ID" NUMERIC PRIMARY KEY,
    "TP_CATEGORY_PRODUCT" NUMERIC REFERENCES "IPYME_AUX"."CATEGORY_PRODUCT"
);

CREATE TABLE "IPYME_AUX"."CURRENCY" (
    "C_ID" NUMERIC PRIMARY KEY,
    "C_NAME" VARCHAR(250)
);

CREATE TABLE "IPYME_AUX"."PRODUCT" (
    "P_ID" NUMERIC PRIMARY KEY,
    "P_CATEGORY_PRODUCT" NUMERIC REFERENCES "IPYME_AUX"."CATEGORY_PRODUCT",
    "P_DESCRIPTION" VARCHAR(255),
    "P_EXTENDED_DESCRIPTION" TEXT,
    "P_PRICE" NUMERIC,
    "P_CURRENCY" REFERENCES "IPYME_AUX"."CURRENCY"
);

CREATE TABLE "IPYME_AUX"."COUNTRY" (
    "C_ID" NUMERIC PRIMARY KEY,
    "C_NAME" VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."ADDRESS_TYPE" (
    "AT_ID" NUMERIC PRIMARY KEY,
    "AT_DESCRIPTION" VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."PEOPLE" (
    "P_ID" NUMERIC PRIMARY KEY,
    "P_LEGAL_ID" VARCHAR(255),
    "P_NAME" VARCHAR(255),
    "P_SURNAME" VARCHAR(255),
    "P_ADDRESS" NUMERIC REFERENCES "IPYME_AUX"."ADDRESS"
);

CREATE TABLE "IPYME_AUX"."ADDRESS_DETAIL" (
    "AD_ID" NUMERIC PRIMARY KEY,
    "AD_LINE1" VARCHAR(255),
    "AD_LINE2" VARCHAR(255),
    "AD_LINE3" VARCHAR(255),
    "AD_COUNTY" VARCHAR(255),
    "AD_COUNTRY" NUMERIC REFERENCES "IPYME_AUX"."COUNTRY",
    "AD_TYPE" NUMERIC REFERENCES "IPYME_AUX"."ADDRESS_TYPE"
);

CREATE TABLE "IPYME_AUX"."ADDRESS_PEOPLE" (
    "AP_ID" NUMERIC PRIMARY KEY,
    "AP_DETAIL" NUMERIC REFERENCES "IPYME_AUX"."ADDRESS_DETAIL"
    "AP_PEOPLE" NUMERIC REFERENCES "IPYME_AUX"."PEOPLE"
);

CREATE TABLE "IPYME_AUX"."LEGAL_ENTITY" (
    "LE_ID" NUMERIC PRIMARY KEY,
    "LE_PEOPLE" NUMERIC REFERENCES "IPYME_AUX"."PEOPLE",
    "LE_LEGAL_ID" VARCHAR(255),
    "LE_LEGAL_NAME" VARCHAR(255),
);

CREATE TABLE "IPYME_AUX"."ADDRESS_LEGAL_ENTITY" (
    "ALE_ID" NUMERIC PRIMARY KEY,
    "ALE_DETAIL" NUMERIC REFERENCES "IPYME_AUX"."ADDRESS_DETAIL"
    "ALE_PEOPLE" NUMERIC REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
);

CREATE TABLE "IPYME_AUX"."PROVIDER" (
    "P_ID" NUMERIC PRIMARY KEY,
    "P_ENTITY" NUMERIC REFERENCES "IPYME_AUX"."ENTITY"
);

CREATE TABLE "IPYME_AUX"."ORDER_PROVIDER" (
    "OP_ID" NUMERIC PRIMARY KEY,
    "OP_PROVIDER" NUMERIC REFERENCES "IPYME_AUX"."PROVIDER"
);

CREATE TABLE "IPYME_AUX"."PRODUCT_LIST" (
    "PL_ID" NUMERIC PRIMARY KEY,
    "PL_ORDER_PROVIDER" REFERENCES "IPYME_AUX"."ORDER_PROVIDER"
);


CREATE TABLE "IPYME_AUX"."STORE_TYPE" (
    "ST_ID" NUMERIC PRIMARY KEY,
    "ST_NAME" VARCHAR(255)
);


CREATE TABLE "IPYME_AUX"."STORE" (
    "S_ID" NUMERIC PRIMARY KEY,
    "S_NAME" VARCHAR(255),
    "S_TYPE" NUMERIC REFERENCES "IPYME_AUX"."STORE_TYPE"
);

CREATE TABLE "IPYME_AUX"."ITEM" (
    "I_ID" NUMERIC PRIMARY KEY,
    "I_PRODUCT" NUMERIC REFERENCES "IPYME_AUX"."PRODUCT",
    "I_STORE" NUMERIC REFERENCES "IPYME_AUX"."STORE"
);


CREATE TABLE "IPYME_AUX"."ENTITY" (
    "E_ID" NUMERIC PRIMARY KEY,
    "E_PEOPLE" NUMERIC 
);


CREATE TABLE "IPYME_AUX"."CUSTOMER

CREATE TABLE "IPYME_AUX"."CUSTOMER" (
    "CU_ID" NUMERIC PRIMARY KEY,
    "CU_ENTITY" NUMERIC REFERENCES "IPYME_AUX"."ENTITY"
    "CU_TAX
);



DROP SCHEMA "IPYME_FINAL" CASCADE;

ALTER SCHEMA "IPYME_AUX" RENAME TO "IPYME_FINAL";

\dn
