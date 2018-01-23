CREATE DATABASE farmDB;

USE farmDB;

CREATE TABLE Cattle (
	prefix               VARCHAR(255)      NOT NULL,
    suffix               INT               NOT NULL,
    earTag               VARCHAR(255)      NOT NULL,
    gender               CHAR(1)           NOT NULL    CHECK(Gender in ('B','C')),
    comments             TEXT,
    mPrefix              VARCHAR(255),
    fPrefix              VARCHAR(255),
    mSuffix              INT,
    fSuffix              INT,
    birthDate            DATETIME,
    boughtDate           DATETIME,
    soldDate             DATETIME,
    deathDate            DATETIME,
    
    CONSTRAINT PK_XFIX   PRIMARY KEY (prefix, suffix),
    CONSTRAINT UNQ_XFIX  UNIQUE (prefix, suffix),
    CONSTRAINT UNQ_TAG   UNIQUE (earTag),
    CONSTRAINT CK_DT     CHECK (soldDate >= boughtDate AND deathDate >= birthDate AND soldDate >= bornDate AND deathDate >= boughtDate),
    
    FOREIGN KEY (mPrefix, mSuffix) REFERENCES Cattle(prefix, suffix),
    FOREIGN KEY (fPrefix, fSuffix) REFERENCES Cattle(prefix, suffix)
    );
    
ALTER TABLE Cattle
ADD CONSTRAINT CK_MXFIX  CHECK (
		(mPrefix, mSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'C')
		OR (mPrefix is NULL AND mSuffix is NULL)
		),
ADD	CONSTRAINT CK_FXFIX  CHECK (
		(fPrefix, fSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'B')
		OR (fPrefix is NULL AND fSuffix is NULL)
		);
    
CREATE TABLE Insemination (
	cowPrefix            VARCHAR(255)     NOT NULL,
    cowSuffix            INT              NOT NULL,
    inseminationDate     DATETIME         NOT NULL,
	bullPrefix           VARCHAR(255)     NOT NULL,
    bullSuffix           INT              NOT NULL,
    
    CONSTRAINT PK_INSEM    PRIMARY KEY (cowPrefix, cowSuffix, inseminationDate),
    CONSTRAINT UNQ_INSEM   UNIQUE (cowPrefix, cowSuffix, inseminationDate),
    
	FOREIGN KEY (cowPrefix, cowSuffix)    REFERENCES Cattle(prefix, suffix),
	FOREIGN KEY (bullPrefix, bullSuffix)  REFERENCES Cattle(prefix, suffix),
    
	CONSTRAINT CK_INSEM_CXFIX  CHECK (
		(cowPrefix, cowSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'C')
		),
	CONSTRAINT CK_INSEM_BXFIX  CHECK (
		(bullPrefix, bullSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'B')
		)
    );
    
CREATE TABLE Medication (
	cowPrefix            VARCHAR(255)     NOT NULL,
    cowSuffix            INT              NOT NULL,
    medicationDate       DATETIME         NOT NULL,
    
    CONSTRAINT PK_MED    PRIMARY KEY (cowPrefix, cowSuffix, medicationDate),
    CONSTRAINT UNQ_MED   UNIQUE (cowPrefix, cowSuffix, medicationDate),
    
	FOREIGN KEY (cowPrefix, cowSuffix) REFERENCES Cattle(prefix, suffix),
    
	CONSTRAINT CK_INSEM_CXFIX  CHECK (
		(cowPrefix, cowSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'C')
		)
    );
    
CREATE TABLE Cow (
	cowPrefix            VARCHAR(255)     NOT NULL,
    cowSuffix            INT              NOT NULL,
    calveNr              INT,
    inseminationState    CHAR(1)          CHECK(inseminationState in ('Y','N')),
    medicineState        CHAR(1)          CHECK(medicineState in ('Y','N')),
    
    CONSTRAINT PK_COW    PRIMARY KEY (cowPrefix, cowSuffix),
    CONSTRAINT UNQ_COW   UNIQUE (cowPrefix, cowSuffix),
    
    FOREIGN KEY (cowPrefix, cowSuffix) REFERENCES Cattle(prefix, suffix),
    
	CONSTRAINT CK_INSEM_CXFIX  CHECK (
		(cowPrefix, cowSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'C')
		)
    );  
    
CREATE TABLE BullInShed (
	bullPrefix           VARCHAR(255)     NOT NULL,
    bullSuffix           INT              NOT NULL,
    
    CONSTRAINT PK_BULL   PRIMARY KEY (bullPrefix, bullSuffix),
	
    FOREIGN KEY (bullPrefix, bullSuffix) REFERENCES Cattle(prefix, suffix)
    );
    
CREATE TABLE Staff (
	staffName            VARCHAR(255)     NOT NULL,
    job                  TEXT             NOT NULL,
    skill                TEXT,
	salary               DECIMAL(7,2)     NOT NULL,
    mpcState             CHAR(1)          NOT NULL        CHECK(mpcState in ('Y','N')),
    
    CONSTRAINT PK_STA    PRIMARY KEY (staffName),
    CONSTRAINT UNQ_STA   UNIQUE (staffName)
    );  
    
CREATE TABLE Milk (
	cowPrefix            VARCHAR(255)     NOT NULL,
    cowSuffix            INT              NOT NULL,
    productDate          DATETIME         NOT NULL,
    lipidity             FLOAT            NOT NULL,
    fat                  FLOAT            NOT NULL,
    volume               FLOAT            NOT NULL,
    parlorNr             INT              NOT NULL,
    mpcStaffName         VARCHAR(255)     NOT NULL,
    
    CONSTRAINT PK_MILK   PRIMARY KEY (cowPrefix, cowSuffix, productDate),
    
    FOREIGN KEY (cowPrefix, cowSuffix) REFERENCES Cattle(prefix, suffix),
	FOREIGN KEY (mpcStaffName) REFERENCES Staff(staffName)
    );

ALTER TABLE Milk
ADD CONSTRAINT CK_MPC    CHECK (
		(mpcStaffName)  IN (SELECT staffName FROM Staff WHERE skill LIKE '%milking parlor certificate%')
	);