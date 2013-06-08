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
        $this->getRequest()->setContent('{}');
        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL',
                    'get_user_details', 
                    array(':p_u_session' => session_id()));
        
            $aUserDetails = array();
               
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
                
                if (!array_key_exists($aRow['card_c_id'], $aUserDetails['card'])){
                    $aUserDetails['card'][$aRow['card_c_id']] = array(
                        'card_c_id'             => $aRow['card_c_id'],
                        'card_c_description'    => $aRow['card_c_description'],
                        'card_c_card_number'    => $aRow['card_c_card_number'],
                        'card_c_name'           => $aRow['card_c_name'],
                        'card_c_expire_date'    => $aRow['card_c_expire_date'],
                        'card_c_issue_numer'    => $aRow['card_c_issue_numer'],
                        'card_c_vendor'         => $aRow['card_c_vendor'],);
                }
                
                if (!array_key_exists($aRow['address_detail_ad_id'], $aUserDetails['addresses'])){
                    $aUserDetails['addresses'][$aRow['address_detail_ad_id']] = array(
                        'address_detail_ad_id'          => $aRow['address_detail_ad_id'],
                        'address_detail_ad_line1'       => $aRow['address_detail_ad_line1'],
                        'address_detail_ad_line2'       => $aRow['address_detail_ad_line2'],
                        'address_detail_ad_town'        => $aRow['address_detail_ad_town'],
                        'address_detail_ad_post_code'   => $aRow['address_detail_ad_post_code'],
                        'address_detail_ad_country'     => $aRow['address_detail_ad_country'],
                        'address_detail_ad_description' => $aRow['address_detail_ad_description'],
                        'country_c_id'                  => $aRow['country_c_id'],
                        'country_c_name'                => $aRow['country_c_name'],
                        'country_c_code'                => $aRow['country_c_code'],);
                }
                
                if (!array_key_exists($aRow['people_p_id'], $aUserDetails['people'])){
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
        $sAddressAction =  $this->getEvent()->getRouteMatch()->getParam('id');
        return new \Zend\View\Model\JsonModel(array('success' => 1, 'address_action' => $sAddressAction));
    }
    
    public function paymentAction() {
        $sAddressAction =  $this->getEvent()->getRouteMatch()->getParam('id');
        return new \Zend\View\Model\JsonModel(array('success' => 1, 'address_action' => $sAddressAction));
    }
}
?>