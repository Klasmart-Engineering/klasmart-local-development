-- MariaDB dump 10.19  Distrib 10.5.12-MariaDB, for Linux (x86_64)
--
-- Host: kidsloop-global-loadtest-k8s-cluster-cms.cluster-c5ejk5ba2vkg.eu-west-2.rds.amazonaws.com    Database: cms_db
-- ------------------------------------------------------
-- Server version	5.7.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assessments`
--

DROP TABLE IF EXISTS `assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `schedule_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'schedule id',
  `title` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'title',
  `program_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'DEPRECATED: program id',
  `subject_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'DEPRECATED: subject id',
  `teacher_ids` json DEFAULT NULL COMMENT 'DEPRECATED: teacher ids',
  `class_length` int(11) NOT NULL COMMENT 'class length (util: minute)',
  `class_end_time` bigint(20) NOT NULL COMMENT 'class end time (unix seconds)',
  `complete_time` bigint(20) NOT NULL COMMENT 'complete time (unix seconds)',
  `status` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'status (enum: in_progress, complete)',
  `create_at` bigint(20) NOT NULL COMMENT 'create time (unix seconds)',
  `update_at` bigint(20) NOT NULL COMMENT 'update time (unix seconds)',
  `delete_at` bigint(20) NOT NULL COMMENT 'delete time (unix seconds)',
  `type` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'DEPRECATED: assessment type',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_schedule_id_delete_at` (`schedule_id`,`delete_at`),
  KEY `assessments_status` (`status`),
  KEY `assessments_schedule_id` (`schedule_id`),
  KEY `assessments_complete_time` (`complete_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments`
--

LOCK TABLES `assessments` WRITE;
/*!40000 ALTER TABLE `assessments` DISABLE KEYS */;
INSERT INTO `assessments` VALUES ('61fbf0fb53e200b6fe53a117','61fbec7de9eebed3e8e5fd23','20220203-Load test-Test number 612','','',NULL,1134,1643901179,1643902085,'complete',1643901179,1643902085,0,''),('61fd3303cc63556dd48075c6','61fd3302cc63556dd48075be','Load test-Test Study','','',NULL,0,0,0,'in_progress',1643983619,1643983619,0,''),('620258c4dab75e762540a62f','620258c3dab75e762540a627','Load test-Test Study','','',NULL,0,0,0,'in_progress',1644320964,1644320964,1644320980,''),('620258d453e200b6fe58cc91','620258c3dab75e762540a627','Load test-Test Study','','',NULL,0,0,0,'in_progress',1644320980,1644320980,0,''),('620259f6cc63556dd4849b96','620259f6cc63556dd4849b8e','Load test-Test','','',NULL,0,0,0,'in_progress',1644321270,1644321270,1644321283,''),('62025a033116699d9a169825','620259f6cc63556dd4849b8e','Load test-Test','','',NULL,0,0,0,'in_progress',1644321283,1644321283,0,'');
/*!40000 ALTER TABLE `assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments_attendances`
--

DROP TABLE IF EXISTS `assessments_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments_attendances` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `assessment_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'assessment id',
  `attendance_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'attendance id',
  `checked` tinyint(1) NOT NULL COMMENT 'checked',
  `origin` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'origin',
  `role` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'role',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assessments_attendances_assessment_id_attendance_id_role` (`assessment_id`,`attendance_id`,`role`),
  KEY `assessments_attendances_assessment_id` (`assessment_id`),
  KEY `assessments_attendances_attendance_id` (`attendance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment and attendance map';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments_attendances`
--

LOCK TABLES `assessments_attendances` WRITE;
/*!40000 ALTER TABLE `assessments_attendances` DISABLE KEYS */;
INSERT INTO `assessments_attendances` VALUES ('61fbf0fb53e200b6fe53a118','61fbf0fb53e200b6fe53a117','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'class_roaster','student'),('61fbf0fb53e200b6fe53a119','61fbf0fb53e200b6fe53a117','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'class_roaster','teacher'),('61fd3303cc63556dd48075c7','61fd3303cc63556dd48075c6','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'class_roaster','teacher'),('61fd3303cc63556dd48075c8','61fd3303cc63556dd48075c6','611824fd-8070-45f0-84af-37295203ae17',1,'class_roaster','teacher'),('61fd3303cc63556dd48075c9','61fd3303cc63556dd48075c6','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'class_roaster','student'),('620258c4dab75e762540a630','620258c4dab75e762540a62f','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'class_roaster','teacher'),('620258c4dab75e762540a631','620258c4dab75e762540a62f','611824fd-8070-45f0-84af-37295203ae17',1,'class_roaster','teacher'),('620258c4dab75e762540a632','620258c4dab75e762540a62f','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'class_roaster','student'),('620258d453e200b6fe58cc92','620258d453e200b6fe58cc91','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'class_roaster','teacher'),('620258d453e200b6fe58cc93','620258d453e200b6fe58cc91','611824fd-8070-45f0-84af-37295203ae17',1,'class_roaster','teacher'),('620258d453e200b6fe58cc94','620258d453e200b6fe58cc91','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'class_roaster','student'),('620259f6cc63556dd4849b97','620259f6cc63556dd4849b96','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'class_roaster','teacher'),('620259f6cc63556dd4849b98','620259f6cc63556dd4849b96','611824fd-8070-45f0-84af-37295203ae17',1,'class_roaster','teacher'),('620259f6cc63556dd4849b99','620259f6cc63556dd4849b96','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'class_roaster','student'),('62025a033116699d9a169826','62025a033116699d9a169825','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'class_roaster','teacher'),('62025a033116699d9a169827','62025a033116699d9a169825','611824fd-8070-45f0-84af-37295203ae17',1,'class_roaster','teacher'),('62025a033116699d9a169828','62025a033116699d9a169825','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'class_roaster','student');
/*!40000 ALTER TABLE `assessments_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments_contents`
--

DROP TABLE IF EXISTS `assessments_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments_contents` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'id',
  `assessment_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'assessment id',
  `content_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'content id',
  `content_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'content name',
  `content_type` int(11) NOT NULL DEFAULT '0' COMMENT 'content type',
  `content_comment` text COLLATE utf8mb4_unicode_ci COMMENT 'content comment',
  `checked` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'checked',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assessments_contents_assessment_id_content_id` (`assessment_id`,`content_id`),
  KEY `idx_assessments_contents_assessment_id` (`assessment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment and outcome map';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments_contents`
--

LOCK TABLES `assessments_contents` WRITE;
/*!40000 ALTER TABLE `assessments_contents` DISABLE KEYS */;
INSERT INTO `assessments_contents` VALUES ('61fbf0fb53e200b6fe53a11a','61fbf0fb53e200b6fe53a117','61fa8ad6ef5a75b726d6639f','Happiness in Maths',2,'',1),('61fbf0fb53e200b6fe53a11b','61fbf0fb53e200b6fe53a117','61fa8bdc9aa773647a98676e','Happiness Test',1,'',1),('61fd3303cc63556dd48075ca','61fd3303cc63556dd48075c6','61fa8ad6ef5a75b726d6639f','Happiness in Maths',2,'',1),('61fd3303cc63556dd48075cb','61fd3303cc63556dd48075c6','61fa8bdc9aa773647a98676e','Happiness Test',1,'',1),('620258c4dab75e762540a633','620258c4dab75e762540a62f','61fa8ad6ef5a75b726d6639f','Happiness in Maths',2,'',1),('620258c4dab75e762540a634','620258c4dab75e762540a62f','61fa8bdc9aa773647a98676e','Happiness Test',1,'',1),('620258d453e200b6fe58cc95','620258d453e200b6fe58cc91','61fa8ad6ef5a75b726d6639f','Happiness in Maths',2,'',1),('620258d453e200b6fe58cc96','620258d453e200b6fe58cc91','61fa8bdc9aa773647a98676e','Happiness Test',1,'',1),('620259f6cc63556dd4849b9a','620259f6cc63556dd4849b96','61fa8ad6ef5a75b726d6639f','Happiness in Maths',2,'',1),('620259f6cc63556dd4849b9b','620259f6cc63556dd4849b96','61fa8bdc9aa773647a98676e','Happiness Test',1,'',1),('62025a033116699d9a169829','62025a033116699d9a169825','61fa8ad6ef5a75b726d6639f','Happiness in Maths',2,'',1),('62025a033116699d9a16982a','62025a033116699d9a169825','61fa8bdc9aa773647a98676e','Happiness Test',1,'',1);
/*!40000 ALTER TABLE `assessments_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments_contents_outcomes`
--

DROP TABLE IF EXISTS `assessments_contents_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments_contents_outcomes` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'id',
  `assessment_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'assessment id',
  `content_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'content id',
  `outcome_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'outcome id',
  `none_achieved` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'none achieved (add: 2021-08-25)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assessments_contents_outcomes` (`assessment_id`,`content_id`,`outcome_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment content and outcome map';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments_contents_outcomes`
--

LOCK TABLES `assessments_contents_outcomes` WRITE;
/*!40000 ALTER TABLE `assessments_contents_outcomes` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessments_contents_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assessments_outcomes`
--

DROP TABLE IF EXISTS `assessments_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assessments_outcomes` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `assessment_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'assessment id',
  `outcome_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'outcome id',
  `skip` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'skip',
  `none_achieved` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'none achieved',
  `checked` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'checked',
  PRIMARY KEY (`id`),
  KEY `assessments_outcomes_assessment_id` (`assessment_id`),
  KEY `assessments_outcomes_outcome_id` (`outcome_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment and outcome map';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assessments_outcomes`
--

LOCK TABLES `assessments_outcomes` WRITE;
/*!40000 ALTER TABLE `assessments_outcomes` DISABLE KEYS */;
/*!40000 ALTER TABLE `assessments_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class_types`
--

DROP TABLE IF EXISTS `class_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `class_types` (
  `id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'name',
  `number` int(11) DEFAULT '0' COMMENT 'number',
  `create_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'created_id',
  `update_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'updated_id',
  `delete_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'deleted_id',
  `create_at` bigint(20) DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  PRIMARY KEY (`id`),
  KEY `idx_id_delete` (`id`,`delete_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='class_types';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class_types`
--

LOCK TABLES `class_types` WRITE;
/*!40000 ALTER TABLE `class_types` DISABLE KEYS */;
INSERT INTO `class_types` VALUES ('Homework','schedule_detail_homework',0,NULL,NULL,NULL,0,0,0),('OfflineClass','schedule_detail_offline_class',0,NULL,NULL,NULL,0,0,0),('OnlineClass','schedule_detail_online_class',0,NULL,NULL,NULL,0,0,0),('Task','schedule_detail_task',0,NULL,NULL,NULL,0,0,0);
/*!40000 ALTER TABLE `class_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `classes_assignments_records`
--

DROP TABLE IF EXISTS `classes_assignments_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classes_assignments_records` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `class_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'class_id',
  `schedule_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'schedule_id',
  `attendance_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'attendance_id',
  `finish_counts` int(11) NOT NULL DEFAULT '0' COMMENT 'finish counts',
  `schedule_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'schedule_type',
  `schedule_start_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'schedule_start_at',
  `last_end_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'last_end_at',
  `create_at` bigint(20) DEFAULT '0' COMMENT 'create_at',
  PRIMARY KEY (`id`),
  KEY `index_class_id` (`class_id`),
  KEY `index_attendance_id` (`attendance_id`),
  KEY `index_schedule_id` (`schedule_id`),
  KEY `index_schedule_start_at` (`schedule_start_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='classes_assignments_records';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes_assignments_records`
--

LOCK TABLES `classes_assignments_records` WRITE;
/*!40000 ALTER TABLE `classes_assignments_records` DISABLE KEYS */;
INSERT INTO `classes_assignments_records` VALUES ('61fbf0fa53e200b6fe53a115','8f4f696a-f935-412d-8134-d53062cea38e','61fbec7de9eebed3e8e5fd23','b4479424-a9d7-46a5-8ee6-40db4ed264b1',2,'live',1643900040,1643901181,1643901178),('620258f0dab75e762540a65d','8f4f696a-f935-412d-8134-d53062cea38e','620258c3dab75e762540a627','b4479424-a9d7-46a5-8ee6-40db4ed264b1',1,'study',1644320963,1644321009,1644321008),('62025a133116699d9a169839','8f4f696a-f935-412d-8134-d53062cea38e','620259f6cc63556dd4849b8e','b4479424-a9d7-46a5-8ee6-40db4ed264b1',10,'study',1644321270,1644360298,1644321299);
/*!40000 ALTER TABLE `classes_assignments_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_content_properties`
--

DROP TABLE IF EXISTS `cms_content_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_content_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'content id',
  `property_type` int(11) NOT NULL DEFAULT '0' COMMENT 'property type',
  `property_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'property id',
  `sequence` int(11) NOT NULL DEFAULT '0' COMMENT 'sequence',
  PRIMARY KEY (`id`),
  KEY `cms_content_properties_content_id_idx` (`content_id`),
  KEY `cms_content_properties_property_type_idx` (`property_type`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='cms content properties';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_content_properties`
--

LOCK TABLES `cms_content_properties` WRITE;
/*!40000 ALTER TABLE `cms_content_properties` DISABLE KEYS */;
INSERT INTO `cms_content_properties` VALUES (1,'617927e15ce6c38339a121b6',2,'5e9a201e-9c2f-4a92-bb6f-1ccf8177bb71',0),(2,'617927e15ce6c38339a121b6',3,'2d5ea951-836c-471e-996e-76823a992689',0),(3,'617927e15ce6c38339a121b6',1,'7565ae11-8130-4b7d-ac24-1d9dd6f792f2',0),(4,'617927e75ce6c38339a121c7',2,'5e9a201e-9c2f-4a92-bb6f-1ccf8177bb71',0),(5,'617927e75ce6c38339a121c7',3,'2d5ea951-836c-471e-996e-76823a992689',0),(6,'617927e75ce6c38339a121c7',1,'7565ae11-8130-4b7d-ac24-1d9dd6f792f2',0),(7,'61795aa65ce6c38339a1229c',5,'66fcda51-33c8-4162-a8d1-0337e1d6ade3',0),(8,'61795aa65ce6c38339a1229c',2,'20d6ca2f-13df-4a7a-8dcb-955908db7baa',0),(9,'61795aa65ce6c38339a1229c',4,'7965d220-619d-400f-8cab-42bd98c7d23c',0),(10,'61795aa65ce6c38339a1229c',3,'ce9014a4-01a9-49d5-bf10-6b08bc454fc1',0),(11,'61795aa65ce6c38339a1229c',6,'963729a4-7853-49d2-b75d-2c61d291afee',0),(12,'61795aa65ce6c38339a1229c',1,'75004121-0c0d-486c-ba65-4c57deacb44b',0),(13,'61795dbf5ce6c38339a1237a',5,'89d71050-186e-4fb2-8cbd-9598ca312be9',0),(14,'61795dbf5ce6c38339a1237a',2,'7cf8d3a3-5493-46c9-93eb-12f220d101d0',0),(15,'61795dbf5ce6c38339a1237a',4,'bb7982cd-020f-4e1a-93fc-4a6874917f07',0),(16,'61795dbf5ce6c38339a1237a',3,'f9d82bdd-4ee2-49dd-a707-133407cdef19',0),(17,'61795dbf5ce6c38339a1237a',6,'963729a4-7853-49d2-b75d-2c61d291afee',0),(18,'61795dbf5ce6c38339a1237a',1,'14d350f1-a7ba-4f46-bef9-dc847f0cbac5',0),(19,'61812da1aa9978b26dc16876',5,'b20eaf10-3e40-4ef7-9d74-93a13782d38f',0),(20,'61812da1aa9978b26dc16876',2,'fab745e8-9e31-4d0c-b780-c40120c98b27',0),(21,'61812da1aa9978b26dc16876',4,'bb7982cd-020f-4e1a-93fc-4a6874917f07',0),(22,'61812da1aa9978b26dc16876',3,'0523610d-cf11-47b6-b7ab-bdbf8c3e09b6',0),(23,'61812da1aa9978b26dc16876',6,'bf89c192-93dd-4192-97ab-f37198548ead',0),(24,'61812da1aa9978b26dc16876',1,'04c630cc-fabe-4176-80f2-30a029907a33',0),(25,'61812e49aa9978b26dc168c3',5,'89d71050-186e-4fb2-8cbd-9598ca312be9',0),(26,'61812e49aa9978b26dc168c3',2,'7cf8d3a3-5493-46c9-93eb-12f220d101d0',0),(27,'61812e49aa9978b26dc168c3',4,'bb7982cd-020f-4e1a-93fc-4a6874917f07',0),(28,'61812e49aa9978b26dc168c3',3,'c12f363a-633b-4080-bd2b-9ced8d034379',0),(29,'61812e49aa9978b26dc168c3',6,'8d49bbbb-b230-4d5a-900b-cde6283519a3',0),(30,'61812e49aa9978b26dc168c3',1,'14d350f1-a7ba-4f46-bef9-dc847f0cbac5',0),(31,'61e59161a25fb213090def92',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(32,'61e59161a25fb213090def92',4,'bb7982cd-020f-4e1a-93fc-4a6874917f07',0),(33,'61e59161a25fb213090def92',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(34,'61e59161a25fb213090def92',6,'bd7adbd0-9ce7-4c50-aa8e-85b842683fb5',0),(35,'61e59161a25fb213090def92',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(36,'61e591ac199e87ffcc8810a2',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(37,'61e591ac199e87ffcc8810a2',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(38,'61e591ac199e87ffcc8810a2',6,'f78c01f9-4b8a-480c-8c4b-80d1ec1747a7',0),(39,'61e591ac199e87ffcc8810a2',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(40,'61e59446a25fb213090df20a',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(41,'61e59446a25fb213090df20a',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(42,'61e59446a25fb213090df20a',6,'f78c01f9-4b8a-480c-8c4b-80d1ec1747a7',0),(43,'61e59446a25fb213090df20a',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(44,'61e59ddcbe0674cc0111b664',2,'36c4f793-9aa3-4fb8-84f0-68a2ab920d5a',0),(45,'61e59ddcbe0674cc0111b664',3,'2a637bea-c529-4868-8269-d0936696da7e',0),(46,'61e59ddcbe0674cc0111b664',1,'4591423a-2619-4ef8-a900-f5d924939d02',0),(47,'61eadaa60bf0d1dab16aaeb7',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(48,'61eadaa60bf0d1dab16aaeb7',4,'7965d220-619d-400f-8cab-42bd98c7d23c',0),(49,'61eadaa60bf0d1dab16aaeb7',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(50,'61eadaa60bf0d1dab16aaeb7',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(55,'61eadb590bf0d1dab16aaf4f',5,'e4d16af5-5b8f-4051-b065-13acf6c694be',0),(56,'61eadb590bf0d1dab16aaf4f',2,'51189ac9-f206-469c-941c-3cda28af8788',0),(57,'61eadb590bf0d1dab16aaf4f',4,'bb7982cd-020f-4e1a-93fc-4a6874917f07',0),(58,'61eadb590bf0d1dab16aaf4f',3,'0f4810e7-5ce1-47e1-8aeb-43b73f15b007',0),(59,'61eadb590bf0d1dab16aaf4f',6,'38c17083-2ef7-402b-824a-20c38e3c57f4',0),(60,'61eadb590bf0d1dab16aaf4f',1,'30de77f9-0da3-47d5-84a5-394aac654a07',0),(61,'61eee3f253f13ad23f576b44',2,'51189ac9-f206-469c-941c-3cda28af8788',0),(62,'61eee3f253f13ad23f576b44',3,'0f4810e7-5ce1-47e1-8aeb-43b73f15b007',0),(63,'61eee3f253f13ad23f576b44',1,'30de77f9-0da3-47d5-84a5-394aac654a07',0),(64,'61eee3fe1235cc9c6959e69d',2,'51189ac9-f206-469c-941c-3cda28af8788',0),(65,'61eee3fe1235cc9c6959e69d',3,'0f4810e7-5ce1-47e1-8aeb-43b73f15b007',0),(66,'61eee3fe1235cc9c6959e69d',1,'30de77f9-0da3-47d5-84a5-394aac654a07',0),(67,'61ef124e1235cc9c695a0bb4',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(68,'61ef124e1235cc9c695a0bb4',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(69,'61ef124e1235cc9c695a0bb4',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(70,'61ef280fe07ca5c42f125725',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(71,'61ef280fe07ca5c42f125725',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(72,'61ef280fe07ca5c42f125725',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(73,'61ef3c811235cc9c695a2d77',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(74,'61ef3c811235cc9c695a2d77',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(75,'61ef3c811235cc9c695a2d77',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(76,'61ef3fcae07ca5c42f126a23',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(77,'61ef3fcae07ca5c42f126a23',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(78,'61ef3fcae07ca5c42f126a23',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(79,'61f071087a6bce688b2d69c9',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(80,'61f071087a6bce688b2d69c9',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(81,'61f071087a6bce688b2d69c9',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(82,'61f0741353f13ad23f58f7ce',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(83,'61f0741353f13ad23f58f7ce',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(84,'61f0741353f13ad23f58f7ce',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(85,'61f0756d6a93400ab93b11e8',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(86,'61f0756d6a93400ab93b11e8',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(87,'61f0756d6a93400ab93b11e8',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(88,'61f076376a93400ab93b128d',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(89,'61f076376a93400ab93b128d',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(90,'61f076376a93400ab93b128d',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(91,'61f076d253f13ad23f58fa05',2,'66a453b0-d38f-472e-b055-7a94a94d66c4',0),(92,'61f076d253f13ad23f58fa05',3,'bcfd9d76-cf05-4ccd-9a41-6b886da661be',0),(93,'61f076d253f13ad23f58fa05',1,'b39edb9a-ab91-4245-94a4-eb2b5007c033',0),(94,'61f7ce484e8e3074f79a270b',2,'51189ac9-f206-469c-941c-3cda28af8788',0),(95,'61f7ce484e8e3074f79a270b',3,'0f4810e7-5ce1-47e1-8aeb-43b73f15b007',0),(96,'61f7ce484e8e3074f79a270b',1,'30de77f9-0da3-47d5-84a5-394aac654a07',0),(97,'61f7ce4dee9e045916473c84',2,'51189ac9-f206-469c-941c-3cda28af8788',0),(98,'61f7ce4dee9e045916473c84',3,'0f4810e7-5ce1-47e1-8aeb-43b73f15b007',0),(99,'61f7ce4dee9e045916473c84',1,'30de77f9-0da3-47d5-84a5-394aac654a07',0),(104,'61fa8bdc9aa773647a98676e',2,'36c4f793-9aa3-4fb8-84f0-68a2ab920d5a',0),(105,'61fa8bdc9aa773647a98676e',3,'665616dd-32c2-44c4-91c9-63f7493c9fd3',0),(106,'61fa8bdc9aa773647a98676e',1,'4591423a-2619-4ef8-a900-f5d924939d02',0),(107,'61fa8ad6ef5a75b726d6639f',2,'36c4f793-9aa3-4fb8-84f0-68a2ab920d5a',0),(108,'61fa8ad6ef5a75b726d6639f',3,'665616dd-32c2-44c4-91c9-63f7493c9fd3',0),(109,'61fa8ad6ef5a75b726d6639f',6,'6ccc8306-1a9e-42bd-83ff-55bac3449853',0),(110,'61fa8ad6ef5a75b726d6639f',1,'4591423a-2619-4ef8-a900-f5d924939d02',0),(111,'623d85f13a67fbe4b795786c',2,'51189ac9-f206-469c-941c-3cda28af8788',0),(112,'623d85f13a67fbe4b795786c',3,'d68c6c5d-c739-46d8-be70-e70d6c565949',0),(113,'623d85f13a67fbe4b795786c',1,'30de77f9-0da3-47d5-84a5-394aac654a07',0);
/*!40000 ALTER TABLE `cms_content_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_content_visibility_settings`
--

DROP TABLE IF EXISTS `cms_content_visibility_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_content_visibility_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'content id',
  `visibility_setting` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'visibility setting',
  PRIMARY KEY (`id`),
  KEY `cms_content_visibility_settings_content_id_idx` (`content_id`),
  KEY `cms_content_visibility_settings_visibility_settings_idx` (`visibility_setting`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='cms content visibility settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_content_visibility_settings`
--

LOCK TABLES `cms_content_visibility_settings` WRITE;
/*!40000 ALTER TABLE `cms_content_visibility_settings` DISABLE KEYS */;
INSERT INTO `cms_content_visibility_settings` VALUES (1,'617927e15ce6c38339a121b6','8a949279-6b0b-49e9-a4ad-77b815d0fb24'),(2,'617927e75ce6c38339a121c7','8a949279-6b0b-49e9-a4ad-77b815d0fb24'),(3,'61795aa65ce6c38339a1229c','8a949279-6b0b-49e9-a4ad-77b815d0fb24'),(4,'61795dbf5ce6c38339a1237a','88a57cd7-ec09-4fd9-953e-b16c00d71177'),(5,'61812da1aa9978b26dc16876','64104a6b-8e5c-4fc9-bf1c-27bead3240d6'),(6,'61812e49aa9978b26dc168c3','64104a6b-8e5c-4fc9-bf1c-27bead3240d6'),(7,'61e59161a25fb213090def92','5956e9e9-d73c-499d-b42c-b88136fbbe56'),(8,'61e591ac199e87ffcc8810a2','5956e9e9-d73c-499d-b42c-b88136fbbe56'),(9,'61e59446a25fb213090df20a','5956e9e9-d73c-499d-b42c-b88136fbbe56'),(10,'61e59ddcbe0674cc0111b664','5956e9e9-d73c-499d-b42c-b88136fbbe56'),(11,'61e59ddcbe0674cc0111b664','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(12,'61eadaa60bf0d1dab16aaeb7','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(13,'61eadb590bf0d1dab16aaf4f','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(14,'61eee3f253f13ad23f576b44','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(15,'61eee3fe1235cc9c6959e69d','5956e9e9-d73c-499d-b42c-b88136fbbe56'),(16,'61ef124e1235cc9c695a0bb4','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(17,'61ef280fe07ca5c42f125725','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(18,'61ef3c811235cc9c695a2d77','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(19,'61ef3fcae07ca5c42f126a23','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(20,'61f071087a6bce688b2d69c9','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(21,'61f0741353f13ad23f58f7ce','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(22,'61f0756d6a93400ab93b11e8','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(23,'61f076376a93400ab93b128d','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(24,'61f076d253f13ad23f58fa05','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(25,'61f7ce484e8e3074f79a270b','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(26,'61f7ce4dee9e045916473c84','5956e9e9-d73c-499d-b42c-b88136fbbe56'),(27,'61fa8ad6ef5a75b726d6639f','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(28,'61fa8bdc9aa773647a98676e','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7'),(29,'623d85f13a67fbe4b795786c','5956e9e9-d73c-499d-b42c-b88136fbbe56');
/*!40000 ALTER TABLE `cms_content_visibility_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_contents`
--

DROP TABLE IF EXISTS `cms_contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_contents` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'content_id',
  `content_type` int(11) NOT NULL COMMENT '????',
  `content_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `program` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'program',
  `subject` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'subject',
  `developmental` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'developmental',
  `skills` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'skills',
  `age` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'age',
  `grade` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'grade',
  `keywords` text COLLATE utf8mb4_unicode_ci COMMENT '???',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '??',
  `thumbnail` text COLLATE utf8mb4_unicode_ci COMMENT '??',
  `source_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '??????',
  `data` json DEFAULT NULL COMMENT '??',
  `extra` text COLLATE utf8mb4_unicode_ci COMMENT '????',
  `outcomes` text COLLATE utf8mb4_unicode_ci COMMENT 'Learning outcomes',
  `dir_path` varchar(768) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '/' COMMENT 'Directory path',
  `suggest_time` int(11) NOT NULL COMMENT '????',
  `author` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??id',
  `creator` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '???id',
  `org` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '????',
  `publish_scope` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '????',
  `publish_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '??',
  `self_study` tinyint(4) NOT NULL DEFAULT '0' COMMENT '??????',
  `draw_activity` tinyint(4) NOT NULL DEFAULT '0' COMMENT '??????',
  `reject_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '????',
  `remark` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '??????',
  `version` int(11) NOT NULL DEFAULT '0' COMMENT '??',
  `locked_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '???',
  `source_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'source_id',
  `copy_source_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'copy_source_id',
  `latest_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'latest_id',
  `lesson_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'lesson_type',
  `create_at` bigint(20) NOT NULL COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  `parent_folder` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '/' COMMENT 'parent folder id',
  PRIMARY KEY (`id`),
  KEY `content_type` (`content_type`),
  KEY `content_author` (`author`),
  KEY `content_org` (`org`),
  KEY `content_publish_status` (`publish_status`),
  KEY `content_source_id` (`source_id`),
  KEY `content_latest_id` (`latest_id`),
  KEY `idx_cms_contents_dir_path` (`dir_path`),
  FULLTEXT KEY `content_name_description_keywords_author_index` (`content_name`,`keywords`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='???';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_contents`
--

LOCK TABLES `cms_contents` WRITE;
/*!40000 ALTER TABLE `cms_contents` DISABLE KEYS */;
INSERT INTO `cms_contents` VALUES ('617927e15ce6c38339a121b6',1,'Test','','','','','','','','','','','{\"source\": \"assets-617927cf5ce6c38339a121a6.jpg\", \"file_type\": 1, \"input_source\": 2}','','','/',0,'ee3b9db9-e714-4dd5-ae6f-43030aebd094','ee3b9db9-e714-4dd5-ae6f-43030aebd094','8a949279-6b0b-49e9-a4ad-77b815d0fb24',NULL,'published',2,2,'','',1,'-','','','','',1635330017,1635330023,0,'/'),('617927e75ce6c38339a121c7',3,'Test','','','','','','','','','','','{\"size\": 0, \"source\": \"assets-617927cf5ce6c38339a121a6.jpg\", \"file_type\": 1}','','','/',0,'ee3b9db9-e714-4dd5-ae6f-43030aebd094','ee3b9db9-e714-4dd5-ae6f-43030aebd094','8a949279-6b0b-49e9-a4ad-77b815d0fb24',NULL,'published',2,2,'','',1,'-','','','','',1635330023,1635330023,0,'/'),('61795aa65ce6c38339a1229c',1,'content1','','','','','','','','test1','','','{\"source\": \"61795aa282fac300146abcbb\", \"file_type\": 5, \"input_source\": 1}','','','/',11,'04a0926a-df6a-465b-8dc2-f519f5bf0497','04a0926a-df6a-465b-8dc2-f519f5bf0497','8a949279-6b0b-49e9-a4ad-77b815d0fb24',NULL,'published',1,2,'','',1,'-','','','','1',1635343014,1635343018,0,'/'),('61795dbf5ce6c38339a1237a',2,'lesson-plan-1','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',10,'04a0926a-df6a-465b-8dc2-f519f5bf0497','04a0926a-df6a-465b-8dc2-f519f5bf0497','8a949279-6b0b-49e9-a4ad-77b815d0fb24',NULL,'published',2,2,'','',1,'-','','','','',1635343807,1635343817,0,'/'),('61812da1aa9978b26dc16876',2,'LP1','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',9,'04a0926a-df6a-465b-8dc2-f519f5bf0497','04a0926a-df6a-465b-8dc2-f519f5bf0497','c555dd50-762f-4856-8b2a-42d7833d4b38',NULL,'published',2,2,'','',1,'-','','','','',1635855777,1635855788,0,'/'),('61812e49aa9978b26dc168c3',1,'new lesson','','','','','','','','','','','{\"source\": \"61812e4582fac300146abcbc\", \"file_type\": 5, \"input_source\": 1}','','','/',5,'04a0926a-df6a-465b-8dc2-f519f5bf0497','04a0926a-df6a-465b-8dc2-f519f5bf0497','c555dd50-762f-4856-8b2a-42d7833d4b38',NULL,'published',2,2,'','',1,'-','','','','1',1635855945,1635855947,0,'/'),('61e59161a25fb213090def92',1,'Test','','','','','','','','','','','{\"source\": \"61e5915993c3e70013dfa9a2\", \"file_type\": 5, \"input_source\": 1}','','','/',0,'527c2d4c-2454-4f25-b194-6c6c67fe5026','527c2d4c-2454-4f25-b194-6c6c67fe5026','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1642434913,1642434913,0,'/'),('61e591ac199e87ffcc8810a2',1,'Test 001','','','','','','','','','','','{\"source\": \"61e591a893c3e70013dfa9a3\", \"file_type\": 5, \"input_source\": 1}','','','/',0,'527c2d4c-2454-4f25-b194-6c6c67fe5026','527c2d4c-2454-4f25-b194-6c6c67fe5026','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'527c2d4c-2454-4f25-b194-6c6c67fe5026','','','','',1642434988,1642434998,0,'/'),('61e59446a25fb213090df20a',1,'Test 001','','','','','','','','','','','{\"source\": \"61e591a893c3e70013dfa9a3\", \"file_type\": 5, \"input_source\": 1}','','','/',0,'527c2d4c-2454-4f25-b194-6c6c67fe5026','527c2d4c-2454-4f25-b194-6c6c67fe5026','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',2,'-','61e591ac199e87ffcc8810a2','61e591ac199e87ffcc8810a2','','',1642435654,1642435654,0,'/'),('61e59ddcbe0674cc0111b664',1,'Test 002','','','','','','','','','','','{\"source\": \"61e59dc293c3e70013dfa9a5\", \"file_type\": 5, \"input_source\": 1}','','','/',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','1',1642438108,1642438110,0,'/'),('61eadaa60bf0d1dab16aaeb7',2,'Test 002','','','','','','','','','','','{\"segmentId\": \"1\", \"materialId\": \"61e591ac199e87ffcc8810a2\"}','','','/',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'hidden',2,2,'','',1,'-','','','61eadb590bf0d1dab16aaf4f','',1642781350,1642781352,0,'/'),('61eadb590bf0d1dab16aaf4f',2,'Test 002','','','','','','','','','','','{\"segmentId\": \"1\", \"materialId\": \"61e591ac199e87ffcc8810a2\"}','','','/',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',2,'-','61eadaa60bf0d1dab16aaeb7','61eadaa60bf0d1dab16aaeb7','','',1642781529,1642781559,0,'/'),('61eee3f253f13ad23f576b44',1,'Test File upload','','','','','','','','','','','{\"source\": \"assets-61eee3da7a6bce688b2bdf9a.jpeg\", \"file_type\": 1, \"input_source\": 2}','','','/61eee8cf6a93400ab939883c',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1643045874,1643045886,0,'61eee8cf6a93400ab939883c'),('61eee3fe1235cc9c6959e69d',3,'Test File upload','','','','','','','','','','','{\"size\": 0, \"source\": \"assets-61eee3da7a6bce688b2bdf9a.jpeg\", \"file_type\": 1}','','','/',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1643045886,1643045886,0,'/'),('61ef124e1235cc9c695a0bb4',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643057742,1643057742,0,'/'),('61ef280fe07ca5c42f125725',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643063311,1643063311,0,'/'),('61ef3c811235cc9c695a2d77',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643068545,1643068545,0,'/'),('61ef3fcae07ca5c42f126a23',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643069386,1643069386,0,'/'),('61f071087a6bce688b2d69c9',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643147528,1643147528,0,'/'),('61f0741353f13ad23f58f7ce',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643148307,1643148307,0,'/'),('61f0756d6a93400ab93b11e8',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643148653,1643148653,0,'/'),('61f076376a93400ab93b128d',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643148855,1643148855,0,'/'),('61f076d253f13ad23f58fa05',2,'Test Payload','','','','','','','','','','','{\"segmentId\": \"\", \"materialId\": \"\"}','','','/',5,'7ccbecd2-5648-492f-a15f-4c8963ca291b','7ccbecd2-5648-492f-a15f-4c8963ca291b','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'draft',2,2,'','',1,'-','','','','',1643149010,1643149010,0,'/'),('61f7ce484e8e3074f79a270b',1,'Test PDF','','','','','','','','','','','{\"source\": \"assets-61f7ce22ee9e045916473c5c.pdf\", \"file_type\": 4, \"input_source\": 2}','','','/',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1643630152,1643630157,0,'/'),('61f7ce4dee9e045916473c84',3,'Test PDF','','','','','','','','','','','{\"size\": 0, \"source\": \"assets-61f7ce22ee9e045916473c5c.pdf\", \"file_type\": 4}','','','/',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','0c6b98f0-1a68-45c8-a949-60711c0b2a50','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1643630157,1643630157,0,'/'),('61fa8ad6ef5a75b726d6639f',2,'Happiness in Maths','','','','','','','','','','','{\"segmentId\": \"1\", \"materialId\": \"61fa8bdc9aa773647a98676e\"}','','','/',10,'611824fd-8070-45f0-84af-37295203ae17','611824fd-8070-45f0-84af-37295203ae17','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1643809494,1643809858,0,'/'),('61fa8bdc9aa773647a98676e',1,'Happiness Test','','','','','','','','','','','{\"source\": \"61fa8b8b6bc9a10013ab9df8\", \"file_type\": 5, \"input_source\": 1}','','','/',10,'611824fd-8070-45f0-84af-37295203ae17','611824fd-8070-45f0-84af-37295203ae17','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1643809756,1643809757,0,'/'),('623d85f13a67fbe4b795786c',3,'Test JPG','','','','','','','','','','','{\"size\": 0, \"source\": \"assets-623d85e913523a640ca31fbc.jpg\", \"file_type\": 1}','','','/',0,'d3fcc303-7151-4c32-b4e2-981b81092175','d3fcc303-7151-4c32-b4e2-981b81092175','5956e9e9-d73c-499d-b42c-b88136fbbe56',NULL,'published',2,2,'','',1,'-','','','','',1648199153,1648199153,0,'/');
/*!40000 ALTER TABLE `cms_contents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_folder_items`
--

DROP TABLE IF EXISTS `cms_folder_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_folder_items` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `owner_type` int(11) NOT NULL COMMENT 'folder item owner type',
  `owner` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'folder item owner',
  `parent_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'folder item parent folder id',
  `link` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'folder item link',
  `item_type` int(11) NOT NULL COMMENT 'folder item type',
  `dir_path` varchar(768) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '/' COMMENT 'Directory path',
  `editor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'folder item editor',
  `items_count` int(11) NOT NULL COMMENT 'folder item count',
  `name` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'folder item name',
  `partition` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'folder item partition',
  `thumbnail` text COLLATE utf8mb4_unicode_ci COMMENT 'folder item thumbnail',
  `creator` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'folder item creator',
  `create_at` bigint(20) NOT NULL COMMENT 'create time (unix seconds)',
  `update_at` bigint(20) NOT NULL COMMENT 'update time (unix seconds)',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'delete time (unix seconds)',
  `keywords` text COLLATE utf8mb4_unicode_ci COMMENT '???',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '??',
  `extra` text COLLATE utf8mb4_unicode_ci COMMENT 'folder item extra data',
  `has_descendant` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'has published descendant',
  PRIMARY KEY (`id`),
  KEY `idx_cms_folder_items_dir_path` (`dir_path`),
  FULLTEXT KEY `folder_name_description_keywords_author_index` (`name`,`keywords`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='cms folder';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_folder_items`
--

LOCK TABLES `cms_folder_items` WRITE;
/*!40000 ALTER TABLE `cms_folder_items` DISABLE KEYS */;
INSERT INTO `cms_folder_items` VALUES ('61eee8cf6a93400ab939883c',1,'5956e9e9-d73c-499d-b42c-b88136fbbe56','/','',1,'/','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1,'Test Folder','plans and materials','','0c6b98f0-1a68-45c8-a949-60711c0b2a50',1643047119,1643047119,0,'','','',1);
/*!40000 ALTER TABLE `cms_folder_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_shared_folders`
--

DROP TABLE IF EXISTS `cms_shared_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_shared_folders` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'record_id',
  `folder_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'folder_id',
  `org_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'org_id',
  `creator` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'creator',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'deleted_at',
  PRIMARY KEY (`id`),
  KEY `org_id` (`org_id`),
  KEY `folder_id` (`folder_id`),
  KEY `creator` (`creator`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='????????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_shared_folders`
--

LOCK TABLES `cms_shared_folders` WRITE;
/*!40000 ALTER TABLE `cms_shared_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_shared_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contents_outcomes_attendances`
--

DROP TABLE IF EXISTS `contents_outcomes_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contents_outcomes_attendances` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'id',
  `assessment_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'assessment id',
  `content_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'content id',
  `outcome_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'outcome id',
  `attendance_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'attendance id',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_assessment_id_content_id_outcome_id_attendance_id` (`assessment_id`,`content_id`,`outcome_id`,`attendance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment content outcome attendances (add: 2021-08-25)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contents_outcomes_attendances`
--

LOCK TABLES `contents_outcomes_attendances` WRITE;
/*!40000 ALTER TABLE `contents_outcomes_attendances` DISABLE KEYS */;
/*!40000 ALTER TABLE `contents_outcomes_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedbacks_assignments`
--

DROP TABLE IF EXISTS `feedbacks_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedbacks_assignments` (
  `id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `feedback_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'feedback_id',
  `attachment_id` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'attachment_id',
  `attachment_name` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'attachment_name',
  `number` int(11) DEFAULT '0' COMMENT 'number',
  `create_at` bigint(20) DEFAULT '0' COMMENT 'create_at',
  `update_at` bigint(20) DEFAULT '0' COMMENT 'update_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  PRIMARY KEY (`id`),
  KEY `idx_feedback_id` (`feedback_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='feedbacks_assignments';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedbacks_assignments`
--

LOCK TABLES `feedbacks_assignments` WRITE;
/*!40000 ALTER TABLE `feedbacks_assignments` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedbacks_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flyway_schema_history`
--

DROP TABLE IF EXISTS `flyway_schema_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flyway_schema_history` (
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `flyway_schema_history_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flyway_schema_history`
--

LOCK TABLES `flyway_schema_history` WRITE;
/*!40000 ALTER TABLE `flyway_schema_history` DISABLE KEYS */;
INSERT INTO `flyway_schema_history` VALUES (1,'000','baseline','SQL','V000__baseline.sql',731431525,'kidsloop','2021-10-19 13:40:59',2395,1),(2,'001','create-users-extend-varchars migrate-20210629','SQL','V001__create-users-extend-varchars_migrate-20210629.sql',499512054,'kidsloop','2021-10-19 13:40:59',97,1),(3,'002','fix-not-null','SQL','V002__fix-not-null.sql',-1345642069,'kidsloop','2021-10-19 13:41:01',1619,1),(4,'003','hide-general-milestone-20210705','SQL','V003__hide-general-milestone-20210705.sql',-1613285165,'kidsloop','2021-10-19 13:41:01',15,1),(5,'004','add folder items extra','SQL','V004__add_folder_items_extra.sql',856109348,'kidsloop','2021-10-19 13:41:01',190,1),(6,'005','fix-not-null','SQL','V005__fix-not-null.sql',1903172810,'kidsloop','2021-10-19 13:41:02',106,1),(7,'006','add folder index','SQL','V006__add_folder_index.sql',-1544476853,'kidsloop','2021-10-19 13:41:02',458,1),(8,'007','milestones add reject reason','SQL','V007__milestones_add_reject_reason.sql',2143121144,'kidsloop','2021-10-19 13:41:03',1095,1),(9,'008','add program group','SQL','V008__add_program_group.sql',-1285186707,'kidsloop','2021-10-19 13:41:03',4,1),(10,'009','remove deprecated tables','SQL','V009__remove_deprecated_tables.sql',-718569954,'kidsloop','2021-10-19 13:41:03',244,1),(11,'010','add home fun study complete by','SQL','V010__add_home_fun_study_complete_by.sql',17736539,'kidsloop','2021-10-19 13:41:04',150,1),(12,'011','add assessments contents outcomes attendances','SQL','V011__add_assessments_contents_outcomes_attendances.sql',474264499,'kidsloop','2021-10-21 15:30:12',146,1),(13,'012','fix old assessment content outcome attendance data','SQL','V012__fix_old_assessment_content_outcome_attendance_data.sql',1345913923,'kidsloop','2021-10-21 15:30:12',87,1),(14,'013','move to root if folder deleted','SQL','V013__move_to_root_if_folder_deleted.sql',1108129006,'kidsloop','2021-10-21 15:30:12',303,1),(15,'014','repaire fold items count','SQL','V014__repaire_fold_items_count.sql',350310253,'kidsloop','2021-10-21 15:30:13',13,1),(16,'015','repaire fold dir path','SQL','V015__repaire_fold_dir_path.sql',882412014,'kidsloop','2021-10-21 15:30:13',18,1),(17,'016','student usage report','SQL','V016__student_usage_report.sql',882073633,'kidsloop','2021-10-21 15:30:13',100,1),(18,'017','add parent folder for content','SQL','V017__add_parent_folder_for_content.sql',785694800,'kidsloop','2021-10-21 15:30:13',187,1),(19,'018','report create view','SQL','V018__report_create_view.sql',-513441115,'kidsloop','2021-12-20 17:40:02',100,1),(20,'019','fix incorrect outcome relation data','SQL','V019__fix_incorrect_outcome_relation_data.sql',-757665179,'kidsloop','2021-12-20 17:40:02',68,1),(21,'020','add shortcode num','SQL','V020__add_shortcode_num.sql',-698185639,'kidsloop','2022-01-14 15:59:18',951,1),(22,'021','add schedule filter index','SQL','V021__add_schedule_filter_index.sql',1161444922,'kidsloop','2022-01-14 15:59:18',227,1),(23,'022','drop cms authed contents','SQL','V022__drop_cms_authed_contents.sql',-230151911,'kidsloop','2022-01-17 12:30:16',111,1),(24,'023','clear outcome data','SQL','V023__clear_outcome_data.sql',-2030269219,'kidsloop','2022-01-17 12:30:16',436,1),(25,'024','schedule content snapshot','SQL','V024__schedule_content_snapshot.sql',-1526466875,'kidsloop','2022-01-17 12:30:17',555,1),(26,'025','add empty field for folder','SQL','V025__add_empty_field_for_folder.sql',-1300267179,'kidsloop','2022-01-31 11:06:14',321,1);
/*!40000 ALTER TABLE `flyway_schema_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `home_fun_studies`
--

DROP TABLE IF EXISTS `home_fun_studies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_fun_studies` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'id',
  `schedule_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'schedule id',
  `title` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'title',
  `teacher_ids` json NOT NULL COMMENT 'teacher id',
  `student_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'student id',
  `subject_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'subject id',
  `status` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'status (enum: in_progress, complete)',
  `due_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'due at',
  `complete_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'complete at (unix seconds)',
  `latest_feedback_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'latest feedback id',
  `latest_feedback_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'latest feedback at (unix seconds)',
  `assess_feedback_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'assess feedback id',
  `assess_score` int(11) NOT NULL DEFAULT '0' COMMENT 'score',
  `assess_comment` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'text',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'create at (unix seconds)',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'update at (unix seconds)',
  `delete_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'delete at (unix seconds)',
  `complete_by` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'complete user id (add: 2021-08-09)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_home_fun_studies_schedule_id_and_student_id` (`schedule_id`,`student_id`),
  KEY `idx_home_fun_studies_schedule_id` (`schedule_id`),
  KEY `idx_home_fun_studies_status` (`status`),
  KEY `idx_home_fun_studies_latest_feedback_at` (`latest_feedback_at`),
  KEY `idx_home_fun_studies_complete_at` (`complete_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='home_fun_studies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `home_fun_studies`
--

LOCK TABLES `home_fun_studies` WRITE;
/*!40000 ALTER TABLE `home_fun_studies` DISABLE KEYS */;
/*!40000 ALTER TABLE `home_fun_studies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `learning_outcomes`
--

DROP TABLE IF EXISTS `learning_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `learning_outcomes` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'outcome_id',
  `ancestor_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ancestor_id',
  `shortcode` char(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'shortcode',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'outcome_name',
  `program` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'program',
  `subject` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'subject',
  `developmental` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'developmental',
  `skills` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'skills',
  `age` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'age',
  `grade` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'grade',
  `keywords` text COLLATE utf8mb4_unicode_ci COMMENT 'keywords',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'description',
  `estimated_time` int(11) NOT NULL DEFAULT '0' COMMENT 'estimated_time',
  `author_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'author_id',
  `author_name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'author_name',
  `organization_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'organization_id',
  `publish_scope` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'publish_scope, default as the organization_id',
  `publish_status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'publish_status',
  `reject_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'reject_reason',
  `version` int(11) NOT NULL DEFAULT '0' COMMENT 'version',
  `assumed` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'assumed',
  `locked_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'locked by who',
  `source_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'source_id',
  `latest_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'latest_id',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  `shortcode_num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_ancestor_id` (`ancestor_id`),
  KEY `index_latest_id` (`latest_id`),
  KEY `index_publish_status` (`publish_status`),
  KEY `index_source_id` (`source_id`),
  KEY `index_shortcode_num_organization_id` (`organization_id`,`shortcode_num`),
  FULLTEXT KEY `fullindex_name_description_keywords_shortcode` (`name`,`keywords`,`description`,`shortcode`),
  FULLTEXT KEY `fullindex_keywords` (`keywords`),
  FULLTEXT KEY `fullindex_description` (`description`),
  FULLTEXT KEY `fullindex_shortcode` (`shortcode`),
  FULLTEXT KEY `fullindex_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='outcomes table';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `learning_outcomes`
--

LOCK TABLES `learning_outcomes` WRITE;
/*!40000 ALTER TABLE `learning_outcomes` DISABLE KEYS */;
INSERT INTO `learning_outcomes` VALUES ('61eadb950deabad23b938a32','61eadb950deabad23b938a32','00000','Test Learning Outcome','','','','','','','','',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','Max Flintoff','5956e9e9-d73c-499d-b42c-b88136fbbe56','5956e9e9-d73c-499d-b42c-b88136fbbe56','published','',0,1,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','','61eadb950deabad23b938a32',1642781589,1642781592,0,0),('620259b93116699d9a1697e1','61eadb950deabad23b938a32','00000','Test Learning Outcome','','','','','','','','',0,'0c6b98f0-1a68-45c8-a949-60711c0b2a50','Max Flintoff','5956e9e9-d73c-499d-b42c-b88136fbbe56','5956e9e9-d73c-499d-b42c-b88136fbbe56','draft','',1,1,'','61eadb950deabad23b938a32','61eadb950deabad23b938a32',1644321209,1644321225,0,0);
/*!40000 ALTER TABLE `learning_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_types`
--

DROP TABLE IF EXISTS `lesson_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `lesson_types` (
  `id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'name',
  `number` int(11) DEFAULT '0' COMMENT 'number',
  `create_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'created_id',
  `update_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'updated_id',
  `delete_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'deleted_id',
  `create_at` bigint(20) DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  PRIMARY KEY (`id`),
  KEY `idx_id_delete` (`id`,`delete_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lesson_types';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_types`
--

LOCK TABLES `lesson_types` WRITE;
/*!40000 ALTER TABLE `lesson_types` DISABLE KEYS */;
INSERT INTO `lesson_types` VALUES ('1','library_label_test',0,NULL,NULL,NULL,0,0,0),('2','library_label_not_test',0,NULL,NULL,NULL,0,0,0);
/*!40000 ALTER TABLE `lesson_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestones`
--

DROP TABLE IF EXISTS `milestones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `milestones` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `name` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'name',
  `shortcode` char(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'shortcode',
  `organization_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'org id',
  `author_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'author id',
  `status` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'status',
  `describe` text COLLATE utf8mb4_unicode_ci COMMENT 'description',
  `ancestor_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'ancestor',
  `locked_by` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'who is editing',
  `source_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'previous version',
  `latest_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'latest version',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  `type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'normal' COMMENT 'milestone type',
  `reject_reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'reject reason',
  `shortcode_num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_shortcode_num_organization_id` (`organization_id`,`shortcode_num`),
  FULLTEXT KEY `fullindex_name_shortcode_describe` (`name`,`shortcode`,`describe`),
  FULLTEXT KEY `fullindex_name` (`name`),
  FULLTEXT KEY `fullindex_shortcode` (`shortcode`),
  FULLTEXT KEY `fullindex_describe` (`describe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='milestones';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestones`
--

LOCK TABLES `milestones` WRITE;
/*!40000 ALTER TABLE `milestones` DISABLE KEYS */;
INSERT INTO `milestones` VALUES ('61eed4267a6bce688b2bd2ef','Test Milestone','00000','5956e9e9-d73c-499d-b42c-b88136fbbe56','0c6b98f0-1a68-45c8-a949-60711c0b2a50','published','','61eed4267a6bce688b2bd2ef','','61eed4267a6bce688b2bd2ef','61eed4267a6bce688b2bd2ef',1643041830,1643041830,0,'normal','',0);
/*!40000 ALTER TABLE `milestones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestones_outcomes`
--

DROP TABLE IF EXISTS `milestones_outcomes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `milestones_outcomes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `milestone_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'milestone',
  `outcome_ancestor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'outcome ancestor',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  PRIMARY KEY (`id`),
  UNIQUE KEY `milestone_ancestor_id_delete` (`milestone_id`,`outcome_ancestor`,`delete_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='milestones_outcomes';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestones_outcomes`
--

LOCK TABLES `milestones_outcomes` WRITE;
/*!40000 ALTER TABLE `milestones_outcomes` DISABLE KEYS */;
/*!40000 ALTER TABLE `milestones_outcomes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `milestones_relations`
--

DROP TABLE IF EXISTS `milestones_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `milestones_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `master_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'master resource',
  `relation_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation resource',
  `relation_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation type',
  `master_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'master type',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  PRIMARY KEY (`id`),
  UNIQUE KEY `master_relation_delete` (`master_id`,`relation_id`,`relation_type`,`master_type`,`delete_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='milestones_relations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `milestones_relations`
--

LOCK TABLES `milestones_relations` WRITE;
/*!40000 ALTER TABLE `milestones_relations` DISABLE KEYS */;
INSERT INTO `milestones_relations` VALUES (1,'61eed4267a6bce688b2bd2ef','30de77f9-0da3-47d5-84a5-394aac654a07','program','milestone',0,0,NULL),(2,'61eed4267a6bce688b2bd2ef','51189ac9-f206-469c-941c-3cda28af8788','subject','milestone',0,0,NULL),(3,'61eed4267a6bce688b2bd2ef','0f4810e7-5ce1-47e1-8aeb-43b73f15b007','category','milestone',0,0,NULL),(4,'61eed4267a6bce688b2bd2ef','38c17083-2ef7-402b-824a-20c38e3c57f4','subcategory','milestone',0,0,NULL),(5,'61eed4267a6bce688b2bd2ef','e4d16af5-5b8f-4051-b065-13acf6c694be','grade','milestone',0,0,NULL),(6,'61eed4267a6bce688b2bd2ef','fe359c71-0b43-40be-99da-8d94cff2143d','age','milestone',0,0,NULL);
/*!40000 ALTER TABLE `milestones_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organizations_properties`
--

DROP TABLE IF EXISTS `organizations_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations_properties` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'org_id',
  `type` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'type',
  `created_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'created_id',
  `updated_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'updated_id',
  `deleted_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'deleted_id',
  `created_at` bigint(20) DEFAULT '0' COMMENT 'created_at',
  `updated_at` bigint(20) DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  `region` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'region',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='organizations_properties';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations_properties`
--

LOCK TABLES `organizations_properties` WRITE;
/*!40000 ALTER TABLE `organizations_properties` DISABLE KEYS */;
INSERT INTO `organizations_properties` VALUES ('10f38ce9-5152-4049-b4e7-6d2e2ba884e6','headquarters',NULL,NULL,NULL,0,0,0,'global'),('9d42af2a-d943-4bb7-84d8-9e2e28b0e290','headquarters',NULL,NULL,NULL,0,0,0,'vn');
/*!40000 ALTER TABLE `organizations_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organizations_regions`
--

DROP TABLE IF EXISTS `organizations_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organizations_regions` (
  `id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `headquarter` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'headquarter',
  `organization_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'organization_id',
  `create_at` bigint(20) DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  PRIMARY KEY (`id`),
  KEY `organization_regions_headquarter_index` (`headquarter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='organization_regions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizations_regions`
--

LOCK TABLES `organizations_regions` WRITE;
/*!40000 ALTER TABLE `organizations_regions` DISABLE KEYS */;
INSERT INTO `organizations_regions` VALUES ('5fb24528993e7591084c2c46','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','281e49c6-a1f8-4d5e-83f2-0cf76700601c',1615963415,1615963415,0),('5fb24528993e7591084c2c47','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','f7d55488-a419-4436-b6d6-5d9021be388c',1618474165,1618474165,0),('5fb24528993e7591084c2c48','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','69ddc951-f20b-4792-9b66-455f371491e9',1620640679,1620640679,0),('5fb24528993e7591084c2c49','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','20cb7b33-35c2-4074-95a3-c782dc4fc1fd',1620640679,1620640679,0),('5fb24528993e7591084c2c50','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','6716f8ec-5470-4d5f-b3e2-d3af043595e6',1620640679,1620640679,0),('5fb24528993e7591084c2c51','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','69ba14b8-7198-4b12-8566-349e0767bc50',1620640679,1620640679,0),('5fb24528993e7591084c2c52','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','7aa8874d-7bea-4915-b832-de2d8506741c',1620640679,1620640679,0),('5fb24528993e7591084c2c53','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','53ddf7ac-e87f-4048-a641-6b1e1dc7b484',1620640679,1620640679,0),('5fb24528993e7591084c2c55','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','ab54b78e-7f6f-4464-8022-27413d1af20f',1620640679,1620640679,0),('5fb24528993e7591084c2c56','9d42af2a-d943-4bb7-84d8-9e2e28b0e290','c37b7446-1807-4c31-bcb5-90d23d1c808a',1620640679,1620640679,0);
/*!40000 ALTER TABLE `organizations_regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outcomes_attendances`
--

DROP TABLE IF EXISTS `outcomes_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outcomes_attendances` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `assessment_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'assessment id',
  `outcome_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'outcome id',
  `attendance_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'attendance id',
  PRIMARY KEY (`id`),
  KEY `outcomes_attendances_assessment_id` (`outcome_id`),
  KEY `outcomes_attendances_outcome_id` (`outcome_id`),
  KEY `outcomes_attendances_attendance_id` (`attendance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='outcome and attendance map';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outcomes_attendances`
--

LOCK TABLES `outcomes_attendances` WRITE;
/*!40000 ALTER TABLE `outcomes_attendances` DISABLE KEYS */;
/*!40000 ALTER TABLE `outcomes_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outcomes_relations`
--

DROP TABLE IF EXISTS `outcomes_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outcomes_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `master_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'master resource',
  `relation_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation resource',
  `relation_type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation type',
  `master_type` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'master type',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_master_id_relation_id_relation_type_delete_at` (`master_id`,`relation_id`,`relation_type`,`delete_at`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='outcomes_relations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outcomes_relations`
--

LOCK TABLES `outcomes_relations` WRITE;
/*!40000 ALTER TABLE `outcomes_relations` DISABLE KEYS */;
INSERT INTO `outcomes_relations` VALUES (1,'61eadb950deabad23b938a32','30de77f9-0da3-47d5-84a5-394aac654a07','program',NULL,0,0,0),(2,'61eadb950deabad23b938a32','51189ac9-f206-469c-941c-3cda28af8788','subject',NULL,0,0,0),(3,'61eadb950deabad23b938a32','0f4810e7-5ce1-47e1-8aeb-43b73f15b007','category',NULL,0,0,0),(4,'61eadb950deabad23b938a32','38c17083-2ef7-402b-824a-20c38e3c57f4','subcategory',NULL,0,0,0),(5,'61eadb950deabad23b938a32','e4d16af5-5b8f-4051-b065-13acf6c694be','grade',NULL,0,0,0),(6,'61eadb950deabad23b938a32','bb7982cd-020f-4e1a-93fc-4a6874917f07','age',NULL,0,0,0),(13,'620259b93116699d9a1697e1','4591423a-2619-4ef8-a900-f5d924939d02','program',NULL,0,0,0),(14,'620259b93116699d9a1697e1','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','subject',NULL,0,0,0),(15,'620259b93116699d9a1697e1','665616dd-32c2-44c4-91c9-63f7493c9fd3','category',NULL,0,0,0),(16,'620259b93116699d9a1697e1','6ccc8306-1a9e-42bd-83ff-55bac3449853','subcategory',NULL,0,0,0);
/*!40000 ALTER TABLE `outcomes_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outcomes_sets`
--

DROP TABLE IF EXISTS `outcomes_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outcomes_sets` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `outcome_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'outcome_id',
  `set_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'set_id',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  PRIMARY KEY (`id`),
  UNIQUE KEY `outcome_set_id_delete` (`outcome_id`,`set_id`,`delete_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='outcomes_sets';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outcomes_sets`
--

LOCK TABLES `outcomes_sets` WRITE;
/*!40000 ALTER TABLE `outcomes_sets` DISABLE KEYS */;
/*!40000 ALTER TABLE `outcomes_sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs_groups`
--

DROP TABLE IF EXISTS `programs_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs_groups` (
  `program_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'program id',
  `group_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'group name',
  PRIMARY KEY (`program_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='programs groups';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs_groups`
--

LOCK TABLES `programs_groups` WRITE;
/*!40000 ALTER TABLE `programs_groups` DISABLE KEYS */;
INSERT INTO `programs_groups` VALUES ('4591423a-2619-4ef8-a900-f5d924939d02','BadaSTEAM'),('56e24fa0-e139-4c80-b365-61c9bc42cd3f','BadaESL'),('7565ae11-8130-4b7d-ac24-1d9dd6f792f2','More'),('7a8c5021-142b-44b1-b60b-275c29d132fe','BadaESL'),('93f293e8-2c6a-47ad-bc46-1554caac99e4','BadaESL'),('b39edb9a-ab91-4245-94a4-eb2b5007c033','BadaESL'),('cdba0679-5719-47dc-806d-78de42026db6','BadaSTEAM'),('d1bbdcc5-0d80-46b0-b98e-162e7439058f','BadaSTEAM'),('f6617737-5022-478d-9672-0354667e0338','BadaESL');
/*!40000 ALTER TABLE `programs_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'title',
  `class_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'class_id',
  `lesson_plan_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'lesson_plan_id',
  `org_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'org_id',
  `subject_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'subject_id',
  `program_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'program_id',
  `class_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'class_type',
  `start_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'start_at',
  `end_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'end_at',
  `due_at` bigint(20) DEFAULT NULL COMMENT 'due_at',
  `status` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'status',
  `is_all_day` tinyint(1) DEFAULT '0' COMMENT 'is_all_day',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'description',
  `attachment` text COLLATE utf8mb4_unicode_ci COMMENT 'attachment',
  `version` bigint(20) DEFAULT '0' COMMENT 'version',
  `repeat_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'repeat_id',
  `repeat` json DEFAULT NULL COMMENT 'repeat',
  `created_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'created_id',
  `updated_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'updated_id',
  `deleted_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'deleted_id',
  `created_at` bigint(20) DEFAULT '0' COMMENT 'created_at',
  `updated_at` bigint(20) DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  `is_hidden` tinyint(1) DEFAULT '0' COMMENT 'is hidden',
  `is_home_fun` tinyint(1) DEFAULT '0' COMMENT 'is home fun',
  `live_lesson_plan` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedules_org_id` (`org_id`),
  KEY `schedules_start_at` (`start_at`),
  KEY `schedules_end_at` (`end_at`),
  KEY `schedules_deleted_at` (`delete_at`),
  KEY `idx_org_id_delete_at_program_id` (`org_id`,`delete_at`,`program_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='schedules';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES ('61795e3e5ce6c38339a123b0','lesson1','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','61795dbf5ce6c38339a1237a','8a949279-6b0b-49e9-a4ad-77b815d0fb24','','14d350f1-a7ba-4f46-bef9-dc847f0cbac5','OfflineClass',1635344100,1635346500,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1635343934,1635343934,0,0,0,NULL),('61795eb05ce6c38339a123c4','lesson2','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','61795dbf5ce6c38339a1237a','8a949279-6b0b-49e9-a4ad-77b815d0fb24','','14d350f1-a7ba-4f46-bef9-dc847f0cbac5','OnlineClass',1635347580,1635375599,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1635344048,1635344048,0,0,0,NULL),('61795f8b5ce6c38339a123f8','class3','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','61795dbf5ce6c38339a1237a','8a949279-6b0b-49e9-a4ad-77b815d0fb24','','14d350f1-a7ba-4f46-bef9-dc847f0cbac5','OnlineClass',1635344280,1635344520,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1635344267,1635344273,0,0,0,NULL),('617a74095ce6c38339a1245e','lesson-2','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','61795dbf5ce6c38339a1237a','8a949279-6b0b-49e9-a4ad-77b815d0fb24','','14d350f1-a7ba-4f46-bef9-dc847f0cbac5','OnlineClass',1635415140,1635418560,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1635415049,1635415052,0,0,0,NULL),('617bed13aa9978b26dc16794','lesson-2','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','61795dbf5ce6c38339a1237a','8a949279-6b0b-49e9-a4ad-77b815d0fb24','','14d350f1-a7ba-4f46-bef9-dc847f0cbac5','OnlineClass',1635511800,1635547500,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1635511571,1635511763,0,0,0,NULL),('61824a35aa9978b26dc1697b','tt1103','','61812da1aa9978b26dc16876','c555dd50-762f-4856-8b2a-42d7833d4b38','','04c630cc-fabe-4176-80f2-30a029907a33','OnlineClass',1635929100,1635929700,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','45c90557-d27b-47c5-93e2-fa0625e8fe32','','',1635928629,1635928642,0,0,0,NULL),('61825296aa9978b26dc169c5','lesson11','c7933437-0858-46eb-add7-21ca69d05f89','61812da1aa9978b26dc16876','c555dd50-762f-4856-8b2a-42d7833d4b38','','04c630cc-fabe-4176-80f2-30a029907a33','OnlineClass',1635931320,1636017120,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1635930774,1635930779,0,0,0,NULL),('61832d2daa9978b26dc16bd7','live-class-test','c7933437-0858-46eb-add7-21ca69d05f89','61812da1aa9978b26dc16876','c555dd50-762f-4856-8b2a-42d7833d4b38','','04c630cc-fabe-4176-80f2-30a029907a33','OnlineClass',1635986782,1636037999,0,'Started',1,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','d9a0b11a-7791-452c-b5ef-036b455a2d80','','',1635986733,1635986740,0,0,0,NULL),('618498afaa9978b26dc16c0d','live-class','c7933437-0858-46eb-add7-21ca69d05f89','61812da1aa9978b26dc16876','c555dd50-762f-4856-8b2a-42d7833d4b38','','04c630cc-fabe-4176-80f2-30a029907a33','OnlineClass',1636079838,1636124399,0,'Started',1,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','d9a0b11a-7791-452c-b5ef-036b455a2d80','','',1636079791,1636079799,0,0,0,NULL),('6188d2baaa9978b26dc16c45','mamur\'s class','c7933437-0858-46eb-add7-21ca69d05f89','61812da1aa9978b26dc16876','c555dd50-762f-4856-8b2a-42d7833d4b38','','04c630cc-fabe-4176-80f2-30a029907a33','OnlineClass',1636356900,1636443120,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','04a0926a-df6a-465b-8dc2-f519f5bf0497','','',1636356794,1636356855,0,0,0,NULL),('61efdf2de07ca5c42f12e99d','Test Schedule','8b09033d-7db9-46c3-aeb8-138c9e7eff96','61eadb590bf0d1dab16aaf4f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','30de77f9-0da3-47d5-84a5-394aac654a07','OfflineClass',1648198800,1648227600,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643110189,1643110189,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61e591ac199e87ffcc8810a2\", \"lesson_material_name\": \"Test 001\"}], \"lesson_plan_id\": \"61eadb590bf0d1dab16aaf4f\", \"lesson_plan_name\": \"Test 002\"}'),('61f079221235cc9c695b772a','Test01','8b09033d-7db9-46c3-aeb8-138c9e7eff96','61eadb590bf0d1dab16aaf4f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','30de77f9-0da3-47d5-84a5-394aac654a07','OnlineClass',1643149620,1643149800,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643149602,1643149606,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61e591ac199e87ffcc8810a2\", \"lesson_material_name\": \"Test 001\"}], \"lesson_plan_id\": \"61eadb590bf0d1dab16aaf4f\", \"lesson_plan_name\": \"Test 002\"}'),('61f07b0953f13ad23f58fd67','001','8f4f696a-f935-412d-8134-d53062cea38e','61eadb590bf0d1dab16aaf4f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','30de77f9-0da3-47d5-84a5-394aac654a07','OnlineClass',1643150100,1643150820,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643150089,1643150095,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61e591ac199e87ffcc8810a2\", \"lesson_material_name\": \"Test 001\"}], \"lesson_plan_id\": \"61eadb590bf0d1dab16aaf4f\", \"lesson_plan_name\": \"Test 002\"}'),('61fa8d48828cacd19ba38954','Happiness','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643810400,1643814000,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643810120,1643810131,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fa9d649aa773647a98758f','XAPI test','8b09033d-7db9-46c3-aeb8-138c9e7eff96','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OfflineClass',1643814300,1643815200,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643814244,1643814307,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fa9ee59aa773647a9876df','Happiness','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643814900,1643818500,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643814629,1643814629,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61faada06179b9d61248449b','XAPI test 2','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643818440,1643818800,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643818400,1643818425,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61faafc98731ec97edf2a284','Happiness','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643819040,1643822460,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643818953,1643818953,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fabda78731ec97edf2adb0','XAPI 3','8b09033d-7db9-46c3-aeb8-138c9e7eff96','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643822580,1643822880,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643822503,1643822503,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fba6b742b7ed237ee944d7','Assessment Test','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643882220,1643882340,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643882167,1643882167,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fbbf75eb83df659cdbc9b3','Attendance Test','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643888520,1643888700,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643888501,1643888501,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fbe6e79ba3c7bf8fef610d','Assessment POST','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643898600,1643898900,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643898599,1643898599,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fbeb3be9eebed3e8e5fc0e','POST req','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643899740,1643899980,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643899707,1643899711,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fbec7de9eebed3e8e5fd23','Test number 612','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','OnlineClass',1643900040,1643903580,0,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643900029,1643900043,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('61fd3302cc63556dd48075be','Test Study','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','Homework',0,0,0,'NotStart',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1643983618,1643983618,0,0,0,NULL),('620258c3dab75e762540a627','Test Study','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','Homework',0,0,1644451199,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1644320963,1644320980,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}'),('620259f6cc63556dd4849b8e','Test','8f4f696a-f935-412d-8134-d53062cea38e','61fa8ad6ef5a75b726d6639f','5956e9e9-d73c-499d-b42c-b88136fbbe56','','4591423a-2619-4ef8-a900-f5d924939d02','Homework',0,0,1644364799,'Started',0,'','{\"id\":\"\",\"name\":\"\"}',0,'','{}','','','',1644321270,1644321283,0,0,0,'{\"materials\": [{\"lesson_material_id\": \"61fa8bdc9aa773647a98676e\", \"lesson_material_name\": \"Happiness Test\"}], \"lesson_plan_id\": \"61fa8ad6ef5a75b726d6639f\", \"lesson_plan_name\": \"Happiness in Maths\"}');
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules_feedbacks`
--

DROP TABLE IF EXISTS `schedules_feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules_feedbacks` (
  `id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `schedule_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'schedule_id',
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'user_id',
  `comment` text COLLATE utf8mb4_unicode_ci COMMENT 'Comment',
  `create_at` bigint(20) DEFAULT '0' COMMENT 'create_at',
  `update_at` bigint(20) DEFAULT '0' COMMENT 'update_at',
  `delete_at` bigint(20) DEFAULT '0' COMMENT 'delete_at',
  PRIMARY KEY (`id`),
  KEY `idx_schedule_id` (`schedule_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='schedules_feedbacks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules_feedbacks`
--

LOCK TABLES `schedules_feedbacks` WRITE;
/*!40000 ALTER TABLE `schedules_feedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedules_feedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules_relations`
--

DROP TABLE IF EXISTS `schedules_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules_relations` (
  `id` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `schedule_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'schedule_id',
  `relation_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation_id',
  `relation_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'relation_type',
  PRIMARY KEY (`id`),
  KEY `idx_schedule_id` (`schedule_id`),
  KEY `idx_relation_id` (`relation_id`),
  KEY `idx_relation_type` (`relation_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='schedules_relations';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules_relations`
--

LOCK TABLES `schedules_relations` WRITE;
/*!40000 ALTER TABLE `schedules_relations` DISABLE KEYS */;
INSERT INTO `schedules_relations` VALUES ('61795e3e5ce6c38339a123b1','61795e3e5ce6c38339a123b0','8a949279-6b0b-49e9-a4ad-77b815d0fb24','org'),('61795e3e5ce6c38339a123b2','61795e3e5ce6c38339a123b0','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','class_roster_class'),('61795e3e5ce6c38339a123b3','61795e3e5ce6c38339a123b0','88a57cd7-ec09-4fd9-953e-b16c00d71177','school'),('61795e3e5ce6c38339a123b4','61795e3e5ce6c38339a123b0','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','participant_class'),('61795e3e5ce6c38339a123b5','61795e3e5ce6c38339a123b0','ee3b9db9-e714-4dd5-ae6f-43030aebd094','class_roster_teacher'),('61795e3e5ce6c38339a123b6','61795e3e5ce6c38339a123b0','04a0926a-df6a-465b-8dc2-f519f5bf0497','class_roster_student'),('61795e3e5ce6c38339a123b7','61795e3e5ce6c38339a123b0','ee3b9db9-e714-4dd5-ae6f-43030aebd094','participant_teacher'),('61795e3e5ce6c38339a123b8','61795e3e5ce6c38339a123b0','04a0926a-df6a-465b-8dc2-f519f5bf0497','participant_student'),('61795e3e5ce6c38339a123b9','61795e3e5ce6c38339a123b0','7cf8d3a3-5493-46c9-93eb-12f220d101d0','Subject'),('61795eb05ce6c38339a123c5','61795eb05ce6c38339a123c4','8a949279-6b0b-49e9-a4ad-77b815d0fb24','org'),('61795eb05ce6c38339a123c6','61795eb05ce6c38339a123c4','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','class_roster_class'),('61795eb05ce6c38339a123c7','61795eb05ce6c38339a123c4','88a57cd7-ec09-4fd9-953e-b16c00d71177','school'),('61795eb05ce6c38339a123c8','61795eb05ce6c38339a123c4','ee3b9db9-e714-4dd5-ae6f-43030aebd094','class_roster_teacher'),('61795eb05ce6c38339a123c9','61795eb05ce6c38339a123c4','04a0926a-df6a-465b-8dc2-f519f5bf0497','class_roster_student'),('61795eb05ce6c38339a123ca','61795eb05ce6c38339a123c4','7cf8d3a3-5493-46c9-93eb-12f220d101d0','Subject'),('61795f8b5ce6c38339a123f9','61795f8b5ce6c38339a123f8','8a949279-6b0b-49e9-a4ad-77b815d0fb24','org'),('61795f8b5ce6c38339a123fa','61795f8b5ce6c38339a123f8','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','class_roster_class'),('61795f8b5ce6c38339a123fb','61795f8b5ce6c38339a123f8','88a57cd7-ec09-4fd9-953e-b16c00d71177','school'),('61795f8b5ce6c38339a123fc','61795f8b5ce6c38339a123f8','ee3b9db9-e714-4dd5-ae6f-43030aebd094','class_roster_teacher'),('61795f8b5ce6c38339a123fd','61795f8b5ce6c38339a123f8','04a0926a-df6a-465b-8dc2-f519f5bf0497','class_roster_student'),('61795f8b5ce6c38339a123fe','61795f8b5ce6c38339a123f8','7cf8d3a3-5493-46c9-93eb-12f220d101d0','Subject'),('617a74095ce6c38339a1245f','617a74095ce6c38339a1245e','8a949279-6b0b-49e9-a4ad-77b815d0fb24','org'),('617a74095ce6c38339a12460','617a74095ce6c38339a1245e','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','class_roster_class'),('617a74095ce6c38339a12461','617a74095ce6c38339a1245e','88a57cd7-ec09-4fd9-953e-b16c00d71177','school'),('617a74095ce6c38339a12462','617a74095ce6c38339a1245e','ee3b9db9-e714-4dd5-ae6f-43030aebd094','class_roster_teacher'),('617a74095ce6c38339a12463','617a74095ce6c38339a1245e','04a0926a-df6a-465b-8dc2-f519f5bf0497','class_roster_student'),('617a74095ce6c38339a12464','617a74095ce6c38339a1245e','2c7265dd-b685-47f9-a1d5-c71c9fb0ea88','participant_teacher'),('617a74095ce6c38339a12465','617a74095ce6c38339a1245e','2c7265dd-b685-47f9-a1d5-c71c9fb0ea88','participant_student'),('617a74095ce6c38339a12466','617a74095ce6c38339a1245e','7cf8d3a3-5493-46c9-93eb-12f220d101d0','Subject'),('617bed13aa9978b26dc16795','617bed13aa9978b26dc16794','8a949279-6b0b-49e9-a4ad-77b815d0fb24','org'),('617bed13aa9978b26dc16796','617bed13aa9978b26dc16794','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','class_roster_class'),('617bed13aa9978b26dc16797','617bed13aa9978b26dc16794','88a57cd7-ec09-4fd9-953e-b16c00d71177','school'),('617bed13aa9978b26dc16798','617bed13aa9978b26dc16794','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','participant_class'),('617bed13aa9978b26dc16799','617bed13aa9978b26dc16794','ee3b9db9-e714-4dd5-ae6f-43030aebd094','class_roster_teacher'),('617bed13aa9978b26dc1679a','617bed13aa9978b26dc16794','04a0926a-df6a-465b-8dc2-f519f5bf0497','class_roster_student'),('617bed13aa9978b26dc1679b','617bed13aa9978b26dc16794','04a0926a-df6a-465b-8dc2-f519f5bf0497','participant_teacher'),('617bed13aa9978b26dc1679c','617bed13aa9978b26dc16794','e5580002-5c80-45ce-ad2d-354da349fe99','participant_student'),('617bed13aa9978b26dc1679d','617bed13aa9978b26dc16794','7cf8d3a3-5493-46c9-93eb-12f220d101d0','Subject'),('61824a35aa9978b26dc1697c','61824a35aa9978b26dc1697b','c555dd50-762f-4856-8b2a-42d7833d4b38','org'),('61824a35aa9978b26dc1697d','61824a35aa9978b26dc1697b','64104a6b-8e5c-4fc9-bf1c-27bead3240d6','school'),('61824a35aa9978b26dc1697e','61824a35aa9978b26dc1697b','69eb9ba4-b78e-4cdb-afad-72e6565fbe24','participant_teacher'),('61824a35aa9978b26dc1697f','61824a35aa9978b26dc1697b','45c90557-d27b-47c5-93e2-fa0625e8fe32','participant_student'),('61824a35aa9978b26dc16980','61824a35aa9978b26dc1697b','fab745e8-9e31-4d0c-b780-c40120c98b27','Subject'),('61825296aa9978b26dc169c6','61825296aa9978b26dc169c5','c555dd50-762f-4856-8b2a-42d7833d4b38','org'),('61825296aa9978b26dc169c7','61825296aa9978b26dc169c5','c7933437-0858-46eb-add7-21ca69d05f89','class_roster_class'),('61825296aa9978b26dc169c8','61825296aa9978b26dc169c5','64104a6b-8e5c-4fc9-bf1c-27bead3240d6','school'),('61825296aa9978b26dc169c9','61825296aa9978b26dc169c5','e2b6ee61-cd96-4a5c-962b-8060abe27bbb','participant_class'),('61825296aa9978b26dc169ca','61825296aa9978b26dc169c5','45c90557-d27b-47c5-93e2-fa0625e8fe32','participant_teacher'),('61825296aa9978b26dc169cb','61825296aa9978b26dc169c5','04a0926a-df6a-465b-8dc2-f519f5bf0497','participant_student'),('61825296aa9978b26dc169cc','61825296aa9978b26dc169c5','fab745e8-9e31-4d0c-b780-c40120c98b27','Subject'),('61832d2daa9978b26dc16bd8','61832d2daa9978b26dc16bd7','c555dd50-762f-4856-8b2a-42d7833d4b38','org'),('61832d2daa9978b26dc16bd9','61832d2daa9978b26dc16bd7','c7933437-0858-46eb-add7-21ca69d05f89','class_roster_class'),('61832d2daa9978b26dc16bda','61832d2daa9978b26dc16bd7','d9a0b11a-7791-452c-b5ef-036b455a2d80','class_roster_teacher'),('61832d2daa9978b26dc16bdb','61832d2daa9978b26dc16bd7','e8c8eacd-9be7-41bc-88ee-1bbdad84d329','class_roster_student'),('61832d2daa9978b26dc16bdc','61832d2daa9978b26dc16bd7','fab745e8-9e31-4d0c-b780-c40120c98b27','Subject'),('618498afaa9978b26dc16c0e','618498afaa9978b26dc16c0d','c555dd50-762f-4856-8b2a-42d7833d4b38','org'),('618498afaa9978b26dc16c0f','618498afaa9978b26dc16c0d','c7933437-0858-46eb-add7-21ca69d05f89','class_roster_class'),('618498afaa9978b26dc16c10','618498afaa9978b26dc16c0d','d9a0b11a-7791-452c-b5ef-036b455a2d80','class_roster_teacher'),('618498afaa9978b26dc16c11','618498afaa9978b26dc16c0d','e8c8eacd-9be7-41bc-88ee-1bbdad84d329','class_roster_student'),('618498afaa9978b26dc16c12','618498afaa9978b26dc16c0d','fab745e8-9e31-4d0c-b780-c40120c98b27','Subject'),('6188d2baaa9978b26dc16c46','6188d2baaa9978b26dc16c45','c555dd50-762f-4856-8b2a-42d7833d4b38','org'),('6188d2baaa9978b26dc16c47','6188d2baaa9978b26dc16c45','c7933437-0858-46eb-add7-21ca69d05f89','class_roster_class'),('6188d2baaa9978b26dc16c48','6188d2baaa9978b26dc16c45','64104a6b-8e5c-4fc9-bf1c-27bead3240d6','school'),('6188d2baaa9978b26dc16c49','6188d2baaa9978b26dc16c45','c7933437-0858-46eb-add7-21ca69d05f89','participant_class'),('6188d2baaa9978b26dc16c4a','6188d2baaa9978b26dc16c45','e8c8eacd-9be7-41bc-88ee-1bbdad84d329','class_roster_student'),('6188d2baaa9978b26dc16c4b','6188d2baaa9978b26dc16c45','e8c8eacd-9be7-41bc-88ee-1bbdad84d329','participant_teacher'),('6188d2baaa9978b26dc16c4c','6188d2baaa9978b26dc16c45','69eb9ba4-b78e-4cdb-afad-72e6565fbe24','participant_teacher'),('6188d2baaa9978b26dc16c4d','6188d2baaa9978b26dc16c45','45c90557-d27b-47c5-93e2-fa0625e8fe32','participant_teacher'),('6188d2baaa9978b26dc16c4e','6188d2baaa9978b26dc16c45','d9a0b11a-7791-452c-b5ef-036b455a2d80','participant_student'),('6188d2baaa9978b26dc16c4f','6188d2baaa9978b26dc16c45','fab745e8-9e31-4d0c-b780-c40120c98b27','Subject'),('61efdf2de07ca5c42f12e99e','61efdf2de07ca5c42f12e99d','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61efdf2de07ca5c42f12e99f','61efdf2de07ca5c42f12e99d','8b09033d-7db9-46c3-aeb8-138c9e7eff96','class_roster_class'),('61efdf2de07ca5c42f12e9a0','61efdf2de07ca5c42f12e99d','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61efdf2de07ca5c42f12e9a1','61efdf2de07ca5c42f12e99d','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61efdf2de07ca5c42f12e9a2','61efdf2de07ca5c42f12e99d','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61efdf2de07ca5c42f12e9a3','61efdf2de07ca5c42f12e99d','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61efdf2de07ca5c42f12e9a4','61efdf2de07ca5c42f12e99d','51189ac9-f206-469c-941c-3cda28af8788','Subject'),('61f079221235cc9c695b772b','61f079221235cc9c695b772a','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61f079221235cc9c695b772c','61f079221235cc9c695b772a','8b09033d-7db9-46c3-aeb8-138c9e7eff96','class_roster_class'),('61f079221235cc9c695b772d','61f079221235cc9c695b772a','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61f079221235cc9c695b772e','61f079221235cc9c695b772a','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61f079221235cc9c695b772f','61f079221235cc9c695b772a','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61f079221235cc9c695b7730','61f079221235cc9c695b772a','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61f079221235cc9c695b7731','61f079221235cc9c695b772a','2ae5e47d-e8ee-440a-945b-881e18fc8a02','participant_teacher'),('61f079221235cc9c695b7732','61f079221235cc9c695b772a','107e2dfa-fdea-43e8-a38c-102684a51ddc','participant_teacher'),('61f079221235cc9c695b7733','61f079221235cc9c695b772a','51189ac9-f206-469c-941c-3cda28af8788','Subject'),('61f07b0953f13ad23f58fd68','61f07b0953f13ad23f58fd67','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61f07b0953f13ad23f58fd69','61f07b0953f13ad23f58fd67','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61f07b0953f13ad23f58fd6a','61f07b0953f13ad23f58fd67','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61f07b0953f13ad23f58fd6b','61f07b0953f13ad23f58fd67','8b09033d-7db9-46c3-aeb8-138c9e7eff96','participant_class'),('61f07b0953f13ad23f58fd6c','61f07b0953f13ad23f58fd67','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61f07b0953f13ad23f58fd6d','61f07b0953f13ad23f58fd67','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61f07b0953f13ad23f58fd6e','61f07b0953f13ad23f58fd67','2ae5e47d-e8ee-440a-945b-881e18fc8a02','participant_teacher'),('61f07b0953f13ad23f58fd6f','61f07b0953f13ad23f58fd67','756c0a16-7fc8-4b44-a1bc-9bdca0e90fae','participant_teacher'),('61f07b0953f13ad23f58fd70','61f07b0953f13ad23f58fd67','6997e817-c8cc-44f4-83a1-e202fe0f8068','participant_teacher'),('61f07b0953f13ad23f58fd71','61f07b0953f13ad23f58fd67','0c6b98f0-1a68-45c8-a949-60711c0b2a50','participant_teacher'),('61f07b0953f13ad23f58fd72','61f07b0953f13ad23f58fd67','55a87bbd-dfb6-4f29-ab68-24b8bfe1af23','participant_teacher'),('61f07b0953f13ad23f58fd73','61f07b0953f13ad23f58fd67','107e2dfa-fdea-43e8-a38c-102684a51ddc','participant_teacher'),('61f07b0953f13ad23f58fd74','61f07b0953f13ad23f58fd67','ff51f226-2445-454f-9a08-498d064152d1','participant_teacher'),('61f07b0953f13ad23f58fd75','61f07b0953f13ad23f58fd67','f5ea5c5d-8182-4ce7-af16-b8dbd5b39a5d','participant_teacher'),('61f07b0953f13ad23f58fd76','61f07b0953f13ad23f58fd67','baf317ba-e3fd-4d59-9165-8b9be6e7a342','participant_teacher'),('61f07b0953f13ad23f58fd77','61f07b0953f13ad23f58fd67','51189ac9-f206-469c-941c-3cda28af8788','Subject'),('61fa8d48828cacd19ba38955','61fa8d48828cacd19ba38954','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fa8d48828cacd19ba38956','61fa8d48828cacd19ba38954','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fa8d48828cacd19ba38957','61fa8d48828cacd19ba38954','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fa8d48828cacd19ba38958','61fa8d48828cacd19ba38954','8b09033d-7db9-46c3-aeb8-138c9e7eff96','participant_class'),('61fa8d48828cacd19ba38959','61fa8d48828cacd19ba38954','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61fa8d48828cacd19ba3895a','61fa8d48828cacd19ba38954','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fa8d48828cacd19ba3895b','61fa8d48828cacd19ba38954','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fa8d48828cacd19ba3895c','61fa8d48828cacd19ba38954','0c6b98f0-1a68-45c8-a949-60711c0b2a50','participant_teacher'),('61fa8d48828cacd19ba3895d','61fa8d48828cacd19ba38954','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fa9d649aa773647a987590','61fa9d649aa773647a98758f','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fa9d649aa773647a987591','61fa9d649aa773647a98758f','8b09033d-7db9-46c3-aeb8-138c9e7eff96','class_roster_class'),('61fa9d649aa773647a987592','61fa9d649aa773647a98758f','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fa9d649aa773647a987593','61fa9d649aa773647a98758f','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fa9d649aa773647a987594','61fa9d649aa773647a98758f','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61fa9d649aa773647a987595','61fa9d649aa773647a98758f','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fa9d649aa773647a987596','61fa9d649aa773647a98758f','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fa9ee59aa773647a9876e0','61fa9ee59aa773647a9876df','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fa9ee59aa773647a9876e1','61fa9ee59aa773647a9876df','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fa9ee59aa773647a9876e2','61fa9ee59aa773647a9876df','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fa9ee59aa773647a9876e3','61fa9ee59aa773647a9876df','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61fa9ee59aa773647a9876e4','61fa9ee59aa773647a9876df','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fa9ee59aa773647a9876e5','61fa9ee59aa773647a9876df','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fa9ee59aa773647a9876e6','61fa9ee59aa773647a9876df','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61faada06179b9d61248449c','61faada06179b9d61248449b','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61faada06179b9d61248449d','61faada06179b9d61248449b','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61faada06179b9d61248449e','61faada06179b9d61248449b','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61faada06179b9d61248449f','61faada06179b9d61248449b','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61faada06179b9d6124844a0','61faada06179b9d61248449b','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61faada06179b9d6124844a1','61faada06179b9d61248449b','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61faada06179b9d6124844a2','61faada06179b9d61248449b','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61faafc98731ec97edf2a285','61faafc98731ec97edf2a284','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61faafc98731ec97edf2a286','61faafc98731ec97edf2a284','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61faafc98731ec97edf2a287','61faafc98731ec97edf2a284','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61faafc98731ec97edf2a288','61faafc98731ec97edf2a284','182c6e98-6628-427e-a9ad-c2ed60a2bb83','class_roster_teacher'),('61faafc98731ec97edf2a289','61faafc98731ec97edf2a284','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61faafc98731ec97edf2a28a','61faafc98731ec97edf2a284','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61faafc98731ec97edf2a28b','61faafc98731ec97edf2a284','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fabda78731ec97edf2adb1','61fabda78731ec97edf2adb0','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fabda78731ec97edf2adb2','61fabda78731ec97edf2adb0','8b09033d-7db9-46c3-aeb8-138c9e7eff96','class_roster_class'),('61fabda78731ec97edf2adb3','61fabda78731ec97edf2adb0','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fabda78731ec97edf2adb4','61fabda78731ec97edf2adb0','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fabda78731ec97edf2adb5','61fabda78731ec97edf2adb0','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fabda78731ec97edf2adb6','61fabda78731ec97edf2adb0','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fba6b742b7ed237ee944d8','61fba6b742b7ed237ee944d7','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fba6b742b7ed237ee944d9','61fba6b742b7ed237ee944d7','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fba6b742b7ed237ee944da','61fba6b742b7ed237ee944d7','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fba6b742b7ed237ee944db','61fba6b742b7ed237ee944d7','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fba6b742b7ed237ee944dc','61fba6b742b7ed237ee944d7','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fba6b742b7ed237ee944dd','61fba6b742b7ed237ee944d7','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fba6b742b7ed237ee944de','61fba6b742b7ed237ee944d7','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fbbf75eb83df659cdbc9b4','61fbbf75eb83df659cdbc9b3','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fbbf75eb83df659cdbc9b5','61fbbf75eb83df659cdbc9b3','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fbbf75eb83df659cdbc9b6','61fbbf75eb83df659cdbc9b3','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fbbf75eb83df659cdbc9b7','61fbbf75eb83df659cdbc9b3','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fbbf75eb83df659cdbc9b8','61fbbf75eb83df659cdbc9b3','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fbbf75eb83df659cdbc9b9','61fbbf75eb83df659cdbc9b3','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fbbf75eb83df659cdbc9ba','61fbbf75eb83df659cdbc9b3','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fbe6e79ba3c7bf8fef610e','61fbe6e79ba3c7bf8fef610d','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fbe6e79ba3c7bf8fef610f','61fbe6e79ba3c7bf8fef610d','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fbe6e79ba3c7bf8fef6110','61fbe6e79ba3c7bf8fef610d','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fbe6e79ba3c7bf8fef6111','61fbe6e79ba3c7bf8fef610d','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fbe6e79ba3c7bf8fef6112','61fbe6e79ba3c7bf8fef610d','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fbe6e79ba3c7bf8fef6113','61fbe6e79ba3c7bf8fef610d','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fbe6e79ba3c7bf8fef6114','61fbe6e79ba3c7bf8fef610d','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fbeb3be9eebed3e8e5fc0f','61fbeb3be9eebed3e8e5fc0e','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fbeb3be9eebed3e8e5fc10','61fbeb3be9eebed3e8e5fc0e','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fbeb3be9eebed3e8e5fc11','61fbeb3be9eebed3e8e5fc0e','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fbeb3be9eebed3e8e5fc12','61fbeb3be9eebed3e8e5fc0e','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fbeb3be9eebed3e8e5fc13','61fbeb3be9eebed3e8e5fc0e','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fbeb3be9eebed3e8e5fc14','61fbeb3be9eebed3e8e5fc0e','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fbeb3be9eebed3e8e5fc15','61fbeb3be9eebed3e8e5fc0e','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fbec7de9eebed3e8e5fd24','61fbec7de9eebed3e8e5fd23','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fbec7de9eebed3e8e5fd25','61fbec7de9eebed3e8e5fd23','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fbec7de9eebed3e8e5fd26','61fbec7de9eebed3e8e5fd23','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fbec7de9eebed3e8e5fd27','61fbec7de9eebed3e8e5fd23','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fbec7de9eebed3e8e5fd28','61fbec7de9eebed3e8e5fd23','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fbec7de9eebed3e8e5fd29','61fbec7de9eebed3e8e5fd23','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fbec7de9eebed3e8e5fd2a','61fbec7de9eebed3e8e5fd23','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('61fd3302cc63556dd48075bf','61fd3302cc63556dd48075be','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('61fd3302cc63556dd48075c0','61fd3302cc63556dd48075be','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('61fd3302cc63556dd48075c1','61fd3302cc63556dd48075be','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('61fd3302cc63556dd48075c2','61fd3302cc63556dd48075be','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('61fd3302cc63556dd48075c3','61fd3302cc63556dd48075be','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('61fd3302cc63556dd48075c4','61fd3302cc63556dd48075be','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('61fd3302cc63556dd48075c5','61fd3302cc63556dd48075be','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('620258c3dab75e762540a628','620258c3dab75e762540a627','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('620258c3dab75e762540a629','620258c3dab75e762540a627','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('620258c3dab75e762540a62a','620258c3dab75e762540a627','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('620258c3dab75e762540a62b','620258c3dab75e762540a627','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('620258c3dab75e762540a62c','620258c3dab75e762540a627','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('620258c3dab75e762540a62d','620258c3dab75e762540a627','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('620258c3dab75e762540a62e','620258c3dab75e762540a627','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject'),('620259f6cc63556dd4849b8f','620259f6cc63556dd4849b8e','5956e9e9-d73c-499d-b42c-b88136fbbe56','org'),('620259f6cc63556dd4849b90','620259f6cc63556dd4849b8e','8f4f696a-f935-412d-8134-d53062cea38e','class_roster_class'),('620259f6cc63556dd4849b91','620259f6cc63556dd4849b8e','ed74f70f-ff41-48ec-91f3-7d9e7dcea7a7','school'),('620259f6cc63556dd4849b92','620259f6cc63556dd4849b8e','0c6b98f0-1a68-45c8-a949-60711c0b2a50','class_roster_teacher'),('620259f6cc63556dd4849b93','620259f6cc63556dd4849b8e','611824fd-8070-45f0-84af-37295203ae17','class_roster_teacher'),('620259f6cc63556dd4849b94','620259f6cc63556dd4849b8e','b4479424-a9d7-46a5-8ee6-40db4ed264b1','class_roster_student'),('620259f6cc63556dd4849b95','620259f6cc63556dd4849b8e','36c4f793-9aa3-4fb8-84f0-68a2ab920d5a','Subject');
/*!40000 ALTER TABLE `schedules_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sets`
--

DROP TABLE IF EXISTS `sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sets` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'name',
  `organization_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'organization_id',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) DEFAULT NULL COMMENT 'deleted_at',
  PRIMARY KEY (`id`),
  KEY `index_name` (`name`),
  FULLTEXT KEY `fullindex_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='sets';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sets`
--

LOCK TABLES `sets` WRITE;
/*!40000 ALTER TABLE `sets` DISABLE KEYS */;
/*!40000 ALTER TABLE `sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_usage_records`
--

DROP TABLE IF EXISTS `student_usage_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_usage_records` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `class_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `room_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `lesson_material_url` varchar(2100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `content_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `action_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `timestamp` bigint(20) NOT NULL DEFAULT '0',
  `student_user_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `student_email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `student_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `lesson_material_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `lesson_plan_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `schedule_start_at` bigint(20) NOT NULL DEFAULT '0',
  `class_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `index_student_lesson_plan_lesson_material_class_content_type` (`student_user_id`,`lesson_plan_id`,`lesson_material_id`,`class_id`,`content_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_usage_records`
--

LOCK TABLES `student_usage_records` WRITE;
/*!40000 ALTER TABLE `student_usage_records` DISABLE KEYS */;
INSERT INTO `student_usage_records` VALUES ('61fbf0d48c7079916bd80089','live','61fbec7de9eebed3e8e5fd23','/h5p/play/61fa8b8b6bc9a10013ab9df8','h5p','viewed',1643901140398,'b4479424-a9d7-46a5-8ee6-40db4ed264b1','max.flintoff+testlogin@opencredo.com','Test Login','61fa8bdc9aa773647a98676e','61fa8ad6ef5a75b726d6639f',1643900040,'8f4f696a-f935-412d-8134-d53062cea38e');
/*!40000 ALTER TABLE `student_usage_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tmp_assessments`
--

DROP TABLE IF EXISTS `tmp_assessments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_assessments` (
  `id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `schedule_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'schedule id',
  `title` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'title',
  `program_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'DEPRECATED: program id',
  `subject_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT 'DEPRECATED: subject id',
  `teacher_ids` json DEFAULT NULL COMMENT 'DEPRECATED: teacher ids',
  `class_length` int(11) NOT NULL COMMENT 'class length (util: minute)',
  `class_end_time` bigint(20) NOT NULL COMMENT 'class end time (unix seconds)',
  `complete_time` bigint(20) NOT NULL COMMENT 'complete time (unix seconds)',
  `status` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'status (enum: in_progress, complete)',
  `create_at` bigint(20) NOT NULL COMMENT 'create time (unix seconds)',
  `update_at` bigint(20) NOT NULL COMMENT 'update time (unix seconds)',
  `delete_at` bigint(20) NOT NULL COMMENT 'delete time (unix seconds)',
  `type` varchar(1024) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'DEPRECATED: assessment type',
  PRIMARY KEY (`id`),
  KEY `assessments_status` (`status`),
  KEY `assessments_schedule_id` (`schedule_id`),
  KEY `assessments_complete_time` (`complete_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='assessment';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tmp_assessments`
--

LOCK TABLES `tmp_assessments` WRITE;
/*!40000 ALTER TABLE `tmp_assessments` DISABLE KEYS */;
/*!40000 ALTER TABLE `tmp_assessments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tmp_outcomes_relations`
--

DROP TABLE IF EXISTS `tmp_outcomes_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmp_outcomes_relations` (
  `id` int(11) NOT NULL DEFAULT '0' COMMENT 'id',
  `master_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'master resource',
  `relation_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation resource',
  `relation_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'relation type',
  `master_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'master type',
  `create_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'created_at',
  `update_at` bigint(20) NOT NULL DEFAULT '0' COMMENT 'updated_at',
  `delete_at` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tmp_outcomes_relations`
--

LOCK TABLES `tmp_outcomes_relations` WRITE;
/*!40000 ALTER TABLE `tmp_outcomes_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `tmp_outcomes_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_settings`
--

DROP TABLE IF EXISTS `user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_settings` (
  `id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id',
  `user_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'user_id',
  `setting_json` json DEFAULT NULL COMMENT 'setting_json',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='user_settings';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_settings`
--

LOCK TABLES `user_settings` WRITE;
/*!40000 ALTER TABLE `user_settings` DISABLE KEYS */;
INSERT INTO `user_settings` VALUES ('default_setting_0','default_setting_0','{\"cms_page_size\": 20}');
/*!40000 ALTER TABLE `user_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_name` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(24) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `secret` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `salt` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` varchar(8) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birthday` bigint(20) DEFAULT NULL,
  `avatar` text COLLATE utf8mb4_unicode_ci,
  `create_at` bigint(20) DEFAULT '0',
  `update_at` bigint(20) DEFAULT '0',
  `delete_at` bigint(20) DEFAULT '0',
  `create_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `update_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `delete_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ams_id` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uix_user_phone` (`phone`,`delete_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `v_schedules_subjects`
--

DROP TABLE IF EXISTS `v_schedules_subjects`;
/*!50001 DROP VIEW IF EXISTS `v_schedules_subjects`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `v_schedules_subjects` (
  `schedule_id` tinyint NOT NULL,
  `class_id` tinyint NOT NULL,
  `subject_id` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_schedules_subjects`
--

/*!50001 DROP TABLE IF EXISTS `v_schedules_subjects`*/;
/*!50001 DROP VIEW IF EXISTS `v_schedules_subjects`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`kidsloop`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_schedules_subjects` AS (select `sr`.`schedule_id` AS `schedule_id`,`sr`.`relation_id` AS `class_id`,if(isnull(`sr1`.`relation_id`),'',`sr1`.`relation_id`) AS `subject_id` from (`schedules_relations` `sr` left join `schedules_relations` `sr1` on(((`sr`.`schedule_id` = `sr1`.`schedule_id`) and (`sr1`.`relation_type` = 'Subject')))) where (`sr`.`relation_type` = 'class_roster_class')) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-29  8:17:11
