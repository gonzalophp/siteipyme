<?php
namespace User\Controller;

class SignupController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        parent::indexAction();
        
        $this->getRequest()->getHeaders()->addHeaderLine('X-Requested-With: XMLHttpRequest');
        $oDataRequest = (object) array('user_name' => 'gonzalo'
                                    , 'user_password' => 'gonzalo'
                                    , 'user_password2' => 'gonzalo'
                                    , 'user_email' => 'gonzalophp@gmail.com');
        
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
                session_start();
                session_regenerate_id();
                $sUser_password_hash = sha1($oDataRequest->user_password);
                $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\UserTable');
                $aResult = $oUserTable->insert(array('u_id' => new \Zend\Db\Sql\Predicate\Expression("DEFAULT")
                                                    ,'u_name'           => new \Zend\Db\Sql\Predicate\Expression("LOWER('".$oDataRequest->user_name."')") 
                                                    ,'u_password_hash'  => $sUser_password_hash
                                                    ,'u_email'          => $oDataRequest->user_email
                                                    ,'u_status'         => 0
                                                    ,'u_session'        => session_id()));
                if ($aResult['success']){
                    $nSignUpSuccess = 1;
                    $sFail = '';
                    $this->_emailConfirmation($oDataRequest->user_name, $oDataRequest->user_password, $oDataRequest->user_email);
                }
                else {
                    if ($aResult['error_code']==23505){
                        $aMatches=array();
                        preg_match('/Key \((.*)\)=\((.*)\) already exists/', $aResult['error_message'], $aMatches);
                        if (count($aMatches)==3) $sFail = "error_constraint_".$aMatches[1];
                    }
                }
            }
        }
        
        $aResponse = array('signup_success' => $nSignUpSuccess
                         , 'signup_fail' => $sFail);
       
        return $this->getServiceLocator()->get('User\View\Helper\JSONResponseView')->setArrayData($aResponse);   
    }
    
    public function onDispatch(\Zend\Mvc\MvcEvent $e) {
        $aConfig = $e->getApplication()->getServiceManager()->get('config');
        $e->getResponse()->getHeaders()->addHeaders(array('Access-Control-Allow-Headers' => 'X-Requested-With'
                                                         ,'Access-Control-Allow-Origin'  => $aConfig['front_end']));
        if ($e->getRequest()->isOptions()) {
            $e->setViewModel(new \Zend\View\Model\JsonModel());
        }
        else {
            parent::onDispatch($e);
        }
    }

    public function confirmAction() {
        $sSessionId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\UserTable');
        $aResult = $oUserTable->update(
            array('u_status' => 1)
            ,array( 'u_session' => $sSessionId
                   ,'u_status' => 0));
        $bConfirmationSuccess = ($aResult['resultset']==1) && $aResult['success'] && ($aResult['error_code']==0);
        if ($bConfirmationSuccess){
            session_id($sSessionId);
            session_start();
        }
        $aResponse = array('signup_confirmation' => ($bConfirmationSuccess?1:0));

        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
       
    private function _emailConfirmation($sUser_name,$sUser_password,$sUser_email) {
        $from = "gonzalophp@gmail.com";
        $to = $sUser_email;
        
        $to = $from;
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
        <a href='http://ipyme/#/user/signup/confirm/".session_id()."'>Click here to confirm and complete your registration</a>
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
        $username = "gonzalophp@gmail.com";  //<> give errors
        $password = "G4d1t4n010";
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