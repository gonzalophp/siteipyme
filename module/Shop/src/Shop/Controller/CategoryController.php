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
//        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
//        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_provider', array(':id' => null));
//            
//        foreach($oResultSet as $aProvider) {
//            $aProvider['grid_id'] = $aProvider['p_id'];
//            $aResponse['datagrid'][] = $aProvider;
//        }

        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function getAction(){
        $aResponse = array(
            'tree' => array(array('title' => "Item 1"
                                    ,'toma' => 'aa'
                                    , 'key' => '77__1')
                               ,array('title' => "Item 2"
                                    ,'toma' => 'bb'
                                    ,'isFolder' => true
                                   , 'key' => '__2'
                                    ,'children' => array(
                                        array('title'=>'item 2.1', 'key' => '__21')
                                       ,array('title'=>'item 2.2', 'key' => '__22')
                                       ,array('title'=>'item 2.3', 'key' => '__23')
                                    ))
                               ,array('title' => "Item 3"
                                     ,'toma' => 'cc'
                                   , 'key' => '__3')
            )
        );
        
        
        
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
    
    public function SaveTreeAction(){
        
//        $this->getRequest()->setContent('{"title":null,"key":"_1","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"aaa","key":"_2","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"bbb","key":"_3","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"ddd","key":"_4","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"eee","key":"_5","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true}],"edited":true},{"title":"ggg","key":"_6","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true},{"title":"ggg","key":"_7","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"hhh","key":"_9","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true},{"title":"uuuuu","key":"_8","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":true}],"edited":true}]}');
//        $this->getRequest()->setContent('{"removed":["18"],"tree":{"title":null,"key":"_1","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"electronics","key":"11","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"computers","key":"12","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false}]},{"title":"abc","key":"_3","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"def","key":"_4","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"efg","key":"_5","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"edited":1}],"edited":1}],"edited":1}]}}');
//        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
       
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
            

            
            foreach($aRequest['removed'] as $nProductCategory) {
                $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'delete_product_category'
                        , array(':p_pc_id'            => $nProductCategory));
                
            }
            
            
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
    
    public function testAction() {
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'get_customer', array(':id' => null));
        
        foreach($oResultSet as $aRow) {
            var_dump($aRow);
        }
        exit;
    }
    
    public function getTree($aTableTree){
//        asort($aTableTree);
        $aRoot =  array();
        $aNodeStack = array(&$aRoot);
        $sBaseAndSeparator = $this->sPathSeparator;
            
        foreach($aTableTree as $sKey => $sNodePath) {
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
                $aTree[count($aTree)-1]['children'] = array();
                $aTree = &$aTree[count($aTree)-1]['children'];
                $aNodeStack[] = &$aTree;
            }

            $aTree[] = array('title' => substr($sNodePath, $nBaseAndSeparatorLength)
                             ,'key'   => $sKey);
        }
        
        return $aRoot;
    }
    
    public function getTableTree($aTree){
        $aTableTree = array();
        $aTableTreePhase1 = $this->fromTreeToTableTree($aTree);
//        sort($aTableTreePhase1);
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
}
?>