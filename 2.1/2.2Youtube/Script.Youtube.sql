CREATE TABLE IF NOT EXISTS `Youtube`.`Usuaris` (
  `idUsuaris` INT NOT NULL AUTO_INCREMENT,
  `password` VARCHAR(45) NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `data_naixament` DATE NOT NULL,
  `sexe` ENUM('home', 'dona') NOT NULL,
  `país` VARCHAR(45) NOT NULL,
  `cp` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idUsuaris`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Youtube`.`Canals` (
  `idCanals` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `subscripts_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idCanals`),
  INDEX `subscripts_id_idx` (`subscripts_id` ASC) VISIBLE,
  INDEX `usuari_id_idx` (`usuari_id` ASC) VISIBLE,
  CONSTRAINT `subscripts_id`
    FOREIGN KEY (`subscripts_id`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `usuari_id`
    FOREIGN KEY (`usuari_id`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Youtube`.`Videos` (
  `idVideos` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(45) NOT NULL,
  `descripcio` TEXT(200) NULL,
  `grandaria` DECIMAL(6,2) NOT NULL,
  `nom_arxiu` VARCHAR(100) NOT NULL,
  `duració` TIME NOT NULL,
  `thumbnail` VARCHAR(25) NOT NULL,
  `reproduccións` FLOAT NULL DEFAULT 0,
  `likes` INT NULL DEFAULT NULL,
  `dislikes` INT NULL DEFAULT NULL,
  `usuario_creador` INT NOT NULL,
  `estat` ENUM('public', 'ocult', 'privat') NOT NULL DEFAULT 'public',
  `canal_id` INT NULL,
  `data/hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idVideos`),
  INDEX `Usuari_id_idx` (`usuario_creador` ASC) VISIBLE,
  INDEX `likes_idx` (`likes` ASC) VISIBLE,
  INDEX `dislikes_idx` (`dislikes` ASC) VISIBLE,
  INDEX `canal_id_idx` (`canal_id` ASC) VISIBLE,
  CONSTRAINT `usuario_creador`
    FOREIGN KEY (`usuario_creador`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `canal_id`
    FOREIGN KEY (`canal_id`)
    REFERENCES `Youtube`.`Canals` (`idCanals`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `likes`
    FOREIGN KEY (`likes`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `dislikes`
    FOREIGN KEY (`dislikes`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Youtube`.`PayList` (
  `idPayList` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `data` DATE NOT NULL DEFAULT (CURDATE()),
  `estat` ENUM('publica', 'privada') NOT NULL DEFAULT 'publica',
  `usuari_playList` INT NOT NULL,
  `videos_lista` INT NULL DEFAULT NULL,
  PRIMARY KEY (`idPayList`),
  INDEX `usuari_id_idx` (`usuari_playList` ASC) VISIBLE,
  INDEX `videos_id_idx` (`videos_lista` ASC) VISIBLE,
  CONSTRAINT `usuari_playList`
    FOREIGN KEY (`usuari_playList`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `videos_id`
    FOREIGN KEY (`videos_lista`)
    REFERENCES `Youtube`.`Videos` (`idVideos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Youtube`.`Etiquetas` (
  `idEtiquetas` INT NOT NULL AUTO_INCREMENT,
  `video_etiqueta` INT NOT NULL,
  `nom` VARCHAR(45) NOT NULL,
  `usuari_etiqueta` INT NOT NULL,
  `data/hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idEtiquetas`),
  INDEX `video_id_idx` (`video_etiqueta` ASC) VISIBLE,
  INDEX `usuari_id_idx` (`usuari_etiqueta` ASC) VISIBLE,
  CONSTRAINT `video_etiqueta`
    FOREIGN KEY (`video_etiqueta`)
    REFERENCES `Youtube`.`Videos` (`idVideos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `usuari_etiqueta`
    FOREIGN KEY (`usuari_etiqueta`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Youtube`.`Comentaris` (
  `idComentaris` INT NOT NULL AUTO_INCREMENT,
  `text` TEXT(200) NOT NULL,
  `data/hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `video_comentari` INT NOT NULL,
  PRIMARY KEY (`idComentaris`),
  INDEX `video_id_idx` (`video_comentari` ASC) VISIBLE,
  CONSTRAINT `video_comentari`
    FOREIGN KEY (`video_comentari`)
    REFERENCES `Youtube`.`Videos` (`idVideos`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `Youtube`.`dislikes` (
  `usuari_dislike` INT NOT NULL,
  `data/hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comentari_dislike` INT NOT NULL,
  INDEX `usuari_id_idx` (`usuari_dislike` ASC) VISIBLE,
  INDEX `comentari_id_idx` (`comentari_dislike` ASC) VISIBLE,
  CONSTRAINT `usuari_dislike`
    FOREIGN KEY (`usuari_dislike`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `comentari_dislike`
    FOREIGN KEY (`comentari_dislike`)
    REFERENCES `Youtube`.`Comentaris` (`idComentaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Youtube`.`Likes` (
  `usuari_like` INT NOT NULL,
  `data/hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comentari_like` INT NOT NULL,
  INDEX `comentari_id_idx` (`comentari_like` ASC) VISIBLE,
  INDEX `usuai_id_idx` (`usuari_like` ASC) VISIBLE,
  CONSTRAINT `usuai_like`
    FOREIGN KEY (`usuari_like`)
    REFERENCES `Youtube`.`Usuaris` (`idUsuaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `comentari_like`
    FOREIGN KEY (`comentari_like`)
    REFERENCES `Youtube`.`Comentaris` (`idComentaris`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;