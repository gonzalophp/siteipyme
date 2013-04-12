<?php
namespace Shop\Controller;

class ProductController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        if ($this->getRequest()->isOptions()) return;
        
        $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\ProductTable');
        $aResult = $oProductTable->select();

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
        
        foreach($aResult['resultset'] as $oProduct) {
            $aResponse['datagrid'][] = $oProduct;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $oRequest = json_decode($sJSONDataRequest);
            $aRequest = (array)$oRequest;
            
            if (array_key_exists('p_id',$aRequest)){
                $aWhere = array('p_id' => $aRequest['p_id']);
                unset($aRequest['p_id']);
                $aSet = array();
                foreach($aRequest as $sField => $sValue) {
                    $aSet[$sField] = $sValue;
                }
                $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\ProductTable');        
                $aResult = $oProductTable->update($aSet,$aWhere);
                $aResponse = array('success' => $aResult['success']);
            }
            else {
                $aInsert = array('p_id' => new \Zend\Db\Sql\Predicate\Expression("DEFAULT"));
                foreach($aRequest as $sField => $sValue) {
                    $aInsert[$sField] = $sValue;
                }
                $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\ProductTable');        
                $aResult = $oProductTable->insert($aInsert);
                $aResponse = array('success' => $aResult['success']);
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
            $oRequest = json_decode($sJSONDataRequest);
            $aRequest = (array)$oRequest;
            
            if (array_key_exists('p_id',$aRequest)){
                $aWhere = array('p_id' => $aRequest['p_id']);
                $oProductTable = $this->getServiceLocator()->get('Datainterface\Model\ProductTable');        
                $aResult = $oProductTable->delete($aWhere);
                $aResponse = array('success' => $aResult['success']);
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
}
?>