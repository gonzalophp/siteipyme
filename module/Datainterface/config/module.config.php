<?php
namespace Datainterface;

return array(
    'service_manager' => array(
        'factories' => array(
            'Datainterface\Model\DataTableGateway' => 'Datainterface\Model\DataTableGateway',
            'Datainterface\Model\TableInterface' =>  '\Datainterface\Model\TableInterface',
            'Datainterface\Model\DataFunctionGateway' => 'Datainterface\Model\DataFunctionGateway',
        ),
        'invokables' => array(
            'Datainterface\Model\User' => 'Datainterface\Model\User',
            'Datainterface\Model\Customer' => 'Datainterface\Model\Customer',
        )
    ),
);
?>