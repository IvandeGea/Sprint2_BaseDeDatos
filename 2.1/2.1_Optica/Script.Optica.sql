CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`CLIENTS` (
  `idClients` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  `adreça_postal` VARCHAR(45) NULL,
  `telefon` VARCHAR(45) NULL,
  `correu_electronic` VARCHAR(45) NULL,
  `data_registre` DATE NULL,
  `client_recomanador_id` INT NULL,
  PRIMARY KEY (`idClients`),
  INDEX `client_recomanador_id_idx` (`client_recomanador_id` ASC) VISIBLE,
  CONSTRAINT `client_recomanador_id`
    FOREIGN KEY (`client_recomanador_id`)
    REFERENCES `Cul_d'ampolla`.`CLIENTS` (`idClients`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`Empleats` (
  `idEmpleats` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  `cognoms` VARCHAR(45) NULL,
  PRIMARY KEY (`idEmpleats`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`PROVEÏDOR` (
  `idPROVEEDORES` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  `adreça_carrer` VARCHAR(45) NULL,
  `adreça_numero` VARCHAR(4) NULL,
  `adreça_pis` VARCHAR(2) NULL,
  `adreça_porta` VARCHAR(2) NULL,
  `ciutat` VARCHAR(20) NULL,
  `codi_postal` VARCHAR(10) NULL,
  `país` VARCHAR(45) NULL,
  `telefon` VARCHAR(45) NULL,
  `fax` VARCHAR(45) NULL,
  `NIF` VARCHAR(45) NULL,
  `PROVEÏDORcol` VARCHAR(45) NULL,
  PRIMARY KEY (`idPROVEEDORES`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`ULLERES` (
  `idULLERES` INT NOT NULL,
  `marca` VARCHAR(45) NULL,
  `ProveidorId` INT NULL,
  `Preu` DECIMAL(10,2) NULL,
  `graduacio_vidre_dret` FLOAT NULL,
  `graduacio_vidre_esquerra` FLOAT NULL,
  `muntura` VARCHAR(45) NULL,
  `color_muntura` VARCHAR(45) NULL,
  `color_vidre_dret` VARCHAR(45) NULL,
  `color_vidre_esquerra` VARCHAR(45) NULL,
  PRIMARY KEY (`idULLERES`),
  INDEX `ProveidorId_idx` (`ProveidorId` ASC) VISIBLE,
  CONSTRAINT `ProveidorId`
    FOREIGN KEY (`ProveidorId`)
    REFERENCES `Cul_d'ampolla`.`PROVEÏDOR` (`idPROVEEDORES`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`VENDES` (
  `idVendes` INT NOT NULL,
  `client_id` INT NULL,
  `ulleres_id` INT NULL,
  `empleat_id` INT NULL,
  `data` DATE NULL,
  PRIMARY KEY (`idVendes`),
  INDEX `client_id_idx` (`client_id` ASC) VISIBLE,
  INDEX `ulleres_id_idx` (`ulleres_id` ASC) VISIBLE,
  INDEX `empleat_id_idx` (`empleat_id` ASC) VISIBLE,
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `Cul_d'ampolla`.`CLIENTS` (`idClients`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ulleres_id`
    FOREIGN KEY (`ulleres_id`)
    REFERENCES `Cul_d'ampolla`.`ULLERES` (`idULLERES`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `empleat_id`
    FOREIGN KEY (`empleat_id`)
    REFERENCES `Cul_d'ampolla`.`Empleats` (`idEmpleats`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;