--\o /dev/null
CREATE LANGUAGE plpgsql;

DROP SCHEMA "IPYME_AUX" CASCADE;
CREATE SCHEMA "IPYME_AUX";

GRANT ALL ON SCHEMA "IPYME_AUX" TO postgres;

\set ON_ERROR_STOP on

CREATE TABLE "IPYME_AUX"."LANGUAGE" (
    "L_ID" BIGSERIAL PRIMARY KEY
    , "L_1" VARCHAR(255)
    , "L_2" VARCHAR(255));

CREATE TABLE "IPYME_AUX"."COMPANY" (
    "C_ID" BIGSERIAL PRIMARY KEY
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
    ST_ID SERIAL PRIMARY KEY
    , ST_DESCRIPTION VARCHAR(255)
    , ST_IN_OUT BOOLEAN
);

CREATE TABLE "IPYME_AUX"."STORE" (
    S_ID SERIAL PRIMARY KEY
    , S_STORE_TYPE INT REFERENCES "IPYME_AUX"."STORE_TYPE"
    , S_STORE_NAME VARCHAR(100)
);



CREATE TABLE "IPYME_AUX"."STOCK" (
    S_ID BIGSERIAL PRIMARY KEY
    , S_PRODUCT_ID BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , S_STORE INT REFERENCES "IPYME_AUX"."STORE"
    , S_QUANTITY NUMERIC
);

CREATE TABLE "IPYME_AUX"."ITEM" (
    I_ID BIGSERIAL PRIMARY KEY
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
    B_ID BIGSERIAL PRIMARY KEY
    ,B_CONFIRMED INTEGER
);

CREATE TABLE "IPYME_AUX"."BASKET_LIST" (
    BL_ID BIGSERIAL PRIMARY KEY
    , BL_BASKET BIGINT REFERENCES "IPYME_AUX"."BASKET"
    , BL_PRODUCT BIGINT REFERENCES "IPYME_AUX"."PRODUCT"
    , BL_QUANTITY NUMERIC(5,3)
);

CREATE TABLE "IPYME_AUX"."COUNTRY" (
    C_ID SERIAL PRIMARY KEY
    , C_NAME TEXT
    , C_CODE TEXT
);

CREATE UNIQUE INDEX COUNTRY_unique_idx ON "IPYME_AUX"."COUNTRY"(C_CODE);

CREATE TABLE "IPYME_AUX"."INVOICE_ENTITY" (
    IE_ID BIGSERIAL PRIMARY KEY
    , IE_LEGAL_ID VARCHAR(100) UNIQUE
    , IE_INVOICE_NAME VARCHAR(100)
);

CREATE TABLE "IPYME_AUX"."PEOPLE" (
    P_ID BIGSERIAL PRIMARY KEY
    , P_TITLE TEXT
    , P_NAME VARCHAR(100)
    , P_SURNAME VARCHAR(100)
    , P_PHONE VARCHAR(20)
    , P_INVOICE_ENTITY BIGINT REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
);

CREATE TABLE "IPYME_AUX"."PEOPLE_REPONSIBILITY" (
    PR_REF VARCHAR(50) PRIMARY KEY
    , PR_DESCRIPTION VARCHAR(100) 
    , PR_PEOPLE BIGINT NOT NULL REFERENCES "IPYME_AUX"."PEOPLE"
);

CREATE TABLE "IPYME_AUX"."COURIER" (
    C_ID BIGSERIAL PRIMARY KEY
    , C_INVOICE_ENTITY BIGINT NOT NULL REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
);

