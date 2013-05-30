<?php
namespace User\Controller;

class SigninController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
//        $this->getRequest()->setContent('{"user_name":"GONZALO","user_password":"gonzalo","user_remember":false}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        $bAuthenticated = false;
        if ($this->getRequest()->isXmlHttpRequest() && ($sJSONDataRequest = $this->getRequest()->getContent())) {
            $oDataRequest = json_decode($sJSONDataRequest);
                    
            $sUser_name     = isset($oDataRequest->user_name)?$oDataRequest->user_name:null;
            $sUser_password = isset($oDataRequest->user_password)?$oDataRequest->user_password:null;
            $bUser_remember = $oDataRequest->user_remember;
            $sUser_password_hash = sha1($sUser_password);
            session_start();
            $sSessionId = session_id();
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'user_login'
                , array( ':p_u_session'         => $sSessionId
                        ,':p_u_name'            => $sUser_name
                        ,':p_u_password_hash'   => $sUser_password_hash));
            
            $bAuthenticated = ($oResultSet->count() == 1);
        }
        $aResponse =  array('u_authenticated'    => ($bAuthenticated ? 1 : 0));
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
