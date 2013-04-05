<?php
namespace User\Controller;

class AuthenticateController extends \Zend\Mvc\Controller\AbstractActionController {
    public function indexAction() {
        parent::indexAction();
        
        session_start();
        $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\UserTable');
        $aResult = $oUserTable->select(array('u_session'=>session_id()
                                            ,'u_status' => 1));

        $bAuthenticated = ($aResult['resultset']->count()==1) && $aResult['success'] && ($aResult['error_code']==0);    
        $aResponse = array('u_valid_session' => ($bAuthenticated ? 1 :0));
        
        return $this->getServiceLocator()->get('User\View\Helper\JSONResponseView')->setArrayData($aResponse);
    }
}
?>