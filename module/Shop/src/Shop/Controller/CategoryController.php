<?php
namespace Shop\Controller;

class CategoryController extends \Zend\Mvc\Controller\AbstractActionController {
    
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
    
    public function newCategoryAction(){
        $aResponse = array(
            'children' => array(array('title' => "Item 1"
                                    ,'toma' => 'aa'
                                    , 'key' => '__1')
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
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveAction(){
//        if ($this->getRequest()->isXmlHttpRequest()) {
//            $sJSONDataRequest = $this->getRequest()->getContent();
//            $aRequest = (array)json_decode($sJSONDataRequest);
//            
//            
//            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
//            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_provider'
//                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null
//                            ,':p_p_provider_name'   => $aRequest['p_provider_name']
//                            ,':p_ie_id'             => array_key_exists('ie_id',$aRequest)?$aRequest['ie_id']:null
//                            ,':p_ie_legal_id'       => $aRequest['ie_legal_id']
//                            ,':p_ie_invoice_name'   => $aRequest['ie_invoice_name']));
//            
//            $aResponse = $oResultSet->current();
//            if ($oResultSet->count()==1){
//                $aResponse['success'] = ($oResultSet->count()==1)?1:0;
//                $aResponse['grid_id'] = $aResponse['p_id'];
//            }
//            else {
//                $aResponse = array('success' => 0);
//            }
//        }
//        else {
//           $aResponse = array('success' => 0);
//        }
        $aResponse = array('success' => 0);
        return new \Zend\View\Model\JsonModel($aResponse);
    }
    
    public function SaveTreeAction(){
        
        $this->getRequest()->setContent('{"title":null,"key":"_1","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"Item 1","key":"__1","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"toma":"aa"},{"title":"Item 2","key":"__2","isFolder":true,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"item 2.1","key":"__21","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false},{"title":"item 2.2","key":"__22","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":true,"select":false,"hideCheckbox":false,"unselectable":false,"children":[{"title":"item2.2.1","key":"_2","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":true,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false}]},{"title":"item 2.3","key":"__23","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false}],"toma":"bb"},{"title":"Item 3","key":"__3","isFolder":false,"isLazy":false,"tooltip":null,"href":null,"icon":null,"addClass":null,"noLink":false,"activate":false,"focus":false,"expand":false,"select":false,"hideCheckbox":false,"unselectable":false,"toma":"cc"}]}');
        $this->getRequest()->getHeaders()->addHeaderLine('X_REQUESTED_WITH','XMLHttpRequest');
       
        
        
        if ($this->getRequest()->isXmlHttpRequest()) {
            $sJSONDataRequest = $this->getRequest()->getContent();
            $aRequest = (array)json_decode($sJSONDataRequest);
            $aResponse = $aRequest;
            
            $aTableTree = $this->getTableTree($aRequest);
            var_dump($aTableTree);
            
            $aTree = $this->fromTableTreeToTree($aTableTree);
            var_dump($aTree);
            exit;
            var_dump($aConvertedTree);
            exit;
            $aResponse = $aConvertedTree;
//            var_dump($aConvertedTree);
//            
//            var_dump($aRequest);
//            $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
//            $oResultSet = $oDataFunctionGateway->getDataRecordSet('IPYME_FINAL', 'set_provider'
//                    , array( ':p_p_id'              => array_key_exists('p_id',$aRequest)?$aRequest['p_id']:null
//                            ,':p_p_provider_name'   => $aRequest['p_provider_name']
//                            ,':p_ie_id'             => array_key_exists('ie_id',$aRequest)?$aRequest['ie_id']:null
//                            ,':p_ie_legal_id'       => $aRequest['ie_legal_id']
//                            ,':p_ie_invoice_name'   => $aRequest['ie_invoice_name']));
//            
//            $aResponse = $oResultSet->current();
//            if ($oResultSet->count()==1){
//                $aResponse['success'] = ($oResultSet->count()==1)?1:0;
//                $aResponse['grid_id'] = $aResponse['p_id'];
//            }
//            else {
//                $aResponse = array('success' => 0);
//            }
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
    
    public function fromTableTreeToTree($aTableTree, $sBaseNodePath=''){
        $aNodeStack = array();
        $sSeparator = ' > ';
        $aTree = array();
        
        $aRoot = $aTree;
        $aNodeStack[0] = &$aRoot;
        $sBaseAndSeparator = $sBaseNodePath.$sSeparator;
        $nStrLen = strlen($sBaseAndSeparator);
            
        foreach($aTableTree as $sKey => $sNodePath) {
            if (strpos($sNodePath, $sBaseAndSeparator)!==0){
                $n=0;
                echo "\n --------- $sBaseAndSeparator";
                while(!empty($sBaseAndSeparator) && (strpos($sNodePath, $sBaseAndSeparator)!==0) && ($n<10)){
                    $n++;
                    
                    $sBaseAndSeparator = substr($sBaseAndSeparator, 0, strrpos($sBaseAndSeparator,$sSeparator));
                    echo "\n --------- $sBaseAndSeparator";
                }
                
                for($n--;$n>0;$n--,array_pop($aNodeStack));
                
                $sBaseAndSeparator .= $sSeparator;
                echo '77777777777';
                echo "\n - n: $n -------- $sBaseAndSeparator";
                $nStrLen = strlen($sBaseAndSeparator);
            }
            if (strpos($sNodePath, $sBaseAndSeparator)===0){
                echo 333;
                if (strlen($sNodePath) > $nStrLen){
                    if (strpos($sNodePath, $sSeparator, $nStrLen) === FALSE){
                        echo '111111';
                        echo $sBaseAndSeparator;
                        $aTree = &$aNodeStack[count($aNodeStack)-1];
                        $aTree[] = array('title' => substr($sNodePath, $nStrLen)
                                         ,'key'   => $sKey);
                        
                    }
                    else {
                        echo '222222';
                        
                        $sBaseAndSeparator = substr($sNodePath, 0, strrpos($sNodePath, $sSeparator)).$sSeparator;
                        echo $sBaseAndSeparator;
                        $nStrLen = strlen($sBaseAndSeparator);
                        $aChildren = array( 0 => array('title' => substr($sNodePath, strlen($sBaseAndSeparator))
                                                      ,'key'   => $sKey));
                        $aTree = &$aNodeStack[count($aNodeStack)-1];
                        $aTree[count($aTree)-1]['children'] = $aChildren;
                        
                        
//                        $aTree[] = &$aChildren;
                        $aNodeStack[] = &$aTree[count($aTree)-1]['children'];
                        
                        
//                        $aTree = &$aTree[count($aTree)-1]['children'];
//                        $aNodeStack[] = &$aTree[count($aTree)-1]['children'];
//                        $aTree = $aNodeStack[\count($aNodeStack)-1];
                        
//                        $aTree[count($aTree)-1]['children'] = $this->fromTableTreeToTree($aTableTree, $sBaseAndSeparator);
                    }
                }
            }
            
            echo "\nAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n$sNodePath\n";
            var_dump($aRoot);
//            var_dump($aTree);
            
            echo "\n\n ";
        }
        
        echo "\n\n\ZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        
        exit;
        return $aRoot;
    }
    
    public function getTableTree($aTree){
        $sSeparator = ' > ';
        
        $aTableTree = array();
        $aConvertedTree = $this->fromTreeToTableTree($aTree);
        $nSeparatorLength = strlen($sSeparator);
        foreach($aConvertedTree as $sNode) {
            $nKeySeparator = strrpos($sNode, $sSeparator);
            $sKey       = substr($sNode, $nKeySeparator+$nSeparatorLength);
            $sNodePath  = substr($sNode, 0, $nKeySeparator);
            $aTableTree[$sKey] = $sNodePath;
        }
        
        return $aTableTree;
    }
    
    public function fromTreeToTableTree($aTree){
        if (is_array($aTree)) {
            $sTitle = $aTree['title'];
            $aChildren = array_key_exists('children', $aTree) ? $aTree['children']:array();
            $sKey = $aTree['key'];
        }
        else {
            $sTitle = $aTree->title;
            $aChildren = isset($aTree->children)?$aTree->children:array();
            $sKey = $aTree->key;
        }
        
        $aTableTree = array();
        if (!empty($aChildren)){
            if (!is_null($sTitle)) $aTableTree[] = $sTitle. ' > '.$sKey;
            foreach($aChildren as $child){
                $aSub = $this->fromTreeToTableTree($child);
                
                foreach($aSub as $sub){
                    $aTableTree[] = $sTitle. ' > '. $sub;
                }
            }
        }
        else {
            $aTableTree = array($sTitle. ' > '.$sKey);
        }
        
        return $aTableTree;
    }
}
?>