CREATE TABLE "IPYME_AUX"."CUSTOMER" (
    C_ID BIGSERIAL PRIMARY KEY
    , C_CUSTOMER_NAME VARCHAR(100)
    , C_INVOICE_ENTITY BIGINT NOT NULL REFERENCES "IPYME_AUX"."INVOICE_ENTITY"
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
    , AD_LINE2 VARCHAR(100)
    , AD_TOWN VARCHAR(100)
    , AD_POST_CODE VARCHAR(10)
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
    , BA_NUMBER VARCHAR(100)
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
    , U_SESSION VARCHAR(100) UNIQUE NOT NULL
    , U_LAST_LOGIN TIMESTAMP WITH TIME ZONE
    , U_EMAIL VARCHAR(200) UNIQUE
    , U_STATUS INT
    , U_BASKET BIGINT REFERENCES "IPYME_AUX"."BASKET"
    , U_CUSTOMER BIGINT REFERENCES "IPYME_AUX"."CUSTOMER"
    , U_NAME VARCHAR(30) UNIQUE 
    , U_PASSWORD_HASH VARCHAR(100) 
    , U_ADMIN INTEGER DEFAULT 0
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



create type "IPYME_AUX".attribute_value_related AS (
	pca_id bigint,
	pca_product_category bigint,
	pca_attribute text,
	pav_product bigint,
	pav_product_category_attribute bigint,
	pav_value text
);



create type "IPYME_AUX"."get_product" AS (
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

CREATE TYPE "IPYME_AUX".basket_list_extended AS(bl_id bigint
                                                ,bl_basket bigint
                                                ,bl_product bigint
                                                ,bl_quantity numeric(5,3)
                                                ,p_ref character varying(45)
                                                ,p_description character varying(255)
                                                ,p_long_description character varying(255)
                                                ,p_image_path text
                                                ,p_category bigint
                                                ,p_price numeric(8,3)
                                                ,c_name character varying(100));


CREATE TYPE "IPYME_AUX".payment_confirmation AS(u_id 	BIGINT
                                                , u_customer 	BIGINT
                                                , bl_id 	BIGINT
                                                , bl_product 	BIGINT
                                                , bl_quantity 	NUMERIC(5,3));



CREATE TYPE "IPYME_AUX".user_details AS
   (user_u_id bigint,
    user_u_session character varying(100),
    user_u_last_login timestamp with time zone,
    user_u_email character varying(200),
    user_u_status integer,
    user_u_basket bigint,
    user_u_customer bigint,
    user_u_name character varying(30),
    user_u_password_hash character varying(100),
    user_u_admin integer,
    customer_c_id bigint,
    customer_c_customer_name character varying(100),
    customer_c_invoice_entity bigint,
    invoice_entity_ie_id bigint,
    invoice_entity_ie_legal_id character varying(100),
    invoice_entity_ie_invoice_name character varying(100),
    card_c_id bigint,
    card_c_invoice_entity bigint,
    card_c_description character varying(100),
    card_c_card_number character varying(20),
    card_c_name character varying(100),
    card_c_expire_date character varying(8),
    card_c_issue_numer character varying(20),
    card_c_vendor integer,
    people_p_id bigint,
    people_p_title TEXT,
    people_p_name character varying(100),
    people_p_surname character varying(100),
    people_p_phone character varying(20),
    people_p_invoice_entity bigint,
    card_vendor_cv_id integer,
    card_vendor_cv_name character varying(100),
    bank_account_ba_id bigint,
    bank_account_ba_invoice_entity bigint,
    bank_account_ba_number character varying(100),
    address_detail_ad_id bigint,
    address_detail_ad_line1 character varying(100),
    address_detail_ad_line2 character varying(100),
    address_detail_ad_town character varying(100),
    address_detail_ad_post_code character varying(10),
    address_detail_ad_country integer,
    address_detail_ad_description character varying(100),
    address_detail_ad_invoice_entity bigint,
    country_c_id integer,
    country_c_name text,
    country_c_code text);



CREATE TYPE "IPYME_AUX".address AS
   (address_detail_ad_id bigint,
    address_detail_ad_line1 character varying(100),
    address_detail_ad_line2 character varying(100),
    address_detail_ad_town character varying(100),
    address_detail_ad_post_code character varying(10),
    address_detail_ad_country integer,
    address_detail_ad_description character varying(100),
    address_detail_ad_invoice_entity bigint,
    country_c_id integer,
    country_c_name text,
    country_c_code text);



CREATE TYPE "IPYME_AUX".card AS (
card_c_id bigint, 
  card_c_invoice_entity bigint,
  card_c_description character varying(100),
  card_c_card_number character varying(20),
  card_c_name character varying(100),
  card_c_expire_date character varying(8),
  card_c_issue_numer character varying(20),
  card_c_vendor integer,
  card_vendor_cv_id integer,
  card_vendor_cv_name character varying(100));


CREATE TYPE "IPYME_AUX".people_details as (
people_p_id bigint,
  people_p_name TEXT,
  people_p_surname TEXT,
  people_p_phone TEXT,
  people_p_invoice_entity bigint,
  people_p_title text);

SET search_path = "IPYME_AUX", pg_catalog;


COPY "COUNTRY"(c_code, c_name) FROM stdin DELIMITERS '|';
ad|andorra
ae|united arab emirates
af|afghanistan
ag|antigua and barbuda
ai|anguilla
al|albania
am|armenia
ao|angola
aq|antarctica
ar|argentina
as|american samoa
at|austria
au|australia
aw|aruba
ax|åland islands
az|azerbaijan
ba|bosnia and herzegovina
bb|barbados
bd|bangladesh
be|belgium
bf|burkina faso
bg|bulgaria
bh|bahrain
bi|burundi
bj|benin
bl|saint barthélemy
bm|bermuda
bn|brunei darussalam
bo|bolivia
bq|bonaire, sint eustatius and saba
br|brazil
bs|bahamas
bt|bhutan
bv|bouvet island
bw|botswana
by|belarus
bz|belize
ca|canada
cc|cocos (keeling) islands
cd|congo, the democratic republic of the
cf|central african republic
cg|congo
ch|switzerland
ci|côte d''ivoire
ck|cook islands
cl|chile
cm|cameroon
cn|china
co|colombia
cr|costa rica
cu|cuba
cv|cape verde
cw|curaçao
cx|christmas island
cy|cyprus
cz|czech republic
de|germany
dj|djibouti
dk|denmark
dm|dominica
do|dominican republic
dz|algeria
ec|ecuador
ee|estonia
eg|egypt
eh|western sahara
er|eritrea
es|spain
et|ethiopia
fi|finland
fj|fiji
fk|falkland islands (malvinas)
fm|micronesia
fo|faroe islands
fr|france
ga|gabon
gb|united kingdom
gd|grenada
ge|georgia
gf|french guiana
gg|guernsey
gh|ghana
gi|gibraltar
gl|greenland
gm|gambia
gn|guinea
gp|guadeloupe
gq|equatorial guinea
gr|greece
gs|south georgia and the south sandwich islands
gt|guatemala
gu|guam
gw|guinea-bissau
gy|guyana
hk|hong kong
hm|heard island and mcdonald islands
hn|honduras
hr|croatia
ht|haiti
hu|hungary
id|indonesia
ie|ireland
il|israel
im|isle of man
in|india
io|british indian ocean territory
iq|iraq
ir|iran, islamic republic of
is|iceland
it|italy
je|jersey
jm|jamaica
jo|jordan
jp|japan
ke|kenya
kg|kyrgyzstan
kh|cambodia
ki|kiribati
km|comoros
kn|saint kitts and nevis
kp|korea, democratic people's republic of
kr|korea, republic of
kw|kuwait
ky|cayman islands
kz|kazakhstan
la|lao people's democratic republic
lb|lebanon
lc|saint lucia
li|liechtenstein
lk|sri lanka
lr|liberia
ls|lesotho
lt|lithuania
lu|luxembourg
lv|latvia
ly|libyan arab jamahiriya
ma|morocco
mc|monaco
md|moldova, republic of
me|montenegro
mf|saint martin (french part)
mg|madagascar
mh|marshall islands
mk|macedonia, the former yugoslav republic of
ml|mali
mm|myanmar
mn|mongolia
mo|macao
mp|northern mariana islands
mq|martinique
mr|mauritania
ms|montserrat
mt|malta
mu|mauritius
mv|maldives
mw|malawi
mx|mexico
my|malaysia
mz|mozambique
na|namibia
nc|new caledonia
ne|niger
nf|norfolk island
ng|nigeria
ni|nicaragua
nl|netherlands
no|norway
np|nepal
nr|nauru
nu|niue
nz|new zealand
om|oman
pa|panama
pe|peru
pf|french polynesia
pg|papua new guinea
ph|philippines
pk|pakistan
pl|poland
pm|saint pierre and miquelon
pn|pitcairn
pr|puerto rico
ps|palestine, state of
pt|portugal
pw|palau
py|paraguay
qa|qatar
re|réunion
ro|romania
rs|serbia
ru|russian federation
rw|rwanda
sa|saudi arabia
sb|solomon islands
sc|seychelles
sd|sudan
se|sweden
sg|singapore
sh|saint helena, ascension and tristan da cunha
si|slovenia
sj|svalbard and jan mayen
sk|slovakia
sl|sierra leone
sm|san marino
sn|senegal
so|somalia
sr|suriname
ss|south sudan
st|sao tome and principe
sv|el salvador
sx|sint maarten (dutch part)
sy|syrian arab republic
sz|swaziland
tc|turks and caicos islands
td|chad
tf|french southern territories
tg|togo
th|thailand
tj|tajikistan
tk|tokelau
tl|timor-leste
tm|turkmenistan
tn|tunisia
to|tonga
tr|turkey
tt|trinidad and tobago
tv|tuvalu
tw|taiwan, province of china
tz|tanzania, united republic of
ua|ukraine
ug|uganda
um|united states minor outlying islands
us|united states
uy|uruguay
uz|uzbekistan
va|holy see (vatican city state)
vc|saint vincent and the grenadines
ve|venezuela, bolivarian republic of
vg|virgin islands, british
vi|virgin islands, u.s.
vn|viet nam
vu|vanuatu
wf|wallis and futuna
ws|samoa
ye|yemen
yt|mayotte
za|south africa
zm|zambia
zw|Zimbabwe
\.


COPY "USER" (u_session, u_last_login, u_email, u_status, u_basket, u_customer, u_name, u_password_hash, u_admin) FROM stdin;
sujpig3kuf2clh6im5f7sf0035	2013-06-13 13:37:02.100457+01	user@ipyme.net	1	\N	\N	user	12dea96fec20593566ab75692c9949596833adc9	0
bkrh0pksg0anu5tt75oif4kl04	2013-06-13 13:36:16.446135+01	admin@ipyme.net	1	\N	\N	admin	d033e22ae348aeb5660fc2140aec35850c4da997	1
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



COPY "CARD_VENDOR" (cv_id, cv_name) FROM stdin;
1	visa
2	visa electron
3	master card
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




\set ON_ERROR_STOP off
DROP SCHEMA "IPYME_FINAL" CASCADE;
\set ON_ERROR_STOP on
ALTER SCHEMA "IPYME_AUX" RENAME TO "IPYME_FINAL";




create or replace function "IPYME_FINAL".rev(varchar) returns varchar as $$
declare
        _temp varchar;
        _count int;
begin
        _temp := '';
        for _count in reverse length($1)..1 loop
                _temp := _temp || substring($1 from _count for 1);
        end loop;
        return _temp;
end;
$$ language plpgsql immutable;


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


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_all_available_attribute_value_related(p_pc_id bigint)
  RETURNS SETOF "IPYME_FINAL".attribute_value_related AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


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

CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_price_by_product(p_p_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRICES" AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


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
											,P.p_image_path
											,substr(PC.pc_path,length(PC.pc_path)-strpos("IPYME_FINAL".rev(PC.pc_path),' > ')+2) AS p_category_name
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


-- Function: "IPYME_FINAL".set_customer(bigint, character varying, bigint, character varying, character varying)

-- DROP FUNCTION "IPYME_FINAL".set_customer(bigint, character varying, bigint, character varying, character varying);
/*
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
*/


-- Function: "IPYME_FINAL".set_product(bigint, character varying, character varying, character varying, numeric, character varying)

-- DROP FUNCTION "IPYME_FINAL".set_product(bigint, character varying, character varying, character varying, numeric, character varying);

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_product(p_p_id bigint
, p_p_ref character varying, p_p_description character varying
, p_p_long_description character varying, p_p_category bigint, p_p_price numeric
, p_p_image_path text
, p_c_name text)
  RETURNS SETOF "IPYME_FINAL".get_product AS
$BODY$
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
	PERFORM "IPYME_FINAL".set_price_to_product(v_p_id, p_p_price, p_c_name);
	--
	RETURN  QUERY SELECT * FROM "IPYME_FINAL".get_product(v_p_id); 
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
/*
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
*/


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


CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_price_to_product(p_p_product bigint
, p_p_price numeric
, p_c_name text)
  RETURNS SETOF "IPYME_FINAL"."PRICES" AS
$BODY$
DECLARE
v_p_id BIGINT;
v_c_id INTEGER;
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
		SELECT c_id
		INTO v_c_id
		FROM "IPYME_FINAL"."CURRENCY"
		WHERE LOWER(c_name) = LOWER(p_c_name);
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
																			, v_c_id	
																			, p_p_price);
		RETURN QUERY SELECT * 
		FROM "IPYME_FINAL"."PRICES" PR
		WHERE PR.p_product = p_p_product
		AND PR.p_status = 1;
		--
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".delete_product_category(p_pc_id bigint)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_CATEGORY" AS
$BODY$
DECLARE
v_row_product_category "IPYME_FINAL"."PRODUCT_CATEGORY"%ROWTYPE;
BEGIN
	--
	SELECT *
	INTO v_row_product_category
	FROM "IPYME_FINAL"."PRODUCT_CATEGORY" PC
	WHERE PC.pc_id = p_pc_id;
	--
	IF NOT FOUND THEN
		--
		RETURN;
		--
	ELSE
		--
		DELETE FROM "IPYME_FINAL"."PRODUCT_CATEGORY" PC
		WHERE PC.pc_id = p_pc_id;
		--
		RETURN QUERY SELECT v_row_product_category.*;
		--
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


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
		v_pc_path := substr(v_pc_path, 0,length(v_pc_path)-strpos("IPYME_FINAL".rev(v_pc_path),' > ')-1);
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
  COST 100
  ROWS 1000;


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
											,P.p_image_path
											,PC3.p_category_name
											,PR.p_price
											,C.c_name
								FROM "IPYME_FINAL"."PRODUCT" P
								INNER JOIN (select PC1.pc_id 
														,substr(PC1.pc_path,length(PC1.pc_path)-strpos("IPYME_FINAL".rev(PC1.pc_path),' > ')+2) as p_category_name
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





CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_product_attribute_value(p_pav_product bigint, p_pav_product_category_attribute bigint, p_pav_value text)
  RETURNS SETOF "IPYME_FINAL"."PRODUCT_ATTRIBUTE_VALUE" AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_product_by_attribute_value(p_category_attribute_id_and_value text)
  RETURNS SETOF "IPYME_FINAL".get_product AS
$BODY$
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
											,substr(PC.pc_path,length(PC.pc_path)-strpos("IPYME_FINAL".rev(PC.pc_path),' > ')+2) AS p_category_name
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_basket_product_list(p_user_id bigint)
  RETURNS SETOF "IPYME_FINAL".basket_list_extended AS
$BODY$
DECLARE
BEGIN
	--
	IF p_user_id IS NOT NULL THEN
		RETURN QUERY 	SELECT BL.bl_id
												,BL.bl_basket 
												,BL.bl_product
												,BL.bl_quantity
												,P.p_ref 
												,P.p_description 
												,P.p_long_description
												,P.p_image_path 
												,P.p_category
												,PR.p_price
												,C.c_name
									FROM "IPYME_FINAL"."BASKET_LIST" BL
									INNER JOIN "IPYME_FINAL"."BASKET" B
									ON BL.bl_basket = B.b_id
									INNER JOIN "IPYME_FINAL"."USER" U
									ON BL.bl_basket = U.u_basket
									INNER JOIN "IPYME_FINAL"."PRODUCT" P
									ON P.p_id = BL.bl_product
									LEFT JOIN "IPYME_FINAL"."PRICES" PR
									ON PR.p_product = P.p_id
									LEFT JOIN "IPYME_FINAL"."CURRENCY" C
									ON PR.p_currency = C.c_id
									WHERE U.u_id = p_user_id
										AND B.b_confirmed = 0
										AND PR.p_status = 1;
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



CREATE OR REPLACE FUNCTION "IPYME_FINAL".save_basket_product_list(p_user_id bigint, p_basket_products text)
  RETURNS SETOF "IPYME_FINAL".basket_list_extended AS
$BODY$
DECLARE
v_a_basket_product_list TEXT[];
v_a_basket_and_product 	TEXT[];
v_basket_list 					"IPYME_FINAL"."BASKET_LIST";
v_user 									"IPYME_FINAL"."USER";
v_a_updated_lines				BIGINT[];
i INT;
BEGIN
	--
	SELECT *
	INTO v_user
	FROM "IPYME_FINAL"."USER" U
	WHERE U.u_id = p_user_id;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	IF v_user.u_basket IS NULL THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."BASKET_b_id_seq"') INTO v_user.u_basket;
		--
		INSERT INTO "IPYME_FINAL"."BASKET" (b_id
																			, b_confirmed)
																 VALUES(v_user.u_basket
																			, 0);
		--
		UPDATE "IPYME_FINAL"."USER"
		SET u_basket = v_user.u_basket
		WHERE u_id = v_user.u_id;
		--
	END IF;
	--
	v_basket_list.bl_basket := v_user.u_basket;
	--
	v_a_basket_product_list := string_to_array(p_basket_products,'%^%');
	--
	IF ARRAY_LENGTH(v_a_basket_product_list,1) IS NULL THEN
		--
		DELETE FROM "IPYME_FINAL"."BASKET_LIST"
		WHERE bl_basket = v_basket_list.bl_basket;
		RETURN;
		--
	END IF;
	--
	FOR i IN 1..coalesce(ARRAY_LENGTH(v_a_basket_product_list,1),0) LOOP
		--
		v_a_basket_and_product := string_to_array(v_a_basket_product_list[i],'~^~');
		--
		v_basket_list.bl_product	:= v_a_basket_and_product[2];
		v_basket_list.bl_quantity	:= v_a_basket_and_product[1];
		--
		UPDATE "IPYME_FINAL"."BASKET_LIST"
		SET bl_quantity = v_basket_list.bl_quantity
		WHERE bl_basket = v_basket_list.bl_basket
			AND bl_product = v_basket_list.bl_product
		RETURNING bl_id INTO v_basket_list.bl_id;
		--
		IF NOT FOUND THEN
			--
			SELECT NEXTVAL('"IPYME_FINAL"."BASKET_LIST_bl_id_seq"') INTO v_basket_list.bl_id;
			--
			INSERT INTO "IPYME_FINAL"."BASKET_LIST" (bl_id
																							,bl_basket
																							,bl_product
																							,bl_quantity)
																			VALUES (v_basket_list.bl_id
																							,v_basket_list.bl_basket
																							,v_basket_list.bl_product
																							,v_basket_list.bl_quantity);
			--
		END IF;
		--
		v_a_updated_lines := v_a_updated_lines || v_basket_list.bl_id;
		--
	END LOOP;
	--
	DELETE FROM "IPYME_FINAL"."BASKET_LIST"
	WHERE bl_basket = v_user.u_basket
	AND NOT ( BL_ID = ANY (v_a_updated_lines));
	--
	--
	RETURN QUERY SELECT * FROM "IPYME_FINAL".get_basket_product_list(v_user.u_id);
	--
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_user_confirm(
p_u_session character varying(100))
  RETURNS SETOF "IPYME_FINAL"."USER" AS
$BODY$
DECLARE
v_user "IPYME_FINAL"."USER";
BEGIN
	--
	IF (p_u_session IS NULL) THEN
		RETURN;
	END IF;
	--
	UPDATE "IPYME_FINAL"."USER"
	SET u_status = 1
	WHERE u_status = 0
		AND u_session = p_u_session;
	--
	IF FOUND THEN
		--
		RETURN QUERY SELECT * 
		FROM "IPYME_FINAL"."USER" U 
		WHERE U.u_session = p_u_session;
		--
	END IF;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_user(p_u_session character varying)
  RETURNS SETOF "IPYME_FINAL"."USER" AS
$BODY$
DECLARE
v_user "IPYME_FINAL"."USER";
BEGIN
	--
	IF (p_u_session IS NULL) THEN
		RETURN;
	END IF;
	--
	SELECT *
	INTO v_user
	FROM "IPYME_FINAL"."USER"
	WHERE u_session = p_u_session 
		AND ((u_status = 1) OR ((u_status=0) AND (u_name IS NULL)));
	--
	IF NOT FOUND THEN
		--
		SELECT nextval('"IPYME_FINAL"."USER_u_id_seq"') INTO v_user.u_id;
		v_user.u_session 			:= p_u_session;
		v_user.u_last_login 	:= now();
		v_user.u_email 				:= null;
		v_user.u_status				:= 0;
		v_user.u_basket				:= null;
		v_user.u_customer			:= null;
		v_user.u_name					:= null;
		v_user.u_password_hash:= null;
		--
		INSERT INTO "IPYME_FINAL"."USER" (u_id 
																			,u_session 
																			,u_last_login 
																			,u_email 
																			,u_status
																			,u_basket
																			,u_customer
																			,u_name
																			,u_password_hash)
															VALUES  (v_user.u_id 
																			,v_user.u_session 
																			,v_user.u_last_login 
																			,v_user.u_email 
																			,v_user.u_status
																			,v_user.u_basket
																			,v_user.u_customer
																			,v_user.u_name
																			,v_user.u_password_hash);
		--
	END IF;
	--
	RETURN QUERY SELECT v_user.*;
	--
	EXCEPTION
		WHEN OTHERS THEN
			RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".user_login(p_u_session character varying, p_u_name character varying, p_u_password_hash character varying)
  RETURNS SETOF "IPYME_FINAL"."USER" AS
$BODY$
DECLARE
v_anonymous_user "IPYME_FINAL"."USER";
v_user "IPYME_FINAL"."USER";
BEGIN
	--
	IF (p_u_session IS NULL) THEN
		RETURN;
	END IF;
	--
	SELECT *
	INTO v_user
	FROM "IPYME_FINAL"."USER"
	WHERE u_name = lower(p_u_name)
		AND u_password_hash = p_u_password_hash 
		AND u_status = 1;
	--
	IF NOT FOUND THEN
		--
		RETURN;
		--
	ELSE
		--
		SELECT *
		INTO v_anonymous_user
		FROM "IPYME_FINAL"."USER"
		WHERE u_session = p_u_session;
		--
		IF NOT FOUND THEN
			--
			v_user.u_session := p_u_session;
			v_user.u_basket := NULL;
			--
			UPDATE "IPYME_FINAL"."USER"
			SET u_session = v_user.u_session
				, u_last_login = now()
			WHERE u_id = v_user.u_id;
			--
		ELSE
			--
			IF NOT v_anonymous_user.u_id = v_user.u_id THEN
				--
				v_user.u_basket := v_anonymous_user.u_basket;
				v_user.u_session := v_anonymous_user.u_session;
				--
				UPDATE "IPYME_FINAL"."USER"
				SET u_basket = NULL
					, u_session = md5(now()::text||random()::text||v_anonymous_user.u_id::TEXT) -- KEEPING BASKET REFERENCE
				WHERE u_id = v_anonymous_user.u_id;
				--
				UPDATE "IPYME_FINAL"."USER"
				SET u_basket = v_user.u_basket
					, u_session = v_user.u_session
					, u_last_login = now()
				WHERE u_id = v_user.u_id;
				--
				IF v_anonymous_user.u_name IS NULL THEN
					DELETE FROM "IPYME_FINAL"."USER"
					WHERE u_id = v_anonymous_user.u_id;
				END IF;
				--
			END IF;
			--
		END IF;
		--
	END IF;
	--
	RETURN QUERY SELECT v_user.*;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



CREATE OR REPLACE FUNCTION "IPYME_FINAL".user_signup(p_u_session character varying, p_u_name character varying, p_u_password_hash character varying, p_u_email character varying)
  RETURNS SETOF "IPYME_FINAL"."USER" AS
$BODY$
DECLARE
v_user "IPYME_FINAL"."USER";
v_anonymous_user "IPYME_FINAL"."USER";
BEGIN
	--
	IF 	p_u_name IS NULL OR 
			p_u_password_hash IS NULL OR 
			p_u_email IS NULL OR 
			p_u_session IS NULL THEN
		--
		RETURN;
		--
	END IF;
	--
	SELECT * 
	INTO v_anonymous_user
	FROM "IPYME_FINAL"."USER"
	WHERE u_session = p_u_session
	AND u_status = 0
	AND u_name IS NULL
	AND u_customer IS NULL;
	--
	IF FOUND THEN
		--
		v_user.u_id			 				:= v_anonymous_user.u_id;
		v_user.u_session 				:= v_anonymous_user.u_session;
		v_user.u_last_login			:= v_anonymous_user.u_last_login;
		v_user.u_email 					:= LOWER(p_u_email);
		v_user.u_status 				:= v_anonymous_user.u_status;
		v_user.u_basket 				:= v_anonymous_user.u_basket;
		v_user.u_customer 			:= v_anonymous_user.u_customer;
		v_user.u_name 					:= LOWER(p_u_name);
		v_user.u_password_hash 	:= p_u_password_hash;
		v_user.u_admin			  	:= v_anonymous_user.u_admin;
		--
		UPDATE "IPYME_FINAL"."USER" 
		SET u_email 				= v_user.u_email 	
				,u_name 					= v_user.u_name 		 
				,u_password_hash = v_user.u_password_hash
		WHERE u_id = v_user.u_id;
		--
	ELSE
		--
				--
		SELECT NEXTVAL('"IPYME_FINAL"."USER_u_id_seq"') INTO v_user.u_id;
		--
		v_user.u_session 				:= p_u_session;
		v_user.u_last_login			:= now();
		v_user.u_email 					:= LOWER(p_u_email);
		v_user.u_status 				:= 0;
		v_user.u_basket 				:= NULL;
		v_user.u_customer 			:= NULL;
		v_user.u_name 					:= LOWER(p_u_name);
		v_user.u_password_hash 	:= p_u_password_hash;
		v_user.u_admin			  	:= 0;
		--
		INSERT INTO "IPYME_FINAL"."USER" ( u_id 
																			,u_session 
																			,u_last_login
																			,u_email 
																			,u_status
																			,u_basket
																			,u_customer
																			,u_name 
																			,u_password_hash
																			,u_admin)
															VALUES ( v_user.u_id 
																			,v_user.u_session 
																			,v_user.u_last_login
																			,v_user.u_email 
																			,v_user.u_status
																			,v_user.u_basket
																			,v_user.u_customer
																			,v_user.u_name 
																			,v_user.u_password_hash
																			,v_user.u_admin);
		--
	END IF;
	--
	--
	RETURN QUERY SELECT v_user.*;
	--
	EXCEPTION
		WHEN OTHERS THEN
			NULL;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;






CREATE OR REPLACE FUNCTION "IPYME_FINAL".payment_confirm(p_u_session text, p_b_id bigint, cust_name text, cust_surname text, cust_add1 text, cust_add2 text, cust_company text, cust_country text, cust_dob text, cust_phone text, cust_postcode text, cust_town text, cust_card_expire text, cust_card_issue text, cust_card_name text, cust_card_number text)
  RETURNS SETOF "IPYME_FINAL".payment_confirmation AS
$BODY$
DECLARE
--
basket_lines CURSOR(c_p_u_session text, c_p_b_id BIGINT) IS
		SELECT U.u_id, U.u_customer, BL.bl_id, BL.bl_product, BL.bl_quantity
		FROM "IPYME_FINAL"."BASKET" B
		INNER JOIN "IPYME_FINAL"."USER" U
		ON U.u_basket = B.b_id
		INNER JOIN "IPYME_FINAL"."BASKET_LIST" BL
		ON B.b_id = BL.bl_basket
		WHERE U.u_session = c_p_u_session
			AND B.b_id = c_p_b_id
			AND B.b_confirmed = 0;
--
v_cur_u_id BIGINT;
v_cur_u_customer BIGINT;
v_cur_bl_id BIGINT;
v_cur_bl_product BIGINT;
v_cur_bl_quantity NUMERIC(5,3);
--
v_customer_identified BOOLEAN := FALSE;
v_customer_order_created BOOLEAN := FALSE;
v_user_basket_reset BOOLEAN := FALSE;
v_customer "IPYME_FINAL"."CUSTOMER";
v_entity "IPYME_FINAL"."INVOICE_ENTITY";
v_people "IPYME_FINAL"."PEOPLE";
v_address_detail "IPYME_FINAL"."ADDRESS_DETAIL";
v_card "IPYME_FINAL"."CARD";
v_order_customer "IPYME_FINAL"."ORDER_CUSTOMER";
v_product_list "IPYME_FINAL"."PRODUCT_LIST";
--
BEGIN
	--
	OPEN basket_lines(p_u_session,p_b_id);
	--
	LOOP
		--
		FETCH basket_lines 
		INTO v_cur_u_id 
				,v_cur_u_customer
				,v_cur_bl_id 
				,v_cur_bl_product
				,v_cur_bl_quantity;
		--
		IF NOT FOUND THEN
			EXIT;
		END IF;
		--
		IF NOT v_customer_identified THEN
			--
			IF v_cur_u_customer IS NULL THEN
				--
				SELECT NEXTVAL('"IPYME_FINAL"."INVOICE_ENTITY_ie_id_seq"') INTO v_entity.ie_id;
				--
				v_entity.ie_legal_id := cust_company;
				v_entity.ie_invoice_name := cust_company;
				--
				INSERT INTO "IPYME_FINAL"."INVOICE_ENTITY" (ie_id
																									,ie_legal_id
																									,ie_invoice_name)
																						VALUES (v_entity.ie_id
																									,v_entity.ie_legal_id
																									,v_entity.ie_invoice_name);
				--																						
				SELECT NEXTVAL('"IPYME_FINAL"."CUSTOMER_c_id_seq"') INTO v_customer.c_id;
				v_customer.c_customer_name := v_entity.ie_invoice_name;
				v_customer.c_invoice_entity := v_entity.ie_id;
				--
				--
				INSERT INTO "IPYME_FINAL"."CUSTOMER" (c_id
																							,c_customer_name
																							,c_invoice_entity)
																			VALUES (v_customer.c_id
																							,v_customer.c_customer_name
																							,v_customer.c_invoice_entity);
				--
				--
				SELECT NEXTVAL('"IPYME_FINAL"."PEOPLE_p_id_seq"') INTO v_people.p_id;
				v_people.p_name			:= cust_name;
				v_people.p_surname	:= cust_surname;
				v_people.p_phone		:= cust_phone;
				v_people.p_invoice_entity := v_entity.ie_id;
				--
				INSERT INTO "IPYME_FINAL"."PEOPLE"(p_id
																					,p_name
																					,p_surname
																					,p_phone
																					,p_invoice_entity)
																	VALUES (v_people.p_id
																					,v_people.p_name
																					,v_people.p_surname
																					,v_people.p_phone
																					,v_people.p_invoice_entity);
				--
				--
				SELECT NEXTVAL('"IPYME_FINAL"."ADDRESS_DETAIL_ad_id_seq"') INTO v_address_detail.ad_id;
				v_address_detail.ad_line1						:= cust_add1;
				v_address_detail.ad_line2						:= cust_add2;
				v_address_detail.ad_town						:= cust_town;
				v_address_detail.ad_post_code 			:= cust_postcode;
				v_address_detail.ad_country 				:= NULL;
				v_address_detail.ad_description 		:= 'PRIMARY';
				v_address_detail.ad_invoice_entity 	:= v_entity.ie_id;
				--
				INSERT INTO "IPYME_FINAL"."ADDRESS_DETAIL"(ad_id
																									,ad_line1
																									,ad_line2
																									,ad_town 
																									,ad_post_code
																									,ad_country 
																									,ad_description 
																									,ad_invoice_entity)
																					VALUES ( v_address_detail.ad_id
																									,v_address_detail.ad_line1
																									,v_address_detail.ad_line2
																									,v_address_detail.ad_town 
																									,v_address_detail.ad_post_code
																									,v_address_detail.ad_country 
																									,v_address_detail.ad_description 
																									,v_address_detail.ad_invoice_entity);
				--
				--
				SELECT NEXTVAL('"IPYME_FINAL"."CARD_c_id_seq"') INTO v_card.c_id;
				v_card.c_invoice_entity := v_entity.ie_id;
				v_card.c_description := 'PRIMARY CARD';
				v_card.c_card_number := cust_card_number;
				v_card.c_name 				:= cust_card_name;
				v_card.c_expire_date := cust_card_expire;
				v_card.c_issue_numer := cust_card_issue;
				v_card.c_vendor := NULL;
				--
				INSERT INTO "IPYME_FINAL"."CARD" (c_id 
																				,c_invoice_entity 
																				,c_description 
																				,c_card_number 
																				,c_name 
																				,c_expire_date
																				,c_issue_numer
																				,c_vendor )
																	VALUES (v_card.c_id
																			,v_card.c_invoice_entity
																			,v_card.c_description
																			,v_card.c_card_number
																			,v_card.c_name 			
																			,v_card.c_expire_date
																			,v_card.c_issue_numer
																			,v_card.c_vendor);
				--
				--
				UPDATE "IPYME_FINAL"."USER"
				SET u_customer = v_customer.c_id
				WHERE u_id = v_cur_u_id;
				--
			ELSE
				--
				v_customer.c_id := v_cur_u_customer;
				--
			END IF;
			--
			IF NOT v_user_basket_reset THEN
				--
				UPDATE "IPYME_FINAL"."USER"
				SET u_basket = NULL
				WHERE u_id = v_cur_u_id;
				--
				v_user_basket_reset := TRUE;
				--
			END IF;
			--
			v_customer_identified := TRUE;
			--
		END IF;
		--
		--
		--
		IF NOT v_customer_order_created THEN
			--
			SELECT NEXTVAL('"IPYME_FINAL"."ORDER_CUSTOMER_oc_id_seq"') INTO v_order_customer.oc_id;
			v_order_customer.od_customer 	:= v_customer.c_id;
			v_order_customer.od_date 			:= now();
			INSERT INTO "IPYME_FINAL"."ORDER_CUSTOMER" (oc_id
																								,od_customer
																								,od_date)
																					VALUES (v_order_customer.oc_id
																								,v_order_customer.od_customer
																								,v_order_customer.od_date);
			--
			v_customer_order_created := TRUE;
			--
		END IF;
		--
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PRODUCT_LIST_pl_id_seq"') INTO v_product_list.pl_id;
		v_product_list.pl_order_customer			:= v_order_customer.oc_id;
		v_product_list.pl_order_provider			:= NULL;
		v_product_list.pl_product							:= v_cur_bl_product;
		v_product_list.pl_quantity						:= v_cur_bl_quantity;
		v_product_list.pl_currency						:= NULL;
		v_product_list.pl_store 							:= NULL;
		v_product_list.pl_quantity_dispatched	:= 0;
		--
		SELECT p_price, p_currency
		INTO v_product_list.pl_price, v_product_list.pl_currency
		FROM "IPYME_FINAL"."PRICES"
		WHERE p_product = v_cur_bl_product
		AND p_status = 1;
		--												
		INSERT INTO "IPYME_FINAL"."PRODUCT_LIST"(pl_id 
																						,pl_order_customer
																						,pl_order_provider
																						,pl_product
																						,pl_quantity
																						,pl_price 
																						,pl_currency
																						,pl_store 
																						,pl_quantity_dispatched)
																		VALUES (v_product_list.pl_id 
																						,v_product_list.pl_order_customer
																						,v_product_list.pl_order_provider
																						,v_product_list.pl_product
																						,v_product_list.pl_quantity
																						,v_product_list.pl_price 
																						,v_product_list.pl_currency
																						,v_product_list.pl_store 
																						,v_product_list.pl_quantity_dispatched);
		--
		--	
	END LOOP;
	--
	UPDATE "IPYME_FINAL"."BASKET"
	SET b_confirmed = 1
	WHERE b_id = p_b_id;
	--
	/*
	EXCEPTION
		WHEN OTHERS THEN
			NULL;
			*/
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_currency(p_c_id integer)
  RETURNS SETOF "IPYME_FINAL"."CURRENCY" AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY 	SELECT * 
								FROM "IPYME_FINAL"."CURRENCY"
								WHERE c_id = p_c_id OR p_c_id IS NULL;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;





CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_user_details(p_u_session character varying)
  RETURNS SETOF "IPYME_FINAL".user_details AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY SELECT	U.u_id 									AS user_u_id
				,U.u_session						AS user_u_session
				,U.u_last_login 				AS user_u_last_login
				,U.u_email							AS user_u_email
				,U.u_status							AS user_u_status
				,U.u_basket							AS user_u_basket
				,U.u_customer						AS user_u_customer
				,U.u_name								AS user_u_name
				,U.u_password_hash 			AS user_u_password_hash
				,U.u_admin							AS user_u_admin
				,C.c_id									AS customer_c_id
				,C.c_customer_name 			AS customer_c_customer_name
				,C.c_invoice_entity			AS customer_c_invoice_entity
				,IE.ie_id 							AS invoice_entity_ie_id
				,IE.ie_legal_id 				AS invoice_entity_ie_legal_id
				,IE.ie_invoice_name			AS invoice_entity_ie_invoice_name
				,CARD.c_id 							AS card_c_id
				,CARD.c_invoice_entity 	AS card_c_invoice_entity
				,CARD.c_description 		AS card_c_description
				,CARD.c_card_number 		AS card_c_card_number
				,CARD.c_name 						AS card_c_name
				,CARD.c_expire_date			AS card_c_expire_date
				,CARD.c_issue_numer 		AS card_c_issue_numer
				,CARD.c_vendor 					AS card_c_vendor
				,P.p_id 								AS people_p_id
				,P.p_title							AS people_p_title 
				,P.p_name 							AS people_p_name
				,P.p_surname 						AS people_p_surname
				,P.p_phone  						AS people_p_phone
				,P.p_invoice_entity 		AS people_p_invoice_entity
				,CV.cv_id								AS card_vendor_cv_id
				,CV.cv_name 						AS card_vendor_cv_name
				,BA.ba_id								AS bank_account_ba_id
				,BA.ba_invoice_entity		AS bank_account_ba_invoice_entity
				,BA.ba_number 						AS bank_account_ba_number
				,AD.ad_id								AS address_detail_ad_id
				,AD.ad_line1 						AS address_detail_ad_line1
				,AD.ad_line2 						AS address_detail_ad_line2
				,AD.ad_town 						AS address_detail_ad_town
				,AD.ad_post_code				AS address_detail_ad_post_code
				,AD.ad_country 					AS address_detail_ad_country
				,AD.ad_description			AS address_detail_ad_description
				,AD.ad_invoice_entity 	AS address_detail_ad_invoice_entity
				,COUNTRY.c_id 					AS country_c_id							
				,COUNTRY.c_name  				AS country_c_name
				,COUNTRY.c_code  				AS country_c_code
	FROM "IPYME_FINAL"."USER" U
	INNER JOIN "IPYME_FINAL"."CUSTOMER" C
	ON U.u_customer = C.c_id
	INNER JOIN "IPYME_FINAL"."INVOICE_ENTITY" IE
	ON IE.ie_id = C.c_invoice_entity
	LEFT JOIN "IPYME_FINAL"."CARD" CARD
	ON CARD.c_invoice_entity = IE.ie_id
	LEFT JOIN "IPYME_FINAL"."CARD_VENDOR" CV
	ON CARD.c_vendor = CV.cv_id
	LEFT JOIN "IPYME_FINAL"."ADDRESS_DETAIL" AD
	ON AD.ad_invoice_entity = IE.ie_id
	LEFT JOIN "IPYME_FINAL"."COUNTRY" COUNTRY
	ON COUNTRY.c_id = AD.ad_country
	LEFT JOIN "IPYME_FINAL"."BANK_ACCOUNT" BA
	ON BA.ba_invoice_entity = IE.ie_id
	LEFT JOIN "IPYME_FINAL"."PEOPLE" P
	ON P.p_invoice_entity = IE.ie_id
	WHERE u_session = p_u_session;
	--

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_countries(p_c_id integer)
  RETURNS SETOF "IPYME_FINAL"."COUNTRY" AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY 	SELECT * 
								FROM "IPYME_FINAL"."COUNTRY"
								WHERE c_id = p_c_id OR p_c_id IS NULL;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;




CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_payment_card(p_u_session text, p_c_id bigint, p_c_description text, p_c_card_number text, p_c_name text, p_c_expire_date text, p_c_issue_numer text, p_c_vendor text, p_cv_name text)
  RETURNS SETOF "IPYME_FINAL".card AS
$BODY$
DECLARE
v_card "IPYME_FINAL"."CARD";
v_card_vendor "IPYME_FINAL"."CARD_VENDOR";
v_invoice_entity BIGINT;
BEGIN
	--
	SELECT C.c_invoice_entity
	INTO v_invoice_entity
	FROM "IPYME_FINAL"."USER" U
	INNER JOIN "IPYME_FINAL"."CUSTOMER" C
	ON U.u_customer = C.c_id
	WHERE u_session = p_u_session
		AND u_status =1;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	SELECT *
	INTO v_card_vendor
	FROM "IPYME_FINAL"."CARD_VENDOR"
	WHERE cv_name = p_cv_name;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	SELECT *
	INTO v_card
	FROM "IPYME_FINAL"."CARD"
	WHERE c_invoice_entity = v_invoice_entity
		AND c_id = p_c_id;
	--
  v_card.c_invoice_entity	:= v_invoice_entity;
  v_card.c_description 		:= p_c_description;
  v_card.c_card_number 		:= p_c_card_number;
  v_card.c_name 					:= p_c_name;
  v_card.c_expire_date 		:= p_c_expire_date;
  v_card.c_issue_numer 		:= p_c_issue_numer;
  v_card.c_vendor 				:= v_card_vendor.cv_id;
	--
	IF NOT FOUND THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."CARD_c_id_seq"') INTO v_card.c_id;
		--
		INSERT INTO "IPYME_FINAL"."CARD"(c_id
																		,c_invoice_entity	
																		,c_description 		
																		,c_card_number 		
																		,c_name 					
																		,c_expire_date 	
																		,c_issue_numer 		
																		,c_vendor)
														VALUES (v_card.c_id
																		,v_card.c_invoice_entity	
																		,v_card.c_description 		
																		,v_card.c_card_number 		
																		,v_card.c_name 					
																		,v_card.c_expire_date 	
																		,v_card.c_issue_numer 		
																		,v_card.c_vendor);
		--
	ELSE
		--
		v_card.c_id := p_c_id;
		--
		UPDATE "IPYME_FINAL"."CARD"
		SET c_invoice_entity 	= v_card.c_invoice_entity	
				,c_description 		=	v_card.c_description 		
				,c_card_number 		= v_card.c_card_number 		
				,c_name 					= v_card.c_name 					
				,c_expire_date 		= v_card.c_expire_date 	
				,c_issue_numer 		= v_card.c_issue_numer 		
				,c_vendor 				= v_card.c_vendor
		WHERE c_id = v_card.c_id;
		--
	END IF;
	--
	RETURN QUERY SELECT v_card.*, v_card_vendor.*;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_address(p_u_session text, p_ad_id bigint, p_ad_line1 text, p_ad_line2 text, p_ad_town text, p_ad_post_code text, p_ad_description text, p_c_code text)
  RETURNS SETOF "IPYME_FINAL".address AS
$BODY$
DECLARE
v_address "IPYME_FINAL".address;
v_address_detail "IPYME_FINAL"."ADDRESS_DETAIL";
v_invoice_entity BIGINT;
v_country "IPYME_FINAL"."COUNTRY";
BEGIN
	--
	SELECT C.c_invoice_entity
	INTO v_invoice_entity
	FROM "IPYME_FINAL"."USER" U
	INNER JOIN "IPYME_FINAL"."CUSTOMER" C
	ON U.u_customer = C.c_id
	WHERE u_session = p_u_session
		AND u_status =1;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	SELECT *
	INTO v_country
	FROM "IPYME_FINAL"."COUNTRY"
	WHERE c_code = p_c_code;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	SELECT *
	INTO v_address_detail
	FROM "IPYME_FINAL"."ADDRESS_DETAIL"
	WHERE ad_invoice_entity = v_invoice_entity
		AND ad_id = p_ad_id;
	--
	v_address_detail.ad_line1 					:= p_ad_line1;
	v_address_detail.ad_line2 					:= p_ad_line2;
	v_address_detail.ad_town 						:= p_ad_town;
	v_address_detail.ad_post_code				:= p_ad_post_code;
	v_address_detail.ad_country					:= v_country.c_id;
	v_address_detail.ad_description			:= p_ad_description;
	v_address_detail.ad_invoice_entity 	:= v_invoice_entity;
	--
	IF NOT FOUND THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."ADDRESS_DETAIL_ad_id_seq"') INTO v_address_detail.ad_id;
		--
		INSERT INTO "IPYME_FINAL"."ADDRESS_DETAIL" (ad_id
																							,ad_line1 		
																							,ad_line2 	
																							,ad_town 	
																							,ad_post_code
																							,ad_country	
																							,ad_description
																							,ad_invoice_entity)
																			VALUES (v_address_detail.ad_id
																							,v_address_detail.ad_line1 		
																							,v_address_detail.ad_line2 	
																							,v_address_detail.ad_town 	
																							,v_address_detail.ad_post_code
																							,v_address_detail.ad_country	
																							,v_address_detail.ad_description
																							,v_address_detail.ad_invoice_entity);
		--
	ELSE
		--
		v_address_detail.ad_id := p_ad_id;
		--
		UPDATE "IPYME_FINAL"."ADDRESS_DETAIL"
		SET ad_line1 				 		= v_address_detail.ad_line1 				 
				,ad_line2 					= v_address_detail.ad_line2 					
				,ad_town 						=	v_address_detail.ad_town 						
				,ad_post_code				=	v_address_detail.ad_post_code				
				,ad_country					= v_address_detail.ad_country					
				,ad_description	 		= v_address_detail.ad_description			
				,ad_invoice_entity 	=	v_address_detail.ad_invoice_entity 	
		WHERE ad_id = v_address_detail.ad_id;
		--
	END IF;
	--
	RETURN QUERY SELECT v_address_detail.*, v_country.*;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;



	CREATE OR REPLACE FUNCTION "IPYME_FINAL".get_card_vendor(p_cv_id integer)
  RETURNS SETOF "IPYME_FINAL"."CARD_VENDOR" AS
$BODY$
DECLARE
BEGIN
	--
	RETURN QUERY 	SELECT * 
								FROM "IPYME_FINAL"."CARD_VENDOR"
								WHERE cv_id = p_cv_id OR p_cv_id IS NULL;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;




CREATE OR REPLACE FUNCTION "IPYME_FINAL".set_people(p_u_session text, p_p_id bigint, p_p_title text, p_p_name text, p_p_surname text, p_p_phone text)
  RETURNS SETOF "IPYME_FINAL".people_details AS
$BODY$
DECLARE
v_people "IPYME_FINAL"."PEOPLE";
v_user "IPYME_FINAL"."USER";
v_customer "IPYME_FINAL"."CUSTOMER";
v_invoice_entity "IPYME_FINAL"."INVOICE_ENTITY";
BEGIN
	--
	SELECT * 
	INTO v_user
	FROM "IPYME_FINAL"."USER" U
	WHERE U.u_session = p_u_session;
	--
	IF NOT FOUND THEN
		RETURN;
	END IF;
	--
	IF v_user.u_customer IS NULL THEN
		--
		SELECT nextval('"IPYME_FINAL"."INVOICE_ENTITY_ie_id_seq"') INTO v_invoice_entity.ie_id;
		v_invoice_entity.ie_legal_id := '';
		v_invoice_entity.ie_invoice_name := '';
		--
		INSERT INTO "IPYME_FINAL"."INVOICE_ENTITY"(ie_id 
																							,ie_legal_id 
																							,ie_invoice_name)
																			VALUES (v_invoice_entity.ie_id 
																							,v_invoice_entity.ie_legal_id 
																							,v_invoice_entity.ie_invoice_name); 
		--
		SELECT NEXTVAL('"IPYME_FINAL"."CUSTOMER_c_id_seq"') INTO v_customer.c_id;
		v_customer.c_customer_name := '';
		v_customer.c_invoice_entity := v_invoice_entity.ie_id;
		--
		INSERT INTO "IPYME_FINAL"."CUSTOMER" (c_id
																				,c_customer_name
																				,c_invoice_entity)
																	VALUES (v_customer.c_id
																				,v_customer.c_customer_name
																				,v_customer.c_invoice_entity);
		--
		UPDATE "IPYME_FINAL"."USER"
		SET u_customer = v_customer.c_id
		WHERE u_id = v_user.u_id;
		--
	ELSE
		--
		SELECT *
		INTO v_customer
		FROM "IPYME_FINAL"."CUSTOMER" C
		WHERE C.c_id = v_user.u_customer;		
		--
		SELECT *
		INTO v_invoice_entity
		FROM "IPYME_FINAL"."INVOICE_ENTITY" IE
		WHERE IE.ie_id = v_customer.c_invoice_entity;
		--
	END IF;
	--
	--
	SELECT *
	INTO v_people
	FROM "IPYME_FINAL"."PEOPLE"
	WHERE p_invoice_entity = v_invoice_entity.ie_id;
		--AND p_id = p_p_id; -- ONLY ONE PERSON ALLOWED FOR THE BETA VERSION
	--
  v_people.p_name 					:= p_p_name;
  v_people.p_surname 				:= p_p_surname;
  v_people.p_phone 					:= p_p_name;
  v_people.p_invoice_entity	:= v_invoice_entity.ie_id;
  v_people.p_title 					:= p_p_title;
	-- 
	IF NOT FOUND THEN
		--
		SELECT NEXTVAL('"IPYME_FINAL"."PEOPLE_p_id_seq"') INTO v_people.p_id;
		--
		INSERT INTO "IPYME_FINAL"."PEOPLE"(p_id
                                                    ,p_name 
                                                    ,p_surname
                                                    ,p_phone
                                                    ,p_invoice_entity
                                                    ,p_title)
                                            VALUES (v_people.p_id
                                                    ,v_people.p_name 
                                                    ,v_people.p_surname
                                                    ,v_people.p_phone
                                                    ,v_people.p_invoice_entity
                                                    ,v_people.p_title);
		--
	ELSE
		--
		UPDATE "IPYME_FINAL"."PEOPLE"
		SET p_name 						= v_people.p_name	
				,p_surname 				=	v_people.p_surname 		
				,p_phone 					= v_people.p_phone 	
				,p_invoice_entity	= v_people.p_invoice_entity
				,p_title 					= v_people.p_title
		WHERE p_id = v_people.p_id;
		--
	END IF;
  --
	RETURN QUERY SELECT v_people.p_id
											,v_people.p_name::text 
											,v_people.p_surname::text
											,v_people.p_phone::text
											,v_people.p_invoice_entity
											,v_people.p_title;
	--
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;


\dn

