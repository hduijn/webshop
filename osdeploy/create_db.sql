create database magento;
create user magento IDENTIFIED BY '';
GRANT ALL ON magento.* TO magento@localhost IDENTIFIED BY '';
flush privileges;

