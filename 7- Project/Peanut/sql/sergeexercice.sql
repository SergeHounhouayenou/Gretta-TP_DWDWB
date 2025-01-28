-- Table cible
CREATE TABLE `cible` (
    id INT PRIMARY KEY , not null auto_increment,
    type VARCHAR(50),
    status VARCHAR(50),
    role VARCHAR(50)
) engine innodb;

-- Table digit
CREATE TABLE `digit` (
    id INT PRIMARY KEY, not null auto_increment,
    function VARCHAR(100),
    network_path VARCHAR(100)
) engine innodb;

-- Table actant
CREATE TABLE `actant` (
    id INT PRIMARY KEY, not null auto_increment,
    type VARCHAR(50),
    capabilities TEXT
);

-- Table acteur
CREATE TABLE `acteur` (
    id INT PRIMARY KEY, not null auto_increment,
    name VARCHAR(100),
    role VARCHAR(50),
    status VARCHAR(50)
)engine innodb;

-- Table action
CREATE TABLE `action` (
    id INT PRIMARY KEY, not null auto_increment,
    description TEXT,
    timestamp DATETIME,
    type VARCHAR(50),
    status VARCHAR(50),
    validation_status BOOLEAN
)engine innodb;

-- Table control
CREATE TABLE `control` (
    id INT PRIMARY KEY, not null auto_increment,
    capabilities TEXT,
    monitoring_scope TEXT
)engine innodb;

-- Table droit
CREATE TABLE `droit` (
    id INT PRIMARY KEY, not null auto_increment,
    description TEXT,
    role VARCHAR(50),
    status VARCHAR(50)
)engine innodb;

-- Table devoir
CREATE TABLE `devoir` (
    id INT PRIMARY KEY, not null auto_increment,
    description TEXT,
    role VARCHAR(50),
    status VARCHAR(50)
)engine innodb;

-- Table regle
CREATE TABLE `regle` (
    id INT PRIMARY KEY, not null auto_increment,
    description TEXT,
    scope TEXT
)engine innodb;

-- Table validation
CREATE TABLE `validation` (
    id INT PRIMARY KEY, not null auto_increment,
    action_id INT,
    validator_id INT,
    status VARCHAR(50),
    backend_parameters TEXT,
    FOREIGN KEY (action_id) REFERENCES action(id),
    FOREIGN KEY (validator_id) REFERENCES control(id)
)engine innodb;

-- Table Attribution
CREATE TABLE `Attribution` (
    id INT PRIMARY KEY, not null auto_increment,
    role_id INT,
    droit_id INT,
    status VARCHAR(50),
    FOREIGN KEY (role_id) REFERENCES acteur(id),
    FOREIGN KEY (droit_id) REFERENCES droit(id)
)engine innodb;

-- Table Configuration
CREATE TABLE `Configuration` (
    id INT PRIMARY KEY, not null auto_increment,
    setting_name VARCHAR(100),
    value TEXT,
    scope TEXT
)engine innodb;

-- Table contentieux
CREATE TABLE `contentieux` (
    id INT PRIMARY KEY, not null auto_increment,
    description TEXT,
    evidence TEXT,
    status VARCHAR(50)
)engine innodb;

insert into `cible` (type, status, role)
value   (),
        ();

insert into `digit` (function, network_path)
value   (),
        ();

insert into `actant` (type, capabilities)
value   (),
        ();

insert into `acteur`(name, role, status)
value   (),
        ();

insert into `action` (description, type, status)
value   (),
        ();

insert into `control` (capabilities, monitoring_scope)
value   (),
        ();

insert into `droit` (description, role, status)
value   (),
        ();

insert into `devoir`(description, role, status)
value   (),
        ();

insert into `regle`(description, scope)
value   (),
        ();

insert into `validation`(action_id, validator_id status, backend_parameters),   )
value   (),
        ();

insert into `Attribution`(role_id, droit_id, status)
value   (),
        ();

insert into `Configuration`(setting_name, value, scope)
value   (),
        ();

insert into `contentieux` (description, evidence, status)
value   (),
        ();
