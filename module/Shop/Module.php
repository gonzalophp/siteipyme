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
        $eventManager->attach(\Zend\Mvc\MvcEvent::EVENT_DISPATCH, array($this, 'onDispatch'),2);
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);
    }

    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }
    
    public function  onDispatch(MvcEvent $e){
        $aConfig = $e->getApplication()->getServiceManager()->get('config');
        $e->getResponse()->getHeaders()->addHeaders(array('Access-Control-Allow-Headers' => 'Content-Type,X-Requested-With'
                                                        ,'Access-Control-Allow-Credentials' => 'true'
                                                        ,'Access-Control-Allow-Origin'  => $aConfig['front_end']));
        if ($e->getTarget()->getRequest()->isOptions()) {
            return $e->getResponse();
        }
        else {
            if (strpos($e->getRouteMatch()->getParam('__NAMESPACE__'),__NAMESPACE__) === 0){
                if (!$e->getApplication()->getServiceManager()->get('User\Model\UserCredentials')->isAuthenticated()){
                    $oJsonModel = new \Zend\View\Model\JsonModel(array('valid_session' => 0));
                    $e->getResponse()->setContent($oJsonModel->serialize());
                    return $e->getResponse();
                }
            }
        }
    }
    
    public function getAutoloaderConfig()
    {
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

            ),
        );
    }
}
