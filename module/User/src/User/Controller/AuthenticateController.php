<?php
namespace User\Controller;

class AuthenticateController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array('u_valid_session' => ($this->getServiceLocator()->get('User\Model\UserCredentials')->isAuthenticated() ? 1 :0), 'session_id' => session_id());
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>