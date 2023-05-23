CREATE TABLE IF NOT EXISTS `Spotify`.`Usuaris` (
  `idUsuaris` INT NOT NULL AUTO_INCREMENT,
  `tipus_usuari` ENUM('free', 'premium') NOT NULL DEFAULT 'free',
  `Email` VARCHAR(45) NOT NULL,
  `Password` VARCHAR(45) NOT NULL,
  `Nom` VARCHAR(15) NOT NULL,
  `Data_naixament` DATE NOT NULL,
  `Sexe` ENUM('Masculi', 'Femeni') NOT NULL,
  `País` VARCHAR(45) NOT NULL,
  `Cp` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idUsuaris`))
ENGINE = InnoDB;
CREATE TABLE IF NOT EXISTS `Spotify`.`Subscripcions` (
  `usuari_premium` INT NOT NULL,
  `data_inici` DATE NOT NULL,
  `data_renovació` DATE NOT NULL,
  `forma_pagament` VARCHAR(45) NOT NULL,
  `SubscripcionsID` INT NOT NULL,
  PRIMARY KEY (`SubscripcionsID`),
  INDEX `usuari_premium_idx` (`usuari_premium` ASC) VISIBLE,
  CONSTRAINT `usuari_premium`
    FOREIGN KEY (`usuari_premium`)
    REFERENCES `Spotify`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Pagaments_Targeta` (
  `Subscripció_targeta` INT NOT NULL,
  `Numero_targeta` VARCHAR(45) NOT NULL,
  `caducitat_targeta` DATE NOT NULL,
  `Codi_seguretat` VARCHAR(5) NOT NULL,
  INDEX `Subscripcio_targeta_idx` (`Subscripció_targeta` ASC) VISIBLE,
  CONSTRAINT `Subscripcio_targeta`
    FOREIGN KEY (`Subscripció_targeta`)
    REFERENCES `Spotify`.`Subscripcions` (`SubscripcionsID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Pagament_PayPal` (
  `Subscripcio_PayPal` INT NOT NULL,
  `Usuari_PayPal` VARCHAR(45) NOT NULL,
  INDEX `Subscripcio_PayPal_idx` (`Subscripcio_PayPal` ASC) VISIBLE,
  CONSTRAINT `Subscripcio_PayPal`
    FOREIGN KEY (`Subscripcio_PayPal`)
    REFERENCES `Spotify`.`Subscripcions` (`SubscripcionsID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Pagaments` (
  `idPagaments` INT NOT NULL AUTO_INCREMENT,
  `Usuari_Pagaments` INT NOT NULL,
  `Data` DATE NOT NULL,
  `Numero_pagament` FLOAT NULL,
  `Total` FLOAT NOT NULL,
  PRIMARY KEY (`idPagaments`),
  UNIQUE INDEX `Numero_pagament_UNIQUE` (`Numero_pagament` ASC) VISIBLE,
  INDEX `Usuari_pagaments_idx` (`Usuari_Pagaments` ASC) VISIBLE,
  CONSTRAINT `Usuari_pagaments`
    FOREIGN KEY (`Usuari_Pagaments`)
    REFERENCES `Spotify`.`Subscripcions` (`usuari_premium`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Artistas` (
  `idArtistas` INT NOT NULL AUTO_INCREMENT,
  `Nom` VARCHAR(45) NOT NULL,
  `Imatge_Artista` BLOB NOT NULL,
  `genere_musical` ENUM('Rock', 'Pop', 'Jazz', 'Hip-hop', 'Electrónica', 'Reggae', 'Country', 'R&B', 'Clásica', 'Metal', 'Folk', 'Indie', 'Salsa', 'Reguetón', 'Blues') NOT NULL,
  `Idioma` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idArtistas`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Album` (
  `idAlbum` INT NOT NULL AUTO_INCREMENT,
  `Artista` INT NOT NULL,
  `Titol` VARCHAR(45) NOT NULL,
  `Any` YEAR(4) NOT NULL,
  `Portada` BLOB NULL,
  PRIMARY KEY (`idAlbum`),
  INDEX `Artista_idx` (`Artista` ASC) VISIBLE,
  CONSTRAINT `Artista`
    FOREIGN KEY (`Artista`)
    REFERENCES `Spotify`.`Artistas` (`idArtistas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Cançons` (
  `idCançons` INT NOT NULL AUTO_INCREMENT,
  `Album_id` INT NOT NULL,
  `Titol` VARCHAR(45) NOT NULL,
  `Durada` TIME NOT NULL,
  `Reproduccións` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idCançons`),
  INDEX `Album_id_idx` (`Album_id` ASC) VISIBLE,
  CONSTRAINT `Album_id`
    FOREIGN KEY (`Album_id`)
    REFERENCES `Spotify`.`Album` (`idAlbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Seguidores` (
  `idSeguidores` INT NOT NULL,
  `id_Seguidor` INT NOT NULL,
  `idArtista` INT NOT NULL,
  PRIMARY KEY (`idSeguidores`),
  INDEX `idArtista_idx` (`idArtista` ASC) VISIBLE,
  INDEX `id_seguidor_idx` (`id_Seguidor` ASC) VISIBLE,
  CONSTRAINT `idArtista`
    FOREIGN KEY (`idArtista`)
    REFERENCES `Spotify`.`Artistas` (`idArtistas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_seguidor`
    FOREIGN KEY (`id_Seguidor`)
    REFERENCES `Spotify`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Favoritos` (
  `Usuario_favoritos` INT NOT NULL,
  `Album_favoritos` INT NULL,
  `Canço_favoritos` INT NULL,
  INDEX `Canço_favoritos_idx` (`Canço_favoritos` ASC) VISIBLE,
  INDEX `Album_favoritos_idx` (`Album_favoritos` ASC) VISIBLE,
  INDEX `Usuari_favoritos_idx` (`Usuario_favoritos` ASC) VISIBLE,
  CONSTRAINT `Canço_favoritos`
    FOREIGN KEY (`Canço_favoritos`)
    REFERENCES `Spotify`.`Cançons` (`idCançons`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Album_favoritos`
    FOREIGN KEY (`Album_favoritos`)
    REFERENCES `Spotify`.`Album` (`idAlbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Usuari_favoritos`
    FOREIGN KEY (`Usuario_favoritos`)
    REFERENCES `Spotify`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`PlayList` (
  `idPlayList` INT NOT NULL AUTO_INCREMENT,
  `Titol` VARCHAR(45) NOT NULL,
  `Nombre_cançons` VARCHAR(45) NOT NULL,
  `Data_Creació` DATE NOT NULL,
  `Estat` ENUM('actives', 'esborrades') NULL,
  `Cançons_PlayList` INT NULL,
  `Usuaris_PlayList` INT NULL,
  PRIMARY KEY (`idPlayList`),
  INDEX `Cançons_PlayList_idx` (`Cançons_PlayList` ASC) VISIBLE,
  INDEX `Usuaris_PlayList_idx` (`Usuaris_PlayList` ASC) VISIBLE,
  CONSTRAINT `Cançons_PlayList`
    FOREIGN KEY (`Cançons_PlayList`)
    REFERENCES `Spotify`.`Cançons` (`idCançons`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Usuaris_PlayList`
    FOREIGN KEY (`Usuaris_PlayList`)
    REFERENCES `Spotify`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Spotify`.`Cançons_PlayList` (
  `PlayList_id` INT NOT NULL,
  `Canço_id` INT NOT NULL,
  `Usuari_PlayList` INT NOT NULL,
  INDEX `Usuaris_PlayList_idx` (`Usuari_PlayList` ASC) VISIBLE,
  INDEX `PlayList_id_idx` (`PlayList_id` ASC) VISIBLE,
  INDEX `Canço_id_idx` (`Canço_id` ASC) VISIBLE,
  CONSTRAINT `Usuari_PlayList`
    FOREIGN KEY (`Usuari_PlayList`)
    REFERENCES `Spotify`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `PlayList_id`
    FOREIGN KEY (`PlayList_id`)
    REFERENCES `Spotify`.`PlayList` (`idPlayList`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Canço_id`
    FOREIGN KEY (`Canço_id`)
    REFERENCES `Spotify`.`Cançons` (`idCançons`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB