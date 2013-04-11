<?php
namespace Menus\Controller;

use Zend\Mvc\Controller\AbstractActionController;

class MainController extends AbstractActionController {
    
    function indexAction() {
        $oMenuList = new \Datainterface\Model\MainMenu;
        $aMenuList= $oMenuList->aMenuList;
        return new \Zend\View\Model\JsonModel($aMenuList);
    }
}
?>
