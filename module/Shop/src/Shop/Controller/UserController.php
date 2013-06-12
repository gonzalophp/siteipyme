<?php
namespace Shop\Controller;

class UserController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "u_id", 'displayName' => "ID", 'width' => 50),
                array('field' => "u_session", 'displayName' => "Session", 'width' => 250),
                array('field' => "u_last_login", 'displayName' => "Last Loged In", 'width' => 100),
                array('field' => "u_email", 'displayName' => "EMail", 'width' => 150),
                array('field' => "u_status", 'displayName' => "Status", 'width' => 50),
                array('field' => "u_basket", 'displayName' => "Basket", 'width' => 70),
                array('field' => "u_customer", 'displayName' => "Customer", 'width' => 100),
                
            )
        );
                
        $oUserTable = $this->getServiceLocator()->get('Datainterface\Model\TableInterface')->getTableInterface('IPYME_FINAL','USER');
        $aResult = $oUserTable->fetchAll();
            
        foreach($aResult['resultset'] as $oUser) {
            $aResponse['datagrid'][] = $oUser;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
        
        
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_customer', array(':id' => null));
        
        foreach($oResultSet as $aRow) {
            $aResponse['datagrid'][] = $aRow;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_customer'
                    , array( ':p_c_id'              => array_key_exists('c_id',$aRequest)?$aRequest['c_id']:null
                            ,':p_c_customer_name'   => $aRequest['c_customer_name']
                            ,':p_ie_id'             => array_key_exists('ie_id',$aRequest)?$aRequest['ie_id']:null
                            ,':p_ie_legal_id'       => $aRequest['ie_legal_id']
                            ,':p_ie_invoice_name'   => $aRequest['ie_invoice_name']));
                    
            $aResultSet = $oResultSet->current();
            $bSuccess = $aResultSet['success'];
        }
        else {
            $bSuccess=false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0)));
    }
    
    public function DeleteAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);;
            $oTableController = $this->getServiceLocator()->get('Datainterface\Model\TableInterface');
            $bSuccess = $oTableController->delete('Datainterface\Model\CustomerTable','p_id',$aRequest);
        }
        else {
            $bSuccess = false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0)));
    }
    
    public function getAction(){
//        $this->getRequest()->setContent('{}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
            $aUser = $this->getServiceLocator()->get('User\Model\UserCredentials')->getUserDetails();
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL',
                    'get_user_details', 
                    array(':p_u_session' => session_id()));
        
            if ($oResultSet->count() > 0){
                 foreach($oResultSet as $aRow) {
                    if (empty($aUserDetails)) {
                        $aUserDetails['user_u_id']                      = $aRow['user_u_id'];
                        $aUserDetails['user_u_last_login']              = $aRow['user_u_last_login'];
                        $aUserDetails['user_u_email']                   = $aRow['user_u_email'];
                        $aUserDetails['invoice_entity_ie_id']           = $aRow['invoice_entity_ie_id'];
                        $aUserDetails['invoice_entity_ie_invoice_name'] = $aRow['invoice_entity_ie_invoice_name'];
                        $aUserDetails['card']      = array();
                        $aUserDetails['addresses'] = array();
                        $aUserDetails['people']    = array();
                    }

                    if (!is_null($aRow['card_c_id']) && !array_key_exists($aRow['card_c_id'], $aUserDetails['card'])){
                        $aUserDetails['card'][$aRow['card_c_id']] = array(
                            'card_c_id'             => $aRow['card_c_id'],
                            'card_c_description'    => $aRow['card_c_description'],
                            'card_c_card_number'    => $aRow['card_c_card_number'],
                            'card_c_name'           => $aRow['card_c_name'],
                            'card_c_expire_date'    => $aRow['card_c_expire_date'],
                            'card_c_issue_numer'    => $aRow['card_c_issue_numer'],
                            'card_c_vendor'         => $aRow['card_c_vendor'],
                            'card_vendor_cv_name'   => $aRow['card_vendor_cv_name'],);
                    }
                    if (!is_null($aRow['address_detail_ad_id']) && !array_key_exists($aRow['address_detail_ad_id'], $aUserDetails['addresses'])){
                        $aUserDetails['addresses'][$aRow['address_detail_ad_id']] = array(
                            'address_detail_ad_description' => $aRow['address_detail_ad_description'],
                            'address_detail_ad_id'          => $aRow['address_detail_ad_id'],
                            'address_detail_ad_line1'       => $aRow['address_detail_ad_line1'],
                            'address_detail_ad_line2'       => $aRow['address_detail_ad_line2'],
                            'address_detail_ad_town'        => $aRow['address_detail_ad_town'],
                            'address_detail_ad_post_code'   => $aRow['address_detail_ad_post_code'],
                            'address_detail_ad_country'     => array('country_c_id'     => $aRow['country_c_id'],
                                                                    'country_c_name'    => $aRow['country_c_name'],
                                                                    'country_c_code'    => $aRow['country_c_code'],)

                        );
                    }

                    if (!is_null($aRow['people_p_id']) && !array_key_exists($aRow['people_p_id'], $aUserDetails['people'])){
                        $aUserDetails['people'][$aRow['people_p_id']] = array(
                            'people_p_id'       => $aRow['people_p_id'],
                            'people_p_title'    => $aRow['people_p_title'],
                            'people_p_name'     => $aRow['people_p_name'],
                            'people_p_surname'  => $aRow['people_p_surname'],
                            'people_p_phone'    => $aRow['people_p_phone'],);
                    }
                }

                $aUserDetails['card']      = array_values($aUserDetails['card']);
                $aUserDetails['addresses'] = array_values($aUserDetails['addresses']);
                $aUserDetails['people']    = array_values($aUserDetails['people']);
            }
            else {
                $aUserDetails = array('card'        => array()
                                    ,'addresses'   => array()
                                    ,'people'      => array());
            }
                
            $aUserDetails['card_vendor'] = array();
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL','get_card_vendor', array(':p_cv_id' => null));
            foreach($oResultSet as $aRow) {
                $aUserDetails['card_vendor'][] = $aRow['cv_name'];
            }
            
            $aUserDetails['user_u_email'] = $aUser['u_email'];
        }
        
