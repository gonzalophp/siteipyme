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

        $sm = $this->getServiceLocator();
        $oUser = $sm->get('Admin\Model\User');
        
        
        
        
        $request = new \Zend\Http\Request();
        
        $sUser_name='AAA';
        $sUser_password='CCC';
        
        if ($this->getRequest()->isXmlHttpRequest() && ($sJSONDataRequest = $this->getRequest()->getContent())) {
            $oDataRequest = json_decode($sJSONDataRequest);
            
            $sUser_name = $oDataRequest->user_name;
            $sUser_password = $oDataRequest->user_password;
            $bLogin_remember = $oDataRequest->login_remember;
            
            $bLoginCorrect = $oUser->isLoginCorrect($sUser_name,$sUser_password);
        }
        else {
            $bLoginCorrect=false;
        }
        
        $aResponse = array('login_correct' => $bLoginCorrect);
        $oViewModel->setVariable('XHR_Response', Json::encode($aResponse));
        return ($oViewModel);
    }
    
    function pruebaAction() {
        echo "this is prueba";exit;
    }
}
?>
