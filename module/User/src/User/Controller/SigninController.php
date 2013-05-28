<?php
namespace User\Controller;

class SigninController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
//        $this->getRequest()->setContent('{"user_name":"GONZALO","user_password":"gonzalo","user_remember":false}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        $bAuthenticated = false;
        if ($this->getRequest()->isXmlHttpRequest() && ($sJSONDataRequest = $this->getRequest()->getContent())) {
            $oDataRequest = json_decode($sJSONDataRequest);
            
            $sUser_name = $oDataRequest->user_name;
            $sUser_password = $oDataRequest->user_password;
            $bUser_remember = $oDataRequest->user_remember;
            $sUser_password_hash = sha1($sUser_password);
            
            $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\DataTableGateway')->getTableGateway('IPYME_FINAL','USER');
            $aResult = $oUserTable->select(array(new \Zend\Db\Sql\Predicate\Literal("lower(u_name)='".strtolower($sUser_name)."'")
                                               , 'u_password_hash'=>$sUser_password_hash
                                                ,'u_status' => 1));
            
            $bAuthenticated = (!is_null($aResult['resultset'])) && ($aResult['resultset']->count()==1) && $aResult['success'] && ($aResult['error_code']==0);
            if ($bAuthenticated) {
                
                if(array_key_exists('PHPSESSID',$_COOKIE)) unset($_COOKIE['PHPSESSID']);
                if ($bUser_remember) session_set_cookie_params(84600,'/');
                session_start();
                
                $oUser = $aResult['resultset']->current();
                $oUser->u_session = session_id();
                
                $resultSet = $oUserTable->update(array('u_session' => $oUser->u_session)
                                               , array('u_id' => $oUser->u_id));
            }
        }
        $aResponse =  array('u_authenticated'    => ($bAuthenticated ? 1 : 0));
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