//        var_dump($aUserDetails);
        return new \Zend\View\Model\JsonModel(array('success' => 1, 'user_details' => $aUserDetails));
    }
    
    public function getCountriesAction() {
        $aCountries = array();
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'get_countries'
                , array(':id' => null));
            
            foreach($oResultSet as $aRow) {
                $aCountries[] = $aRow;
            }
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => 1, 'available' => $aCountries));
    }
    
    public function addressAction() {
//        $this->getRequest()->setContent('{"address_detail_ad_description":"ertraaaaaaa","address_detail_ad_id":21,"address_detail_ad_line1":"ertredddddddddddd","address_detail_ad_line2":"retreDDDD","address_detail_ad_town":"retre","address_detail_ad_post_code":"ertretert","address_detail_ad_country":{"country_c_id":527,"country_c_name":"bolivia","country_c_code":"bo"}}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
//        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $aFunctionParams = array(':p_u_session'         => session_id()
                                    ,':p_ad_id'             => array_key_exists('address_detail_ad_id',$aRequest)?$aRequest['address_detail_ad_id']:0
                                    ,':p_ad_line1'          => array_key_exists('address_detail_ad_line1',$aRequest)?$aRequest['address_detail_ad_line1']:''
                                    ,':p_ad_line2'          => array_key_exists('address_detail_ad_line2',$aRequest)?$aRequest['address_detail_ad_line2']:''
                                    ,':p_ad_town'           => array_key_exists('address_detail_ad_town',$aRequest)?$aRequest['address_detail_ad_town']:''
                                    ,':p_ad_post_code'      => array_key_exists('address_detail_ad_post_code',$aRequest)?$aRequest['address_detail_ad_post_code']:''
                                    ,':p_ad_description'    => array_key_exists('address_detail_ad_description',$aRequest)?$aRequest['address_detail_ad_description']:''
                                    ,':p_c_code'            => array_key_exists('address_detail_ad_country',$aRequest)?$aRequest['address_detail_ad_country']->country_c_code:'');
            
  
