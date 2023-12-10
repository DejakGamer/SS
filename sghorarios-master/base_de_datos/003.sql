-- MySQL dump 10.13  Distrib 8.0.24, for Win64 (x86_64)
--
-- Host: localhost    Database: horarios
-- ------------------------------------------------------
-- Server version	8.0.24

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (69,1,8),(71,1,12),(1,1,20),(2,1,21),(3,1,22),(4,1,23),(5,1,24),(78,1,30),(67,1,32),(68,1,36),(70,1,40),(72,1,44),(73,1,48),(74,1,49),(75,1,50),(76,1,51),(77,1,52),(6,2,20),(7,2,21),(8,2,22),(9,2,23),(10,2,24),(65,2,29),(66,2,30),(51,2,32),(52,2,33),(53,2,34),(54,2,35),(55,2,36),(56,2,41),(57,2,42),(58,2,43),(59,2,44),(60,2,45),(61,2,46),(62,2,47),(63,2,48),(64,2,52),(11,3,5),(12,3,6),(13,3,7),(14,3,8),(15,3,12),(16,3,13),(17,3,16),(18,3,20),(19,3,21),(20,3,22),(21,3,23),(22,3,24),(23,3,25),(24,3,26),(25,3,27),(26,3,28),(27,3,29),(28,3,30),(29,3,31),(30,3,32),(31,3,33),(32,3,34),(33,3,35),(34,3,36),(35,3,37),(36,3,38),(37,3,39),(38,3,40),(39,3,41),(40,3,42),(41,3,43),(42,3,44),(43,3,45),(44,3,46),(45,3,47),(46,3,48),(47,3,49),(48,3,50),(49,3,51),(50,3,52);
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add coordinador',7,'add_coordinador'),(26,'Can change coordinador',7,'change_coordinador'),(27,'Can delete coordinador',7,'delete_coordinador'),(28,'Can view coordinador',7,'view_coordinador'),(29,'Can add docente',8,'add_docente'),(30,'Can change docente',8,'change_docente'),(31,'Can delete docente',8,'delete_docente'),(32,'Can view docente',8,'view_docente'),(33,'Can add grupo',9,'add_grupo'),(34,'Can change grupo',9,'change_grupo'),(35,'Can delete grupo',9,'delete_grupo'),(36,'Can view grupo',9,'view_grupo'),(37,'Can add licenciatura',10,'add_licenciatura'),(38,'Can change licenciatura',10,'change_licenciatura'),(39,'Can delete licenciatura',10,'delete_licenciatura'),(40,'Can view licenciatura',10,'view_licenciatura'),(41,'Can add unidad aprendizaje',11,'add_unidadaprendizaje'),(42,'Can change unidad aprendizaje',11,'change_unidadaprendizaje'),(43,'Can delete unidad aprendizaje',11,'delete_unidadaprendizaje'),(44,'Can view unidad aprendizaje',11,'view_unidadaprendizaje'),(45,'Can add horarios',12,'add_horarios'),(46,'Can change horarios',12,'change_horarios'),(47,'Can delete horarios',12,'delete_horarios'),(48,'Can view horarios',12,'view_horarios'),(49,'Can add horario_disponible',13,'add_horario_disponible'),(50,'Can change horario_disponible',13,'change_horario_disponible'),(51,'Can delete horario_disponible',13,'delete_horario_disponible'),(52,'Can view horario_disponible',13,'view_horario_disponible');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$260000$cv3TkHHJPWBTXeDZpm9Bp8$fHx87w4oCwOkUTMplElLmUvvSqUVMBOSSef66G9ycXc=','2021-05-21 21:18:17.476538',1,'Admin','','','asda@asda.com',1,1,'2021-05-15 16:19:17.000000'),(2,'pbkdf2_sha256$260000$iXfZ5yNfIvpBrS4etjloVk$GoabT12faF+GfCHgtYmzgL0JiBO1mVErR2ILp7AiKR8=','2021-05-21 22:08:52.388310',0,'szaragozah760@alumno.uaemex.mx','Sergio','Zaragoza','szaragozah760@alumno.uaemex.mx',0,1,'2021-05-15 17:31:34.644283'),(3,'pbkdf2_sha256$260000$QbTYNSZvH7xcgq3C1HTUm3$4w5CHLnO7FDeNJm9ElDuustIdAxQb0AXeW9owNFN0ns=',NULL,0,'szaragozah750@alumno.uaemex.mx','Víctor Axel','Juarez','szaragozah750@alumno.uaemex.mx',0,1,'2021-05-15 17:46:46.317043'),(4,'pbkdf2_sha256$260000$xwDqkj8L4Nn2G2i2xPXIPn$EoPMZ3+20RtsVfJqoyw1M5hOpzrXVX+3+3Ec3AlLYTw=',NULL,0,'szaragozah740@alumno.uaemex.mx','Sergio','Zar','szaragozah740@alumno.uaemex.mx',0,1,'2021-05-15 17:47:47.440499'),(5,'pbkdf2_sha256$260000$MNty19AX60TEH25uszGqJH$bbPv0X7tQ55isFz7PIKP63/3PyFaowYUhUgl4nue8wU=',NULL,0,'jjesus@uaemex.mx','Juan Jesus','Monrroy','jjesus@uaemex.mx',0,1,'2021-05-15 17:48:43.599480'),(6,'pbkdf2_sha256$260000$uwH4wmmwqWa25Wg7eklsB0$8YdQ/Hq6lWBLtfw0fiitQpnAUj+Fa970Ug0O+xJy0yY=',NULL,0,'jmonrroy@uaemex.mx','Juan','Monrroy','jmonrroy@uaemex.mx',0,1,'2021-05-15 17:49:27.216772'),(7,'pbkdf2_sha256$260000$XwNbsFSKKo6zURNnMEaazx$1SyR0Y+rO/HXeXMC3/yA0JHnRIWOt3i7V2Lcp5SBsMI=',NULL,0,'saladino@uamex.mx','Alberto','Saladino','saladino@uamex.mx',0,1,'2021-05-15 17:52:53.335111'),(8,'pbkdf2_sha256$260000$976LZLmOvdYARJhahMsOCM$hPuFjBwp/JVqzy2b7eC45dSIKvToEqQjDyT7VDTQwE8=',NULL,0,'sanpedro@uaemex.mx','Francisco','San Predro','sanpedro@uaemex.mx',0,1,'2021-05-15 17:53:59.555340'),(9,'pbkdf2_sha256$260000$vDv750Az8CkRybJVJoDbdp$i1q5hrd0MhAEjs5ojArUt35RpSxQEHjKeXEMxvzHVlA=',NULL,0,'sanfir@uaemex.mx','María','SanFir','sanfir@uaemex.mx',0,1,'2021-05-15 17:54:43.042291'),(10,'pbkdf2_sha256$260000$7OZ9xQG6fpHDcosMsx0T5f$CFY7IKoXKJMjU1J6J22Z/rDODqm9kUWZXVQR3tVvUKk=',NULL,0,'juvenal@uaemex.mx','Juvenal','Villareal','juvenal@uaemex.mx',0,1,'2021-05-15 17:56:03.365947'),(11,'pbkdf2_sha256$260000$JZoy6goqCAqOmmax5Mh1Eo$1kaRn3Qpt2RwGFyDw+vcbhVqzjml8tACk4g+DZwTjvc=',NULL,0,'juarez@uaemex.mx','Óscar','Juarez','juarez@uaemex.mx',0,1,'2021-05-15 17:56:51.428207'),(12,'pbkdf2_sha256$260000$5mrIsocRYjDMzqLV08f5a5$CrBNwuL4VnV969n920/7DuPtXyCh/N2rfc8nmAehlqw=',NULL,0,'estrada@uaemex.mx','David','Estrada','estrada@uaemex.mx',0,1,'2021-05-15 17:57:56.152386');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,2,1),(2,2,2),(3,3,1),(4,4,1),(5,5,1),(6,6,1),(7,7,1),(8,8,1),(9,9,1),(10,10,1),(11,11,1),(12,12,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
INSERT INTO `auth_user_user_permissions` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),(14,1,14),(15,1,15),(16,1,16),(17,1,17),(18,1,18),(19,1,19),(20,1,20),(21,1,21),(22,1,22),(23,1,23),(24,1,24),(25,1,25),(26,1,26),(27,1,27),(28,1,28),(29,1,29),(30,1,30),(31,1,31),(32,1,32),(33,1,33),(34,1,34),(35,1,35),(36,1,36),(37,1,37),(38,1,38),(39,1,39),(40,1,40),(41,1,41),(42,1,42),(43,1,43),(44,1,44),(45,1,45),(46,1,46),(47,1,47),(48,1,48),(49,1,49),(50,1,50),(51,1,51),(52,1,52);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2021-05-15 16:22:10.177220','1','Docente',1,'[{\"added\": {}}]',3,1),(2,'2021-05-15 16:22:35.266070','2','Coordinador',1,'[{\"added\": {}}]',3,1),(3,'2021-05-18 21:26:51.676587','3','Academico',1,'[{\"added\": {}}]',3,1),(4,'2021-05-18 21:30:08.822247','2','Coordinador',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',3,1),(5,'2021-05-18 21:31:42.081255','1','Docente',2,'[{\"changed\": {\"fields\": [\"Permissions\"]}}]',3,1),(6,'2021-05-18 21:32:19.714917','1','Admin',2,'[{\"changed\": {\"fields\": [\"User permissions\"]}}]',4,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'horarios','coordinador'),(8,'horarios','docente'),(9,'horarios','grupo'),(13,'horarios','horario_disponible'),(12,'horarios','horarios'),(10,'horarios','licenciatura'),(11,'horarios','unidadaprendizaje'),(6,'sessions','session');
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2021-05-15 16:16:48.205902'),(2,'auth','0001_initial','2021-05-15 16:17:16.227497'),(3,'admin','0001_initial','2021-05-15 16:17:26.377429'),(4,'admin','0002_logentry_remove_auto_add','2021-05-15 16:17:26.553631'),(5,'admin','0003_logentry_add_action_flag_choices','2021-05-15 16:17:26.823716'),(6,'contenttypes','0002_remove_content_type_name','2021-05-15 16:17:31.429121'),(7,'auth','0002_alter_permission_name_max_length','2021-05-15 16:17:33.369346'),(8,'auth','0003_alter_user_email_max_length','2021-05-15 16:17:33.724084'),(9,'auth','0004_alter_user_username_opts','2021-05-15 16:17:34.025082'),(10,'auth','0005_alter_user_last_login_null','2021-05-15 16:17:38.950955'),(11,'auth','0006_require_contenttypes_0002','2021-05-15 16:17:39.474033'),(12,'auth','0007_alter_validators_add_error_messages','2021-05-15 16:17:39.661041'),(13,'auth','0008_alter_user_username_max_length','2021-05-15 16:17:42.782406'),(14,'auth','0009_alter_user_last_name_max_length','2021-05-15 16:17:44.673336'),(15,'auth','0010_alter_group_name_max_length','2021-05-15 16:17:45.112856'),(16,'auth','0011_update_proxy_permissions','2021-05-15 16:17:45.450536'),(17,'auth','0012_alter_user_first_name_max_length','2021-05-15 16:17:47.165021'),(18,'horarios','0001_initial','2021-05-15 16:18:27.494559'),(19,'sessions','0001_initial','2021-05-15 16:18:28.961810'),(20,'horarios','0002_auto_20210518_1101','2021-05-18 16:02:07.704440');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('ii6d10q5hwspigbz313oi0dbps18qn8k','.eJxVjMEOwiAQBf-FsyFAgQWP3v0GsrAgVQNJaU_Gf9cmPej1zcx7sYDbWsM28hJmYmem2Ol3i5geue2A7thunafe1mWOfFf4QQe_dsrPy-H-HVQc9Vsb64V0ApyVU5ZSmwmTlyS18roAQrIwCYioLGXjRcxoFBUVwRQhnCH2_gClYzbe:1lkDK8:RJ4TocJd7B32mR8064gJM3q96u4phkvwUMKzLW6rDQ4','2021-06-04 22:08:52.604476');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_coordinador`
--

LOCK TABLES `horarios_coordinador` WRITE;
/*!40000 ALTER TABLE `horarios_coordinador` DISABLE KEYS */;
INSERT INTO `horarios_coordinador` VALUES (1,1,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_docente`
--

LOCK TABLES `horarios_docente` WRITE;
/*!40000 ALTER TABLE `horarios_docente` DISABLE KEYS */;
INSERT INTO `horarios_docente` VALUES (1,'Licenciatura','Ingeniería de Software',1,2),(2,'Licenciatura','Ingeniería de Software',2,3),(3,'Doctorado','Filosofía',2,4),(4,'Doctorado','Humanidades',2,5),(5,'Doctorado','Humanidades',1,6),(6,'Doctorado','Humanidades',1,7),(7,'Doctorado','Literatura',2,8),(8,'Doctorado','Humanidades',1,9),(9,'Doctorado','Psicología',2,10),(10,'Doctorado','Humanidades',1,11),(11,'Licenciatura','Filosofía',2,12);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_grupo`
--

LOCK TABLES `horarios_grupo` WRITE;
/*!40000 ALTER TABLE `horarios_grupo` DISABLE KEYS */;
INSERT INTO `horarios_grupo` VALUES ('F5',5,1),('F6',5,1),('FI',1,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_horario_disponible`
--

LOCK TABLES `horarios_horario_disponible` WRITE;
/*!40000 ALTER TABLE `horarios_horario_disponible` DISABLE KEYS */;
INSERT INTO `horarios_horario_disponible` VALUES (1,4,13,19,1),(2,5,0,9,1),(3,2,0,19,2),(8,0,14,19,4),(9,1,14,19,4),(10,2,14,19,4),(11,3,14,19,4),(12,4,14,19,4),(13,5,14,19,4),(14,0,0,6,5),(15,2,0,6,5),(16,4,0,6,5),(17,0,4,6,6),(18,0,18,19,6),(19,1,18,19,6),(20,2,3,6,6),(21,2,18,19,6),(22,3,18,19,6),(23,4,0,2,6),(24,4,18,19,6),(25,5,0,7,6),(26,5,18,19,6),(27,0,6,13,7),(28,2,5,11,7),(29,2,15,19,7),(30,4,5,8,7),(31,4,13,17,7),(32,5,6,9,7),(33,5,14,19,7),(34,1,0,7,8),(35,1,14,19,8),(36,3,0,6,8),(37,3,11,19,8),(38,0,14,18,9),(39,1,8,13,9),(40,2,4,10,9),(41,2,17,19,9),(42,3,8,12,9),(43,4,10,14,9),(44,5,0,5,9),(45,0,0,5,10),(46,1,5,9,10),(47,1,13,17,10),(48,0,0,19,11),(49,1,0,19,11),(50,2,0,19,11),(51,3,0,19,11),(52,4,0,19,11),(53,5,0,19,11),(61,1,1,1,3);
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
  `docente_id` int NOT NULL,
  `grupo_id` varchar(4) NOT NULL,
  `unidadAprendizaje_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `horarios_horarios_docente_id_ac04b981_fk_horarios_docente_id` (`docente_id`),
  KEY `horarios_horarios_unidadAprendizaje_id_805513fb_fk_horarios_` (`unidadAprendizaje_id`),
  KEY `horarios_horarios_grupo_id_8bd6289b_fk` (`grupo_id`),
  CONSTRAINT `horarios_horarios_docente_id_ac04b981_fk_horarios_docente_id` FOREIGN KEY (`docente_id`) REFERENCES `horarios_docente` (`id`),
  CONSTRAINT `horarios_horarios_grupo_id_8bd6289b_fk` FOREIGN KEY (`grupo_id`) REFERENCES `horarios_grupo` (`siglas`),
  CONSTRAINT `horarios_horarios_unidadAprendizaje_id_805513fb_fk_horarios_` FOREIGN KEY (`unidadAprendizaje_id`) REFERENCES `horarios_unidadaprendizaje` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_horarios`
--

LOCK TABLES `horarios_horarios` WRITE;
/*!40000 ALTER TABLE `horarios_horarios` DISABLE KEYS */;
INSERT INTO `horarios_horarios` VALUES (1,0,3,2,2,'FI',12),(3,4,15,2,2,'F5',7),(4,13,18,4,1,'F5',8),(5,0,9,5,1,'F5',8),(6,14,19,0,4,'F6',7),(7,14,19,1,4,'F6',13),(8,14,19,2,4,'F6',16),(9,14,19,3,4,'F6',16),(10,14,19,4,4,'F6',13),(11,14,19,5,4,'F6',7);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_licenciatura`
--

LOCK TABLES `horarios_licenciatura` WRITE;
/*!40000 ALTER TABLE `horarios_licenciatura` DISABLE KEYS */;
INSERT INTO `horarios_licenciatura` VALUES (1,'Filosofía',2015,'LFI',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios_unidadaprendizaje`
--

LOCK TABLES `horarios_unidadaprendizaje` WRITE;
/*!40000 ALTER TABLE `horarios_unidadaprendizaje` DISABLE KEYS */;
INSERT INTO `horarios_unidadaprendizaje` VALUES (1,'Elaboración de textos académicos',1,4,1),(2,'Antropología filosófica',1,8,1),(3,'Ética',1,8,1),(4,'Historia de la Filosofía griega clásica',1,8,1),(5,'Lógica tradicional',1,8,1),(6,'Pensamiento prehispánico',1,8,1),(7,'Inglés 8',5,6,1),(8,'Filosofía de la ciencia',5,8,1),(9,'Historia de la Filosofía del siglo VXII a mediados del XVIII',5,8,1),(10,'Filosofía en América Latina y el Caribe siglo XX',5,4,1),(11,'Filosofía política contemporánea',5,8,1),(12,'Análisis de textos filosóficos',5,6,1),(13,'Filosofía de la cultura',5,6,1),(14,'Filosofía de las ciencias de la vida',5,6,1),(15,'Monográfico temático o de autor Grecia y Roma',5,6,1),(16,'Filosofía de los pueblos originarios contemporáneos',5,6,1);
/*!40000 ALTER TABLE `horarios_unidadaprendizaje` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-22 13:39:37
