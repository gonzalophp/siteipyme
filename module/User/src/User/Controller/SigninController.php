<?php
namespace User\Controller;

class SigninController extends \Zend\Mvc\Controller\AbstractActionController {
    public function indexAction() {
        parent::indexAction();
        
//        $oDataRequest = (object) array('user_name' => 'GONZALO', 'user_password' => 'gonzalo');
        
        $bAuthenticated = false;
        if ($this->getRequest()->isXmlHttpRequest() && ($sJSONDataRequest = $this->getRequest()->getContent())) {
            $oDataRequest = json_decode($sJSONDataRequest);
            
            $sUser_name = $oDataRequest->user_name;
            $sUser_password = $oDataRequest->user_password;
            $sUser_password_hash = sha1($sUser_password);
            
            $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\UserTable');
            $aResult = $oUserTable->select(array(new \Zend\Db\Sql\Predicate\Literal("lower(u_name)='".strtolower($sUser_name)."'")
                                               , 'u_password_hash'=>$sUser_password_hash
                                                ,'u_status' => 1));
            
            $bAuthenticated = ($aResult['resultset']->count()==1) && $aResult['success'] && ($aResult['error_code']==0);
            
            if ($bAuthenticated) {
                session_start();
                session_regenerate_id();
                
                $oUser = $aResult['resultset']->current();
                $oUser->u_session = session_id();
                
                $resultSet = $oUserTable->update(array('u_session' => $oUser->u_session)
                                               , array('u_id' => $oUser->u_id));
            }
        }
        $aResponse =  array('u_authenticated'    => ($bAuthenticated ? 1 : 0));
        
        return $this->getServiceLocator()->get('User\View\Helper\JSONResponseView')->setArrayData($aResponse);
    }
}
