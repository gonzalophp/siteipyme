<?php
namespace Menus\Controller;

use Zend\Mvc\Controller\AbstractActionController;

class MainController extends AbstractActionController {
    function indexAction() {
        $oMenuList = new \Datainterface\Model\MainMenu;
        $aMenuList= $oMenuList->aMenuList;
        
        return $this->getServiceLocator()->get('User\View\Helper\JSONResponseView')->setArrayData($aMenuList); 
    }
}
?>
