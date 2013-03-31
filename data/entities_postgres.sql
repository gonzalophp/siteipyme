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


CREATE TABLE "IPYME_AUX"."CATEGORY_DETAILS" (
    CD_ID NUMERIC PRIMARY KEY
    , CD_TAX_RATE NUMERIC
    , CD_DESCRIPTION VARCHAR(255));

CREATE TABLE "IPYME_AUX"."PRODUCT_CATEGORY_VALUE" (
    PCV_ID NUMERIC PRIMARY KEY
    , PCV_CATEGORY_DETAILS NUMERIC REFERENCES CATEGORY_DETAILS
    , PCV_VALUE VARCHAR(255)
);

CREATE TABLE "IPYME_AUX"."PRODUCT" (
    P_ID NUMERIC PRIMARY KEY
    , P_REF VARCHAR(45)
    , P_DESCRIPTION VARCHAR(255)
    , P_LONG_DESCRIPTION VARCHAR(255)
    , P_WEIGHT NUMERIC(8,3)
    , P_SIZE VARCHAR(50)
);


CREATE TABLE "IPYME_AUX"."PRODUCT_CATEGORY_LINK" (
PCL_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT",
PCL_PRODUCT_CATEGORY_VALUE BIGINT REFERENCES "IPYME_AUX"."PRODUCT_CATEGORY_VALUE",
PRIMARY KEY (PCL_PRODUCT, PCL_PRODUCT_CATEGORY_VALUE)
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
    C_ID INT PRIMARY KEY
    , C_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PRICES" (
    P_ID BIGINT PRIMARY KEY
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

CREATE TABLE "IPYME_AUX"."LEGAL_ENTITY" (
    LE_ID BIGINT PRIMARY KEY
    , LE_LEGAL_ID VARCHAR(100)
    , LE_LEGAL_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PEOPLE" (
    P_ID BIGINT PRIMARY KEY
    , P_NAME VARCHAR(100)
    , P_SURNAME VARCHAR(100)
    , P_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
);

CREATE TABLE "IPYME_AUX"."PEOPLE_REPONSIBILITY" (
    PR_REF VARCHAR(50) PRIMARY KEY
    , PR_DESCRIPTION VARCHAR(100) 
    , PR_PEOPLE BIGINT REFERENCES "IPYME_AUX"."PEOPLE"
);

CREATE TABLE "IPYME_AUX"."COURIER" (
    C_ID BIGINT PRIMARY KEY
    , C_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
);

CREATE TABLE "IPYME_AUX"."CUSTOMER" (
    C_ID BIGINT PRIMARY KEY
    , C_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
);

CREATE TABLE "IPYME_AUX"."PROVIDER" (
    P_ID BIGINT PRIMARY KEY
    , P_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
);

CREATE TABLE "IPYME_AUX"."ADDRESS_DETAIL" (
    AD_ID BIGINT PRIMARY KEY
    , AD_LINE1 VARCHAR(100)
    , AD_LINE VARCHAR(100)
    , AD_TOWN VARCHAR(100)
    , AD_COUNTRY INT REFERENCES "IPYME_AUX"."COUNTRY"
    , AD_DESCRIPTION VARCHAR(100)
    , AD_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
);


CREATE TABLE "IPYME_AUX"."PROVIDER_CATEGORY_LINK" (
    PCL_PROVIDER BIGINT REFERENCES "IPYME_AUX"."PROVIDER"
    , PCL_CATEGORY_DETAILS BIGINT REFERENCES "IPYME_AUX"."CATEGORY_DETAILS"
    , PRIMARY KEY (PCL_PROVIDER, PCL_CATEGORY_DETAILS)
);

CREATE TABLE "IPYME_AUX"."ORDER_CUSTOMER" (
    OC_ID BIGINT PRIMARY KEY
    , OD_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , OD_DATE TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "IPYME_AUX"."SALE" (
    S_ID BIGINT PRIMARY KEY
    , S_ORDER_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."ORDER_CUSTOMER"
);

CREATE TABLE "IPYME_AUX"."ORDER_PROVIDER" (
    OP_ID BIGINT PRIMARY KEY
    , OP_PROVIDER BIGINT REFERENCES "IPYME_AUX"."PROVIDER"
    , OP_DATE TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "IPYME_AUX"."PURCHASE" (
    P_ID BIGINT PRIMARY KEY
    , P_ORDER_PROVIDER BIGINT REFERENCES "IPYME_AUX"."ORDER_PROVIDER"
);

CREATE TABLE "IPYME_AUX"."COMMERCIAL_TRANSACTION" (
    CT_ID BIGINT PRIMARY KEY
    ,CT_PURCHASE BIGINT REFERENCES "IPYME_AUX"."PURCHASE"
    ,CT_SALE BIGINT REFERENCES "IPYME_AUX"."SALE"
);

CREATE TABLE "IPYME_AUX"."DELIVERY" (
    D_ID BIGINT PRIMARY KEY
    , D_SALE BIGINT REFERENCES "IPYME_AUX"."SALE"
    , D_TRACKING VARCHAR(100)
    , D_WEIGHT NUMERIC(5,3)
    , D_PARTS INT
    , D_COURIER BIGINT REFERENCES "IPYME_AUX"."COURIER"
);

CREATE TABLE "IPYME_AUX"."CARD_VENDOR" (
    CV_ID INT PRIMARY KEY
    , CV_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."CARD" (
    C_ID BIGINT PRIMARY KEY
    , C_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
    , C_DESCRIPTION VARCHAR(100)
    , C_CARD_NUMBER VARCHAR(20)
    , C_NAME VARCHAR(100)
    , C_EXPIRE_DATE VARCHAR(8)
    , C_ISSUE_NUMER VARCHAR(20)
    , C_VENDOR INT REFERENCES "IPYME_AUX"."CARD_VENDOR"
);

CREATE TABLE "IPYME_AUX"."BANK_ACCOUNT" (
    BA_ID BIGINT PRIMARY KEY
    , BA_LEGAL_ENTITY BIGINT REFERENCES "IPYME_AUX"."LEGAL_ENTITY"
    , BA_NUMER VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PAYMENT" (
    P_ID BIGINT PRIMARY KEY
    , P_CARD BIGINT REFERENCES "IPYME_AUX"."CARD"
    , P_AMOUNT NUMERIC(8,3)
    , P_CURRENCY INT REFERENCES "IPYME_AUX"."CURRENCY"
    , P_DATE TIMESTAMP WITH TIME ZONE
    , P_COMMERCIAL_TRANSACTION BIGINT REFERENCES "IPYME_AUX"."COMMERCIAL_TRANSACTION"
    , P_BANK BIGINT REFERENCES "IPYME_AUX"."BANK_ACCOUNT"
    , P_CASH BOOLEAN
);

CREATE TABLE "IPYME_AUX"."PRODUCT_LIST" (
    PL_ID BIGINT PRIMARY KEY
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
    IH_ID BIGINT PRIMARY KEY
    , IH_ITEM BIGINT REFERENCES "IPYME_AUX"."ITEM"
    , IH_PRODUCT_LIST BIGINT REFERENCES "IPYME_AUX"."PRODUCT_LIST"
    , IH_DATE TIMESTAMP WITH TIME ZONE
);

CREATE TABLE "IPYME_AUX"."USER" (
    U_ID BIGINT PRIMARY KEY
    , U_SESSION VARCHAR(100)
    , U_LAST_LOGIN TIMESTAMP WITH TIME ZONE
    , U_EMAIL VARCHAR(200)
    , U_STATUS INT
    , U_BASKET BIGINT REFERENCES "IPYME_AUX"."BASKET"
    , U_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , U_NAME VARCHAR(30) NOT NULL
    , U_PASSWORD VARCHAR(100) NOT NULL
    , UNIQUE (U_NAME)
);

CREATE TABLE "IPYME_AUX"."CUSTOMER_CATEGORY_LINK" (
    CCL_CATEGORY_DETAILS BIGINT REFERENCES "IPYME_AUX"."CATEGORY_DETAILS"
    , CCL_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , PRIMARY KEY (CCL_CATEGORY_DETAILS, CCL_CUSTOMER)
);






DROP SCHEMA "IPYME_FINAL" CASCADE;

ALTER SCHEMA "IPYME_AUX" RENAME TO "IPYME_FINAL";

\dn
