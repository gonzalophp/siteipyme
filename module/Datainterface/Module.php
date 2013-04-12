<?php
namespace Datainterface;

class Module{
    public function getAutoloaderConfig(){
        return array(
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }
    
    public function getServiceConfig()
    {
        return array(
            'factories' => array(
                'Datainterface\Model\UserTable' =>  function($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $tableIdentifier = new \Zend\Db\Sql\TableIdentifier('USER','IPYME_FINAL');
                    $row = new \Datainterface\Model\User();
                    $table = new \Datainterface\Model\DataTableGateway($dbAdapter, $tableIdentifier, $row);
                    return $table;
                },
                'Datainterface\Model\ProductTable' =>  function($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $tableIdentifier = new \Zend\Db\Sql\TableIdentifier('PRODUCT','IPYME_FINAL');
                    $row = new \Datainterface\Model\Product();
                    $table = new \Datainterface\Model\DataTableGateway($dbAdapter, $tableIdentifier,$row);
                    return $table;
                },
            ),
        );
    }
}
