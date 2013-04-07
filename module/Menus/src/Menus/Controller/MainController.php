<?php
namespace Menus\Controller;

use Zend\Mvc\Controller\AbstractActionController;

class MainController extends AbstractActionController {
    
    public function onDispatch(\Zend\Mvc\MvcEvent $e) {
        $aConfig = $e->getApplication()->getServiceManager()->get('config');
        $e->getResponse()->getHeaders()->addHeaders(array('Access-Control-Allow-Headers' => 'X-Requested-With'
                                                         ,'Access-Control-Allow-Origin'  => $aConfig['front_end']));
        if ($e->getRequest()->isOptions()) {
            $e->setViewModel(new \Zend\View\Model\JsonModel());
        }
        else {
            parent::onDispatch($e);
        }
    }
    
    
    function indexAction() {
        $oMenuList = new \Datainterface\Model\MainMenu;
        $aMenuList= $oMenuList->aMenuList;
        return new \Zend\View\Model\JsonModel($aMenuList);
    }
}
?>
