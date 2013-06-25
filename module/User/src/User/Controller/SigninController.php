<?php
namespace User\Controller;

class SigninController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
//        $this->getRequest()->setContent('{"user_name":"gonzalo","user_password":"gonzalo","user_remember":false}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        $aUser = array();
        if ($this->getRequest()->isXmlHttpRequest() && ($sJSONDataRequest = $this->getRequest()->getContent())) {
            $oDataRequest = json_decode($sJSONDataRequest);
                    
            $sUser_name     = isset($oDataRequest->user_name)?$oDataRequest->user_name:null;
            $sUser_password_hash = isset($oDataRequest->hash_user_password)?$oDataRequest->hash_user_password:null;
            session_start();
            $sSessionId = session_id();
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $aFunctionParams = array( ':p_u_session'         => $sSessionId
                                    ,':p_u_name'            => $sUser_name
                                    ,':p_u_password_hash'   => $sUser_password_hash);

            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'user_login'
                , $aFunctionParams);
            $aUser = $oResultSet->current();
        }
        $aResponse =  array('u_authenticated'   => ((count($aUser)>0) ? 1 : 0),
                            "name"              => (array_key_exists('u_name', $aUser)?$aUser['u_name']:''),
                            "admin"             => (array_key_exists('u_admin', $aUser)?$aUser['u_admin']:0));
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