//            var_dump($aRequest,$aFunctionParams);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL'
                    , 'set_address'
                    , $aFunctionParams);
                
            
            
            $aResultSet = $oResultSet->current();
            if ($bSuccess = ($oResultSet->count() == 1)){
                $aResultSet['address_detail_ad_country'] = array('country_c_code' => $aResultSet['country_c_code']
                                                                ,'country_c_id' => $aResultSet['country_c_id']
                                                                ,'country_c_name' => $aResultSet['country_c_name']);
            }
        }
        else {
            $bSuccess=false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0), 'address' => $aResultSet));
    }
    
    public function cardAction() {
//        $this->getRequest()->setContent('{"card_c_description":"bbbbbb","card_vendor_cv_name":"electron","card_c_name":"bbbbbb","card_c_card_number":"bbbbbb","card_c_expire_date":"bbbbbb","card_c_issue_numer":"bbbbbb"}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
//        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            
            $aFunctionParams = array(':p_u_session'     => session_id()
                                    ,':p_c_id'          => array_key_exists('card_c_id',$aRequest)?$aRequest['card_c_id']:0
                                    ,':p_c_description' => array_key_exists('card_c_description',$aRequest)?$aRequest['card_c_description']:''
                                    ,':p_c_card_number' => array_key_exists('card_c_card_number',$aRequest)?$aRequest['card_c_card_number']:''
                                    ,':p_c_name'        => array_key_exists('card_c_name',$aRequest)?$aRequest['card_c_name']:''
                                    ,':p_c_expire_date' => array_key_exists('card_c_expire_date',$aRequest)?$aRequest['card_c_expire_date']:''
                                    ,':p_c_issue_numer' => array_key_exists('card_c_issue_numer',$aRequest)?$aRequest['card_c_issue_numer']:''
                                    ,':p_c_vendor'      => array_key_exists('card_c_vendor',$aRequest)?$aRequest['card_c_vendor']:''
                                    ,':p_cv_name'       => array_key_exists('card_vendor_cv_name',$aRequest)?$aRequest['card_vendor_cv_name']:'');
//            var_dump($aRequest,$aFunctionParams);
//            exit;
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL'
                    , 'set_payment_card'
                    , $aFunctionParams);
                
            
            
            $aResultSet = $oResultSet->current();
            $bSuccess = ($oResultSet->count() == 1);
        }
        else {
            $bSuccess=false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0), 'card' => $aResultSet));
    }
    
    public function accountAction() {
//        $this->getRequest()->setContent('{"people_p_title":"Mr.","people_p_name":"gfff","people_p_surname":"fdffd","people_p_phone":"fddfd"}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
//        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $aFunctionParams = array(':p_u_session' => session_id()
                                    ,':p_p_id'      => array_key_exists('people_p_id',$aRequest)?$aRequest['people_p_id']:0
                                    ,':p_title'     => array_key_exists('people_p_title',$aRequest)?$aRequest['people_p_title']:''
                                    ,':p_p_name'    => array_key_exists('people_p_name',$aRequest)?$aRequest['people_p_name']:''
                                    ,':p_p_surname' => array_key_exists('people_p_surname',$aRequest)?$aRequest['people_p_surname']:''
                                    ,':p_p_phone'   => array_key_exists('people_p_phone',$aRequest)?$aRequest['people_p_phone']:'');
//            var_dump($aRequest,$aFunctionParams);
//            exit;
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL'
                    , 'set_people'
                    , $aFunctionParams);
            
            $aResultSet = $oResultSet->current();
            $bSuccess = ($oResultSet->count() == 1);
        }
        else {
            $bSuccess=false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0), 'people' => $aResultSet));
    }
}
?>