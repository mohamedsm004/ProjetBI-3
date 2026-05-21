ALTER TABLE raw.dim_branches ADD PRIMARY KEY (branch_id);
ALTER TABLE raw.dim_customers ADD PRIMARY KEY (customer_id);
ALTER TABLE raw.dim_time ADD PRIMARY KEY (date_id);
ALTER TABLE raw.dim_transaction_type ADD PRIMARY KEY (type_id);
ALTER TABLE raw.fct_transactions ADD PRIMARY KEY (branch_id, customer_id, date_id, transaction_type, transaction_id);

ALTER TABLE raw.fct_transactions 
ADD CONSTRAINT fk_branch 
FOREIGN KEY (branch_id) REFERENCES raw.dim_branches(branch_id);

ALTER TABLE raw.fct_transactions 
ADD CONSTRAINT fk_customer 
FOREIGN KEY (customer_id) REFERENCES raw.dim_customers(customer_id);

ALTER TABLE raw.fct_transactions 
ADD CONSTRAINT fk_date 
FOREIGN KEY (date_id) REFERENCES raw.dim_time(date_id);

ALTER TABLE raw.fct_transactions 
ADD CONSTRAINT fk_transaction_type 
FOREIGN KEY (transaction_type) REFERENCES raw.dim_transaction_type(type_id);
