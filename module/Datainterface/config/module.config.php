<?php
namespace Datainterface;

return array(
    'service_manager' => array(
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
                'Datainterface\Model\TableInterface' =>  '\Datainterface\Model\TableInterface',
        ),
    ),
);
?>