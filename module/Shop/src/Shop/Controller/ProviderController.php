<?php
namespace Shop\Controller;

class ProviderController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "p_id", 'displayName' => "ID", 'width' => 30),
                array('field' => "p_provider_name", 'displayName' => "Provider", 'width' => 150),
                array('field' => "ie_legal_id", 'displayName' => "Legal ID", 'width' => 100),
                array('field' => "ie_invoice_name", 'displayName' => "Invoice Name", 'width' => 150),
            )
        );
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_provider', array(':id' => null));
            
        foreach($oResultSet as $aProvider) {
            $aProvider['grid_id'] = $aProvider['p_id'];
            $aResponse['datagrid'][] = $aProvider;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_provider'
                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null
                            ,':p_p_provider_name'   => $aRequest['p_provider_name']
                            ,':p_ie_id'             => array_key_exists('ie_id',$aRequest)?$aRequest['ie_id']:null
                            ,':p_ie_legal_id'       => $aRequest['ie_legal_id']
                            ,':p_ie_invoice_name'   => $aRequest['ie_invoice_name']));
            
            $aResponse = $oResultSet->current();
            if ($oResultSet->count()==1){
                $aResponse['success'] = ($oResultSet->count()==1)?1:0;
                $aResponse['grid_id'] = $aResponse['p_id'];
            }
            else {
                $aResponse = array('success' => 0);
            }
        }
        else {
           $aResponse = array('success' => 0);
        }
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function DeleteAction(){
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'delete_provider'
                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null));
                    
            $aResponse = $oResultSet->current();
            $aResponse['success'] = ($oResultSet->count()==1)?1:0;
        }
        else {
            $aResponse = array('success' => 0);
        }
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function testAction() {
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_customer', array(':id' => null));
        
        foreach($oResultSet as $aRow) {
            var_dump($aRow);
        }
        exit;
    }
}
?>