<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */
namespace User;

use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;

error_reporting(E_ALL);
class Module
{
    public function onBootstrap(MvcEvent $e)
    {
        $e->getApplication()->getServiceManager()->get('translator');
        $eventManager        = $e->getApplication()->getEventManager();
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);
    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }

    public function getAutoloaderConfig()
    {
        return array(
            'Zend\Loader\StandardAutoloader' => array(
                'namespaces' => array(
                    __NAMESPACE__.'\View\Helper' => __DIR__ . '/view/Helper/',
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
                    $table = new \Datainterface\Model\UserTable($dbAdapter, $tableIdentifier);
                    return $table;
                },
                'User\View\Helper\JSONResponseView' =>  function() {
                    $oJSONResponseView = new \User\View\Helper\JSONResponseView();
                    return $oJSONResponseView;
                },
//                'User\Model\User' =>  function($sm) {
//                    $tableGateway = $sm->get('UserTableGateway');
//                    $table = new UserTable($tableGateway);
//                    return $table;
//                },
//                'UserTableGateway' => function ($sm) {
//                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
//                    $resultSetPrototype = new ResultSet();
//                    $resultSetPrototype->setArrayObjectPrototype(new User());
//                    return new TableGateway(new \Zend\Db\Sql\TableIdentifier('USER','IPYME_FINAL'), $dbAdapter, null, $resultSetPrototype);
//                },
            ),
        );
    }
}
