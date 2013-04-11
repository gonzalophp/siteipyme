<?php
namespace Shop;

use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;

error_reporting(E_ALL);

class Module
{
    public function onBootstrap(MvcEvent $e)
    {
        $e->getApplication()->getServiceManager()->get('translator');
        $eventManager        = $e->getApplication()->getEventManager();
        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_DISPATCH, array($this, 'onDispatch'));
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);
    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }
    
    public function  onDispatch(MvcEvent $e){
        $aConfig = $e->getApplication()->getServiceManager()->get('config');
        $e->getResponse()->getHeaders()->addHeaders(array('Access-Control-Allow-Headers' => 'X-Requested-With'
                                                     ,'Access-Control-Allow-Credentials' => 'true'
                                                     ,'Access-Control-Allow-Origin'  => $aConfig['front_end']));
            
        if ($e->getTarget()->getRequest()->isOptions()) {
            $e->setViewModel(new \Zend\View\Model\JsonModel());
        }

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
                'Datainterface\Model\ProductTable' =>  function($sm) {
                    $dbAdapter = $sm->get('Zend\Db\Adapter\Adapter');
                    $tableIdentifier = new \Zend\Db\Sql\TableIdentifier('PRODUCT','IPYME_FINAL');
                    $table = new \Datainterface\Model\ProductTable($dbAdapter, $tableIdentifier);
                    return $table;
                },
            ),
        );
    }
}
