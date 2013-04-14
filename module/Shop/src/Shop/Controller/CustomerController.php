<?php
namespace Shop\Controller;

class CustomerController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "p_id", 'displayName' => "ID", 'width' => 30, 'pinned' => true),
                array('field' => "p_ref", 'displayName' => "Reference", 'width' => 100),
                array('field' => "p_description", 'displayName' => "Description", 'width' => 150),
                array('field' => "p_size", 'displayName' => "Size", 'width' => 70),
                array('field' => "p_weight", 'displayName' => "Weight", 'width' => 70),
                array('field' => "p_long_description", 'displayName' => "Long Description", 'width' => 200),
            )
        );
        
        $oTableController = $this->getServiceLocator()->get('Datainterface\Model\TableInterface');
        $aResult = $oTableController->fetchAll('Datainterface\Model\CustomerTable');
            
        foreach($aResult['resultset'] as $oCustomer) {
            $aResponse['datagrid'][] = $oCustomer;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oTableController = $this->getServiceLocator()->get('Datainterface\Model\TableInterface');
            $bSuccess = $oTableController->save('Datainterface\Model\CustomerTable', 'p_id',$aRequest)?1:0;
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
}
?>