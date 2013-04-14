<?php
namespace Shop\Controller;

class ProductController extends \Zend\Mvc\Controller\AbstractActionController {
    
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
        
        $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\TableInterface')->getTableInterface('IPYME_FINAL','PRODUCT');
        $aResult = $oProductTable->fetchAll();
            
        foreach($aResult['resultset'] as $oProduct) {
            $aResponse['datagrid'][] = $oProduct;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\TableInterface')->getTableInterface('IPYME_FINAL','PRODUCT','p_id',$aRequest);
            $bSuccess = $oProductTable->save()?1:0;
        }
        else {
            $bSuccess=false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0)));
    }
    
    public function DeleteAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\TableInterface')->getTableInterface('IPYME_FINAL','PRODUCT','p_id',$aRequest);
            $bSuccess = $oProductTable->delete();
        }
        else {
            $bSuccess = false;
        }
        
        return new \Zend\View\Model\JsonModel(array('success' => ($bSuccess?1:0)));
    }
}
?>