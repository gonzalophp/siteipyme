<?php
namespace User\Controller;

class SignupController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        if ($this->getRequest()->isOptions()) return;
        parent::indexAction();
        
//        $this->getRequest()->setContent('{"user_name":"user","user_email":"user@ipyme.net","user_password":"user","user_password2":"user"}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        $nSignUpSuccess = 0;
        $sFail = 'unknown';
            
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $oDataRequest = json_decode($sJSONDataRequest);
            
            if (!$this->_objectPropertiesHaveValues($oDataRequest, array('user_name'
                                                                        ,'user_email'
                                                                        ,'user_password'
                                                                        ,'user_password2'))){
                $sFail = 'error_data_incomplete';
            }
            elseif ($oDataRequest->user_password != $oDataRequest->user_password2) {
                $sFail = 'error_password_does_not_match';
            }
            else {
                $sUser_password_hash = sha1($oDataRequest->user_password);
                
                $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
                
                session_start();
                session_regenerate_id();
                
                $aFunctionParams = array( ':p_u_session'         => session_id()
                                        ,':p_u_name'            => $oDataRequest->user_name
                                        ,':p_u_password_hash'   => $sUser_password_hash
                                        ,':p_u_email'           => $oDataRequest->user_email);
                        
                $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL'
                    , 'user_signup'
                    , $aFunctionParams);
                $nSignUpSuccess = ($oResultSet->count() == 1) ? 1:0;
                
                if ($nSignUpSuccess){
                    $this->_emailConfirmation($oDataRequest->user_name, $oDataRequest->user_password, $oDataRequest->user_email);
                }
                
                $sFail = '';
            }
        }
        
        $aResponse = array('signup_success' => $nSignUpSuccess
                         , 'signup_fail' => $sFail);
       
        return new \Zend\View\Model\JsonModel($aResponse);
    }

    public function confirmAction() {
        if ($this->getRequest()->isOptions()) return;
        $sSessionId =  $this->getEvent()->getRouteMatch()->getParam('id');
        
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'set_user_confirm'
                , array(':p_u_session' => $sSessionId));
        
        $bConfirmationSuccess = ($oResultSet->count() == 1);
        $aResponse = array('signup_confirmation' => ($bConfirmationSuccess?1:0));
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
       
    private function _emailConfirmation($sUser_name,$sUser_password,$sUser_email) {
        $aConfig = $this->getEvent()->getApplication()->getServiceManager()->get('config');
        
        
        $from = "ipymesoft@gmail.com";
        $to = $sUser_email;
        
        $subject = "iPyME Registration";
        $text = "";
        
        $htmlText = "<body>
    <style>
        div {
            background-color:#eee;
        }
        footer {
            font-size: smaller;
        }
        a {
            margin:1em 0em 1em 0em;
        }
    </style>
    <p>Your registration at iPyME has been accepted</p>
    <p>
        <ul>
            <li>User: <b>$sUser_name</b></li>
            <li>Password: <b>$sUser_password</b></li>
        </ul>
    </p>
    <p>Please, confirm your new registry data at iPyME making click on the link below:
        <br/>
        <br/>
        <a href='{$aConfig['front_end']}/#/user/signup/confirm/".session_id()."'>Click here to confirm and complete your registration</a>
    </p>
    <hr/>
    <footer>2013 - Gonzalo Grado</footer>
</body>";
        
        $oMimePartText = new \Zend\Mime\Part($text);
        $oMimePartText->type = \Zend\Mime\Mime::TYPE_TEXT;

        $oMimePartHTML = new \Zend\Mime\Part($htmlText);
        $oMimePartHTML->type = \Zend\Mime\Mime::TYPE_HTML;

        $oMimeMessage = new \Zend\Mime\Message();
        $oMimeMessage->setParts(array($oMimePartText,$oMimePartHTML));
    
        $host = "smtp.gmail.com";
        $port = "465";
        $username = "ipymesoft@gmail.com";  //<> give errors
        $password = "openshift";
        $ssl = 'ssl';
        
        $oMailMessage = new \Zend\Mail\Message();
        $oMailMessage->addTo($to)
                ->addFrom($from)
                ->setSubject($subject)
                ->setBody($oMimeMessage);
        $oTransport = new \Zend\Mail\Transport\Smtp(new \Zend\Mail\Transport\SmtpOptions(
                array(  'name'              => 'localhost',
                        'host'              => $host,
                        'port'              => $port,
                        'connection_class'  => 'login',
                        'connection_config' => array(
                            'username' => $username,
                            'password' => $password,
                            'ssl'      => $ssl,
                        ),
                    )));
        $oTransport->send($oMailMessage);
    }
    
    private function _objectPropertiesHaveValues($oObject, $aProperties){
        foreach($aProperties as $sProperty) {
            if(!(isset($oObject->$sProperty) && !empty($oObject->$sProperty))) return false;
        }
        return true;
    }
}