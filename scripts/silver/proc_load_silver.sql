INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date

)

SELECT

	cst_id,
	cst_key,
	TRIM(cst_firstname) as cst_firstname, -- Removing unwanted spaces
	TRIM(cst_lastname) as cst_lastname,
	CASE WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
		 WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
		 ELSE 'Unknown'
	END AS cst_marital_status, -- Normalize marital values to real readable format
	CASE WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
		 WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
		 ELSE 'Unknown'
	END AS cst_gndr, -- Normalize gender values to real readable format
	cst_create_date

FROM (


	SELECT 
	*, 
	ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	FROM bronze.crm_cust_info

) t

WHERE flag_last = 1 -- Removing duplicates
