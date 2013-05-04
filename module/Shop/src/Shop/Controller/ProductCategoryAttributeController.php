<?php
namespace Shop\Controller;

class ProductCategoryAttributeController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function getAction(){
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category_attribute'
            , array(':p_pc_id'            => $nProductCategoryId));
        
        $aCategoryAttribute = array();
        foreach($oResultSet as $aRow) {
            $aCategoryAttribute[] = array('pca_id' => $aRow['pca_id'] ,'pca_value' => $aRow['pca_value']);
        }
//        var_dump($nCategoryId);
        $aResponse = array('success' => 1, 'category_attribute' => $aCategoryAttribute);
                
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function saveAction(){
        
//        $this->getRequest()->setContent('{"title":null,"key":"_1","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"aaa","key":"_2","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"bbb","key":"_3","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"ddd","key":"_4","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"eee","key":"_5","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true}],"edited":true},{"title":"ggg","key":"_6","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true},{"title":"ggg","key":"_7","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"hhh","key":"_9","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true},{"title":"uuuuu","key":"_8","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true}]}');
//        $this->getRequest()->setContent('{"category_id":"2","category_attributes":[{"key":-1,"value":"aaaa"},{"key":-1,"value":"bbbb"},{"key":-1,"value":"cccc"}]}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
       
//         $aResponse = array('success' => 333);
//          return new \Zend\View\Model\JsonModel($aResponse);
         
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
//            $aSavedAttributes = array();
//            foreach($aRequest['category_attributes']['values'] as $oCategoryAttribute){
//                $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category_attribute'
//                    , array(':p_pca_id'                  => ($oCategoryAttribute->pca_id != -1) ? $oCategoryAttribute->pca_id: NULL
//                            ,':p_pca_product_category'   => $aRequest['category_id']
//                            ,':p_pca_value'              => $oCategoryAttribute->pca_value));
//                $aSavedAttributes[] = $oResultSet->current();
//            }
            
            $aRemovedAttributes = array();
            foreach($aRequest['category_attributes']['removed'] as $oCategoryAttribute){
                $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category_attribute'
                    , array(':p_pca_id'                  => ($oCategoryAttribute->pca_id != -1) ? $oCategoryAttribute->pca_id: NULL
                            ,':p_pca_product_category'   => $aRequest['category_id']
                            ,':p_pca_value'              => $oCategoryAttribute->pca_value));
                $aSavedAttributes[] = $oResultSet->current();
            }
            
                
            
//            $aTableTree = $this->getTableTree($aRequest['tree']);
//            $aCategories = array();
//            foreach($aTableTree as $sNodeProperties => $sNodePath) {
//                list($sNodeKey, $sNodeEdited) = explode($this->sPropertySeparator, $sNodeProperties);
//                $aCategories[] = array('key' => $sNodeKey
//                                        ,'edited' => $sNodeEdited
//                                        ,'path' => $sNodePath);
//            }
            
            $aResponse = array('success' => 1, 'removed_attributes' => $aRemovedAttributes, 'saved_attributes' => $aSavedAttributes);
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
}
?>