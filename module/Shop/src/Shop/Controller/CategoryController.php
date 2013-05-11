<?php
namespace Shop\Controller;

class CategoryController extends \Zend\Mvc\Controller\AbstractActionController {
    public $sPathSeparator = ' > ';
    public $sPropertySeparator = '^^^';
    
    public function indexAction() {
        $aResponse = array(
            'datagrid' => array(),
            'columnDefs' => array(
                array('field' => "c_id", 'displayName' => "ID", 'width' => 30),
                array('field' => "c_reference", 'displayName' => "Reference", 'width' => 150),
                array('field' => "c_description", 'displayName' => "Description", 'width' => 200),
                array('field' => "c_tax", 'displayName' => "Tax", 'width' => 150),
            )
        );

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function getAttributeAction(){
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category_attribute'
            , array(':p_pc_id'            => $nProductCategoryId));
        
        $aCategoryAttribute = array();
        foreach($oResultSet as $aRow) {
            $aCategoryAttribute[] = array('pca_id' => $aRow['pca_id'] ,'pca_attribute' => $aRow['pca_attribute']);
        }
        $aResponse = array('success' => 1, 'category_attribute' => $aCategoryAttribute);
                
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function getAttributeRelatedAction(){
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nProductCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_attribute_related'
            , array(':p_pc_id'            => $nProductCategoryId));
        
        $aCategoryAttribute = array();
        foreach($oResultSet as $aRow) {
            $aCategoryAttribute[] = array('pca_id' => $aRow['pca_id'] ,'pca_attribute' => $aRow['pca_attribute']);
        }
        $aResponse = array('success' => 1, 'category_attribute' => $aCategoryAttribute);
                
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    public function getAttributeValuesRelatedAction(){
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $sParameters =  $this->getEvent()->getRouteMatch()->getParam('id');
        $aParameters = explode(',',$sParameters);

        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_attribute_value_related'
            , array(':p_pc_id'            => $aParameters[0]));
        
        $aCategoryAttribute = array();
        foreach($oResultSet as $aRow) {
            if (!array_key_exists($aRow['pca_id'], $aCategoryAttribute)){
                $aCategoryAttribute[$aRow['pca_id']] = array('pca_id'           => $aRow['pca_id'] 
                                                            ,'pca_attribute'    => $aRow['pca_attribute']
                                                            ,'attribute_value_selected' => ''
                                                            ,'attribute_values' => array());
            }
            if (!is_null($aRow['pav_product'])){
//                $aCategoryAttribute[$aRow['pca_id']]['attribute_values'][] = array('pav_id'                         => $aRow['pav_id']
//                                                                                , 'pav_product_category_attribute'  => $aRow['pav_product_category_attribute']
//                                                                                , 'pav_value'                       => $aRow['pav_value']);
                if ($aRow['pav_product'] == $aParameters[1]) $aCategoryAttribute[$aRow['pca_id']]['attribute_value_selected'] = $aRow['pav_value'];
                $aCategoryAttribute[$aRow['pca_id']]['attribute_values'][] = $aRow['pav_value'];
            }
        }
        
        $aResponse = array('success' => 1, 'category_attribute' => $aCategoryAttribute);
                
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    
    public function getAction(){
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category'
            , array(':p_pc_id'            => (($nCategoryId != 'all') ? $nCategoryId:NULL)));
        
        $aTableTree = array();
        foreach($oResultSet as $aRow) {
            $aTableTree[$aRow['pc_id']] = "{$aRow['pc_path']}";
        }
        
        $aTree = $this->getTree($aTableTree);
        $aResponse = array('tree' => $aTree);
                
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function saveAction(){
//        $this->getRequest()->setContent('{"tree":{"title":null,"key":"_1","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"drinks","key":"12","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"alcohol","key":"13","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""}],"url":""},{"title":"food","key":"1","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"breakfast","key":"5","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""},{"title":"cupboard","key":"8","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"snacks","key":"9","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"nuts","key":"10","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"cashews","key":"11","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""}],"url":""}],"url":""}],"url":""},{"title":"frozen","key":"4","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"fish","key":"7","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""},{"title":"meat","key":"6","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""},{"title":"vegetables","key":"21","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""}],"url":""},{"title":"jars","key":"3","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""},{"title":"vegetables","key":"2","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""}],"url":""},{"title":"PCHARDWARE","key":"14","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"COMPONENTS","key":"15","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"CPU","key":"20","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""},{"title":"MEMORY","key":"16","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"DDR2","key":"17","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""},{"title":"DDR3","key":"18","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""}],"url":""},{"title":"MOTHERBOARD","key":"19","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"url":""}],"url":""}],"url":""}]},"added_nodes":[],"updated_nodes":[{"editing":1,"key":"21","attributes":{"removed":[17],"values":[]}},{"editing":1,"key":"10","attributes":{"removed":[-1,-1],"values":[]}},{"editing":1,"key":"2","attributes":{"removed":[],"values":[{"pca_id":1,"pca_attribute":"garden peas"},{"pca_id":4,"pca_attribute":"carrots"},{"pca_id":5,"pca_attribute":"spinach"},{"pca_id":6,"pca_attribute":"green beans"}]}},{"editing":1,"key":"6","attributes":{"removed":[],"values":[{"pca_id":-1,"pca_attribute":"chicken"}]}}]}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
        
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category'
            , array(':p_pc_id'            => NULL));
        
            $aRemovedCategories = array();
            foreach($oResultSet as $aRow) {
                $aRemovedCategories[$aRow['pc_id']] = $aRow['pc_id'];
            }
            
            $aTableTree = $this->getTableTree($aRequest['tree']);
            $aCategories = array();
            foreach($aTableTree as $sNodeProperties => $sNodePath) {
                list($sNodeKey, $sNodeEdited) = explode($this->sPropertySeparator, $sNodeProperties);
                $aCategories[] = array('key' => $sNodeKey
                                        ,'edited' => $sNodeEdited
                                        ,'path' => $sNodePath);
                if ((strpos($sNodeKey,'_'))!==0){
                    if (array_key_exists($sNodeKey, $aRemovedCategories)){
                        unset($aRemovedCategories[$sNodeKey]);
                    }
                }
            }
            
            // Remove categories
            foreach($aRemovedCategories as $nProductCategoryId) {
                $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'delete_product_category'
                        , array(':p_pc_id'            => $nProductCategoryId));
            }
            
