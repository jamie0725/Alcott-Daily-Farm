CREATE DATABASE farmDB;

USE farmDB;

CREATE TABLE Cattle (
	prefix               VARCHAR(255)      NOT NULL,
    suffix               INT               NOT NULL,
    earTag               VARCHAR(255),
    gender               ENUM('C','B')     NOT NULL,
    comments             TEXT,
    motherPrefix         VARCHAR(255),
    fatherPrefix         VARCHAR(255),
    motherSuffix         INT,
    fatherSuffix         INT,
    birthDate            DATE,
    boughtDate           DATE,
    soldDate             DATE,
    deathDate            DATE,
    
    CONSTRAINT PK_XFIX   PRIMARY KEY (prefix, suffix),
    CONSTRAINT UNQ_XFIX  UNIQUE (prefix, suffix),
    CONSTRAINT UNQ_TAG   UNIQUE (earTag),
    CONSTRAINT CK_DT     CHECK (soldDate >= boughtDate AND deathDate >= birthDate AND soldDate >= bornDate AND deathDate >= boughtDate),
    
    FOREIGN KEY (motherPrefix, motherSuffix) REFERENCES Cattle(prefix, suffix),
    FOREIGN KEY (fatherPrefix, fatherSuffix) REFERENCES Cattle(prefix, suffix)
    );
    
ALTER TABLE Cattle
ADD CONSTRAINT CK_MXFIX  CHECK (
		(motherPrefix, motherSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'C')
		OR (motherPrefix is NULL AND motherSuffix is NULL)
		),
ADD	CONSTRAINT CK_FXFIX  CHECK (
		(fatherPrefix, fatherSuffix) IN (SELECT (prefix, suffix) FROM Cattle WHERE gender = 'B')
		OR (fatherPrefix is NULL AND fatherSuffix is NULL)
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
    inseminationState    ENUM('Y','N')    NOT NULL,
    medicationState      ENUM('Y','N')    NOT NULL,
    
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
    mpcState             ENUM('Y','N')    NOT NULL,
    
    CONSTRAINT PK_STA    PRIMARY KEY (staffName),
    CONSTRAINT UNQ_STA   UNIQUE (staffName)
    );  
    
CREATE TABLE Milk (
	cowPrefix            VARCHAR(255)     NOT NULL,
    cowSuffix            INT              NOT NULL,
    productDate          DATETIME         NOT NULL,
    fat                  FLOAT            NOT NULL,
    volume               FLOAT            NOT NULL,
    lipidity             FLOAT AS (fat/(volume*10))             NOT NULL,
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
    
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, deathDate, comments)
		VALUE('Jo', 52, '699-140', 'C', '2008-01-05', '2010-07-16', 'Died at July 16, 2010');
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate)
		VALUE('Meg', 30, '699-141', 'C', '2008-01-20');
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate)
		VALUE('Fritz', 15, '699-142', 'B', '2008-03-26');
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, soldDate, comments)
		VALUE('Fritz', 16, '699-143', 'B', '2008-03-26', '2008-04-14', 'Missing front right leg');
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix, comments)
		VALUE('Jo', 70, '699-181', 'C', '2009-06-15', 'Jo', 52, 'Fritz', 15, 'Received 1 dose of antibiotics per day from April 5, 2010 until April 26, 2010');
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Jo', 71, '699-182', 'C', '2009-06-15', 'Jo', 52, 'Fritz', 15);
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, boughtDate, Comments)
		VALUE('John', 1, '699-183', 'B', '2009-07-02', '2010-07-10',  'Acquired on July 10, 2010');
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Fritz', 17, '699-205', 'B', '2010-07-16', 'Jo', 52, 'Fritz', 15);
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Meg', 42, '699-184', 'C', '2009-09-05', 'Meg', 30, 'Fritz', 15);
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, soldDate, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Fritz', 19, '699-185', 'B', '2009-09-05', '2009-10-05', 'Meg', 30, 'Fritz', 15);
INSERT INTO Cattle (prefix, suffix, earTag, gender, birthDate, deathDate, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix, comments)
		VALUE('Meg', 46, '699-186', 'C', '2010-10-10', '2010-10-17', 'Meg', 30, 'Fritz', 15, 'Died of illness on October 17');
-- Here are cattles that is not listed officially in the chat, but in the pedigree.
INSERT INTO Cattle (prefix, suffix, gender, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Jo', 84, 'C', 'Jo', 70, 'John', 1);
INSERT INTO Cattle (prefix, suffix, gender, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('John', 2, 'B', 'Jo', 71, 'John', 1);
INSERT INTO Cattle (prefix, suffix, gender, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Meg', 52, 'C', 'Meg', 42, 'Fritz', 17);
INSERT INTO Cattle (prefix, suffix, gender, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Fritz', 23, 'B', 'Meg', 42, 'Fritz', 17);
INSERT INTO Cattle (prefix, suffix, gender, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Fritz', 24, 'B', 'Meg', 42, 'Fritz', 17);
INSERT INTO Cattle (prefix, suffix, gender, motherPrefix, motherSuffix, fatherPrefix, fatherSuffix)
		VALUE('Fritz', 25, 'B', 'Jo', 71, 'Fritz', 23);

INSERT INTO Staff (staffName, salary, job, skill, mpcState)
		VALUE('Bronson Alcott', '2400', 'Manager', 'MSc. Agricultural engineering, tractor license, milking parlor certificate', 'Y');
INSERT INTO Staff (staffName, salary, job, skill, mpcState)
		VALUE('William Alcott', '2200', 'General Executive', 'BSc. Agri. Engineering, milking parlor certificate', 'Y');
INSERT INTO Staff (staffName, salary, job, mpcState)
		VALUE('Abby May Alcott', '1800', 'Secretary & cook', 'N');
INSERT INTO Staff (staffName, salary, job, mpcState)
		VALUE('Louisa May Alcott', '1800', 'Shopkeeper', 'N');
INSERT INTO Staff (staffName, salary, job, skill, mpcState)
		VALUE('Heinrich Pestalozzi', '1800', 'Stableboy', 'tractor license', 'N');
INSERT INTO Staff (staffName, salary, job, mpcState)
		VALUE('George Sand', '1700', 'Stableboy', 'N');
INSERT INTO Staff (staffName, salary, job, skill, mpcState)
		VALUE('Lloyd Garrison', '1800', 'Stableboy', 'milking parlor certificate', 'Y');
        
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Jo', 70, '2011-04-02 07:20:00', 11.35, 910.27, 1, 'Bronson Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Jo', 71, '2011-04-02 07:30:00', 10.77, 838.983, 1, 'Bronson Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Meg', 42, '2011-04-02 07:40:00', 12.30, 858.54, 1, 'Bronson Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Meg', 30, '2011-04-02 07:20:00', 10.50, 892.5, 2, 'William Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Jo', 70, '2011-04-02 19:40:00', 11.10, 886.89, 1, 'William Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Jo', 71, '2011-04-02 19:40:00', 10.88, 848.64, 2, 'Bronson Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Meg', 42, '2011-04-02 19:50:00', 12.50, 843.75, 1, 'William Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Meg', 30, '2011-04-02 19:50:00', 10.23, 879.78, 2, 'Bronson Alcott');
INSERT INTO Milk (cowPrefix, cowSuffix, productDate, volume, fat, parlorNr, mpcStaffName)
		VALUE('Jo', 70, '2011-04-03 07:20:00', 11.40, 889.2, 1, 'Bronson Alcott');
        