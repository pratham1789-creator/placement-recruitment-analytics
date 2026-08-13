USE placement_analytics;

CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    location VARCHAR(50),
    experience INT,
    skills VARCHAR(255)
);

CREATE TABLE Companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    company_tier INT,
    website VARCHAR(255),
    linkedin VARCHAR(255),
    location VARCHAR(100)
);

CREATE TABLE Jobs (
    job_id INT PRIMARY KEY,
    company_id INT NOT NULL,
    job_title VARCHAR(100),
    job_type VARCHAR(50),
    location VARCHAR(100),
    exp_required INT,

    FOREIGN KEY (company_id)
        REFERENCES Companies(company_id)
);

CREATE TABLE Recruitment_Stages (
    stage_id INT PRIMARY KEY,
    stage_name VARCHAR(100) NOT NULL,
    stage_order INT NOT NULL
);

CREATE TABLE Applications (
    application_id INT PRIMARY KEY,
    candidate_id INT NOT NULL,
    job_id INT NOT NULL,
    applied_date DATE NOT NULL,

    FOREIGN KEY (candidate_id)
        REFERENCES Candidates(candidate_id),

    FOREIGN KEY (job_id)
        REFERENCES Jobs(job_id)
);

CREATE TABLE Application_Stages (
    stage_record_id INT PRIMARY KEY,
    application_id INT NOT NULL,
    stage_id INT NOT NULL,
    stage_date DATE NOT NULL,
    result VARCHAR(100),

    FOREIGN KEY (application_id)
        REFERENCES Applications(application_id),

    FOREIGN KEY (stage_id)
        REFERENCES Recruitment_Stages(stage_id)
);
