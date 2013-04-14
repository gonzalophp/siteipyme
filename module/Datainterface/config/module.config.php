<?php
namespace Datainterface;

return array(
    'service_manager' => array(
        'factories' => array(
            'Datainterface\Model\DataTableGateway' => 'Datainterface\Model\DataTableGateway',
            'Datainterface\Model\TableInterface' =>  '\Datainterface\Model\TableInterface',
        ),
        'invokables' => array(
            'Datainterface\Model\User' => 'Datainterface\Model\User',
            'Datainterface\Model\Product' => 'Datainterface\Model\Product',
            'Datainterface\Model\Customer' => 'Datainterface\Model\Customer',
        )
    ),
);
?>