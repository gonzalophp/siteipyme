<?php
namespace Admin\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Zend\Json\Json;

class UserController extends AbstractActionController {
    function indexAction() {
        parent::indexAction();
        $oViewModel = new ViewModel();
        $oViewModel->setTerminal(true);
        $oViewModel->setTemplate('xhr/xhr');
        $oMenuList = new \Admin\Model\MainMenu;
        $aMenuList= $oMenuList->aMenuList;
        $oViewModel->setVariable('XHR_Response', Json::encode($aMenuList));
        return ($oViewModel);
    }

    function loginAction() {
        $oViewModel = new ViewModel();
        $oViewModel->setTerminal(true);
        $oViewModel->setTemplate('xhr/xhr');
        $oUser = new \Admin\Model\User;
        $aLoginData = $oUser->aLoginData;
        $oViewModel->setVariable('XHR_Response', Json::encode($aLoginData));
        return ($oViewModel);
    }
    
    function pruebaAction() {
        echo "this is prueba";exit;
    }
}
?>
