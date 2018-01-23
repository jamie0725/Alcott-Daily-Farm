CREATE DATABASE farmDB;

USE farmDB;

CREATE TABLE Cattle (
	Prefix               VARCHAR(20)     NOT NULL,
    Suffix               INT             NOT NULL,
    EarTag               CHAR(7)         NOT NULL    UNIQUE,
    Gender               CHAR(1)         NOT NULL    CHECK(Gender in ('B','C')),
    Comments             VARCHAR(1000),
    mPrefix              VARCHAR(20),
    fPrefix              VARCHAR(20),
    mSuffix              INT,
    fSuffix              INT,
    birthDate            DATETIME,
    boughtDate           DATETIME,
    soldDate             DATETIME,
    deathDate            DATETIME,
    PRIMARY KEY (Prefix, Suffix)
    );
    
CREATE TABLE Cow (
	cowPrefix            VARCHAR(20)     NOT NULL,
    cowSuffix            INT             NOT NULL,
    calveNr              INT,
    inseminationState    CHAR(1)         CHECK(inseminationState in ('Y','N')),
    medicineState        CHAR(1)         CHECK(medicineState in ('Y','N')),
    PRIMARY KEY (cowPrefix, cowSuffix)
    );
    
CREATE TABLE BullInShed (
	bullPrefix           VARCHAR(20)     NOT NULL,
    bullSuffix           INT             NOT NULL,
    PRIMARY KEY (bullPrefix, bullSuffix)
    );
    
CREATE TABLE Insemination (
	cowPrefix            VARCHAR(20)     NOT NULL,
    cowSuffix            INT             NOT NULL,
    inseminationDate     DATETIME        NOT NULL,
	bullPrefix           VARCHAR(20)     NOT NULL,
    bullSuffix           INT             NOT NULL,
    PRIMARY KEY (cowPrefix, cowSuffix, bullPrefix, bullSuffix, inseminationDate)
    );
    
CREATE TABLE Staff (
	staffName            VARCHAR(20)        NOT NULL,
    job                  VARCHAR(20)        NOT NULL,
    skill                VARCHAR(20),
	salary               DECIMAL(7,2)       NOT NULL,
    mpcState             CHAR(1)            NOT NULL        CHECK(mpcState in ('Y','N')),
    PRIMARY KEY (staffName)
    );
    
CREATE TABLE Milk (
	cowPrefix            VARCHAR(20)      NOT NULL,
    cowSuffix            INT              NOT NULL,
    instanceNr           INT              NOT NULL,
    productDate          DATETIME         NOT NULL,
    lipidity             DECIMAL(3,2)     NOT NULL,
    fat                  DECIMAL(5,2)     NOT NULL,
    volume               DECIMAL(4,2)     NOT NULL,
    parlorNr             INT              NOT NULL,
    mpcStaffName         VARCHAR(20)      NOT NULL,
    PRIMARY KEY (cowPrefix, cowSuffix, instanceNr, productDate)
    );

