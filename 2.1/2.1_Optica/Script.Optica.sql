CREATE SCHEMA IF NOT EXISTS `Cul_d'ampolla` DEFAULT CHARACTER SET utf8 ;
USE `Cul_d'ampolla` ;

-- -----------------------------------------------------
-- Table `Cul_d'ampolla`.`PROVEÏDOR`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`PROVEÏDOR` (
  `idPROVEEDORES` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `adreça_carrer` VARCHAR(45) NOT NULL,
  `adreça_numero` VARCHAR(4) NOT NULL,
  `adreça_pis` VARCHAR(2) NULL,
  `adreça_porta` VARCHAR(2) NULL,
  `ciutat` VARCHAR(20) NOT NULL,
  `codi_postal` VARCHAR(10) NOT NULL,
  `país` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `fax` VARCHAR(45) NULL,
  `NIF` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idPROVEEDORES`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cul_d'ampolla`.`ULLERES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`ULLERES` (
  `idULLERES` INT NOT NULL AUTO_INCREMENT,
  `marca` VARCHAR(45) NOT NULL,
  `ProveidorId` INT NOT NULL,
  `Preu` DECIMAL(10,2) NOT NULL,
  `graduacio_vidre_dret` FLOAT NOT NULL,
  `graduacio_vidre_esquerra` FLOAT NOT NULL,
  `muntura` VARCHAR(45) NOT NULL,
  `color_muntura` VARCHAR(45) NOT NULL,
  `color_vidre_dret` VARCHAR(45) NOT NULL,
  `color_vidre_esquerra` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idULLERES`),
  INDEX `ProveidorId_idx` (`ProveidorId` ASC) VISIBLE,
  CONSTRAINT `ProveidorId`
    FOREIGN KEY (`ProveidorId`)
    REFERENCES `Cul_d'ampolla`.`PROVEÏDOR` (`idPROVEEDORES`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cul_d'ampolla`.`CLIENTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`CLIENTS` (
  `idClients` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `adreça_postal` VARCHAR(45) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `correu_electronic` VARCHAR(45) NOT NULL,
  `data_registre` DATE NOT NULL,
  `client_recomanador_id` INT NOT NULL,
  PRIMARY KEY (`idClients`),
  INDEX `client_recomanador_id_idx` (`client_recomanador_id` ASC) VISIBLE,
  CONSTRAINT `client_recomanador_id`
    FOREIGN KEY (`client_recomanador_id`)
    REFERENCES `Cul_d'ampolla`.`CLIENTS` (`idClients`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cul_d'ampolla`.`Empleats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`Empleats` (
  `idEmpleats` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `cognoms` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEmpleats`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cul_d'ampolla`.`VENDES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cul_d'ampolla`.`VENDES` (
  `idVendes` INT NOT NULL AUTO_INCREMENT,
  `client_id` INT NOT NULL,
  `ulleres_id` INT NOT NULL,
  `empleat_id` INT NOT NULL,
  `data` DATE NOT NULL,
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