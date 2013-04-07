<?php
namespace User\Controller;

class AuthenticateController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function onDispatch(\Zend\Mvc\MvcEvent $e) {
        $aConfig = $e->getApplication()->getServiceManager()->get('config');
        $e->getResponse()->getHeaders()->addHeaders(array('Access-Control-Allow-Headers' => 'X-Requested-With'
                                                         ,'Access-Control-Allow-Credentials' => 'true'
                                                         ,'Access-Control-Allow-Origin'  => $aConfig['front_end']));
        if ($e->getRequest()->isOptions()) {
            $e->setViewModel(new \Zend\View\Model\JsonModel());
        }
        else {
            parent::onDispatch($e);
        }
    }
    
    public function indexAction() {
        parent::indexAction();
        session_start();
        $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\UserTable');
        $aResult = $oUserTable->select(array('u_session'=>session_id()
                                            ,'u_status' => 1));

        $bAuthenticated = ($aResult['resultset']->count()==1) && $aResult['success'] && ($aResult['error_code']==0);    
        $aResponse = array('u_valid_session' => ($bAuthenticated ? 1 :0), 'session_id' => session_id());
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>