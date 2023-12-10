-- MySQL dump 10.13  Distrib 8.0.24, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: horarios
-- ------------------------------------------------------
-- Server version	8.0.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (3,'Academico'),(2,'Coordinador'),(1,'Docente');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (3,1,8),(5,1,12),(7,1,16),(10,1,20),(12,1,21),(13,1,22),(14,1,23),(15,1,24),(16,1,30),(1,1,32),(2,1,36),(4,1,40),(6,1,44),(9,1,48),(8,1,49),(11,1,52),(17,2,8),(18,2,12),(19,2,16),(20,2,20),(21,2,21),(22,2,22),(23,2,23),(24,2,24),(25,2,26),(26,2,28),(27,2,29),(28,2,30),(29,2,31),(30,2,32),(31,2,33),(32,2,34),(33,2,35),(34,2,36),(35,2,40),(36,2,41),(37,2,42),(38,2,43),(39,2,44),(40,2,45),(41,2,46),(42,2,47),(43,2,48),(44,2,50),(45,2,51),(46,2,52),(47,3,8),(48,3,12),(49,3,13),(50,3,20),(51,3,21),(52,3,22),(53,3,23),(54,3,24),(55,3,25),(56,3,26),(57,3,27),(58,3,28),(59,3,29),(60,3,30),(61,3,31),(62,3,32),(63,3,33),(64,3,34),(65,3,35),(66,3,36),(67,3,37),(68,3,38),(69,3,39),(70,3,40),(71,3,41),(72,3,42),(73,3,43),(74,3,44),(75,3,45),(76,3,46),(77,3,47),(78,3,48),(79,3,49),(80,3,50),(81,3,51),(82,3,52);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add coordinador',7,'add_coordinador'),(26,'Can change coordinador',7,'change_coordinador'),(27,'Can delete coordinador',7,'delete_coordinador'),(28,'Can view coordinador',7,'view_coordinador'),(29,'Can add docente',8,'add_docente'),(30,'Can change docente',8,'change_docente'),(31,'Can delete docente',8,'delete_docente'),(32,'Can view docente',8,'view_docente'),(33,'Can add grupo',9,'add_grupo'),(34,'Can change grupo',9,'change_grupo'),(35,'Can delete grupo',9,'delete_grupo'),(36,'Can view grupo',9,'view_grupo'),(37,'Can add licenciatura',10,'add_licenciatura'),(38,'Can change licenciatura',10,'change_licenciatura'),(39,'Can delete licenciatura',10,'delete_licenciatura'),(40,'Can view licenciatura',10,'view_licenciatura'),(41,'Can add unidad aprendizaje',11,'add_unidadaprendizaje'),(42,'Can change unidad aprendizaje',11,'change_unidadaprendizaje'),(43,'Can delete unidad aprendizaje',11,'delete_unidadaprendizaje'),(44,'Can view unidad aprendizaje',11,'view_unidadaprendizaje'),(45,'Can add horarios',12,'add_horarios'),(46,'Can change horarios',12,'change_horarios'),(47,'Can delete horarios',12,'delete_horarios'),(48,'Can view horarios',12,'view_horarios'),(49,'Can add horario_disponible',13,'add_horario_disponible'),(50,'Can change horario_disponible',13,'change_horario_disponible'),(51,'Can delete horario_disponible',13,'delete_horario_disponible'),(52,'Can view horario_disponible',13,'view_horario_disponible'),(53,'Can add configuracion',14,'add_configuracion'),(54,'Can change configuracion',14,'change_configuracion'),(55,'Can delete configuracion',14,'delete_configuracion'),(56,'Can view configuracion',14,'view_configuracion');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$DdDrR1JNjrhoUXhH9FsAU9$AAgHfEci+lO1b5XhJ8CVIX8NiBBXVPbyPVWGVEBKnfg=','2021-06-08 21:51:24.062292',1,'Admin','','','asdasd@asdaj.com',1,1,'2021-05-26 18:33:39.000000'),(2,'pbkdf2_sha256$260000$J4fWKG24WDEvYi3FGL4jCW$JtkVmIyF61bUDvwogUZaPain3600txGWAHxylRWkjFY=','2021-06-22 17:34:30.581180',0,'Academico','Benjamín','López González','blopezg@uaemex.mx',0,1,'2021-05-26 18:39:32.000000'),(3,'pbkdf2_sha256$260000$h1HgVb0Ckl041kM6QkxuPT$RjKAFR5GiQHpFBofYGaLVWj0G6EzDC7brHg+NhO+rAk=','2021-06-22 17:43:48.791939',0,'gaavilavi@uaemex.mx','Gerardo Arturo','Ávila Vilchis ','gaavilavi@uaemex.mx',0,1,'2021-05-26 18:47:42.148664'),(4,'pbkdf2_sha256$260000$91nQad2CkWYDVd0qeLcjPv$zz44+SGXjDp8lkyj35OCJMIAPZEUhczfbxv009HuPKg=','2021-06-07 17:42:50.630801',0,'blopezg@uaemex.mx','Benjamín','López Gónzalez ','blopezg@uaemex.mx',0,1,'2021-05-26 21:25:51.399634'),(5,'pbkdf2_sha256$260000$u9aQCjVfvMm5CEKkGXAlmo$jgW9Htu/MDL1fyBVZy38E0rpFADjchFKo3CxNM3bIL8=',NULL,0,'mcamachoa@uaemex.mx','Marcela','Camacho Avila','mcamachoa@uaemex.mx',0,1,'2021-05-26 21:30:43.498509'),(6,'pbkdf2_sha256$260000$OfLnNcKJ9cR5moJVVmrPal$rX0Z5p2ucp3a/qv/G2RvLsgx6v3p87QkKkGYk5MN8ck=',NULL,0,'ebernalr@uaemex.mx','Esmeralda','Bernal Romero','ebernalr@uaemex.mx',0,1,'2021-05-26 21:32:20.577207'),(7,'pbkdf2_sha256$260000$HolSwkD4ZTZLnZDTXZfYL8$EXtZ/IpcnJVR/gkdyby3WsD3qtUbn0cNrVr+Fkxj+IA=',NULL,0,'amartinezr@uaemex.mx','Armando','Martínez Reyes ','amartinezr@uaemex.mx',0,1,'2021-05-26 21:34:06.851448'),(8,'pbkdf2_sha256$260000$C3Sfq5dtoHMpyLeXcWlVsh$yZftreWsm2Cyr8as18g65tfL1scLtva0sb0SyqNlLEg=','2021-06-16 17:19:22.917445',0,'spalaciosa@uaemex.mx','Selene','Palacios Astudillo','spalaciosa@uaemex.mx',0,1,'2021-05-26 21:36:14.328387'),(9,'pbkdf2_sha256$260000$dIBFlGkVvth7wuMtrqPCkg$s9x9WtX5U8SSnPTqxP+knpOFkUY4jT7o6zrV1tV716I=',NULL,0,'msanchezs@uaemex.mx','Mauro','Sánchez Sánchez','msanchezs@uaemex.mx',0,1,'2021-05-26 21:41:05.659936'),(10,'pbkdf2_sha256$260000$zTxT8K9erLInAM47WAfv2P$g2Y8tipCXY7Nb/JD/LJ5f5gBgLh6diF9ZOr/knuTgu0=',NULL,0,'jamartinezp@uaemex.mx','Jose Arturo','Martinez Perez','jamartinezp@uaemex.mx',0,1,'2021-05-26 21:42:26.087584'),(11,'pbkdf2_sha256$260000$utm9OvudV2kvGGp4pkxH19$fsn2spWQPJGjhkGQbBTimQXB/rhAILV/Ic6usn7Wwpo=',NULL,0,'jltapiaf@uaemex.mx','Jose Luis','Tapia Fabela','jltapiaf@uaemex.mx',0,1,'2021-05-26 21:43:27.976831'),(12,'pbkdf2_sha256$260000$5mDbvm87T4T4Fdzxbqwq7I$NHs0q206/vja8Zwa+Y6wPXw8l5Xf4QvHglg2I1anTOU=',NULL,0,'cetorresr@uaemex.mx','Carlos Eduardo','Torres Reyes','cetorresr@uaemex.mx',0,1,'2021-05-26 21:46:52.372585'),(13,'pbkdf2_sha256$260000$XOcU7ycdIOqrUQ99rdieoi$V+yl4IKNzWXlX8cjZLdkjcj1UiujTxAh/ATP2Z3y1L4=',NULL,0,'lgonzalesm@uaemex.mx','Leonor','Gonzales Muñoz','lgonzalesm@uaemex.mx',0,1,'2021-05-26 21:48:43.425758'),(14,'pbkdf2_sha256$260000$iqVz1D23Me8M7saAmrwi4e$TN3Qj0PRErm3Y8aB39Nfl32KMgV5TcQl2Vxf6utSzns=',NULL,0,'jgarcilazor@uaemex.mx','Julieta','Garcilazo Reyes ','jgarcilazor@uaemex.mx',0,1,'2021-05-26 21:50:48.104512'),(15,'pbkdf2_sha256$260000$Exe4ca0bLPiDsX6RaCfnib$Cg0Nnh4isrTzPG+dNICdYxD4NSeqjWAzlo/7DbGrARA=','2021-06-18 15:30:11.723613',0,'mtaguilars@uaemex.mx','María Teresa','Aguílar Sepúlveda','mtaguilars@uaemex.mx',0,1,'2021-05-26 21:52:38.670333'),(16,'pbkdf2_sha256$260000$FGlFPvaiFst8VIRn842mBR$eJJl+XcVa6GZedupmDe1018Tq9/1YHcOeCIpUUDqHEQ=',NULL,0,'lortizv@uaemex.mx','Liniana','Oritiz Villagran','lortizv@uaemex.mx',0,1,'2021-05-26 21:54:10.783890'),(17,'pbkdf2_sha256$260000$vH9RuwKQNYgMuXQ40Zkvvt$lRJ5Aaz4inVFnl64DMbVgYlHCr/+P6p+LCK6KVkomrA=',NULL,0,'igonzalesdc@uaemex.mx','Ismael','Gonzales del Campo','igonzalesdc@uaemex.mx',0,1,'2021-05-26 21:55:45.105909'),(18,'pbkdf2_sha256$260000$4RxR6BcYJHIsNOsHo03MuA$rvW/EsI+iRQl5hDUCGE6rQ4d6gCcBtwaUYrqwXpTLos=',NULL,0,'dhernandezb@uaemex.mx','David ','Hernandez Benitez','dhernandezb@uaemex.mx',0,1,'2021-05-26 21:57:20.140262'),(19,'pbkdf2_sha256$260000$t3MEpYS2FEAImAhibcA96o$h8kbrzSNuHGalwkyo6RNAd8DDp+XZtI4uEj/vsr4Cf8=',NULL,0,'yhernandezc@uaemex.mx','Yanet','Hernandez Casimiro','yhernandezc@uaemex.mx',0,1,'2021-05-26 21:58:53.044688'),(20,'pbkdf2_sha256$260000$p4eOsmLj05H45RldaPKKBP$8PekjYLHk+ZxyC+SHYjd//+NU8DaBOrMOIE/5RZre2s=',NULL,0,'gamatiasm@uaemex.mx','Griselda Areli','Matias Mendoza','gamatiasm@uaemex.mx',0,1,'2021-05-26 22:01:12.140418'),(21,'pbkdf2_sha256$260000$JCZNbkl1Y8CNie0SxE8ENP$g5/5j5w46rDnYjofpBNd+3GVGD2TlNgicT5fUSFA1CU=',NULL,0,'brodriguezg@uaemex.mx','Bertha','Rodriguez Guitierrez ','brodriguezg@uaemex.mx',0,1,'2021-05-26 22:02:34.784274'),(22,'pbkdf2_sha256$260000$6kmGNxEHGvb7Dtz3LszeYs$ZKOomQiNX30A0Bz0oRNO9UQ7RMBQn+4gSuP8oj20m6Q=',NULL,0,'efierro@uaemex.mx','Elizabeth','Fierro','efierro@uaemex.mx',0,1,'2021-05-26 22:04:15.625786'),(23,'pbkdf2_sha256$260000$FOtROwPC3iF6ANIJEeyh4K$TMfEd4OdJEBxyYKiKOEhsuO1SjceuK5dC1kEgghOCUg=',NULL,0,'jarmeagag@uaemex.mx','Jovanni','Armeaga Garcia','jarmeagag@uaemex.mx',0,1,'2021-05-26 22:07:43.614140'),(24,'pbkdf2_sha256$260000$mFhIykE5nx4htbrJvNUpHI$GEqaRhmsp5993lNNZegolLL7yPu7kI1AG3PkiRp4xKg=',NULL,0,'repulidoa@uaemex.mx','Rocio Elizabeth','Pulido Alba','repulidoa@uaemex.mx',0,1,'2021-05-26 22:09:07.443905'),(25,'pbkdf2_sha256$260000$Hx4mm3CBd9oWkjZoEFjMc2$4jO9+dfCYuA6hS+LkmgBjEKXrAd8iGrk8xLPjKxBEf8=',NULL,0,'mcverae@uaemex.mx','Martin Carlos ','Vera Estrada','mcverae@uaemex.mx',0,1,'2021-05-26 22:10:48.336914'),(26,'pbkdf2_sha256$260000$3eFjGD6Yc3qQjZraz9can0$j2Yrb475UPG75vyCT8bBHvEt2vQHepBCfqKBQMW0Ftw=',NULL,0,'mnphinojosag@uaemex.mx','Mara Nefertiti Patricia','Hinojosa Garduño ','mnphinojosag@uaemex.mx',0,1,'2021-05-26 22:13:13.209374'),(27,'pbkdf2_sha256$260000$uL2v4c0dloZTre2eoGe2Fu$IlrZFzXnX/vWnro+lnGsIDvG+eV7XzjWLeVmHCZGteM=',NULL,0,'vajurezba@uaemex.mx','Victor Axel','Juárez Bartolo','vajurezba@uaemex.mx',0,1,'2021-05-27 15:18:57.569581'),(28,'pbkdf2_sha256$260000$cxeoXzvf3omv8iteIAKd93$3rLWNkKNsAnY+nHlmW8EP1vs00UJosQ/HiCjIZd+dKI=',NULL,0,'jlgonzalezr@uaemex.mx','Jacobo Leonardo','Gonzalez Ruiz','jlgonzalezr@uaemex.mx',0,1,'2021-05-27 15:20:31.190731'),(29,'pbkdf2_sha256$260000$ffhpOPUEXxrlgbMTg6zNRW$1gE52bIDVC+7bOhXypo500stmvcbhqLQgI44hNK0Jfk=',NULL,0,'ifvalencia@uaemex.mx','Ivan Francisco','Valencia','ifvalencia@uaemex.mx',0,1,'2021-05-27 15:22:20.328091'),(30,'pbkdf2_sha256$260000$PuGKbAYyimJ9fhIySTvyPY$tVYtbbly6ZNtrMqgWH+PRkK4YoMf1mf/v+c+IaXlj5Y=',NULL,0,'malcantaraf@uaemex.mx','Maria','Alcantara Fernandez','malcantaraf@uaemex.mx',0,1,'2021-05-27 15:23:43.055223'),(31,'pbkdf2_sha256$260000$49v5k5hHIzoJ08aCJGKmDm$VGJEJ1ZbxCb6lqnsmXYKkraCac7BySRKzxQOsUNR6Gc=',NULL,0,'nacolinm@uaemex.mx','Noe Armando','Colin Mercado','nacolinm@uaemex.mx',0,1,'2021-05-27 15:24:58.487997'),(32,'pbkdf2_sha256$260000$gGt9SyrXrbxYPKI3GQg0AI$zSn31aOamAfdhJYkcGhJRqTzlKGtzyDYT2NrXi/YFAw=',NULL,0,'mgarciaa@uaemex.mx','Martin','Garcia Avila','mgarciaa@uaemex.mx',0,1,'2021-05-27 15:27:32.492127'),(33,'pbkdf2_sha256$260000$ab9gQq4y3lyHLLdMR6h8Ls$wfvZ9RUcAr1qmKdY3Y2flpb4MGKx/mzUsdpz3v2u6xk=',NULL,0,'afonsecam@uaemex.mx','Adriana','Fonseca Munguía','afonsecam@uaemex.mx',0,1,'2021-05-27 15:29:36.672525'),(34,'pbkdf2_sha256$260000$B66UJmnvsqPnmO5uA8PwZl$TQThv73MhoXUziKTpMFfSF0pUY4j/3CWawMRv2pHS7Y=',NULL,0,'ynledeneva@uaemex.mx','Yulia Nikolaevna','Ledeneva','ynledeneva@uaemex.mx',0,1,'2021-05-27 15:32:48.814960'),(35,'pbkdf2_sha256$260000$85IeXwdrTWksja6moaRzcn$UOhiEc1CTWQbZMlt+/DfL04lLAOzNX17myUXoR/Rhfc=',NULL,0,'ggonzalezv@uaemex.mx','Gilda','Gonzalez Villaseñor','ggonzalezv@uaemex.mx',0,1,'2021-05-27 15:35:25.047861'),(36,'pbkdf2_sha256$260000$gGUjbrTkpsuqSlLesMUBBU$B43GiP26O6xIGPkgPBtDiQFNVqNelkzltsd5aPCONtc=',NULL,0,'jscelios@uaemex.mx','Jose Alberto','Celio Sandoval','jscelios@uaemex.mx',0,1,'2021-05-27 15:37:08.359775'),(39,'pbkdf2_sha256$260000$MWcZ4lykNCAILe5Fpx2OL4$FWraVZQ17TMSXzeoNY+QUHeB3Co7zz0PL3EfhFaQpAc=',NULL,0,'vjuarez@uaemex.mx','Víctor Axel','Juarez','vjuarez@uaemex.mx',0,1,'2021-06-07 18:26:49.313225'),(40,'pbkdf2_sha256$260000$yNW0HISb1hwKDa6PNrP8Kg$Vzx8Ruzyc6krUTE48qlSUTIoYJoIApcjpRnTGrbdb+U=','2021-06-22 17:42:54.800060',0,'szaragozah@uaemex.mx','Sergio','Zaragoza','szaragozah@uaemex.mx',0,1,'2021-06-07 18:47:18.413290');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,1,3),(2,2,3),(3,3,1),(55,3,2),(5,4,1),(6,5,1),(7,6,1),(8,7,1),(9,8,1),(52,8,2),(10,9,1),(11,10,1),(12,11,1),(13,12,1),(14,13,1),(15,14,1),(16,15,1),(17,16,1),(18,17,1),(19,18,1),(20,19,1),(21,20,1),(22,21,1),(23,22,1),(24,23,1),(25,24,1),(26,25,1),(27,26,1),(28,27,1),(29,28,1),(30,29,1),(31,30,1),(32,31,1),(33,32,1),(34,33,1),(35,34,1),(36,35,1),(37,36,1),(53,39,1),(54,40,1);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2021-05-26 18:35:35.308106','1','Docente',1,'[{\"added\": {}}]',3,1),(2,'2021-05-26 18:36:27.723264','2','Coordinador',1,'[{\"added\": {}}]',3,1),(3,'2021-05-26 18:37:22.300879','3','Academico',1,'[{\"added\": {}}]',3,1),(4,'2021-05-26 18:37:36.405830','1','Admin',2,'[{\"changed\": {\"fields\": [\"Groups\"]}}]',4,1),(5,'2021-05-26 18:39:32.189417','2','Academico',1,'[{\"added\": {}}]',4,1),(6,'2021-05-26 18:40:33.700347','2','Academico',2,'[{\"changed\": {\"fields\": [\"First name\", \"Last name\", \"Email address\", \"Groups\"]}}]',4,1),(7,'2021-05-27 17:47:33.513540','37','vjuarez@uaemex.mx',3,'',4,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(14,'horarios','configuracion'),(7,'horarios','coordinador'),(8,'horarios','docente'),(9,'horarios','grupo'),(13,'horarios','horario_disponible'),(12,'horarios','horarios'),(10,'horarios','licenciatura'),(11,'horarios','unidadaprendizaje'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2021-05-26 18:31:12.946473'),(2,'auth','0001_initial','2021-05-26 18:31:22.534762'),(3,'admin','0001_initial','2021-05-26 18:31:24.685794'),(4,'admin','0002_logentry_remove_auto_add','2021-05-26 18:31:24.779115'),(5,'admin','0003_logentry_add_action_flag_choices','2021-05-26 18:31:24.906073'),(6,'contenttypes','0002_remove_content_type_name','2021-05-26 18:31:26.194101'),(7,'auth','0002_alter_permission_name_max_length','2021-05-26 18:31:27.301710'),(8,'auth','0003_alter_user_email_max_length','2021-05-26 18:31:27.572334'),(9,'auth','0004_alter_user_username_opts','2021-05-26 18:31:27.649302'),(10,'auth','0005_alter_user_last_login_null','2021-05-26 18:31:28.335291'),(11,'auth','0006_require_contenttypes_0002','2021-05-26 18:31:28.412427'),(12,'auth','0007_alter_validators_add_error_messages','2021-05-26 18:31:28.497920'),(13,'auth','0008_alter_user_username_max_length','2021-05-26 18:31:29.338465'),(14,'auth','0009_alter_user_last_name_max_length','2021-05-26 18:31:30.266385'),(15,'auth','0010_alter_group_name_max_length','2021-05-26 18:31:30.412925'),(16,'auth','0011_update_proxy_permissions','2021-05-26 18:31:30.501740'),(17,'auth','0012_alter_user_first_name_max_length','2021-05-26 18:31:31.548593'),(18,'horarios','0001_initial','2021-05-26 18:31:44.261046'),(19,'horarios','0002_auto_20210526_1831','2021-05-26 18:31:52.802597'),(20,'sessions','0001_initial','2021-05-26 18:31:53.691444'),(21,'horarios','0003_configuracion','2021-05-28 16:37:10.881824');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('e5pxpxfarumtmsg80y3s0kow0nm3u930','.eJxVjMsOwiAQRf-FtSFQ3i7d-w1kZgCpGkhKuzL-uzbpQrf3nHNfLMK21riNvMQ5sTNT7PS7IdAjtx2kO7Rb59TbuszId4UfdPBrT_l5Ody_gwqjfmsESMKCE36ytkwKs05GoZdGEBkqgKEIq8gpIYt2NkEI0ueApK0oUrH3B_G0N_g:1lvkRA:xSvzj0h5hgEBfUF7dwIrnMJ9sdmpKwSqJRU3QtyOntg','2021-07-06 17:43:48.903675'),('m262fav08t9po63vlh6bh1sdb90bhiwr','.eJxVjMsOwiAQRf-FtSFQ3i7d-w1kZgCpGkhKuzL-uzbpQrf3nHNfLMK21riNvMQ5sTNT7PS7IdAjtx2kO7Rb59TbuszId4UfdPBrT_l5Ody_gwqjfmsESMKCE36ytkwKs05GoZdGEBkqgKEIq8gpIYt2NkEI0ueApK0oUrH3B_G0N_g:1lmfnu:sh7EaWltsnMARUjf-znjlfR_nwZYSklz_ryZgnBXr3I','2021-06-11 16:57:46.186424');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_configuracion`
--

DROP TABLE IF EXISTS `horarios_configuracion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_configuracion` (
  `llave` varchar(100) NOT NULL,
  `valor` longtext NOT NULL,
  PRIMARY KEY (`llave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_configuracion`
--

LOCK TABLES `horarios_configuracion` WRITE;
/*!40000 ALTER TABLE `horarios_configuracion` DISABLE KEYS */;
INSERT INTO `horarios_configuracion` VALUES ('fechalimite','2021-06-19');
/*!40000 ALTER TABLE `horarios_configuracion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_coordinador`
--

DROP TABLE IF EXISTS `horarios_coordinador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_coordinador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `activo` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `horarios_coordinador_user_id_307c1fa8_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_coordinador`
--

LOCK TABLES `horarios_coordinador` WRITE;
/*!40000 ALTER TABLE `horarios_coordinador` DISABLE KEYS */;
INSERT INTO `horarios_coordinador` VALUES (6,1,8),(7,1,3);
/*!40000 ALTER TABLE `horarios_coordinador` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_docente`
--

DROP TABLE IF EXISTS `horarios_docente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_docente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `grado_academico` varchar(40) NOT NULL,
  `nombre_grado` varchar(150) NOT NULL,
  `tipo_de_docente` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `horarios_docente_user_id_8f00d49b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_docente`
--

LOCK TABLES `horarios_docente` WRITE;
/*!40000 ALTER TABLE `horarios_docente` DISABLE KEYS */;
INSERT INTO `horarios_docente` VALUES (1,'Maestria','Ciencias Computacionales',1,3),(2,'Maestria','Ciencias',1,4),(3,'Doctorado','Ciencias Computacionales',2,5),(4,'Licenciatura','Matemáticas',2,6),(5,'Maestria','Matemáticas',2,7),(6,'Maestria','Ciencias',2,8),(7,'Maestria','Ciencias',2,9),(8,'Doctorado','Ciencias Computacionales',2,10),(9,'Doctorado','Ingeniería',1,11),(10,'Doctorado','Ciencias Computacionales',2,12),(11,'Licenciatura','Ingeniería Industrial',2,13),(12,'Maestria','Ciencias Computacionales',2,14),(13,'Maestria','Lenguas',1,15),(14,'Maestria','Lenguas Extranjeras ',1,16),(15,'Licenciatura','Ingeniería en Computación',2,17),(16,'Maestria','Ciencias Computacionales',2,18),(17,'Maestria','Ciencias Computacionales',2,19),(18,'Doctorado','Ciencias Computacionales',2,20),(19,'Licenciatura','Lenguas Extranjeras ',2,21),(20,'Maestria','Lenguas Extranjeras ',2,22),(21,'Maestria','Ciencias Computacionales',1,23),(22,'Maestria','Ciencias Computacionales',2,24),(23,'Doctorado','Ingeniería',1,25),(24,'Licenciatura','Ingeniería en Computación',2,26),(25,'Maestria','Ingeniería de Software',1,27),(26,'Doctorado','Ciencias Computacionales',2,28),(27,'Doctorado','Ciencias Computacionales',2,29),(28,'Maestria','Arquitectura de Software',2,30),(29,'Doctorado','Administración',2,31),(30,'Maestria','Ciencias Computacionales',1,32),(31,'Doctorado','Administración',1,33),(32,'Doctorado','Ciencias Computacionales',1,34),(33,'Doctorado','Ciencias Computacionales',1,35),(34,'Maestria','Ciencias Computacionales',2,36),(37,'Licenciatura','Ingeniería de Software',1,39),(38,'Licenciatura','Ingeniería de Software',2,40);
/*!40000 ALTER TABLE `horarios_docente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_grupo`
--

DROP TABLE IF EXISTS `horarios_grupo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_grupo` (
  `siglas` varchar(4) NOT NULL,
  `semestre` int NOT NULL,
  `licenciatura_id` int NOT NULL,
  PRIMARY KEY (`siglas`),
  KEY `horarios_grupo_licenciatura_id_987eed56_fk_horarios_` (`licenciatura_id`),
  CONSTRAINT `horarios_grupo_licenciatura_id_987eed56_fk_horarios_` FOREIGN KEY (`licenciatura_id`) REFERENCES `horarios_licenciatura` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_grupo`
--

LOCK TABLES `horarios_grupo` WRITE;
/*!40000 ALTER TABLE `horarios_grupo` DISABLE KEYS */;
INSERT INTO `horarios_grupo` VALUES ('IP1',1,3),('S2',2,1);
/*!40000 ALTER TABLE `horarios_grupo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_horario_disponible`
--

DROP TABLE IF EXISTS `horarios_horario_disponible`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_horario_disponible` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dia` int NOT NULL,
  `hora_inicio` int NOT NULL,
  `hora_final` int NOT NULL,
  `docente_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `horarios_horario_dis_docente_id_6df7a46d_fk_horarios_` (`docente_id`),
  CONSTRAINT `horarios_horario_dis_docente_id_6df7a46d_fk_horarios_` FOREIGN KEY (`docente_id`) REFERENCES `horarios_docente` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_horario_disponible`
--

LOCK TABLES `horarios_horario_disponible` WRITE;
/*!40000 ALTER TABLE `horarios_horario_disponible` DISABLE KEYS */;
INSERT INTO `horarios_horario_disponible` VALUES (9,1,0,2,3),(10,1,4,6,3),(11,1,8,10,3),(12,3,0,2,3),(13,3,4,6,3),(14,3,8,10,3),(15,1,0,7,4),(16,3,0,7,4),(17,3,0,7,5),(18,0,0,4,6),(19,1,8,12,6),(20,2,0,4,6),(21,3,8,12,6),(22,0,0,9,7),(23,2,0,9,7),(24,4,0,9,7),(25,2,0,3,8),(26,4,0,3,8),(27,1,7,10,9),(28,3,7,10,9),(29,0,5,8,10),(30,2,5,8,10),(31,0,4,10,11),(32,2,4,10,11),(33,0,4,12,12),(34,2,4,12,12),(36,4,0,7,14),(37,0,0,3,15),(38,0,5,8,15),(39,2,0,3,15),(40,2,5,8,15),(41,0,0,3,16),(42,1,0,7,16),(43,2,0,3,16),(44,3,0,7,16),(45,1,8,11,17),(46,2,8,14,17),(47,3,8,11,17),(48,4,8,13,17),(49,0,4,6,18),(50,1,0,2,18),(51,1,8,10,18),(52,2,4,6,18),(53,3,0,2,18),(54,3,8,10,18),(55,4,0,7,19),(56,4,8,15,20),(57,0,0,2,21),(58,0,4,12,21),(59,2,0,2,21),(60,2,4,12,21),(61,4,0,11,21),(62,1,0,2,22),(63,1,8,11,22),(64,3,0,2,22),(65,3,8,11,22),(66,4,2,9,23),(67,1,0,2,24),(68,1,4,6,24),(69,3,0,2,24),(70,3,4,6,24),(71,0,7,10,25),(72,1,7,10,25),(73,2,7,10,25),(74,3,7,10,25),(75,1,5,7,26),(76,3,5,7,26),(77,4,0,7,26),(78,1,0,3,27),(79,3,0,3,27),(80,1,4,6,28),(81,3,4,6,28),(82,0,8,10,29),(83,2,8,10,29),(84,1,0,9,30),(85,3,0,9,30),(86,1,8,15,31),(87,3,12,19,31),(88,0,14,17,32),(89,2,14,17,32),(90,4,0,7,33),(91,1,8,15,34),(92,3,8,15,34),(93,0,0,19,2),(94,1,0,19,2),(95,2,0,19,2),(96,3,0,19,2),(97,4,0,19,2),(98,0,10,13,1),(99,1,10,13,1),(100,2,10,13,1),(101,4,6,9,1),(102,5,0,5,1),(104,0,0,15,13),(106,1,0,19,37),(109,0,0,19,38),(110,5,0,19,38);
/*!40000 ALTER TABLE `horarios_horario_disponible` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_horarios`
--

DROP TABLE IF EXISTS `horarios_horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_horarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `hora_inicio` int NOT NULL,
  `hora_final` int NOT NULL,
  `dia` int NOT NULL,
  `docente_id` int DEFAULT NULL,
  `grupo_id` varchar(4) NOT NULL,
  `unidadAprendizaje_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `horarios_horarios_unidadAprendizaje_id_805513fb_fk_horarios_` (`unidadAprendizaje_id`),
  KEY `horarios_horarios_grupo_id_8bd6289b_fk` (`grupo_id`),
  KEY `horarios_horarios_docente_id_ac04b981_fk_horarios_docente_id` (`docente_id`),
  CONSTRAINT `horarios_horarios_docente_id_ac04b981_fk_horarios_docente_id` FOREIGN KEY (`docente_id`) REFERENCES `horarios_docente` (`id`),
  CONSTRAINT `horarios_horarios_grupo_id_8bd6289b_fk` FOREIGN KEY (`grupo_id`) REFERENCES `horarios_grupo` (`siglas`),
  CONSTRAINT `horarios_horarios_unidadAprendizaje_id_805513fb_fk_horarios_` FOREIGN KEY (`unidadAprendizaje_id`) REFERENCES `horarios_unidadaprendizaje` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_horarios`
--

LOCK TABLES `horarios_horarios` WRITE;
/*!40000 ALTER TABLE `horarios_horarios` DISABLE KEYS */;
INSERT INTO `horarios_horarios` VALUES (27,0,9,1,30,'IP1',32),(28,2,9,3,30,'IP1',32),(33,0,4,0,6,'S2',3),(34,8,15,0,13,'S2',5),(35,0,3,1,4,'S2',2),(36,4,6,1,3,'S2',1),(37,7,10,1,9,'S2',4),(38,0,3,3,4,'S2',2),(39,4,6,3,3,'S2',1),(40,0,4,4,6,'S2',3);
/*!40000 ALTER TABLE `horarios_horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_licenciatura`
--

DROP TABLE IF EXISTS `horarios_licenciatura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_licenciatura` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `version` int NOT NULL,
  `siglas` varchar(4) NOT NULL,
  `coordinador_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `horarios_licenciatur_coordinador_id_d56ec70d_fk_horarios_` (`coordinador_id`),
  CONSTRAINT `horarios_licenciatur_coordinador_id_d56ec70d_fk_horarios_` FOREIGN KEY (`coordinador_id`) REFERENCES `horarios_coordinador` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_licenciatura`
--

LOCK TABLES `horarios_licenciatura` WRITE;
/*!40000 ALTER TABLE `horarios_licenciatura` DISABLE KEYS */;
INSERT INTO `horarios_licenciatura` VALUES (1,'Ingeniería en Software',2016,'ISW',7),(2,'Ingeniería en Software',2008,'ISW',7),(3,'Ingeniería en Plasticos',2016,'IPL',6);
/*!40000 ALTER TABLE `horarios_licenciatura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios_unidadaprendizaje`
--

DROP TABLE IF EXISTS `horarios_unidadaprendizaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horarios_unidadaprendizaje` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(100) NOT NULL,
  `semestre` int NOT NULL,
  `horas` int NOT NULL,
  `licenciatura_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `horarios_unidadapren_licenciatura_id_b80687d6_fk_horarios_` (`licenciatura_id`),
  CONSTRAINT `horarios_unidadapren_licenciatura_id_b80687d6_fk_horarios_` FOREIGN KEY (`licenciatura_id`) REFERENCES `horarios_licenciatura` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_unidadaprendizaje`
--

LOCK TABLES `horarios_unidadaprendizaje` WRITE;
/*!40000 ALTER TABLE `horarios_unidadaprendizaje` DISABLE KEYS */;
INSERT INTO `horarios_unidadaprendizaje` VALUES (1,'Teoría de algoritmos',2,3,1),(2,'Cálculo diferencial e integral',2,4,1),(3,'Programación',2,5,1),(4,'Circuitos eléctricos',2,4,1),(5,'Inglés 5',2,4,1),(6,'Teoría de sistemas',2,3,1),(7,'Arquitectura de computadoras',4,4,1),(8,'Estructura de datos',4,5,1),(9,'Programación de microcontroladores',4,4,1),(10,'Requisitos y especificación de software',4,3,1),(11,'Diseño de compiladores e intérpretes',4,4,1),(12,'Interacción humano computadora',4,3,1),(13,'Inglés 7',4,4,1),(14,'Bases de datos avanzadas',6,4,1),(15,'Teoría de lenguajes de programación',6,3,1),(16,'Graficación',6,4,1),(17,'Pruebas y mantenimiento de software',6,3,1),(18,'Desarrollo de aplicaciones web',6,4,1),(19,'Arquitectura de software',6,4,1),(20,'Administración',6,3,1),(21,'Calidad del software',8,3,1),(22,'Herramientas para la administración y programación de sistemas',8,3,1),(23,'Seguridad informática',8,5,1),(24,'Datawarehouse',8,3,1),(25,'Integrativa profesional',8,4,1),(26,'Técnicas y métodos de procesamiento de imágenes',8,3,1),(27,'Administración y organización de proyectos de software',8,4,1),(28,'Tecnologías para el tratamiento de la información',8,4,1),(29,'Bases de datos orientadas a objetos',8,4,1),(30,'Administración de empresas de desarrollo de software',8,4,1),(31,'Practica Profesional',10,4,1),(32,'Termodinámica',1,9,3);
/*!40000 ALTER TABLE `horarios_unidadaprendizaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'horarios'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-17 21:35:20
