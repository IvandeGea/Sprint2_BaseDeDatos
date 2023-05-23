CREATE TABLE IF NOT EXISTS `Pizzeria`.`Categorias` (
  `idCategorias` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  PRIMARY KEY (`idCategorias`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pizzeria`.`Pizzas` (
  `idPizzas` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  `tipo_masa` ENUM('fina', 'gruesa', 'rellena') NULL,
  `categoria` INT NULL,
  PRIMARY KEY (`idPizzas`),
  INDEX `categoria_idx` (`categoria` ASC) VISIBLE,
  CONSTRAINT `categoria`
    FOREIGN KEY (`categoria`)
    REFERENCES `Pizzeria`.`Categorias` (`idCategorias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pizzeria`.`Productes` (
  `idProductes` INT NOT NULL,
  `Nom` VARCHAR(45) NULL,
  `descripció` TEXT(100) NULL,
  `imatge` BLOB NULL,
  `preu` DECIMAL(6,2) NULL,
  `tipo_producte` ENUM('pizza', 'hamburguesa', 'beguda') NULL,
  `pizza_id` INT NULL,
  PRIMARY KEY (`idProductes`),
  INDEX `categoria_pizza_idx` (`pizza_id` ASC) VISIBLE,
  CONSTRAINT `categoria_pizza`
    FOREIGN KEY (`pizza_id`)
    REFERENCES `Pizzeria`.`Pizzas` (`idPizzas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pizzeria`.`Clients` (
  `idClients` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  `cognoms` VARCHAR(45) NULL,
  `adreça` VARCHAR(45) NULL,
  `codi_postal` VARCHAR(45) NULL,
  `localitat` VARCHAR(45) NULL,
  `provincia` VARCHAR(45) NULL,
  `telefon` VARCHAR(45) NULL,
  PRIMARY KEY (`idClients`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pizzeria`.`Empleats` (
  `idEmpleats` INT NOT NULL,
  `nom` VARCHAR(45) NULL,
  `cognoms` VARCHAR(45) NULL,
  `NIF` VARCHAR(45) NULL,
  `Telefon` VARCHAR(45) NULL,
  `carrec` ENUM('cocinero', 'repartidor') NULL,
  `botiga_id` INT NULL,
  PRIMARY KEY (`idEmpleats`),
  INDEX `botiga_id_idx` (`botiga_id` ASC) VISIBLE,
  CONSTRAINT `botiga_id`
    FOREIGN KEY (`botiga_id`)
    REFERENCES `Pizzeria`.`Botiga` (`idBotiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pizzeria`.`Botiga` (
  `idBotiga` INT NOT NULL,
  `adreça` VARCHAR(45) NULL,
  `codi_postal` VARCHAR(45) NULL,
  `localitat` VARCHAR(45) NULL,
  `provincia` VARCHAR(45) NULL,
  PRIMARY KEY (`idBotiga`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Pizzeria`.`Comandes` (
  `idComandes` INT NOT NULL,
  `Data/hora` DATETIME NULL,
  `tipo_comanda` ENUM('domicilio', 'recogida') NULL,
  `client_id` INT NULL,
  `productes_id` INT NULL,
  `preu_total` DECIMAL(6,2) NULL,
  `botiga` INT NULL,
  `repartidor_id` INT NULL,
  `hora_entrega` DATETIME NULL,
  PRIMARY KEY (`idComandes`),
  INDEX `botiga_id_idx` (`botiga` ASC) VISIBLE,
  INDEX `repartidor_id_idx` (`repartidor_id` ASC) VISIBLE,
  INDEX `client_id_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `Pizzeria`.`Clients` (`idClients`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `productes_id`
    FOREIGN KEY (`productes_id`)
    REFERENCES `Pizzeria`.`Productes` (`idProductes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `botiga`
    FOREIGN KEY (`botiga`)
    REFERENCES `Pizzeria`.`Botiga` (`idBotiga`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `repartidor_id`
    FOREIGN KEY (`repartidor_id`)
    REFERENCES `Pizzeria`.`Empleats` (`idEmpleats`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


--Llista quants productes de tipus “Begudes”. s'han venut en una determinada localitat.

SELECT p.Nom AS nom_producte, COUNT(*) AS total_productes
FROM Comandes c
JOIN Productes p ON c.productes_id = p.idProductes
JOIN Botiga b ON c.botiga = b.idBotiga
WHERE p.tipo_producte = 'beguda'
  AND b.localitat = 'Barcelona'
GROUP BY p.Nom;


--Llista quantes comandes ha efectuat un determinat empleat/da.