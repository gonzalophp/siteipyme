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
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product', array(':id' => null));
            
        foreach($oResultSet as $aProduct) {
            $aProduct['grid_id'] = $aProduct['p_id'];
            $aResponse['datagrid'][] = $aProduct;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'set_product'
                , array(':p_p_id'                => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null
                        ,':p_p_ref'              => $aRequest['p_ref']
                        ,':p_p_description'      => $aRequest['p_description']
                        ,':p_p_long_description' => $aRequest['p_long_description']
                        ,':p_p_weight'           => $aRequest['p_weight']
                        ,':p_p_size'             => $aRequest['p_size']));

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
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'delete_product'
                , array(':p_p_id'                => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null));
            
            
            $aResponse = $oResultSet->current();
            $aResponse['success'] = ($oResultSet->count()==1)?1:0;
        }
        else {
            $aResponse = array('success' => 0);
        }
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>