<?php
namespace Shop\Controller;

class ProductCategoryValueController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function getAction(){
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category_values'
            , array(':p_pc_id'            => $nProductCategoryId));
        
        $aCategoryValues = array();
        foreach($oResultSet as $aRow) {
            $aCategoryValues[] = $aRow;
        }
//        var_dump($nCategoryId);
        $aResponse = array('success' => 1, 'category_values' => $aCategoryValues);
                
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function saveAction(){
        
//        $this->getRequest()->setContent('{"title":null,"key":"_1","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"aaa","key":"_2","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"bbb","key":"_3","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"ddd","key":"_4","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"eee","key":"_5","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true}],"edited":true},{"title":"ggg","key":"_6","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true},{"title":"ggg","key":"_7","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"hhh","key":"_9","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true},{"title":"uuuuu","key":"_8","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true}]}');
//        $this->getRequest()->setContent('{"removed":["18"],"tree":{"title":null,"key":"_1","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"electronics","key":"11","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"computers","key":"12","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false}]},{"title":"abc","key":"_3","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"def","key":"_4","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"efg","key":"_5","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":1}],"edited":1}],"edited":1}]}}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
       
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category_values'
                    , array(':p_pcv_id'                  => (array_key_exists('p_pcv_id', $aRequest) ? $aRequest['p_pcv_id']:NULL)
                            ,':p_pcv_product_category'   => $aRequest['p_pcv_product_category']
                            ,':p_pcv_value'              => $aRequest['p_pcv_value']));
                
            
            $aTableTree = $this->getTableTree($aRequest['tree']);
            $aCategories = array();
            foreach($aTableTree as $sNodeProperties => $sNodePath) {
                list($sNodeKey, $sNodeEdited) = explode($this->sPropertySeparator, $sNodeProperties);
                $aCategories[] = array('key' => $sNodeKey
                                        ,'edited' => $sNodeEdited
                                        ,'path' => $sNodePath);
            }
            
            $aResponse = array('success' => 1, 'saved_categories' => array());
            
            foreach($aCategories as $aCategory) {
                if ($aCategory['edited'] == 1) {
                    $nCategoryId = ((strpos($aCategory['key'],'_'))===0) ? NULL : $aCategory['key'];
                    $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category'
                        , array(':p_pc_id'            => $nCategoryId
                                , ':p_pc_tax_rate'      => 0
                                , ':p_pc_description'   => ''
                                , ':p_pc_path'          => $aCategory['path']));
                    foreach($oResultSet as $row){
                        $aResponse['saved_categories'][] = array('old_key' =>  $aCategory['key']
                                                                ,'new_key' => $row['pc_id']);
                    }
                }
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
}
?>