            $aKeyMap = array();
            foreach($aCategories as $aCategory) {
                if ($aCategory['edited'] == 1) {
                    $nCategoryId = ((strpos($aCategory['key'],'_'))===0) ? NULL : $aCategory['key'];
                    $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category'
                        , array(':p_pc_id'            => $nCategoryId
                                , ':p_pc_tax_rate'      => 0
                                , ':p_pc_description'   => ''
                                , ':p_pc_path'          => $aCategory['path']));
                    foreach($oResultSet as $row){
                        $aKeyMap[$aCategory['key']] = $row['pc_id'];
                    }
                }
                else {
                    $aKeyMap[$aCategory['key']] = $aCategory['key'];
                }
            }
            
            // Added categories
            foreach($aRequest['added_nodes'] as $oCategory) {
                if (array_key_exists($oCategory->key, $aKeyMap)){
                    foreach($oCategory->attributes->values as $oAttribute){
                        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category_attribute'
                            , array(':p_pca_id'                  => NULL
                                    ,':p_pca_product_category'   => $aKeyMap[$oCategory->key]
                                    ,':p_pca_attribute'              => $oAttribute->pca_attribute));
                    }
                }
            }
            
            
            // Updated categories
            foreach($aRequest['updated_nodes'] as $oCategory) {
                if (!array_key_exists($oCategory->key,$aRemovedCategories)){
                    foreach($oCategory->attributes->removed as $nAttributeId){
                        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'delete_product_category_attribute'
                            , array(':p_pca_id'                  => $nAttributeId));
                    }
                    foreach($oCategory->attributes->values as $oAttribute){
                        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_product_category_attribute'
                            , array(':p_pca_id'                  => (($oAttribute->pca_id != -1) ? $oAttribute->pca_id:NULL)
                                    ,':p_pca_product_category'   => $oCategory->key
                                    ,':p_pca_attribute'              => $oAttribute->pca_attribute));
                    }
                }
            }
            
            // Reading all category tree
            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category'
                , array(':p_pc_id' => NULL));

            $aTableTree = array();
            foreach($oResultSet as $aRow) {
                $aTableTree[$aRow['pc_id']] = "{$aRow['pc_path']}";
            }

            $aTree = $this->getTree($aTableTree);
        
            $aResponse = array('success' => 1
                              ,'tree' => $aTree);
        }
        else {
           $aResponse = array('success' => 0);
        }
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    
    public function getTree($aTableTree, $nTreeDepth=0, $bMenuOutput=false){
//        asort($aTableTree);
        $aRoot =  array();
        $aNodeStack = array(&$aRoot);
        $sBaseAndSeparator = $this->sPathSeparator;
        
        if ($bMenuOutput){
            $aIndexes = array('nodes' => 'nodes'
                             ,'label' => 'label');
        }
        else {
            $aIndexes = array('nodes' => 'children'
                             ,'label' => 'title');
        }
            
        foreach($aTableTree as $sKey => $sNodePath) {
            if ($nTreeDepth && (substr_count($sNodePath, $this->sPathSeparator)>$nTreeDepth)) continue;
            if (strpos($sNodePath, $sBaseAndSeparator) !== 0){
                do {
                    $sBaseAndSeparator = substr($sBaseAndSeparator, 0, strrpos($sBaseAndSeparator,$this->sPathSeparator));
                } while((strcmp($sBaseAndSeparator, $this->sPathSeparator)>0) && (strpos($sNodePath, $sBaseAndSeparator)!==0) && array_pop($aNodeStack));
                
                $sBaseAndSeparator .= $this->sPathSeparator;
            }
            $nBaseAndSeparatorLength = strlen($sBaseAndSeparator);
            $aTree = &$aNodeStack[count($aNodeStack)-1];
            if (strpos($sNodePath, $this->sPathSeparator, $nBaseAndSeparatorLength) !== FALSE){
                $sBaseAndSeparator = substr($sNodePath, 0, strrpos($sNodePath, $this->sPathSeparator)).$this->sPathSeparator;
                $nBaseAndSeparatorLength = strlen($sBaseAndSeparator);
                $aTree[count($aTree)-1]['isFolder'] = true;
                $aTree[count($aTree)-1][$aIndexes['nodes']] = array();
                $aTree = &$aTree[count($aTree)-1][$aIndexes['nodes']];
                $aNodeStack[] = &$aTree;
            }

            $aTree[] = array($aIndexes['label'] => substr($sNodePath, $nBaseAndSeparatorLength)
                            ,'key'      => $sKey
                            ,'url'      => '');
        }
        
        return $aRoot;
    }
    
    public function getTableTree($aTree){
        $aTableTree = array();
        $aTableTreePhase1 = $this->fromTreeToTableTree($aTree);
        $nSeparatorLength = strlen($this->sPathSeparator);
        foreach($aTableTreePhase1 as $sNodeLine) {
            $nKeySeparator = strrpos($sNodeLine, $this->sPathSeparator);
            $sKey       = substr($sNodeLine, $nKeySeparator+$nSeparatorLength);
            $sNodePath  = substr($sNodeLine, 0, $nKeySeparator);
            $aTableTree[$sKey] = $sNodePath;
        }
        
        return $aTableTree;
    }
    
    public function fromTreeToTableTree($aTree){
        if (is_array($aTree)) {
            $sTitle = $aTree['title'];
            $aChildren = array_key_exists('children', $aTree) ? $aTree['children']:array();
            $sKey = $aTree['key'];
            $nEdited = array_key_exists('edited', $aTree) ? $aTree['edited']:0;
        }
        else {
            $sTitle = $aTree->title;
            $aChildren = isset($aTree->children)?$aTree->children:array();
            $sKey = $aTree->key;
            $nEdited = isset($aTree->edited)?$aTree->edited:0;
        }
        
        $aTableTree = array();
        if (!empty($aChildren)){
            if (!is_null($sTitle)) $aTableTree[] = "$sTitle$this->sPathSeparator$sKey$this->sPropertySeparator$nEdited";
            foreach($aChildren as $child){
                $aSub = $this->fromTreeToTableTree($child);
                
                foreach($aSub as $sub){
                    $aTableTree[] = "$sTitle$this->sPathSeparator$sub";
                }
            }
        }
        else {
            $aTableTree = array("$sTitle$this->sPathSeparator$sKey$this->sPropertySeparator$nEdited");
        }
        
        return $aTableTree;
    }
    
    public function menuAction() {
        
        $aMenuList = array(
            (object) array(
                'label' => 'iPyME'
                , 'url' => ''
                , 'nodes' => array(
                    (object) array(
                        'label' => 'Purchase'
                        , 'url' => '#/admin/purchase'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Provider'
                                , 'url' => '#/admin/list/provider'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Order'
                                , 'url' => '#/admin/purchase/order'
                                , 'nodes' => array())))
                    , (object) array(
                        'label' => 'Sale'
                        , 'url' => '#/admin/sale'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Customer'
                                , 'url' => '#/admin/list/customer'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Order'
                                , 'url' => '#/admin/sale/order'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Delivery'
                                , 'url' => '#/admin/sale/delivery'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Payment'
                                , 'url' => '#/admin/sale/payment'
                                , 'nodes' => array())))
                    , (object) array(
                        'label' => 'Product'
                        , 'url' => ''
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Stores'
                                , 'url' => '#/admin/stores'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Products'
                                , 'url' => '#/admin/list/product'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Category'
                                , 'url' => '#/admin/category'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Item'
                                , 'url' => '#/admin/product/item'
                                , 'nodes' => array())))
                    , (object) array(
                        'label' => 'Settings'
                        , 'url' => '#/admin/settings'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Users'
                                , 'url' => '#/admin/list/user'
                                , 'nodes' => array())))))
            , (object) array(
                'label' => 'Sign In'
                , 'url' => '#/user/signin'
                , 'nodes' => array())
            , (object) array(
                'label' => 'Basket'
                , 'url' => '#/user/basket'
                , 'nodes' => array())
            , (object) array(
                'label' => 'Resources'
                , 'url' => 'http://www.elmundo.es'
                , 'nodes' => array(
                    (object) array(
                        'label' => 'Resources A'
                        , 'url' => 'http://www.elmundo.es'
                        , 'nodes' => array())
                    , (object) array(
                        'label' => 'Resources B'
                        , 'url' => '#/admin/product'
                        , 'nodes' => array(
                            (object) array(
                                'label' => 'Resources B A'
                                , 'url' => 'http://www.elmundo.es'
                                , 'nodes' => array())
                            , (object) array(
                                'label' => 'Product'
                                , 'url' => '#/admin/product'
                                , 'nodes' => array()))))));
        
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $nCategoryId =  $this->getEvent()->getRouteMatch()->getParam('id');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_product_category'
            , array(':p_pc_id'            => NULL));
        
        $aTableTree = array();
        foreach($oResultSet as $aRow) {
            $aTableTree[$aRow['pc_id']] = "{$aRow['pc_path']}";
        }
        
        $aTree = $this->getTree($aTableTree,3, true);
        
        return new \Zend\View\Model\JsonModel($aTree);
    }
}
?>