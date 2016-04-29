ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_email_password_key UNIQUE (email, password);

ALTER TABLE ONLY nodes
    ADD CONSTRAINT nodes_pkey PRIMARY KEY (id);
