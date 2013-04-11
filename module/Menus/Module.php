<?php
namespace Menus;

class Module {
    
    public function onBootstrap(\Zend\Mvc\MvcEvent $e)
    {
        $e->getApplication()->getEventManager()->attach(\Zend\Mvc\MvcEvent::EVENT_DISPATCH, array($this, 'onDispatch'));
    }
    
    
    public function getConfig()
    {
        return include __DIR__ . '/config/module.config.php';
    }
    
    public function  onDispatch(\Zend\Mvc\MvcEvent $e){
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
                    __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                ),
            ),
        );
    }
}
?>
