<?php
namespace Shop\Controller;

class CustomerController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "c_id", 'displayName' => "ID", 'width' => 30),
                array('field' => "c_customer_name", 'displayName' => "Customer", 'width' => 150),
                array('field' => "ie_legal_id", 'displayName' => "Legal ID", 'width' => 100),
                array('field' => "ie_invoice_name", 'displayName' => "Invoice Name", 'width' => 150),
            )
        );
        
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