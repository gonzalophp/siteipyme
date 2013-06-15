<?php
namespace Shop\Controller;

class ProductController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "p_id", 'displayName' => "ID", 'width' => 30, 'pinned' => true),
                array('field' => "p_category_name", 'displayName' => "Category", 'width' => 100),
                array('field' => "p_ref", 'displayName' => "Reference", 'width' => 100),
                array('field' => "p_description", 'displayName' => "Description", 'width' => 150),
                array('field' => "p_long_description", 'displayName' => "Long Description", 'width' => 200),
                array('field' => "p_price", 'displayName' => "Price", 'width' => 50),
                array('field' => "c_name", 'displayName' => "Currency", 'width' => 50),
            )
        );
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        
        $nPage=1;
        $nPageSize=10;
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            if (array_key_exists('pagesize', $aRequest)) $nPageSize = $aRequest['pagesize'];
            if (array_key_exists('page', $aRequest)) $nPage = $aRequest['page'];
        }
        
        
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
            'IPYME_FINAL'
            , 'get_product'
            , array(':id' => null
                    ,':p_pagesize' => $nPageSize
                    ,':p_page' => $nPage));
            
        foreach($oResultSet as $aProduct) {
            $aProduct['grid_id'] = $aProduct['p_id'];
            $aProduct['p_price'] = number_format($aProduct['p_price'],2);
            $aResponse['datagrid'][] = $aProduct;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    public function getDisplayedProductsByCategoryAction() {
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        
        $nPage=1;
        $nPageSize=10;
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            if (array_key_exists('pagesize', $aRequest)) $nPageSize = $aRequest['pagesize'];
            if (array_key_exists('page', $aRequest)) $nPage = $aRequest['page'];
        }
            
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'get_product_by_category'
                , array(':pc_id' => $nProductCategoryId
                        ,':p_pagesize'=> $nPageSize
                        ,':p_page'=> $nPage));
        
        $aResponse = array('success' =>1, 'displayedProducts' => array());
        foreach($oResultSet as $aProduct) {
            $aResponse['displayedProducts'][] = array('id'              => $aProduct['p_id']
                                                    , 'image_path'      => $aProduct['p_image_path']
                                                    , 'description'     => $aProduct['p_description']
                                                    , 'longDescription' => $aProduct['p_long_description']
                                                    , 'price'           => number_format($aProduct['p_price'],2)
                                                    , 'currency'        => $aProduct['c_name']
                                                    , 'category'        => $aProduct['p_category']
                                                    , 'category_name'   => $aProduct['p_category_name']
                                                    , 'quantity'        => 1);
        }
                                    
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function getDisplayedProductsByAttributeValueAction() {
//        $this->getRequest()->setContent('{"15":{"pca_id":15,"pca_attribute":"CORES","attribute_value_selected":"","attribute_values":["2","4"],"attributes":[{"id":15,"value":"2","selected":0},{"id":15,"value":"4","selected":1}]},"20":{"pca_id":20,"pca_attribute":"FAMILY","attribute_value_selected":"","attribute_values":["CORE 2","I5","I7"],"attributes":[{"id":20,"value":"CORE 2","selected":0},{"id":20,"value":"I5","selected":1},{"id":20,"value":"I7","selected":1}]},"21":{"pca_id":21,"pca_attribute":"SPEED","attribute_value_selected":"","attribute_values":["3.4G"],"attributes":[{"id":21,"value":"3.4G","selected":0}]}}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            
            $aAttributeValuesSelected = array();
            foreach($aRequest as $nCategoryAttributeId => $aAttributeDetails){
                foreach($aAttributeDetails['attributes'] as $aAttributeValueDetails) {
                    if ($aAttributeValueDetails['selected'] == 1){
                        $aAttributeValuesSelected[] = $nCategoryAttributeId.'%^%'.$aAttributeValueDetails['value'];
                    }
                }
            }
            
            $sAttributeValuesSelected = implode('~^~',$aAttributeValuesSelected);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                    'IPYME_FINAL'
                    , 'get_product_by_attribute_value'
                    , array(':p_category_attribute_id_and_value' => $sAttributeValuesSelected));
            
            

            $aResponse = array('success' =>1, 'displayedProducts' => array());
            foreach($oResultSet as $aProduct) {
                $aResponse['displayedProducts'][] = array('id'              => $aProduct['p_id']
                                                        , 'image_path'      => $aProduct['p_image_path']
                                                        , 'description'     => $aProduct['p_description']
                                                        , 'longDescription' => $aProduct['p_long_description']
                                                        , 'price'           => number_format($aProduct['p_price'],2)
                                                        , 'currency'        => $aProduct['c_name']
                                                        , 'category'        => $aProduct['p_category']
                                                        , 'category_name'   => $aProduct['p_category_name']
                                                        , 'quantity'        => 1);
            }
        }
        else {
            $aResponse = array('success' => 0);
        }
                                    
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    
    public function getProductsByCategoryAction() {
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        
        $nPage=1;
        $nPageSize=10;
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            if (array_key_exists('pagesize', $aRequest)) $nPageSize = $aRequest['pagesize'];
            if (array_key_exists('page', $aRequest)) $nPage = $aRequest['page'];
        }
            
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'get_product_by_category'
                , array(':pc_id' => $nProductCategoryId
                        ,':p_pagesize'=> $nPageSize
                        ,':p_page'=> $nPage));
        
        
        
        $aResponse = array('success' =>1);
        foreach($oResultSet as $aProduct) {
            $aProduct['grid_id'] = $aProduct['p_id'];
            $aProduct['p_price'] = number_format($aProduct['p_price'],2);
            $aResponse['datagrid'][] = $aProduct;
        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    public function SaveAction(){
//        $this->getRequest()->setContent('{"p_category":"8","p_category_name":"CPU","category_attribute":{"1":{"pca_id":1,"pca_attribute":"BRAND","attribute_value_selected":"INTEL","attribute_values":["INTEL"],"attributes":[{"id":1,"value":"INTEL"}]},"2":{"pca_id":2,"pca_attribute":"SPEED","attribute_value_selected":"3.30GHZ","attribute_values":["3.30GHZ","3.40GHZ"],"attributes":[{"id":2,"value":"3.30GHZ"},{"id":2,"value":"3.40GHZ"}]},"3":{"pca_id":3,"pca_attribute":"CORES","attribute_value_selected":"4","attribute_values":["2","4"],"attributes":[{"id":3,"value":"2"},{"id":3,"value":"4"}]},"5":{"pca_id":5,"pca_attribute":"SOCKET","attribute_value_selected":"LGA1155","attribute_values":["LGA1150","LGA1155"],"attributes":[{"id":5,"value":"LGA1150"},{"id":5,"value":"LGA1155"}]},"18":{"pca_id":18,"pca_attribute":"CODENAME","attribute_value_selected":"SANDYBRIDGE","attribute_values":["HASWELL","SANDYBRIDGE"],"attributes":[{"id":18,"value":"HASWELL"},{"id":18,"value":"SANDYBRIDGE"}]}},"p_description":"Intel Core i5-2500K 3.30GHz","p_long_description":"Intel Core i5-2500K 3.30GHz (Sandybridge) Socket LGA1155 Processor - Retail","p_ref":"Intel Core i5-2500K 3.30GHz","p_price":"170","c_name":"GBP","p_image_path":"http://siteipyme/img/CP-360-IN_200.jpg"}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
//        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            $nProductId = array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null;
            
            $aFunctionParams = array(':p_p_id'                => $nProductId
                        ,':p_p_ref'              => $aRequest['p_ref']
                        ,':p_p_description'      => array_key_exists('p_description',$aRequest)?$aRequest['p_description']:null
                        ,':p_p_long_description' => array_key_exists('p_long_description',$aRequest)?$aRequest['p_long_description']:null
                        ,':p_p_category'         => $aRequest['p_category']
                        ,':p_p_price'            => array_key_exists('p_price',$aRequest)?$aRequest['p_price']:null
                        ,':p_p_image_path'       => array_key_exists('p_image_path',$aRequest)?$aRequest['p_image_path']:null
                        ,':p_c_name'             => array_key_exists('c_name',$aRequest)?$aRequest['c_name']:null);
            
//            var_dump($aFunctionParams);
            $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'set_product'
                , $aFunctionParams);
            
            $aResponse = $oResultSet->current();
            if ($oResultSet->count()==1){
                $aResponse['success'] = 1;
                $aResponse['grid_id'] = $aResponse['p_id'];
                
                if (array_key_exists('category_attribute',$aRequest)){
                    foreach($aRequest['category_attribute'] as $aAttributeValue){
                        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                        'IPYME_FINAL'
                        , 'set_product_attribute_value'
                        , array(':p_pav_product'                    => $aResponse['p_id']
                               ,':p_pav_product_category_attribute' => $aAttributeValue['pca_id']
                               ,':p_pav_value'                      => $aAttributeValue['attribute_value_selected']));
                    }
                }
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
        
//        $this->getRequest()->setContent('{"fields":{"p_id":42,"p_ref":"DDR51","p_description":null,"p_long_description":null,"p_category":16,"grid_id":42},"categoryselected":{"id":"15","category":"COMPONENTS"}}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest, true);
//            var_dump($aRequest);
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
    
    public function getAction() {
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
                'IPYME_FINAL'
                , 'get_product'
                , array(':pc_id' => $nProductId
                        ,':p_pagesize'=>1
                        ,':p_page'=>1
                ));
        
        $aProduct = $oResultSet->current();
        $aProduct['p_price'] = number_format($aProduct['p_price'],2);
        
        $aResponse = array('success' =>1, 'product' => $aProduct);
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>