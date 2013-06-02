<?php
namespace User\Controller;

class AuthenticateController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $oUserCredentials = $this->getServiceLocator()->get('User\Model\UserCredentials');
        $oUser = $oUserCredentials->getUserDetails();
        $aResponse = array('u_valid_session'    => ($oUserCredentials->isAuthenticated() ? 1 :0)
                         , 'name'               => (!is_null($oUser['u_name'])?$oUser['u_name']:'')
                         , 'admin'              => $oUser['u_admin']);
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>